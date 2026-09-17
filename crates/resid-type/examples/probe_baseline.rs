fn main() {
    let src = std::fs::read_to_string("examples/codegen.resid").unwrap();
    let (unit, errs) = resid_parser::Parser::parse("codegen.resid", &src);
    if !errs.is_empty() {
        eprintln!("parse errors: {:?}", &errs[..errs.len().min(5)]);
        return;
    }
    eprintln!("parsed ok, {} declarations", unit.declarations.len());
    let g = resid_type::find_growable_fields(&unit);
    eprintln!("find_growable_fields done");
    let _ = g.is_growable("x", 0, "y");
    let g2 = resid_type::find_growable_accumulators(&unit);
    eprintln!("find_growable_accumulators done");
    let _ = g2.is_growable("x", 0);
}
