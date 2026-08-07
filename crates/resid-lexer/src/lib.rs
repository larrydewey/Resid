//! Resid language lexer — converts source text into a stream of tokens.
//!
//! All tokens from spec §28 with span tracking (file, line, col_start, col_end).

pub mod token;
mod lexer;

pub use token::*;
pub use lexer::*;
