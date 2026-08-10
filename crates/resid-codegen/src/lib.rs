//! LLVM code generation for Resid (numeric core).
//!
//! Lowers a parsed + type-checked AST to LLVM IR: functions, immutable
//! bindings, calls, integer/float arithmetic with spec mixed-width widening,
//! casts, comparisons, logical connectives, and statement-level `if`.

use std::collections::HashMap;
use std::num::NonZeroU32;

use inkwell::builder::Builder;
use inkwell::basic_block::BasicBlock;
use inkwell::context::Context;
use inkwell::module::Module;
use inkwell::types::{BasicMetadataTypeEnum, BasicTypeEnum, FloatType, FunctionType, IntType};
use inkwell::values::{
    BasicMetadataValueEnum, BasicValue, BasicValueEnum, FloatValue, FunctionValue, IntValue,
    PointerValue,
};
use inkwell::{AddressSpace, FloatPredicate, IntPredicate};

use resid_ir::{BinOp, NumericType, numeric_result_type};
use resid_lexer::token::Literal;
use resid_lexer::token::Op as OpKind;
use resid_parser::{Block, Declaration, Expr, ExprKind, Id, RangeExpr, StmtKind, TranslationUnit};
use resid_type::{best_overload, FunctionSig, SemType, Types};

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
    /// The user-declared named types (for resolving `Type::Base` references and
    /// variant/struct layout).
    types: Types,
    /// The function currently being lowered (used to place branch blocks).
    cur_fn: Option<FunctionValue<'ctx>>,
    /// Return type of the current function (single-block body).
    cur_ret: Option<SemType>,
    /// In-flight loop targets: innermost `(continue_bb, break_bb)`.
    loops: Vec<(BasicBlock<'ctx>, BasicBlock<'ctx>)>,
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
            types: Types::new(),
            cur_fn: None,
            cur_ret: None,
            loops: Vec::new(),
        }
    }

    /// Generate a module for the whole translation unit.
    pub fn generate(&mut self, unit: &TranslationUnit) -> Result<(), String> {
        self.sigs = resid_type::collect_signatures(unit);
        self.types = resid_type::collect_types(unit);
        self.declare_runtime();
        // Declare extern symbols for every signature without a definition here
        // (built-ins like `println`, and - later - the stdlib).
        for (name, sig) in &self.sigs {
            if !unit
                .declarations
                .iter()
                .any(|d| matches!(d, Declaration::Function(f) if f.name.0 == *name))
            {
                self.declare_extern(name, sig)?;
            }
        }
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
            _ => self
                .cx
                .custom_width_int_type(NonZeroU32::new(bits as u32).unwrap())
                .map_err(|e| format!("codegen: int width {bits}: {e}")),
        }
    }

    fn float_type(&self, bits: u16) -> Result<FloatType<'ctx>, String> {
        match bits {
            16 => Ok(self.cx.f16_type()),
            32 => Ok(self.cx.f32_type()),
            64 => Ok(self.cx.f64_type()),
            _ => Err(format!(
                "codegen: float width {bits} not yet supported in LLVM"
            )),
        }
    }

    fn llvm_type(&self, t: &SemType) -> Result<BasicTypeEnum<'ctx>, String> {
        let bt: BasicTypeEnum<'ctx> = match t {
            SemType::Bool => self.cx.bool_type().into(),
            SemType::Str | SemType::Bytes => self.cx.ptr_type(AddressSpace::default()).into(),
            SemType::Numeric(n) => match n {
                NumericType::Int(w) | NumericType::UInt(w) => self.int_type(w.bits())?.into(),
                NumericType::Float(w) => self.float_type(w.bits())?.into(),
                NumericType::ISize | NumericType::USize => self.int_type(64)?.into(),
            },
            SemType::Range(_) => self.int_type(64)?.into(),
            // Composites are untyped heap pointers.
            SemType::List(_) | SemType::Slice(_) | SemType::Struct { .. } | SemType::Sum { .. } | SemType::Ptr | SemType::SourceLoc => {
                self.cx.ptr_type(AddressSpace::default()).into()
            }
        };
        Ok(bt)
    }

    // ─── Functions ───────────────────────────────────────────────

    fn declare_function(
        &self,
        name: &str,
        unit: &TranslationUnit,
    ) -> Result<FunctionValue<'ctx>, String> {
        let f = self
            .find_func(unit, name)
            .ok_or("internal: function not found")?;
        let params: Vec<SemType> = f
            .params
            .iter()
            .map(|p| resid_type::resolve_type_ctx(&p.type_, &self.types).unwrap_or(SemType::Bool))
            .collect();
        let ret = resid_type::resolve_type_ctx(&f.ret, &self.types).unwrap_or(SemType::Bool);
        let ret_ll = self.llvm_type(&ret)?;
        let param_ll: Vec<BasicTypeEnum<'ctx>> =
            params.iter().map(|t| self.llvm_type(t).unwrap()).collect();
        let param_meta: Vec<BasicMetadataTypeEnum<'ctx>> =
            param_ll.iter().map(|t| (*t).into()).collect();
        let ft = make_fn_type(ret_ll, &param_meta);
        Ok(self.module.add_function(&f.name.0, ft, None))
    }

    /// Declare an external (runtime-provided) function.
    /// Note: C ABI uses i8 for bool parameters (not i1).
    fn declare_extern(&self, name: &str, sig: &FunctionSig) -> Result<(), String> {
        if self.module.get_function(name).is_some() {
            return Ok(());
        }
        let ret_ll = self.llvm_type(&sig.ret)?;
        let param_ll: Result<Vec<BasicTypeEnum<'ctx>>, String> = sig
            .params
            .iter()
            .map(|t| self.param_type(t))
            .collect();
        let param_ll = param_ll?;
        let param_meta: Vec<BasicMetadataTypeEnum<'ctx>> =
            param_ll.iter().map(|t| (*t).into()).collect();
        let ft = make_fn_type(ret_ll, &param_meta);
        self.module.add_function(name, ft, None);
        Ok(())
    }

    /// LLVM type for a function parameter — matches the C ABI.
    /// Bool parameters are i8 (C `int8_t`), everything else matches llvm_type.
    fn param_type(&self, t: &SemType) -> Result<BasicTypeEnum<'ctx>, String> {
        match t {
            SemType::Bool => Ok(self.cx.i8_type().into()),
            _ => self.llvm_type(t),
        }
    }

    /// A string constant: canonicalize into a global `[N x i8]` and return a
    /// pointer to its first byte.
    fn lower_str(&mut self, s: &str) -> PointerValue<'ctx> {
        let bytes: Vec<u8> = s.bytes().chain(std::iter::once(0)).collect();
        let elems: Vec<inkwell::values::IntValue<'ctx>> = bytes
            .iter()
            .map(|b| self.cx.i8_type().const_int(*b as u64, false))
            .collect();
        let arr = self.cx.i8_type().const_array(&elems);
        let arr_ty = arr.get_type();
        let gv = self
            .module
            .add_global(arr_ty, Some(AddressSpace::default()), "str");
        gv.set_initializer(&arr);
        gv.set_constant(true);
        gv.set_unnamed_addr(true);
        let zero = self.cx.i32_type().const_zero();
        let ptr = gv.as_pointer_value();
        unsafe {
            self.builder
                .build_in_bounds_gep(arr_ty, ptr, &[zero, zero], "str")
                .map_err(to_err)
                .unwrap()
        }
    }

    /// A byte array constant (`b"..."`): a global `[N x i8]` with the raw
    /// bytes (no NUL terminator), returning a pointer to its first byte.
    fn lower_bytes(&mut self, bytes: &[u8]) -> PointerValue<'ctx> {
        let elems: Vec<inkwell::values::IntValue<'ctx>> = bytes
            .iter()
            .map(|b| self.cx.i8_type().const_int(*b as u64, false))
            .collect();
        let arr = self.cx.i8_type().const_array(&elems);
        let arr_ty = arr.get_type();
        let gv = self
            .module
            .add_global(arr_ty, Some(AddressSpace::default()), "bytes");
        gv.set_initializer(&arr);
        gv.set_constant(true);
        gv.set_unnamed_addr(true);
        let zero = self.cx.i32_type().const_zero();
        let ptr = gv.as_pointer_value();
        unsafe {
            self.builder
                .build_in_bounds_gep(arr_ty, ptr, &[zero, zero], "bytes")
                .map_err(to_err)
                .unwrap()
        }
    }

    fn find_func<'a>(
        &self,
        unit: &'a TranslationUnit,
        name: &str,
    ) -> Option<&'a resid_parser::FuncDef> {
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
        let enter_ret = resid_type::resolve_type_ctx(&f.ret, &self.types).unwrap_or(SemType::Bool);
        self.cur_ret = Some(enter_ret.clone());
        let entry = self.cx.append_basic_block(fv, "entry");
        self.builder.position_at_end(entry);

        let mut sc = Scope::new();
        for (i, p) in f.params.iter().enumerate() {
            let ty = resid_type::resolve_type_ctx(&p.type_, &self.types).unwrap_or(SemType::Bool);
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
                            self.builder.build_return(Some(&zero)).map_err(to_err)?;
                        }
                        SemType::Bool => {
                            self.builder
                                .build_return(Some(&self.cx.bool_type().const_zero()))
                                .map_err(to_err)?;
                        }
                        SemType::Range(_) => {
                            self.builder
                                .build_return(Some(&self.cx.i64_type().const_zero()))
                                .map_err(to_err)?;
                        }
                        SemType::Str | SemType::Bytes | SemType::List(_) | SemType::Slice(_) | SemType::Struct { .. } | SemType::Sum { .. } | SemType::Ptr | SemType::SourceLoc => {
                            self.builder
                                .build_return(Some(
                                    &self.cx.ptr_type(AddressSpace::default()).const_null(),
                                ))
                                .map_err(to_err)?;
                        }
                    }
                }
            }
        }
        Ok(())
    }

    // ─── Statements ──────────────────────────────────────────────

    /// Lower a block. Returns true if it ends with a terminator (return/break).
    fn lower_block(&mut self, sc: &mut Scope<'ctx>, block: &Block) -> Result<bool, String> {
        Ok(self.lower_block_with_tail(sc, block, false)?.0)
    }

    /// Lower a block, optionally capturing the block's tail value (from
    /// `block.ret`, or the final expression statement when there is no `ret`).
    /// Returns `(terminated, tail_value)`.
    fn lower_block_with_tail(
        &mut self,
        sc: &mut Scope<'ctx>,
        block: &Block,
        capture_tail: bool,
    ) -> Result<(bool, Option<Val<'ctx>>), String> {
        let mut terminated = false;
        let mut tail: Option<Val<'ctx>> = None;
        let last_is_tail =
            capture_tail && block.ret.is_none() && matches!(block.statements.last(), Some(s) if matches!(s.kind, StmtKind::Expr(_)));
        for (idx, stmt) in block.statements.iter().enumerate() {
            if terminated {
                break;
            }
            let is_tail = last_is_tail && idx == block.statements.len() - 1;
            match &stmt.kind {
                StmtKind::Bind { type_, name, value } => {
                    let ty = match type_ {
                        Some(t) => {
                            resid_type::resolve_type_ctx(t, &self.types).unwrap_or(SemType::Bool)
                        }
                        None => resid_type::infer_expr_ctx(
                            value,
                            &self.env(sc),
                            &self.sigs,
                            &self.types,
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
                    let v = self.lower_expr(sc, e, None)?;
                    if is_tail {
                        tail = Some(v);
                    }
                }
                StmtKind::Return(v) => {
                    match v {
                        Some(e) => {
                            let raw = self.lower_expr(sc, e, None)?;
                            let val = self
                                .cast_val(raw, &self.cur_ret.clone().unwrap_or(SemType::Bool))?;
                            self.builder.build_return(Some(&val.v)).map_err(to_err)?;
                        }
                        None => {
                            self.builder.build_return(None).map_err(to_err)?;
                        }
                    }
                    terminated = true;
                }
                StmtKind::Destructure { pattern, source } => {
                    let v = self.lower_expr(sc, source, None)?;
                    self.bind_pattern_vars(sc, pattern, v.v, &v.ty)?;
                }
                StmtKind::Break | StmtKind::Continue => {
                    if let Some(&(_, break_bb)) = self.loops.last() {
                        let target = match &stmt.kind {
                            StmtKind::Continue => self.loops.last().map(|&(c, _)| c),
                            _ => Some(break_bb),
                        };
                        if let Some(t) = target {
                            self.builder
                                .build_unconditional_branch(t)
                                .map_err(to_err)?;
                        }
                    } else {
                        return Err("codegen: break/continue outside a loop".into());
                    }
                    terminated = true;
                }
            }
        }
        if let Some(ret) = &block.ret {
            let v = self.lower_expr(sc, ret, None)?;
            if capture_tail {
                tail = Some(v);
            }
        }
        Ok((terminated, tail))
    }

    /// Lower a top-level `if` expression: condition → then/else blocks joined
    /// at a merge with a phi (mirrors `match`).
    fn lower_if(
        &mut self,
        sc: &mut Scope<'ctx>,
        cond: &Expr,
        then_block: &Block,
        else_block: &Option<Box<Block>>,
    ) -> Result<Val<'ctx>, String> {
        let fv = self
            .cur_fn
            .ok_or_else(|| "codegen: if outside a function".to_string())?;
        let cond_v = self.lower_expr(sc, cond, None)?;
        let cond_bool = self.cast_val(cond_v, &SemType::Bool)?;
        let cond = cond_bool.v.into_int_value();

        let then_bb = self.cx.append_basic_block(fv, "if_then");
        let else_bb = self.cx.append_basic_block(fv, "if_else");
        let merge_bb = self.cx.append_basic_block(fv, "if_merge");

        self.builder
            .build_conditional_branch(cond, then_bb, else_bb)
            .map_err(to_err)?;

        // Then arm.
        self.builder.position_at_end(then_bb);
        let (t_term, t_tail) = self.lower_block_with_tail(sc, then_block, true)?;
        let then_reaches = if t_term {
            None
        } else {
            self.builder
                .build_unconditional_branch(merge_bb)
                .map_err(to_err)?;
            Some(then_bb)
        };

        // Else arm (or default-zero for the missing branch).
        self.builder.position_at_end(else_bb);
        let (e_term, e_tail) = match else_block {
            Some(b) => self.lower_block_with_tail(sc, b, true)?,
            None => (false, None),
        };
        let else_reaches = if e_term {
            None
        } else {
            self.builder
                .build_unconditional_branch(merge_bb)
                .map_err(to_err)?;
            Some(else_bb)
        };

        // Join the arms with a phi.
        self.builder.position_at_end(merge_bb);
        let join_ty = t_tail
            .as_ref()
            .map(|v| v.ty.clone())
            .or_else(|| e_tail.as_ref().map(|v| v.ty.clone()))
            .unwrap_or(SemType::Bool);
        let ll = self.llvm_type(&join_ty)?;
        let t_val = t_tail.unwrap_or_else(|| self.zero_val());
        let e_val = e_tail.unwrap_or_else(|| self.zero_val());
        let tv = self.cast_val(t_val, &join_ty)?;
        let ev = self.cast_val(e_val, &join_ty)?;
        let theta = match (then_reaches, else_reaches) {
            (Some(tb), Some(eb)) => {
                let phi = self.builder.build_phi(ll, "iff").map_err(to_err)?;
                phi.add_incoming(&[(&tv.v, tb), (&ev.v, eb)]);
                phi.as_basic_value()
            }
            (Some(tb), None) => {
                let phi = self.builder.build_phi(ll, "iff").map_err(to_err)?;
                phi.add_incoming(&[(&tv.v, tb)]);
                phi.as_basic_value()
            }
            (None, Some(eb)) => {
                let phi = self.builder.build_phi(ll, "iff").map_err(to_err)?;
                phi.add_incoming(&[(&ev.v, eb)]);
                phi.as_basic_value()
            }
            (None, None) => tv.v,
        };
        Ok(Val {
            v: theta,
            ty: join_ty,
        })
    }

    /// Lower a `while` loop: cond block, body block, loop back-edge, and an
    /// exit block that `break` targets.
    fn lower_while(
        &mut self,
        sc: &mut Scope<'ctx>,
        cond: &Expr,
        body: &Block,
    ) -> Result<Val<'ctx>, String> {
        let fv = self
            .cur_fn
            .ok_or_else(|| "codegen: while outside a function".to_string())?;

        let cond_bb = self.cx.append_basic_block(fv, "while_cond");
        let body_bb = self.cx.append_basic_block(fv, "while_body");
        let exit_bb = self.cx.append_basic_block(fv, "while_exit");

        self.builder
            .build_unconditional_branch(cond_bb)
            .map_err(to_err)?;

        // Condition.
        self.builder.position_at_end(cond_bb);
        let c = self.lower_expr(sc, cond, None)?;
        let cb = self.cast_val(c, &SemType::Bool)?.v.into_int_value();
        self.builder
            .build_conditional_branch(cb, body_bb, exit_bb)
            .map_err(to_err)?;

        // Body.
        self.builder.position_at_end(body_bb);
        self.loops.push((cond_bb, exit_bb));
        let (terminated, _) = self.lower_block_with_tail(sc, body, false)?;
        self.loops.pop();
        if !terminated {
            self.builder
                .build_unconditional_branch(cond_bb)
                .map_err(to_err)?;
        }

        self.builder.position_at_end(exit_bb);
        Ok(Val {
            v: self.cx.bool_type().const_zero().into(),
            ty: SemType::Bool,
        })
    }

    /// The Boolean test for whether `obj` (of type `ty`) matches `pattern`.
    /// Tagged (variant / unit-variant) patterns compare the runtime tag; all
    /// other patterns are irrefutable and always match.
    fn pattern_match_test(
        &mut self,
        pattern: &resid_parser::Pattern,
        obj: BasicValueEnum<'ctx>,
        ty: &SemType,
    ) -> Result<inkwell::values::IntValue<'ctx>, String> {
        let idx = match &pattern.kind {
            resid_parser::PatternKind::Variant { name, .. } => ty.variant_index(&name.0),
            resid_parser::PatternKind::Bind(id) if ty.unit_variant_index(&id.0).is_some() => {
                ty.variant_index(&id.0)
            }
            _ => None,
        };
        match idx {
            Some(i) => {
                let tag = self.rt_call("resid_box_tag", vec![obj])?;
                let tag = tag.into_int_value();
                let target = self.cx.i64_type().const_int(i as u64, false);
                self.builder
                    .build_int_compare(IntPredicate::EQ, tag, target, "iflet_tag")
                    .map_err(to_err)
            }
            None => Ok(self.cx.bool_type().const_all_ones()),
        }
    }

    /// Lower `if (Pattern = value) { ... } else { ... }`: test whether the
    /// source matches the pattern; bind the pattern's variables inside the
    /// then-branch only.
    fn lower_if_let(
        &mut self,
        sc: &mut Scope<'ctx>,
        pattern: &resid_parser::Pattern,
        source: &Expr,
        then_block: &Block,
        else_block: &Option<Box<Block>>,
    ) -> Result<Val<'ctx>, String> {
        let fv = self
            .cur_fn
            .ok_or_else(|| "codegen: if-let outside a function".to_string())?;
        let sv = self.lower_expr(sc, source, None)?;
        let test = self.pattern_match_test(pattern, sv.v, &sv.ty)?;

        let then_bb = self.cx.append_basic_block(fv, "iflet_then");
        let else_bb = self.cx.append_basic_block(fv, "iflet_else");
        let merge_bb = self.cx.append_basic_block(fv, "iflet_merge");
        self.builder
            .build_conditional_branch(test, then_bb, else_bb)
            .map_err(to_err)?;

        self.builder.position_at_end(then_bb);
        self.bind_pattern_vars(sc, pattern, sv.v, &sv.ty)?;
        let (t_term, _) = self.lower_block_with_tail(sc, then_block, false)?;
        if !t_term {
            self.builder
                .build_unconditional_branch(merge_bb)
                .map_err(to_err)?;
        }

        self.builder.position_at_end(else_bb);
        match else_block {
            Some(b) => {
                let (e_term, _) = self.lower_block_with_tail(sc, b, false)?;
                if !e_term {
                    self.builder
                        .build_unconditional_branch(merge_bb)
                        .map_err(to_err)?;
                }
            }
            None => {
                self.builder
                    .build_unconditional_branch(merge_bb)
                    .map_err(to_err)?;
            }
        }

        self.builder.position_at_end(merge_bb);
        Ok(self.zero_val())
    }

    /// Lower `while (Pattern = source) { ... }`: keep matching while the
    /// source matches the pattern, binding the vars in each iteration.
    fn lower_while_let(
        &mut self,
        sc: &mut Scope<'ctx>,
        pattern: &resid_parser::Pattern,
        source: &Expr,
        body: &Block,
    ) -> Result<Val<'ctx>, String> {
        let fv = self
            .cur_fn
            .ok_or_else(|| "codegen: while-let outside a function".to_string())?;

        let cond_bb = self.cx.append_basic_block(fv, "while_cond");
        let body_bb = self.cx.append_basic_block(fv, "while_body");
        let exit_bb = self.cx.append_basic_block(fv, "while_exit");

        self.builder
            .build_unconditional_branch(cond_bb)
            .map_err(to_err)?;

        self.builder.position_at_end(cond_bb);
        let sv = self.lower_expr(sc, source, None)?;
        let test = self.pattern_match_test(pattern, sv.v, &sv.ty)?;
        self.builder
            .build_conditional_branch(test, body_bb, exit_bb)
            .map_err(to_err)?;

        self.builder.position_at_end(body_bb);
        self.bind_pattern_vars(sc, pattern, sv.v, &sv.ty)?;
        self.loops.push((cond_bb, exit_bb));
        let (terminated, _) = self.lower_block_with_tail(sc, body, false)?;
        self.loops.pop();
        if !terminated {
            self.builder
                .build_unconditional_branch(cond_bb)
                .map_err(to_err)?;
        }

        self.builder.position_at_end(exit_bb);
        Ok(self.zero_val())
    }

    /// Locate the `Some`-style payload variant (has a payload) and the unit
    /// `None`-like variant of an Option sum. Returns (payload_idx, unit_idx,
    /// payload_type).
    fn option_variant_ix(ty: &SemType) -> Option<(usize, usize, SemType)> {
        let SemType::Sum { variants, .. } = ty else {
            return None;
        };
        let payload = variants
            .iter()
            .enumerate()
            .find(|(_, (_, p))| p.is_some())
            .and_then(|(i, (_, p))| p.clone().map(|pt| (i, pt)))?;
        let unit = variants
            .iter()
            .enumerate()
            .find(|(_, (_, p))| p.is_none())
            .map(|(i, _)| i)?;
        Some((payload.0, unit, payload.1))
    }

    /// Lower `value?`: unwrap an Option in a value position. On the unit
    /// variant the enclosing function early-returns (a boxed None); otherwise
    /// the payload becomes the expression's value.
    fn lower_early_return(
        &mut self,
        sc: &mut Scope<'ctx>,
        value: &Expr,
    ) -> Result<Val<'ctx>, String> {
        let fv = self
            .cur_fn
            .ok_or_else(|| "codegen: `?` outside a function".to_string())?;
        let sv = self.lower_expr(sc, value, None)?;
        let (payload_idx, unit_idx, payload_ty) =
            Self::option_variant_ix(&sv.ty).ok_or_else(|| {
                format!("codegen: `?` requires an Option, found {}", sv.ty)
            })?;

        let tag = self.rt_call("resid_box_tag", vec![sv.v])?;
        let tag = tag.into_int_value();
        let is_unit = self
            .builder
            .build_int_compare(
                inkwell::IntPredicate::EQ,
                tag,
                self.cx
                    .i64_type()
                    .const_int(unit_idx as u64, false),
                "q_is_unit",
            )
            .map_err(to_err)?;

        let payload_bb = self.cx.append_basic_block(fv, "q_payload");
        let ret_bb = self.cx.append_basic_block(fv, "q_return_none");
        self.builder
            .build_conditional_branch(is_unit, ret_bb, payload_bb)
            .map_err(to_err)?;

        // Early return: box a None of the enclosing function's return value.
        self.builder.position_at_end(ret_bb);
        let ret_ty = self.cur_ret.clone().unwrap_or_else(|| sv.ty.clone());
        if let SemType::Sum { variants, .. } = &ret_ty {
            if let Some(ni) = variants.iter().position(|(_, p)| p.is_none()) {
                let none_val = self.build_constructor(ni as i64, &ret_ty, Vec::new())?;
                self.builder.build_return(Some(&none_val.v)).map_err(to_err)?;
                self.builder.position_at_end(payload_bb);
                let slot = self.cx.i64_type().const_int(payload_idx as u64, false);
                return self.load_slot(sv.v, slot, &payload_ty);
            }
        }
        Err(format!(
            "codegen: `?` needs the enclosing function to return an Option"
        ))
    }

    /// Lower `value else { … }`: unwrap the Option; the unit variant runs the
    /// fallback block whose tail type must equal the payload type.
    fn lower_else_fallback(
        &mut self,
        sc: &mut Scope<'ctx>,
        value: &Expr,
        fallback: &Block,
    ) -> Result<Val<'ctx>, String> {
        let fv = self
            .cur_fn
            .ok_or_else(|| "codegen: `value else` outside a function".to_string())?;
        let sv = self.lower_expr(sc, value, None)?;
        let (payload_idx, unit_idx, payload_ty) =
            Self::option_variant_ix(&sv.ty).ok_or_else(|| {
                format!("codegen: `value else` requires an Option, found {}", sv.ty)
            })?;
        let _ = unit_idx;

        let tag = self.rt_call("resid_box_tag", vec![sv.v])?;
        let tag = tag.into_int_value();
        let is_payload = self
            .builder
            .build_int_compare(
                inkwell::IntPredicate::EQ,
                tag,
                self.cx.i64_type().const_int(payload_idx as u64, false),
                "ve_is_payload",
            )
            .map_err(to_err)?;

        let payload_bb = self.cx.append_basic_block(fv, "ve_payload");
        let fallback_bb = self.cx.append_basic_block(fv, "ve_fallback");
        let merge_bb = self.cx.append_basic_block(fv, "ve_merge");
        self.builder
            .build_conditional_branch(is_payload, payload_bb, fallback_bb)
            .map_err(to_err)?;

        // Payload branch: use the boxed payload.
        self.builder.position_at_end(payload_bb);
        let slot = self.cx.i64_type().const_int(payload_idx as u64, false);
        let payload = self.load_slot(sv.v, slot, &payload_ty)?;
        self.builder
            .build_unconditional_branch(merge_bb)
            .map_err(to_err)?;

        // Fallback branch: lower the block and capture its tail.
        self.builder.position_at_end(fallback_bb);
        let (f_terms, f_tail) = self.lower_block_with_tail(sc, fallback, true)?;

        // Join with a phi over the payload type.
        self.builder.position_at_end(merge_bb);
        let ll = self.llvm_type(&payload_ty)?;
        let phi = self.builder.build_phi(ll, "ve").map_err(to_err)?;
        phi.add_incoming(&[(&payload.v, payload_bb)]);
        if !f_terms {
            match f_tail {
                Some(tail) => {
                    let tv = self.cast_val(tail, &payload_ty)?;
                    phi.add_incoming(&[(&tv.v, fallback_bb)]);
                }
                None => {
                    let zero = self.zero_of_ty(&payload_ty)?;
                    phi.add_incoming(&[(&zero, fallback_bb)]);
                }
            }
            self.builder
                .build_unconditional_branch(merge_bb)
                .map_err(to_err)?;
            self.builder.position_at_end(merge_bb);
        }
        let v = phi.as_basic_value();
        Ok(Val { v, ty: payload_ty })
    }
    fn lower_assert(
        &mut self,
        sc: &mut Scope<'ctx>,
        cond: &Expr,
        message: &Expr,
    ) -> Result<Val<'ctx>, String> {
        let fv = self
            .cur_fn
            .ok_or_else(|| "codegen: assert outside a function".to_string())?;

        let ok_bb = self.cx.append_basic_block(fv, "assert_ok");
        let fail_bb = self.cx.append_basic_block(fv, "assert_fail");

        let c = self.lower_expr(sc, cond, None)?;
        let cb = self.cast_val(c, &SemType::Bool)?.v.into_int_value();
        self.builder
            .build_conditional_branch(cb, ok_bb, fail_bb)
            .map_err(to_err)?;

        // Fail: print the message via resid_abort and (unreachably) continue.
        self.builder.position_at_end(fail_bb);
        let msg = self.lower_expr(sc, message, None)?;
        let msg_str = match &msg.ty {
            SemType::Str => msg.v.into_pointer_value(),
            _ => {
                return Err(format!(
                    "codegen: assert message must be Str, got {}",
                    msg.ty
                ))
            }
        };
        let abort = self
            .module
            .get_function("resid_abort")
            .ok_or("codegen: missing resid_abort decl")?;
        let meta = vec![msg_str.into()];
        self.builder.build_call(abort, &meta, "assert_fail").map_err(to_err)?;
        self.builder.build_unreachable().map_err(to_err)?;

        // Ok: continue with a unit value.
        self.builder.position_at_end(ok_bb);
        Ok(self.zero_val())
    }

    fn lower_for_in(
        &mut self,
        sc: &mut Scope<'ctx>,
        collection: &Expr,
        name: &Id,
        body: &Block,
        _type_: &resid_parser::Type,
    ) -> Result<Val<'ctx>, String> {
        let fv = self
            .cur_fn
            .ok_or_else(|| "codegen: for-in outside a function".to_string())?;

        // A numeric range iterates a counter; a List iterates its slots.
        if let ExprKind::Range { start, end, closed } = &collection.kind {
            return self.lower_for_in_range(sc, fv, start, end, *closed, name, body);
        }

        let col = self.lower_expr(sc, collection, None)?;
        let elem_ty = match &col.ty {
            SemType::List(inner) => inner.as_ref().clone(),
            SemType::Range(inner) => inner.as_ref().clone(),
            other => return Err(format!("codegen: for-in on non-List/non-Range type {other}")),
        };

        let cond_bb = self.cx.append_basic_block(fv, "forin_cond");
        let body_entry_bb = self.cx.append_basic_block(fv, "forin_body_entry");
        let body_bb = self.cx.append_basic_block(fv, "forin_body");
        let inc_bb = self.cx.append_basic_block(fv, "forin_inc");
        let exit_bb = self.cx.append_basic_block(fv, "forin_exit");

        // Position at current builder location (function entry or previous stmt)
        // and emit unconditional branch to cond block
        let cur_pos = self.builder.get_insert_block().unwrap();
        self.builder
            .build_unconditional_branch(cond_bb)
            .map_err(to_err)?;

        // ── Condition ──────────────────────────────────────────────
        // Phi must be the first instruction in the block.
        self.builder.position_at_end(cond_bb);
        let i_phi = self
            .builder
            .build_phi(self.cx.i64_type(), "forin_i")
            .map_err(to_err)?;
        // The first incoming is from the function's entry block (where we branched from)
        let func_entry = cur_pos;
        i_phi.add_incoming(&[(&self.cx.i64_type().const_zero(), func_entry),]);
        let len_v = self.rt_call("resid_list_len", vec![col.v])?;
        let i_val = i_phi.as_basic_value().into_int_value();
        let cmp = self
            .builder
            .build_int_compare(
                IntPredicate::SLT,
                i_val,
                len_v.into_int_value(),
                "forin_cmp",
            )
            .map_err(to_err)?;
        self.builder
            .build_conditional_branch(cmp, body_entry_bb, exit_bb)
            .map_err(to_err)?;

        // ── Body entry: load element and store into loop var slot ──
        self.builder.position_at_end(body_entry_bb);
        let idx = i_phi.as_basic_value().into_int_value();
        let elem = self.load_slot(col.v, idx, &elem_ty)?;

        // Allocate slot for loop variable
        let ll = self.llvm_type(&elem_ty)?;
        let ptr = self.builder.build_alloca(ll, &name.0).map_err(to_err)?;
        self.builder.build_store(ptr, elem.v).map_err(to_err)?;
        sc.vars.insert(name.0.clone(), (ptr, elem_ty.clone()));

        self.builder
            .build_unconditional_branch(body_bb)
            .map_err(to_err)?;

        // ── Body ───────────────────────────────────────────────────
        self.builder.position_at_end(body_bb);
        self.loops.push((inc_bb, exit_bb));
        let (terminated, _) = self.lower_block_with_tail(sc, body, false)?;
        if !terminated {
            self.builder
                .build_unconditional_branch(inc_bb)
                .map_err(to_err)?;
        }
        self.loops.pop();

        // ── Increment ──────────────────────────────────────────────
        self.builder.position_at_end(inc_bb);
        // cond_bb dominates inc_bb (through the loop), so cond_bb's phi value
        // is available here. Both natural loop exit and continue paths use it.
        let inc = self
            .builder
            .build_int_add(i_val, self.cx.i64_type().const_int(1, false), "forin_inc")
            .map_err(to_err)?;
        self.builder
            .build_unconditional_branch(cond_bb)
            .map_err(to_err)?;
        // cond_bb's predecessors are entry_bb and inc_bb — phi has exactly these two incoming.
        i_phi.add_incoming(&[(&inc, inc_bb)]);

        self.builder.position_at_end(exit_bb);
        Ok(Val {
            v: self.cx.bool_type().const_zero().into(),
            ty: SemType::Bool,
        })
    }

    /// Lower `for (T x in start..end)` / `start..=end`: iterate a numeric
    /// counter from `start` to (inclusive/exclusive) `end`.
    #[allow(clippy::too_many_arguments)]
    fn lower_for_in_range(
        &mut self,
        sc: &mut Scope<'ctx>,
        fv: inkwell::values::FunctionValue<'ctx>,
        start: &Expr,
        end: &Expr,
        closed: bool,
        name: &Id,
        body: &Block,
    ) -> Result<Val<'ctx>, String> {
        let elem_ty = self
            .lower_expr(sc, start, None)?
            .ty
            .clone();
        let elem_ty = match elem_ty {
            SemType::Numeric(n) if !n.is_float() => SemType::Numeric(n),
            other => {
                return Err(format!(
                    "codegen: range bounds must be integral numeric, got {other}"
                ))
            }
        };

        let cond_bb = self.cx.append_basic_block(fv, "forin_r_cond");
        let body_bb = self.cx.append_basic_block(fv, "forin_r_body");
        let inc_bb = self.cx.append_basic_block(fv, "forin_r_inc");
        let exit_bb = self.cx.append_basic_block(fv, "forin_r_exit");

        // Evaluate bounds once, before the loop.
        let elem_num = match &elem_ty {
            SemType::Numeric(n) => *n,
            _ => unreachable!("range bounds numeric only"),
        };
        let start_v = self.lower_expr(sc, start, Some(elem_num))?;
        let end_v = self.lower_expr(sc, end, Some(elem_num))?;

        let cur_pos = self.builder.get_insert_block().unwrap();
        self.builder
            .build_unconditional_branch(cond_bb)
            .map_err(to_err)?;

        // ── Condition: i < end (i <= end when closed) ───────────────
        self.builder.position_at_end(cond_bb);
        let i_phi = self
            .builder
            .build_phi(self.cx.i64_type(), "forin_r_i")
            .map_err(to_err)?;
        // Start value, widened to the phi's i64 domain.
        let start_val = Val {
            v: start_v.v,
            ty: elem_ty.clone(),
        };
        let start_i = self
            .cast_val(
                start_val,
                &SemType::Numeric(NumericType::Int(IntWidth::B64.into())),
            )?
            .v
            .into_int_value();
        i_phi.add_incoming(&[(&start_i, cur_pos)]);
        let i_val = i_phi.as_basic_value().into_int_value();
        let end_val = Val {
            v: end_v.v,
            ty: elem_ty.clone(),
        };
        let end_i = self
            .cast_val(
                end_val,
                &SemType::Numeric(NumericType::Int(IntWidth::B64.into())),
            )?
            .v
            .into_int_value();
        let bound_cmp = if closed {
            IntPredicate::SLE
        } else {
            IntPredicate::SLT
        };
        let cmp = self
            .builder
            .build_int_compare(bound_cmp, i_val, end_i, "forin_r_cmp")
            .map_err(to_err)?;
        self.builder
            .build_conditional_branch(cmp, body_bb, exit_bb)
            .map_err(to_err)?;

        // ── Body: loop var is the current counter ──────────────────
        self.builder.position_at_end(body_bb);
        let ll = self.llvm_type(&elem_ty)?;
        let ptr = self.builder.build_alloca(ll, &name.0).map_err(to_err)?;
        let loop_val = self.cast_val(
            Val {
                v: i_val.into(),
                ty: SemType::Numeric(NumericType::Int(IntWidth::B64.into())),
            },
            &elem_ty,
        )?;
        self.builder.build_store(ptr, loop_val.v).map_err(to_err)?;
        sc.vars.insert(name.0.clone(), (ptr, elem_ty.clone()));

        self.loops.push((inc_bb, exit_bb));
        let (terminated, _) = self.lower_block_with_tail(sc, body, false)?;
        if !terminated {
            self.builder
                .build_unconditional_branch(inc_bb)
                .map_err(to_err)?;
        }
        self.loops.pop();

        // ── Increment ──────────────────────────────────────────────
        self.builder.position_at_end(inc_bb);
        let inc = self
            .builder
            .build_int_add(i_val, self.cx.i64_type().const_int(1, false), "forin_r_inc")
            .map_err(to_err)?;
        self.builder
            .build_unconditional_branch(cond_bb)
            .map_err(to_err)?;
        i_phi.add_incoming(&[(&inc, inc_bb)]);

        self.builder.position_at_end(exit_bb);
        Ok(self.zero_val())
    }

    /// A zero/undef value for a block with no tail expression.
    fn zero_val(&self) -> Val<'ctx> {
        Val {
            v: self.cx.bool_type().const_zero().into(),
            ty: SemType::Bool,
        }
    }

    /// A zero constant of the LLVM type for a semantic type (used for phi
    /// placeholders on branches that produce no value).
    fn zero_of_ty(&self, ty: &SemType) -> Result<BasicValueEnum<'ctx>, String> {
        match self.llvm_type(ty)? {
            inkwell::types::BasicTypeEnum::IntType(i) => Ok(i.const_zero().into()),
            inkwell::types::BasicTypeEnum::FloatType(f) => Ok(f.const_zero().into()),
            t => Ok(t.const_zero()),
        }
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
                if let Some((ptr, ty)) = sc.vars.get(&id.0) {
                    let pointee_ty = self.llvm_type(ty)?;
                    let v = self
                        .builder
                        .build_load(pointee_ty, *ptr, &id.0)
                        .map_err(to_err)?;
                    return Ok(Val {
                        v,
                        ty: ty.clone(),
                    });
                }
                // A bare unit variant constructor (`None`).
                self.lower_unit_variant(sc, &id.0)
            }

            ExprKind::Cast { type_, operand } => {
                let to = resid_type::resolve_type_ctx(type_, &self.types)
                    .ok_or("codegen: unknown cast type")?;
                let raw = self.lower_expr(sc, operand, None)?;
                self.cast_val(raw, &to)
            }

            ExprKind::UnaryOp { op, operand } => {
                let raw = self.lower_expr(sc, operand, None)?;
                self.lower_unary(op, raw)
            }

            ExprKind::BinaryOp { op, lhs, rhs } => self.lower_binary(sc, op, lhs, rhs),

            ExprKind::If {
                cond,
                then_block,
                else_block,
            } => self.lower_if(sc, cond, then_block, else_block),

            ExprKind::While { cond, body } => self.lower_while(sc, cond, body),

            ExprKind::IfLet {
                pattern,
                source,
                then_block,
                else_block,
            } => self.lower_if_let(sc, pattern, source, then_block, else_block),

            ExprKind::WhileLet {
                pattern,
                source,
                body,
            } => self.lower_while_let(sc, pattern, source, body),

            ExprKind::EarlyReturn(value) => self.lower_early_return(sc, value),
            ExprKind::ElseFallback { value, fallback } => {
                self.lower_else_fallback(sc, value, fallback)
            }

            ExprKind::ForIn { type_, name, collection, body } => {
                self.lower_for_in(sc, collection, name, body, type_)
            }

            ExprKind::Call { func, args } => self.lower_call(sc, func, args),

            ExprKind::ListLit(elems) => self.lower_list_lit(sc, elems),
            ExprKind::StructLit { name, fields } => self.lower_struct_lit(sc, name, fields),
            ExprKind::FieldAccess { target, field } => {
                self.lower_field_access(sc, target, field)
            }
            ExprKind::Index { target, index } => self.lower_index(sc, target, index),
            ExprKind::Match {
                scrutinee,
                arms,
            } => self.lower_match(sc, scrutinee, arms),
            ExprKind::MethodCall {
                target,
                method,
                args,
            } => self.lower_method_call(sc, target, method, args),

            ExprKind::RawString(s) => {
                let ptr = self.lower_str(s);
                Ok(Val {
                    v: ptr.into(),
                    ty: SemType::Str,
                })
            }

            ExprKind::ByteString(bytes) => {
                let ptr = self.lower_bytes(bytes);
                Ok(Val {
                    v: ptr.into(),
                    ty: SemType::Bytes,
                })
            }

            ExprKind::Location => self.lower_source_loc(&e.span),

            ExprKind::FString(parts) => {
                // Fold pure-text f-strings to a single constant.
                let mut all_text = true;
                for p in parts {
                    if let resid_parser::FStringPart::Expr(_) = p {
                        all_text = false;
                        break;
                    }
                }
                if all_text {
                    let mut out = String::new();
                    for p in parts {
                        if let resid_parser::FStringPart::Text(t) = p {
                            out.push_str(t);
                        }
                    }
                    let ptr = self.lower_str(&out);
                    return Ok(Val {
                        v: ptr.into(),
                        ty: SemType::Str,
                    });
                }
                // Interpolated: eval each part to a string, then concat.
                let mut acc: Option<PointerValue<'ctx>> = None;
                for part in parts {
                    let part_ptr: PointerValue<'ctx> = match part {
                        resid_parser::FStringPart::Text(t) => self.lower_str(t),
                        resid_parser::FStringPart::Expr(e) => {
                            let v = self.lower_expr(sc, e, None)?;
                            self.value_to_str(v)?
                        }
                    };
                    acc = match acc {
                        None => Some(part_ptr),
                        Some(prev) => {
                            let f = self
                                .module
                                .get_function("resid_str_concat")
                                .ok_or("codegen: resid_str_concat not declared")?;
                            let cs = self
                                .builder
                                .build_call(f, &[prev.into(), part_ptr.into()], "concat")
                                .map_err(to_err)?;
                            Some(cs.try_as_basic_value().expect_basic("concat").into_pointer_value())
                        }
                    };
                }
                let ptr = acc.unwrap_or_else(|| self.lower_str(""));
                Ok(Val {
                    v: ptr.into(),
                    ty: SemType::Str,
                })
            }

            ExprKind::Rt(inner) | ExprKind::AtResidual { inner, .. } => {
                self.lower_expr(sc, inner, target)
            }

            ExprKind::Discard(inner) => self.lower_expr(sc, inner, target),

            ExprKind::Assert { cond, message } => self.lower_assert(sc, cond, message),

            ExprKind::RtAssert { cond, message } => self.lower_assert(sc, cond, message),

            ExprKind::Known(inner) | ExprKind::RtKnown(inner) => {
                self.lower_expr(sc, inner, target)
            }

            ExprKind::Todo(msg) => self.lower_abort(&format!("todo: {msg}")),
            ExprKind::Unimplemented(msg) => self.lower_abort(&format!("unimplemented: {msg}")),

            ExprKind::ComptimePrint(inner) => {
                let v = self.lower_expr(sc, inner, target)?;
                let msg = match &inner.kind {
                    ExprKind::Literal(lit) => format!("{lit}"),
                    other => resid_type::kind_tag(other).to_string(),
                };
                eprintln!("[comptime_print] {msg}");
                let _ = v.v; // value dropped; only the compile-time side effect matters
                Ok(self.zero_val())
            }

            ExprKind::Range { start, end, closed } => {
                self.lower_range(sc, start, end, *closed)
            }

            ExprKind::Slice { target, range } => {
                self.lower_slice(sc, target, range)
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
                Ok(Val {
                    v: v.into(),
                    ty: SemType::Bool,
                })
            }

            Literal::Str(lit) => {
                let ptr = self.lower_str(&lit.value);
                Ok(Val {
                    v: ptr.into(),
                    ty: SemType::Str,
                })
            }

            Literal::RawStr(lit) => {
                let ptr = self.lower_str(&lit.value);
                Ok(Val {
                    v: ptr.into(),
                    ty: SemType::Str,
                })
            }

            Literal::ByteStr(lit) => {
                let ptr = self.lower_bytes(&lit.value);
                Ok(Val {
                    v: ptr.into(),
                    ty: SemType::Bytes,
                })
            }

            Literal::Char(c) => {
                let ptr = self.lower_str(&c.to_string());
                Ok(Val {
                    v: ptr.into(),
                    ty: SemType::Str,
                })
            }

            _ => Err(format!("codegen: literal `{lit}` not supported yet")),
        }
    }

    fn lower_unary(&mut self, op: &OpKind, raw: Val<'ctx>) -> Result<Val<'ctx>, String> {
        match op {
            OpKind::Plus => Ok(raw),
            OpKind::Minus => {
                let v = match raw.v {
                    BasicValueEnum::IntValue(i) => {
                        self.builder.build_int_neg(i, "neg").map_err(to_err)?.into()
                    }
                    BasicValueEnum::FloatValue(f) => self
                        .builder
                        .build_float_neg(f, "fneg")
                        .map_err(to_err)?
                        .into(),
                    _ => return Err("codegen: unary minus needs numeric".into()),
                };
                Ok(Val { v, ty: raw.ty })
            }
            OpKind::Not => {
                let i = raw.v.into_int_value();
                let v = self.builder.build_not(i, "not").map_err(to_err)?;
                Ok(Val {
                    v: v.into(),
                    ty: SemType::Bool,
                })
            }
            OpKind::Tilde => {
                let i = raw.v.into_int_value();
                let v = self.builder.build_not(i, "bvnot").map_err(to_err)?;
                Ok(Val {
                    v: v.into(),
                    ty: raw.ty,
                })
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
        // String concatenation: fold constant string operands at compile time.
        if matches!(op, OpKind::Plus) {
            if let (Some(l), Some(r)) = (const_str(lhs), const_str(rhs)) {
                let ptr = self.lower_str(&format!("{l}{r}"));
                return Ok(Val {
                    v: ptr.into(),
                    ty: SemType::Str,
                });
            }
            // Runtime Str + Str (non-constant operand): concatenate at runtime.
            let l = self.lower_expr(sc, lhs, None)?;
            let r = self.lower_expr(sc, rhs, None)?;
            if l.ty == SemType::Str && r.ty == SemType::Str {
                let f = self
                    .module
                    .get_function("resid_str_concat")
                    .ok_or("codegen: resid_str_concat not declared")?;
                let cs = self
                    .builder
                    .build_call(f, &[l.v.into(), r.v.into()], "concat")
                    .map_err(to_err)?;
                let v = cs.try_as_basic_value().expect_basic("concat");
                return Ok(Val {
                    v,
                    ty: SemType::Str,
                });
            }
        }

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
            return Ok(Val {
                v: v.into(),
                ty: SemType::Bool,
            });
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
        Ok(Val {
            v,
            ty: SemType::Numeric(res),
        })
    }

    fn widen(&mut self, v: Val<'ctx>, res: Numeric) -> Result<BasicValueEnum<'ctx>, String> {
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
            return Ok(self
                .builder
                .build_float_cast(f, ft, "wid")
                .map_err(to_err)?
                .into());
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
        Ok(self
            .builder
            .build_int_truncate(i, it, "trunc")
            .map_err(to_err)?
            .into())
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
            let w = lt
                .target_width()
                .unwrap_or(64)
                .max(rt.target_width().unwrap_or(64));
            let ft = self.float_type(w)?;
            let lf = to_float(l)?;
            let rf = to_float(r)?;
            let lf = self
                .builder
                .build_float_cast(lf, ft, "fc")
                .map_err(to_err)?;
            let rf = self
                .builder
                .build_float_cast(rf, ft, "fc")
                .map_err(to_err)?;
            let pred = match binop {
                BinOp::Eq => FloatPredicate::OEQ,
                BinOp::Ne => FloatPredicate::ONE,
                BinOp::Lt => FloatPredicate::OLT,
                BinOp::Le => FloatPredicate::OLE,
                BinOp::Gt => FloatPredicate::OGT,
                BinOp::Ge => FloatPredicate::OGE,
                _ => unreachable!(),
            };
            let i = self
                .builder
                .build_float_compare(pred, lf, rf, "fcmp")
                .map_err(to_err)?;
            return Ok(Val {
                v: i.into(),
                ty: SemType::Bool,
            });
        }
        let w = lt
            .target_width()
            .unwrap_or(64)
            .max(rt.target_width().unwrap_or(64));
        let signed = lt.is_signed() && rt.is_signed();
        let li = self.to_int(l, w)?;
        let ri = self.to_int(r, w)?;
        let pred = int_pred(binop, signed);
        let i = self
            .builder
            .build_int_compare(pred, li, ri, "icmp")
            .map_err(to_err)?;
        Ok(Val {
            v: i.into(),
            ty: SemType::Bool,
        })
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
        self.builder
            .build_int_truncate(i, it, "trunc")
            .map_err(to_err)
    }

    fn cast_val(&mut self, raw: Val<'ctx>, to: &SemType) -> Result<Val<'ctx>, String> {
        // Identical semantic type — no conversion needed (covers composite
        // pointer values, Str, and already-typed numeric values).
        if raw.ty == *to {
            return Ok(raw);
        }
        // Ptr target accepts any pointer-typed source (composites, Str).
        if matches!(to, SemType::Ptr) {
            return Ok(raw);
        }
        let to_ll = self.llvm_type(to)?;
        let v = match (raw.v, to_ll) {
            (BasicValueEnum::IntValue(i), BasicTypeEnum::IntType(t)) => {
                let (a, b) = (i.get_type().get_bit_width(), t.get_bit_width());
                if a == b {
                    BasicValueEnum::IntValue(i)
                } else if a > b {
                    self.builder
                        .build_int_truncate(i, t, "cast")
                        .map_err(to_err)?
                        .into()
                } else {
                    let signed = matches!(&raw.ty, SemType::Numeric(n) if n.is_signed());
                    if signed {
                        self.builder
                            .build_int_s_extend(i, t, "cast")
                            .map_err(to_err)?
                            .into()
                    } else {
                        self.builder
                            .build_int_z_extend(i, t, "cast")
                            .map_err(to_err)?
                            .into()
                    }
                }
            }
            (BasicValueEnum::FloatValue(f), BasicTypeEnum::FloatType(t)) => self
                .builder
                .build_float_cast(f, t, "cast")
                .map_err(to_err)?
                .into(),
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

    /// Widen an argument value to match a function parameter type.
    /// Handles:
    /// - Bool (i1) → i8 for C ABI (extern param_type uses i8 for Bool)
    /// - Numeric widening/truncation to the target bit width
    /// - Passthrough for pointer types (Str, List, Struct, Sum)
    fn widen_call_arg(&mut self, raw: Val<'ctx>, target: &SemType) -> Result<Val<'ctx>, String> {
        // Bool argument → i8 param (C ABI for extern functions) — must run
        // before the equality check below, since both sides are SemType::Bool
        // but the LLVM types differ (i1 vs i8).
        if raw.ty == SemType::Bool && matches!(target, SemType::Bool) {
            let i = raw.v.into_int_value();
            let b8 = self
                .builder
                .build_int_z_extend(i, self.cx.i8_type(), "bool_to_i8")
                .map_err(to_err)?;
            return Ok(Val {
                v: b8.into(),
                ty: SemType::Bool,
            });
        }
        if raw.ty == *target {
            return Ok(raw);
        }
        // Composite types (List/Struct/Sum) → Ptr parameter — passthrough.
        if matches!(target, SemType::Ptr) {
            match &raw.ty {
                SemType::List(_) | SemType::Struct { .. } | SemType::Sum { .. } => return Ok(raw),
                _ => {}
            }
        }
        // Numeric widening / truncation (ints and floats).
        if let (SemType::Numeric(src), SemType::Numeric(dst)) = (&raw.ty, target) {
            // If the source is float and the target is integer (or vice versa),
            // do NOT widen — the conversion helper expects the original type.
            if src.is_float() != dst.is_float() && src.is_integer() != dst.is_integer() {
                return Ok(raw);
            }
            let dst_bits = dst.target_width().unwrap_or(64);
            if src.is_float() {
                let ft = self.float_type(dst_bits)?;
                let f = raw.v.into_float_value();
                let src_bits = src.target_width().unwrap_or(64);
                if src_bits == dst_bits {
                    return Ok(raw);
                }
                let v = self
                    .builder
                    .build_float_cast(f, ft, "widen_float")
                    .map_err(to_err)?;
                return Ok(Val {
                    v: v.into(),
                    ty: target.clone(),
                });
            }
            // Integer widening / truncation.
            let src_bits = src.target_width().unwrap_or(64);
            if src_bits == dst_bits {
                return Ok(raw);
            }
            let i = raw.v.into_int_value();
            let v = if src_bits < dst_bits {
                let signed = src.is_signed();
                let ext = if signed {
                    self.builder.build_int_s_extend(i, self.int_type(dst_bits)?, "widen")
                } else {
                    self.builder.build_int_z_extend(i, self.int_type(dst_bits)?, "widen")
                };
                ext.map_err(to_err)?.into()
            } else {
                self.builder
                    .build_int_truncate(i, self.int_type(dst_bits)?, "widen")
                    .map_err(to_err)?
                    .into()
            };
            return Ok(Val { v, ty: target.clone() });
        }
        // Pointer types (Str, List, Struct, Sum) — passthrough.
        Ok(raw)
    }

    /// Convert an arbitrary lowered value to a string pointer, for f-string
    /// interpolation. Strings pass through; numerics go through the
    /// `*ToString` runtime helpers (widened to the widest supported width);
    /// boxed composites go through `ToString`.
    fn value_to_str(&mut self, raw: Val<'ctx>) -> Result<PointerValue<'ctx>, String> {
        match &raw.ty {
            SemType::Str => Ok(raw.v.into_pointer_value()),
            SemType::Numeric(n) => {
                let (name, want): (&str, Numeric) = match n {
                    NumericType::Int(_) | NumericType::ISize => (
                        "IntToString",
                        Numeric::Int(resid_ir::IntWidth::B64),
                    ),
                    NumericType::UInt(_) | NumericType::USize => (
                        "UIntToString",
                        Numeric::UInt(resid_ir::IntWidth::B64),
                    ),
                    NumericType::Float(_) => (
                        "FloatToString",
                        Numeric::Float(resid_ir::FloatWidth::F64),
                    ),
                };
                let arg = self.widen(raw, want)?;
                self.call_to_string(name, arg.into())
            }
            SemType::Bool => {
                let i = raw.v.into_int_value();
                let b8 = self
                    .builder
                    .build_int_z_extend(i, self.cx.i8_type(), "bool_to_i8")
                    .map_err(to_err)?;
                self.call_to_string("BoolToString", b8.into())
            }
            SemType::List(_) | SemType::Slice(_) | SemType::Struct { .. } | SemType::Sum { .. }
            | SemType::SourceLoc | SemType::Ptr => self.call_to_string("ToString", raw.v.into()),
            other => Err(format!("codegen: cannot interpolate value of type {other}")),
        }
    }

    /// Call a runtime `*ToString` helper and return the resulting string ptr.
    fn call_to_string(
        &self,
        name: &str,
        arg: BasicMetadataValueEnum<'ctx>,
    ) -> Result<PointerValue<'ctx>, String> {
        let f = self
            .module
            .get_function(name)
            .ok_or_else(|| format!("codegen: `{name}` not declared"))?;
        let cs = self.builder.build_call(f, &[arg], "call").map_err(to_err)?;
        let v = cs.try_as_basic_value().expect_basic("to_string");
        Ok(v.into_pointer_value())
    }

    // ─── Calls ───────────────────────────────────────────────────

    /// Declare the bootstrap runtime helpers (boxed composite values + arithmetic).
    fn declare_runtime(&mut self) {
        let ptr = self.cx.ptr_type(AddressSpace::default());
        let i64t = self.cx.i64_type();
        let i8t = self.cx.i8_type();
        let f64t = self.cx.f64_type();
        self.decl_rt("resid_box_new", vec![i64t.into(), i64t.into(), ptr.into(), ptr.into()], ptr.into());
        self.decl_rt("resid_box_tag", vec![ptr.into()], i64t.into());
        self.decl_rt("resid_box_slot", vec![ptr.into(), i64t.into()], ptr.into());
        self.decl_rt("resid_box_i64", vec![i64t.into()], ptr.into());
        self.decl_rt("resid_box_f64", vec![f64t.into()], ptr.into());
        self.decl_rt("resid_box_bool", vec![i8t.into()], ptr.into());
        self.decl_rt("resid_unbox_i64", vec![ptr.into()], i64t.into());
        self.decl_rt("resid_unbox_f64", vec![ptr.into()], f64t.into());
        self.decl_rt("resid_unbox_bool", vec![ptr.into()], i8t.into());
        self.decl_rt("resid_list_len", vec![ptr.into()], i64t.into());
        self.decl_rt_void("resid_abort", vec![ptr.into()]);
        // String concatenation (f-string interpolation, Str + Str).
        self.decl_rt("resid_str_concat", vec![ptr.into(), ptr.into()], ptr.into());
        // Checked arithmetic (called after overflow check passes).
        self.decl_rt("checked_add", vec![i64t.into(), i64t.into()], i64t.into());
        self.decl_rt("checked_sub", vec![i64t.into(), i64t.into()], i64t.into());
        self.decl_rt("checked_mul", vec![i64t.into(), i64t.into()], i64t.into());
        self.decl_rt("checked_div", vec![i64t.into(), i64t.into()], i64t.into());
        self.decl_rt("checked_uadd", vec![i64t.into(), i64t.into()], i64t.into());
        self.decl_rt("checked_usub", vec![i64t.into(), i64t.into()], i64t.into());
        self.decl_rt("checked_umul", vec![i64t.into(), i64t.into()], i64t.into());
        self.decl_rt("checked_udiv", vec![i64t.into(), i64t.into()], i64t.into());
        // Wrapping arithmetic.
        self.decl_rt("wrapping_add", vec![i64t.into(), i64t.into()], i64t.into());
        self.decl_rt("wrapping_sub", vec![i64t.into(), i64t.into()], i64t.into());
        self.decl_rt("wrapping_mul", vec![i64t.into(), i64t.into()], i64t.into());
        self.decl_rt("wrapping_div", vec![i64t.into(), i64t.into()], i64t.into());
        self.decl_rt("wrapping_uadd", vec![i64t.into(), i64t.into()], i64t.into());
        self.decl_rt("wrapping_usub", vec![i64t.into(), i64t.into()], i64t.into());
        self.decl_rt("wrapping_umul", vec![i64t.into(), i64t.into()], i64t.into());
        self.decl_rt("wrapping_udiv", vec![i64t.into(), i64t.into()], i64t.into());
        // Saturating arithmetic.
        self.decl_rt("saturating_add", vec![i64t.into(), i64t.into()], i64t.into());
        self.decl_rt("saturating_sub", vec![i64t.into(), i64t.into()], i64t.into());
        self.decl_rt("saturating_mul", vec![i64t.into(), i64t.into()], i64t.into());
        self.decl_rt("saturating_uadd", vec![i64t.into(), i64t.into()], i64t.into());
        self.decl_rt("saturating_usub", vec![i64t.into(), i64t.into()], i64t.into());
        self.decl_rt("saturating_umul", vec![i64t.into(), i64t.into()], i64t.into());
        // Range and Slice construction (spec §15).
        self.decl_rt("resid_range_new", vec![i64t.into(), i64t.into(), i8t.into()], ptr.into());
        self.decl_rt("resid_slice_new", vec![ptr.into(), i64t.into(), i64t.into()], ptr.into());
    }

    fn decl_rt(
        &mut self,
        name: &str,
        params: Vec<BasicTypeEnum<'ctx>>,
        ret: BasicTypeEnum<'ctx>,
    ) {
        if self.module.get_function(name).is_some() {
            return;
        }
        let meta: Vec<BasicMetadataTypeEnum<'ctx>> = params.iter().map(|t| (*t).into()).collect();
        let ft = make_fn_type(ret, &meta);
        self.module.add_function(name, ft, None);
    }

    /// Declare a void-returning runtime helper (`void f(…)`).
    fn decl_rt_void(&mut self, name: &str, params: Vec<BasicTypeEnum<'ctx>>) {
        if self.module.get_function(name).is_some() {
            return;
        }
        let meta: Vec<BasicMetadataTypeEnum<'ctx>> = params.iter().map(|t| (*t).into()).collect();
        let ft = self.cx.void_type().fn_type(&meta, false);
        self.module.add_function(name, ft, None);
    }

    /// Emit `resid_abort(msg)` for the given string value.
    fn lower_abort(&mut self, msg: &str) -> Result<Val<'ctx>, String> {
        let ptr = self.lower_str(msg);
        let f = self
            .module
            .get_function("resid_abort")
            .ok_or("codegen: missing resid_abort decl")?;
        let meta = vec![ptr.into()];
        self.builder.build_call(f, &meta, "abort").map_err(to_err)?;
        Ok(self.zero_val())
    }

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

        // A variant constructor like `Some(x)`.
        if let Some(sum) = resid_type::find_constructor(&self.types, name).cloned() {
            let SemType::Sum { variants, .. } = &sum else {
                unreachable!()
            };
            let idx = sum
                .variant_index(name)
                .ok_or_else(|| format!("codegen: no variant `{name}`"))?;
            let (_, payload) = &variants[idx];
            return match payload {
                None => {
                    if !args.is_empty() {
                        return Err(format!("codegen: `{name}` takes no arguments"));
                    }
                    self.build_constructor(idx as i64, &sum, Vec::new())
                }
                Some(pt) => {
                    if args.len() != 1 {
                        return Err(format!(
                            "codegen: `{name}` expects one payload argument"
                        ));
                    }
                    let raw = self.lower_expr(sc, &args[0].1, None)?;
                    let raw = self.cast_val(raw, pt)?;
                    let boxed = self.box_scalar(raw)?;
                    self.build_constructor(idx as i64, &sum, vec![boxed])
                }
            };
        }

        // Infer argument types, then pick the best overload (handles multiple
        // signatures with the same name but different parameter types, e.g.
        // IntToString(i8/i16/i32/i64) and ToString(List(T) / Struct / Sum).
        let arg_types: Vec<SemType> = args
            .iter()
            .map(|(_, a)| self.lower_expr(sc, a, None).map(|v| v.ty).unwrap_or(SemType::Bool))
            .collect();
        let sig = best_overload(&arg_types, &self.sigs, name).unwrap_or(FunctionSig {
            name: name.clone(),
            params: Vec::new(),
            ret: SemType::Bool,
        });
        let fnv = self
            .module
            .get_function(name)
            .ok_or_else(|| format!("codegen: no such function `{name}`"))?;
        let mut llargs: Vec<BasicMetadataValueEnum<'ctx>> = Vec::new();
        for (i, (_, a)) in args.iter().enumerate() {
            // Infer the target width from the selected signature's param type.
            let want = sig.params.get(i).and_then(|t| match t {
                SemType::Numeric(n) => Some(*n),
                _ => None,
            });
            let av = self.lower_expr(sc, a, want)?;
            // Widen the argument to exactly match the parameter type,
            // handling Bool↔i8 conversion for C ABI compatibility.
            let param_ty = sig.params.get(i).cloned().unwrap_or(SemType::Bool);
            let av = self.widen_call_arg(av, &param_ty)?;
            llargs.push(av.v.into());
        }
        let cs = self
            .builder
            .build_call(fnv, &llargs, "call")
            .map_err(to_err)?;
        let v = cs
            .try_as_basic_value()
            .expect_basic("call of void function");
        Ok(Val {
            v,
            ty: sig.ret.clone(),
        })
    }

    // ─── Composites ─────────────────────────────────────────────

    fn build_constructor(
        &mut self,
        tag: i64,
        sum: &SemType,
        slots: Vec<BasicValueEnum<'ctx>>,
    ) -> Result<Val<'ctx>, String> {
        let tagv = self.cx.i64_type().const_int(tag as u64, false);
        let cntv = self.cx.i64_type().const_int(slots.len() as u64, false);
        let slotarray = if slots.is_empty() {
            self.cx.ptr_type(AddressSpace::default()).const_null().as_basic_value_enum()
        } else {
            let elem = self.cx.ptr_type(AddressSpace::default());
            let arr_ty = elem.array_type(slots.len() as u32);
            let alloca = self.builder.build_alloca(arr_ty, "slots").map_err(to_err)?;
            for (i, s) in slots.iter().enumerate() {
                let g = unsafe {
                    self.builder
                        .build_in_bounds_gep(
                            arr_ty,
                            alloca,
                            &[
                                self.cx.i32_type().const_int(0, false),
                                self.cx.i32_type().const_int(i as u64, false),
                            ],
                            "slot",
                        )
                        .map_err(to_err)?
                };
                self.builder.build_store(g, *s).map_err(to_err)?;
            }
            alloca.as_basic_value_enum()
        };
        let type_str = self.lower_str(&format!("{sum}"));
        let v = self.rt_call(
            "resid_box_new",
            vec![tagv.into(), cntv.into(), slotarray, type_str.into()],
        )?;
        Ok(Val { v, ty: sum.clone() })
    }

    /// A bare unit-variant constructor (`None`).
    fn lower_unit_variant(&mut self, _sc: &mut Scope<'ctx>, name: &str) -> Result<Val<'ctx>, String> {
        let sum = resid_type::find_constructor(&self.types, name)
            .cloned()
            .ok_or_else(|| format!("codegen: undefined variable `{name}`"))?;
        let idx = sum
            .variant_index(name)
            .ok_or_else(|| format!("codegen: no variant `{name}`"))?;
        let SemType::Sum { variants, .. } = &sum else {
            unreachable!()
        };
        if variants[idx].1.is_some() {
            return Err(format!("codegen: `{name}` requires an argument"));
        }
        self.build_constructor(idx as i64, &sum, Vec::new())
    }

    /// Box a scalar (numeric/bool) or pass a pointer-typed value through.
    fn box_scalar(&mut self, v: Val<'ctx>) -> Result<BasicValueEnum<'ctx>, String> {
        match &v.ty {
            SemType::Numeric(n) if !n.is_float() => {
                let i64v = self.cast_val(
                    v,
                    &SemType::Numeric(NumericType::Int(
                        resid_ir::IntWidth::from_bits(64).unwrap(),
                    )),
                )?;
                self.rt_call("resid_box_i64", vec![i64v.v])
            }
            SemType::Numeric(_) => {
                let f = self.cast_val(
                    v,
                    &SemType::Numeric(NumericType::Float(resid_ir::FloatWidth::F64)),
                )?;
                self.rt_call("resid_box_f64", vec![f.v])
            }
            SemType::Bool => {
                let b = v.v.into_int_value();
                let it = self.cx.i8_type();
                let b8 = self.builder.build_int_z_extend(b, it, "bbi").map_err(to_err)?;
                self.rt_call("resid_box_bool", vec![b8.into()])
            }
            // Str and nested composites are already pointers.
            _ => Ok(v.v),
        }
    }

    /// Read slot `idx` of a boxed object, unboxing per the field type.
    fn load_slot(
        &mut self,
        obj: BasicValueEnum<'ctx>,
        idx: IntValue<'ctx>,
        fty: &SemType,
    ) -> Result<Val<'ctx>, String> {
        let slot = self.rt_call("resid_box_slot", vec![obj, idx.into()])?;
        match fty {
            SemType::Numeric(n) if !n.is_float() => {
                let raw = self.rt_call("resid_unbox_i64", vec![slot])?;
                let v = Val {
                    v: raw,
                    ty: SemType::Numeric(NumericType::Int(
                        resid_ir::IntWidth::from_bits(64).unwrap(),
                    )),
                };
                self.cast_val(v, fty)
            }
            SemType::Numeric(_) => {
                let raw = self.rt_call("resid_unbox_f64", vec![slot])?;
                let v = Val {
                    v: raw,
                    ty: SemType::Numeric(NumericType::Float(resid_ir::FloatWidth::F64)),
                };
                self.cast_val(v, fty)
            }
            SemType::Bool => {
                let u = self.rt_call("resid_unbox_bool", vec![slot])?;
                let b = u.into_int_value();
                let b1 = self
                    .builder
                    .build_int_truncate(b, self.cx.bool_type(), "unbox_b")
                    .map_err(to_err)?;
                Ok(Val {
                    v: b1.into(),
                    ty: SemType::Bool,
                })
            }
            SemType::Str => Ok(Val {
                v: slot,
                ty: SemType::Str,
            }),
            _ => Ok(Val {
                v: slot,
                ty: fty.clone(),
            }),
        }
    }

    fn lower_list_lit(&mut self, sc: &mut Scope<'ctx>, elems: &[Expr]) -> Result<Val<'ctx>, String> {
        let mut slots = Vec::new();
        let mut elem_ty: Option<SemType> = None;
        for e in elems {
            let v = self.lower_expr(sc, e, None)?;
            let t = v.ty.clone();
            match &elem_ty {
                None => elem_ty = Some(t.clone()),
                Some(k) if k == &t => {}
                Some(k) => {
                    return Err(format!(
                        "codegen: list elements differ ({k} vs {t})"
                    ));
                }
            }
            slots.push(self.box_scalar(v)?);
        }
        let elem_ty = elem_ty.ok_or_else(|| "codegen: cannot lower an empty list literal".to_string())?;
        let ty = SemType::List(Box::new(elem_ty));
        self.build_constructor(0, &ty, slots)
    }

    fn lower_struct_lit(
        &mut self,
        sc: &mut Scope<'ctx>,
        name: &Id,
        fields: &[(Id, Expr)],
    ) -> Result<Val<'ctx>, String> {
        let st = self
            .types
            .get(&name.0)
            .cloned()
            .ok_or_else(|| format!("codegen: unknown type `{}`", name.0))?;
        let SemType::Struct { fields: defs, .. } = &st else {
            return Err(format!("codegen: `{}` is not a struct", name.0));
        };
        let mut slots = Vec::new();
        for (fname, _) in defs {
            let (_, vexpr) = fields
                .iter()
                .find(|(n, _)| n.0 == *fname)
                .ok_or_else(|| format!("codegen: missing field `{}`", fname))?;
            let v = self.lower_expr(sc, vexpr, None)?;
            slots.push(self.box_scalar(v)?);
        }
        self.build_constructor(0, &st, slots)
    }

    fn lower_field_access(
        &mut self,
        sc: &mut Scope<'ctx>,
        target: &Expr,
        field: &Id,
    ) -> Result<Val<'ctx>, String> {
        let tv = self.lower_expr(sc, target, None)?;
        let fields: Vec<(String, SemType)> = match &tv.ty {
            SemType::Struct { fields, .. } => fields.clone(),
            SemType::SourceLoc => resid_type::source_loc_fields(),
            other => {
                return Err(format!(
                    "codegen: field access on non-struct {other}"
                ))
            }
        };
        let idx = fields
            .iter()
            .position(|(n, _)| n == &field.0)
            .ok_or_else(|| format!("codegen: no field `{}`", field.0))?;
        let fty = fields[idx].1.clone();
        let iv = self.cx.i64_type().const_int(idx as u64, false);
        self.load_slot(tv.v, iv, &fty)
    }

    fn lower_index(
        &mut self,
        sc: &mut Scope<'ctx>,
        target: &Expr,
        index: &Expr,
    ) -> Result<Val<'ctx>, String> {
        let tv = self.lower_expr(sc, target, None)?;
        let (list_val, elem) = match &tv.ty {
            SemType::List(elem) => (tv.v, elem),
            SemType::Slice(inner_list) => {
                // Resolve slice to its underlying list via first slot.
                let list_slot = self.rt_call("resid_box_slot", vec![tv.v, self.cx.i64_type().const_int(0, false).into()])?;
                (list_slot, inner_list)
            }
            other => return Err(format!("codegen: cannot index {}", other)),
        };
        let iv = self.lower_expr(sc, index, None)?;
        let iw = self.cast_val(
            iv,
            &SemType::Numeric(NumericType::Int(resid_ir::IntWidth::from_bits(64).unwrap())),
        )?;
        let idx = iw.v.into_int_value();
        self.load_slot(list_val, idx, elem)
    }

    /// Lower `#location` to a boxed SourceLoc carrying the current span's
    /// file, line, and column. Fields are `file: Str`, `line: Int`, `col: Int`.
    fn lower_source_loc(&mut self, span: &resid_lexer::token::Span) -> Result<Val<'ctx>, String> {
        let i64t = self.cx.i64_type();
        let file_ptr = self.lower_str(&span.file);
        let file_box = self.box_scalar(Val {
            v: file_ptr.into(),
            ty: SemType::Str,
        })?;
        let line_v = i64t.const_int(span.line as u64, false);
        let line_box = self.box_scalar(Val {
            v: line_v.into(),
            ty: SemType::Numeric(NumericType::Int(resid_ir::IntWidth::from_bits(64).unwrap())),
        })?;
        let col_v = i64t.const_int(span.col_start as u64, false);
        let col_box = self.box_scalar(Val {
            v: col_v.into(),
            ty: SemType::Numeric(NumericType::Int(resid_ir::IntWidth::from_bits(64).unwrap())),
        })?;
        let st = SemType::SourceLoc;
        let slots = vec![file_box, line_box, col_box];
        self.build_constructor(0, &st, slots)
    }

    /// Lower a range expression `start..end` or `start..=end` to a boxed Range value.
    fn lower_range(
        &mut self,
        sc: &mut Scope<'ctx>,
        start: &Expr,
        end: &Expr,
        closed: bool,
    ) -> Result<Val<'ctx>, String> {
        let start_val = self.lower_expr(sc, start, None)?;
        let start_ty = start_val.ty.clone();
        let start_w = self.cast_val(
            start_val,
            &SemType::Numeric(NumericType::Int(resid_ir::IntWidth::from_bits(64).unwrap())),
        )?;
        let end_val = self.lower_expr(sc, end, None)?;
        let end_w = self.cast_val(
            end_val,
            &SemType::Numeric(NumericType::Int(resid_ir::IntWidth::from_bits(64).unwrap())),
        )?;
        let closed_val = self.cx.i8_type().const_int(if closed { 1 } else { 0 }, false);
        let v = self.rt_call(
            "resid_range_new",
            vec![start_w.v.into(), end_w.v.into(), closed_val.into()],
        )?;
        let range_ty = SemType::Range(Box::new(start_ty));
        Ok(Val { v, ty: range_ty })
    }

    /// Lower a slice expression `target[start..end]` to a boxed Slice value.
    fn lower_slice(
        &mut self,
        sc: &mut Scope<'ctx>,
        target: &Expr,
        range: &RangeExpr,
    ) -> Result<Val<'ctx>, String> {
        let target_val = self.lower_expr(sc, target, None)?;
        let SemType::List(_) = &target_val.ty else {
            return Err(format!("codegen: cannot slice {}", target_val.ty));
        };
        let start_val = match &range.start {
            Some(e) => self.lower_expr(sc, e, None)?,
            None => {
                let zero = self.cx.i64_type().const_int(0, false);
                Val { v: zero.into(), ty: SemType::Numeric(NumericType::Int(resid_ir::IntWidth::from_bits(64).unwrap())) }
            }
        };
        let start_w = self.cast_val(
            start_val,
            &SemType::Numeric(NumericType::Int(resid_ir::IntWidth::from_bits(64).unwrap())),
        )?;
        let end_val = match &range.end {
            Some(e) => self.lower_expr(sc, e, None)?,
            None => {
                let len = self.rt_call("resid_list_len", vec![target_val.v])?;
                Val { v: len, ty: SemType::Numeric(NumericType::Int(resid_ir::IntWidth::from_bits(64).unwrap())) }
            }
        };
        let end_w = self.cast_val(
            end_val,
            &SemType::Numeric(NumericType::Int(resid_ir::IntWidth::from_bits(64).unwrap())),
        )?;
        let v = self.rt_call(
            "resid_slice_new",
            vec![target_val.v.into(), start_w.v.into(), end_w.v.into()],
        )?;
        let slice_ty = match &target_val.ty {
            SemType::List(e) => SemType::Slice(e.clone()),
            _ => SemType::Slice(Box::new(SemType::Numeric(NumericType::Int(resid_ir::IntWidth::from_bits(64).unwrap())))),
        };
        Ok(Val { v, ty: slice_ty })
    }

    fn lower_method_call(
        &mut self,
        sc: &mut Scope<'ctx>,
        target: &Expr,
        method: &Id,
        args: &[Box<Expr>],
    ) -> Result<Val<'ctx>, String> {
        let tv = self.lower_expr(sc, target, None)?;
        match (method.0.as_str(), &tv.ty) {
            ("len", SemType::List(_)) if args.is_empty() => {
                let v = self.rt_call("resid_list_len", vec![tv.v])?;
                Ok(Val {
                    v,
                    ty: SemType::Numeric(NumericType::ISize),
                })
            }
            _ => Err(format!(
                "codegen: unsupported method `{}` on {}",
                method.0, tv.ty
            )),
        }
    }

    /// Lower a `match`: chain tag comparisons, execute the matched arm, join
    /// with a phi.
    fn lower_match(
        &mut self,
        sc: &mut Scope<'ctx>,
        scrutinee: &Expr,
        arms: &[(resid_parser::Pattern, Expr)],
    ) -> Result<Val<'ctx>, String> {
        let sv = self.lower_expr(sc, scrutinee, None)?;
        let st = sv.ty.clone();
        let fv = self
            .cur_fn
            .ok_or_else(|| "codegen: match outside a function".to_string())?;

        let tag = self.rt_call("resid_box_tag", vec![sv.v])?;
        let tag = tag.into_int_value();

        let n = arms.len();
        let mut checks: Vec<inkwell::basic_block::BasicBlock<'ctx>> = Vec::new();
        let mut bodies: Vec<inkwell::basic_block::BasicBlock<'ctx>> = Vec::new();
        for i in 0..n {
            checks.push(self.cx.append_basic_block(fv, &format!("match_check{i}")));
        }
        let merge = self.cx.append_basic_block(fv, "match_merge");
        let unreachable_bb = self.cx.append_basic_block(fv, "match_unreachable");
        for i in 0..n {
            bodies.push(self.cx.append_basic_block(fv, &format!("match_arm{i}")));
        }

        self.builder.build_unconditional_branch(checks[0]).map_err(to_err)?;
        for i in 0..n {
            self.builder.position_at_end(checks[i]);
            // A variant name (Some/None or a bare unit-variant like `None`) is
            // a refutable, tagged arm; literal/wildcard/Bind/struct patterns
            // match unconditionally.
            let tagged_idx = match &arms[i].0.kind {
                resid_parser::PatternKind::Variant { name, .. } => st.variant_index(&name.0),
                resid_parser::PatternKind::Bind(id) if st.unit_variant_index(&id.0).is_some() => {
                    st.variant_index(&id.0)
                }
                _ => None,
            };
            let cond = match tagged_idx {
                None => self.cx.bool_type().const_int(1, false),
                Some(idx) => {
                    let target = self.cx.i64_type().const_int(idx as u64, false);
                    self.builder
                        .build_int_compare(IntPredicate::EQ, tag, target, "tseq")
                        .map_err(to_err)?
                }
            };
            let next = if i + 1 < n {
                checks[i + 1]
            } else {
                unreachable_bb
            };
            self.builder
                .build_conditional_branch(cond, bodies[i], next)
                .map_err(to_err)?;
        }

        let mut phi_vals: Vec<(BasicValueEnum<'ctx>, BasicBlock<'ctx>)> = Vec::new();
        let mut arm_ty: Option<SemType> = None;
        for i in 0..n {
            self.builder.position_at_end(bodies[i]);
            self.bind_pattern_vars(sc, &arms[i].0, sv.v, &st)?;
            let bv = self.lower_expr(sc, &arms[i].1, None)?;
            // Normalize arms to a single result type (the checker guarantees
            // they agree); use the first computed arm's type as the join.
            let target_ty = match &arm_ty {
                None => bv.ty.clone(),
                Some(t) => t.clone(),
            };
            if arm_ty.is_none() {
                arm_ty = Some(target_ty.clone());
            }
            let cv = self.cast_val(bv, &target_ty)?;
            let block = self.builder.get_insert_block();
            phi_vals.push((cv.v, block.unwrap()));
            self.builder.build_unconditional_branch(merge).map_err(to_err)?;
        }

        self.builder.position_at_end(unreachable_bb);
        self.builder.build_unreachable().map_err(to_err)?;

        self.builder.position_at_end(merge);
        let ty = arm_ty.unwrap_or(SemType::Bool);
        let ll = self.llvm_type(&ty)?;
        let phi = self.builder.build_phi(ll, "match").map_err(to_err)?;
        let clones: Vec<(BasicValueEnum<'ctx>, BasicBlock<'ctx>)> = phi_vals;
        for (val, block) in clones {
            phi.add_incoming(&[(&val, block)]);
        }
        let v = phi.as_basic_value();
        Ok(Val { v, ty })
    }

    /// Bind the variables a pattern introduces into the current scope.
    fn bind_pattern_vars(
        &mut self,
        sc: &mut Scope<'ctx>,
        pat: &resid_parser::Pattern,
        obj: BasicValueEnum<'ctx>,
        ty: &SemType,
    ) -> Result<(), String> {
        match &pat.kind {
            resid_parser::PatternKind::Wildcard | resid_parser::PatternKind::Literal(_) => Ok(()),
            resid_parser::PatternKind::Bind(id) => {
                // A bare identifier naming a unit variant (`None`) is the
                // variant itself, not a capture.
                if ty.unit_variant_index(&id.0).is_some() {
                    return Ok(());
                }
                let ll = self.llvm_type(ty)?;
                let ptr = self.builder.build_alloca(ll, &id.0).map_err(to_err)?;
                self.builder.build_store(ptr, obj).map_err(to_err)?;
                sc.vars.insert(id.0.clone(), (ptr, ty.clone()));
                Ok(())
            }
            resid_parser::PatternKind::Variant { name, param } => {
                let SemType::Sum { variants, .. } = ty else {
                    return Err(format!("codegen: not a sum type: {ty}"));
                };
                let idx = ty
                    .variant_index(&name.0)
                    .ok_or_else(|| format!("codegen: no variant `{}`", name.0))?;
                let (_, payload) = &variants[idx];
                match (param, payload) {
                    (Some(b), Some(pt)) => {
                        let zero = self.cx.i64_type().const_int(0, false);
                        let slot = self.load_slot(obj, zero, pt)?;
                        let inner = resid_parser::Pattern {
                            kind: resid_parser::PatternKind::Bind(b.clone()),
                            span: pat.span.clone(),
                        };
                        self.bind_pattern_vars(sc, &inner, slot.v, pt)
                    }
                    _ => Ok(()),
                }
            }
            resid_parser::PatternKind::Struct { name: _, fields } => {
                let SemType::Struct { fields: defs, .. } = ty else {
                    return Err(format!("codegen: not a struct pattern: {ty}"));
                };
                for (fname, sub) in fields {
                    let pos = defs
                        .iter()
                        .position(|(n, _)| n == &fname.0)
                        .ok_or_else(|| format!("codegen: no field `{}`", fname))?;
                    let fty = defs[pos].1.clone();
                    let iv = self.cx.i64_type().const_int(pos as u64, false);
                    let slot = self.load_slot(obj, iv, &fty)?;
                    self.bind_pattern_vars(sc, sub, slot.v, &fty)?;
                }
                Ok(())
            }
        }
    }

    /// Call an extern runtime function declared in the module.
    fn rt_call(
        &mut self,
        name: &str,
        args: Vec<BasicValueEnum<'ctx>>,
    ) -> Result<BasicValueEnum<'ctx>, String> {
        let f = self
            .module
            .get_function(name)
            .ok_or_else(|| format!("codegen: missing runtime decl `{name}`"))?;
        let meta: Vec<BasicMetadataValueEnum<'ctx>> = args.into_iter().map(|a| a.into()).collect();
        let cs = self
            .builder
            .build_call(f, &meta, name)
            .map_err(to_err)?;
        cs.try_as_basic_value()
            .basic()
            .ok_or_else(|| format!("codegen: runtime `{name}` returned void"))
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

