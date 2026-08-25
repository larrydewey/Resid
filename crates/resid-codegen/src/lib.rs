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
use resid_parser::{Block, Declaration, Expr, ExprKind, Id, RangeExpr, Stmt, StmtKind, TranslationUnit, WithBinding};
use resid_type::{FunctionSig, SemType, Types};

/// A lowered value plus the semantic type the checker attributed to it.
pub struct Val<'ctx> {
    pub v: BasicValueEnum<'ctx>,
    pub ty: SemType,
}

/// Does `block` end in a guaranteed terminator (return or an if whose both
/// branches return)? Used to propagate early-return termination out of nested
/// if/else arms so an enclosing block is not double-terminated.
fn block_terminates(block: &Block) -> bool {
    if block.ret.is_some() {
        return true;
    }
    match block.statements.last() {
        Some(s) => match &s.kind {
            StmtKind::Return(_) => true,
            StmtKind::Expr(e) => {
                if let ExprKind::If {
                    then_block,
                    else_block,
                    ..
                } = &e.kind
                {
                    block_terminates(then_block)
                        && else_block.as_ref().is_some_and(|b| block_terminates(b))
                } else if let ExprKind::With { body, .. } = &e.kind {
                    block_terminates(body)
                } else {
                    false
                }
            }
            _ => false,
        },
        None => false,
    }
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

/// Collect every identifier referenced in `expr` (used for spawn capture).
fn collect_ids_expr(e: &Expr, out: &mut Vec<String>) {
    use resid_parser::FStringPart;
    match &e.kind {
        ExprKind::Id(id) => out.push(id.0.clone()),
        ExprKind::BinaryOp { lhs, rhs, .. } => {
            collect_ids_expr(lhs, out);
            collect_ids_expr(rhs, out);
        }
        ExprKind::UnaryOp { operand, .. } => collect_ids_expr(operand, out),
        ExprKind::Cast { operand, .. } => collect_ids_expr(operand, out),
        ExprKind::Call { func, args } => {
            collect_ids_expr(func, out);
            for (_, a) in args {
                collect_ids_expr(a, out);
            }
        }
        ExprKind::Rt(inner)
        | ExprKind::Known(inner)
        | ExprKind::RtKnown(inner)
        | ExprKind::ComptimePrint(inner)
        | ExprKind::Discard(inner) => collect_ids_expr(inner, out),
        ExprKind::AtResidual { inner, .. } => collect_ids_expr(inner, out),
        ExprKind::If {
            cond,
            then_block,
            else_block,
        } => {
            collect_ids_expr(cond, out);
            collect_ids_block(then_block, out);
            if let Some(b) = else_block {
                collect_ids_block(b, out);
            }
        }
        ExprKind::While { cond, body } => {
            collect_ids_expr(cond, out);
            collect_ids_block(body, out);
        }
        ExprKind::ForIn {
            collection, body, ..
        } => {
            collect_ids_expr(collection, out);
            collect_ids_block(body, out);
        }
        ExprKind::Match { scrutinee, arms } => {
            collect_ids_expr(scrutinee, out);
            for (_, b) in arms {
                collect_ids_expr(b, out);
            }
        }
        ExprKind::For {
            init,
            cond,
            step,
            body,
        } => {
            if let Some(s) = init {
                collect_ids_stmt(s, out);
            }
            collect_ids_expr(cond, out);
            if let Some(s) = step {
                collect_ids_stmt(s, out);
            }
            collect_ids_block(body, out);
        }
        ExprKind::Spawn { body, .. } => collect_ids_block(body, out),
        ExprKind::Assert { cond, message } | ExprKind::RtAssert { cond, message } => {
            collect_ids_expr(cond, out);
            collect_ids_expr(message, out);
        }
        ExprKind::StructLit { fields, .. } => {
            for (_, f) in fields {
                collect_ids_expr(f, out);
            }
        }
        ExprKind::ListLit(elems) => {
            for e in elems {
                collect_ids_expr(e, out);
            }
        }
        ExprKind::MapLit(pairs) => {
            for (k, v) in pairs {
                collect_ids_expr(k, out);
                collect_ids_expr(v, out);
            }
        }
        ExprKind::Range { start, end, .. } => {
            collect_ids_expr(start, out);
            collect_ids_expr(end, out);
        }
        ExprKind::FString(parts) => {
            for p in parts {
                if let FStringPart::Expr(e) = p {
                    collect_ids_expr(e, out);
                }
            }
        }
        ExprKind::FieldAccess { target, .. } => collect_ids_expr(target, out),
        ExprKind::Index { target, index } => {
            collect_ids_expr(target, out);
            collect_ids_expr(index, out);
        }
        ExprKind::Slice { target, range } => {
            collect_ids_expr(target, out);
            if let Some(s) = &range.start {
                collect_ids_expr(s, out);
            }
            if let Some(e) = &range.end {
                collect_ids_expr(e, out);
            }
        }
        ExprKind::MethodCall {
            target, args, ..
        } => {
            collect_ids_expr(target, out);
            for a in args {
                collect_ids_expr(a, out);
            }
        }
        ExprKind::EarlyReturn(inner) => collect_ids_expr(inner, out),
        ExprKind::ElseFallback { value, fallback } => {
            collect_ids_expr(value, out);
            collect_ids_block(fallback, out);
        }
        ExprKind::Destructure { source, .. } => collect_ids_expr(source, out),
        ExprKind::IfLet {
            source,
            then_block,
            else_block,
            ..
        } => {
            collect_ids_expr(source, out);
            collect_ids_block(then_block, out);
            if let Some(b) = else_block {
                collect_ids_block(b, out);
            }
        }
        ExprKind::WhileLet { source, body, .. } => {
            collect_ids_expr(source, out);
            collect_ids_block(body, out);
        }
        ExprKind::With { bindings, body } => {
            for b in bindings {
                collect_ids_expr(&b.init, out);
            }
            collect_ids_block(body, out);
        }
        ExprKind::Using { value, .. } => collect_ids_expr(value, out),
        ExprKind::ProviderCall { args, .. } => {
            for a in args {
                collect_ids_expr(a, out);
            }
        }
        ExprKind::Literal(_)
        | ExprKind::Location
        | ExprKind::RawString(_)
        | ExprKind::ByteString(_)
        | ExprKind::Todo(_)
        | ExprKind::Unimplemented(_) => {}
    }
}

/// Collect identifiers referenced across a block's statements and tail expr.
fn collect_ids_block(b: &Block, out: &mut Vec<String>) {
    for s in &b.statements {
        collect_ids_stmt(s, out);
    }
    if let Some(r) = &b.ret {
        collect_ids_expr(r, out);
    }
}

/// Collect identifiers referenced by a statement.
fn collect_ids_stmt(s: &Stmt, out: &mut Vec<String>) {
    match &s.kind {
        StmtKind::Bind { value, .. } => collect_ids_expr(&**value, out),
        StmtKind::Discard(e) => collect_ids_expr(&**e, out),
        StmtKind::Destructure { source, .. } => collect_ids_expr(&**source, out),
        StmtKind::Expr(e) => collect_ids_expr(&**e, out),
        StmtKind::Return(e) => {
            if let Some(e) = e {
                collect_ids_expr(&**e, out);
            }
        }
        StmtKind::Break | StmtKind::Continue => {}
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
    /// True when the entry `main` returns a Dec struct by value. LLVM lowers
    /// the 520-byte struct through a hidden sret pointer, which libc does not
    /// provide when it calls `int main(int, char**)` — so the user function is
    /// emitted as `resid_main` and a real `main` wrapper is synthesized.
    wrap_main: bool,
    /// Monotonic counter for synthesized spawn worker functions.
    spawn_ctr: u32,
    /// True while lowering a spawn worker body: `return` boxes its value and
    /// returns a pointer instead of returning from the enclosing user fn.
    in_spawn_worker: bool,
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
            wrap_main: false,
            spawn_ctr: 0,
            in_spawn_worker: false,
        }
    }

    /// Generate a module for the whole translation unit.
    pub fn generate(&mut self, unit: &TranslationUnit) -> Result<(), String> {
        self.sigs = resid_type::collect_signatures(unit);
        self.types = resid_type::collect_types(unit);
        // A `Dec main()` returns a struct by value; wrap it so the real entry
        // point stays C-ABI compatible (see `wrap_main`).
        self.wrap_main = unit.declarations.iter().any(|d| {
            matches!(d, Declaration::Function(f) if f.name.0 == "main"
                && matches!(
                    resid_type::resolve_type_ctx(&f.ret, &self.types),
                    Some(SemType::Numeric(NumericType::Dec(_)))
                ))
        });
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
        // Declare every function up front so forward references and mutual
        // recursion resolve (a caller may name a function defined later).
        for name in &names {
            let sym = self.decl_name(name);
            self.declare_function(name, &sym, unit)?;
        }
        for name in &names {
            let sym = self.decl_name(name);
            let fv = self
                .module
                .get_function(&sym)
                .ok_or_else(|| format!("codegen: missing declaration for `{name}`"))?;
            self.cur_fn = Some(fv);
            self.lower_function(name, unit, fv)?;
        }
        self.cur_fn = None;
        if self.wrap_main {
            self.emit_main_wrapper()?;
        }
        Ok(())
    }

    /// LLVM symbol for a user function; a wrapped `Dec main` lives under
    /// `resid_main` so the C-ABI `main` wrapper can own the real name.
    fn decl_name(&self, name: &str) -> String {
        if self.wrap_main && name == "main" {
            "resid_main".to_string()
        } else {
            name.to_string()
        }
    }

    /// Synthesize `int main()` → call `resid_main`, discard the Dec result.
    fn emit_main_wrapper(&mut self) -> Result<(), String> {
        let i32t = self.cx.i32_type();
        let fty = i32t.fn_type(&[], false);
        let main = self.module.add_function("main", fty, None);
        let entry = self.cx.append_basic_block(main, "entry");
        self.builder.position_at_end(entry);
        let user = self
            .module
            .get_function("resid_main")
            .ok_or("codegen: resid_main missing")?;
        self.builder.build_call(user, &[], "main_call").map_err(to_err)?;
        self.builder
            .build_return(Some(&i32t.const_zero()))
            .map_err(to_err)?;
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
            128 => Ok(self.cx.f128_type()),
            _ => Err(format!(
                "codegen: float width {bits} not yet supported in LLVM"
            )),
        }
    }

    /// The `resid_dec` LLVM struct type: `{ i8 sign, i16 nd,
    /// [512 x i8] digits, i32 exp }` (byte-identical to the C struct in
    /// resid_rt.c, so by-value passing matches the SysV ABI).
    fn dec_type(&self) -> inkwell::types::StructType<'ctx> {
        self.cx.struct_type(
            &[
                self.cx.i8_type().into(),
                self.cx.i16_type().into(),
                self.cx.i8_type().array_type(512).into(),
                self.cx.i32_type().into(),
            ],
            false,
        )
    }

    fn llvm_type(&self, t: &SemType) -> Result<BasicTypeEnum<'ctx>, String> {
        let bt: BasicTypeEnum<'ctx> = match t {
            SemType::Bool => self.cx.bool_type().into(),
            SemType::Str | SemType::Bytes => self.cx.ptr_type(AddressSpace::default()).into(),
            SemType::Numeric(n) => match n {
                NumericType::Int(w) | NumericType::UInt(w) => self.int_type(w.bits())?.into(),
                NumericType::Float(w) => self.float_type(w.bits())?.into(),
                NumericType::ISize | NumericType::USize => self.int_type(64)?.into(),
                // Dec(N) is the exact-decimal struct `{ i8 sign, i16 nd,
                // [512 x i8] digits, i32 exp }` — byte-layout compatible with
                // the `resid_dec` C struct in resid_rt.c (spec §6.6a).
                NumericType::Dec(_) => self.dec_type().into(),
            },
            SemType::Range(_) => self.int_type(64)?.into(),
            // Composites are untyped heap pointers.
            SemType::List(_) | SemType::Slice(_) | SemType::Struct { .. } | SemType::Sum { .. } | SemType::Ptr | SemType::SourceLoc | SemType::File => {
                self.cx.ptr_type(AddressSpace::default()).into()
            }
        };
        Ok(bt)
    }

    /// Allocate a `resid_dec` slot, store `v` into it, return the pointer.
    /// Dec values always cross the LLVM↔C boundary as pointers (the aggregate
    /// by-value ABI differs between clang and LLVM for this 520-byte struct).
    fn dec_slot(&mut self, v: BasicValueEnum<'ctx>) -> Result<PointerValue<'ctx>, String> {
        let ptr = self
            .builder
            .build_alloca(self.dec_type(), "decs")
            .map_err(to_err)?;
        self.builder.build_store(ptr, v).map_err(to_err)?;
        Ok(ptr)
    }

    /// Call a void-returning Dec helper that writes its result through the
    /// first (out) pointer, then load the result as a struct value.
    fn dec_call_out(
        &mut self,
        name: &str,
        in_ptrs: &[PointerValue<'ctx>],
        extra: &[BasicMetadataValueEnum<'ctx>],
    ) -> Result<BasicValueEnum<'ctx>, String> {
        let out = self
            .builder
            .build_alloca(self.dec_type(), "decout")
            .map_err(to_err)?;
        let f = self
            .module
            .get_function(name)
            .ok_or_else(|| format!("codegen: {name} not declared"))?;
        let mut args: Vec<BasicMetadataValueEnum<'ctx>> = vec![out.into()];
        for p in in_ptrs {
            args.push(BasicMetadataValueEnum::PointerValue(*p));
        }
        args.extend(extra.iter().copied());
        self.builder.build_call(f, &args, name).map_err(to_err)?;
        let v = self
            .builder
            .build_load(self.dec_type(), out, "decout")
            .map_err(to_err)?;
        Ok(v.into())
    }

    // ─── Functions ───────────────────────────────────────────────

    fn declare_function(
        &self,
        name: &str,
        sym: &str,
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
            params.iter().map(|t| self.param_type(t).unwrap()).collect();
        let param_meta: Vec<BasicMetadataTypeEnum<'ctx>> =
            param_ll.iter().map(|t| (*t).into()).collect();
        let ft = make_fn_type(ret_ll, &param_meta);
        Ok(self.module.add_function(sym, ft, None))
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
            // Bool params arrive as i8 (C ABI); narrow to i1 for the body.
            let arg = if ty == SemType::Bool {
                let i8 = arg.into_int_value();
                self.builder
                    .build_int_truncate(i8, self.cx.bool_type(), "bool_narrow")
                    .map_err(to_err)?
                    .into()
            } else {
                arg
            };
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
                        SemType::Numeric(NumericType::Dec(_)) => {
                            let st = self.dec_type();
                            let zeros: Vec<inkwell::values::IntValue<'ctx>> = (0..512)
                                .map(|_| self.cx.i8_type().const_zero())
                                .collect();
                            let arr = self.cx.i8_type().const_array(&zeros);
                            let z = st.const_named_struct(&[
                                self.cx.i8_type().const_zero().into(),
                                self.cx.i16_type().const_zero().into(),
                                arr.into(),
                                self.cx.i32_type().const_zero().into(),
                            ]);
                            self.builder.build_return(Some(&z)).map_err(to_err)?;
                        }
                        SemType::Numeric(_) => {
                            let it = self.llvm_type(&ret_ty)?;
                            let zero: inkwell::values::BasicValueEnum<'ctx> = match it {
                                inkwell::types::BasicTypeEnum::IntType(i) => {
                                    i.const_zero().into()
                                }
                                inkwell::types::BasicTypeEnum::FloatType(ft) => {
                                    ft.const_zero().into()
                                }
                                _ => self.cx.bool_type().const_zero().into(),
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
                        SemType::Str | SemType::Bytes | SemType::List(_) | SemType::Slice(_) | SemType::Struct { .. } | SemType::Sum { .. } | SemType::Ptr | SemType::SourceLoc | SemType::File => {
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
    ) -> Result<(bool, Option<Val<'ctx>>, Option<Val<'ctx>>), String> {
        let mut terminated = false;
        let mut tail: Option<Val<'ctx>> = None;
        // When in a spawn worker, capture the explicit return value so the
        // caller can wrap it in an Ok(sum) result.
        let mut spawn_ret: Option<Val<'ctx>> = None;
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
                    let v = if matches!(&value.kind, ExprKind::ListLit(elems) if elems.is_empty())
                        && matches!(ty, SemType::List(_))
                    {
                        self.build_constructor(0, &ty, Vec::new())?
                    } else {
                        self.lower_expr(sc, value, target)?
                    };
                    let v = self.cast_val(v, &ty)?;
                    self.builder.build_store(ptr, v.v).map_err(to_err)?;
                    sc.vars.insert(name.0.clone(), (ptr, ty));
                }
                StmtKind::Expr(e) | StmtKind::Discard(e) => {
                    let v = self.lower_expr(sc, e, None)?;
                    if is_tail {
                        tail = Some(v);
                    }
                    // An `if` whose then/else branches both return terminates the
                    // enclosing block too (early return out of both arms).
                    if let ExprKind::If {
                        then_block,
                        else_block,
                        ..
                    } = &e.kind
                    {
                        if block_terminates(then_block)
                            && else_block.as_ref().is_some_and(|b| block_terminates(b))
                        {
                            terminated = true;
                        }
                    }
                    // A `with` whose body returns also terminates the block.
                    if let ExprKind::With { body, .. } = &e.kind {
                        if block_terminates(body) {
                            terminated = true;
                        }
                    }
                }
                StmtKind::Return(v) => {
                    if self.in_spawn_worker {
                        // Capture the return value so lower_spawn can wrap it in Ok.
                        match v {
                            Some(e) => {
                                let raw = self.lower_expr(sc, e, None)?;
                                spawn_ret = Some(raw);
                            }
                            None => {
                                let null_ptr = self.cx.ptr_type(AddressSpace::default()).const_null();
                                spawn_ret = Some(Val { v: null_ptr.into(), ty: SemType::Ptr });
                            }
                        }
                    } else {
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
        if !terminated {
            if let Some(ret) = &block.ret {
                // A `return` inside a nested block (if-branch, while body, …) is a
                // real early return: emit it and terminate the block. (The
                // function-body `ret` is additionally handled by `lower_function`,
                // which only runs when the block was not terminated.)
                if self.in_spawn_worker {
                    // Capture the return value so lower_spawn can wrap it in Ok.
                    let raw = self.lower_expr(sc, ret, None)?;
                    spawn_ret = Some(raw);
                } else {
                    let raw = self.lower_expr(sc, ret, None)?;
                    let val = self
                        .cast_val(raw, &self.cur_ret.clone().unwrap_or(SemType::Bool))?;
                    self.builder.build_return(Some(&val.v)).map_err(to_err)?;
                }
                terminated = true;
            }
        }
        Ok((terminated, tail, spawn_ret))
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
        let (t_term, t_tail, _) = self.lower_block_with_tail(sc, then_block, true)?;
        let then_reaches = if t_term {
            None
        } else {
            let from = self.builder.get_insert_block().unwrap();
            self.builder
                .build_unconditional_branch(merge_bb)
                .map_err(to_err)?;
            Some(from)
        };

        // Else arm (or default-zero for the missing branch).
        self.builder.position_at_end(else_bb);
        let (e_term, e_tail, _) = match else_block {
            Some(b) => self.lower_block_with_tail(sc, b, true)?,
            None => (false, None, None),
        };
        let else_reaches = if e_term {
            None
        } else {
            let from = self.builder.get_insert_block().unwrap();
            self.builder
                .build_unconditional_branch(merge_bb)
                .map_err(to_err)?;
            Some(from)
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
            (None, None) => {
                // Both arms returned early — merge_bb is unreachable. It still
                // needs a terminator for verification.
                self.builder.build_unreachable().map_err(to_err)?;
                tv.v
            }
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
        let (terminated, _, _) = self.lower_block_with_tail(sc, body, false)?;
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
        let (t_term, _, _) = self.lower_block_with_tail(sc, then_block, false)?;
        if !t_term {
            self.builder
                .build_unconditional_branch(merge_bb)
                .map_err(to_err)?;
        }

        self.builder.position_at_end(else_bb);
        match else_block {
            Some(b) => {
                let (e_term, _, _) = self.lower_block_with_tail(sc, b, false)?;
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
        let (terminated, _, _) = self.lower_block_with_tail(sc, body, false)?;
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
        let (_payload_idx, unit_idx, payload_ty) =
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
                let slot = self.cx.i64_type().const_int(0, false);
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
        let slot = self.cx.i64_type().const_int(0, false);
        let payload = self.load_slot(sv.v, slot, &payload_ty)?;
        self.builder
            .build_unconditional_branch(merge_bb)
            .map_err(to_err)?;

        // Fallback branch: lower the block and capture its tail.
        self.builder.position_at_end(fallback_bb);
        let (f_terms, f_tail, _) = self.lower_block_with_tail(sc, fallback, true)?;

        // If the fallback did not terminate, route it to the merge block.
        if !f_terms {
            self.builder
                .build_unconditional_branch(merge_bb)
                .map_err(to_err)?;
        }

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
        let (terminated, _, _) = self.lower_block_with_tail(sc, body, false)?;
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
        let (terminated, _, _) = self.lower_block_with_tail(sc, body, false)?;
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
            ExprKind::ProviderCall {
                provider,
                verb,
                args,
            } => self.lower_provider_call(sc, provider, verb, args),

            ExprKind::Spawn { body, .. } => self.lower_spawn(sc, e, body),

            ExprKind::With { bindings, body } => self.lower_with(sc, bindings, body),

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
            Literal::Int { kind, .. } => {
                if let Some(Numeric::Float(fw)) = target {
                    let ft = self.float_type(fw.bits() as u16)?; // cfg
                    let c = self.cx.f64_type().const_float(
                        kind.as_u128().unwrap_or(u128::MAX) as f64,
                    );
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
                    .unwrap_or_else(|| {
                        // No target: keep 64-bit default unless the value
                        // exceeds it (the type checker infers Int(64) for
                        // integer literals; only widen when needed so wide
                        // values aren't truncated to i64).
                        let bits = kind.required_bits();
                        if bits <= 64 {
                            64
                        } else {
                            [128u16, 256, 512]
                                .into_iter()
                                .find(|&w| w >= bits)
                                .unwrap_or(512)
                        }
                    });
                let unsigned = matches!(target, Some(Numeric::UInt(_)));
                let it = self.int_type(width)?;
                let v = it
                    .const_int_from_string(
                        kind.digits(),
                        match kind.radix() {
                            2 => inkwell::types::StringRadix::Binary,
                            8 => inkwell::types::StringRadix::Octal,
                            16 => inkwell::types::StringRadix::Hexadecimal,
                            _ => inkwell::types::StringRadix::Decimal,
                        },
                    )
                    .ok_or_else(|| {
                        format!("codegen: cannot build Int({width}) literal {}", kind.source_str())
                    })?;
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

            // Decimal literal (spec §6.6a): digits carried verbatim (never
            // through binary); built via `resid_dec_from_digits`, which pads
            // or rounds to the literal's precision (the bind target, or the
            // Dec(34) default).
            Literal::Dec(lit) => {
                let prec: u32 = match target {
                    Some(NumericType::Dec(n)) => n as u32,
                    _ => 34,
                };
                let dstr = self.lower_str(&lit.digits);
                let v = self.dec_call_out(
                    "resid_dec_from_digits",
                    &[],
                    &[
                        dstr.into(),
                        self.cx.i32_type().const_int(lit.exp as u64, false).into(),
                        self.cx.i16_type().const_int(prec as u64, false).into(),
                    ],
                )?;
                Ok(Val {
                    v,
                    ty: SemType::Numeric(NumericType::Dec(prec as u16)),
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

            // Char literals are Unicode codepoints (spec §14: literals default
            // to Int; §32 has no Char core type). Lowered as Int(64).
            Literal::Char(c) => {
                let cp = i64::from(u32::from(*c));
                let iv = self.cx.i64_type().const_int(cp as u64, true);
                Ok(Val {
                    v: iv.into(),
                    ty: SemType::Numeric(NumericType::Int(
                        resid_ir::IntWidth::from_bits(64).unwrap(),
                    )),
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
                    // Dec(N) negation flips the sign field (spec §6.6a).
                    BasicValueEnum::StructValue(_) if matches!(&raw.ty, SemType::Numeric(NumericType::Dec(_))) => {
                        let sp = self.dec_slot(raw.v)?;
                        self.dec_call_out("resid_dec_neg", &[sp], &[])?
                    }
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

        // Str == Str / Str != Str: compare via the runtime (strcmp-based).
        // Needed by the bootstrap lexer to match keywords/identifiers.
        if matches!(op, OpKind::EqEq | OpKind::Ne) {
            let l = self.lower_expr(sc, lhs, None)?;
            let r = self.lower_expr(sc, rhs, None)?;
            if l.ty == SemType::Str && r.ty == SemType::Str {
                let f = self
                    .module
                    .get_function("resid_str_eq")
                    .ok_or("codegen: resid_str_eq not declared")?;
                let cs = self
                    .builder
                    .build_call(f, &[l.v.into(), r.v.into()], "streq")
                    .map_err(to_err)?;
                let v = cs.try_as_basic_value().expect_basic("streq");
                let eq = v.into_int_value();
                let cmp = self
                    .builder
                    .build_int_compare(
                        inkwell::IntPredicate::NE,
                        eq,
                        self.cx.i8_type().const_zero(),
                        "strcmpne",
                    )
                    .map_err(to_err)?;
                let res = if matches!(op, OpKind::EqEq) {
                    cmp
                } else {
                    self.builder.build_not(cmp, "strnot").map_err(to_err)?
                };
                return Ok(Val {
                    v: res.into(),
                    ty: SemType::Bool,
                });
            }
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
        // Dec values carry their own precision; the runtime helpers round to
        // the result precision internally (spec §6.6a Dec(max)).
        if res.is_dec() {
            if !src.is_dec() {
                return Err("codegen: cannot widen non-Dec to Dec".into());
            }
            return Ok(v.v);
        }
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

    /// Spec v3.2 §6.1: checked integer add/sub at operand width.
    /// - Both operands constant: fold with exact i64 math; a provable
    ///   overflow is a compile-time error (reduction: no residual check).
    /// - Otherwise emit the raw op plus an overflow predicate that traps.
    fn checked_int_arith(
        &mut self,
        binop: BinOp,
        li: inkwell::values::IntValue<'ctx>,
        ri: inkwell::values::IntValue<'ctx>,
        signed: bool,
        _res: Numeric,
    ) -> Result<BasicValueEnum<'ctx>, String> {
        let width = li.get_type().get_bit_width();
        let is_sub = matches!(binop, BinOp::Sub);
        // Constant folding (widths <= 64, exact i64 math): a provable
        // overflow is a compile error — the residual check reduces away
        // entirely, per the reduction ethos (spec §34).
        if width <= 64 && li.is_constant_int() && ri.is_constant_int() {
            let av = li.get_sign_extended_constant().unwrap_or(0) as i128;
            let bv = ri.get_sign_extended_constant().unwrap_or(0) as i128;
            let rv = if is_sub { av.wrapping_sub(bv) } else { av.wrapping_add(bv) };
            let (lo, hi) = if signed {
                (-(1i128 << (width - 1)), (1i128 << (width - 1)) - 1)
            } else {
                (0i128, ((1u128 << width.min(127)) - 1) as i128)
            };
            if rv < lo || rv > hi {
                return Err(format!(
                    "compile-time arithmetic overflow: {} {} {} does not fit {}({})",
                    av,
                    if is_sub { "-" } else { "+" },
                    bv,
                    if signed { "Int" } else { "UInt" },
                    width
                ));
            }
            let it = self.int_type(width as u16)?;
            let enc = if rv < 0 { (1i128 << width) + rv } else { rv };
            let lit = it.const_int(enc as u64, false);
            return Ok(lit.into());
        }
        let raw = if is_sub {
            self.builder.build_int_sub(li, ri, "subchk")
        } else {
            self.builder.build_int_add(li, ri, "addchk")
        }
        .map_err(to_err)?;
        let it = li.get_type();
        let zero = it.const_int(0, false);
        // Overflow predicate.
        let ovf = if !signed {
            if is_sub {
                self.builder
                    .build_int_compare(inkwell::IntPredicate::ULT, li, ri, "usubovf")
                    .map_err(to_err)?
            } else {
                self.builder
                    .build_int_compare(inkwell::IntPredicate::ULT, raw, li, "uaddovf")
                    .map_err(to_err)?
            }
        } else {
            let pos_l = self
                .builder
                .build_int_compare(inkwell::IntPredicate::SGT, li, zero, "posl")
                .map_err(to_err)?;
            let neg_l = self
                .builder
                .build_int_compare(inkwell::IntPredicate::SLT, li, zero, "negl")
                .map_err(to_err)?;
            let pos_r = self
                .builder
                .build_int_compare(inkwell::IntPredicate::SGT, ri, zero, "posr")
                .map_err(to_err)?;
            let neg_r = self
                .builder
                .build_int_compare(inkwell::IntPredicate::SLT, ri, zero, "negr")
                .map_err(to_err)?;
            let res_neg = self
                .builder
                .build_int_compare(inkwell::IntPredicate::SLT, raw, zero, "resneg")
                .map_err(to_err)?;
            let res_pos = self.builder.build_not(res_neg, "respos").map_err(to_err)?;
            let p1 = if is_sub {
                let a = self.builder.build_and(pos_l, neg_r, "a").map_err(to_err)?;
                self.builder.build_and(a, res_neg, "b").map_err(to_err)?
            } else {
                let a = self.builder.build_and(pos_l, pos_r, "a").map_err(to_err)?;
                self.builder.build_and(a, res_neg, "b").map_err(to_err)?
            };
            let p2 = if is_sub {
                let a = self.builder.build_and(neg_l, pos_r, "c").map_err(to_err)?;
                self.builder.build_and(a, res_pos, "d").map_err(to_err)?
            } else {
                let a = self.builder.build_and(neg_l, neg_r, "c").map_err(to_err)?;
                self.builder.build_and(a, res_pos, "d").map_err(to_err)?
            };
            self.builder.build_or(p1, p2, "ovf").map_err(to_err)?
        };
        let cur_fn = self.cur_fn.ok_or("codegen: no current function")?;
        let trap_bb = self.cx.append_basic_block(cur_fn, "arith_trap");
        let ok_bb = self.cx.append_basic_block(cur_fn, "arith_ok");
        self.builder
            .build_conditional_branch(ovf, trap_bb, ok_bb)
            .map_err(to_err)?;
        self.builder.position_at_end(trap_bb);
        let abortf = self
            .module
            .get_function("resid_arith_overflow")
            .ok_or("codegen: missing resid_arith_overflow decl")?;
        self.builder.build_call(abortf, &[], "ovfcall").map_err(to_err)?;
        self.builder.build_unreachable().map_err(to_err)?;
        self.builder.position_at_end(ok_bb);
        Ok(raw.into())
    }

    fn apply_binop(
        &mut self,
        binop: BinOp,
        l: BasicValueEnum<'ctx>,
        r: BasicValueEnum<'ctx>,
        res: Numeric,
    ) -> Result<BasicValueEnum<'ctx>, String> {
        // Dec arithmetic (spec §6.6a): exact add/sub/mul, division to N+2
        // guard digits — all rounded once inside the runtime helper.
        if res.is_dec() {
            let name = match binop {
                BinOp::Add => "resid_dec_add",
                BinOp::Sub => "resid_dec_sub",
                BinOp::Mul => "resid_dec_mul",
                BinOp::Div => "resid_dec_div",
                _ => return Err("codegen: unsupported Dec op".into()),
            };
            let lp = self.dec_slot(l)?;
            let rp = self.dec_slot(r)?;
            return self.dec_call_out(name, &[lp, rp], &[]);
        }
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
        // Spec v3.2 §6.1/§6.4: add/sub keep the operand width and must
        // trap on overflow (never widen-then-narrow). Constant operands
        // are folded at compile time — a provable overflow is a compile
        // error; otherwise a residual range check guards the op.
        if matches!(binop, BinOp::Add | BinOp::Sub) {
            return self.checked_int_arith(binop, li, ri, signed, res);
        }
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
            BinOp::ShiftLeft => {
                let sh = self.builder.build_left_shift(li, ri, "shl").map_err(to_err)?;
                let width = li.get_type().get_bit_width();
                let wv = li.get_type().const_int(width as u64, false);
                let ovf = self
                    .builder
                    .build_int_compare(inkwell::IntPredicate::UGE, ri, wv, "shovf").map_err(to_err)?;
                let zero = li.get_type().const_int(0, false);
                self.builder
                    .build_select(ovf, zero, sh, "shsafe")
                    .map(|bv| bv.into_int_value())
            }
            BinOp::ShiftRight => {
                let sh = self.builder.build_right_shift(li, ri, signed, "shr").map_err(to_err)?;
                let width = li.get_type().get_bit_width();
                let wv = li.get_type().const_int(width as u64, false);
                let ovf = self
                    .builder
                    .build_int_compare(inkwell::IntPredicate::UGE, ri, wv, "shovf").map_err(to_err)?;
                let zero = li.get_type().const_int(0, false);
                self.builder
                    .build_select(ovf, zero, sh, "shsafe")
                    .map(|bv| bv.into_int_value())
            }
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
        // Dec comparisons go through `resid_dec_cmp` (an i32 sign), then a
        // signed compare against zero.
        if lt.is_dec() || rt.is_dec() {
            if !(lt.is_dec() && rt.is_dec()) {
                return Err("codegen: Dec compared with non-Dec".into());
            }
            let lp = self.dec_slot(l.v)?;
            let rp = self.dec_slot(r.v)?;
            let f = self
                .module
                .get_function("resid_dec_cmp")
                .ok_or("codegen: resid_dec_cmp not declared")?;
            let cs = self
                .builder
                .build_call(f, &[lp.into(), rp.into()], "dcmp")
                .map_err(to_err)?;
            let c = cs.try_as_basic_value().expect_basic("dcmp").into_int_value();
            let pred = int_pred(binop, true);
            let i = self
                .builder
                .build_int_compare(pred, c, self.cx.i32_type().const_zero(), "dcmpz")
                .map_err(to_err)?;
            return Ok(Val {
                v: i.into(),
                ty: SemType::Bool,
            });
        }
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
        // ── Dec(N) conversions (spec §6.6a) ─────────────────────────
        // These bypass the LLVM cast below: Dec is an aggregate struct, and
        // all Dec conversions go through the C runtime (the type checker
        // permits C-style casts to any target, so Dec sources/targets must be
        // handled generically here).
        if matches!(to, SemType::Numeric(NumericType::Dec(_))) {
            return self.cast_to_dec(raw, to);
        }
        if matches!(&raw.ty, SemType::Numeric(NumericType::Dec(_))) {
            return self.cast_from_dec(raw, to);
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
            // Sum types with same name but different inner widths (e.g. Result(Int(128),E) → Result(Int(64),E)).
            // Read tag + payload, cast the payload, rebuild the target sum.
            (BasicValueEnum::PointerValue(ptr), BasicTypeEnum::PointerType(_))
                if matches!(&raw.ty, SemType::Sum { .. }) && matches!(to, SemType::Sum { .. }) =>
            {
                let SemType::Sum { variants: from_variants, .. } = &raw.ty else {
                    unreachable!()
                };
                let SemType::Sum { variants: to_variants, .. } = to else {
                    unreachable!()
                };
                if from_variants.len() != to_variants.len() {
                    return Err(format!("codegen: cannot cast {} to {to} (variant count mismatch)", raw.ty));
                }
                // Same variant order — cast the payload of the matching variant.
                for (fi, (fname, fty)) in from_variants.iter().enumerate() {
                    if fi < to_variants.len() {
                        let (tname, tty) = &to_variants[fi];
                        if fname == tname {
                            // Same variant name — check if inner types differ.
                            match (fty, tty) {
                                (Some(f), Some(t)) if f != t => {
                                    // Payload differs — extract, cast, box, rebuild.
                                    let slot = self.rt_call("resid_box_slot", vec![ptr.into(), self.cx.i64_type().const_int(0, false).into()])?;
                                    let payload = self.extract_payload(slot, f)?;
                                    let casted = self.cast_val(payload, t)?;
                                    let boxed = self.box_scalar(casted)?;
                                    let ok = self.build_constructor(fi as i64, to, vec![boxed])?;
                                    return Ok(ok);
                                }
                                (Some(_), Some(_)) => {
                                    // Inner types same — just rebuild with target sum type.
                                    let ok = self.build_constructor(fi as i64, to, vec![ptr.into()])?;
                                    return Ok(ok);
                                }
                                (None, None) => {
                                    // Unit variant — rebuild.
                                    let ok = self.build_constructor(fi as i64, to, Vec::new())?;
                                    return Ok(ok);
                                }
                                _ => {}
                            }
                        }
                    }
                }
                return Err(format!("codegen: cannot cast {} to {to}", raw.ty));
            }
            _ => return Err(format!("codegen: cannot cast {} to {to}", raw.ty)),
        };
        Ok(Val { v, ty: to.clone() })
    }

    /// Cast any supported source value to Dec(prec). Sources: Dec (round),
    /// Int/UInt (exact via i64 or i128), Float (lossy via %.17g), Str (parse).
    fn cast_to_dec(&mut self, raw: Val<'ctx>, to: &SemType) -> Result<Val<'ctx>, String> {
        let prec = match to {
            SemType::Numeric(NumericType::Dec(n)) => *n,
            _ => return Err("codegen: cast_to_dec needs Dec target".into()),
        };
        let p = self.cx.i16_type().const_int(prec as u64, false);
        let v = match &raw.ty {
            SemType::Numeric(NumericType::Dec(_)) => {
                let sp = self.dec_slot(raw.v)?;
                self.dec_call_out("resid_dec_round", &[sp], &[p.into()])?
            }
            SemType::Numeric(NumericType::Int(w)) | SemType::Numeric(NumericType::UInt(w)) => {
                if w.bits() == 128 {
                    let i128t = self.int_type(128)?;
                    let i = raw.v.into_int_value();
                    let wide = if i.get_type().get_bit_width() == 128 {
                        i
                    } else if matches!(&raw.ty, SemType::Numeric(n) if n.is_signed()) {
                        self.builder.build_int_s_extend(i, i128t, "sext").map_err(to_err)?
                    } else {
                        self.builder.build_int_z_extend(i, i128t, "zext").map_err(to_err)?
                    };
                    self.dec_call_out("resid_dec_from_i128", &[], &[wide.into(), p.into()])?
                } else {
                    let i64t = self.cx.i64_type();
                    let i = raw.v.into_int_value();
                    let wide = if i.get_type().get_bit_width() == 64 {
                        i
                    } else if matches!(&raw.ty, SemType::Numeric(n) if n.is_signed()) {
                        self.builder.build_int_s_extend(i, i64t, "sext").map_err(to_err)?
                    } else {
                        self.builder.build_int_z_extend(i, i64t, "zext").map_err(to_err)?
                    };
                    self.dec_call_out("resid_dec_from_int", &[], &[wide.into(), p.into()])?
                }
            }
            SemType::Numeric(NumericType::Float(_)) => {
                let fd = self.cx.f64_type();
                let fl = raw.v.into_float_value();
                let dbl = if fl.get_type().get_bit_width() == 64 {
                    fl
                } else {
                    self.builder
                        .build_float_cast(fl, fd, "fcast")
                        .map_err(to_err)?
                };
                self.dec_call_out("resid_dec_from_f64", &[], &[dbl.into(), p.into()])?
            }
            SemType::Str => self.dec_call_out(
                "resid_dec_from_str",
                &[],
                &[raw.v.into_pointer_value().into(), p.into()],
            )?,
            other => return Err(format!("codegen: cannot cast {other} to Dec")),
        };
        Ok(Val {
            v,
            ty: to.clone(),
        })
    }

    /// Cast a Dec source to Int/UInt/Float (runtime checks bounds and
    /// integrality per spec §6.6a; `resid_dec_to_int` aborts on error).
    fn cast_from_dec(&mut self, raw: Val<'ctx>, to: &SemType) -> Result<Val<'ctx>, String> {
        match to {
            SemType::Numeric(NumericType::Int(w)) | SemType::Numeric(NumericType::UInt(w)) => {
                let (lo, hi): (i64, i64) = if matches!(to, SemType::Numeric(NumericType::Int(_))) {
                    if w.bits() == 64 {
                        (i64::MIN, i64::MAX)
                    } else {
                        let half = 1i64 << (w.bits() - 1);
                        (-half, half - 1)
                    }
                } else if w.bits() <= 63 {
                    (0, (1i64 << w.bits()) - 1)
                } else {
                    (0, i64::MAX)
                };
                let f = self
                    .module
                    .get_function("resid_dec_to_int")
                    .ok_or("codegen: resid_dec_to_int not declared")?;
                let sp = self.dec_slot(raw.v)?;
                let cs = self
                    .builder
                    .build_call(
                        f,
                        &[
                            sp.into(),
                            self.cx.i64_type().const_int(lo as u64, false).into(),
                            self.cx.i64_type().const_int(hi as u64, false).into(),
                        ],
                        "dectoint",
                    )
                    .map_err(to_err)?;
                let i64v = cs.try_as_basic_value().expect_basic("dec to int").into_int_value();
                let it = self.int_type(w.bits())?;
                let i = if i64v.get_type().get_bit_width() == w.bits() as u32 {
                    i64v
                } else if i64v.get_type().get_bit_width() > w.bits() as u32 {
                    self.builder.build_int_truncate(i64v, it, "trunc").map_err(to_err)?
                } else if matches!(to, SemType::Numeric(NumericType::Int(_))) {
                    self.builder.build_int_s_extend(i64v, it, "sext").map_err(to_err)?
                } else {
                    self.builder.build_int_z_extend(i64v, it, "zext").map_err(to_err)?
                };
                Ok(Val { v: i.into(), ty: to.clone() })
            }
            SemType::Numeric(NumericType::Float(w)) => {
                let f = self
                    .module
                    .get_function("resid_dec_to_f64")
                    .ok_or("codegen: resid_dec_to_f64 not declared")?;
                let sp = self.dec_slot(raw.v)?;
                let cs = self
                    .builder
                    .build_call(f, &[sp.into()], "dectof")
                    .map_err(to_err)?;
                let dbl = cs
                    .try_as_basic_value()
                    .expect_basic("dec to float")
                    .into_float_value();
                let ft = self.float_type(w.bits())?;
                let fl = if dbl.get_type().get_bit_width() == w.bits() as u32 {
                    dbl
                } else {
                    self.builder.build_float_cast(dbl, ft, "fcast").map_err(to_err)?
                };
                Ok(Val { v: fl.into(), ty: to.clone() })
            }
            _ => Err(format!("codegen: cannot cast Dec to {to}")),
        }
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
                    NumericType::Float(FloatWidth::F128) => (
                        "Float128ToString",
                        Numeric::Float(resid_ir::FloatWidth::F128),
                    ),
                    NumericType::Float(_) => (
                        "FloatToString",
                        Numeric::Float(resid_ir::FloatWidth::F64),
                    ),
                    // Dec(N) prints in fixed notation with all N significant
                    // digits, trailing zeros preserved (spec §6.6a).
                    NumericType::Dec(_) => {
                        let sp = self.dec_slot(raw.v)?;
                        let f = self
                            .module
                            .get_function("resid_dec_to_string")
                            .ok_or("codegen: resid_dec_to_string not declared")?;
                        let cs = self
                            .builder
                            .build_call(f, &[sp.into()], "dstr")
                            .map_err(to_err)?;
                        let v = cs.try_as_basic_value().expect_basic("dec str");
                        return Ok(v.into_pointer_value());
                    }
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

    /// Lower a trusted provider call `provider.verb(args)` (spec §32).
    ///
    /// Dispatch table mirrors `resid_type::PROVIDER_VERBS`. To add a verb:
    /// add the runtime helper in `resid_rt.c`, declare it in
    /// `declare_runtime`, and add a `(provider, verb) -> runtime name` arm
    /// here. Result coercion: bool results are zextended i1 → i8 (the C ABI
    /// the runtime helpers return); lists/strings pass through as pointers.
    fn lower_provider_call(
        &mut self,
        sc: &mut Scope<'ctx>,
        provider: &Id,
        verb: &Id,
        args: &[Box<Expr>],
    ) -> Result<Val<'ctx>, String> {
        let rt_name = match (provider.0.as_str(), verb.0.as_str()) {
            ("filesystem", "exists") => "resid_fs_exists",
            ("filesystem", "list_dir") => "resid_fs_list_dir",
            ("filesystem", "read_all") => "resid_fs_read_all",
            ("filesystem", "write_all") => "resid_fs_write_all",
            ("filesystem", "open") => "resid_fs_open",
            ("filesystem", "read_handle") => "resid_fs_read_handle",
            ("filesystem", "close") => "resid_fs_close",
            ("environment", "get") => "resid_env_get",
            ("environment", "has") => "resid_env_has",
            ("args", "count") => "resid_args_count",
            ("args", "get") => "resid_args_get",
            ("process", "run") => "resid_process_run",
            ("git", "rev") => "resid_git_rev",
            ("git", "branch") => "resid_git_branch",
            (p, v) => return Err(format!("codegen: unknown provider call `{p}.{v}`")),
        };
        let f = self
            .module
            .get_function(rt_name)
            .ok_or_else(|| format!("codegen: `{rt_name}` not declared"))?;
        let mut llargs: Vec<BasicMetadataValueEnum<'ctx>> = Vec::new();
        for a in args {
            let v = self.lower_expr(sc, a, None)?;
            llargs.push(self.as_rt_arg(v)?);
        }
        let cs = self.builder.build_call(f, &llargs, rt_name).map_err(to_err)?;
        let v = cs.try_as_basic_value().expect_basic("provider call");
        // Recover the checker's return type to coerce appropriately.
        let ret = resid_type::provider_verbs()
            .iter()
            .find(|(p, vv, _, _)| p == &provider.0 && vv == &verb.0)
            .map(|(_, _, _, r)| r.clone())
            .unwrap_or(SemType::Str);
        match &ret {
            SemType::Bool => {
                // The C runtime returns Bool as i8; narrow to i1 so branch
                // conditions and logic ops see the type LLVM expects.
                let i8v = v.into_int_value();
                let b = self
                    .builder
                    .build_int_truncate(i8v, self.cx.bool_type(), "boolnarrow")
                    .map_err(to_err)?;
                Ok(Val {
                    v: b.into(),
                    ty: SemType::Bool,
                })
            }
            SemType::Numeric(NumericType::Int(IntWidth::B64)) => Ok(Val {
                v: v.into_int_value().into(),
                ty: SemType::Numeric(NumericType::Int(IntWidth::B64)),
            }),
            SemType::Str => Ok(Val {
                v: v.into_pointer_value().into(),
                ty: SemType::Str,
            }),
            SemType::List(_) => Ok(Val {
                v: v.into_pointer_value().into(),
                ty: ret.clone(),
            }),
            SemType::File => Ok(Val {
                v: v.into_pointer_value().into(),
                ty: SemType::File,
            }),
            other => Err(format!(
                "codegen: provider call returns unsupported type {other}"
            )),
        }
    }

    /// Lower `spawn (caps) { body }` (spec §19): compile the body as a worker
    /// function that receives the captured outer-scope values boxed in a
    /// `ResidVal` (tag 0), run it on a fresh pthread via `resid_spawn`, and
    /// join before yielding `Result(T, RegionError)` — always `Ok(T)` for now
    /// (child failure → `Err(RegionError)` is the future abort-catchable path).
    fn lower_spawn(
        &mut self,
        sc: &mut Scope<'ctx>,
        e: &Expr,
        body: &Block,
    ) -> Result<Val<'ctx>, String> {
        let result_ty = resid_type::infer_expr_ctx(e, &self.env(sc), &self.sigs, &self.types)
            .map_err(|er| format!("codegen: spawn: {er}"))?;
        // Extract the body return type T from Result(T, RegionError).
        let body_ty = match &result_ty {
            SemType::Sum { variants, .. } => variants[0].1.clone().ok_or("spawn Ok variant has no type")?,
            other => return Err(format!("codegen: spawn body type is not a Sum, found {other}")),
        };
        // Capture every outer-scope binding the body references, by value.
        // Resid forbids shadowing, so a body-local binding can never collide
        // with an outer name: filtering by `sc.vars` is exact.
        let mut ids = Vec::new();
        collect_ids_block(body, &mut ids);
        let mut captures: Vec<(String, SemType)> = Vec::new();
        for id in ids {
            if captures.iter().any(|(n, _)| *n == id) {
                continue;
            }
            if let Some((_, ty)) = sc.vars.get(&id) {
                captures.push((id, ty.clone()));
            }
        }

        self.spawn_ctr += 1;
        let fname = format!("spawn_worker_{}", self.spawn_ctr);
        let ptrt = self.cx.ptr_type(AddressSpace::default());
        let fty = ptrt.fn_type(&[ptrt.into()], false);
        let worker = self.module.add_function(&fname, fty, None);
        let save_fn = self.cur_fn;
        let save_bb = self.builder.get_insert_block();
        let save_ret = self.cur_ret.take();
        let save_spawn = self.in_spawn_worker;

        self.cur_fn = Some(worker);
        self.in_spawn_worker = true;
        let entry = self.cx.append_basic_block(worker, "entry");
        self.builder.position_at_end(entry);
        let captures_arg = worker.get_first_param().unwrap().into_pointer_value();
        let mut wsc = Scope::new();
        for (i, (name, ty)) in captures.iter().enumerate() {
            let idx = self.cx.i64_type().const_int(i as u64, false);
            let v = self.load_capture(captures_arg.into(), idx, ty)?;
            let ll = self.llvm_type(ty)?;
            let ptr = self.builder.build_alloca(ll, name).map_err(to_err)?;
            self.builder.build_store(ptr, v.v).map_err(to_err)?;
            wsc.vars.insert(name.clone(), (ptr, ty.clone()));
        }
        let (_, tail, spawn_ret) = self.lower_block_with_tail(&mut wsc, body, true)?;
        // Determine the value to return: explicit `return` wins over tail expr.
        let ret_val = spawn_ret.or(tail);
        if let Some(v) = ret_val {
            // If the body's inferred type differs from the expected type
            // (e.g. Int(128) inferred from literal 7 but the caller expects
            // Int(64)), cast before boxing and wrapping in Ok.
            let v = if v.ty != body_ty {
                self.cast_val(v, &body_ty)?
            } else {
                v
            };
            // Worker returns the Result's Ok variant (tag 0) containing the
            // body's value. The payload must be a boxed value (pointer), so
            // box the scalar first.
            let boxed_payload = self.box_scalar(v)?;
            let region_error = SemType::Struct {
                name: "RegionError".into(),
                fields: vec![("message".into(), SemType::Str)],
            };
            let result_sum = SemType::Sum {
                name: "Result".into(),
                variants: vec![("Ok".into(), Some(body_ty.clone())), ("Err".into(), Some(region_error))],
            };
            let ok = self.build_constructor(0, &result_sum, vec![boxed_payload])?;
            self.builder.build_return(Some(&ok.v)).map_err(to_err)?;
        } else if self
            .builder
            .get_insert_block()
            .map_or(true, |bb| bb.get_terminator().is_none())
        {
            // Empty body -> Ok unit? For now null (parent will get null = Err path?).
            // But Result(T, E) requires a value. This shouldn't happen for valid code.
            self.builder
                .build_return(Some(&ptrt.const_null()))
                .map_err(to_err)?;
        }

        self.cur_fn = save_fn;
        self.in_spawn_worker = save_spawn;
        self.cur_ret = save_ret;
        if let Some(bb) = save_bb {
            self.builder.position_at_end(bb);
        }

        // Build the capture box (tag 0) in the parent.
        let cap_box = if captures.is_empty() {
            ptrt.const_null().as_basic_value_enum()
        } else {
            let arr_ty = ptrt.array_type(captures.len() as u32);
            // sizeof(ptr) * captures.len() — each slot is a ptr (8 bytes on 64-bit).
            let ptr_bytes: u64 = 8;
            let malloc_size = self
                .cx
                .i64_type()
                .const_int((captures.len() as u64) * ptr_bytes, false);
            let heap_caps = self
                .rt_call("resid_malloc", vec![malloc_size.into()])?
                .into_pointer_value();
            for (i, (_, ty)) in captures.iter().enumerate() {
                let g = unsafe {
                    self.builder
                        .build_in_bounds_gep(
                            arr_ty,
                            heap_caps,
                            &[
                                self.cx.i32_type().const_int(0, false),
                                self.cx.i32_type().const_int(i as u64, false),
                            ],
                            "cap",
                        )
                        .map_err(to_err)?
                };
                let (ptr, _) = sc.vars.get(&captures[i].0).unwrap();
                let raw = self
                    .builder
                    .build_load(self.llvm_type(ty)?, *ptr, &captures[i].0)
                    .map_err(to_err)?;
                let boxed = self.box_scalar(Val {
                    v: raw,
                    ty: ty.clone(),
                })?;
                self.builder.build_store(g, boxed).map_err(to_err)?;
            }
            heap_caps.as_basic_value_enum()
        };
        let v = self.rt_call(
            "resid_spawn",
            vec![worker.as_global_value().as_pointer_value().into(), cap_box],
        )?;
        Ok(Val { v, ty: result_ty })
    }

    /// Lower `with (Type h = expr) { body }` (spec §16): acquire each handle
    /// by evaluating its init, run `body` with the handle bound, then release
    /// every handle in reverse binding order (`resid_handle_release`). Returns
    /// the body's tail value (phi-joined) or Bool zero for an empty body.
    fn lower_with(
        &mut self,
        sc: &mut Scope<'ctx>,
        bindings: &[WithBinding],
        body: &Block,
    ) -> Result<Val<'ctx>, String> {
        let fv = self
            .cur_fn
            .ok_or_else(|| "codegen: with outside a function".to_string())?;

        // Acquire each handle: alloca a pointer slot, store the boxed handle
        // value from the init, and bind the name in the body scope.
        let ptr_ll = self.cx.ptr_type(AddressSpace::default());
        let mut acquired: Vec<(String, PointerValue<'ctx>)> = Vec::new();
        for b in bindings {
            let ty = resid_type::resolve_type_ctx(&b.type_, &self.types)
                .ok_or_else(|| "codegen: unknown with-binding type".to_string())?;
            let v = self.lower_expr(sc, &b.init, None)?;
            let v = self.cast_val(v, &ty)?;
            let slot = self
                .builder
                .build_alloca(ptr_ll, &b.name.0)
                .map_err(to_err)?;
            self.builder.build_store(slot, v.v).map_err(to_err)?;
            sc.vars.insert(b.name.0.clone(), (slot, ty));
            acquired.push((b.name.0.clone(), slot));
        }

        let body_bb = self.cx.append_basic_block(fv, "with_body");
        let merge_bb = self.cx.append_basic_block(fv, "with_merge");
        self.builder
            .build_unconditional_branch(body_bb)
            .map_err(to_err)?;

        self.builder.position_at_end(body_bb);
        let (terminated, tail, _) = self.lower_block_with_tail(sc, body, true)?;
        let reaches = if terminated {
            None
        } else {
            let from = self.builder.get_insert_block().unwrap();
            self.builder
                .build_unconditional_branch(merge_bb)
                .map_err(to_err)?;
            Some(from)
        };

        // Cleanup runs in the merge block after the body has completed —
        // reverse binding order (spec §16 RAII).
        self.builder.position_at_end(merge_bb);
        let release = self
            .module
            .get_function("resid_handle_release")
            .ok_or("codegen: missing resid_handle_release decl")?;
        for (name, slot) in acquired.iter().rev() {
            let v = self
                .builder
                .build_load(ptr_ll, *slot, name)
                .map_err(to_err)?;
            self.builder
                .build_call(release, &[v.into()], "release")
                .map_err(to_err)?;
        }

        let join_ty = tail.as_ref().map(|v| v.ty.clone()).unwrap_or(SemType::Bool);
        let ll = self.llvm_type(&join_ty)?;
        let tv = self.cast_val(tail.unwrap_or_else(|| self.zero_val()), &join_ty)?;
        let theta = match reaches {
            Some(fb) => {
                let phi = self.builder.build_phi(ll, "with").map_err(to_err)?;
                phi.add_incoming(&[(&tv.v, fb)]);
                phi.as_basic_value()
            }
            None => {
                // Body terminated (early return) — the merge block is dead but
                // still needs a terminator for module verification.
                self.builder.build_unreachable().map_err(to_err)?;
                tv.v
            }
        };
        Ok(Val { v: theta, ty: join_ty })
    }

    /// Prepare a lowered value as a C-ABI runtime argument: Str/Bytes/list/
    /// struct pointers pass through; Bool widens to i8.
    fn as_rt_arg(&mut self, v: Val<'ctx>) -> Result<BasicMetadataValueEnum<'ctx>, String> {
        match &v.ty {
            SemType::Bool => {
                let i = v.v.into_int_value();
                let b8 = self
                    .builder
                    .build_int_z_extend(i, self.cx.i8_type(), "bool_to_i8")
                    .map_err(to_err)?;
                Ok(b8.into())
            }
            SemType::Str
            | SemType::Bytes
            | SemType::List(_)
            | SemType::Slice(_)
            | SemType::Struct { .. }
            | SemType::Sum { .. }
            | SemType::Ptr
            | SemType::SourceLoc
            | SemType::File => Ok(v.v.into_pointer_value().into()),
            SemType::Numeric(n) => {
                let n = *n;
                let w = self.widen(v, n)?;
                Ok(w.into())
            }
            _ => Err(format!("codegen: unsupported rt arg type {}", v.ty)),
        }
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
        // Structured spawn (spec §19): pthread create + join of a worker.
        self.decl_rt("resid_spawn", vec![ptr.into(), ptr.into()], ptr.into());
        self.decl_rt("resid_malloc", vec![i64t.into()], ptr.into());
        self.decl_rt("resid_box_i64", vec![i64t.into()], ptr.into());
        self.decl_rt("resid_box_f64", vec![f64t.into()], ptr.into());
        self.decl_rt("resid_box_bool", vec![i8t.into()], ptr.into());
        self.decl_rt("resid_unbox_i64", vec![ptr.into()], i64t.into());
        self.decl_rt("resid_unbox_f64", vec![ptr.into()], f64t.into());
        self.decl_rt("resid_unbox_bool", vec![ptr.into()], i8t.into());
        self.decl_rt("resid_list_len", vec![ptr.into()], i64t.into());
        self.decl_rt("resid_list_concat", vec![ptr.into(), ptr.into()], ptr.into());
        self.decl_rt_void("resid_abort", vec![ptr.into()]);
        // Checked add/sub overflow trap (spec v3.2 §6.1).
        self.decl_rt_void("resid_arith_overflow", vec![]);
        self.decl_rt_void("resid_index_abort", vec![i64t.into(), i64t.into()]);
        // String concatenation (f-string interpolation, Str + Str).
        self.decl_rt("resid_str_concat", vec![ptr.into(), ptr.into()], ptr.into());
        // String equality (Str == Str / Str != Str) for the bootstrap lexer.
        self.decl_rt("resid_str_eq", vec![ptr.into(), ptr.into()], i8t.into());
        // Trusted providers (spec §32): filesystem, environment, git.
        // Names must match the `resid_<provider>_<verb>` helpers in resid_rt.c.
        self.decl_rt("resid_fs_exists", vec![ptr.into()], i8t.into());
        self.decl_rt("resid_fs_list_dir", vec![ptr.into()], ptr.into());
        self.decl_rt("resid_fs_read_all", vec![ptr.into()], ptr.into());
        self.decl_rt("resid_fs_write_all", vec![ptr.into(), ptr.into()], i8t.into());
        self.decl_rt("resid_fs_open", vec![ptr.into()], ptr.into());
        self.decl_rt("resid_fs_read_handle", vec![ptr.into()], ptr.into());
        self.decl_rt("resid_fs_close", vec![ptr.into()], i8t.into());
        // Handle release (spec §16): frees an acquired handle's box (closing
        // any wrapped FILE*); called by `with` blocks in reverse binding order.
        self.decl_rt_void("resid_handle_release", vec![ptr.into()]);
        self.decl_rt("resid_env_get", vec![ptr.into()], ptr.into());
        self.decl_rt("resid_env_has", vec![ptr.into()], i8t.into());
        self.decl_rt("resid_args_count", vec![], i64t.into());
        // UTC civil timestamp YYYYMMDDHHMMSS for x509 validity checks.
        self.decl_rt("resid_utc_now_civil", vec![], i64t.into());
        self.decl_rt("resid_args_get", vec![i64t.into()], ptr.into());
        self.decl_rt("resid_process_run", vec![ptr.into()], i64t.into());
        self.decl_rt("resid_git_rev", vec![ptr.into()], ptr.into());
        self.decl_rt("resid_git_branch", vec![], ptr.into());
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
        // Wide (256/512-bit) integer stringification — C ABI takes u64 limbs.
        self.decl_rt(
            "Int256ToString",
            vec![i64t.into(), i64t.into(), i64t.into(), i64t.into()],
            ptr.into(),
        );
        self.decl_rt(
            "UInt256ToString",
            vec![i64t.into(), i64t.into(), i64t.into(), i64t.into()],
            ptr.into(),
        );
        self.decl_rt(
            "Int512ToString",
            vec![
                i64t.into(), i64t.into(), i64t.into(), i64t.into(),
                i64t.into(), i64t.into(), i64t.into(), i64t.into(),
            ],
            ptr.into(),
        );
        self.decl_rt(
            "UInt512ToString",
            vec![
                i64t.into(), i64t.into(), i64t.into(), i64t.into(),
                i64t.into(), i64t.into(), i64t.into(), i64t.into(),
            ],
            ptr.into(),
        );
        // Dec(N) exact-decimal runtime (spec §6.6a). `resid_dec` crosses the
        // LLVM boundary as pointers (out-ptr for results, const ptrs for
        // operands) — clang and LLVM disagree on by-value aggregate ABI, so
        // the struct is never passed by value.
        let i16t = self.cx.i16_type();
        let i32t = self.cx.i32_type();
        self.decl_rt_void("resid_dec_from_digits", vec![ptr.into(), ptr.into(), i32t.into(), i16t.into()]);
        self.decl_rt_void("resid_dec_from_int", vec![ptr.into(), i64t.into(), i16t.into()]);
        self.decl_rt_void("resid_dec_from_i128", vec![ptr.into(), self.int_type(128).unwrap().into(), i16t.into()]);
        self.decl_rt_void("resid_dec_from_str", vec![ptr.into(), ptr.into(), i16t.into()]);
        self.decl_rt_void("resid_dec_from_f64", vec![ptr.into(), f64t.into(), i16t.into()]);
        self.decl_rt_void("resid_dec_round", vec![ptr.into(), ptr.into(), i16t.into()]);
        self.decl_rt_void("resid_dec_neg", vec![ptr.into(), ptr.into()]);
        self.decl_rt_void("resid_dec_add", vec![ptr.into(), ptr.into(), ptr.into()]);
        self.decl_rt_void("resid_dec_sub", vec![ptr.into(), ptr.into(), ptr.into()]);
        self.decl_rt_void("resid_dec_mul", vec![ptr.into(), ptr.into(), ptr.into()]);
        self.decl_rt_void("resid_dec_div", vec![ptr.into(), ptr.into(), ptr.into()]);
        self.decl_rt("resid_dec_cmp", vec![ptr.into(), ptr.into()], i32t.into());
        self.decl_rt("resid_dec_to_string", vec![ptr.into()], ptr.into());
        self.decl_rt("resid_dec_to_int", vec![ptr.into(), i64t.into(), i64t.into()], i64t.into());
        self.decl_rt("resid_dec_to_f64", vec![ptr.into()], f64t.into());
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

        // Wide (256/512-bit) integer stringification. The C ABI has no native
        // 256-bit type, so decompose the value into little-endian u64 limbs and
        // call the runtime helper (declared with `u64` params in
        // `declare_wide_tostring`).
        if let Some(bits) = ["Int256ToString", "UInt256ToString", "Int512ToString", "UInt512ToString"]
            .iter()
            .find(|n| *n == name)
            .and_then(|n| {
                if n.ends_with("256ToString") {
                    Some(256)
                } else {
                    Some(512)
                }
            })
        {
            if args.len() != 1 {
                return Err(format!("codegen: `{name}` expects one argument"));
            }
            let (_, a) = &args[0];
            let target_sem = if name.starts_with("UInt") {
                SemType::Numeric(NumericType::UInt(IntWidth::from_bits(bits).unwrap()))
            } else {
                SemType::Numeric(NumericType::Int(IntWidth::from_bits(bits).unwrap()))
            };
            let target = if name.starts_with("UInt") {
                NumericType::UInt(IntWidth::from_bits(bits).unwrap())
            } else {
                NumericType::Int(IntWidth::from_bits(bits).unwrap())
            };
            let av = self.lower_expr(sc, a, Some(target))?;
            let av = self.widen_call_arg(av, &target_sem)?;
            let iv = av.v.into_int_value();
            let it = self.int_type(bits)?;
            let i64t = self.cx.i64_type();
            let mut limbs: Vec<BasicMetadataValueEnum<'ctx>> = Vec::new();
            let mut cur = iv;
            for _ in 0..(bits / 64) {
                let lo = self
                    .builder
                    .build_int_truncate(cur, i64t, "limb")
                    .map_err(to_err)?;
                limbs.push(lo.into());
                let shifted = self
                    .builder
                    .build_right_shift(cur, it.const_int(64, false), false, "shr")
                    .map_err(to_err)?;
                cur = shifted;
            }
            let f = self
                .module
                .get_function(name)
                .ok_or_else(|| format!("codegen: `{name}` not declared"))?;
            let cs = self.builder.build_call(f, &limbs, name).map_err(to_err)?;
            let v = cs
                .try_as_basic_value()
                .expect_basic("wide tostring");
            return Ok(Val {
                v,
                ty: SemType::Str,
            });
        }

        // Conversion helpers (spec §6.7 and §6.6a). `dN` is synthesized by
        // the type checker — no extern exists — so any `dN` call not shadowed
        // by a user definition is a Dec conversion. `iN`/`uN`/`fN` are extern
        // C functions for scalar args, but a Dec argument must be converted
        // through the runtime instead (the extern expects an i64/double).
        if let Some((kind, n)) = Self::parse_conv_helper(name) {
            if kind == 'd' {
                if self.module.get_function(name).is_none() {
                    return self.lower_dec_conversion(sc, kind, n, args);
                }
            } else if args.len() == 1 {
                let arg_ty =
                    resid_type::infer_expr_ctx(&args[0].1, &self.env(sc), &self.sigs, &self.types)
                        .unwrap_or(SemType::Bool);
                if matches!(arg_ty, SemType::Numeric(NumericType::Dec(_))) {
                    return self.lower_dec_conversion(sc, kind, n, args);
                }
            }
        }

        // Resolve named arguments: map each arg's name (if provided) to the
        // corresponding position in the function's param list.
        let (resolved_args, sig) = self.resolve_call_args(name, args)?;

        let fnv = self
            .module
            .get_function(&self.decl_name(name))
            .ok_or_else(|| format!("codegen: no such function `{name}`"))?;
        let mut llargs: Vec<BasicMetadataValueEnum<'ctx>> = Vec::new();
        for (i, (_, a)) in resolved_args.iter().enumerate() {
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

    /// Match a conversion-helper name (`d34`, `i32`, `u64`, `f128`) to its
    /// kind letter and numeric parameter.
    fn parse_conv_helper(name: &str) -> Option<(char, u32)> {
        let mut cs = name.chars();
        let k = cs.next()?;
        if !matches!(k, 'd' | 'i' | 'u' | 'f') {
            return None;
        }
        let rest = &name[k.len_utf8()..];
        if rest.is_empty() || !rest.bytes().all(|b| b.is_ascii_digit()) {
            return None;
        }
        let n: u32 = rest.parse().ok()?;
        if n == 0 {
            return None;
        }
        Some((k, n))
    }

    /// Lower a conversion-helper call whose argument is (or becomes) a Dec
    /// value: `dN` from Dec/Int/Str, `iN`/`uN`/`fN` from Dec (spec §6.6a).
    fn lower_dec_conversion(
        &mut self,
        sc: &mut Scope<'ctx>,
        kind: char,
        n: u32,
        args: &[(Option<Id>, Expr)],
    ) -> Result<Val<'ctx>, String> {
        if args.len() != 1 {
            return Err(format!("codegen: `{kind}{n}` expects one argument"));
        }
        let (_, a) = &args[0];
        let want = match kind {
            'd' => None,
            'i' => Some(NumericType::Int(
                IntWidth::from_bits(n as u16).ok_or("codegen: invalid `iN` width")?,
            )),
            'u' => Some(NumericType::UInt(
                IntWidth::from_bits(n as u16).ok_or("codegen: invalid `uN` width")?,
            )),
            'f' => Some(NumericType::Float(
                FloatWidth::from_bits(n as u16).ok_or("codegen: invalid `fN` width")?,
            )),
            _ => unreachable!(),
        };
        let av = self.lower_expr(sc, a, want)?;
        if kind == 'd' {
            self.cast_to_dec(av, &SemType::Numeric(NumericType::Dec(n as u16)))
        } else {
            self.cast_from_dec(av, &SemType::Numeric(want.expect("want")))
        }
    }

    /// Resolve named arguments and fill in default parameters, returning the
    /// args reordered into positional form plus the selected FunctionSig.
    fn resolve_call_args(
        &self,
        name: &str,
        args: &[(Option<Id>, Expr)],
    ) -> Result<(Vec<(Option<Id>, Expr)>, FunctionSig), String> {
        // Pick the best overload — we don't have full type info at this
        // stage, so use the first matching signature by name.
        let sig = self.sigs.get(name).cloned().unwrap_or(FunctionSig {
            name: name.to_string(),
            params: Vec::new(),
            param_names: Vec::new(),
            param_defaults: Vec::new(),
            ret: SemType::Bool,
        });

        let total_params = sig.params.len();
        let provided = args.len();

        if provided > total_params {
            return Err(format!(
                "codegen: `{}` expects {} args, got {}",
                name,
                total_params,
                provided
            ));
        }

        // If all args are provided positionally, return as-is.
        if provided == total_params {
            return Ok((args.to_vec(), sig));
        }

        // Resolve by name: build a map from param name → expr.
        let mut by_name: HashMap<String, (Option<Id>, Expr)> = HashMap::new();
        let mut positional = Vec::new();
        for (name_opt, expr) in args {
            match name_opt {
                Some(n) => {
                    by_name.insert(n.0.clone(), (name_opt.clone(), expr.clone()));
                }
                None => {
                    positional.push((name_opt.clone(), expr.clone()));
                }
            }
        }

        // Build resolved args in param order.
        let mut resolved = Vec::new();
        let mut used_positional = 0;
        for i in 0..total_params {
            if let Some(entry) = by_name.get(&sig.param_names.get(i).cloned().unwrap_or_default()) {
                resolved.push(entry.clone());
            } else if used_positional < positional.len() {
                resolved.push(positional[used_positional].clone());
                used_positional += 1;
            } else if let Some(default) = sig.param_defaults.get(i).and_then(|d| d.clone()) {
                resolved.push((None, Expr { kind: default, span: resid_lexer::token::Span { file: "<default>".into(), line: 0, col_start: 0, col_end: 0 } }));
            } else {
                return Err(format!(
                    "codegen: `{}` param `{}` has no default and was not provided",
                    name,
                    sig.param_names.get(i).map(|s| s.as_str()).unwrap_or("?")
                ));
            }
        }

        Ok((resolved, sig))
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

    /// Load a captured value from a raw pointer array (spawn worker captures).
    /// The array contains boxed values; each element is a ResidVal*.
    fn load_capture(
        &mut self,
        arr: BasicValueEnum<'ctx>,
        idx: IntValue<'ctx>,
        fty: &SemType,
    ) -> Result<Val<'ctx>, String> {
        let ptr = arr.into_pointer_value();
        // The captures array is a raw void** allocated by resid_malloc.
        // Each slot holds a ResidVal* (pointer to boxed value).
        // Use byte-offset GEP on the raw ptr.
        let ptrsize = self.cx.i64_type().const_int(8, false);
        let byte_off = self
            .builder
            .build_int_mul(idx, ptrsize, "byte_off")
            .map_err(to_err)?;
        let g = unsafe {
            self.builder
                .build_in_bounds_gep(
                    self.cx.i8_type(),
                    ptr,
                    &[byte_off],
                    "cap",
                )
                .map_err(to_err)?
        };
        let loaded = self.builder.build_load(self.cx.ptr_type(AddressSpace::default()), g, "cap_val").map_err(to_err)?;
        match fty {
            SemType::Numeric(n) if !n.is_float() => {
                let raw = self.rt_call("resid_unbox_i64", vec![loaded])?;
                Ok(Val {
                    v: raw,
                    ty: SemType::Numeric(NumericType::Int(
                        resid_ir::IntWidth::from_bits(64).unwrap(),
                    )),
                })
            }
            SemType::Numeric(_) => {
                let raw = self.rt_call("resid_unbox_f64", vec![loaded])?;
                Ok(Val {
                    v: raw,
                    ty: SemType::Numeric(NumericType::Float(resid_ir::FloatWidth::F64)),
                })
            }
            SemType::Bool => {
                let raw = self.rt_call("resid_unbox_bool", vec![loaded])?;
                Ok(Val {
                    v: raw.into_int_value().into(),
                    ty: SemType::Bool,
                })
            }
            _ => Ok(Val {
                v: loaded,
                ty: fty.clone(),
            }),
        }
    }

    /// Extract a payload value from a box slot pointer (result of `resid_box_slot`).
    /// Used by sum-type casting to read the variant payload before casting.
    fn extract_payload(&mut self, slot: BasicValueEnum<'ctx>, fty: &SemType) -> Result<Val<'ctx>, String> {
        match fty {
            SemType::Numeric(n) if !n.is_float() => {
                let raw = self.rt_call("resid_unbox_i64", vec![slot])?;
                Ok(Val {
                    v: raw,
                    ty: SemType::Numeric(NumericType::Int(
                        resid_ir::IntWidth::from_bits(64).unwrap(),
                    )),
                })
            }
            SemType::Numeric(_) => {
                let raw = self.rt_call("resid_unbox_f64", vec![slot])?;
                Ok(Val {
                    v: raw,
                    ty: SemType::Numeric(NumericType::Float(resid_ir::FloatWidth::F64)),
                })
            }
            SemType::Bool => {
                let raw = self.rt_call("resid_unbox_bool", vec![slot])?;
                Ok(Val {
                    v: raw.into_int_value().into(),
                    ty: SemType::Bool,
                })
            }
            // Pointer types (Str, List, Struct, Sum) — slot is already the pointer.
            _ => Ok(Val {
                v: slot,
                ty: fty.clone(),
            }),
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
            .or_else(|| resid_type::type_from_name(&name.0))
            .ok_or_else(|| format!("codegen: unknown type `{}`", name.0))?;
        let SemType::Struct { fields: defs, .. } = &st else {
            return Err(format!("codegen: `{}` is not a struct", name.0));
        };
        let mut slots = Vec::new();
        for (fname, fty) in defs {
            let (_, vexpr) = fields
                .iter()
                .find(|(n, _)| n.0 == *fname)
                .ok_or_else(|| format!("codegen: missing field `{}`", fname))?;
            let v = if matches!(&vexpr.kind, ExprKind::ListLit(elems) if elems.is_empty())
                && matches!(fty, SemType::List(_))
            {
                self.build_constructor(0, fty, Vec::new())?
            } else {
                self.lower_expr(sc, vexpr, None)?
            };
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
        // Bounds check: unsigned idx < element count, else runtime abort.
        // List indexing is unchecked in the runtime, so an out-of-range
        // index here would otherwise be silent memory corruption.
        let len_v = self.rt_call("resid_list_len", vec![list_val])?;
        let len_i = len_v.into_int_value();
        let cur_fn = self
            .cur_fn
            .ok_or_else(|| "codegen: index outside a function".to_string())?;
        let ok_bb = self.cx.append_basic_block(cur_fn, "index_ok");
        let oob_bb = self.cx.append_basic_block(cur_fn, "index_oob");
        let cmp = self
            .builder
            .build_int_compare(inkwell::IntPredicate::ULT, idx, len_i, "index_in_bounds")
            .map_err(to_err)?;
        self.builder
            .build_conditional_branch(cmp, ok_bb, oob_bb)
            .map_err(to_err)?;
        self.builder.position_at_end(oob_bb);
        let abort = self
            .module
            .get_function("resid_index_abort")
            .ok_or("codegen: missing resid_index_abort decl")?;
        self.builder
            .build_call(abort, &[idx.into(), len_i.into()], "index_oob_abort")
            .map_err(to_err)?;
        self.builder.build_unreachable().map_err(to_err)?;
        self.builder.position_at_end(ok_bb);
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
            ("concat", SemType::List(elem)) if args.len() == 1 => {
                let av = self.lower_expr(sc, &args[0], None)?;
                let v = self.rt_call("resid_list_concat", vec![tv.v.into(), av.v.into()])?;
                Ok(Val {
                    v,
                    ty: SemType::List(elem.clone()),
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
        BasicTypeEnum::StructType(s) => s.fn_type(params, false),
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
