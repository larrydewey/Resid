// binary-trees: single-threaded, same algorithm as the Benchmarks Game description.
// Each node is individually heap-allocated (Box), trees are freed after use.

struct Node {
    left: Option<Box<Node>>,
    right: Option<Box<Node>>,
}

fn bottom_up(depth: u32) -> Box<Node> {
    if depth == 0 {
        Box::new(Node { left: None, right: None })
    } else {
        Box::new(Node {
            left: Some(bottom_up(depth - 1)),
            right: Some(bottom_up(depth - 1)),
        })
    }
}

fn check(node: &Node) -> u32 {
    match (&node.left, &node.right) {
        (Some(l), Some(r)) => 1 + check(l) + check(r),
        _ => 1,
    }
}

fn main() {
    let n: u32 = std::env::args().nth(1).and_then(|s| s.parse().ok()).unwrap_or(10);
    let min_depth = 4;
    let max_depth = if min_depth + 2 > n { min_depth + 2 } else { n };

    let stretch_depth = max_depth + 1;
    let stretch = bottom_up(stretch_depth);
    println!("stretch tree of depth {}\t check: {}", stretch_depth, check(&stretch));
    drop(stretch);

    let long_lived = bottom_up(max_depth);

    let mut depth = min_depth;
    while depth <= max_depth {
        let iterations = 1u32 << (max_depth - depth + min_depth);
        let mut chk = 0u32;
        for _ in 0..iterations {
            let t = bottom_up(depth);
            chk += check(&t);
        }
        println!("{}\t trees of depth {}\t check: {}", iterations, depth, chk);
        depth += 2;
    }
    println!("long lived tree of depth {}\t check: {}", max_depth, check(&long_lived));
}
