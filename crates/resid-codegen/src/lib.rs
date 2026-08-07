//! LLVM code generation for Resid (numeric core).
//!
//! Lowers a parsed + type-checked AST to LLVM IR: functions, immutable
//! bindings, calls, integer/float arithmetic with spec mixed-width widening,
//! casts, comparisons, logical connectives, and statement-level `if`.

use std::collections::HashMap;
use std::num::NonZeroU32;

use inkwell::builder::Builder;
use inkwell::context::Context;
use inkwell::module::Module;
use inkwell::types::{BasicMetadataTypeEnum, BasicTypeEnum, FloatType, FunctionType, IntType};
use inkwell::values::{
    BasicMetadataValueEnum, BasicValueEnum, FloatValue, FunctionValue, IntValue, PointerValue,
};
use inkwell::{AddressSpace, FloatPredicate, IntPredicate};

use resid_ir::{BinOp, NumericType, numeric_result_type};
use resid_lexer::token::Literal;
use resid_lexer::token::Op as OpKind;
use resid_parser::{Block, Declaration, Expr, ExprKind, Id, StmtKind, TranslationUnit};
use resid_type::{FunctionSig, SemType};

/// A lowered value plus the semantic type the checker attributed to it.
pub struct Val<'ctx> {
    pub v: BasicValueEnum<'ctx>,
    pub ty: SemType,
}

/// Per-function local scope: symbol → (alloca address, type).
struct Scope<'ctx> {
    vars: HashMap<String, (PointerValue<'ctx>, SemType)>,
}

impl<'ctx> Scope<'ctx> {
    fn new() -> Self {
        Scope {
            vars: HashMap::new(),
        }
    }
}

/// The LLVM code generator.
pub struct CodeGen<'ctx> {
    pub cx: &'ctx Context,
    pub module: Module<'ctx>,
    builder: Builder<'ctx>,
    pub sigs: HashMap<String, FunctionSig>,
    /// The function currently being lowered (used to place branch blocks).
    cur_fn: Option<FunctionValue<'ctx>>,
    /// Return type of the current function (single-block body).
    cur_ret: Option<SemType>,
}

impl<'ctx> CodeGen<'ctx> {
    pub fn new(cx: &'ctx Context, name: &str) -> Self {
        let module = cx.create_module(name);
        let builder = cx.create_builder();
        CodeGen {
            cx,
            module,
            builder,
            sigs: HashMap::new(),
            cur_fn: None,
            cur_ret: None,
        }
    }

    /// Generate a module for the whole translation unit.
    pub fn generate(&mut self, unit: &TranslationUnit) -> Result<(), String> {
        self.sigs = resid_type::collect_signatures(unit);
        let names: Vec<String> = unit
            .declarations
            .iter()
            .filter_map(|d| match d {
                Declaration::Function(f) => Some(f.name.0.clone()),
                _ => None,
            })
            .collect();
        for name in &names {
            let fv = self.declare_function(name, unit)?;
            self.cur_fn = Some(fv);
            self.lower_function(&name, unit, fv)?;
        }
        self.cur_fn = None;
        Ok(())
    }

    // ─── Types ───────────────────────────────────────────────────

