//! Resid language parser — converts token stream into an AST.
//!
//! Implements all EBNF productions from spec §28 with
//! precedence climbing for operators (spec §27).

mod ast;
mod parser;

pub use ast::*;
pub use parser::*;
