//! Knowledge-graph IR for Resid — Phase 2.
//!
//! Implements the enriched expression DAG, AST→IR conversion, and the
//! fixed-point reduction engine (spec §§3, 7–8, 13, 15–16, 22, 33).

#![allow(dead_code)]

pub mod convert;
pub mod graph;
pub mod reduce;
pub mod retro;
pub mod types;

pub use convert::*;
pub use graph::GraphKey;
pub use graph::*;
pub use reduce::*;
pub use retro::*;
pub use types::*;