    fn int_type(&self, bits: u16) -> Result<IntType<'ctx>, String> {
        match bits {
            8 => Ok(self.cx.i8_type()),
            16 => Ok(self.cx.i16_type()),
            32 => Ok(self.cx.i32_type()),
            64 => Ok(self.cx.i64_type()),
            _ => self.cx
                .custom_width_int_type(NonZeroU32::new(bits as u32).unwrap())
                .map_err(|e| format!("codegen: int width {bits}: {e}")),
        }
    }

    fn float_type(&self, bits: u16) -> Result<FloatType<'ctx>, String> {
        match bits {
            16 => Ok(self.cx.f16_type()),
            32 => Ok(self.cx.f32_type()),
            64 => Ok(self.cx.f64_type()),
            _ => Err(format!("codegen: float width {bits} not yet supported in LLVM")),
        }
    }

    fn llvm_type(&self, t: &SemType) -> Result<BasicTypeEnum<'ctx>, String> {
        let bt: BasicTypeEnum<'ctx> = match t {
            SemType::Bool => self.cx.bool_type().into(),
            SemType::Str => self.cx.ptr_type(AddressSpace::default()).into(),
            SemType::Numeric(n) => match n {
                Numeric::Int(w) | Numeric::UInt(w) => self.int_type(w.bits())?.into(),
                Numeric::Float(w) => self.float_type(w.bits())?.into(),
                Numeric::ISize | Numeric::USize => self.int_type(64)?.into(),
            },
        };
        Ok(bt)
    }

    // ─── Functions ───────────────────────────────────────────────

    fn declare_function(
        &self,
        name: &str,
        unit: &TranslationUnit,
    ) -> Result<FunctionValue<'ctx>, String> {
        let f = self.find_func(unit, name).ok_or("internal: function not found")?;
        let params: Vec<SemType> = f
            .params
            .iter()
            .map(|p| resid_type::resolve_type(&p.type_).unwrap_or(SemType::Bool))
            .collect();
        let ret = resid_type::resolve_type(&f.ret).unwrap_or(SemType::Bool);
        let ret_ll = self.llvm_type(&ret)?;
        let param_ll: Vec<BasicTypeEnum<'ctx>> = params
            .iter()
            .map(|t| self.llvm_type(t).unwrap())
            .collect();
        let param_meta: Vec<BasicMetadataTypeEnum<'ctx>> =
            param_ll.iter().map(|t| (*t).into()).collect();
        let ft = make_fn_type(ret_ll, &param_meta);
        Ok(self.module.add_function(&f.name.0, ft, None))
    }

    fn find_func<'a>(&self, unit: &'a TranslationUnit, name: &str) -> Option<&'a resid_parser::FuncDef> {
        unit.declarations.iter().find_map(|d| match d {
            Declaration::Function(f) if f.name.0 == name => Some(f),
            _ => None,
        })
    }

    fn lower_function(
        &mut self,
        name: &str,
        unit: &TranslationUnit,
        fv: FunctionValue<'ctx>,
    ) -> Result<(), String> {
        let f = self.find_func(unit, name).ok_or("?")?;
        let enter_ret = resid_type::resolve_type(&f.ret).unwrap_or(SemType::Bool);
        self.cur_ret = Some(enter_ret.clone());
        let entry = self.cx.append_basic_block(fv, "entry");
        self.builder.position_at_end(entry);

        let mut sc = Scope::new();
        for (i, p) in f.params.iter().enumerate() {
            let ty = resid_type::resolve_type(&p.type_).unwrap_or(SemType::Bool);
            let ll = self.llvm_type(&ty)?;
            let ptr = self.builder.build_alloca(ll, &p.name.0).map_err(to_err)?;
            let arg = fv.get_nth_param(i as u32).ok_or("missing param")?;
            self.builder.build_store(ptr, arg).map_err(to_err)?;
            sc.vars.insert(p.name.0.clone(), (ptr, ty));
        }

        let terminated = self.lower_block(&mut sc, &f.body)?;
        if !terminated {
            match &f.body.ret {
                Some(ret_expr) => {
                    let v = self.lower_expr(&mut sc, ret_expr, None)?;
                    let v = self.cast_val(v, &self.cur_ret.clone().unwrap_or(SemType::Bool))?;
                    self.builder.build_return(Some(&v.v)).map_err(to_err)?;
                }
                None => {
                    let ret_ty = enter_ret;
                    match ret_ty {
                        SemType::Numeric(_) => {
                            let it = self.llvm_type(&ret_ty)?;
                            let zero = match it {
                                inkwell::types::BasicTypeEnum::IntType(i) => i.const_zero(),
                                _ => self.cx.bool_type().const_zero(),
                            };
                            self.builder
                                .build_return(Some(&zero))
                                .map_err(to_err)?;
                        }
                        SemType::Bool => {
                            self.builder
                                .build_return(Some(&self.cx.bool_type().const_zero()))
                                .map_err(to_err)?;
                        }
                        SemType::Str => {
                            self.builder
                                .build_return(Some(&self.cx.ptr_type(AddressSpace::default()).const_null()))
                                .map_err(to_err)?;
                        }
                    }
                }
            }
        }
        Ok(())
    }

    // ─── Statements ──────────────────────────────────────────────

    /// Lower a block. Returns true if it ends with a terminator (return).
    fn lower_block(&mut self, sc: &mut Scope<'ctx>, block: &Block) -> Result<bool, String> {
        let mut terminated = false;
        for stmt in &block.statements {
            if terminated {
                break;
            }
            match &stmt.kind {
                StmtKind::Bind { type_, name, value } => {
                    let ty = match type_ {
                        Some(t) => resid_type::resolve_type(t).unwrap_or(SemType::Bool),
                        None => resid_type::infer_expr(
                            value,
                            &self.env(sc),
                            &self.sigs,
                        )
                        .unwrap_or(SemType::Bool),
                    };
                    let ll = self.llvm_type(&ty)?;
                    let ptr = self.builder.build_alloca(ll, &name.0).map_err(to_err)?;
                    let target = match &ty {
                        SemType::Numeric(n) => Some(*n),
                        _ => None,
                    };
                    let v = self.lower_expr(sc, value, target)?;
                    let v = self.cast_val(v, &ty)?;
                    self.builder.build_store(ptr, v.v).map_err(to_err)?;
                    sc.vars.insert(name.0.clone(), (ptr, ty));
                }
                StmtKind::Expr(e) | StmtKind::Discard(e) => {
                    self.lower_expr(sc, e, None)?;
                }
                StmtKind::Return(v) => {
                    match v {
                        Some(e) => {
                            let raw = self.lower_expr(sc, e, None)?;
                            let val =
                                self.cast_val(raw, &self.cur_ret.clone().unwrap_or(SemType::Bool))?;
                            self.builder.build_return(Some(&val.v)).map_err(to_err)?;
                        }
                        None => {
                            self.builder.build_return(None).map_err(to_err)?;
                        }
                    }
                    terminated = true;
                }
                StmtKind::Break | StmtKind::Continue | StmtKind::Destructure { .. } => {}
            }
        }
        Ok(terminated)
    }

    /// Build a `resid-type` environment mirroring the current LLVM scope so
    /// untyped bindings and operands can be inferred to widths.
    fn env(&self, sc: &Scope<'ctx>) -> resid_type::Env {
        let mut e = resid_type::Env::new();
        for (k, (_, ty)) in &sc.vars {
            e.insert(k, ty.clone());
        }
        e
    }

    // ─── Expressions ─────────────────────────────────────────────

    fn lower_expr(
        &mut self,
        sc: &mut Scope<'ctx>,
        e: &Expr,
        target: Option<Numeric>,
    ) -> Result<Val<'ctx>, String> {
        match &e.kind {
            ExprKind::Literal(lit) => self.lower_literal(lit, target),

            ExprKind::Id(id) => {
                let (ptr, ty) = sc
                    .vars
                    .get(&id.0)
                    .ok_or_else(|| format!("codegen: undefined variable `{}`", id.0))?;
                let pointee_ty = self.llvm_type(&ty)?;
                let v = self
                    .builder
                    .build_load(pointee_ty, *ptr, &id.0)
                    .map_err(to_err)?;
                Ok(Val { v, ty: ty.clone() })
            }

            ExprKind::Cast { type_, operand } => {
                let to = resid_type::resolve_type(type_).ok_or("codegen: unknown cast type")?;
                let raw = self.lower_expr(sc, operand, None)?;
                self.cast_val(raw, &to)
            }

            ExprKind::UnaryOp { op, operand } => {
                let raw = self.lower_expr(sc, operand, None)?;
                self.lower_unary(op, raw)
            }

            ExprKind::BinaryOp { op, lhs, rhs } => {
                self.lower_binary(sc, op, lhs, rhs)
            }

            ExprKind::Call { func, args } => self.lower_call(sc, func, args),

            ExprKind::Rt(inner) | ExprKind::AtResidual { inner, .. } => {
                self.lower_expr(sc, inner, target)
            }

            other => Err(format!(
                "codegen: `{}` not yet supported",
                resid_type::kind_tag(other)
            )),
        }
    }

    fn lower_literal(
        &mut self,
        lit: &Literal,
        target: Option<Numeric>,
    ) -> Result<Val<'ctx>, String> {
        match lit {
            Literal::Int { value, .. } => {
                if let Some(Numeric::Float(fw)) = target {
                    let ft = self.float_type(fw.bits() as u16)?; // cfg
                    let c = self.cx.f64_type().const_float(*value as f64);
                    let v = if fw.bits() == 64 {
                        c
                    } else {
                        self.builder
                            .build_float_cast(c, ft, "lit")
                            .map_err(to_err)?
                    };
                    return Ok(Val {
                        v: v.into(),
                        ty: SemType::Numeric(Numeric::Float(fw)),
                    });
                }
                let width = target
                    .filter(|n| !n.is_float())
                    .and_then(|n| n.target_width())
                    .unwrap_or(64);
                let unsigned = matches!(target, Some(Numeric::UInt(_)));
                let it = self.int_type(width)?;
                let v = it.const_int(*value as u64, false);
                let ty = if unsigned {
                    SemType::Numeric(Numeric::UInt(IntWidth::from_bits(width).unwrap()))
                } else {
                    SemType::Numeric(Numeric::Int(IntWidth::from_bits(width).unwrap()))
                };
                Ok(Val { v: v.into(), ty })
            }

            Literal::Float(fl) => {
                let ft = self.cx.f64_type();
                let value: f64 = fl
                    .value
                    .parse()
                    .map_err(|_| format!("codegen: bad float literal `{}`", fl.value))?;
                let v = ft.const_float(value);
                Ok(Val {
                    v: v.into(),
                    ty: SemType::Numeric(Numeric::Float(FloatWidth::from_bits(64).unwrap())),
                })
            }

            Literal::Bool(b) => {
                let v = self.cx.bool_type().const_int(*b as u64, false);
                Ok(Val { v: v.into(), ty: SemType::Bool })
            }

            _ => Err(format!("codegen: literal `{lit}` not supported yet")),
        }
    }

    fn lower_unary(&mut self, op: &OpKind, raw: Val<'ctx>) -> Result<Val<'ctx>, String> {
        match op {
            OpKind::Plus => Ok(raw),
            OpKind::Minus => {
                let v = match raw.v {
                    BasicValueEnum::IntValue(i) => self.builder.build_int_neg(i, "neg").map_err(to_err)?.into(),
                    BasicValueEnum::FloatValue(f) => self.builder.build_float_neg(f, "fneg").map_err(to_err)?.into(),
                    _ => return Err("codegen: unary minus needs numeric".into()),
                };
                Ok(Val { v, ty: raw.ty })
            }
            OpKind::Not => {
                let i = raw.v.into_int_value();
                let v = self.builder.build_not(i, "not").map_err(to_err)?;
                Ok(Val { v: v.into(), ty: SemType::Bool })
            }
            OpKind::Tilde => {
                let i = raw.v.into_int_value();
                let v = self.builder.build_not(i, "bvnot").map_err(to_err)?;
                Ok(Val { v: v.into(), ty: raw.ty })
            }
            _ => Err(format!("codegen: unary {op:?} unsupported")),
        }
    }

    fn lower_binary(
        &mut self,
        sc: &mut Scope<'ctx>,
        op: &OpKind,
        lhs: &Expr,
        rhs: &Expr,
    ) -> Result<Val<'ctx>, String> {
        // Logical connectives on Bools.
        if matches!(op, OpKind::AndAnd | OpKind::OrOr) {
            let l = self.lower_expr(sc, lhs, None)?;
            let r = self.lower_expr(sc, rhs, None)?;
            let li = l.v.into_int_value();
            let ri = r.v.into_int_value();
            let v = if matches!(op, OpKind::AndAnd) {
                self.builder.build_and(li, ri, "land").map_err(to_err)?
            } else {
                self.builder.build_or(li, ri, "lor").map_err(to_err)?
            };
            return Ok(Val { v: v.into(), ty: SemType::Bool });
        }

        let binop = resid_type::to_bin_op(op)
            .ok_or_else(|| format!("codegen: unsupported operator {op:?}"))?;

        let l = self.lower_expr(sc, lhs, None)?;
        let r = self.lower_expr(sc, rhs, None)?;
        let lt = as_numeric(&l.ty, &l)?;
        let rt = as_numeric(&r.ty, &r)?;

        // Comparisons produce a Bool and use their own lowering.
        if matches!(
            binop,
            BinOp::Eq | BinOp::Ne | BinOp::Lt | BinOp::Le | BinOp::Gt | BinOp::Ge
        ) {
            return self.write_cmp(binop, l, r, lt, rt);
        }

        let res = match numeric_result_type(&lt, binop, &rt) {
            resid_ir::ResultType::Numeric(n) => n,
            resid_ir::ResultType::Bool => {
                return Err("codegen: unexpected bool result".into());
            }
            resid_ir::ResultType::Error(_) => {
                return Err("codegen: signed/unsigned mix".into());
            }
        };
        let ln = self.widen(l, res)?;
        let rn = self.widen(r, res)?;
        let v = self.apply_binop(binop, ln, rn, res)?;
        Ok(Val { v, ty: SemType::Numeric(res) })
    }

    fn widen(
        &mut self,
        v: Val<'ctx>,
        res: Numeric,
    ) -> Result<BasicValueEnum<'ctx>, String> {
        let src = match &v.ty {
            SemType::Numeric(n) => *n,
            _ => return Err("codegen: numeric required".into()),
        };
        let w = res.target_width().unwrap_or(64);
        if res.is_float() {
            let ft = self.float_type(w)?;
            let f = v.v.into_float_value();
            if f.get_type().get_bit_width() == w as u32 {
                return Ok(f.into());
            }
            return Ok(self.builder.build_float_cast(f, ft, "wid").map_err(to_err)?.into());
        }
        let it = self.int_type(w)?;
        let srcbits = src.target_width().unwrap_or(64);
        let signed = src.is_signed();
        let i = v.v.into_int_value();
        if srcbits == w {
            return Ok(i.into());
        }
        if srcbits < w {
            let ext = if signed {
                self.builder.build_int_s_extend(i, it, "sext")
            } else {
                self.builder.build_int_z_extend(i, it, "zext")
            };
            return Ok(ext.map_err(to_err)?.into());
        }
        Ok(self.builder.build_int_truncate(i, it, "trunc").map_err(to_err)?.into())
    }

    fn apply_binop(
        &mut self,
        binop: BinOp,
        l: BasicValueEnum<'ctx>,
        r: BasicValueEnum<'ctx>,
        res: Numeric,
    ) -> Result<BasicValueEnum<'ctx>, String> {
        if res.is_float() {
            let lf = l.into_float_value();
            let rf = r.into_float_value();
            let v = match binop {
                BinOp::Add => self.builder.build_float_add(lf, rf, "fadd"),
                BinOp::Sub => self.builder.build_float_sub(lf, rf, "fsub"),
                BinOp::Mul => self.builder.build_float_mul(lf, rf, "fmul"),
                BinOp::Div => self.builder.build_float_div(lf, rf, "fdiv"),
                BinOp::Rem => self.builder.build_float_rem(lf, rf, "frem"),
                _ => return Err("codegen: unsupported float op".into()),
            };
            return Ok(v.map_err(to_err)?.into());
        }
        let li = l.into_int_value();
        let ri = r.into_int_value();
        let signed = res.is_signed();
        let v = match binop {
            BinOp::Add => self.builder.build_int_add(li, ri, "add"),
            BinOp::Sub => self.builder.build_int_sub(li, ri, "sub"),
            BinOp::Mul => self.builder.build_int_mul(li, ri, "mul"),
            BinOp::Div => {
                if signed {
                    self.builder.build_int_signed_div(li, ri, "sdiv")
                } else {
                    self.builder.build_int_unsigned_div(li, ri, "udiv")
                }
            }
            BinOp::Rem => {
                if signed {
                    self.builder.build_int_signed_rem(li, ri, "srem")
                } else {
                    self.builder.build_int_unsigned_rem(li, ri, "urem")
                }
            }
            BinOp::ShiftLeft => self.builder.build_left_shift(li, ri, "shl"),
            BinOp::ShiftRight => self.builder.build_right_shift(li, ri, signed, "shr"),
            BinOp::And => self.builder.build_and(li, ri, "and"),
            BinOp::Or => self.builder.build_or(li, ri, "or"),
            BinOp::Xor => self.builder.build_xor(li, ri, "xor"),
            _ => return Err("codegen: unsupported binary op".into()),
        };
        Ok(v.map_err(to_err)?.into())
    }

    fn write_cmp(
        &mut self,
        binop: BinOp,
        l: Val<'ctx>,
        r: Val<'ctx>,
        lt: Numeric,
        rt: Numeric,
    ) -> Result<Val<'ctx>, String> {
        if lt.is_float() || rt.is_float() {
            let w = lt.target_width().unwrap_or(64).max(rt.target_width().unwrap_or(64));
            let ft = self.float_type(w)?;
            let lf = to_float(l)?;
            let rf = to_float(r)?;
            let lf = self.builder.build_float_cast(lf, ft, "fc").map_err(to_err)?;
            let rf = self.builder.build_float_cast(rf, ft, "fc").map_err(to_err)?;
            let pred = match binop {
                BinOp::Eq => FloatPredicate::OEQ,
                BinOp::Ne => FloatPredicate::ONE,
                BinOp::Lt => FloatPredicate::OLT,
                BinOp::Le => FloatPredicate::OLE,
                BinOp::Gt => FloatPredicate::OGT,
                BinOp::Ge => FloatPredicate::OGE,
                _ => unreachable!(),
            };
            let i = self.builder.build_float_compare(pred, lf, rf, "fcmp").map_err(to_err)?;
            return Ok(Val { v: i.into(), ty: SemType::Bool });
        }
        let w = lt.target_width().unwrap_or(64).max(rt.target_width().unwrap_or(64));
        let signed = lt.is_signed() && rt.is_signed();
        let li = self.to_int(l, w)?;
        let ri = self.to_int(r, w)?;
        let pred = int_pred(binop, signed);
        let i = self.builder.build_int_compare(pred, li, ri, "icmp").map_err(to_err)?;
        Ok(Val { v: i.into(), ty: SemType::Bool })
    }

    fn to_int(&mut self, v: Val<'ctx>, w: u16) -> Result<IntValue<'ctx>, String> {
        let src = match &v.ty {
            SemType::Numeric(n) => *n,
            _ => return Err("codegen: int compare".into()),
        };
        let it = self.int_type(w)?;
        let srcbits = src.target_width().unwrap_or(64);
        let i = v.v.into_int_value();
        if srcbits == w {
            return Ok(i);
        }
        if srcbits < w {
            let signed = src.is_signed();
            let ext = if signed {
                self.builder.build_int_s_extend(i, it, "sext")
            } else {
                self.builder.build_int_z_extend(i, it, "zext")
            };
            return ext.map_err(to_err);
        }
        self.builder.build_int_truncate(i, it, "trunc").map_err(to_err)
    }

    fn cast_val(&mut self, raw: Val<'ctx>, to: &SemType) -> Result<Val<'ctx>, String> {
        let to_ll = self.llvm_type(to)?;
        let v = match (raw.v, to_ll) {
            (BasicValueEnum::IntValue(i), BasicTypeEnum::IntType(t)) => {
                let (a, b) = (i.get_type().get_bit_width(), t.get_bit_width());
                if a == b {
                    BasicValueEnum::IntValue(i)
                } else if a > b {
                    self.builder.build_int_truncate(i, t, "cast").map_err(to_err)?.into()
                } else {
                    let signed = matches!(&raw.ty, SemType::Numeric(n) if n.is_signed());
                    if signed {
                        self.builder.build_int_s_extend(i, t, "cast").map_err(to_err)?.into()
                    } else {
                        self.builder.build_int_z_extend(i, t, "cast").map_err(to_err)?.into()
                    }
                }
            }
            (BasicValueEnum::FloatValue(f), BasicTypeEnum::FloatType(t)) => {
                self.builder.build_float_cast(f, t, "cast").map_err(to_err)?.into()
            }
            (BasicValueEnum::IntValue(i), BasicTypeEnum::FloatType(t)) => {
                let signed = matches!(&raw.ty, SemType::Numeric(n) if n.is_signed());
                let v = if signed {
                    self.builder.build_signed_int_to_float(i, t, "cast")
                } else {
                    self.builder.build_unsigned_int_to_float(i, t, "cast")
                };
                v.map_err(to_err)?.into()
            }
            (BasicValueEnum::FloatValue(f), BasicTypeEnum::IntType(t)) => {
                let signed = matches!(to, SemType::Numeric(n) if n.is_signed());
                let v = if signed {
                    self.builder.build_float_to_signed_int(f, t, "cast")
                } else {
                    self.builder.build_float_to_unsigned_int(f, t, "cast")
                };
                v.map_err(to_err)?.into()
            }
            _ => return Err(format!("codegen: cannot cast {} to {to}", raw.ty)),
        };
        Ok(Val { v, ty: to.clone() })
    }

    // ─── Calls ───────────────────────────────────────────────────

    fn lower_call(
        &mut self,
        sc: &mut Scope<'ctx>,
        func: &Expr,
        args: &[(Option<Id>, Expr)],
    ) -> Result<Val<'ctx>, String> {
        let name = match &func.kind {
            ExprKind::Id(id) => &id.0,
            _ => return Err("codegen: only direct calls supported".into()),
        };
        let fnv = self
            .module
            .get_function(name)
            .ok_or_else(|| format!("codegen: no such function `{name}`"))?;
        let sig = self.sigs.get(name).cloned().unwrap_or(FunctionSig {
            name: name.clone(),
            params: Vec::new(),
            ret: SemType::Bool,
        });
        let mut llargs: Vec<BasicMetadataValueEnum<'ctx>> = Vec::new();
        for (i, (_, a)) in args.iter().enumerate() {
            let want = sig.params.get(i).and_then(|t| match t {
                SemType::Numeric(n) => Some(*n),
                _ => None,
            });
            let av = self.lower_expr(sc, a, want)?;
            llargs.push(av.v.into());
        }
        let cs = self.builder.build_call(fnv, &llargs, "call").map_err(to_err)?;
        let v = cs.try_as_basic_value().expect_basic("call of void function");
        Ok(Val {
            v,
            ty: sig.ret.clone(),
        })
    }
}