/// Extract the compile-time string value of an expression, if it is a plain
/// string literal/raw string/f-string-of-text/folded concat.
pub fn const_str(e: &Expr) -> Option<String> {
    fn walk(e: &Expr, out: &mut String) -> bool {
        match &e.kind {
            ExprKind::Literal(Literal::Str(l)) => {
                out.push_str(&l.value);
                true
            }
            ExprKind::Literal(Literal::RawStr(l)) => {
                out.push_str(&l.value);
                true
            }
            ExprKind::Literal(Literal::Char(c)) => {
                out.push_str(&c.to_string());
                true
            }
            ExprKind::RawString(s) => {
                out.push_str(s);
                true
            }
            ExprKind::FString(parts) => {
                let mut ok = true;
                for p in parts {
                    match p {
                        resid_parser::FStringPart::Text(t) => out.push_str(t),
                        resid_parser::FStringPart::Expr(_) => ok = false,
                    }
                }
                ok
            }
            ExprKind::BinaryOp {
                op: OpKind::Plus,
                lhs,
                rhs,
            } => walk(lhs, out) && walk(rhs, out),
            _ => false,
        }
    }
    let mut out = String::new();
    walk(e, &mut out).then_some(out)
}

/// Shorthand for the IR primitive type shared across this module.
type Numeric = NumericType;
#[cfg(test)]
mod tests;
