//! Knowledge-graph IR for Resid — Phase 2.
//!
//! Implements the enriched expression DAG, AST→IR conversion, and the
//! fixed-point reduction engine (spec §§3, 7–8, 13, 15–16, 22, 33).

#![allow(dead_code)]

pub mod types;
pub mod graph;
pub mod convert;
pub mod reduce;

pub use graph::GraphKey;
pub use types::*;
pub use graph::*;
pub use convert::*;
pub use reduce::*;