fn to_err(e: inkwell::builder::BuilderError) -> String {
    format!("llvm: {e:?}")
}

/// Build a function type from a return type and parameter types.
fn make_fn_type<'ctx>(
    ret: BasicTypeEnum<'ctx>,
    params: &[BasicMetadataTypeEnum<'ctx>],
) -> FunctionType<'ctx> {
    match ret {
        BasicTypeEnum::IntType(i) => i.fn_type(params, false),
        BasicTypeEnum::FloatType(f) => f.fn_type(params, false),
        BasicTypeEnum::PointerType(p) => p.fn_type(params, false),
        BasicTypeEnum::ArrayType(a) => a.fn_type(params, false),
        _ => unreachable!("unsupported return type in make_fn_type"),
    }
}

fn as_numeric<'ctx>(t: &SemType, _v: &Val<'ctx>) -> Result<Numeric, String> {
    match t {
        SemType::Numeric(n) => Ok(*n),
        other => Err(format!("codegen: numeric op needs numbers, got {other}")),
    }
}

fn to_float(v: Val<'_>) -> Result<FloatValue<'_>, String> {
    match v.v {
        BasicValueEnum::FloatValue(f) => Ok(f),
        _ => Err("codegen: expected float".into()),
    }
}

fn int_pred(binop: BinOp, signed: bool) -> IntPredicate {
    use BinOp::*;
    use IntPredicate::*;
    match (binop, signed) {
        (Eq, _) => EQ,
        (Ne, _) => NE,
        (Lt, true) => SLT,
        (Le, true) => SLE,
        (Gt, true) => SGT,
        (Ge, true) => SGE,
        (Lt, false) => ULT,
        (Le, false) => ULE,
        (Gt, false) => UGT,
        (Ge, false) => UGE,
        _ => EQ,
    }
}

// Re-export the numeric primitive types for convenience.
pub use resid_ir::{FloatWidth, IntWidth};

/// Shorthand for the IR primitive type shared across this module.
type Numeric = NumericType;
#[cfg(test)]
mod tests;

