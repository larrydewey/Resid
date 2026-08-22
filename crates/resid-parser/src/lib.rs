//! Resid language parser — converts token stream into an AST.
//!
//! Implements all EBNF productions from spec §28 with
//! precedence climbing for operators (spec §27).

mod alias;
mod ast;
mod parser;
mod providers;
mod resolve;

pub use ast::*;
pub use parser::*;
pub use providers::{collect_provider_calls, ProviderUse};
pub use resolve::{resolve_unit, resolve_unit_with, DependencyMap, ImportError};
