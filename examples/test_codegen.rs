use inkwell::context::Context;
use resid_parser::Parser;
use resid_codegen::CodeGen;
use resid_type::check_program;

fn main() {
    let source = r#"Int main() {
    Result(Int, RegionError) r = spawn () {
        return 42;
    };
    Int out = match r {
        Ok(n) => n,
        Err(e) => 0,
    };
    println(IntToString(out));
    return 0;
}
"#;

    let file = "test.resid";
    let (unit, errors) = Parser::parse(file, source);
    for e in &errors {
        eprintln!("{}:{}:{}: error: {}", e.span.file, e.span.line, e.span.col_start, e.message);
    }
    if !errors.is_empty() {
        eprintln!("parse failed");
        return;
    }

    let type_errors = check_program(&unit);
    for e in &type_errors {
        eprintln!("{}:{}:{}: type error: {}", e.span.file, e.span.line, e.span.col_start, e.message);
    }
    if !type_errors.is_empty() {
        eprintln!("type checking failed");
        return;
    }

    let cx = Context::create();
    let mut cg = CodeGen::new(&cx, "test");
    if let Err(e) = cg.generate(&unit) {
        eprintln!("codegen error: {}", e);
        return;
    }

    // Print IR even if verification fails
    println!("{}", cg.module.print_to_string());
}
