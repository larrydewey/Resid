//! End-to-end tests: `residc <file> build|run` produces a runnable native
//! binary (requires clang on PATH, matching the repo's LLVM requirement).

use std::process::Command;

fn residc_bin() -> &'static str {
    env!("CARGO_BIN_EXE_residc")
}

#[test]
fn run_hello_prints_and_exits_zero() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("hello.resid");
    std::fs::write(
        &file,
        "Int main() {\n    println(\"hello from resid\");\n    return 0;\n}\n",
    )
    .unwrap();

    let out = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("failed to run residc run");

    let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
    let code = out.status.code().unwrap();
    assert_eq!(
        code,
        0,
        "residc failed: {}",
        String::from_utf8_lossy(&out.stderr)
    );
    assert_eq!(
        stdout.trim(),
        "hello from resid",
        "unexpected program output: {stdout:?}"
    );

    // A non-zero return must propagate out of `run`.
    let fail = dir.join("fail.resid");
    std::fs::write(&fail, "Int main() {\n    return 7;\n}\n").unwrap();
    let out2 = Command::new(residc_bin())
        .arg(&fail)
        .arg("run")
        .output()
        .unwrap();
    assert_eq!(out2.status.code(), Some(7));

    let _ = std::fs::remove_dir_all(&dir);
}

/// Lists, structs, and Option matches lower to the boxed runtime and run.
#[test]
fn run_composite_values() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-comp-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("composites.resid");
    std::fs::write(
        &file,
        r#"type Point = { x: Int, y: Int };
Int main() {
    List(Int) xs = [10, 20, 30];
    println(IntToString(xs[1]));
    Point p = Point { x: 3, y: 4 };
    println(IntToString(p.x));
    Option(Int) mx = Some(7);
    Int out = match mx {
        Some(n) => n,
        None => 0,
    };
    println(IntToString(out));
    return 0;
}
"#,
    )
    .unwrap();

    let out = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("failed to run residc run");

    let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
    let code = out.status.code().unwrap();
    assert_eq!(
        code,
        0,
        "residc failed: {}",
        String::from_utf8_lossy(&out.stderr)
    );
    assert_eq!(
        stdout.trim(),
        "20\n3\n7",
        "unexpected program output: {stdout:?}"
    );

    let _ = std::fs::remove_dir_all(&dir);
}

/// `if`-expressions with phi joins and `while` loops lower correctly.
#[test]
fn run_if_while_control_flow() {
    let dir = std::env::temp_dir().join(format!(
        "residc-e2e-ctrl-{}",
        std::process::id()
    ));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("ctrl.resid");
    std::fs::write(
        &file,
        r#"Int main() {
    Int x = if (1 < 2) { 10; } else { 20; };
    println(IntToString(x));

    Int y = if (1 > 2) { 100; };
    println(IntToString(y));

    while (true) {
        break;
    }
    println("done");
    return 0;
}
"#,
    )
    .unwrap();

    let out = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("failed to run residc run");

    let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
    let code = out.status.code().unwrap();
    assert_eq!(
        code,
        0,
        "residc failed: {}",
        String::from_utf8_lossy(&out.stderr)
    );
    assert_eq!(
        stdout.trim(),
        "10\n0\ndone",
        "unexpected program output: {stdout:?}"
    );

    let _ = std::fs::remove_dir_all(&dir);
}

/// `comptime_print` fires during compilation (to stderr) and is dropped at
/// runtime, so the program still runs.
#[test]
fn run_comptime_print_fires_at_compile_time() {
    let dir =
        std::env::temp_dir().join(format!("residc-e2e-ctp-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("ctp.resid");
    std::fs::write(
        &file,
        "Int main() {\n    comptime_print(\"building now\");\n    println(\"ran\");\n    return 0;\n}\n",
    )
    .unwrap();

    let out = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("failed to run residc run");

    let code = out.status.code().unwrap();
    assert_eq!(
        code,
        0,
        "residc failed: {}",
        String::from_utf8_lossy(&out.stderr)
    );
    let stderr = String::from_utf8_lossy(&out.stderr).into_owned();
    assert!(
        stderr.contains("[comptime_print]"),
        "expected comptime_print to fire during compile, stderr: {stderr:?}"
    );
    let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
    assert_eq!(stdout.trim(), "ran", "unexpected runtime output: {stdout:?}");

    let _ = std::fs::remove_dir_all(&dir);
}

/// `@residual Type y = expr` (spec §9) lowers like a typed binding: the value
/// is computed at runtime and printed.
#[test]
fn run_at_residual_binding() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-atr-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("atresid.resid");
    std::fs::write(
        &file,
        r#"Int main() {
    Int src = 6;
    @residual Int x = src * 7;
    println(IntToString(x));
    return 0;
}
"#,
    )
    .unwrap();

    let out = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("failed to run residc run");

    let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
    let code = out.status.code().unwrap();
    assert_eq!(
        code,
        0,
        "residc failed: {}",
        String::from_utf8_lossy(&out.stderr)
    );
    assert_eq!(stdout.trim(), "42", "unexpected program output: {stdout:?}");

    let _ = std::fs::remove_dir_all(&dir);
}

