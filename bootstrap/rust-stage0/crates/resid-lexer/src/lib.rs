//! Resid language lexer — converts source text into a stream of tokens.
//!
//! All tokens from spec §28 with span tracking (file, line, col_start, col_end).

mod lexer;
pub mod token;

pub use lexer::*;
pub use token::*;
