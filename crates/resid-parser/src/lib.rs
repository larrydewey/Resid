//! Resid language parser — converts token stream into an AST.
//!
//! Implements all EBNF productions from spec §28 with
//! precedence climbing for operators (spec §27).

mod ast;
mod parser;
mod resolve;

pub use ast::*;
pub use parser::*;
pub use resolve::{resolve_unit, resolve_unit_with, DependencyMap, ImportError};