/// `assert`/`rt_assert` pass through when conditions hold; `known`/`rt_known`
/// type-check and lower. A failing assert aborts with the message.
#[test]
fn run_assertions_and_todo() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-ast-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("asserts.resid");
    std::fs::write(
        &file,
        r#"Int main() {
    assert(1 < 2, "one is less than two");
    rt_assert(2 == 2, "two equals two");
    Int x = 42;
    known(x);
    rt_known(x);
    println("asserted ok");
    return 0;
}
"#,
    )
    .unwrap();

    let out = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("failed to run residc run");

    let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
    let code = out.status.code().unwrap();
    assert_eq!(
        code,
        0,
        "residc failed: {}",
        String::from_utf8_lossy(&out.stderr)
    );
    assert_eq!(stdout.trim(), "asserted ok", "unexpected output: {stdout:?}");

    // A failing assert must abort with the message on stderr.
    let fail = dir.join("fail.resid");
    std::fs::write(
        &fail,
        "Int main() {\n    assert(1 > 2, \"boom\");\n    return 0;\n}\n",
    )
    .unwrap();
    let out2 = Command::new(residc_bin())
        .arg(&fail)
        .arg("run")
        .output()
        .unwrap();
    assert_ne!(out2.status.code(), Some(0), "failing assert must not exit 0");
    let stderr = String::from_utf8_lossy(&out2.stderr).into_owned();
    assert!(
        stderr.contains("boom"),
        "failing assert should print message, stderr: {stderr:?}"
    );

    let _ = std::fs::remove_dir_all(&dir);
}

/// All value formatting helpers: Int/UInt/Float/Bool → Str and composites.
#[test]
fn run_value_formatting() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-fmt-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("fmt.resid");
    std::fs::write(
        &file,
        r#"type Point = { x: Int, y: Int };
    Int main() {
    // IntToString with narrowing i8 value
    Int(8) a = 42;
    println(IntToString(a));

    // FloatToString
    Float(64) pi = 3.14;
    println(FloatToString(pi));

    // BoolToString
    Bool t = true;
    Bool f = false;
    println(BoolToString(t));
    println(BoolToString(f));

    // IntToString with narrowing i32 value
    Int(32) c = 100;
    println(IntToString(c));

    // Composite: Option
    Option(Int) mx = Some(7);
    Int out = match mx {
        Some(n) => n,
        None => 0,
    };
    println(IntToString(out));

    // Composite: List with ToString
    List(Int) xs = [1, 2, 3];
    println(ToString(xs));

    // Composite: Struct with ToString
    Point p = Point { x: 3, y: 4 };
    println(ToString(p));

    // Composite: None with ToString
    Option(Int) nothing = None;
    println(ToString(nothing));

    return 0;
}
"#,
    )
    .unwrap();

    let out = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("failed to run residc run");

    let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
    let code = out.status.code().unwrap();
    assert_eq!(
        code,
        0,
        "residc failed: {}",
        String::from_utf8_lossy(&out.stderr)
    );
    // Verify all formatted values are present in output
    let lines: Vec<&str> = stdout.trim().split('\n').collect();
    assert!(lines.len() >= 8, "expected at least 8 lines, got {}:\n{}", lines.len(), stdout);
    assert!(lines[0].contains("42"), "IntToString(42): {}", lines[0]);
    assert!(lines[1].contains("3.14"), "FloatToString(3.14): {}", lines[1]);
    assert!(lines[2].contains("true"), "BoolToString(true): {}", lines[2]);
    assert!(lines[3].contains("false"), "BoolToString(false): {}", lines[3]);
    assert!(lines[4].contains("100"), "IntToString(100): {}", lines[4]);
    assert!(lines[5].contains("7"), "Some(7): {}", lines[5]);
    assert!(lines[6].contains("1"), "List(1,2,3): {}", lines[6]);
    assert!(lines[7].contains("3"), "Struct Point: {}", lines[7]);

    let _ = std::fs::remove_dir_all(&dir);
}

/// Iterating a numeric range: `0..3` half-open, `0..=2` inclusive, and a
/// nonzero start.
#[test]
fn run_range_for_in() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-range-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("range.res");
    std::fs::write(
        &file,
        r#"Int main() {
    for (Int i in 0..3) {
        println(IntToString(i));
    }
    for (Int j in 0..=2) {
        println(IntToString(j));
    }
    for (Int k in 2..5) {
        println(IntToString(k));
    }
    return 0;
}
"#,
    )
    .unwrap();

    let out = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("failed to run residc run");

    let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
    let code = out.status.code().unwrap();
    assert_eq!(
        code,
        0,
        "residc failed: {}",
        String::from_utf8_lossy(&out.stderr)
    );
    let lines: Vec<&str> = stdout.trim().split('\n').collect();
    assert_eq!(
        lines,
        vec!["0", "1", "2", "0", "1", "2", "2", "3", "4"],
        "unexpected output: {stdout:?}"
    );

    let _ = std::fs::remove_dir_all(&dir);
}

/// if-let / while-let over an `Option`: matching `Some(n)` binds `n` in the
/// then/body scope; a `None` falls through to else / skips the loop.
#[test]
fn run_if_let_and_while_let() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-iflet-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("iflet.res");
    std::fs::write(
        &file,
        r#"Int main() {
    Option(Int) a = Some(5);
    Option(Int) b = None;

    if (Some(v) = a) {
        println(IntToString(v));
    } else {
        println("none");
    }

    if (Some(v) = b) {
        println(IntToString(v));
    } else {
        println("none");
    }

    // else-if chain: first arm fails (None), second matches.
    if (Some(v) = b) {
        println(IntToString(v));
    } else if (Some(w) = a) {
        println(IntToString(w));
    } else {
        println("none");
    }

    while (Some(n) = b) {
        println(IntToString(n));
    }
    println("done");

    return 0;
}
"#,
    )
    .unwrap();

    let out = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("failed to run residc run");

    let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
    let code = out.status.code().unwrap();
    assert_eq!(
        code,
        0,
        "residc failed: {}",
        String::from_utf8_lossy(&out.stderr)
    );
    let lines: Vec<&str> = stdout.trim().split('\n').collect();
    assert_eq!(
        lines,
        vec!["5", "none", "5", "done"],
        "unexpected output: {stdout:?}"
    );

    let _ = std::fs::remove_dir_all(&dir);
}
