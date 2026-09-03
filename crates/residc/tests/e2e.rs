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
    let file = dir.join("range.resid");
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
    let file = dir.join("iflet.resid");
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

/// Conversion helpers (spec §6.7): i32, u16, f32, f64, isize, usize narrow/
/// widen values.  Values that fit are preserved; narrowing truncates.
#[test]
fn run_conversion_helpers() {
    let dir = std::env::temp_dir().join(format!(
        "residc-e2e-conv-{}",
        std::process::id()
    ));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("conv.resid");
    std::fs::write(
        &file,
        r#"Int main() {
    // i32 from Int(64) literal (default)
    Int(32) a = i32(42);
    println(IntToString(a));

    // u16 from Int(64) literal
    UInt(16) b = u16(256);
    println(UIntToString(b));

    // f32 from Float(64) literal (default)
    Float(32) c = f32(3.14);
    println(FloatToString(c));

    // f64 identity
    Float(64) d = f64(2.71);
    println(FloatToString(d));

    // isize / usize
    Int(64) e = 99;
    println(IntToString(isize(e)));

    UInt(64) f = 123;
    println(UIntToString(usize(f)));

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
    assert!(lines.len() >= 6, "expected at least 6 lines, got {}:\n{}", lines.len(), stdout);
    assert!(lines[0].contains("42"), "i32(42): {}", lines[0]);
    assert!(lines[1].contains("256"), "u16(256): {}", lines[1]);
    assert!(lines[2].contains("3.14"), "f32(3.14): {}", lines[2]);
    assert!(lines[3].contains("2.71"), "f64(2.71): {}", lines[3]);
    assert!(lines[4].contains("99"), "isize(99): {}", lines[4]);
    assert!(lines[5].contains("123"), "usize(123): {}", lines[5]);

    let _ = std::fs::remove_dir_all(&dir);
}

/// Range construction (`0..5`, `0..=4`) and slice construction (`xs[1..4]`,
/// partial-open `xs[..4]`, `xs[1..]`, `xs[..]`) lower and run end-to-end.
#[test]
fn run_range_and_slice_construction() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-rngslc-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("rngslc.resid");
    std::fs::write(
        &file,
        r#"Int main() {
    // Range construction.
    Range(Int) r = 0..5;
    Range(Int) rc = 0..=4;
    for (Int i in 0..3) {
        println(IntToString(i));
    }

    // Slice construction + indexing back into the list.
    List(Int) xs = [10, 20, 30, 40, 50];
    Slice(Int) s = xs[1..4];
    Slice(Int) po1 = xs[..4];
    Slice(Int) po2 = xs[1..];
    Slice(Int) po3 = xs[..];
    println(IntToString(xs[1]));
    println(IntToString(xs[3]));
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
        vec!["0", "1", "2", "20", "40"],
        "unexpected output: {stdout:?}"
    );

    let _ = std::fs::remove_dir_all(&dir);
}

/// Raw strings, byte strings, and #location all run to completion.
#[test]
fn run_raw_bytes_and_location() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-rbl-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("raw_bytes_loc.resid");
    std::fs::write(
        &file,
        r#"
Int main() {
    Str raw = r"C:\path\file";
    println(raw);
    Bytes b = b"bytes";
    SourceLoc loc = #location;
    println(loc.file);
    println(IntToString(loc.line));
    println(IntToString(loc.col));
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
    assert_eq!(lines[0], r"C:\path\file", "raw string: {stdout:?}");
    assert_eq!(lines.len(), 4, "unexpected output: {stdout:?}");
    assert!(lines[1].ends_with("raw_bytes_loc.resid"), "file: {stdout:?}");
    assert!(lines[2].parse::<i64>().is_ok(), "line num: {stdout:?}");
    assert!(lines[3].parse::<i64>().is_ok(), "col num: {stdout:?}");

    let _ = std::fs::remove_dir_all(&dir);
}

/// F-string interpolation and runtime Str + Str run end-to-end.
#[test]
fn run_fstring_interpolation() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-fstr-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("fstr.resid");
    std::fs::write(
        &file,
        r#"
Int main() {
    Str name = "resid";
    Int n = 7;
    Float pi = 3.5;
    Bool ok = true;
    println(f"hello {name}");
    println(f"n={n}");
    println(f"pi={pi}");
    println(f"ok={ok}");
    println(f"both={name}{n}");
    Str a = "foo";
    Str c = a + "bar";
    println(c);
    println(f"{c}!");
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
        vec![
            "hello resid",
            "n=7",
            "pi=3.5",
            "ok=true",
            "both=resid7",
            "foobar",
            "foobar!",
        ],
        "unexpected output: {stdout:?}"
    );

    let _ = std::fs::remove_dir_all(&dir);
}

/// Str == Str / Str != Str run end-to-end (bootstrap lexer keyword matching).
#[test]
fn run_str_equality() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-streq-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("streq.resid");
    std::fs::write(
        &file,
        r#"
Int main() {
    Str kw = "if";
    Bool is_if = kw == "if";
    Bool is_else = kw == "else";
    Bool not_while = kw != "while";
    if (is_if && !is_else && not_while) {
        println("lexer-keyword-ok");
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
    assert_eq!(
        stdout.trim(),
        "lexer-keyword-ok",
        "unexpected output: {stdout:?}"
    );

    let _ = std::fs::remove_dir_all(&dir);
}

/// `return` inside an if/else branch is a real early return (not a fall-through
/// phi tail), so branches return immediately and recursion terminates.
#[test]
fn run_early_return_in_branch_and_recursion() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-recur-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("recur.resid");
    std::fs::write(
        &file,
        r#"
Int f(Int n) {
    if (n <= 0) { return 42; }
    return 7;
}
Int sum(Int n) {
    if (n <= 0) { return 0; }
    Int m = n - 1;
    return n + sum(m);
}
Int main() {
    println(IntToString(f(-5)));
    println(IntToString(f(5)));
    println(IntToString(sum(5)));
    println(IntToString(sum(10)));
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
        "42\n7\n15\n55",
        "unexpected output: {stdout:?}"
    );

    let _ = std::fs::remove_dir_all(&dir);
}

/// A Resid program lexes a `.resid` source file (bootstrap lexer, M4).
#[test]
fn bootstrap_lexer_tokenizes_source() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-lex-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let lexer = dir.join("lexer.resid");
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap();
    std::fs::copy(workspace.join("examples/lexer.resid"), &lexer).unwrap();
    let src = dir.join("sample.resid");
    std::fs::write(
        &src,
        r#"// C-style line comment
/* block comment */
Int main() {
    println("hi");
    return 0;
}
"#,
    )
    .unwrap();

    let out = Command::new(residc_bin())
        .arg(&lexer)
        .arg("run")
        .arg(&src)
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
        "ident(Int)\nident(main)\nop(()\nop())\nop({)\nident(println)\nop(()\nliteral(Str hi)\nop())\nop(;)\nkeyword(return)\nliteral(Int 0)\nop(;)\nop(})\nEOF",
        "unexpected lexer output: {stdout:?}"
    );

    let _ = std::fs::remove_dir_all(&dir);
}

/// A Resid program parses a `.resid` source file into an AST (bootstrap
/// parser, M5).
#[test]
fn bootstrap_parser_builds_ast() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-parse-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let parser = dir.join("parser.resid");
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap();
    std::fs::copy(workspace.join("examples/parser.resid"), &parser).unwrap();
    let src = dir.join("ast_sample.resid");
    std::fs::write(
        &src,
        r#"type Point = { x: Int, y: Int };
Int add(Int a, Int b) {
    Int c = a + b;
    return c;
}
Int main() {
    List(Int) xs = [1, 2, 3];
    Point p = Point { x: 3, y: 4 };
    Int n = add(1, 2) * 3 - 4;
    if (n > 5) {
        println("big");
    } else {
        println("small");
    }
    for (Int i in 0..5) {
        println(IntToString(i));
    }
    Option(Int) mx = Some(7);
    Int out = match mx {
        Some(k) => k,
        None => 0,
    };
    return 0;
}
"#,
    )
    .unwrap();

    let out = Command::new(residc_bin())
        .arg(&parser)
        .arg("run")
        .arg(&src)
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
    let lines: Vec<&str> = stdout.trim().lines().collect();
    assert_eq!(lines.last(), Some(&"EOF"), "unexpected parser output: {stdout:?}");
    assert_eq!(
        lines[0],
        "(type-def Point (x (type Int)) (y (type Int)))",
        "unexpected type-def: {stdout:?}"
    );
    assert!(
        lines.iter().any(|l| l.contains("(func add -> (type Int)")),
        "missing add: {stdout:?}"
    );
    assert!(
        lines.iter().any(|l| {
            l.contains("(bind n Int (bin * (call (id add)  (int 1) (int 2)) (bin - (int 3) (int 4)))")
        }),
        "missing precedence: {stdout:?}"
    );
    assert!(
        lines
            .iter()
            .any(|l| l.contains("(match (id mx)")),
        "missing match: {stdout:?}"
    );
    assert!(
        lines.iter().any(|l| l.contains("(for-in Int i")),
        "missing for-in: {stdout:?}"
    );

    let _ = std::fs::remove_dir_all(&dir);
}

/// M6a: the self-hosted type checker (examples/typecheck.resid) accepts all
/// three bootstrap programs — including its own source.
#[test]
fn bootstrap_typechecker_accepts_bootstrap_sources() {
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap();
    for name in ["typecheck.resid", "lexer.resid", "parser.resid"] {
        let out = Command::new(residc_bin())
            .arg(workspace.join("examples/typecheck.resid"))
            .arg("run")
            .arg(workspace.join("examples").join(name))
            .output()
            .expect("failed to run residc run");
        let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
        assert_eq!(
            out.status.code(),
            Some(0),
            "{name}: residc failed: {}",
            String::from_utf8_lossy(&out.stderr)
        );
        assert_eq!(
            stdout.trim().lines().last(),
            Some("typecheck OK"),
            "{name}: unexpected output: {stdout:?}"
        );
    }
}

/// M6a: the self-hosted type checker rejects ill-typed programs.
#[test]
fn bootstrap_typechecker_rejects_type_errors() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-tc-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap();
    let bad = dir.join("bad.resid");
    std::fs::write(
        &bad,
        r#"
Int main() {
    Str x = 42;
    return 0;
}
"#,
    )
    .unwrap();

    let out = Command::new(residc_bin())
        .arg(workspace.join("examples/typecheck.resid"))
        .arg("run")
        .arg(&bad)
        .output()
        .expect("failed to run residc run");

    let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
    assert_ne!(out.status.code(), Some(0), "ill-typed source passed: {stdout:?}");
    assert!(
        stdout.contains("type error"),
        "missing type error report: {stdout:?}"
    );

    let _ = std::fs::remove_dir_all(&dir);
}

/// `List.concat(b)` joins two lists of the same element type.
#[test]
fn run_list_concat() {
    let dir =
        std::env::temp_dir().join(format!("residc-e2e-conc-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("concat.resid");
    std::fs::write(
        &file,
        r#"Int main() {
    List(Int) a = [1, 2];
    List(Int) b = [3, 4, 5];
    List(Int) c = a.concat(b);
    println(IntToString(c[0]));
    println(IntToString(c[2]));
    println(IntToString(c[4]));

    List(Str) sa = ["hello", " "];
    List(Str) sb = ["world"];
    List(Str) sc = sa.concat(sb);
    println(sc[0]);

    // Empty list concat — empty list takes element type from declared binding
    List(Int) empty = [];
    List(Int) d = a.concat(empty);
    println(IntToString(d[0]));

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
        vec!["1", "3", "5", "hello", "1"],
        "unexpected output: {stdout:?}"
    );

    let _ = std::fs::remove_dir_all(&dir);
}

/// Empty list literals type-check with declared element type and run.
#[test]
fn run_empty_list_with_declared_type() {
    let dir = std::env::temp_dir().join(format!(
        "residc-e2e-empty-{}",
        std::process::id()
    ));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("empty.resid");
    std::fs::write(
        &file,
        r#"Int main() {
    List(Int) empty = [];
    List(Str) words = [];
    println(IntToString(empty.len()));
    println(IntToString(words.len()));
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
        "0\n0",
        "unexpected output: {stdout:?}"
    );

    let _ = std::fs::remove_dir_all(&dir);
}

/// Default parameters: functions with default values for trailing params can
/// be called with fewer arguments. Named args skip over defaults.
#[test]
fn run_default_params() {
    let dir = std::env::temp_dir().join(format!(
        "residc-e2e-defpar-{}",
        std::process::id()
    ));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("defpar.resid");
    std::fs::write(
        &file,
        r#"
Str greet(Int count, Str msg = "hello", Str suffix = " world") {
    return msg + suffix;
}
Int main() {
    // Use defaults for msg and suffix
    println(greet(2));
    // Override only suffix
    println(greet(1, "hi", "!"));
    // All explicit
    println(greet(1, "hey", "."));
    // Named args: skip over msg, override suffix
    println(greet(1, suffix = "!"));
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
        vec!["hello world", "hi!", "hey.", "hello!"],
        "unexpected output: {stdout:?}"
    );

    let _ = std::fs::remove_dir_all(&dir);
}

/// String introspection built-ins (`str_len`, `str_char_at`, `str_from_code`,
/// `str_slice`) run end-to-end — unblocking M2 string building in Resid.
#[test]
fn run_str_introspection() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-stri-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("stri.resid");
    std::fs::write(
        &file,
        r#"
Int main() {
    Str s = "hello";
    Int n = str_len(s);
    println(IntToString(n));
    Int c = str_char_at(s, 1);
    println(IntToString(c));
    Str one = str_from_code(c);
    println(one);
    Str sub = str_slice(s, 1, 3);
    println(sub);
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
        vec!["5", "101", "e", "el"],
        "unexpected output: {stdout:?}"
    );

    let _ = std::fs::remove_dir_all(&dir);
}

/// Wide 256/512-bit integer stringification via u64-limb decomposition runs
/// end-to-end (Int256ToString / UInt256ToString / Int512ToString / UInt512ToString).
#[test]
fn run_wide_int_256_512() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-wid2-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("wid2.resid");
    std::fs::write(
        &file,
        r#"
Int main() {
    Int(256) a = 340282366920938463463374607431768211455;
    println(Int256ToString(a));
    Int(256) b = a + a;
    println(Int256ToString(b));
    Int(512) w = (Int(512))a * (Int(512))a;
    println(Int512ToString(w));
    UInt(512) u = 18446744073709551615;
    println(UInt512ToString(u));
    Int(256) neg = 0 - 18446744073709551616;
    println(Int256ToString(neg));
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
        vec![
            "340282366920938463463374607431768211455",
            "680564733841876926926749214863536422910",
            "115792089237316195423570985008687907852589419931798687112530834793049593217025",
            "18446744073709551615",
            "-18446744073709551616",
        ],
        "unexpected output: {stdout:?}"
    );

    let _ = std::fs::remove_dir_all(&dir);
}

/// Wide 128-bit integer literals, arithmetic, casts, and stringification run

#[test]
fn run_wide_literal_beyond_u128() {
    // A decimal literal wider than u128 (2^256-1) must survive lexing and
    // print exactly, not silently truncate to 0.
    let dir = std::env::temp_dir().join(format!("residc-e2e-wid3-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("wid3.resid");
    std::fs::write(
        &file,
        r#"
Int main() {
    UInt(256) a = 115792089237316195423570985008687907853269984665640564039457584007913129639935;
    println(UInt256ToString(a));
    UInt(512) b = 340282366920938463463374607431768211455;
    println(UInt512ToString(b));
    Int(256) c = 57896044618658097711785492504343953926634992332820282019728792003956564819967;
    println(Int256ToString(c));
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
        vec![
            "115792089237316195423570985008687907853269984665640564039457584007913129639935",
            "340282366920938463463374607431768211455",
            "57896044618658097711785492504343953926634992332820282019728792003956564819967",
        ],
        "unexpected output: {stdout:?}"
    );

    let _ = std::fs::remove_dir_all(&dir);
}

/// Wide 128-bit integer literals, arithmetic, casts, and stringification run
/// end-to-end (Int128ToString / UInt128ToString).
#[test]
fn run_wide_int_128() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-wid-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("wid.resid");
    std::fs::write(
        &file,
        r#"
Int main() {
    Int(128) big = 18446744073709551617;
    println(Int128ToString(big));
    Int(128) a = 5;
    Int(128) b = 7;
    Int(128) s = a + b;
    println(Int128ToString(s));
    Int(128) neg = 0 - 170141183460469231731687303715884105728;
    println(Int128ToString(neg));
    UInt(128) max = 340282366920938463463374607431768211455;
    println(UInt128ToString(max));
    Int(128) hi = (Int(128))9223372036854775807;
    println(Int128ToString(hi));
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
        vec![
            "18446744073709551617",
            "12",
            "-170141183460469231731687303715884105728",
            "340282366920938463463374607431768211455",
            "9223372036854775807",
        ],
        "unexpected output: {stdout:?}"
    );

    let _ = std::fs::remove_dir_all(&dir);
}

/// Float(128) end-to-end: f128() conversion, arithmetic, comparison,
/// quad-precision Float128ToString, and f-string interpolation.
#[test]
fn run_float128() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-f128-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("f128.resid");
    std::fs::write(
        &file,
        r#"
Float(128) pow2(Int(64) n) {
    if (n == 0) {
        return f128(1.0);
    } else {
        return pow2((Int(64))(n - 1)) * f128(2.0);
    }
}

Int main() {
    Float(128) a = f128(1.5);
    Float(128) b = f128(2.25);
    println(Float128ToString(a + b));
    println(Float128ToString(a * b));
    println(Float128ToString(f128(1.0) / f128(3.0)));
    println(Float128ToString(f128(2.5)));
    println(Float128ToString(pow2(100)));
    println(Float128ToString(f128(0.0001)));
    println(f"sum = {a + b}");
    if (a < b) { println("lt"); }
    if (a == b) { println("eq"); }
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
        vec![
            "3.75",
            "3.375",
            "0.333333333333333333333333333333333317",
            "2.5",
            "1267650600228229401496703205376",
            "0.000100000000000000004792173602385929598",
            "sum = 3.75",
            "lt",
        ],
        "unexpected output: {stdout:?}"
    );

    let _ = std::fs::remove_dir_all(&dir);
}

/// Dec(N) exact decimals (spec §6.6a) compile and run end-to-end: literals,
/// exact arithmetic, comparisons, rounding casts, and conversion helpers.
#[test]
fn run_dec_exact_arithmetic() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-dec-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("dec.resid");
    std::fs::write(
        &file,
        r#"Dec main() {
    Dec(4) a = 1.5m;
    Dec(4) b = 2.25m;
    Dec(4) s = a + b;
    Dec(4) d = a - b;
    Dec(4) m = a * b;
    Dec(4) q = a / b;
    Dec(4) q2 = 10.0m / 3.0m;
    Dec(4) neg = -a;
    println(f"a={a}");
    println(f"a+b={s}");
    println(f"a-b={d}");
    println(f"a*b={m}");
    println(f"a/b={q}");
    println(f"10/3={q2}");
    println(f"-a={neg}");
    Bool lb = a < b;
    Bool eq = (a == 1.5m);
    println(f"a<b={lb}");
    println(f"a==1.5m={eq}");
    Dec(6) di = (Dec(6)) 7;
    println(f"7 as Dec(6)={di}");
    Dec(6) r = (Dec(6)) 1.23456789m;
    println(f"round={r}");
    Int i = i32(12.0m);
    Float fl = f64(12.5m);
    Dec(8) y = d8(123.456m);
    Dec(8) z = d8("9.87654321");
    println(f"i32={i}");
    println(f"f64={fl}");
    println(f"d8={y}");
    println(f"d8str={z}");
    return 0m;
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
        vec![
            "a=1.500",
            "a+b=3.750",
            "a-b=-0.7500",
            "a*b=3.375",
            "a/b=0.6667",
            "10/3=3.333",
            "-a=-1.500",
            "a<b=true",
            "a==1.5m=true",
            "7 as Dec(6)=7.00000",
            "round=1.23457",
            "i32=12",
            "f64=12.5",
            "d8=123.45600",
            "d8str=9.8765432",
        ],
        "unexpected output: {stdout:?}"
    );

    let _ = std::fs::remove_dir_all(&dir);
}

/// M6 P1: `filesystem.write_all` writes a file; `read_all` round-trips it.
#[test]
fn run_fs_write_all_roundtrip() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-fs-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let out_path = dir.join("written.txt");
    let file = dir.join("fs.resid");
    std::fs::write(
        &file,
        format!(
            r#"Int main() {{
    Bool ok = filesystem.write_all("{out}", "hello from write_all\n");
    println(BoolToString(ok));
    Str back = filesystem.read_all("{out}");
    print(back);
    return 0;
}}
"#,
            out = out_path.display()
        ),
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
    assert_eq!(stdout, "true\nhello from write_all\n");

    let _ = std::fs::remove_dir_all(&dir);
}

/// M6 P2 (type half): `Result(T, RegionError)` construction, match, message.
#[test]
fn run_result_type_ok_err() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-res-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("result.resid");
    std::fs::write(
        &file,
        r#"Int main() {
    Result(Int, RegionError) r = Ok(7);
    Int out = match r {
        Ok(n) => n,
        Err(e) => 0,
    };
    println(IntToString(out));
    Result(Int, RegionError) bad = Err(RegionError { message: "boom" });
    Str msg = match bad {
        Ok(n) => "none",
        Err(e) => e.message,
    };
    println(msg);
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
    assert_eq!(stdout, "7\nboom\n");

    let _ = std::fs::remove_dir_all(&dir);
}

/// Spawn expression: `spawn (caps) { body }` compiles to a pthread worker,
/// joins the thread, and yields `Result(T, RegionError)`.
#[test]
fn run_spawn_simple() {
    let dir = std::env::temp_dir()
        .join(format!("residc-e2e-spawn-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("spawn.resid");
    std::fs::write(
        &file,
        r#"Int main() {
    Result(Int, RegionError) r = spawn () {
        return 42;
    };
    Int out = match r {
        Ok(n) => n,
        Err(e) => 0,
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
        "42",
        "expected spawn to return 42, got: {stdout:?}"
    );

    let _ = std::fs::remove_dir_all(&dir);
}

/// Spawn with captures: outer-scope bindings are passed into the worker.
#[test]
fn run_spawn_with_captures() {
    let dir = std::env::temp_dir()
        .join(format!("residc-e2e-spawn-cap-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("spawn_cap.resid");
    std::fs::write(
        &file,
        r#"Int main() {
    Int x = 10;
    Int y = 20;
    Result(Int, RegionError) r = spawn () {
        return x + y;
    };
    Int out = match r {
        Ok(n) => n,
        Err(e) => 0,
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
        "30",
        "expected spawn with captures to return 30, got: {stdout:?}"
    );

    let _ = std::fs::remove_dir_all(&dir);
}

/// Handle types (spec §16): `with (File h = filesystem.open(path)) { body }`
/// acquires the handle, binds it in the body, reads through the handle, and
/// releases it automatically (RAII) when the block ends. `filesystem.close`
/// releases a handle explicitly.
#[test]
fn run_with_handle_raii() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-handle-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let path = dir.join("with.txt");
    let file = dir.join("with.resid");
    std::fs::write(
        &file,
        format!(
            r#"Int main() {{
    Str p = "{path}";
    Bool wok = filesystem.write_all(p, "hello with\n");
    with (File h = filesystem.open(p)) {{
        Str data = filesystem.read_handle(h);
        print(data);
        return 0;
    }}
    return 1;
}}
"#,
            path = path.display()
        ),
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
        stdout,
        "hello with\n",
        "expected data read through the File handle, got: {stdout:?}"
    );

    let _ = std::fs::remove_dir_all(&dir);
}

/// Handle types (spec §16): a handle acquired outside a `with` block is
/// released explicitly via `filesystem.close`.
#[test]
fn run_handle_explicit_close() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-handle-c-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let path = dir.join("close.txt");
    let file = dir.join("close.resid");
    std::fs::write(
        &file,
        format!(
            r#"Int main() {{
    Str p = "{path}";
    Bool wok = filesystem.write_all(p, "data");
    File h = filesystem.open(p);
    Bool closed = filesystem.close(h);
    println(BoolToString(closed));
    return 0;
}}
"#,
            path = path.display()
        ),
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
        "true",
        "expected explicit close to succeed, got: {stdout:?}"
    );

    let _ = std::fs::remove_dir_all(&dir);
}

/// Nested spawn: spawn inside a spawn body.
#[test]
fn run_spawn_nested() {
    let dir = std::env::temp_dir()
        .join(format!("residc-e2e-spawn-nest-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("spawn_nested.resid");
    std::fs::write(
        &file,
        r#"Int main() {
    Result(Int, RegionError) r1 = spawn () {
        Result(Int, RegionError) r2 = spawn () {
            return 7;
        };
        Int inner = match r2 {
            Ok(n) => n,
            Err(e) => 0,
        };
        return inner * 6;
    };
    Int out = match r1 {
        Ok(n) => n,
        Err(e) => 0,
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
        "42",
        "expected nested spawn to return 42, got: {stdout:?}"
    );

    let _ = std::fs::remove_dir_all(&dir);
}

/// Spec §19 "Child failure -> Err(RegionError) to parent": a runtime abort
/// inside a spawned worker (here a list-index bounds abort routed through
/// `resid_abort`) is delivered to the parent as `Err(RegionError)`, which the
/// parent's `match` catches — it does NOT terminate the process. A healthy
/// worker still yields `Ok(T)`.
#[test]
fn run_spawn_child_failure_err() {
    let dir = std::env::temp_dir()
        .join(format!("residc-e2e-spawn-err-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();

    // Legal / healthy: worker returns a value; parent sees Ok and prints 42.
    let okpath = dir.join("ok.resid");
    std::fs::write(
        &okpath,
        r#"Int main() {
    Result(Int, RegionError) r = spawn () {
        return 42;
    };
    Int out = match r {
        Ok(n) => n,
        Err(e) => 0,
    };
    println(IntToString(out));
    return 0;
}
"#,
    )
    .unwrap();
    let out = Command::new(residc_bin()).arg(&okpath).arg("run").current_dir(&dir).output().unwrap();
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    assert_eq!(String::from_utf8_lossy(&out.stdout).trim(), "42");

    // Child failure: a list-index bounds abort inside the worker (routed via
    // resid_abort) is DELIVERED as Err(RegionError), not a process abort. The
    // parent's match takes the Err arm -> prints 7, process exits 0.
    let bad = dir.join("bad.resid");
    std::fs::write(
        &bad,
        r#"Int tricky(Int i) {
    List(Int) xs = [10, 20, 30];
    return xs[i];
}

Int main() {
    Result(Int, RegionError) r = spawn () {
        Int idx = 7;
        Int y = tricky(idx);
        return y;
    };
    Int out = match r {
        Ok(n) => 1,
        Err(e) => 7,
    };
    println(IntToString(out));
    return 0;
}
"#,
    )
    .unwrap();
    let out = Command::new(residc_bin()).arg(&bad).arg("run").current_dir(&dir).output().unwrap();
    assert_eq!(out.status.code(), Some(0), "child failure must not abort the process:\n{}", String::from_utf8_lossy(&out.stderr));
    assert_eq!(String::from_utf8_lossy(&out.stdout).trim(), "7");

    let _ = std::fs::remove_dir_all(&dir);
}

/// M6b: the self-hosted fused codegen emits LLVM IR for a sample program;
/// the IR assembles with clang + the C runtime and runs correctly.
#[test]
fn bootstrap_codegen_emits_runnable_ir() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-cg-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap();
    let sample = dir.join("sample.resid");
    std::fs::write(
        &sample,
        r#"
Int sq(Int x) {
    return x * x;
}

Int main() {
    println("hi");
    Int a = sq(7);
    if (a > 40) {
        println("big");
    } else {
        println("small");
    }
    Int base = 100;
    for (Int i in 0..3) {
        Int s = sq(base);
        if (s == 10000) {
            println("tick");
        } else {
            println("other");
        }
    }
    return 0;
}
"#,
    )
    .unwrap();
    let out_ll = dir.join("out.ll");

    // Stage 1: run the bootstrap codegen (compiled Resid) on the sample.
    let out = Command::new(residc_bin())
        .arg(workspace.join("examples/codegen.resid"))
        .arg("run")
        .arg(&sample)
        .arg("-o")
        .arg(&out_ll)
        .output()
        .expect("failed to run residc run");
    assert_eq!(
        out.status.code(),
        Some(0),
        "bootstrap codegen failed: {}",
        String::from_utf8_lossy(&out.stderr)
    );
    assert!(out_ll.exists(), "bootstrap codegen wrote no IR");

    // Stage 2: assemble the emitted IR with clang + the C runtime.
    let bin = dir.join("sample_bin");
    let cc = Command::new("clang")
        .arg(&out_ll)
        .arg(workspace.join("crates/residc/resid_rt.c"))
        .arg("-Wno-override-module")
        .arg("-pthread")
        .arg("-o")
        .arg(&bin)
        .output()
        .expect("failed to run clang");
    assert!(
        cc.status.success(),
        "clang failed: {}",
        String::from_utf8_lossy(&cc.stderr)
    );

    // Stage 3: run the native binary and check its output.
    let run = Command::new(&bin).output().expect("failed to run binary");
    let stdout = String::from_utf8_lossy(&run.stdout).into_owned();
    assert_eq!(run.status.code(), Some(0), "binary failed: {stdout:?}");
    assert_eq!(
        stdout.lines().collect::<Vec<_>>(),
        vec!["hi", "big", "tick", "tick", "tick"],
        "unexpected output: {stdout:?}"
    );

    let _ = std::fs::remove_dir_all(&dir);
}

/// M6c: the self-hosted driver (typecheck → codegen → clang, all in Resid)
/// compiles a sample program to a working native binary, and rejects
/// ill-typed sources with a nonzero exit.
#[test]
fn bootstrap_driver_compiles_and_rejects() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-drv-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap();
    let sample = dir.join("sample.resid");
    std::fs::write(
        &sample,
        r#"
Int sq(Int x) {
    return x * x;
}

Int main() {
    println("hi");
    Int a = sq(7);
    if (a > 40) {
        println("big");
    } else {
        println("small");
    }
    for (Int i in 0..3) {
        Int s = sq(100);
        if (s == 10000) {
            println("tick");
        } else {
            println("other");
        }
    }
    return 0;
}
"#,
    )
    .unwrap();
    let bin = dir.join("sample_drv");

    let out = Command::new(residc_bin())
        .arg(workspace.join("examples/driver.resid"))
        .arg("run")
        .arg(&sample)
        .arg("-o")
        .arg(&bin)
        .arg("-rt")
        .arg(workspace.join("crates/residc/resid_rt.c"))
        .output()
        .expect("failed to run residc run");
    assert_eq!(
        out.status.code(),
        Some(0),
        "driver failed: {}",
        String::from_utf8_lossy(&out.stderr)
    );
    assert!(bin.exists(), "driver produced no binary");

    let run = Command::new(&bin).output().expect("failed to run binary");
    let stdout = String::from_utf8_lossy(&run.stdout).into_owned();
    assert_eq!(run.status.code(), Some(0), "binary failed: {stdout:?}");
    assert_eq!(
        stdout.lines().collect::<Vec<_>>(),
        vec!["hi", "big", "tick", "tick", "tick"],
        "unexpected output: {stdout:?}"
    );

    // Ill-typed input must be rejected by the driver's own checker.
    let bad = dir.join("bad.resid");
    std::fs::write(
        &bad,
        r#"
Int main() {
    Str x = 42;
    return 0;
}
"#,
    )
    .unwrap();
    let bad_out = Command::new(residc_bin())
        .arg(workspace.join("examples/driver.resid"))
        .arg("run")
        .arg(&bad)
        .arg("-o")
        .arg(dir.join("bad_bin"))
        .arg("-rt")
        .arg(workspace.join("crates/residc/resid_rt.c"))
        .output()
        .expect("failed to run residc run");
    assert_ne!(
        bad_out.status.code(),
        Some(0),
        "driver accepted an ill-typed program"
    );
    assert!(
        String::from_utf8_lossy(&bad_out.stdout).contains("type error"),
        "missing type error report"
    );

    let _ = std::fs::remove_dir_all(&dir);
}

/// Stage-2 self-hosting (M6 item 4): the Resid-written emitter
/// (examples/codegen.resid) compiles the bootstrap lexer into a working
/// binary — the emitter's output is linked and run like any other.
#[test]
fn stage2_emitter_compiles_bootstrap_lexer() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-stage2-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap();

    // 1. Build the Resid-written emitter with the Rust residc.
    let out = Command::new(residc_bin())
        .arg(workspace.join("examples/codegen.resid"))
        .arg("build")
        .arg("-o")
        .arg(dir.join("emitter"))
        .arg("-rt")
        .arg(workspace.join("crates/residc/resid_rt.c"))
        .output()
        .expect("failed to build stage-2 emitter");
    assert_eq!(
        out.status.code(),
        Some(0),
        "emitter build failed: {}",
        String::from_utf8_lossy(&out.stderr)
    );

    // 2. The emitter compiles the bootstrap lexer to LLVM IR.
    let ll = dir.join("lexer2.ll");
    let out = Command::new(dir.join("emitter"))
        .arg(workspace.join("examples/lexer.resid"))
        .arg("-o")
        .arg(&ll)
        .output()
        .expect("failed to run stage-2 emitter");
    assert_eq!(
        out.status.code(),
        Some(0),
        "stage-2 compile of lexer.resid failed: {}",
        String::from_utf8_lossy(&out.stderr)
    );
    assert!(ll.exists(), "emitter wrote no IR");

    // 3. Link the emitted IR and run it on a sample source.
    let clang = Command::new("clang")
        .arg(&ll)
        .arg(workspace.join("crates/residc/resid_rt.c"))
        .arg("-Wno-override-module")
        .arg("-pthread")
        .arg("-o")
        .arg(dir.join("lexer2"))
        .output()
        .expect("failed to run clang");
    assert_eq!(
        clang.status.code(),
        Some(0),
        "clang failed: {}",
        String::from_utf8_lossy(&clang.stderr)
    );

    let src = dir.join("sample.resid");
    std::fs::write(
        &src,
        "Int main() {\n    println(\"hi\");\n    return 0;\n}\n",
    )
    .unwrap();
    let run = Command::new(dir.join("lexer2"))
        .arg(&src)
        .output()
        .expect("failed to run stage-2-built lexer");
    let stdout = String::from_utf8_lossy(&run.stdout).into_owned();
    assert_eq!(
        stdout.trim(),
        "ident(Int)\nident(main)\nop(()\nop())\nop({)\nident(println)\nop(()\nliteral(Str hi)\nop())\nop(;)\nkeyword(return)\nliteral(Int 0)\nop(;)\nop(})\nEOF",
        "unexpected stage-2 lexer output: {stdout:?}"
    );

    let _ = std::fs::remove_dir_all(&dir);
}

/// Stdlib v1: string verbs run end-to-end through the full pipeline.
#[test]
fn run_stdlib_string_verbs() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-stdlib-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("stdlib.resid");
    std::fs::write(
        &file,
        r#"
Int main() {
    Str s = str_trim("  hi  ");
    println(s);
    List(Str) parts = str_split("a,b,c", ",");
    println(str_join(parts, "-"));
    println(str_to_upper("abc"));
    println(str_replace("aaa", "a", "ba"));
    if (str_starts_with("hello", "he") && str_ends_with("hello", "lo")) {
        println(str_repeat("ab", 3));
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
        .expect("failed to run residc");

    let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
    assert_eq!(
        out.status.code(),
        Some(0),
        "residc failed: {}",
        String::from_utf8_lossy(&out.stderr)
    );
    assert_eq!(
        stdout.trim(),
        "hi\na-b-c\nABC\nbababa\nababab",
        "unexpected output: {stdout:?}"
    );

    let _ = std::fs::remove_dir_all(&dir);
}

/// Stdlib v1.1: integer parsing + math verbs end-to-end.
#[test]
fn run_stdlib_parse_math() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-stdmath-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("stdmath.resid");
    std::fs::write(
        &file,
        r#"
Int main() {
    if (str_is_int("-17")) {
        println(IntToString(str_parse_int("-17")));
    }
    println(IntToString(abs_i64(-8)));
    println(IntToString(min_i64(3, 9)));
    println(IntToString(max_i64(3, 9)));
    println(IntToString(clamp_i64(15, 0, 10)));
    return 0;
}
"#,
    )
    .unwrap();

    let out = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("failed to run residc");
    let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
    assert_eq!(
        out.status.code(),
        Some(0),
        "residc failed: {}",
        String::from_utf8_lossy(&out.stderr)
    );
    assert_eq!(stdout.trim(), "-17\n8\n3\n9\n10", "unexpected output: {stdout:?}");

    let _ = std::fs::remove_dir_all(&dir);
}

/// Stdlib v1.2: float parsing + misc string helpers end-to-end.
#[test]
fn run_stdlib_float_misc() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-stdmisc-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("stdmisc.resid");
    std::fs::write(
        &file,
        r#"
Int main() {
    if (str_is_float("3.5")) {
        Float f = str_parse_float("3.5") + str_parse_float("-1.25");
        println(f"sum={f}");
    }
    println(IntToString(str_count("banana", "an")));
    println(str_reverse("héllo"));
    return 0;
}
"#,
    )
    .unwrap();

    let out = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("failed to run residc");
    let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
    assert_eq!(
        out.status.code(),
        Some(0),
        "residc failed: {}",
        String::from_utf8_lossy(&out.stderr)
    );
    assert_eq!(stdout.trim(), "sum=2.25\n2\nolléh", "unexpected output: {stdout:?}");

    let _ = std::fs::remove_dir_all(&dir);
}

/// Stdlib v1.3: list verbs end-to-end.
#[test]
fn run_stdlib_list_verbs() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-stdlist-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("stdlist.resid");
    std::fs::write(
        &file,
        r#"
Int main() {
    List(Int) xs = [3, 1, 2];
    List(Int) sorted = list_sort_ints(xs);
    List(Int) rev = list_reverse_ints(sorted);
    println(IntToString(list_sum(rev)));
    println(IntToString(list_sum(xs)));
    if (list_contains_int(xs, 2)) {
        println("has 2");
    }
    List(Str) ss = list_sort_strs(["pear", "apple", "fig"]);
    println(str_join(ss, ","));
    List(Str) rs = list_reverse_strs(ss);
    println(str_join(rs, ","));
    if (list_contains_str(ss, "fig")) {
        println("has fig");
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
        .expect("failed to run residc");
    let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
    assert_eq!(
        out.status.code(),
        Some(0),
        "residc failed: {}",
        String::from_utf8_lossy(&out.stderr)
    );
    assert_eq!(
        stdout.trim(),
        "6\n6\nhas 2\napple,fig,pear\npear,fig,apple\nhas fig",
        "unexpected output: {stdout:?}"
    );

    let _ = std::fs::remove_dir_all(&dir);
}

/// Stdlib v1.4: List(Float) verbs end-to-end.
#[test]
fn run_stdlib_float_list() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-stdfl-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("stdfl.resid");
    std::fs::write(
        &file,
        r#"
Int main() {
    List(Float) fs = [3.5, -1.0, 2.25];
    List(Float) sorted = list_sort_floats(fs);
    println(f"sum={list_sumf(sorted)}");
    if (list_contains_float(fs, 2.25)) {
        println("has 2.25");
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
        .expect("failed to run residc");
    let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
    assert_eq!(
        out.status.code(),
        Some(0),
        "residc failed: {}",
        String::from_utf8_lossy(&out.stderr)
    );
    assert_eq!(stdout.trim(), "sum=4.75\nhas 2.25", "unexpected output: {stdout:?}");
    let _ = std::fs::remove_dir_all(&dir);
}

/// Unicode simple case mapping covers the full generated pair tables
/// (tools/gen_case_tables.py, exhaustive vs unicodedata): ASCII, Latin-1,
/// Latin Extended-A/B incl. irregular pairs, Greek incl. accented variants
/// and final sigma, Cyrillic; SpecialCasing uppercase expansions
/// (ß→SS, ligatures, ŉ→ʼN, Greek ypogegrammeni) and the conditional
/// Final_Sigma rule (Σ→ς word-finally) are implemented.
#[test]
fn run_unicode_case_mapping() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-case-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("case.resid");
    std::fs::write(
        &file,
        r#"
Int main() {
    println(str_to_upper("héllo wörld привет αβγ"));
    println(str_to_lower("HÉLLO WÖRLD ПРИВЕТ ΑΒΓ"));
    println(str_to_upper("ßÿ"));
    println(str_to_upper("ǆ ς ж ά"));
    println(str_to_lower("Ǆ Σ Ж Ά ẛ"));
    println(str_to_upper("ﬁle ﬂag ﬃ ŉ ǰ"));
    println(str_to_upper("ᾈ ᾨ"));
    println(str_to_lower("ΑΣ ΟΔΟΣ ΣΑ"));
    return 0;
}
"#,
    )
    .unwrap();
    let out = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("failed to run residc");
    let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
    assert_eq!(
        out.status.code(),
        Some(0),
        "residc failed: {}",
        String::from_utf8_lossy(&out.stderr)
    );
    let want: Vec<&str> = vec![
        "H\u{c9}LLO W\u{d6}RLD \u{41f}\u{420}\u{418}\u{412}\u{415}\u{422} \u{391}\u{392}\u{393}",
        "h\u{e9}llo w\u{f6}rld \u{43f}\u{440}\u{438}\u{432}\u{435}\u{442} \u{3b1}\u{3b2}\u{3b3}",
        "SS\u{178}",
        "\u{1c4} \u{3a3} \u{416} \u{386}",
        "\u{1c6} \u{3c3} \u{436} \u{3ac} \u{1e9b}",
        "FILE FLAG FFI \u{2bc}N J\u{30c}",
        "\u{1f08}\u{399} \u{1fa8}\u{399}",
        "\u{3b1}\u{3c3} \u{3bf}\u{3b4}\u{3bf}\u{3c3} \u{3c3}\u{3b1}",
    ];
    let got: Vec<&str> = stdout.trim().split('\n').collect();
    for (i, (a, b)) in got.iter().zip(want.iter()).enumerate() {
        if a != b {
            let ha: Vec<String> = a.chars().map(|c| format!("{:x}", c as u32)).collect();
            let hb: Vec<String> = b.chars().map(|c| format!("{:x}", c as u32)).collect();
            panic!("line {i} differs\n got-hex {}\nwant-hex {}", ha.join(" "), hb.join(" "));
        }
    }
    if got.len() != want.len() { panic!("len {} != {}", got.len(), want.len()); }
    let _ = std::fs::remove_dir_all(&dir);
}

/// SHA-256 written in pure Resid (lib/crypto.resid) — self-hosted crypto.
#[test]
fn run_sha256_in_resid() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-sha-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap();
    std::fs::copy(workspace.join("lib/crypto.resid"), dir.join("crypto.resid")).unwrap();
    let file = dir.join("main.resid");
    std::fs::write(
        &file,
        r#"
import "crypto.resid";
Int main() {
    println(sha256(""));
    println(sha256("abc"));
    println(sha256("The quick brown fox jumps over the lazy dog"));
    return 0;
}
"#,
    )
    .unwrap();
    let out = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("failed to run residc");
    let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    assert_eq!(
        stdout.trim(),
        "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855\nba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad\nd7a8fbb307d7809469ca9abcb0082e4f8d5651e46d3cdb762d02d0bf37c9e592",
        "{stdout:?}"
    );
    let _ = std::fs::remove_dir_all(&dir);
}







/// Stage-2 provenance sidecars: the bootstrap driver signs its artifacts
/// with the self-hosted Ed25519 signer; `residc verify` accepts them.
#[test]
fn run_stage2_provenance_sidecar() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-prov2-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap();
    // Reuse the repo keypair if present; otherwise generate one.
    let keys = workspace.join("keys");
    let have_key = keys.join("resid-ed25519.key").exists();
    if !have_key {
        let out = Command::new(residc_bin())
            .arg("keygen")
            .current_dir(workspace)
            .output()
            .expect("keygen");
        assert_eq!(out.status.code(), Some(0));
    }
    let file = dir.join("main.resid");
    std::fs::write(
        &file,
        "Int main() {\n    filesystem.write_all(\"side.txt\", \"d\");\n    return 0;\n}\n",
    )
    .unwrap();
    let bin = dir.join("st2bin");
    let out = Command::new(residc_bin())
        .arg(workspace.join("examples/driver.resid"))
        .arg("run")
        .arg(&file)
        .arg("-o")
        .arg(&bin)
        .arg("-rt")
        .arg(workspace.join("crates/residc/resid_rt.c"))
        .current_dir(workspace) // driver looks for keys/ relative to cwd
        .output()
        .expect("failed to run driver");
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    let sidecar_path = dir.join("st2bin.resid-prov");
    assert!(sidecar_path.exists(), "sidecar missing: {}", String::from_utf8_lossy(&out.stdout));
    let out2 = Command::new(residc_bin())
        .arg("verify")
        .arg(&sidecar_path)
        .current_dir(workspace)
        .output()
        .expect("verify");
    let stdout = String::from_utf8_lossy(&out2.stdout).into_owned();
    assert!(stdout.contains("SIGNATURE OK"), "verify output: {stdout}");
    // Sidecar payload embeds the driver's own residual notes.
    let sidecar = std::fs::read_to_string(&sidecar_path).unwrap();
    assert!(
        sidecar.contains("toolchain=resid-stage2;source_sha256="),
        "sidecar payload malformed: {sidecar}"
    );
    // The driver embeds its own residual scan: the provider call above.
    assert!(
        sidecar.contains("records=provider-call@"),
        "sidecar missing residual records: {sidecar}"
    );
    let _ = std::fs::remove_dir_all(&dir);
    if !have_key {
        let _ = std::fs::remove_file(keys.join("resid-ed25519.key"));
        let _ = std::fs::remove_file(keys.join("resid-ed25519.pub"));
    }
}

/// `else if` chains parse and execute correctly in both the Rust pipeline
/// and the stage-2 bootstrap compiler (regression: parser never consumed
/// the `if` after `else`; stage-2 codegen had no chain support).
#[test]
fn run_else_if_chain() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-elseif-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap();
    for (x, want) in [("5", "big"), ("2", "mid"), ("0", "small")] {
        let file = dir.join("main.resid");
        std::fs::write(
            &file,
            format!(
                r#"
Int main() {{
    Int x = {x};
    if (x > 3) {{
        println("big");
    }} else if (x > 1) {{
        println("mid");
    }} else {{
        println("small");
    }}
    return 0;
}}
"#
            ),
        )
        .unwrap();
        // Rust pipeline
        let out = Command::new(residc_bin())
            .arg(&file)
            .arg("run")
            .output()
            .expect("failed to run residc");
        assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
        assert_eq!(String::from_utf8_lossy(&out.stdout).trim(), want, "rust pipe x={x}");
        // Stage-2 bootstrap pipeline
        let bin = dir.join(format!("drv_{x}"));
        let out2 = Command::new(residc_bin())
            .arg(workspace.join("examples/driver.resid"))
            .arg("run")
            .arg(&file)
            .arg("-o")
            .arg(&bin)
            .arg("-rt")
            .arg(workspace.join("crates/residc/resid_rt.c"))
            .output()
            .expect("failed to run driver");
        assert_eq!(out2.status.code(), Some(0), "{}", String::from_utf8_lossy(&out2.stderr));
        let out3 = Command::new(&bin).output().expect("failed to exec");
        assert_eq!(String::from_utf8_lossy(&out3.stdout).trim(), want, "stage-2 x={x}");
    }
    let _ = std::fs::remove_dir_all(&dir);
}

/// Ed25519 deterministic signing in pure Resid: derived pubkey matches the
/// RFC 8032 test-1 vector, signed message verifies, tampered fails.
#[test]
fn run_ed25519_sign_in_resid() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-edsign-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap();
    std::fs::copy(workspace.join("lib/crypto.resid"), dir.join("crypto.resid")).unwrap();
    std::fs::copy(workspace.join("lib/ed25519.resid"), dir.join("ed25519.resid")).unwrap();
    let file = dir.join("main.resid");
    std::fs::write(
        &file,
        r#"
import "ed25519.resid";
Str hexs(List(Int) bs) {
    return hex_range_b(bs, 1, 32, "");
}
Int main() {
    List(Int) sd = [0, 157, 97, 177, 157, 239, 253, 90, 96, 186, 132, 74, 244, 146, 236, 44, 196, 68, 73, 197, 105, 123, 50, 105, 25, 112, 59, 172, 3, 28, 174, 127, 96];
    println(hexs(pub_key(sd)));
    List(Int) sg = sign_msg(sd, "hello world");
    Bool ok = verify_sig("hello world", sg, pub_key(sd));
    if (ok) { println("SELF-VERIFY-OK"); }
    if (!ok) { println("SELF-VERIFY-BAD"); }
    Bool bad = verify_sig("other msg", sg, pub_key(sd));
    if (bad) { println("WRONG-MSG-ACCEPTED"); }
    if (!bad) { println("WRONG-MSG-REJECTED"); }
    return 0;
}
"#,
    )
    .unwrap();
    let out = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("failed to run residc");
    let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    assert_eq!(
        stdout.trim(),
        "d75a980182b10ab7d54bfed3c964073a0ee172f3daa62325af021a68f707511a\nSELF-VERIFY-OK\nWRONG-MSG-REJECTED",
        "{stdout:?}"
    );
    let _ = std::fs::remove_dir_all(&dir);
}

/// Ed25519 verification in pure Resid (Int(256) field math) — valid sig
/// accepted, tampered sig rejected.
#[test]
fn run_ed25519_verify_in_resid() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-ed25519-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap();
    std::fs::copy(workspace.join("lib/crypto.resid"), dir.join("crypto.resid")).unwrap();
    std::fs::copy(workspace.join("lib/ed25519.resid"), dir.join("ed25519.resid")).unwrap();
    let file = dir.join("main.resid");
    std::fs::write(
        &file,
        r#"
import "ed25519.resid";
Int main() {
    List(Int) sg = [0, 44, 84, 130, 57, 42, 25, 126, 192, 159, 163, 55, 119, 149, 141, 58, 11, 228, 244, 150, 10, 248, 94, 151, 150, 164, 216, 34, 201, 94, 207, 112, 74, 52, 254, 211, 42, 219, 105, 154, 136, 192, 234, 135, 107, 159, 187, 23, 209, 219, 211, 54, 247, 84, 253, 146, 7, 191, 193, 18, 200, 154, 165, 79, 2];
    List(Int) pk = [0, 215, 90, 152, 1, 130, 177, 10, 183, 213, 75, 254, 211, 201, 100, 7, 58, 14, 225, 114, 243, 218, 166, 35, 37, 175, 2, 26, 104, 247, 7, 81, 26];
    Bool ok = verify_sig("hello world", sg, pk);
    if (ok) { println("VALID"); }
    if (!ok) { println("INVALID"); }
    List(Int) bad = [0, 44, 84, 130, 57, 42, 25, 126, 192, 159, 163, 55, 119, 149, 141, 58, 11, 228, 244, 150, 10, 248, 94, 151, 150, 164, 216, 34, 201, 94, 207, 112, 74, 52, 254, 211, 42, 219, 105, 154, 136, 193, 234, 135, 107, 159, 187, 23, 209, 219, 211, 54, 247, 84, 253, 146, 7, 191, 193, 18, 200, 154, 165, 79, 2];
    Bool ok2 = verify_sig("hello world", bad, pk);
    if (ok2) { println("TAMPER-ACCEPTED"); }
    if (!ok2) { println("TAMPER-REJECTED"); }
    return 0;
}
"#,
    )
    .unwrap();
    let out = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("failed to run residc");
    let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    assert_eq!(stdout.trim(), "VALID\nTAMPER-REJECTED", "{stdout:?}");
    let _ = std::fs::remove_dir_all(&dir);
}

/// X25519 (RFC 7748) in pure Resid — §5.2 vectors plus §6.1 DH keygen and
/// shared-secret agreement through both directions.
#[test]
fn run_x25519_in_resid() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-x25519-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap();
    std::fs::copy(workspace.join("lib/crypto.resid"), dir.join("crypto.resid")).unwrap();
    std::fs::copy(workspace.join("lib/ed25519.resid"), dir.join("ed25519.resid")).unwrap();
    std::fs::copy(workspace.join("lib/x25519.resid"), dir.join("x25519.resid")).unwrap();
    let file = dir.join("main.resid");
    std::fs::write(
        &file,
        r#"
import "x25519.resid";
import "crypto.resid";
Int hv(Str s, Int i) {
    Int c = str_char_at(s, i);
    if (c > 96) { return c - 87; }
    return c - 48;
}
List(Int) hb_acc(Str s, Int i, List(Int) acc) {
    if (i >= str_len(s)) { return acc; }
    Int ii = i + 1;
    Int hi = hv(s, i);
    Int lo = hv(s, ii);
    Int h16 = hi * 16;
    Int byt = h16 + lo;
    List(Int) acc2 = acc.concat([byt]);
    Int ni = i + 2;
    return hb_acc(s, ni, acc2);
}
List(Int) hb(Str s) {
    return hb_acc(s, 0, [0]);
}
Int main() {
    // RFC 7748 section 5.2 vector 1
    List(Int) k1 = hb("a546e36bf0527c9d3b16154b82465edd62144c0ac1fc5a18506a2244ba449ac4");
    List(Int) u1 = hb("e6db6867583030db3594c1a424b15f7c726624ec26b3353b10a903a6d0ab1c4c");
    println(hex_encode(x25519(k1, u1)));
    // RFC 7748 section 5.2 vector 2
    List(Int) k2 = hb("4b66e9d4d1b4673c5ad22691957d6af5c11b6421e0ea01d42ca4169e7918ba0d");
    List(Int) u2 = hb("e5210f12786811d3f4b7959d0538ae2c31dbe7106fc03c3efc4cd549c715a493");
    println(hex_encode(x25519(k2, u2)));
    // RFC 7748 section 6.1: public keys from private scalars
    List(Int) ask = hb("77076d0a7318a57d3c16c17251b26645df4c2f87ebc0992ab177fba51db92c2a");
    List(Int) bsk = hb("5dab087e624a8a4b79e17f8b83800ee66f3bb1292618b6fd1c2f8b27ff88e0eb");
    List(Int) base = hb("0900000000000000000000000000000000000000000000000000000000000000");
    println(hex_encode(x25519(ask, base)));
    println(hex_encode(x25519(bsk, base)));
    // shared secret, both directions
    List(Int) apub = hb("8520f0098930a754748b7ddcb43ef75a0dbf3a0d26381af4eba4a98eaa9b4e6a");
    List(Int) bpub = hb("de9edb7d7b7dc1b4d35b61c2ece435373f8343c85b78674dadfc7e146f882b4f");
    println(hex_encode(x25519(ask, bpub)));
    println(hex_encode(x25519(bsk, apub)));
    return 0;
}
"#,
    )
    .unwrap();
    let out = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("failed to run residc");
    let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    assert_eq!(
        stdout.trim(),
        "c3da55379de9c6908e94ea4df28d084f32eccf03491c71f754b4075577a28552\n\
         95cbde9476e8907d7aade45cb4b873f88b595a68799fa152e6f8f7647aac7957\n\
         8520f0098930a754748b7ddcb43ef75a0dbf3a0d26381af4eba4a98eaa9b4e6a\n\
         de9edb7d7b7dc1b4d35b61c2ece435373f8343c85b78674dadfc7e146f882b4f\n\
         4a5d9d5ba4ce2de1728e3bf480350f25e07e21c947d19e3376f09b3c1e161742\n\
         4a5d9d5ba4ce2de1728e3bf480350f25e07e21c947d19e3376f09b3c1e161742",
        "{stdout:?}"
    );
    let _ = std::fs::remove_dir_all(&dir);
}

/// HKDF-SHA256 (RFC 5869) in pure Resid — test cases 1, 2 and 3
/// (incl. empty salt/info and multi-block output) against published vectors.
#[test]
fn run_hkdf_in_resid() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-hkdf-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap();
    std::fs::copy(workspace.join("lib/crypto.resid"), dir.join("crypto.resid")).unwrap();
    let file = dir.join("main.resid");
    std::fs::write(
        &file,
        r#"
import "crypto.resid";
List(Int) rng_acc(Int lo, Int hi, List(Int) acc) {
    if (lo > hi) { return acc; }
    List(Int) acc2 = acc.concat([lo]);
    Int ni = lo + 1;
    return rng_acc(ni, hi, acc2);
}
List(Int) rep_acc(Int n, Int b, List(Int) acc) {
    if (n == 0) { return acc; }
    List(Int) acc2 = acc.concat([b]);
    Int nn = n - 1;
    return rep_acc(nn, b, acc2);
}
Int main() {
    // RFC 5869 case 1
    List(Int) salt = rng_acc(0x00, 0x0c, [0]);
    List(Int) ikm1 = rep_acc(22, 0x0b, [0]);
    List(Int) info = rng_acc(0xf0, 0xf9, [0]);
    println(hex_encode(hkdf_extract(salt, ikm1)));
    println(hex_encode(hkdf_expand(hkdf_extract(salt, ikm1), info, 42)));
    // RFC 5869 case 3 (empty salt + empty info)
    println(hex_encode(hkdf_extract([0], ikm1)));
    println(hex_encode(hkdf_expand(hkdf_extract([0], ikm1), [0], 42)));
    // RFC 5869 case 2 style long inputs
    List(Int) ikm2 = rng_acc(0x00, 0x4f, [0]);
    List(Int) salt2 = rng_acc(0x60, 0xaf, [0]);
    List(Int) info2 = rng_acc(0xb0, 0xff, [0]);
    println(hex_encode(hkdf_expand(hkdf_extract(salt2, ikm2), info2, 82)));
    return 0;
}
"#,
    )
    .unwrap();
    let out = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("failed to run residc");
    let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    assert_eq!(
        stdout.trim(),
        "077709362c2e32df0ddc3f0dc47bba6390b6c73bb50f9c3122ec844ad7c2b3e5\n\
         3cb25f25faacd57a90434f64d0362f2a2d2d0a90cf1a5a4c5db02d56ecc4c5bf34007208d5b887185865\n\
         19ef24a32c717b167f33a91d6f648bdf96596776afdb6377ac434c1c293ccb04\n\
         8da4e775a563c18f715f802a063c5a31b8a11f5c5ee1879ec3454e5f3c738d2d9d201395faa4b61a96c8\n\
         b11e398dc80327a1c8e7f78c596a49344f012eda2d4efad8a050cc4c19afa97c59045a99cac7827271cb41c65e590e09da3275600c2f09b8367793a9aca3db71cc30c58179ec3e87c14c01d5c1f3434f1d87",
        "{stdout:?}"
    );
    let _ = std::fs::remove_dir_all(&dir);
}

/// ChaCha20-Poly1305 AEAD (RFC 8439) in pure Resid — §2.5.2 Poly1305
/// vector and §2.8.2 AEAD vector (ct + tag byte-exact), plus roundtrip
/// open and tamper rejection.
#[test]
fn run_chacha20poly1305_in_resid() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-chacha-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap();
    for f in ["crypto.resid", "chacha.resid"] {
        std::fs::copy(workspace.join("lib").join(f), dir.join(f)).unwrap();
    }
    let file = dir.join("main.resid");
    std::fs::write(
        &file,
        format!(
            r#"
import "chacha.resid";
import "crypto.resid";

List(Int) hb_acc(Str s, Int i, List(Int) acc) {{
    if (i >= str_len(s)) {{ return acc; }}
    Int c = str_char_at(s, i);
    Int dhi = c - 87;
    Int dlo = c - 48;
    Int hi = if (c > 96) {{ dhi }} else {{ dlo }};
    Int j = i + 1;
    Int c2 = str_char_at(s, j);
    Int ehi = c2 - 87;
    Int elo = c2 - 48;
    Int lo = if (c2 > 96) {{ ehi }} else {{ elo }};
    Int h16 = hi * 16;
    Int byt = h16 + lo;
    List(Int) acc2 = acc.concat([byt]);
    Int ni = i + 2;
    return hb_acc(s, ni, acc2);
}}

List(Int) hb(Str s) {{
    return hb_acc(s, 0, [0]);
}}

Int main() {{
    // RFC 8439 section 2.5.2 Poly1305
    List(Int) mk = hb("85d6be7857556d337f4452fe42d506a80103808afb0db2fd4abff6af4149f51b");
    println(hex_encode(poly1305(mk, bytes_of("Cryptographic Forum Research Group"))));
    // RFC 8439 section 2.8.2 AEAD seal
    List(Int) key = hb("808182838485868788898a8b8c8d8e8f909192939495969798999a9b9c9d9e9f");
    List(Int) nonce = hb("070000004041424344454647");
    List(Int) pt = bytes_of("Ladies and Gentlemen of the class of '99: If I could offer you only one tip for the future, sunscreen would be it.");
    List(Int) aad = hb("50515253c0c1c2c3c4c5c6c7");
    List(Int) sealed = chacha20poly1305_seal(key, nonce, pt, aad);
    println(hex_encode(sealed));
    Bool ok = chacha20poly1305_open(key, nonce, sealed, aad);
    if (ok) {{ println("OPEN-OK"); }}
    List(Int) bad = ls_set(sealed, 3, sealed[3] ^ 1);
    Bool ok2 = chacha20poly1305_open(key, nonce, bad, aad);
    if (!ok2) {{ println("TAMPER-REJECTED"); }}
    return 0;
}}
"#
        ),
    )
    .unwrap();
    let out = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("failed to run residc");
    let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    assert_eq!(
        stdout.trim(),
        "a8061dc1305136c6c22b8baf0c0127a9\n\
         d31a8d34648e60db7b86afbc53ef7ec2a4aded51296e08fea9e2b5a736ee62d63dbea45e8ca9671282fafb69da92728b1a71de0a9e060b2905d6a5b67ecd3b3692ddbd7f2d778b8c9803aee328091b58fab324e4fad675945585808b4831d7bc3ff4def08e4b7a9de576d26586cec64b61161ae10b594f09e26a7e902ecbd0600691\n\
         OPEN-OK\n\
         TAMPER-REJECTED",
        "{stdout:?}"
    );
    let _ = std::fs::remove_dir_all(&dir);
}

/// AES-128-GCM (NIST SP 800-38D) in pure Resid — test cases 1-4
/// (incl. multi-block and AAD) plus roundtrip open.
#[test]
fn run_aes128gcm_in_resid() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-aesgcm-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap();
    for f in ["crypto.resid", "aesgcm.resid"] {
        std::fs::copy(workspace.join("lib").join(f), dir.join(f)).unwrap();
    }
    let file = dir.join("main.resid");
    std::fs::write(
        &file,
        r#"
import "aesgcm.resid";
import "crypto.resid";

List(Int) hb_acc(Str s, Int i, List(Int) acc) {
    if (i >= str_len(s)) { return acc; }
    Int c = str_char_at(s, i);
    Int dhi = c - 87;
    Int dlo = c - 48;
    Int hi = if (c > 96) { dhi } else { dlo };
    Int j = i + 1;
    Int c2 = str_char_at(s, j);
    Int ehi = c2 - 87;
    Int elo = c2 - 48;
    Int lo = if (c2 > 96) { ehi } else { elo };
    Int h16 = hi * 16;
    Int byt = h16 + lo;
    List(Int) acc2 = acc.concat([byt]);
    Int ni = i + 2;
    return hb_acc(s, ni, acc2);
}

List(Int) hb(Str s) {
    return hb_acc(s, 0, [0]);
}

List(Int) rep(Int n, Int b, List(Int) acc) {
    if (n == 0) { return acc; }
    List(Int) acc2 = acc.concat([b]);
    Int nn = n - 1;
    return rep(nn, b, acc2);
}

Int main() {
    List(Int) key0 = rep(16, 0, [0]);
    List(Int) iv0 = rep(12, 0, [0]);
    List(Int) aad0 = [0];
    println(hex_encode(aes128_gcm_seal(key0, iv0, [0], aad0)));
    List(Int) r2 = aes128_gcm_seal(key0, iv0, rep(16, 0, [0]), aad0);
    println(hex_encode(r2));
    List(Int) r3 = aes128_gcm_seal(key0, iv0, rep(16, 0, [0]), rep(16, 0, [0]));
    println(hex_encode(r3));
    List(Int) key4 = hb("feffe9928665731c6d6a8f9467308308");
    List(Int) iv4 = hb("cafebabefacedbaddecaf888");
    List(Int) pt4 = hb("d9313225f88406e5a55909c5aff5269a86a7a9531534f7da2e4c303d8a318a721c3c0c95956809532fcf0e2449a6b525b16aedf5aa0de657ba637b3914a2adf83ea685c2acaeaa70a5b99c");
    List(Int) aad4 = hb("feedfacedeadbeeffeedfacedeadbeefabaddad2");
    List(Int) r4 = aes128_gcm_seal(key4, iv4, pt4, aad4);
    println(hex_encode(r4));
    Bool o4 = aes128_gcm_open(key4, iv4, r4, aad4);
    if (o4) { println("OPEN-OK"); }
    return 0;
}
"#,
    )
    .unwrap();
    let out = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("failed to run residc");
    let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    assert_eq!(
        stdout.trim(),
        "58e2fccefa7e3061367f1d57a4e7455a\n\
         0388dace60b6a392f328c2b971b2fe78ab6e47d42cec13bdf53a67b21257bddf\n\
         0388dace60b6a392f328c2b971b2fe78d24e503a1bb037071c71b35d987b8657\n\
         42831ec2217774244b7221b784d0d49ce3aa212f2c02a4e035c17e2329aca12e21d514b25466931c7d8f6a5aac84aa051ba30b396a0aac973d58e09149322628e30ee206625c1b811d10632b1dcaa49d714c5faf22659c4337fe5d\n\
         OPEN-OK",
        "{stdout:?}"
    );
    let _ = std::fs::remove_dir_all(&dir);
}

/// TLS 1.3 handshake core (RFC 8446) in pure Resid, pinned to the
/// RFC 8448 simplified trace: transcript hashes, key schedule from the
/// X25519 shared secret, traffic secrets and keys, server Finished,
/// application secrets — plus AES-128-GCM record protection interop
/// with a Python-sealed record (open + re-seal byte-exact).
#[test]
fn run_tls13_handshake_in_resid() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-tls13-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent().unwrap().parent().unwrap();
    for f in ["crypto.resid", "aesgcm.resid", "ed25519.resid", "x25519.resid", "tls.resid"] {
        std::fs::copy(workspace.join("lib").join(f), dir.join(f)).unwrap();
    }
    let file = dir.join("main.resid");
    std::fs::write(
        &file,
        r#"
import "tls.resid";
import "crypto.resid";
import "aesgcm.resid";
import "x25519.resid";

List(Int) hb_acc(Str s, Int i, List(Int) acc) {
    if (i >= str_len(s)) { return acc; }
    Int c = str_char_at(s, i);
    Int dhi = c - 87;
    Int dlo = c - 48;
    Int hi = if (c > 96) { dhi } else { dlo };
    Int j = i + 1;
    Int c2 = str_char_at(s, j);
    Int ehi = c2 - 87;
    Int elo = c2 - 48;
    Int lo = if (c2 > 96) { ehi } else { elo };
    Int h16 = hi * 16;
    Int byt = h16 + lo;
    List(Int) acc2 = acc.concat([byt]);
    Int ni = i + 2;
    return hb_acc(s, ni, acc2);
}

List(Int) hb(Str s) {
    return hb_acc(s, 0, [0]);
}

Str ck(Str name, List(Int) got, Str want) {
    Str g = hex_encode(got);
    if (g == want) {
        println(name + " OK");
    } else {
        println(name + " BAD");
        println(g);
    }
    return g;
}

Int main() {
    List(Int) ch = hb("010000c00303cb34ecb1e78163ba1c38c6dacb196a6dffa21a8d9912ec18a2ef6283024dece7000006130113031302010000910000000b0009000006736572766572ff01000100000a00140012001d0017001800190100010101020103010400230000003300260024001d002099381de560e4bd43d23d8e435a7dbafeb3c06e51c13cae4d5413691e529aaf2c002b0003020304000d0020001e040305030603020308040805080604010501060102010402050206020202002d00020101001c00024001");
    List(Int) sh = hb("020000560303a6af06a4121860dc5e6e60249cd34c95930c8ac5cb1434dac155772ed3e2692800130100002e00330024001d0020c9828876112095fe66762bdbf7c672e156d6cc253b833df1dd69b1b04e751f0f002b00020304");
    List(Int) ee = hb("080000240022000a00140012001d00170018001901000101010201030104001c0002400100000000");
    List(Int) ctmsg = hb("0b0001b9000001b50001b0308201ac30820115a003020102020102300d06092a864886f70d01010b0500300e310c300a06035504031303727361301e170d3136303733303031323335395a170d3236303733303031323335395a300e310c300a0603550403130372736130819f300d06092a864886f70d010101050003818d0030818902818100b4bb498f8279303d980836399b36c6988c0c68de55e1bdb826d3901a2461eafd2de49a91d015abbc9a95137ace6c1af19eaa6af98c7ced43120998e187a80ee0ccb0524b1b018c3e0b63264d449a6d38e22a5fda430846748030530ef0461c8ca9d9efbfae8ea6d1d03e2bd193eff0ab9a8002c47428a6d35a8d88d79f7f1e3f0203010001a31a301830090603551d1304023000300b0603551d0f0404030205a0300d06092a864886f70d01010b05000381810085aad2a0e5b9276b908c65f73a7267170618a54c5f8a7b337d2df7a594365417f2eae8f8a58c8f8172f9319cf36b7fd6c55b80f21a03015156726096fd335e5e67f2dbf102702e608ccae6bec1fc63a42a99be5c3eb7107c3c54e9b9eb2bd5203b1c3b84e0a8b2f759409ba3eac9d91d402dcc0cc8f8961229ac9187b42b4de10000");
    List(Int) cv = hb("0f000084080400805a747c5d88fa9bd2e55ab085a61015b7211f824cd484145ab3ff52f1fda8477b0b7abc90db78e2d33a5c141a078653fa6bef780c5ea248eeaaa785c4f394cab6d30bbe8d4859ee511f602957b15411ac027671459e46445c9ea58c181e818e95b8c3fb0bf3278409d3be152a3da5043e063dda65cdf5aea20d53dfacd42f74f3");
    List(Int) finmsg = hb("140000209b9b141d906337fbd2cbdce71df4deda4ab42c309572cb7fffee5454b78f0718");
    List(Int) cpriv = hb("49af42ba7f7994852d713ef2784bcbcaa7911de26adc5642cb634540e7ea5005");
    List(Int) spub = hb("c9828876112095fe66762bdbf7c672e156d6cc253b833df1dd69b1b04e751f0f");
    // transcript CH||SH
    List(Int) tr1 = sconcat(ch, sh);
    List(Int) th1 = slice_seed(sha256_bytes(tr1), 1, 32, [0]);
    ck("th1", th1, "860c06edc07858ee8e78f0e7428c58edd6b43f2ca3e6e95f02ed063cf0e1cad8");
    // key schedule from X25519 shared secret
    List(Int) shared = x25519(cpriv, spub);
    ck("shared", shared, "8bd4054fb55b9d63fdfbacf9f04b9f0d35e6d63f537563efd46272900f89492d");
    List(Int) hs = tls_handshake_secret(shared);
    ck("handshake-secret", hs, "1dc826e93606aa6fdc0aadc12f741b01046aa6b99f691ed221a9f0ca043fbeac");
    List(Int) c_hs = tls_c_hs_traffic(hs, th1);
    ck("c-hs-traffic", c_hs, "b3eddb126e067f35a780b3abf45e2d8f3b1a950738f52e9600746a0e27a55a21");
    List(Int) s_hs = tls_s_hs_traffic(hs, th1);
    ck("s-hs-traffic", s_hs, "b67b7d690cc16c4e75e54213cb2d37b4e9c912bcded9105d42befd59d391ad38");
    List(Int) master = tls_master_secret(hs);
    ck("master", master, "18df06843d13a08bf2a449844c5f8a478001bc4d4c627984d5a41da8d0402919");
    // server handshake traffic keys
    List(Int) skey = tls_traffic_key(s_hs);
    ck("s-hs-key", skey, "3fce516009c21727d0f2e4e86ee403bc");
    List(Int) siv = tls_traffic_iv(s_hs);
    ck("s-hs-iv", siv, "5d313eb2671276ee13000b30");
    // server Finished over transcript CH..CV
    List(Int) tr2 = sconcat(tr1, ee);
    List(Int) tr3 = sconcat(tr2, ctmsg);
    List(Int) tr4 = sconcat(tr3, cv);
    List(Int) th_sv = slice_seed(sha256_bytes(tr4), 1, 32, [0]);
    List(Int) svfin = tls_finished(s_hs, th_sv);
    ck("server-finished", svfin, "9b9b141d906337fbd2cbdce71df4deda4ab42c309572cb7fffee5454b78f0718");
    // transcript through server Finished -> application secrets
    List(Int) tr5 = sconcat(tr4, finmsg);
    List(Int) th_ap = slice_seed(sha256_bytes(tr5), 1, 32, [0]);
    ck("th-ap", th_ap, "9608102a0f1ccc6db6250b7b7e417b1a000eaada3daae4777a7686c9ff83df13");
    List(Int) c_ap = tls_c_ap_traffic(master, th_ap);
    ck("c-ap-traffic", c_ap, "9e40646ce79a7f9dc05af8889bce6552875afa0b06df0087f792ebb7c17504a5");
    List(Int) s_ap = tls_s_ap_traffic(master, th_ap);
    ck("s-ap-traffic", s_ap, "a11af9f05531f856ad47116b45a950328204b4f44bfb6b3a4b4f1f3fcb631643");
    // record layer: open a Python-sealed server-handshake record
    List(Int) nonce = tls_record_nonce(siv, 0);
    List(Int) hdr = tls_record_header(36);
    List(Int) rec = hb("cdff334e47c6aeed484f16cf96b991252e591e4df498f7e32ae04ecd687cedf91bb75bb25334c4ebbfda5c46c16eb7c38322ae39");
    Bool opened = tls_record_open(skey, nonce, hdr, rec);
    if (opened) { println("RECORD-OPEN OK"); } else { println("RECORD-OPEN BAD"); }
    // seal it back and compare
    List(Int) innerpt = hb("14000020" + "1111111111111111111111111111111111111111111111111111111111111111");
    List(Int) sealed = tls_record_seal(skey, nonce, hdr, innerpt);
    ck("record-seal", sealed, "cdff334e47c6aeed484f16cf96b991252e591e4df498f7e32ae04ecd687cedf91bb75bb25334c4ebbfda5c46c16eb7c38322ae39");
    return 0;
}

"#,
    )
    .unwrap();
    let out = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("failed to run residc");
    let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    for line in [
        "th1 OK", "shared OK", "handshake-secret OK", "c-hs-traffic OK",
        "s-hs-traffic OK", "master OK", "s-hs-key OK", "s-hs-iv OK",
        "server-finished OK", "th-ap OK", "c-ap-traffic OK", "s-ap-traffic OK",
        "RECORD-OPEN OK", "record-seal OK",
    ] {
        assert!(stdout.contains(line), "missing {line} in {stdout:?}");
    }
    let _ = std::fs::remove_dir_all(&dir);
}

/// TLS 1.3 message framing in pure Resid: ClientHello construction is
/// byte-exact against the RFC 8448 trace, ServerHello parsing recovers
/// random + x25519 key share, the handshake flight walks EE/CT/CV/Fin,
/// Certificate DER extraction matches, and an ECDSA-P256
/// CertificateVerify over the trace transcript verifies.
#[test]
fn run_tls13_framing_in_resid() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-tlsmsg-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent().unwrap().parent().unwrap();
    for f in ["crypto.resid","aesgcm.resid","ed25519.resid","x25519.resid","tls.resid","tlsmsg.resid","chain.resid","rsa.resid","ec256.resid","der.resid","x509.resid"] {
        std::fs::copy(workspace.join("lib").join(f), dir.join(f)).unwrap();
    }
    let file = dir.join("main.resid");
    std::fs::write(&file, r#"
import "tlsmsg.resid";
import "tls.resid";
import "crypto.resid";
import "aesgcm.resid";
import "x25519.resid";
import "chain.resid";

List(Int) hb_acc(Str s, Int i, List(Int) acc) {
    if (i >= str_len(s)) { return acc; }
    Int c = str_char_at(s, i);
    Int dhi = c - 87;
    Int dlo = c - 48;
    Int hi = if (c > 96) { dhi } else { dlo };
    Int j = i + 1;
    Int c2 = str_char_at(s, j);
    Int ehi = c2 - 87;
    Int elo = c2 - 48;
    Int lo = if (c2 > 96) { ehi } else { elo };
    Int h16 = hi * 16;
    Int byt = h16 + lo;
    List(Int) acc2 = acc.concat([byt]);
    Int ni = i + 2;
    return hb_acc(s, ni, acc2);
}

List(Int) hb(Str s) {
    return hb_acc(s, 0, [0]);
}

Str ck(Str name, Str got, Str want) {
    if (got == want) { println(name + " OK"); } else { println(name + " BAD"); println(got); }
    return got;
}

Int main() {
    List(Int) rnd = hb("cb34ecb1e78163ba1c38c6dacb196a6dffa21a8d9912ec18a2ef6283024dece7");
    List(Int) cshare = hb("99381de560e4bd43d23d8e435a7dbafeb3c06e51c13cae4d5413691e529aaf2c");
    List(Int) mych = tlsmsg_client_hello_rfc(rnd, cshare);
    ck("client-hello", hex_encode(mych), "010000c00303cb34ecb1e78163ba1c38c6dacb196a6dffa21a8d9912ec18a2ef6283024dece7000006130113031302010000910000000b0009000006736572766572ff01000100000a00140012001d0017001800190100010101020103010400230000003300260024001d002099381de560e4bd43d23d8e435a7dbafeb3c06e51c13cae4d5413691e529aaf2c002b0003020304000d0020001e040305030603020308040805080604010501060102010402050206020202002d00020101001c00024001");
    List(Int) shmsg = hb("020000560303a6af06a4121860dc5e6e60249cd34c95930c8ac5cb1434dac155772ed3e2692800130100002e00330024001d0020c9828876112095fe66762bdbf7c672e156d6cc253b833df1dd69b1b04e751f0f002b00020304");
    List(Int) shr = sh_random(shmsg);
    ck("sh-random", hex_encode(shr), "a6af06a4121860dc5e6e60249cd34c95930c8ac5cb1434dac155772ed3e26928");
    List(Int) shp = sh_pubkey(shmsg);
    ck("sh-pubkey", hex_encode(shp), "c9828876112095fe66762bdbf7c672e156d6cc253b833df1dd69b1b04e751f0f");
    List(Int) flight = hb("080000240022000a00140012001d00170018001901000101010201030104001c00024001000000000b0001b9000001b50001b0308201ac30820115a003020102020102300d06092a864886f70d01010b0500300e310c300a06035504031303727361301e170d3136303733303031323335395a170d3236303733303031323335395a300e310c300a0603550403130372736130819f300d06092a864886f70d010101050003818d0030818902818100b4bb498f8279303d980836399b36c6988c0c68de55e1bdb826d3901a2461eafd2de49a91d015abbc9a95137ace6c1af19eaa6af98c7ced43120998e187a80ee0ccb0524b1b018c3e0b63264d449a6d38e22a5fda430846748030530ef0461c8ca9d9efbfae8ea6d1d03e2bd193eff0ab9a8002c47428a6d35a8d88d79f7f1e3f0203010001a31a301830090603551d1304023000300b0603551d0f0404030205a0300d06092a864886f70d01010b05000381810085aad2a0e5b9276b908c65f73a7267170618a54c5f8a7b337d2df7a594365417f2eae8f8a58c8f8172f9319cf36b7fd6c55b80f21a03015156726096fd335e5e67f2dbf102702e608ccae6bec1fc63a42a99be5c3eb7107c3c54e9b9eb2bd5203b1c3b84e0a8b2f759409ba3eac9d91d402dcc0cc8f8961229ac9187b42b4de100000f000084080400805a747c5d88fa9bd2e55ab085a61015b7211f824cd484145ab3ff52f1fda8477b0b7abc90db78e2d33a5c141a078653fa6bef780c5ea248eeaaa785c4f394cab6d30bbe8d4859ee511f602957b15411ac027671459e46445c9ea58c181e818e95b8c3fb0bf3278409d3be152a3da5043e063dda65cdf5aea20d53dfacd42f74f3140000209b9b141d906337fbd2cbdce71df4deda4ab42c309572cb7fffee5454b78f0718");
    println(IntToString(tm_type_at(flight, 1)));
    Int pe = tm_find_pos(flight, 8, 0);
    Int pc = tm_find_pos(flight, 11, 0);
    Int pv = tm_find_pos(flight, 15, 0);
    Int pf = tm_find_pos(flight, 20, 0);
    println(IntToString(pe));
    println(IntToString(pc));
    println(IntToString(pv));
    println(IntToString(pf));
    // full messages for the transcript
    List(Int) ee = tm_full_msg(flight, pe);
    List(Int) ctmsg = tm_full_msg(flight, pc);
    List(Int) cvmsg = tm_full_msg(flight, pv);
    List(Int) finmsg = tm_full_msg(flight, pf);
    List(Int) certder = tm_cert_der(tm_body(flight, pc));
    ck("cert-der", hex_encode(certder), "308201ac30820115a003020102020102300d06092a864886f70d01010b0500300e310c300a06035504031303727361301e170d3136303733303031323335395a170d3236303733303031323335395a300e310c300a0603550403130372736130819f300d06092a864886f70d010101050003818d0030818902818100b4bb498f8279303d980836399b36c6988c0c68de55e1bdb826d3901a2461eafd2de49a91d015abbc9a95137ace6c1af19eaa6af98c7ced43120998e187a80ee0ccb0524b1b018c3e0b63264d449a6d38e22a5fda430846748030530ef0461c8ca9d9efbfae8ea6d1d03e2bd193eff0ab9a8002c47428a6d35a8d88d79f7f1e3f0203010001a31a301830090603551d1304023000300b0603551d0f0404030205a0300d06092a864886f70d01010b05000381810085aad2a0e5b9276b908c65f73a7267170618a54c5f8a7b337d2df7a594365417f2eae8f8a58c8f8172f9319cf36b7fd6c55b80f21a03015156726096fd335e5e67f2dbf102702e608ccae6bec1fc63a42a99be5c3eb7107c3c54e9b9eb2bd5203b1c3b84e0a8b2f759409ba3eac9d91d402dcc0cc8f8961229ac9187b42b4de1");
    // transcript CH||SH||EE||CT||CV
    List(Int) tr1 = sconcat(mych, shmsg);
    List(Int) tr2 = sconcat(tr1, ee);
    List(Int) tr3 = sconcat(tr2, ctmsg);
    List(Int) trcv = sconcat(tr3, cvmsg);
    List(Int) thcvraw = sha256_bytes(trcv);
    List(Int) thcv = slice_seed(thcvraw, 1, 32, [0]);
    ck("th-cv", hex_encode(thcv), "edb7725fa7a3473b031ec8ef65a2485493900138a2b91291407d7951a06110ed");
    // ECDSA CertificateVerify with own EC cert over the same transcript
    List(Int) ecdsa_cert = hb("3082017e30820125a0030201020214557826b8d723dbfb5853602a3bf8f1bbfecf9abc300a06082a8648ce3d04030230153113301106035504030c0a746c7331332d74657374301e170d3236303832343032343935335a170d3336303832313032343935335a30153113301106035504030c0a746c7331332d746573743059301306072a8648ce3d020106082a8648ce3d03010703420004f1fe77a29adb468d27b972e1dbb3af5cc8b6312abe7531aee14a19e85abcb8fb2eab53db22bb3aaae7f015b48ae561480ede9697fd43d904cfad6c91e6152f06a3533051301d0603551d0e04160414fb0e957b9228a734cf0a08f30925f2fddff915c5301f0603551d23041830168014fb0e957b9228a734cf0a08f30925f2fddff915c5300f0603551d130101ff040530030101ff300a06082a8648ce3d04030203470030440220571ae7eb3474a071b1dbd75d7854b4d07214123a8db8e3130cda8e073c1bea42022074cffaf39c2e701c5d80c8b166ba5cfc1f0955b068993aca450ddf94872d1bd6");
    List(Int) ec_sig = hb("3045022100a864ad5a8c3a0883344cf8f8e3be548849c4f2d78491afed9b3db37d95247cb9022066973cb4e661586931202f5f19d71d97371a1610b824bb85ea66bbb946f7d210");
    List(Int) content = tm_cv_content(thcv);
    List(Int) keyb = cert_pubkey_bits(ecdsa_cert);
    List(Int) keyb2 = slice_seed(keyb, 1, 66, [0]);
    Bool okcv = tm_ecdsa_verify_sha256(content, keyb2, ec_sig);
    if (okcv) { println("CV-ECDSA OK"); } else { println("CV-ECDSA BAD"); }
    return 0;
}
"#).unwrap();
    let out = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("failed to run residc");
    let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    for line in ["client-hello OK","sh-random OK","sh-pubkey OK","cert-der OK","th-cv OK","CV-ECDSA OK"] {
        assert!(stdout.contains(line), "missing {line} in {stdout:?}");
    }
    let _ = std::fs::remove_dir_all(&dir);
}


/// Exhaustive wide-int unsigned-compare + ECDSA-P256 property tests.
/// Regression harness for the signed-compare pitfall: Int(N) relational ops
/// compile as signed, so lib/ec256.resid provides ec_ge/ec_ge512 (unsigned
/// compare via top-bit/disjoint-sign decomposition) and uses them everywhere.
/// Fixtures: random vectors; expectations computed independently (big-endian
/// lexicographic compare / python cryptography signing).
#[test]
fn run_ecdsa_prop_in_resid() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-ecprop-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent().unwrap().parent().unwrap();
    for f in ["crypto.resid","aesgcm.resid","ed25519.resid","x25519.resid","tls.resid","tlsmsg.resid","chain.resid","rsa.resid","ec256.resid","der.resid","x509.resid"] {
        std::fs::copy(workspace.join("lib").join(f), dir.join(f)).unwrap();
    }
    let src = r#"import "ec256.resid";
import "tlsmsg.resid";
import "crypto.resid";

List(Int) hb_acc(Str s, Int i, List(Int) acc) {
    if (i >= str_len(s)) { return acc; }
    Int c = str_char_at(s, i);
    Int dhi = c - 87;
    Int dlo = c - 48;
    Int hi = if (c > 96) { dhi } else { dlo };
    Int j = i + 1;
    Int c2 = str_char_at(s, j);
    Int ehi = c2 - 87;
    Int elo = c2 - 48;
    Int lo = if (c2 > 96) { ehi } else { elo };
    Int byt = hi * 16 + lo;
    List(Int) acc2 = acc.concat([byt]);
    Int ni = i + 2;
    return hb_acc(s, ni, acc2);
}
List(Int) hb(Str s) { return hb_acc(s, 0, [0]); }
Int main() {
    Bool ge0 = ec_ge(ec_from_be(hb("0000000000000000000000000000000000000000000000000000000000000000")), ec_from_be(hb("0000000000000000000000000000000000000000000000000000000000000000")));
    if (ge0) { println("ge0 PASS"); } else { println("ge0 FAIL"); }
    Bool ge1 = ec_ge(ec_from_be(hb("0000000000000000000000000000000000000000000000000000000000000001")), ec_from_be(hb("0000000000000000000000000000000000000000000000000000000000000000")));
    if (ge1) { println("ge1 PASS"); } else { println("ge1 FAIL"); }
    Bool ge2 = ec_ge(ec_from_be(hb("ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff")), ec_from_be(hb("0000000000000000000000000000000000000000000000000000000000000000")));
    if (ge2) { println("ge2 PASS"); } else { println("ge2 FAIL"); }
    Bool ge3 = ec_ge(ec_from_be(hb("0000000000000000000000000000000000000000000000000000000000000000")), ec_from_be(hb("ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff")));
    if (!ge3) { println("ge3 PASS"); } else { println("ge3 FAIL"); }
    Bool ge4 = ec_ge(ec_from_be(hb("8000000000000000000000000000000000000000000000000000000000000000")), ec_from_be(hb("7f00000000000000000000000000000000000000000000000000000000000000")));
    if (ge4) { println("ge4 PASS"); } else { println("ge4 FAIL"); }
    Bool ge5 = ec_ge(ec_from_be(hb("7f00000000000000000000000000000000000000000000000000000000000000")), ec_from_be(hb("8000000000000000000000000000000000000000000000000000000000000000")));
    if (!ge5) { println("ge5 PASS"); } else { println("ge5 FAIL"); }
    Bool ge6 = ec_ge(ec_from_be(hb("fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe")), ec_from_be(hb("ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff")));
    if (!ge6) { println("ge6 PASS"); } else { println("ge6 FAIL"); }
    Bool ge7 = ec_ge(ec_from_be(hb("ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff")), ec_from_be(hb("fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe")));
    if (ge7) { println("ge7 PASS"); } else { println("ge7 FAIL"); }
    Bool ge8 = ec_ge(ec_from_be(hb("8000000000000000000000000000000000000000000000000000000000000000")), ec_from_be(hb("8000000000000000000000000000000000000000000000000000000000000000")));
    if (ge8) { println("ge8 PASS"); } else { println("ge8 FAIL"); }
    Bool ge9 = ec_ge(ec_from_be(hb("bb54aac4b89dc868ba37d9cc21b2cece9f09b43ceb7e57a0ea8766221624d01b")), ec_from_be(hb("086464359164e7a006aadd75179d6d5c5e19fde90cf9b4838622421e57a12862")));
    if (ge9) { println("ge9 PASS"); } else { println("ge9 FAIL"); }
    Bool ge10 = ec_ge(ec_from_be(hb("e1811b4cdab215dc934f1cecb1c2236ab4866d6245f7c8db815171aac963d551")), ec_from_be(hb("f0a4140f62df9da1ceb7739ce1c2c2498d79c52beb01af2b8cfbc74713c164e3")));
    if (!ge10) { println("ge10 PASS"); } else { println("ge10 FAIL"); }
    Bool ge11 = ec_ge(ec_from_be(hb("3a7c9a1afb6cb6a88d344e16fe97084c4bee29faea0a596253797215e1eccf9d")), ec_from_be(hb("a00cdab43456290799635064362851cf7d1edc74d4a8ecf26325252245b88bc1")));
    if (!ge11) { println("ge11 PASS"); } else { println("ge11 FAIL"); }
    Bool ge12 = ec_ge(ec_from_be(hb("0e007d1e3acb8e924f03d499f8be13a5061c2d1bbfdfd7cbf25806fe5e6125d9")), ec_from_be(hb("602d50d57129725fdf0ad99c35a4901afbbba60cb8a96e340d1fcdcb13cc0014")));
    if (!ge12) { println("ge12 PASS"); } else { println("ge12 FAIL"); }
    Bool ge13 = ec_ge(ec_from_be(hb("dee92aa4e56d2debb9be104a4a3774d153456787c5f7ad23bf6e53f1892b8ff7")), ec_from_be(hb("834d37684a534d16011c79b43f9e6620d8c1ce2e665eb86e1d7c3397a292a594")));
    if (ge13) { println("ge13 PASS"); } else { println("ge13 FAIL"); }
    Bool ge14 = ec_ge(ec_from_be(hb("1682d7a4ae2d898d11a51947dbfeffaf56c00ae12561c49e6afad0e741c8c1c6")), ec_from_be(hb("5b2785a942808a8036335f42b2d3423e4ec6b1de089b2fc5c6ea0f341f784e76")));
    if (!ge14) { println("ge14 PASS"); } else { println("ge14 FAIL"); }
    Bool ge15 = ec_ge(ec_from_be(hb("220d1c170da24eaf7e989baf9dcaad5b10ca33dfd8cc75e42477025dce88ae83")), ec_from_be(hb("e75a230086a0e00e9271f4c938b319067687e990e05e0da0ecce1278f75ff58d")));
    if (!ge15) { println("ge15 PASS"); } else { println("ge15 FAIL"); }
    Bool ge16 = ec_ge(ec_from_be(hb("9853f19dcaeed5de104aae37c7af367d74bc8756e370a937fe9f2311396d7562")), ec_from_be(hb("dfd2301108477405b7fa196622a643ad8aa0ea8335e2923a1410678f8d2b4074")));
    if (!ge16) { println("ge16 PASS"); } else { println("ge16 FAIL"); }
    Bool ge17 = ec_ge(ec_from_be(hb("4c573147b989265588d180db0cdc628dff9d87c23c835da1aafdea42dd8fe043")), ec_from_be(hb("92bc1ba0f82788489e985689c15eab7bb2a507bee676abf5d1764175b6836849")));
    if (!ge17) { println("ge17 PASS"); } else { println("ge17 FAIL"); }
    Bool ge18 = ec_ge(ec_from_be(hb("99f5cf198397a70d57a33da71a4d2e6bff61bfd257776d7d0ab35ffbab3b9c38")), ec_from_be(hb("93cb12e98cf7d6a29a7141f29ada0be6add0c3b1f023fe8733f3afb01872e7d5")));
    if (ge18) { println("ge18 PASS"); } else { println("ge18 FAIL"); }
    Bool ge19 = ec_ge(ec_from_be(hb("37302b3c6cf3cbe7a67da5922ca3f5730f004231b5678ab485cf495a850677da")), ec_from_be(hb("9f0a2cffde7db3d1ab77a464265d77a53931d22d4250a312647dd16dc5397c71")));
    if (!ge19) { println("ge19 PASS"); } else { println("ge19 FAIL"); }
    Bool ge20 = ec_ge(ec_from_be(hb("72a1ba9b79f3a62c1321d2e32a0d39bb54e5e9d18d04016fa177af0ff4467080")), ec_from_be(hb("2a4b9949df86d1fdb70e2d4371077fc012755385577c8cfc6c1a8aa0f7f10ecd")));
    if (ge20) { println("ge20 PASS"); } else { println("ge20 FAIL"); }
    Bool ge21 = ec_ge(ec_from_be(hb("e0a3318493262591e78b8c14c6686167123b7d868483aa5b67e2fb4529483433")), ec_from_be(hb("deee1bce24bc02d91ec71cc673dba58482a363ed145a49a4e37311253c105846")));
    if (ge21) { println("ge21 PASS"); } else { println("ge21 FAIL"); }
    Bool ge22 = ec_ge(ec_from_be(hb("c0afb13b74e5ddda9cc25d7aae49bc896c9966ae45a1eadc2379688c5cce8e6d")), ec_from_be(hb("b87140d16fd422de6ae353eb1f030be08bdf418a795dae41a09791fcbfb4870d")));
    if (ge22) { println("ge22 PASS"); } else { println("ge22 FAIL"); }
    Bool ge23 = ec_ge(ec_from_be(hb("89b28ff9466fc64a47227a367aa0a8d8b657699e0799b487f013b473225f8092")), ec_from_be(hb("4c7b83956e2e289d1a63df36c915c743e9115b1679b4516e0ee5954351d288a8")));
    if (ge23) { println("ge23 PASS"); } else { println("ge23 FAIL"); }
    Bool ge24 = ec_ge(ec_from_be(hb("38f45ef15b48b1a4b80b8c209ad42c33672bdaa428a36ae935e0cda959cf7023")), ec_from_be(hb("15f70258168340611602fe91af634a5f4608377b5235fa2d757c51d720c0c765")));
    if (ge24) { println("ge24 PASS"); } else { println("ge24 FAIL"); }
    Bool ge25 = ec_ge(ec_from_be(hb("6249a3035fb9638dc652d6d6cd370d8c963141f6d79ba440300f25c467302c1d")), ec_from_be(hb("966bff8f62300d7d41bc2130e009fe05b085aa844056c01425e150819a505f39")));
    if (!ge25) { println("ge25 PASS"); } else { println("ge25 FAIL"); }
    Bool ge26 = ec_ge(ec_from_be(hb("962d9c558570bff3ec067b956ca73f89a701081432b590b5e6f9aab5829f4d75")), ec_from_be(hb("4a273b3ab705a5f9b0ed8b7b18dcfc9a1838a3c1c7479c164b7eca677a77ecb1")));
    if (ge26) { println("ge26 PASS"); } else { println("ge26 FAIL"); }
    Bool ge27 = ec_ge(ec_from_be(hb("4ef925c3c26f14b79268db559a8e0e5e06be9a1579c16ce174b1010decdda09d")), ec_from_be(hb("063c7010c5dec5f4a02f8da5f72e546109313e8a8482b6f18e1a84bb06f25c3f")));
    if (ge27) { println("ge27 PASS"); } else { println("ge27 FAIL"); }
    Bool ge28 = ec_ge(ec_from_be(hb("354ddfe82926c76641b427d52dde8e922c6efca68cced17260e2c4ac3d267a8a")), ec_from_be(hb("3b5fc62484fab0bb534f3a3244e5295024e9bc22f2173836cde6167bab472788")));
    if (!ge28) { println("ge28 PASS"); } else { println("ge28 FAIL"); }
    Bool ge29 = ec_ge(ec_from_be(hb("c0801976342e636382f4ce5c1b0f4b9b72fb4dad5832f8fef1eb0a84edddaf22")), ec_from_be(hb("ba3df4291b39b4b384b810875d4421368132f780e53ee8b41ddf1c417717efa4")));
    if (ge29) { println("ge29 PASS"); } else { println("ge29 FAIL"); }
    Bool ge30 = ec_ge(ec_from_be(hb("1f3fce446976050c18fc04db6729afe41d3ecd4faa5e79a055ab93a5a0dfd63b")), ec_from_be(hb("8701dbec48aaacc594bc13a703186b800e43a24da08378245f38044a9587e390")));
    if (!ge30) { println("ge30 PASS"); } else { println("ge30 FAIL"); }
    Bool ge31 = ec_ge(ec_from_be(hb("47d7dbf9e20180489f3101f60518e126f3eed2b2e62bf33cbbd7e6c3a4477650")), ec_from_be(hb("c5071c34d8c6fbdc4aaf4d35c5af8fe64bd3013653b808c9242a7a39eec9fcd2")));
    if (!ge31) { println("ge31 PASS"); } else { println("ge31 FAIL"); }
    Bool ge32 = ec_ge(ec_from_be(hb("596143217c13dace2077fe5f988a2805a52b23449d4397521c25d6051e3beb15")), ec_from_be(hb("a0fd627a2ee037ad576fdaa33a90707c64f15cda0c513cf2055ba1e283211711")));
    if (!ge32) { println("ge32 PASS"); } else { println("ge32 FAIL"); }
    Bool ge33 = ec_ge(ec_from_be(hb("1ac0d9014ec99f3ee73e1ee9815d41433a62156bac6f2e219f8ea4355e298e5a")), ec_from_be(hb("1ac0d9014ec99f3ee73e1ee9815f41433a62156bac6f2e219f8ea4355e298e5a")));
    if (!ge33) { println("ge33 PASS"); } else { println("ge33 FAIL"); }
    Bool ge34 = ec_ge(ec_from_be(hb("63dc2ae1d4fcd6420822033856ba17fcfc0f3da0e30a45bc4d80ae9e391b8d1a")), ec_from_be(hb("63dc2ae1d4fcd6420822033856ba17fcfc0f2da0e30a45bc4d80ae9e391b8d1a")));
    if (ge34) { println("ge34 PASS"); } else { println("ge34 FAIL"); }
    Bool ge35 = ec_ge(ec_from_be(hb("c0831624f63c2b87ab7929a82ef743360590476ba29441e470df9a12f491deba")), ec_from_be(hb("c0831624f63c2b87ab7929a82ee743360590476ba29441e470df9a12f491deba")));
    if (ge35) { println("ge35 PASS"); } else { println("ge35 FAIL"); }
    Bool ge36 = ec_ge(ec_from_be(hb("60441d5dbf1f0bc9da5a10d5a5cab5bf00e98cd66138c22c42c07e1e021f4351")), ec_from_be(hb("60441d5dbf1f0bc9da5a10d5a5cab5bf00e98cd66138c22c42c47e1e021f4351")));
    if (!ge36) { println("ge36 PASS"); } else { println("ge36 FAIL"); }
    Bool ge37 = ec_ge(ec_from_be(hb("8773de954e35a8745b65d307dbf4845a13cefd3d8deeb78a001a7be0031c71de")), ec_from_be(hb("8773de954f35a8745b65d307dbf4845a13cefd3d8deeb78a001a7be0031c71de")));
    if (!ge37) { println("ge37 PASS"); } else { println("ge37 FAIL"); }
    Bool ge38 = ec_ge(ec_from_be(hb("4db610f85e8e9af3da77f51cba2bbd9a9414b83242fc2100b925962774a62a89")), ec_from_be(hb("4db610f85e8e9af3da77f51cba2bbd9a9414b83242fc2100b925962776a62a89")));
    if (!ge38) { println("ge38 PASS"); } else { println("ge38 FAIL"); }
    Bool ge39 = ec_ge(ec_from_be(hb("8c945fc9a8a8b4db0731bda3f9f6a9f8543dc34df124b0ca7839e99c32c39680")), ec_from_be(hb("8c945fc9a8a8b4db0731bda3f9f6a9f0543dc34df124b0ca7839e99c32c39680")));
    if (ge39) { println("ge39 PASS"); } else { println("ge39 FAIL"); }
    Bool ge40 = ec_ge(ec_from_be(hb("efde8fef5edd76256cdc526739802feed79cdd1cfbd615926b250d20c5e9c396")), ec_from_be(hb("efde8fef5edd76256cdc526739802feed79cdd1cfbd635926b250d20c5e9c396")));
    if (!ge40) { println("ge40 PASS"); } else { println("ge40 FAIL"); }
    Bool ge41 = ec_ge(ec_from_be(hb("aaed9ad4067faa0df7dc48c266b26679791cdff97e378418be82895f298f521f")), ec_from_be(hb("aaed9ad4067faa0df7dc48c266b26679391cdff97e378418be82895f298f521f")));
    if (ge41) { println("ge41 PASS"); } else { println("ge41 FAIL"); }
    Bool ge42 = ec_ge(ec_from_be(hb("b3b0ad1f4bc82bf5b29cf400daf69c26823e732d7b230e66199dab18eaa8611e")), ec_from_be(hb("b3b0ad1f4bc82bf5b29cf400daf69c26823e732d7b230e66199dab18eea8611e")));
    if (!ge42) { println("ge42 PASS"); } else { println("ge42 FAIL"); }
    Bool ge43 = ec_ge(ec_from_be(hb("4f30bd95a6463003bcd43eeace749ee96f80a3a1209aca95951d8f7ea030985c")), ec_from_be(hb("4f30bd95a6463003bcd43eeace749ee96f80a3a1209eca95951d8f7ea030985c")));
    if (!ge43) { println("ge43 PASS"); } else { println("ge43 FAIL"); }
    Bool ge44 = ec_ge(ec_from_be(hb("a22cfcd16e49dd2cce32828a989eb4fef35b9c5c045b66bdf0380d1255f20c23")), ec_from_be(hb("a22cfcd16e49dd2cce32828a989cb4fef35b9c5c045b66bdf0380d1255f20c23")));
    if (ge44) { println("ge44 PASS"); } else { println("ge44 FAIL"); }
    Bool ge45 = ec_ge(ec_from_be(hb("e1db065d58677944f60def8b25f027529b3ea73454d3d40c6f9781da53546006")), ec_from_be(hb("e1db065d58677944f60def8b25f02f529b3ea73454d3d40c6f9781da53546006")));
    if (!ge45) { println("ge45 PASS"); } else { println("ge45 FAIL"); }
    Bool ge46 = ec_ge(ec_from_be(hb("410e95f9db5671566846d21eaef06230506ab4f4e29bd0dafc2869f2404ccbc6")), ec_from_be(hb("410e95f9db5671566846d21eaef06230506ab4f4e29b50dafc2869f2404ccbc6")));
    if (ge46) { println("ge46 PASS"); } else { println("ge46 FAIL"); }
    Bool ge47 = ec_ge(ec_from_be(hb("dd31a032a82f823d0c4abe93184c149cc4c554968a4f59487675fe4e6a983fd9")), ec_from_be(hb("dd31a032a82f823d0c4abe93184c149cc4c554968a4f59487675fe4e6a98bfd9")));
    if (!ge47) { println("ge47 PASS"); } else { println("ge47 FAIL"); }
    Bool ge48 = ec_ge(ec_from_be(hb("77c771883d01f9c1afa72da0bb5cf68d7bf79772ed4c2d48107a184721f157db")), ec_from_be(hb("77c771883d01f9c1afa72da0bb5cf68d7bf79772ed4c2d48107a180721f157db")));
    if (ge48) { println("ge48 PASS"); } else { println("ge48 FAIL"); }
    Bool cv0 = tm_ecdsa_verify_sha256(hb("e5019433c0697f6a90ea102ce8a86354787f508932e824a59802554b3d1d925c445c7afb9cb2765de55301b79277327d6604e0c69c42cc2a7fddf2292d4634e2d8fa66cc76da034fd44225af282406e052f6761f6eaaad8bf9cff242990cdeffde5266f5287e97aec43ebe476babce4361c4ccf0ab74c4657d499485e745d68ea887"), hb("0004a834c5ed734924fe2df8c0786a4141bee4c1c5f24fa5858a5287464fe6cd24d9740d595f4011f6f8640532deefa558828c94a51a42d50f7fcc4958b315f30647"), hb("30450220713fff1c5ad46b035d5cc7712ae8f8c71b45027c22ece265c9d51339c81c9172022100dd24eec2f67ac3fa8b9497b78939a4e8d8f079de38ea9a462d10b9cf40c3b941"));
    if (cv0) { println("cv0 PASS"); } else { println("cv0 FAIL"); }
    Bool cv1 = tm_ecdsa_verify_sha256(hb("3304fa5b466e2a5f2bf679b77cc04693432dd4b50b5d27b50aea23dc1a8719af6203beaa0d2ca5d0b7ecd7f3e5d198bc26fe968ded7688f3405fd1045b5db7043e17dbee65634f9a0ac3e16929fc9fc56d3eedd5125acc52594f30089fc03078678def9b683ab99be698e1d2af1db54b9a8f64b7d2017c3d2b54fdc3b24b859ab54f"), hb("0004a834c5ed734924fe2df8c0786a4141bee4c1c5f24fa5858a5287464fe6cd24d9740d595f4011f6f8640532deefa558828c94a51a42d50f7fcc4958b315f30647"), hb("304402207b670d597712e4e9cecf0085b80a710bfa970f5453adb76fd1490b51926c153f022017043380e257556ec3eeda9adf72d569a781673b73fe4c5fdd7e49558b8dbc0e"));
    if (cv1) { println("cv1 PASS"); } else { println("cv1 FAIL"); }
    Bool cv2 = tm_ecdsa_verify_sha256(hb("005a091db668456c90d4b383ddffe3d4b0706b0cce7a5631e62e5a8748ee522891d5346d499a8ce916ad4104737563ac8331e335cbd29590b939df797bc3bf49e4be06bd4852fd7ae930e8abeaed5cef7069c5bcee50c0be413dce8323a7f7baaac89e90067d2f2f4128a001f22356ea256932fc361d622ab01f7610a238c99b72af"), hb("0004a834c5ed734924fe2df8c0786a4141bee4c1c5f24fa5858a5287464fe6cd24d9740d595f4011f6f8640532deefa558828c94a51a42d50f7fcc4958b315f30647"), hb("304402204e5729332de0c7d87e78d4d2d71045844a663ea32def8d3122a55fd548e3824e02207037b6c57ceaf08d1683664f06572482b1d014681ace250c804a124f347248c3"));
    if (!cv2) { println("cv2 PASS"); } else { println("cv2 FAIL"); }
    Bool cv3 = tm_ecdsa_verify_sha256(hb("49a08af3aec5315d230079a287d17d9f9088665a62a3b7bdde4512d7f00b28338cc36fe578b4140e6baa9e621c7c1ef84ae94c6f70fed485b937506d9b894ae43b8e87ee8312ee50dca9581ef62993b7c19894ef1b7a9512447e26f20d3daacbb84ba8303d5e73e8dafed9f873ec85377f0cba98211551b9839f908e7f134c5f5aee"), hb("0004a834c5ed734924fe2df8c0786a4141bee4c1c5f24fa5858a5287464fe6cd24d9740d595f4011f6f8640532deefa558828c94a51a42d50f7fcc4958b315f30647"), hb("3045022005db06f8a01b253e6b97f54cc4ff76fd9d2a76b8e64990528f8ea6a2965a6735022100b4cbcca93252c93a42be785a6bb920375af392b7d89728ece3a86672c99a9df5"));
    if (cv3) { println("cv3 PASS"); } else { println("cv3 FAIL"); }
    Bool cv4 = tm_ecdsa_verify_sha256(hb("6a01315ee57d8bb454f5aea8476a43afc1f40bcf3f4c197db8a9da0066029935a66ccd7e3527e9f83928747b4039491fc967963c48711e6220d4d68a00858537a4f0c0eeced83b2c7ff6e01c2ebe6c41858a81f533fbf06c8ddbf615e0b68d9ffa793910894b7d0a6db47cf3a1377e45d9e140cfe85965e1eede94733c82efabb259"), hb("0004a834c5ed734924fe2df8c0786a4141bee4c1c5f24fa5858a5287464fe6cd24d9740d595f4011f6f8640532deefa558828c94a51a42d50f7fcc4958b315f30647"), hb("30450220549532ddd11ccca7e13008387f81637d7c4aad792e954af1427b4a026078e734022100f259216ae41174e0308ea30e31f4681c33309a246ad749b886824b065e4d7696"));
    if (cv4) { println("cv4 PASS"); } else { println("cv4 FAIL"); }
    Bool cv5 = tm_ecdsa_verify_sha256(hb("bf39d30d7a65e9daf47912e15bfe7ba0ceb1d99fd6c2b10ae7ce4292280e0832188dc435350c70fa826819ab64150dbb0a246007c9dce914d01a55139de2cc5eedd26d9299ecbc59b9f2776e99c05f742abf04bb5ee935c86092d75e9a53925bcb8f8a99d8ea1f605da37bc5529de81d0109d3f22ee2f5dd1c1c44a0f6097c2d7e34"), hb("0004a834c5ed734924fe2df8c0786a4141bee4c1c5f24fa5858a5287464fe6cd24d9740d595f4011f6f8640532deefa558828c94a51a42d50f7fcc4958b315f30647"), hb("3045022100db494e75e459e4a20f77763d3d4fa1ab21da3825a8913193ff739be6f8d24689022020e818d83a910291fec69d43fb05ecfddfeb85aa6795075be269ac469f4375cc"));
    if (!cv5) { println("cv5 PASS"); } else { println("cv5 FAIL"); }
    Bool cv6 = tm_ecdsa_verify_sha256(hb("7a62ad2f1feab41e23d28cb8783dd12db8eb82a8444b142c75bf573d4b876894146b54e8dd50423465c781b4b01b91218ef4a4c131e18a013fc314afad3416fea15bb84fa5ffd50f6849987332a351b6fbf0ec691ac1ba4c01212cc40fea142eaee46bcdf5b87e904e334d1a63eedb4e79d4b6aba27b37c7383794e232485500b0ff"), hb("0004a834c5ed734924fe2df8c0786a4141bee4c1c5f24fa5858a5287464fe6cd24d9740d595f4011f6f8640532deefa558828c94a51a42d50f7fcc4958b315f30647"), hb("3045022100d3742840f02de89198664999880c6b87868e178a5bb3ffc09ca1b71ff99e4577022079c2cba2553192a89ce364e523b4e7e8723ce6ba50e64aebf0e05ddbddbc29f7"));
    if (cv6) { println("cv6 PASS"); } else { println("cv6 FAIL"); }
    Bool cv7 = tm_ecdsa_verify_sha256(hb("a59e7414d2009fa61a76c4f0067218caa1ab67d78f4fea093d65c5e1299a381df2a0c33aecf1f6c7398ec1663be96cd2cc1497fd9f584d68d8f2e434349d9200657b556523787ecfac804caf158c35be37fc7f67d2628a457fcd8090267b52436adccfb54c4e9727d05d81626892ed933dcdeab721d77dc4681db775137179fec412"), hb("0004a834c5ed734924fe2df8c0786a4141bee4c1c5f24fa5858a5287464fe6cd24d9740d595f4011f6f8640532deefa558828c94a51a42d50f7fcc4958b315f30647"), hb("304502205082d7b57c5b996e19bc0ac0c87d72d2146d534b12674bd46b21524758d29cb70221008a3e16affccb2767fdb78c0339ffc7646545f8526734717c75519566ab52fb16"));
    if (cv7) { println("cv7 PASS"); } else { println("cv7 FAIL"); }
    Bool cv8 = tm_ecdsa_verify_sha256(hb("6d94c4789632031aef0ccd162be99f906e181e8baf719a8ca141bb6f6530ffb5bf027c1a3a56487d0ff848a49ab82a120728e824925bd074b5cec9524e7bba471d45fce2a392ff9bc96e4c4d6c4602a105a26ae0b318bbd2acc64ca0629620729e139bb0d530597cf3a884b487373fcb529f94f4bb2947190238791dcb60fdca7fc6"), hb("0004a834c5ed734924fe2df8c0786a4141bee4c1c5f24fa5858a5287464fe6cd24d9740d595f4011f6f8640532deefa558828c94a51a42d50f7fcc4958b315f30647"), hb("3045022100802c0d4888a6cb38cf46b64d96978633be18aa195e6d1f58903138401a6bf79c02200e5ca35b6a14671d9c05fe825511b6f9181669689e8d291985f5cc59b456f166"));
    if (!cv8) { println("cv8 PASS"); } else { println("cv8 FAIL"); }
    Bool cv9 = tm_ecdsa_verify_sha256(hb("2868331c2fdf7f82b505e4e0d45100ea1f5daeca01da1e238ca4ba16f2408d87da56118b7f32fa1a7da2caf720486290cb4fbc37c9536a0960384b56f182298f3b0c7bcc53d73b83f49d42c6f129c140ae37a0ddbcf0efc9affc99b15b5883663bcd68c1220cdd21965aaacb0560944847f9baedd6cd923ea25008ff4c4cf62f6535"), hb("0004a834c5ed734924fe2df8c0786a4141bee4c1c5f24fa5858a5287464fe6cd24d9740d595f4011f6f8640532deefa558828c94a51a42d50f7fcc4958b315f30647"), hb("304502205ce2422e693765988658942ef89dab96c57b9771e1e9a0d7c36d942c34ee52e6022100a4a6dcc003fe5bffa5ea8e3f79dfdb983bca345e6ced02f92c4d5b2c59d3fd61"));
    if (cv9) { println("cv9 PASS"); } else { println("cv9 FAIL"); }
    Bool cv10 = tm_ecdsa_verify_sha256(hb("0ebb9a13c47a22c3ffa0825fa4825a33c69634e31e4e59f1ced46746dcbbf06c5f14e2db8e2fa01dcc15cc029d81564236b806c71fc72bb9702c5a5f05a245c4b21a5dca6759be24cc0363997350aa857e3a29f28a1dd31c8d993459bfcecd5e30d4a6aea5c90a88de1cad242df7e90ed82389724248a16e02230c74010c85b0a9ff"), hb("0004a834c5ed734924fe2df8c0786a4141bee4c1c5f24fa5858a5287464fe6cd24d9740d595f4011f6f8640532deefa558828c94a51a42d50f7fcc4958b315f30647"), hb("304502207465831102ba02e0d793f2a1475965a06f05afea0a1cb42f5dcffc9917d4a7340221009ad4273493db6593a5758744dfcddeb16118814f93cf9af0dbe7e7ebf666627e"));
    if (cv10) { println("cv10 PASS"); } else { println("cv10 FAIL"); }
    Bool cv11 = tm_ecdsa_verify_sha256(hb("246b7ad1db7dd069fdf6af5ce74a20bcf5bd2b7a851b56387af4849b32507879c2cda83fa368701fbb5bb7c2bac5d4e438b119c25feaec9f892bfa5f0e1b9a38d9f6b74d1ee2b4abdc57ca01c501cb6e9077fdcabd73d6b977ddcea9138a6cf735c8edb9c7e6919fe7c254263c8619ff73e4eb5518018bbaaf1c2416fe0ace871689"), hb("0004a834c5ed734924fe2df8c0786a4141bee4c1c5f24fa5858a5287464fe6cd24d9740d595f4011f6f8640532deefa558828c94a51a42d50f7fcc4958b315f30647"), hb("3044022035b657fc2e042d27e6f0ca8d0cce5d8b56258dca2126206c31e8b116d796622e02200dfdc01c86bb2610cd639b57bc5ebc64765ac8429bd79d766b4403a0cd7c2ca2"));
    if (!cv11) { println("cv11 PASS"); } else { println("cv11 FAIL"); }
    Bool cv12 = tm_ecdsa_verify_sha256(hb("5a689fc7b2de7313ada62a0bf2d34e393f8027a259287a2dda2666e586138f2b4ee68433831ac4b081e6c0811c69a588e4ef2817f650ca952b83d4df8b468e400dd9a6bfdb13619c56272749fcb28a8039c5570ed7ecc0df5af1eafd75f36f99441403d66300e872b97e192308a348076e405aead6729df50085db47f012905fa36a"), hb("0004a834c5ed734924fe2df8c0786a4141bee4c1c5f24fa5858a5287464fe6cd24d9740d595f4011f6f8640532deefa558828c94a51a42d50f7fcc4958b315f30647"), hb("3045022100e8aef19a56b852491ca1309c4653dc725fce38a7bff8ab5bd199b04b850eabf60220472fef1b4bd396d52180a123720fa29c365dd60fe53ad0c7af50753264cd3907"));
    if (cv12) { println("cv12 PASS"); } else { println("cv12 FAIL"); }
    Bool cv13 = tm_ecdsa_verify_sha256(hb("8c1b49b8316ea297b933c5f9a59d72d0d466ec025467cec3fb6d163c0925f280273c89d1ff20be06a6c34790d75385e3210af41aa5433002f588244d3334794dff8840577c420b9366b38f1f41afb8ff729b22542b2c0fedb852571df495db66f94c5bd8c9c26e6a3e1bf076a2def1d9c1d0737883e0ba52f8a034a53d9d43632bb7"), hb("0004a834c5ed734924fe2df8c0786a4141bee4c1c5f24fa5858a5287464fe6cd24d9740d595f4011f6f8640532deefa558828c94a51a42d50f7fcc4958b315f30647"), hb("30450220751001d747c1dd74a2a747e492ea90289ec18a689ee0f454d147b04fec748fa0022100836fd2f2396d421b4430d0e2711902f000b1ce8ba0697af703d6bdacf2520ce2"));
    if (cv13) { println("cv13 PASS"); } else { println("cv13 FAIL"); }
    return 0;
}
"#;
    let file = dir.join("main.resid");
    std::fs::write(&file, src).unwrap();
    let out = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("failed to run residc");
    let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    assert!(stdout.contains("ge0 PASS"), "missing marker: ge0 PASS");
    assert!(stdout.contains("ge1 PASS"), "missing marker: ge1 PASS");
    assert!(stdout.contains("ge2 PASS"), "missing marker: ge2 PASS");
    assert!(stdout.contains("ge3 PASS"), "missing marker: ge3 PASS");
    assert!(stdout.contains("ge4 PASS"), "missing marker: ge4 PASS");
    assert!(stdout.contains("ge5 PASS"), "missing marker: ge5 PASS");
    assert!(stdout.contains("ge6 PASS"), "missing marker: ge6 PASS");
    assert!(stdout.contains("ge7 PASS"), "missing marker: ge7 PASS");
    assert!(stdout.contains("ge8 PASS"), "missing marker: ge8 PASS");
    assert!(stdout.contains("ge9 PASS"), "missing marker: ge9 PASS");
    assert!(stdout.contains("ge10 PASS"), "missing marker: ge10 PASS");
    assert!(stdout.contains("ge11 PASS"), "missing marker: ge11 PASS");
    assert!(stdout.contains("ge12 PASS"), "missing marker: ge12 PASS");
    assert!(stdout.contains("ge13 PASS"), "missing marker: ge13 PASS");
    assert!(stdout.contains("ge14 PASS"), "missing marker: ge14 PASS");
    assert!(stdout.contains("ge15 PASS"), "missing marker: ge15 PASS");
    assert!(stdout.contains("ge16 PASS"), "missing marker: ge16 PASS");
    assert!(stdout.contains("ge17 PASS"), "missing marker: ge17 PASS");
    assert!(stdout.contains("ge18 PASS"), "missing marker: ge18 PASS");
    assert!(stdout.contains("ge19 PASS"), "missing marker: ge19 PASS");
    assert!(stdout.contains("ge20 PASS"), "missing marker: ge20 PASS");
    assert!(stdout.contains("ge21 PASS"), "missing marker: ge21 PASS");
    assert!(stdout.contains("ge22 PASS"), "missing marker: ge22 PASS");
    assert!(stdout.contains("ge23 PASS"), "missing marker: ge23 PASS");
    assert!(stdout.contains("ge24 PASS"), "missing marker: ge24 PASS");
    assert!(stdout.contains("ge25 PASS"), "missing marker: ge25 PASS");
    assert!(stdout.contains("ge26 PASS"), "missing marker: ge26 PASS");
    assert!(stdout.contains("ge27 PASS"), "missing marker: ge27 PASS");
    assert!(stdout.contains("ge28 PASS"), "missing marker: ge28 PASS");
    assert!(stdout.contains("ge29 PASS"), "missing marker: ge29 PASS");
    assert!(stdout.contains("ge30 PASS"), "missing marker: ge30 PASS");
    assert!(stdout.contains("ge31 PASS"), "missing marker: ge31 PASS");
    assert!(stdout.contains("ge32 PASS"), "missing marker: ge32 PASS");
    assert!(stdout.contains("ge33 PASS"), "missing marker: ge33 PASS");
    assert!(stdout.contains("ge34 PASS"), "missing marker: ge34 PASS");
    assert!(stdout.contains("ge35 PASS"), "missing marker: ge35 PASS");
    assert!(stdout.contains("ge36 PASS"), "missing marker: ge36 PASS");
    assert!(stdout.contains("ge37 PASS"), "missing marker: ge37 PASS");
    assert!(stdout.contains("ge38 PASS"), "missing marker: ge38 PASS");
    assert!(stdout.contains("ge39 PASS"), "missing marker: ge39 PASS");
    assert!(stdout.contains("ge40 PASS"), "missing marker: ge40 PASS");
    assert!(stdout.contains("ge41 PASS"), "missing marker: ge41 PASS");
    assert!(stdout.contains("ge42 PASS"), "missing marker: ge42 PASS");
    assert!(stdout.contains("ge43 PASS"), "missing marker: ge43 PASS");
    assert!(stdout.contains("ge44 PASS"), "missing marker: ge44 PASS");
    assert!(stdout.contains("ge45 PASS"), "missing marker: ge45 PASS");
    assert!(stdout.contains("ge46 PASS"), "missing marker: ge46 PASS");
    assert!(stdout.contains("ge47 PASS"), "missing marker: ge47 PASS");
    assert!(stdout.contains("ge48 PASS"), "missing marker: ge48 PASS");
    assert!(stdout.contains("cv0 PASS"), "missing marker: cv0 PASS");
    assert!(stdout.contains("cv1 PASS"), "missing marker: cv1 PASS");
    assert!(stdout.contains("cv2 PASS"), "missing marker: cv2 PASS");
    assert!(stdout.contains("cv3 PASS"), "missing marker: cv3 PASS");
    assert!(stdout.contains("cv4 PASS"), "missing marker: cv4 PASS");
    assert!(stdout.contains("cv5 PASS"), "missing marker: cv5 PASS");
    assert!(stdout.contains("cv6 PASS"), "missing marker: cv6 PASS");
    assert!(stdout.contains("cv7 PASS"), "missing marker: cv7 PASS");
    assert!(stdout.contains("cv8 PASS"), "missing marker: cv8 PASS");
    assert!(stdout.contains("cv9 PASS"), "missing marker: cv9 PASS");
    assert!(stdout.contains("cv10 PASS"), "missing marker: cv10 PASS");
    assert!(stdout.contains("cv11 PASS"), "missing marker: cv11 PASS");
    assert!(stdout.contains("cv12 PASS"), "missing marker: cv12 PASS");
    assert!(stdout.contains("cv13 PASS"), "missing marker: cv13 PASS");
    let _ = std::fs::remove_dir_all(&dir);
}

/// Wide-int 512-bit unsigned-compare property test (ec_ge512 halves logic,
/// incl. equal-high-halves case that originally short-circuited wrongly).
#[test]
fn run_ecge512_wide_prop_in_resid() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-ecwide-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent().unwrap().parent().unwrap();
    for f in ["crypto.resid","aesgcm.resid","ed25519.resid","x25519.resid","tls.resid","tlsmsg.resid","chain.resid","rsa.resid","ec256.resid","der.resid","x509.resid"] {
        std::fs::copy(workspace.join("lib").join(f), dir.join(f)).unwrap();
    }
    let src = r#"import "ec256.resid";
import "tlsmsg.resid";
import "crypto.resid";

List(Int) hb_acc(Str s, Int i, List(Int) acc) {
    if (i >= str_len(s)) { return acc; }
    Int c = str_char_at(s, i);
    Int dhi = c - 87;
    Int dlo = c - 48;
    Int hi = if (c > 96) { dhi } else { dlo };
    Int j = i + 1;
    Int c2 = str_char_at(s, j);
    Int ehi = c2 - 87;
    Int elo = c2 - 48;
    Int lo = if (c2 > 96) { ehi } else { elo };
    Int byt = hi * 16 + lo;
    List(Int) acc2 = acc.concat([byt]);
    Int ni = i + 2;
    return hb_acc(s, ni, acc2);
}
List(Int) hb(Str s) { return hb_acc(s, 0, [0]); }
Int(512) be512_acc(List(Int) b, Int i, Int last, Int(512) acc) {
    if (i > last) { return acc; }
    Int byte = b[i];
    Int(512) bv = (Int(512)) byte;
    Int(512) a8 = acc * 256;
    Int(512) a2v = a8 + bv;
    Int ni = i + 1;
    return be512_acc(b, ni, last, a2v);
}
Int(512) ec_from_be512(List(Int) bytes) {
    Int blen = bytes.len() - 1;
    return be512_acc(bytes, 1, blen, 0);
}
Int main() {
    Bool ge0 = ec_ge(ec_from_be(hb("0000000000000000000000000000000000000000000000000000000000000000")), ec_from_be(hb("0000000000000000000000000000000000000000000000000000000000000000")));
    if (ge0) { println("ge0 PASS"); } else { println("ge0 FAIL"); }
    Bool ge1 = ec_ge(ec_from_be(hb("0000000000000000000000000000000000000000000000000000000000000001")), ec_from_be(hb("0000000000000000000000000000000000000000000000000000000000000000")));
    if (ge1) { println("ge1 PASS"); } else { println("ge1 FAIL"); }
    Bool ge2 = ec_ge(ec_from_be(hb("ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff")), ec_from_be(hb("0000000000000000000000000000000000000000000000000000000000000000")));
    if (ge2) { println("ge2 PASS"); } else { println("ge2 FAIL"); }
    Bool ge3 = ec_ge(ec_from_be(hb("0000000000000000000000000000000000000000000000000000000000000000")), ec_from_be(hb("ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff")));
    if (!ge3) { println("ge3 PASS"); } else { println("ge3 FAIL"); }
    Bool ge4 = ec_ge(ec_from_be(hb("8000000000000000000000000000000000000000000000000000000000000000")), ec_from_be(hb("7f00000000000000000000000000000000000000000000000000000000000000")));
    if (ge4) { println("ge4 PASS"); } else { println("ge4 FAIL"); }
    Bool ge5 = ec_ge(ec_from_be(hb("7f00000000000000000000000000000000000000000000000000000000000000")), ec_from_be(hb("8000000000000000000000000000000000000000000000000000000000000000")));
    if (!ge5) { println("ge5 PASS"); } else { println("ge5 FAIL"); }
    Bool ge6 = ec_ge(ec_from_be(hb("fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe")), ec_from_be(hb("ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff")));
    if (!ge6) { println("ge6 PASS"); } else { println("ge6 FAIL"); }
    Bool ge7 = ec_ge(ec_from_be(hb("ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff")), ec_from_be(hb("fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe")));
    if (ge7) { println("ge7 PASS"); } else { println("ge7 FAIL"); }
    Bool ge8 = ec_ge(ec_from_be(hb("8000000000000000000000000000000000000000000000000000000000000000")), ec_from_be(hb("8000000000000000000000000000000000000000000000000000000000000000")));
    if (ge8) { println("ge8 PASS"); } else { println("ge8 FAIL"); }
    Bool ge9 = ec_ge(ec_from_be(hb("bb54aac4b89dc868ba37d9cc21b2cece9f09b43ceb7e57a0ea8766221624d01b")), ec_from_be(hb("086464359164e7a006aadd75179d6d5c5e19fde90cf9b4838622421e57a12862")));
    if (ge9) { println("ge9 PASS"); } else { println("ge9 FAIL"); }
    Bool ge10 = ec_ge(ec_from_be(hb("e1811b4cdab215dc934f1cecb1c2236ab4866d6245f7c8db815171aac963d551")), ec_from_be(hb("f0a4140f62df9da1ceb7739ce1c2c2498d79c52beb01af2b8cfbc74713c164e3")));
    if (!ge10) { println("ge10 PASS"); } else { println("ge10 FAIL"); }
    Bool ge11 = ec_ge(ec_from_be(hb("3a7c9a1afb6cb6a88d344e16fe97084c4bee29faea0a596253797215e1eccf9d")), ec_from_be(hb("a00cdab43456290799635064362851cf7d1edc74d4a8ecf26325252245b88bc1")));
    if (!ge11) { println("ge11 PASS"); } else { println("ge11 FAIL"); }
    Bool ge12 = ec_ge(ec_from_be(hb("0e007d1e3acb8e924f03d499f8be13a5061c2d1bbfdfd7cbf25806fe5e6125d9")), ec_from_be(hb("602d50d57129725fdf0ad99c35a4901afbbba60cb8a96e340d1fcdcb13cc0014")));
    if (!ge12) { println("ge12 PASS"); } else { println("ge12 FAIL"); }
    Bool ge13 = ec_ge(ec_from_be(hb("dee92aa4e56d2debb9be104a4a3774d153456787c5f7ad23bf6e53f1892b8ff7")), ec_from_be(hb("834d37684a534d16011c79b43f9e6620d8c1ce2e665eb86e1d7c3397a292a594")));
    if (ge13) { println("ge13 PASS"); } else { println("ge13 FAIL"); }
    Bool ge14 = ec_ge(ec_from_be(hb("1682d7a4ae2d898d11a51947dbfeffaf56c00ae12561c49e6afad0e741c8c1c6")), ec_from_be(hb("5b2785a942808a8036335f42b2d3423e4ec6b1de089b2fc5c6ea0f341f784e76")));
    if (!ge14) { println("ge14 PASS"); } else { println("ge14 FAIL"); }
    Bool ge15 = ec_ge(ec_from_be(hb("220d1c170da24eaf7e989baf9dcaad5b10ca33dfd8cc75e42477025dce88ae83")), ec_from_be(hb("e75a230086a0e00e9271f4c938b319067687e990e05e0da0ecce1278f75ff58d")));
    if (!ge15) { println("ge15 PASS"); } else { println("ge15 FAIL"); }
    Bool ge16 = ec_ge(ec_from_be(hb("9853f19dcaeed5de104aae37c7af367d74bc8756e370a937fe9f2311396d7562")), ec_from_be(hb("dfd2301108477405b7fa196622a643ad8aa0ea8335e2923a1410678f8d2b4074")));
    if (!ge16) { println("ge16 PASS"); } else { println("ge16 FAIL"); }
    Bool ge17 = ec_ge(ec_from_be(hb("4c573147b989265588d180db0cdc628dff9d87c23c835da1aafdea42dd8fe043")), ec_from_be(hb("92bc1ba0f82788489e985689c15eab7bb2a507bee676abf5d1764175b6836849")));
    if (!ge17) { println("ge17 PASS"); } else { println("ge17 FAIL"); }
    Bool ge18 = ec_ge(ec_from_be(hb("99f5cf198397a70d57a33da71a4d2e6bff61bfd257776d7d0ab35ffbab3b9c38")), ec_from_be(hb("93cb12e98cf7d6a29a7141f29ada0be6add0c3b1f023fe8733f3afb01872e7d5")));
    if (ge18) { println("ge18 PASS"); } else { println("ge18 FAIL"); }
    Bool ge19 = ec_ge(ec_from_be(hb("37302b3c6cf3cbe7a67da5922ca3f5730f004231b5678ab485cf495a850677da")), ec_from_be(hb("9f0a2cffde7db3d1ab77a464265d77a53931d22d4250a312647dd16dc5397c71")));
    if (!ge19) { println("ge19 PASS"); } else { println("ge19 FAIL"); }
    Bool ge20 = ec_ge(ec_from_be(hb("72a1ba9b79f3a62c1321d2e32a0d39bb54e5e9d18d04016fa177af0ff4467080")), ec_from_be(hb("2a4b9949df86d1fdb70e2d4371077fc012755385577c8cfc6c1a8aa0f7f10ecd")));
    if (ge20) { println("ge20 PASS"); } else { println("ge20 FAIL"); }
    Bool ge21 = ec_ge(ec_from_be(hb("e0a3318493262591e78b8c14c6686167123b7d868483aa5b67e2fb4529483433")), ec_from_be(hb("deee1bce24bc02d91ec71cc673dba58482a363ed145a49a4e37311253c105846")));
    if (ge21) { println("ge21 PASS"); } else { println("ge21 FAIL"); }
    Bool ge22 = ec_ge(ec_from_be(hb("c0afb13b74e5ddda9cc25d7aae49bc896c9966ae45a1eadc2379688c5cce8e6d")), ec_from_be(hb("b87140d16fd422de6ae353eb1f030be08bdf418a795dae41a09791fcbfb4870d")));
    if (ge22) { println("ge22 PASS"); } else { println("ge22 FAIL"); }
    Bool ge23 = ec_ge(ec_from_be(hb("89b28ff9466fc64a47227a367aa0a8d8b657699e0799b487f013b473225f8092")), ec_from_be(hb("4c7b83956e2e289d1a63df36c915c743e9115b1679b4516e0ee5954351d288a8")));
    if (ge23) { println("ge23 PASS"); } else { println("ge23 FAIL"); }
    Bool ge24 = ec_ge(ec_from_be(hb("38f45ef15b48b1a4b80b8c209ad42c33672bdaa428a36ae935e0cda959cf7023")), ec_from_be(hb("15f70258168340611602fe91af634a5f4608377b5235fa2d757c51d720c0c765")));
    if (ge24) { println("ge24 PASS"); } else { println("ge24 FAIL"); }
    Bool ge25 = ec_ge(ec_from_be(hb("6249a3035fb9638dc652d6d6cd370d8c963141f6d79ba440300f25c467302c1d")), ec_from_be(hb("966bff8f62300d7d41bc2130e009fe05b085aa844056c01425e150819a505f39")));
    if (!ge25) { println("ge25 PASS"); } else { println("ge25 FAIL"); }
    Bool ge26 = ec_ge(ec_from_be(hb("962d9c558570bff3ec067b956ca73f89a701081432b590b5e6f9aab5829f4d75")), ec_from_be(hb("4a273b3ab705a5f9b0ed8b7b18dcfc9a1838a3c1c7479c164b7eca677a77ecb1")));
    if (ge26) { println("ge26 PASS"); } else { println("ge26 FAIL"); }
    Bool ge27 = ec_ge(ec_from_be(hb("4ef925c3c26f14b79268db559a8e0e5e06be9a1579c16ce174b1010decdda09d")), ec_from_be(hb("063c7010c5dec5f4a02f8da5f72e546109313e8a8482b6f18e1a84bb06f25c3f")));
    if (ge27) { println("ge27 PASS"); } else { println("ge27 FAIL"); }
    Bool ge28 = ec_ge(ec_from_be(hb("354ddfe82926c76641b427d52dde8e922c6efca68cced17260e2c4ac3d267a8a")), ec_from_be(hb("3b5fc62484fab0bb534f3a3244e5295024e9bc22f2173836cde6167bab472788")));
    if (!ge28) { println("ge28 PASS"); } else { println("ge28 FAIL"); }
    Bool ge29 = ec_ge(ec_from_be(hb("c0801976342e636382f4ce5c1b0f4b9b72fb4dad5832f8fef1eb0a84edddaf22")), ec_from_be(hb("ba3df4291b39b4b384b810875d4421368132f780e53ee8b41ddf1c417717efa4")));
    if (ge29) { println("ge29 PASS"); } else { println("ge29 FAIL"); }
    Bool ge30 = ec_ge(ec_from_be(hb("1f3fce446976050c18fc04db6729afe41d3ecd4faa5e79a055ab93a5a0dfd63b")), ec_from_be(hb("8701dbec48aaacc594bc13a703186b800e43a24da08378245f38044a9587e390")));
    if (!ge30) { println("ge30 PASS"); } else { println("ge30 FAIL"); }
    Bool ge31 = ec_ge(ec_from_be(hb("47d7dbf9e20180489f3101f60518e126f3eed2b2e62bf33cbbd7e6c3a4477650")), ec_from_be(hb("c5071c34d8c6fbdc4aaf4d35c5af8fe64bd3013653b808c9242a7a39eec9fcd2")));
    if (!ge31) { println("ge31 PASS"); } else { println("ge31 FAIL"); }
    Bool ge32 = ec_ge(ec_from_be(hb("596143217c13dace2077fe5f988a2805a52b23449d4397521c25d6051e3beb15")), ec_from_be(hb("a0fd627a2ee037ad576fdaa33a90707c64f15cda0c513cf2055ba1e283211711")));
    if (!ge32) { println("ge32 PASS"); } else { println("ge32 FAIL"); }
    Bool ge33 = ec_ge(ec_from_be(hb("1ac0d9014ec99f3ee73e1ee9815d41433a62156bac6f2e219f8ea4355e298e5a")), ec_from_be(hb("1ac0d9014ec99f3ee73e1ee9815f41433a62156bac6f2e219f8ea4355e298e5a")));
    if (!ge33) { println("ge33 PASS"); } else { println("ge33 FAIL"); }
    Bool ge34 = ec_ge(ec_from_be(hb("63dc2ae1d4fcd6420822033856ba17fcfc0f3da0e30a45bc4d80ae9e391b8d1a")), ec_from_be(hb("63dc2ae1d4fcd6420822033856ba17fcfc0f2da0e30a45bc4d80ae9e391b8d1a")));
    if (ge34) { println("ge34 PASS"); } else { println("ge34 FAIL"); }
    Bool ge35 = ec_ge(ec_from_be(hb("c0831624f63c2b87ab7929a82ef743360590476ba29441e470df9a12f491deba")), ec_from_be(hb("c0831624f63c2b87ab7929a82ee743360590476ba29441e470df9a12f491deba")));
    if (ge35) { println("ge35 PASS"); } else { println("ge35 FAIL"); }
    Bool ge36 = ec_ge(ec_from_be(hb("60441d5dbf1f0bc9da5a10d5a5cab5bf00e98cd66138c22c42c07e1e021f4351")), ec_from_be(hb("60441d5dbf1f0bc9da5a10d5a5cab5bf00e98cd66138c22c42c47e1e021f4351")));
    if (!ge36) { println("ge36 PASS"); } else { println("ge36 FAIL"); }
    Bool ge37 = ec_ge(ec_from_be(hb("8773de954e35a8745b65d307dbf4845a13cefd3d8deeb78a001a7be0031c71de")), ec_from_be(hb("8773de954f35a8745b65d307dbf4845a13cefd3d8deeb78a001a7be0031c71de")));
    if (!ge37) { println("ge37 PASS"); } else { println("ge37 FAIL"); }
    Bool ge38 = ec_ge(ec_from_be(hb("4db610f85e8e9af3da77f51cba2bbd9a9414b83242fc2100b925962774a62a89")), ec_from_be(hb("4db610f85e8e9af3da77f51cba2bbd9a9414b83242fc2100b925962776a62a89")));
    if (!ge38) { println("ge38 PASS"); } else { println("ge38 FAIL"); }
    Bool ge39 = ec_ge(ec_from_be(hb("8c945fc9a8a8b4db0731bda3f9f6a9f8543dc34df124b0ca7839e99c32c39680")), ec_from_be(hb("8c945fc9a8a8b4db0731bda3f9f6a9f0543dc34df124b0ca7839e99c32c39680")));
    if (ge39) { println("ge39 PASS"); } else { println("ge39 FAIL"); }
    Bool ge40 = ec_ge(ec_from_be(hb("efde8fef5edd76256cdc526739802feed79cdd1cfbd615926b250d20c5e9c396")), ec_from_be(hb("efde8fef5edd76256cdc526739802feed79cdd1cfbd635926b250d20c5e9c396")));
    if (!ge40) { println("ge40 PASS"); } else { println("ge40 FAIL"); }
    Bool ge41 = ec_ge(ec_from_be(hb("aaed9ad4067faa0df7dc48c266b26679791cdff97e378418be82895f298f521f")), ec_from_be(hb("aaed9ad4067faa0df7dc48c266b26679391cdff97e378418be82895f298f521f")));
    if (ge41) { println("ge41 PASS"); } else { println("ge41 FAIL"); }
    Bool ge42 = ec_ge(ec_from_be(hb("b3b0ad1f4bc82bf5b29cf400daf69c26823e732d7b230e66199dab18eaa8611e")), ec_from_be(hb("b3b0ad1f4bc82bf5b29cf400daf69c26823e732d7b230e66199dab18eea8611e")));
    if (!ge42) { println("ge42 PASS"); } else { println("ge42 FAIL"); }
    Bool ge43 = ec_ge(ec_from_be(hb("4f30bd95a6463003bcd43eeace749ee96f80a3a1209aca95951d8f7ea030985c")), ec_from_be(hb("4f30bd95a6463003bcd43eeace749ee96f80a3a1209eca95951d8f7ea030985c")));
    if (!ge43) { println("ge43 PASS"); } else { println("ge43 FAIL"); }
    Bool ge44 = ec_ge(ec_from_be(hb("a22cfcd16e49dd2cce32828a989eb4fef35b9c5c045b66bdf0380d1255f20c23")), ec_from_be(hb("a22cfcd16e49dd2cce32828a989cb4fef35b9c5c045b66bdf0380d1255f20c23")));
    if (ge44) { println("ge44 PASS"); } else { println("ge44 FAIL"); }
    Bool ge45 = ec_ge(ec_from_be(hb("e1db065d58677944f60def8b25f027529b3ea73454d3d40c6f9781da53546006")), ec_from_be(hb("e1db065d58677944f60def8b25f02f529b3ea73454d3d40c6f9781da53546006")));
    if (!ge45) { println("ge45 PASS"); } else { println("ge45 FAIL"); }
    Bool ge46 = ec_ge(ec_from_be(hb("410e95f9db5671566846d21eaef06230506ab4f4e29bd0dafc2869f2404ccbc6")), ec_from_be(hb("410e95f9db5671566846d21eaef06230506ab4f4e29b50dafc2869f2404ccbc6")));
    if (ge46) { println("ge46 PASS"); } else { println("ge46 FAIL"); }
    Bool ge47 = ec_ge(ec_from_be(hb("dd31a032a82f823d0c4abe93184c149cc4c554968a4f59487675fe4e6a983fd9")), ec_from_be(hb("dd31a032a82f823d0c4abe93184c149cc4c554968a4f59487675fe4e6a98bfd9")));
    if (!ge47) { println("ge47 PASS"); } else { println("ge47 FAIL"); }
    Bool ge48 = ec_ge(ec_from_be(hb("77c771883d01f9c1afa72da0bb5cf68d7bf79772ed4c2d48107a184721f157db")), ec_from_be(hb("77c771883d01f9c1afa72da0bb5cf68d7bf79772ed4c2d48107a180721f157db")));
    if (ge48) { println("ge48 PASS"); } else { println("ge48 FAIL"); }
    Bool ge512_0 = ec_ge512(ec_from_be512(hb("ca69115024460203e9afa5133d95b214c96bd97a32e14565209693714ae25a09cd1764e89388133906b879e61e1da507a1e14dc677fc5f9fe62db782ea364126")), ec_from_be512(hb("8918350b81dfbd38c7bcd1d121ace2bb1f4f65c223d4e35c211713a6669d7fec4016aa4874e0a29a729f8c3311ecd5021f23a2bbcb03dea69355cee1e8da1851")));
    if (ge512_0) { println("ge512_0 PASS"); } else { println("ge512_0 FAIL"); }
    Bool ge512_1 = ec_ge512(ec_from_be512(hb("422214bfb1b14c4cf537cb982a190d3b01ae873ebe7382804b23e091a8ce849602f267b705da214b4ef093c9c50cc9e6d0225e23bb45129f1258ed3888e1c7c7")), ec_from_be512(hb("2b843bffc03626f8f18013364ad7c31a2af2b6b5c2405d6f165ee38eea24632087cbb3d9874050dff9093220289b7372a2aa591d64bdee173176bd43f5f6f4ec")));
    if (ge512_1) { println("ge512_1 PASS"); } else { println("ge512_1 FAIL"); }
    Bool ge512_2 = ec_ge512(ec_from_be512(hb("4c334e5372577b4ab594b39e6adeb609187df7e211dc4090285e1592616fd0f567c896640a0d8954d43e91c29ac81a8aa072c906e51e7f6b3243fc29bb9052c2")), ec_from_be512(hb("7ef5c773283df797661cf28da95e58df805cd1e7c1670ebc83a7d9e85d325654c94655c95a0f74b60c53bdf495f1023db6d80370fcb68a187e8899a4ccc0af8a")));
    if (!ge512_2) { println("ge512_2 PASS"); } else { println("ge512_2 FAIL"); }
    Bool ge512_3 = ec_ge512(ec_from_be512(hb("410cf455b8295a56f3c321ec7cd1eb8fb9597178af7a4855bcc2c791ed63128822e8b6ab028ce660187e1f7cf9a41accf441a5b54e4d35f5bb6eba910966aa83")), ec_from_be512(hb("8f644b807186b5454fc33fab18c781ee8b44eb5b6661ce20c17ad50e203c5d9aaf277e8dbaa0efa5cfff668d1b4aebda4598dc7a5ad8f24b3214c5a88eaa5bf6")));
    if (!ge512_3) { println("ge512_3 PASS"); } else { println("ge512_3 FAIL"); }
    Bool ge512_4 = ec_ge512(ec_from_be512(hb("5a8153c2490ef1cd72d8eac35043fa4beb99f6e47b83d8d65ef22f44da04550a54d9f8a6070e99b8a24e19109676bff044fed035b01ae8e640425657999c9e26")), ec_from_be512(hb("78f43e3634e3eb4317c277735bdbe19dee764e14056ac453046356e80f4bfd5ac0c72209e0c0a96527b2fc38f25bf05c7b6d28e7d43a1aeff304ff5957bc7093")));
    if (!ge512_4) { println("ge512_4 PASS"); } else { println("ge512_4 FAIL"); }
    Bool ge512_5 = ec_ge512(ec_from_be512(hb("10df3acfea4cb4b384ed8655ee6339dcc18e441abff644e29f58dc3243ff6fa295287e63ee033d1111262f15d0da2a66e6852d80542afc271e1e6aa5cb9a36b9")), ec_from_be512(hb("e270f69c790fffc888eced542d78caca3871a3bb8892cd09ac38ea165ead4a427594a714354e6231bc504f3dfd80bea52b774bf29eae580bf897906d185b5fbb")));
    if (!ge512_5) { println("ge512_5 PASS"); } else { println("ge512_5 FAIL"); }
    Bool ge512_6 = ec_ge512(ec_from_be512(hb("7ba7651df5703bc6155a2315506f9af548b00c5a77582d152434f662d0449b783147367a57539688d450b74de479fd3fcd0044ca9e4c6329f2f804aae69035c7")), ec_from_be512(hb("431971cc644f65db54e3e52cb42fe261fd5e4796c6db781cb3da929e819d55000e04a90bbcfee5f8011def3db5dae28b10c066c64ae0e1e064f7f5f3a6bbfb1c")));
    if (ge512_6) { println("ge512_6 PASS"); } else { println("ge512_6 FAIL"); }
    Bool ge512_7 = ec_ge512(ec_from_be512(hb("9f5d422b9fcf97af304f8c4a7cadfc777dd794b027f096fe9ecb1bbb88441ce333ccd4f5532f3ed62bf9ce70ca2eebb27e064a18c77f72ddb9e5f84460362d62")), ec_from_be512(hb("fdfb7531835397c281c2f135e36c2cb794baf849cb7ccde841993482c8332faa081363e0f6b367a007942c7f96827280e8c42a5ff3ad61a36e8c3e7374be09d3")));
    if (!ge512_7) { println("ge512_7 PASS"); } else { println("ge512_7 FAIL"); }
    Bool ge512_8 = ec_ge512(ec_from_be512(hb("d7d1ad12928eb990735185a0ed873e88655b4e5c439a5ed542590cd1874ee0a8e3eefb9473881976ac75b4100d26af0f59057c078a8b34620931030fa7ed7106")), ec_from_be512(hb("abb360b7aa26f727e1d28a3db43b6778a26272e0b7f4b471c3dfd5b91257637328ff25bce1f65be6dcc080859c30783bf37b5ccd70b126408be10cef6f88e7a4")));
    if (ge512_8) { println("ge512_8 PASS"); } else { println("ge512_8 FAIL"); }
    Bool ge512_9 = ec_ge512(ec_from_be512(hb("1b76d2f09ff95d9ccd4aeae36854f6f772ad9afaf78e66e42fe4a1c7ff560b87e71929f84db126dc2046a19d37a7a13a8c7807f555ca977d7845a88037afafd4")), ec_from_be512(hb("7b20f02cae12443c422327cff88cc1c5bb80d8bdf00689c7cac42dcc9531017cc4a795f31bff0966d018b3e9262605409eb3dcae17255568b0dd321bf2b78269")));
    if (!ge512_9) { println("ge512_9 PASS"); } else { println("ge512_9 FAIL"); }
    Bool ge512_10 = ec_ge512(ec_from_be512(hb("0014a62b6dfcff4899f5c68c8a584fa73a2fdb4a3aa803753152da7f7e2c379bbd46f197e0994ddf4ec6c3b8a2217cbf37a1fa17b8faf9fa61bc09e2b3a9ab7e")), ec_from_be512(hb("aa3dfdc795694c5f94657a67f28f03855194208455abb5044f6bbdf693dbc34e5a6a0e0a9f6f5d4b5413a1666e62e380f9957fb19b458560084cbd67aef0db00")));
    if (!ge512_10) { println("ge512_10 PASS"); } else { println("ge512_10 FAIL"); }
    Bool ge512_11 = ec_ge512(ec_from_be512(hb("c2408656a9940d93743cdbb3b3019de8cbaf86e605c41080aedfb72c1f0a156ce0eba081c0010888507fd16e9a16f3f80889d0280dbbaabc4491782fb0b61821")), ec_from_be512(hb("f393ce3623a14167a262e761a52b065b234413d826486595dd800e485b904621158a9b5eed2b4703a6c0ca60331bb16c306a3a6b3954a50526604d7e56b5e145")));
    if (!ge512_11) { println("ge512_11 PASS"); } else { println("ge512_11 FAIL"); }
    Bool ge512_12 = ec_ge512(ec_from_be512(hb("4c012c7ee2283068b35c41e69a4ced923388647ef9a0e2bccc04d2dbbbffa24d75fafc0b802d126c700942d9cdd877eb12b3d67800a790df4c5afe8a5137c270")), ec_from_be512(hb("fe08dd2ace2932ff73e37e8435db5aa776b5a408c1ea845a78867ecce891da20bd37597bda356e9c926110fde649b09654dfe67cbdbd29b86c1e14bc2d71b224")));
    if (!ge512_12) { println("ge512_12 PASS"); } else { println("ge512_12 FAIL"); }
    Bool ge512_13 = ec_ge512(ec_from_be512(hb("19d931329f43f6d22981c82afc92bd0ca6821dabd304df447020d98560a46c8b2bc2cb06319e0d6e2f0acdbefa8f217b5ddfb40466caecd2fe3861fde3d879e1")), ec_from_be512(hb("712615f992127b57ce522184ed2c181851c951f3a39618971050230aecf2be8e32257204bcc627fa0a8281949e20d6013e683aff324a6eb2ac707ddd2657b5af")));
    if (!ge512_13) { println("ge512_13 PASS"); } else { println("ge512_13 FAIL"); }
    Bool ge512_14 = ec_ge512(ec_from_be512(hb("ce30c60288b589228b6546c7328a8b3e003a7e95ae01b332e219ce23250a3ddc12e9f4c34381fd07bca6c5a61545dc8b78eb591fbcac9a5c14d59fb765c21bb4")), ec_from_be512(hb("ad44b814551a454d349de79425f61770f9975808ea17a4276c977b5b257684561bf9b23fca95cf111706a3233a1b6c93abfbf8075d3f4380a2254097540a80cc")));
    if (ge512_14) { println("ge512_14 PASS"); } else { println("ge512_14 FAIL"); }
    Bool ge512_15 = ec_ge512(ec_from_be512(hb("22ce58446d2de3b45802f963449134bb891e6c9899c5f89fd803e6dcd561d098d52ceed8762ec973b2c33f6d08b08b8c7da14de613b224234aaa09dbc19fa33b")), ec_from_be512(hb("a2f46234be476a64a9bf2f52a7ff5588ae4e1e938648e8ef62d662f37a6ea45e2f570878de76b12ae3297dd0d2040eb103bd7505f09127ff5f317960d8c51405")));
    if (!ge512_15) { println("ge512_15 PASS"); } else { println("ge512_15 FAIL"); }
    Bool ge512_16 = ec_ge512(ec_from_be512(hb("c16af1d06abdadd876b6802b8985bac796d315f25d4c8612df541759241054dc4a50793920739103d2d79d34527df5c59d746e607324d5cb1962402bba0169e1")), ec_from_be512(hb("30a5c80a06f086a64bb7dc591f297bee84c3b2ff144377dca96b4d529964458a4c8295b185a16a5f7af8bd7492f4a28248330ab325d0c9ec3be264c3383a1bc2")));
    if (ge512_16) { println("ge512_16 PASS"); } else { println("ge512_16 FAIL"); }
    Bool ge512_17 = ec_ge512(ec_from_be512(hb("3a0f8f195686dd78461ce8bad53797307a0760624b86d84d138228a860d2e1e63b5537800a6bf72566d918a848805d135cb66a42b6f554cd8676092eb6f74a73")), ec_from_be512(hb("0813b4cfa9f7d8ea9dd161fbd0b1f8ee6845582d678ec7be4756488266df8b136b26d1e3e491f9665b7d555fb1cf35c7facf1e9d7f163269a929f1ef12cc0600")));
    if (ge512_17) { println("ge512_17 PASS"); } else { println("ge512_17 FAIL"); }
    Bool ge512_18 = ec_ge512(ec_from_be512(hb("ec42ea20f8d998973df3b70dc30e209736d53b09227062a4292231382c209880e67ab030eadba69a372427a30abb8b538010be506f15de49ac2a1fd2cabe1445")), ec_from_be512(hb("9a614d85477f917445a84e054add15196378588e0edfa18eb72484e4ffe3bd28224affdb024688b1e1d4ef328cf773734bf360c29dd30a895f7e1775d40cc037")));
    if (ge512_18) { println("ge512_18 PASS"); } else { println("ge512_18 FAIL"); }
    Bool ge512_19 = ec_ge512(ec_from_be512(hb("264a8892fcd3b179a9415f49bb31938574449a17ea4e40ae4384bc30de19b7503e5b8b8d28856ace1c6996bc823bed5b3fea3a0ef9f8ca6d15dd29f7ad365d67")), ec_from_be512(hb("0d88f7397157f11795b9bc379f5dbc9eec6c03e8ccd94ea6bbdd2d421f02c7ef5016e373e89cf6be1d8938c8fade436608eac94fdaef696f6381ea039fadb621")));
    if (ge512_19) { println("ge512_19 PASS"); } else { println("ge512_19 FAIL"); }
    Bool ge512_20 = ec_ge512(ec_from_be512(hb("00ae65d6d4e03a28bbd130b9affbbd63c8f43e05c868c19b06f3d8e9bf63038e1c2998e28743dda83cce2f1d5d24dda057c6e1e86804effe17f469128dffabd2")), ec_from_be512(hb("00ae65d6d4e03a28bbd130b9affbbd63c8f43e05c868c19b06f3d8e9bf63038e1c2998e28743dda83cce2f1d5d24dda057c6a1e86804effe17f469128dffabd2")));
    if (ge512_20) { println("ge512_20 PASS"); } else { println("ge512_20 FAIL"); }
    Bool ge512_21 = ec_ge512(ec_from_be512(hb("22b482a7fd0b964c52eb2ef9c0436f62543ceff36fbeadd6abc3c32e17a4bc7c99c6bb25a24c7d9c598f86174de77816d371ddbc8189c3339900f53b58c0d9b2")), ec_from_be512(hb("22bc82a7fd0b964c52eb2ef9c0436f62543ceff36fbeadd6abc3c32e17a4bc7c99c6bb25a24c7d9c598f86174de77816d371ddbc8189c3339900f53b58c0d9b2")));
    if (!ge512_21) { println("ge512_21 PASS"); } else { println("ge512_21 FAIL"); }
    Bool ge512_22 = ec_ge512(ec_from_be512(hb("02f46bca6c123d8471e1e8b39946a420734e76b04431e92a495ade1dccae87eea63c2e64d14633d6f80e573a7044cb97aaf63bf74806906f5a7346c7bcb99d64")), ec_from_be512(hb("02f46fca6c123d8471e1e8b39946a420734e76b04431e92a495ade1dccae87eea63c2e64d14633d6f80e573a7044cb97aaf63bf74806906f5a7346c7bcb99d64")));
    if (!ge512_22) { println("ge512_22 PASS"); } else { println("ge512_22 FAIL"); }
    Bool ge512_23 = ec_ge512(ec_from_be512(hb("ee8645b0406eaffc55492efb2c4a90b4cf7664244f1803b20ab457bed4a5804cecb96a237e5ad0807741e61550d6bb93f7c58b070e378597ec4d4f4b95a713dd")), ec_from_be512(hb("ee8645b0406eaffc55492efb2c4a90b4cf7664644f1803b20ab457bed4a5804cecb96a237e5ad0807741e61550d6bb93f7c58b070e378597ec4d4f4b95a713dd")));
    if (!ge512_23) { println("ge512_23 PASS"); } else { println("ge512_23 FAIL"); }
    Bool ge512_24 = ec_ge512(ec_from_be512(hb("cbbbf69fbeae8c459fa66a23b6fa520b3cd032cc357cb7ed74c41ee6957fd760953ebf2e83b64bd0d7cccd2d66f50155d94b737609caa70a71b1a493744542e0")), ec_from_be512(hb("cbbbf69fbeae8c459fa66a23b6fa520b3cd032cc357cb7ed74c41ee6957fd760973ebf2e83b64bd0d7cccd2d66f50155d94b737609caa70a71b1a493744542e0")));
    if (!ge512_24) { println("ge512_24 PASS"); } else { println("ge512_24 FAIL"); }
    Bool ge512_25 = ec_ge512(ec_from_be512(hb("80c627223c443d16546b062836c47121c47dbda0d91f90c57e1332a9b1d3b608c61d5372cd0b0acd552b47767d419fe0fb05d0d4bed01e42aa85e0ec786467fc")), ec_from_be512(hb("80c627223c443d16546b062836c47121c47dbda0d91f90c57e1332a9b1d3b608c61d5372cd0b8acd552b47767d419fe0fb05d0d4bed01e42aa85e0ec786467fc")));
    if (!ge512_25) { println("ge512_25 PASS"); } else { println("ge512_25 FAIL"); }
    Bool ge512_26 = ec_ge512(ec_from_be512(hb("e1697afb1ebc472def0471b941b86b3c9367f2246e146257e7b0a1f6e0df89f6f532f7613450ec2ed552f21a4fd364213e3c6facf0a7f6a226ca6688e27957c4")), ec_from_be512(hb("e1697afb1ebc472def0471b941b86b3c9367f2246e146257e7b0a1f6e0df89f6f532f7613450ec2ed552f31a4fd364213e3c6facf0a7f6a226ca6688e27957c4")));
    if (!ge512_26) { println("ge512_26 PASS"); } else { println("ge512_26 FAIL"); }
    Bool ge512_27 = ec_ge512(ec_from_be512(hb("341eaa7a69d98951eda7efd9d3e3917e8b611f95a5fc873e71882b96bbeb7737d57f3a70734551e10e3bc12d2c2504d28444b8cf27f032ab81859431382acf0e")), ec_from_be512(hb("341eaa7a69d98951eda7efd1d3e3917e8b611f95a5fc873e71882b96bbeb7737d57f3a70734551e10e3bc12d2c2504d28444b8cf27f032ab81859431382acf0e")));
    if (ge512_27) { println("ge512_27 PASS"); } else { println("ge512_27 FAIL"); }
    Bool ge512_28 = ec_ge512(ec_from_be512(hb("648c96ed65869ae3a08351adb163b4e6633305eeb630c945b080edd3e33e11869b567a0a4e66064535f90ab14bc8d70b3173c8cbba6dd7a6126fd11f7fd4007e")), ec_from_be512(hb("648c96ed65869ae3a08351adb163b4e6633305eeb630c945b080edd3e33e11869b567a0a4e66064535f90ab14bc8d70b3172c8cbba6dd7a6126fd11f7fd4007e")));
    if (ge512_28) { println("ge512_28 PASS"); } else { println("ge512_28 FAIL"); }
    Bool ge512_29 = ec_ge512(ec_from_be512(hb("d16019b4b024883cb8593805d564fbd073bf88356ad106c7141a1bed547c71b85e2a2eefea3dee5c6a997cf9fbe6e3b5e59e59bb597ac5dfb5a024223f664ad0")), ec_from_be512(hb("d12019b4b024883cb8593805d564fbd073bf88356ad106c7141a1bed547c71b85e2a2eefea3dee5c6a997cf9fbe6e3b5e59e59bb597ac5dfb5a024223f664ad0")));
    if (ge512_29) { println("ge512_29 PASS"); } else { println("ge512_29 FAIL"); }
    Bool ge512_30 = ec_ge512(ec_from_be512(hb("2b35c3899154954f502f31f02e2ae40bf87995ce0363280e15d8f4e0297385045efd3b7c0a305eac2519a2e688d2081daf90ef6596dfa0a82387ee7edba9f41f")), ec_from_be512(hb("2b35c3899154954f502f31f02e2ae40bf87995ce0363280e15d8f4e0297385045efd3b7c0a305eac2519a2e68ad2081daf90ef6596dfa0a82387ee7edba9f41f")));
    if (!ge512_30) { println("ge512_30 PASS"); } else { println("ge512_30 FAIL"); }
    Bool ge512_31 = ec_ge512(ec_from_be512(hb("11b95ef8dc7d403c595c8857976907dae7af2a7b2be1b7d1dd5f3d9a1f96a05c7bb6ecde7efcd6cf00de914cd57b05aad2e3fdf5ae7f47e2545347cd748f4dd2")), ec_from_be512(hb("11b95ef8dc7d403c595c8857976907dae7af2a7b2be1b7d1dd5f3d9a1f96a05c7bb6ecde7efcd6cf00de914cd57b05aad2e3fdf5ae6f47e2545347cd748f4dd2")));
    if (ge512_31) { println("ge512_31 PASS"); } else { println("ge512_31 FAIL"); }
    Bool cv0 = tm_ecdsa_verify_sha256(hb("e5019433c0697f6a90ea102ce8a86354787f508932e824a59802554b3d1d925c445c7afb9cb2765de55301b79277327d6604e0c69c42cc2a7fddf2292d4634e2d8fa66cc76da034fd44225af282406e052f6761f6eaaad8bf9cff242990cdeffde5266f5287e97aec43ebe476babce4361c4ccf0ab74c4657d499485e745d68ea887"), hb("0004a834c5ed734924fe2df8c0786a4141bee4c1c5f24fa5858a5287464fe6cd24d9740d595f4011f6f8640532deefa558828c94a51a42d50f7fcc4958b315f30647"), hb("30450220713fff1c5ad46b035d5cc7712ae8f8c71b45027c22ece265c9d51339c81c9172022100dd24eec2f67ac3fa8b9497b78939a4e8d8f079de38ea9a462d10b9cf40c3b941"));
    if (cv0) { println("cv0 PASS"); } else { println("cv0 FAIL"); }
    Bool cv1 = tm_ecdsa_verify_sha256(hb("3304fa5b466e2a5f2bf679b77cc04693432dd4b50b5d27b50aea23dc1a8719af6203beaa0d2ca5d0b7ecd7f3e5d198bc26fe968ded7688f3405fd1045b5db7043e17dbee65634f9a0ac3e16929fc9fc56d3eedd5125acc52594f30089fc03078678def9b683ab99be698e1d2af1db54b9a8f64b7d2017c3d2b54fdc3b24b859ab54f"), hb("0004a834c5ed734924fe2df8c0786a4141bee4c1c5f24fa5858a5287464fe6cd24d9740d595f4011f6f8640532deefa558828c94a51a42d50f7fcc4958b315f30647"), hb("304402207b670d597712e4e9cecf0085b80a710bfa970f5453adb76fd1490b51926c153f022017043380e257556ec3eeda9adf72d569a781673b73fe4c5fdd7e49558b8dbc0e"));
    if (cv1) { println("cv1 PASS"); } else { println("cv1 FAIL"); }
    Bool cv2 = tm_ecdsa_verify_sha256(hb("005a091db668456c90d4b383ddffe3d4b0706b0cce7a5631e62e5a8748ee522891d5346d499a8ce916ad4104737563ac8331e335cbd29590b939df797bc3bf49e4be06bd4852fd7ae930e8abeaed5cef7069c5bcee50c0be413dce8323a7f7baaac89e90067d2f2f4128a001f22356ea256932fc361d622ab01f7610a238c99b72af"), hb("0004a834c5ed734924fe2df8c0786a4141bee4c1c5f24fa5858a5287464fe6cd24d9740d595f4011f6f8640532deefa558828c94a51a42d50f7fcc4958b315f30647"), hb("304402204e5729332de0c7d87e78d4d2d71045844a663ea32def8d3122a55fd548e3824e02207037b6c57ceaf08d1683664f06572482b1d014681ace250c804a124f347248c3"));
    if (!cv2) { println("cv2 PASS"); } else { println("cv2 FAIL"); }
    Bool cv3 = tm_ecdsa_verify_sha256(hb("49a08af3aec5315d230079a287d17d9f9088665a62a3b7bdde4512d7f00b28338cc36fe578b4140e6baa9e621c7c1ef84ae94c6f70fed485b937506d9b894ae43b8e87ee8312ee50dca9581ef62993b7c19894ef1b7a9512447e26f20d3daacbb84ba8303d5e73e8dafed9f873ec85377f0cba98211551b9839f908e7f134c5f5aee"), hb("0004a834c5ed734924fe2df8c0786a4141bee4c1c5f24fa5858a5287464fe6cd24d9740d595f4011f6f8640532deefa558828c94a51a42d50f7fcc4958b315f30647"), hb("3045022005db06f8a01b253e6b97f54cc4ff76fd9d2a76b8e64990528f8ea6a2965a6735022100b4cbcca93252c93a42be785a6bb920375af392b7d89728ece3a86672c99a9df5"));
    if (cv3) { println("cv3 PASS"); } else { println("cv3 FAIL"); }
    Bool cv4 = tm_ecdsa_verify_sha256(hb("6a01315ee57d8bb454f5aea8476a43afc1f40bcf3f4c197db8a9da0066029935a66ccd7e3527e9f83928747b4039491fc967963c48711e6220d4d68a00858537a4f0c0eeced83b2c7ff6e01c2ebe6c41858a81f533fbf06c8ddbf615e0b68d9ffa793910894b7d0a6db47cf3a1377e45d9e140cfe85965e1eede94733c82efabb259"), hb("0004a834c5ed734924fe2df8c0786a4141bee4c1c5f24fa5858a5287464fe6cd24d9740d595f4011f6f8640532deefa558828c94a51a42d50f7fcc4958b315f30647"), hb("30450220549532ddd11ccca7e13008387f81637d7c4aad792e954af1427b4a026078e734022100f259216ae41174e0308ea30e31f4681c33309a246ad749b886824b065e4d7696"));
    if (cv4) { println("cv4 PASS"); } else { println("cv4 FAIL"); }
    Bool cv5 = tm_ecdsa_verify_sha256(hb("bf39d30d7a65e9daf47912e15bfe7ba0ceb1d99fd6c2b10ae7ce4292280e0832188dc435350c70fa826819ab64150dbb0a246007c9dce914d01a55139de2cc5eedd26d9299ecbc59b9f2776e99c05f742abf04bb5ee935c86092d75e9a53925bcb8f8a99d8ea1f605da37bc5529de81d0109d3f22ee2f5dd1c1c44a0f6097c2d7e34"), hb("0004a834c5ed734924fe2df8c0786a4141bee4c1c5f24fa5858a5287464fe6cd24d9740d595f4011f6f8640532deefa558828c94a51a42d50f7fcc4958b315f30647"), hb("3045022100db494e75e459e4a20f77763d3d4fa1ab21da3825a8913193ff739be6f8d24689022020e818d83a910291fec69d43fb05ecfddfeb85aa6795075be269ac469f4375cc"));
    if (!cv5) { println("cv5 PASS"); } else { println("cv5 FAIL"); }
    Bool cv6 = tm_ecdsa_verify_sha256(hb("7a62ad2f1feab41e23d28cb8783dd12db8eb82a8444b142c75bf573d4b876894146b54e8dd50423465c781b4b01b91218ef4a4c131e18a013fc314afad3416fea15bb84fa5ffd50f6849987332a351b6fbf0ec691ac1ba4c01212cc40fea142eaee46bcdf5b87e904e334d1a63eedb4e79d4b6aba27b37c7383794e232485500b0ff"), hb("0004a834c5ed734924fe2df8c0786a4141bee4c1c5f24fa5858a5287464fe6cd24d9740d595f4011f6f8640532deefa558828c94a51a42d50f7fcc4958b315f30647"), hb("3045022100d3742840f02de89198664999880c6b87868e178a5bb3ffc09ca1b71ff99e4577022079c2cba2553192a89ce364e523b4e7e8723ce6ba50e64aebf0e05ddbddbc29f7"));
    if (cv6) { println("cv6 PASS"); } else { println("cv6 FAIL"); }
    Bool cv7 = tm_ecdsa_verify_sha256(hb("a59e7414d2009fa61a76c4f0067218caa1ab67d78f4fea093d65c5e1299a381df2a0c33aecf1f6c7398ec1663be96cd2cc1497fd9f584d68d8f2e434349d9200657b556523787ecfac804caf158c35be37fc7f67d2628a457fcd8090267b52436adccfb54c4e9727d05d81626892ed933dcdeab721d77dc4681db775137179fec412"), hb("0004a834c5ed734924fe2df8c0786a4141bee4c1c5f24fa5858a5287464fe6cd24d9740d595f4011f6f8640532deefa558828c94a51a42d50f7fcc4958b315f30647"), hb("304502205082d7b57c5b996e19bc0ac0c87d72d2146d534b12674bd46b21524758d29cb70221008a3e16affccb2767fdb78c0339ffc7646545f8526734717c75519566ab52fb16"));
    if (cv7) { println("cv7 PASS"); } else { println("cv7 FAIL"); }
    Bool cv8 = tm_ecdsa_verify_sha256(hb("6d94c4789632031aef0ccd162be99f906e181e8baf719a8ca141bb6f6530ffb5bf027c1a3a56487d0ff848a49ab82a120728e824925bd074b5cec9524e7bba471d45fce2a392ff9bc96e4c4d6c4602a105a26ae0b318bbd2acc64ca0629620729e139bb0d530597cf3a884b487373fcb529f94f4bb2947190238791dcb60fdca7fc6"), hb("0004a834c5ed734924fe2df8c0786a4141bee4c1c5f24fa5858a5287464fe6cd24d9740d595f4011f6f8640532deefa558828c94a51a42d50f7fcc4958b315f30647"), hb("3045022100802c0d4888a6cb38cf46b64d96978633be18aa195e6d1f58903138401a6bf79c02200e5ca35b6a14671d9c05fe825511b6f9181669689e8d291985f5cc59b456f166"));
    if (!cv8) { println("cv8 PASS"); } else { println("cv8 FAIL"); }
    Bool cv9 = tm_ecdsa_verify_sha256(hb("2868331c2fdf7f82b505e4e0d45100ea1f5daeca01da1e238ca4ba16f2408d87da56118b7f32fa1a7da2caf720486290cb4fbc37c9536a0960384b56f182298f3b0c7bcc53d73b83f49d42c6f129c140ae37a0ddbcf0efc9affc99b15b5883663bcd68c1220cdd21965aaacb0560944847f9baedd6cd923ea25008ff4c4cf62f6535"), hb("0004a834c5ed734924fe2df8c0786a4141bee4c1c5f24fa5858a5287464fe6cd24d9740d595f4011f6f8640532deefa558828c94a51a42d50f7fcc4958b315f30647"), hb("304502205ce2422e693765988658942ef89dab96c57b9771e1e9a0d7c36d942c34ee52e6022100a4a6dcc003fe5bffa5ea8e3f79dfdb983bca345e6ced02f92c4d5b2c59d3fd61"));
    if (cv9) { println("cv9 PASS"); } else { println("cv9 FAIL"); }
    Bool cv10 = tm_ecdsa_verify_sha256(hb("0ebb9a13c47a22c3ffa0825fa4825a33c69634e31e4e59f1ced46746dcbbf06c5f14e2db8e2fa01dcc15cc029d81564236b806c71fc72bb9702c5a5f05a245c4b21a5dca6759be24cc0363997350aa857e3a29f28a1dd31c8d993459bfcecd5e30d4a6aea5c90a88de1cad242df7e90ed82389724248a16e02230c74010c85b0a9ff"), hb("0004a834c5ed734924fe2df8c0786a4141bee4c1c5f24fa5858a5287464fe6cd24d9740d595f4011f6f8640532deefa558828c94a51a42d50f7fcc4958b315f30647"), hb("304502207465831102ba02e0d793f2a1475965a06f05afea0a1cb42f5dcffc9917d4a7340221009ad4273493db6593a5758744dfcddeb16118814f93cf9af0dbe7e7ebf666627e"));
    if (cv10) { println("cv10 PASS"); } else { println("cv10 FAIL"); }
    Bool cv11 = tm_ecdsa_verify_sha256(hb("246b7ad1db7dd069fdf6af5ce74a20bcf5bd2b7a851b56387af4849b32507879c2cda83fa368701fbb5bb7c2bac5d4e438b119c25feaec9f892bfa5f0e1b9a38d9f6b74d1ee2b4abdc57ca01c501cb6e9077fdcabd73d6b977ddcea9138a6cf735c8edb9c7e6919fe7c254263c8619ff73e4eb5518018bbaaf1c2416fe0ace871689"), hb("0004a834c5ed734924fe2df8c0786a4141bee4c1c5f24fa5858a5287464fe6cd24d9740d595f4011f6f8640532deefa558828c94a51a42d50f7fcc4958b315f30647"), hb("3044022035b657fc2e042d27e6f0ca8d0cce5d8b56258dca2126206c31e8b116d796622e02200dfdc01c86bb2610cd639b57bc5ebc64765ac8429bd79d766b4403a0cd7c2ca2"));
    if (!cv11) { println("cv11 PASS"); } else { println("cv11 FAIL"); }
    Bool cv12 = tm_ecdsa_verify_sha256(hb("5a689fc7b2de7313ada62a0bf2d34e393f8027a259287a2dda2666e586138f2b4ee68433831ac4b081e6c0811c69a588e4ef2817f650ca952b83d4df8b468e400dd9a6bfdb13619c56272749fcb28a8039c5570ed7ecc0df5af1eafd75f36f99441403d66300e872b97e192308a348076e405aead6729df50085db47f012905fa36a"), hb("0004a834c5ed734924fe2df8c0786a4141bee4c1c5f24fa5858a5287464fe6cd24d9740d595f4011f6f8640532deefa558828c94a51a42d50f7fcc4958b315f30647"), hb("3045022100e8aef19a56b852491ca1309c4653dc725fce38a7bff8ab5bd199b04b850eabf60220472fef1b4bd396d52180a123720fa29c365dd60fe53ad0c7af50753264cd3907"));
    if (cv12) { println("cv12 PASS"); } else { println("cv12 FAIL"); }
    Bool cv13 = tm_ecdsa_verify_sha256(hb("8c1b49b8316ea297b933c5f9a59d72d0d466ec025467cec3fb6d163c0925f280273c89d1ff20be06a6c34790d75385e3210af41aa5433002f588244d3334794dff8840577c420b9366b38f1f41afb8ff729b22542b2c0fedb852571df495db66f94c5bd8c9c26e6a3e1bf076a2def1d9c1d0737883e0ba52f8a034a53d9d43632bb7"), hb("0004a834c5ed734924fe2df8c0786a4141bee4c1c5f24fa5858a5287464fe6cd24d9740d595f4011f6f8640532deefa558828c94a51a42d50f7fcc4958b315f30647"), hb("30450220751001d747c1dd74a2a747e492ea90289ec18a689ee0f454d147b04fec748fa0022100836fd2f2396d421b4430d0e2711902f000b1ce8ba0697af703d6bdacf2520ce2"));
    if (cv13) { println("cv13 PASS"); } else { println("cv13 FAIL"); }
    return 0;
}
"#;
    let file = dir.join("main.resid");
    std::fs::write(&file, src).unwrap();
    let out = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("failed to run residc");
    let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    assert!(stdout.contains("ge0 PASS"), "missing marker: ge0 PASS");
    assert!(stdout.contains("ge1 PASS"), "missing marker: ge1 PASS");
    assert!(stdout.contains("ge2 PASS"), "missing marker: ge2 PASS");
    assert!(stdout.contains("ge3 PASS"), "missing marker: ge3 PASS");
    assert!(stdout.contains("ge4 PASS"), "missing marker: ge4 PASS");
    assert!(stdout.contains("ge5 PASS"), "missing marker: ge5 PASS");
    assert!(stdout.contains("ge6 PASS"), "missing marker: ge6 PASS");
    assert!(stdout.contains("ge7 PASS"), "missing marker: ge7 PASS");
    assert!(stdout.contains("ge8 PASS"), "missing marker: ge8 PASS");
    assert!(stdout.contains("ge9 PASS"), "missing marker: ge9 PASS");
    assert!(stdout.contains("ge10 PASS"), "missing marker: ge10 PASS");
    assert!(stdout.contains("ge11 PASS"), "missing marker: ge11 PASS");
    assert!(stdout.contains("ge12 PASS"), "missing marker: ge12 PASS");
    assert!(stdout.contains("ge13 PASS"), "missing marker: ge13 PASS");
    assert!(stdout.contains("ge14 PASS"), "missing marker: ge14 PASS");
    assert!(stdout.contains("ge15 PASS"), "missing marker: ge15 PASS");
    assert!(stdout.contains("ge16 PASS"), "missing marker: ge16 PASS");
    assert!(stdout.contains("ge17 PASS"), "missing marker: ge17 PASS");
    assert!(stdout.contains("ge18 PASS"), "missing marker: ge18 PASS");
    assert!(stdout.contains("ge19 PASS"), "missing marker: ge19 PASS");
    assert!(stdout.contains("ge20 PASS"), "missing marker: ge20 PASS");
    assert!(stdout.contains("ge21 PASS"), "missing marker: ge21 PASS");
    assert!(stdout.contains("ge22 PASS"), "missing marker: ge22 PASS");
    assert!(stdout.contains("ge23 PASS"), "missing marker: ge23 PASS");
    assert!(stdout.contains("ge24 PASS"), "missing marker: ge24 PASS");
    assert!(stdout.contains("ge25 PASS"), "missing marker: ge25 PASS");
    assert!(stdout.contains("ge26 PASS"), "missing marker: ge26 PASS");
    assert!(stdout.contains("ge27 PASS"), "missing marker: ge27 PASS");
    assert!(stdout.contains("ge28 PASS"), "missing marker: ge28 PASS");
    assert!(stdout.contains("ge29 PASS"), "missing marker: ge29 PASS");
    assert!(stdout.contains("ge30 PASS"), "missing marker: ge30 PASS");
    assert!(stdout.contains("ge31 PASS"), "missing marker: ge31 PASS");
    assert!(stdout.contains("ge32 PASS"), "missing marker: ge32 PASS");
    assert!(stdout.contains("ge33 PASS"), "missing marker: ge33 PASS");
    assert!(stdout.contains("ge34 PASS"), "missing marker: ge34 PASS");
    assert!(stdout.contains("ge35 PASS"), "missing marker: ge35 PASS");
    assert!(stdout.contains("ge36 PASS"), "missing marker: ge36 PASS");
    assert!(stdout.contains("ge37 PASS"), "missing marker: ge37 PASS");
    assert!(stdout.contains("ge38 PASS"), "missing marker: ge38 PASS");
    assert!(stdout.contains("ge39 PASS"), "missing marker: ge39 PASS");
    assert!(stdout.contains("ge40 PASS"), "missing marker: ge40 PASS");
    assert!(stdout.contains("ge41 PASS"), "missing marker: ge41 PASS");
    assert!(stdout.contains("ge42 PASS"), "missing marker: ge42 PASS");
    assert!(stdout.contains("ge43 PASS"), "missing marker: ge43 PASS");
    assert!(stdout.contains("ge44 PASS"), "missing marker: ge44 PASS");
    assert!(stdout.contains("ge45 PASS"), "missing marker: ge45 PASS");
    assert!(stdout.contains("ge46 PASS"), "missing marker: ge46 PASS");
    assert!(stdout.contains("ge47 PASS"), "missing marker: ge47 PASS");
    assert!(stdout.contains("ge48 PASS"), "missing marker: ge48 PASS");
    assert!(stdout.contains("ge512_0 PASS"), "missing marker: ge512_0 PASS");
    assert!(stdout.contains("ge512_1 PASS"), "missing marker: ge512_1 PASS");
    assert!(stdout.contains("ge512_2 PASS"), "missing marker: ge512_2 PASS");
    assert!(stdout.contains("ge512_3 PASS"), "missing marker: ge512_3 PASS");
    assert!(stdout.contains("ge512_4 PASS"), "missing marker: ge512_4 PASS");
    assert!(stdout.contains("ge512_5 PASS"), "missing marker: ge512_5 PASS");
    assert!(stdout.contains("ge512_6 PASS"), "missing marker: ge512_6 PASS");
    assert!(stdout.contains("ge512_7 PASS"), "missing marker: ge512_7 PASS");
    assert!(stdout.contains("ge512_8 PASS"), "missing marker: ge512_8 PASS");
    assert!(stdout.contains("ge512_9 PASS"), "missing marker: ge512_9 PASS");
    assert!(stdout.contains("ge512_10 PASS"), "missing marker: ge512_10 PASS");
    assert!(stdout.contains("ge512_11 PASS"), "missing marker: ge512_11 PASS");
    assert!(stdout.contains("ge512_12 PASS"), "missing marker: ge512_12 PASS");
    assert!(stdout.contains("ge512_13 PASS"), "missing marker: ge512_13 PASS");
    assert!(stdout.contains("ge512_14 PASS"), "missing marker: ge512_14 PASS");
    assert!(stdout.contains("ge512_15 PASS"), "missing marker: ge512_15 PASS");
    assert!(stdout.contains("ge512_16 PASS"), "missing marker: ge512_16 PASS");
    assert!(stdout.contains("ge512_17 PASS"), "missing marker: ge512_17 PASS");
    assert!(stdout.contains("ge512_18 PASS"), "missing marker: ge512_18 PASS");
    assert!(stdout.contains("ge512_19 PASS"), "missing marker: ge512_19 PASS");
    assert!(stdout.contains("ge512_20 PASS"), "missing marker: ge512_20 PASS");
    assert!(stdout.contains("ge512_21 PASS"), "missing marker: ge512_21 PASS");
    assert!(stdout.contains("ge512_22 PASS"), "missing marker: ge512_22 PASS");
    assert!(stdout.contains("ge512_23 PASS"), "missing marker: ge512_23 PASS");
    assert!(stdout.contains("ge512_24 PASS"), "missing marker: ge512_24 PASS");
    assert!(stdout.contains("ge512_25 PASS"), "missing marker: ge512_25 PASS");
    assert!(stdout.contains("ge512_26 PASS"), "missing marker: ge512_26 PASS");
    assert!(stdout.contains("ge512_27 PASS"), "missing marker: ge512_27 PASS");
    assert!(stdout.contains("ge512_28 PASS"), "missing marker: ge512_28 PASS");
    assert!(stdout.contains("ge512_29 PASS"), "missing marker: ge512_29 PASS");
    assert!(stdout.contains("ge512_30 PASS"), "missing marker: ge512_30 PASS");
    assert!(stdout.contains("ge512_31 PASS"), "missing marker: ge512_31 PASS");
    assert!(stdout.contains("cv0 PASS"), "missing marker: cv0 PASS");
    assert!(stdout.contains("cv1 PASS"), "missing marker: cv1 PASS");
    assert!(stdout.contains("cv2 PASS"), "missing marker: cv2 PASS");
    assert!(stdout.contains("cv3 PASS"), "missing marker: cv3 PASS");
    assert!(stdout.contains("cv4 PASS"), "missing marker: cv4 PASS");
    assert!(stdout.contains("cv5 PASS"), "missing marker: cv5 PASS");
    assert!(stdout.contains("cv6 PASS"), "missing marker: cv6 PASS");
    assert!(stdout.contains("cv7 PASS"), "missing marker: cv7 PASS");
    assert!(stdout.contains("cv8 PASS"), "missing marker: cv8 PASS");
    assert!(stdout.contains("cv9 PASS"), "missing marker: cv9 PASS");
    assert!(stdout.contains("cv10 PASS"), "missing marker: cv10 PASS");
    assert!(stdout.contains("cv11 PASS"), "missing marker: cv11 PASS");
    assert!(stdout.contains("cv12 PASS"), "missing marker: cv12 PASS");
    assert!(stdout.contains("cv13 PASS"), "missing marker: cv13 PASS");
    let _ = std::fs::remove_dir_all(&dir);
}

/// Minimal regression: ec_ge(0, u256::MAX) must be false even inside a
/// larger translation unit full of prior wide-int operations.
#[test]
fn run_ec_ge_zero_max_in_resid() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-eczero-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent().unwrap().parent().unwrap();
    for f in ["crypto.resid","aesgcm.resid","ed25519.resid","x25519.resid","tls.resid","tlsmsg.resid","chain.resid","rsa.resid","ec256.resid","der.resid","x509.resid"] {
        std::fs::copy(workspace.join("lib").join(f), dir.join(f)).unwrap();
    }
    let file = dir.join("main.resid");
    std::fs::write(&file, r#"
import "ec256.resid";
import "crypto.resid";

List(Int) hb_acc(Str s, Int i, List(Int) acc) {
    if (i >= str_len(s)) { return acc; }
    Int c = str_char_at(s, i);
    Int dhi = c - 87;
    Int dlo = c - 48;
    Int hi = if (c > 96) { dhi } else { dlo };
    Int j = i + 1;
    Int c2 = str_char_at(s, j);
    Int ehi = c2 - 87;
    Int elo = c2 - 48;
    Int lo = if (c2 > 96) { ehi } else { elo };
    Int byt = hi * 16 + lo;
    List(Int) acc2 = acc.concat([byt]);
    Int ni = i + 2;
    return hb_acc(s, ni, acc2);
}
List(Int) hb(Str s) { return hb_acc(s, 0, [0]); }

Int main() {
    Int(256) a = ec_from_be(hb("0000000000000000000000000000000000000000000000000000000000000000"));
    Int(256) b = ec_from_be(hb("ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"));
    Bool t = ec_ge(a, b);
    if (!t) { println("ZERO-MAX OK"); } else { println("ZERO-MAX BAD"); }
    return 0;
}
"#).unwrap();
    let out = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("failed to run residc");
    let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
    assert!(stdout.contains("ZERO-MAX OK"), "{}", stdout);
    let _ = std::fs::remove_dir_all(&dir);
}


/// Shift counts >= bit width yield 0 (machine shifts wrap the count mod width).
#[test]
fn run_shift_overflow_yields_zero() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-shovf-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("main.resid");
    std::fs::write(
        &file,
        r#"
Int main() {
    Int x = 8;
    println(IntToString(x >> 64));
    println(IntToString(x << 100));
    println(IntToString(x >> 1));
    return 0;
}
"#,
    )
    .unwrap();
    let out = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("failed to run residc");
    let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    assert_eq!(stdout.trim(), "0\n0\n4", "{stdout:?}");
    let _ = std::fs::remove_dir_all(&dir);
}

/// SHA-512 in pure Resid (32-bit limb pairs) — FIPS 180-4 vectors incl. multi-block.
#[test]
fn run_sha512_in_resid() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-sha512-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap();
    std::fs::copy(workspace.join("lib/crypto.resid"), dir.join("crypto.resid")).unwrap();
    let file = dir.join("main.resid");
    std::fs::write(
        &file,
        r#"
import "crypto.resid";
List(Int) n_as(Int k, List(Int) acc) {
    if (k == 0) { return acc; }
    List(Int) acc2 = acc.concat([97]);
    Int k2 = k - 1;
    return n_as(k2, acc2);
}
Int main() {
    println(hex_encode(sha512_bytes(bytes_of(""))));
    println(hex_encode(sha512_bytes(bytes_of("abc"))));
    println(hex_encode(sha512_bytes(n_as(200, [0]))));
    return 0;
}
"#,
    )
    .unwrap();
    let out = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("failed to run residc");
    let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    assert_eq!(
        stdout.trim(),
        "cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e\nddaf35a193617abacc417349ae20413112e6fa4e89a97ea20a9eeee64b55d39a2192992a274fc1a836ba3c23a3feebbd454d4423643ce80e2a9ac94fa54ca49f\n4b11459c33f52a22ee8236782714c150a3b2c60994e9acee17fe68947a3e6789f31e7668394592da7bef827cddca88c4e6f86e4df7ed1ae6cba71f3e98faee9f",
        "{stdout:?}"
    );
    let _ = std::fs::remove_dir_all(&dir);
}

/// HMAC-SHA256 in pure Resid — RFC 4231-style vectors via lib/crypto.resid.
#[test]
fn run_hmac_sha256_in_resid() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-hmac-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap();
    std::fs::copy(workspace.join("lib/crypto.resid"), dir.join("crypto.resid")).unwrap();
    let file = dir.join("main.resid");
    std::fs::write(
        &file,
        r#"
import "crypto.resid";
Int main() {
    List(Int) k1 = bytes_of("key");
    List(Int) m1 = bytes_of("The quick brown fox jumps over the lazy dog");
    println(hex_encode(hmac_sha256_bytes(k1, m1)));
    List(Int) k2 = bytes_of("Jefe");
    List(Int) m2 = bytes_of("what do ya want for nothing?");
    println(hex_encode(hmac_sha256_bytes(k2, m2)));
    return 0;
}
"#,
    )
    .unwrap();
    let out = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("failed to run residc");
    let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    assert_eq!(
        stdout.trim(),
        "f7bc83f430538424b13298e6aa6fb143ef4d59a14946175997479dbc2d1a3cd8\n5bdcc146bf60754e6a042426089575c75a003f089d2739839dec58b964ec3843",
        "{stdout:?}"
    );
    let _ = std::fs::remove_dir_all(&dir);
}

/// Crypto v3: constant-time equality, Base64, PBKDF2-HMAC-SHA256.
#[test]
fn run_crypto_kit() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-kit-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap();
    std::fs::copy(workspace.join("lib/crypto.resid"), dir.join("crypto.resid")).unwrap();
    let file = dir.join("main.resid");
    std::fs::write(
        &file,
        r#"
import "crypto.resid";
Int main() {
    List(Int) a = bytes_of("attack at dawn");
    List(Int) b = bytes_of("attack at dawn");
    List(Int) c = bytes_of("attack at dusk");
    if (ct_equal(a, b)) {
        println("equal");
    }
    if (!ct_equal(a, c)) {
        println("different");
    }
    println(base64_encode(bytes_of("hello")));
    println(hex_encode(pbkdf2_hmac_sha256(bytes_of("password"), bytes_of("salt"), 4096, 1)));
    return 0;
}
"#,
    )
    .unwrap();
    let out = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("failed to run residc");
    let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    assert_eq!(
        stdout.trim(),
        "equal\ndifferent\naGVsbG8==\nc5e478d59288c841aa530db6845c4c8d962893a001ce4e11a4963873aa98134a",
        "{stdout:?}"
    );
    let _ = std::fs::remove_dir_all(&dir);
}

/// Crypto v4: OS-entropy randomness assembled in Resid.
#[test]
fn run_crypto_randomness() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-rnd-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap();
    std::fs::copy(workspace.join("lib/crypto.resid"), dir.join("crypto.resid")).unwrap();
    let file = dir.join("main.resid");
    std::fs::write(
        &file,
        r#"
import "crypto.resid";
Int main() {
    Str h1 = random_hex(32);
    Str h2 = random_hex(32);
    println(IntToString(str_len(h1)));
    println(IntToString(str_len(h2)));
    if (h1 == h2) {
        println("SAME");
    } else {
        println("DIFFERENT");
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
        .expect("failed to run residc");
    let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    let lines: Vec<&str> = stdout.trim().lines().collect();
    assert_eq!(lines[0], "64", "{stdout:?}");
    assert_eq!(lines[1], "64", "{stdout:?}");
    assert_eq!(lines[2], "DIFFERENT", "{stdout:?}");
    let _ = std::fs::remove_dir_all(&dir);
}

/// List indexing is bounds-checked: out-of-range aborts cleanly instead of
/// reading wild memory (found while debugging SHA-512-in-Resid).
#[test]
fn run_index_oob_aborts_cleanly() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-oob-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("oob.resid");
    std::fs::write(
        &file,
        r#"
Int main() {
    List(Int) xs = [1, 2, 3];
    println(IntToString(xs[5]));
    return 0;
}
"#,
    )
    .unwrap();
    let out = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("failed to run residc");
    let err = String::from_utf8_lossy(&out.stderr).into_owned();
    assert_ne!(out.status.code(), Some(0), "OOB must fail");
    assert!(err.contains("list index out of bounds"), "{err}");
    let _ = std::fs::remove_dir_all(&dir);
}

/// COSE provenance: build signs a COSE_Sign1 trailer; verify accepts it;
/// tampering with the code region is detected as CODE HASH MISMATCH;
/// tampering with the trailer breaks the signature.
#[test]
fn run_cose_provenance_verify_and_tamper() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-cose-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap();
    let keys = workspace.join("keys");
    let have_key = keys.join("resid-ed25519.key").exists();
    if !have_key {
        let out = Command::new(residc_bin())
            .arg("keygen")
            .current_dir(workspace)
            .output()
            .expect("keygen");
        assert_eq!(out.status.code(), Some(0));
    }
    let file = dir.join("main.resid");
    std::fs::write(&file, "Int main() {\n    println(\"ok\");\n    return 0;\n}\n").unwrap();
    let bin = dir.join("cosebin");
    let out = Command::new(residc_bin())
        .arg(&file)
        .arg("build")
        .arg("-o")
        .arg(&bin)
        .current_dir(workspace)
        .output()
        .expect("build");
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    // Clean verify.
    let out = Command::new(residc_bin())
        .arg("verify")
        .arg(&bin)
        .current_dir(workspace)
        .output()
        .expect("verify");
    let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
    assert!(stdout.contains("SIGNATURE OK"), "verify: {stdout}");
    assert_eq!(out.status.code(), Some(0));
    // Tamper with the CODE region (first byte).
    let mut bytes = std::fs::read(&bin).unwrap();
    bytes[0] ^= 0xFF;
    let tampered = dir.join("tampered-code");
    std::fs::write(&tampered, &bytes).unwrap();
    let out = Command::new(residc_bin())
        .arg("verify")
        .arg(&tampered)
        .current_dir(workspace)
        .output()
        .expect("verify tampered");
    let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
    assert!(
        stdout.contains("CODE HASH MISMATCH"),
        "expected hash mismatch, got: {stdout}"
    );
    assert_ne!(out.status.code(), Some(0));
    // Tamper with the TRAILER (flip last byte) -> invalid signature.
    let mut bytes = std::fs::read(&bin).unwrap();
    let n = bytes.len();
    bytes[n - 1] ^= 0x01;
    let tampered = dir.join("tampered-trailer");
    std::fs::write(&tampered, &bytes).unwrap();
    let out = Command::new(residc_bin())
        .arg("verify")
        .arg(&tampered)
        .current_dir(workspace)
        .output()
        .expect("verify tampered trailer");
    let all = format!(
        "{}{}",
        String::from_utf8_lossy(&out.stdout),
        String::from_utf8_lossy(&out.stderr)
    );
    assert!(!all.contains("SIGNATURE OK"), "trailer tamper undetected: {all}");
    let _ = std::fs::remove_dir_all(&dir);
    if !have_key {
        let _ = std::fs::remove_file(keys.join("resid-ed25519.key"));
        let _ = std::fs::remove_file(keys.join("resid-ed25519.pub"));
    }
}

/// Confidential provenance reservation: RESID_PROV_ENCRYPT=1 wraps the
/// payload in COSE_Encrypt0 before signing; verify still authenticates
/// (code hash concealed inside the sealed payload).
#[test]
fn run_encrypt0_provenance_roundtrip() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-enc0-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap();
    let keys = workspace.join("keys");
    let have_key = keys.join("resid-ed25519.key").exists();
    if !have_key {
        Command::new(residc_bin())
            .arg("keygen")
            .current_dir(workspace)
            .output()
            .expect("keygen");
    }
    let file = dir.join("main.resid");
    std::fs::write(&file, "Int main() {\n    println(\"ok\");\n    return 0;\n}\n").unwrap();
    let bin = dir.join("encbin");
    let out = Command::new(residc_bin())
        .arg(&file)
        .arg("build")
        .arg("-o")
        .arg(&bin)
        .env("RESID_PROV_ENCRYPT", "1")
        .env("RESID_PROV_KEY", "ab".repeat(32))
        .current_dir(workspace)
        .output()
        .expect("build");
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    let stderr = String::from_utf8_lossy(&out.stderr).into_owned();
    assert!(stderr.contains("encrypt0+sign1"), "build stderr: {stderr}");
    // Missing key is refused cleanly.
    let out = Command::new(residc_bin())
        .arg(&file)
        .arg("build")
        .arg("-o")
        .arg(&dir.join("nokey"))
        .env("RESID_PROV_ENCRYPT", "1")
        .env_remove("RESID_PROV_KEY")
        .current_dir(workspace)
        .output()
        .expect("build nokey");
    assert_ne!(out.status.code(), Some(0), "missing RESID_PROV_KEY must fail");
    // Verify reports the concealed-payload form and succeeds.
    let out = Command::new(residc_bin())
        .arg("verify")
        .arg(&bin)
        .current_dir(workspace)
        .output()
        .expect("verify");
    let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
    assert!(
        stdout.contains("SIGNATURE OK"),
        "encrypted verify failed: {stdout}"
    );
    let _ = std::fs::remove_dir_all(&dir);
    if !have_key {
        let _ = std::fs::remove_file(keys.join("resid-ed25519.key"));
        let _ = std::fs::remove_file(keys.join("resid-ed25519.pub"));
    }
}

/// Reduction pass: rebuilding an artifact whose source lost a residual
/// (`rt` binding removed) reports the discharged note on stderr.
#[test]
fn run_reduction_reports_discharged_notes() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-red-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap();
    let keys = workspace.join("keys");
    let have_key = keys.join("resid-ed25519.key").exists();
    if !have_key {
        Command::new(residc_bin())
            .arg("keygen")
            .current_dir(workspace)
            .output()
            .expect("keygen");
    }
    let f1 = dir.join("v1.resid");
    std::fs::write(
        &f1,
        "Int main() {\n    rt println(\"hello residual\");\n    return 0;\n}\n",
    )
    .unwrap();
    let bin = dir.join("redbin");
    let out = Command::new(residc_bin())
        .arg(&f1)
        .arg("build")
        .arg("-o")
        .arg(&bin)
        .current_dir(workspace)
        .output()
        .expect("build v1");
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    // Same artifact name, residual removed.
    let f2 = dir.join("v2.resid");
    std::fs::write(&f2, "Int main() {\n    println(\"hello\");\n    return 0;\n}\n").unwrap();
    let out = Command::new(residc_bin())
        .arg(&f2)
        .arg("build")
        .arg("-o")
        .arg(&bin)
        .current_dir(workspace)
        .output()
        .expect("build v2");
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    let stderr = String::from_utf8_lossy(&out.stderr).into_owned();
    assert!(
        stderr.contains("reduction: discharged rt-binding"),
        "expected discharge report, got: {stderr}"
    );
    let _ = std::fs::remove_dir_all(&dir);
    if !have_key {
        let _ = std::fs::remove_file(keys.join("resid-ed25519.key"));
        let _ = std::fs::remove_file(keys.join("resid-ed25519.pub"));
    }
}

/// Pure-Resid HTTP client stack (lib/http.resid) over raw TCP externs:
/// GET request built and response parsed entirely in Resid against a
/// live in-process HTTP/1.1 server.
#[test]
fn run_http_get_in_resid() {
    use std::io::{Read, Write};
    let dir = std::env::temp_dir().join(format!("residc-e2e-http-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap();
    // In-process HTTP/1.1 server.
    let listener = std::net::TcpListener::bind(("127.0.0.1", 0)).unwrap();
    let port = listener.local_addr().unwrap().port();
    std::thread::spawn(move || {
        for conn in listener.incoming() {
            let Ok(mut stream) = conn else { break };
            let mut buf = [0u8; 4096];
            let _ = stream.read(&mut buf);
            let req = String::from_utf8_lossy(&buf);
            let path = req.split_whitespace().nth(1).unwrap_or("/").to_string();
            let (code, body): (&str, &str) = if path == "/hello.txt" {
                ("200 OK", "hello from http.resid\n")
            } else {
                ("404 Not Found", "gone\n")
            };
            let resp = format!(
                "HTTP/1.1 {code}\r\nContent-Type: text/plain\r\nContent-Length: {}\r\nConnection: close\r\n\r\n{}",
                body.len(),
                body
            );
            let _ = stream.write_all(resp.as_bytes());
        }
    });
    // Client program imports the library.
    std::fs::copy(workspace.join("lib/http.resid"), dir.join("http.resid")).unwrap();
    std::fs::copy(workspace.join("lib/crypto.resid"), dir.join("crypto.resid")).ok();
    let file = dir.join("main.resid");
    std::fs::write(
        &file,
        format!(
            r#"
import "http.resid";
Int main() {{
    println(http_get_body("http://127.0.0.1:{port}/hello.txt"));
    println(IntToString(http_get_status("http://127.0.0.1:{port}/missing")));
    return 0;
}}
"#
        ),
    )
    .unwrap();
    let out = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("failed to run residc");
    let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    assert_eq!(
        stdout.trim(),
        "hello from http.resid\n\n404",
        "{stdout:?}"
    );
    let _ = std::fs::remove_dir_all(&dir);
}

/// TCP externs work through BOTH pipelines identically: the Rust pipeline
/// and the stage-2 bootstrap driver produce the same output for a program
/// doing raw-socket HTTP against an in-process server.
#[test]
fn run_tcp_externs_both_pipelines() {
    use std::io::{Read, Write};
    let dir = std::env::temp_dir().join(format!("residc-e2e-tcp2-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap();
    let listener = std::net::TcpListener::bind(("127.0.0.1", 0)).unwrap();
    let port = listener.local_addr().unwrap().port();
    std::thread::spawn(move || {
        for conn in listener.incoming() {
            let Ok(mut stream) = conn else { break };
            let mut buf = [0u8; 4096];
            let _ = stream.read(&mut buf);
            let body = "dual pipeline\n";
            let resp = format!(
                "HTTP/1.1 200 OK\r\nContent-Length: {}\r\nConnection: close\r\n\r\n{}",
                body.len(),
                body
            );
            let _ = stream.write_all(resp.as_bytes());
        }
    });
    let file = dir.join("main.resid");
    std::fs::write(
        &file,
        format!(
            r#"
Int main() {{
    Int fd = resid_tcp_connect("127.0.0.1", {port});
    Str h1 = "GET /x.txt HTTP/1.1\r\n";
    Str h2 = "Host: 127.0.0.1\r\nConnection: close\r\n\r\n";
    Str req = h1 + h2;
    if (!resid_tcp_send(fd, req)) {{ println("send fail"); }}
    Str resp = resid_tcp_recv_all(fd);
    resid_tcp_close(fd);
    println(resp);
    return 0;
}}
"#
        ),
    )
    .unwrap();
    // Rust pipeline.
    let out = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("rust pipeline run");
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    let rust_out = String::from_utf8_lossy(&out.stdout).into_owned();
    assert!(rust_out.contains("dual pipeline"), "{rust_out:?}");
    // Stage-2 driver.
    let bin = dir.join("tcp_drv");
    let out = Command::new(residc_bin())
        .arg(workspace.join("examples/driver.resid"))
        .arg("run")
        .arg(&file)
        .arg("-o")
        .arg(&bin)
        .arg("-rt")
        .arg(workspace.join("crates/residc/resid_rt.c"))
        .current_dir(workspace) // driver looks for keys/ relative to cwd
        .output()
        .expect("driver run");
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    let out = Command::new(&bin).output().expect("stage-2 binary runs");
    let stage2_out = String::from_utf8_lossy(&out.stdout).into_owned();
    // Byte-for-byte agreement between pipelines.
    assert_eq!(rust_out, stage2_out, "{rust_out:?} vs {stage2_out:?}");
    let _ = std::fs::remove_dir_all(&dir);
}

/// Import resolution in the stage-2 bootstrap compiler: a program that
/// imports a library file compiles and runs identically to the Rust
/// pipeline. Also covers trailing commas in multi-line list literals,
/// which the bootstrap parser previously rejected.
#[test]
fn run_stage2_import_resolution() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-imp2-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap();
    // Library with a trailing-comma multi-line list literal.
    std::fs::write(
        dir.join("libtest.resid"),
        "pub List(Int) ktab() {\n    List(Int) k = [\n        1116352408, -2057255420,\n    ];\n    return k;\n}\n",
    )
    .unwrap();
    let file = dir.join("main.resid");
    std::fs::write(
        &file,
        "import \"libtest.resid\";\nInt main() {\n    List(Int) k = ktab();\n    Int sum = k[0] + k[1];
    println(IntToString(sum));\n    return 0;\n}\n",
    )
    .unwrap();
    // Rust pipeline.
    let out = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("rust pipeline");
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    let rust_out = String::from_utf8_lossy(&out.stdout).into_owned();
    assert_eq!(rust_out.trim(), "-940903012", "{rust_out:?}");
    // Stage-2 driver.
    let bin = dir.join("imp_bin");
    let out = Command::new(residc_bin())
        .arg(workspace.join("examples/driver.resid"))
        .arg("run")
        .arg(&file)
        .arg("-o")
        .arg(&bin)
        .arg("-rt")
        .arg(workspace.join("crates/residc/resid_rt.c"))
        .current_dir(workspace)
        .output()
        .expect("driver run");
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    let out = Command::new(&bin).output().expect("stage-2 binary");
    let stage2_out = String::from_utf8_lossy(&out.stdout).into_owned();
    // Byte-for-byte agreement between pipelines.
    assert_eq!(rust_out, stage2_out, "{rust_out:?} vs {stage2_out:?}");
    let _ = std::fs::remove_dir_all(&dir);
}

/// Pure-Resid DER/ASN.1 decoder (lib/der.resid) — x509 foundation.
/// Decodes SEQUENCE { INTEGER 42, OCTET STRING "hi" } and a long-form
/// length element, through BOTH pipelines.
#[test]
fn run_der_parser_in_resid() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-der-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap();
    std::fs::copy(workspace.join("lib/der.resid"), dir.join("der.resid")).unwrap();
    // SEQUENCE(30 05) { INTEGER(02 01) 42, OCTET STRING(04 02) "hi" } then
    // INTEGER with long-form length (02 81 FF ...) truncated marker check:
    // we decode 0x2015 as long-form length carrying value bytes 0x20 0x15
    // -> val_len 0x2015 = 8213.
    let file = dir.join("main.resid");
    std::fs::write(
        &file,
        r#"
import "der.resid";
Int main() {
    List(Int) blob = [0, 48, 5, 2, 1, 42, 4, 2, 104, 105];
    DerTlv seq = der_next(blob, 1);
    println(IntToString(seq.tag));
    println(IntToString(seq.val_len));
    Int ipos = der_content_pos(blob, 1);
    DerTlv intv = der_next(blob, ipos);
    println(IntToString(intv.val_len));
    List(Int) v = der_content(blob, ipos);
    println(IntToString(v[1]));
    List(Int) big = [0, 2, 130, 32, 21, 9, 9];
    DerTlv lf = der_next(big, 1);
    println(IntToString(lf.val_len));
    return 0;
}
"#,
    )
    .unwrap();
    let out = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("rust pipeline");
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    let rust_out = String::from_utf8_lossy(&out.stdout).into_owned();
    assert_eq!(
        rust_out.trim(),
        "48\n5\n1\n42\n8213",
        "{rust_out:?}"
    );
    // Stage-2 driver.
    let bin = dir.join("der_bin");
    let out = Command::new(residc_bin())
        .arg(workspace.join("examples/driver.resid"))
        .arg("run")
        .arg(&file)
        .arg("-o")
        .arg(&bin)
        .arg("-rt")
        .arg(workspace.join("crates/residc/resid_rt.c"))
        .current_dir(workspace)
        .output()
        .expect("driver run");
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    let out = Command::new(&bin).output().expect("stage-2 binary");
    // Agreement between pipelines (resolver may add one trailing newline).
    assert_eq!(rust_out.trim_end(), String::from_utf8_lossy(&out.stdout).trim_end());
    let _ = std::fs::remove_dir_all(&dir);
}

/// Pure-Resid x509 TBS walker (lib/x509.resid over lib/der.resid) — decodes an
/// openssl-generated self-signed certificate (fixed serial 7331, subject
/// C=US/O=Resid/CN=Resid Test CA, sha256WithRSAEncryption) embedded as a
/// seeded byte list. Checks serial, sig-alg OID, SPKI alg OID, issuer and
/// subject RDN strings, and validity times through BOTH pipelines.
#[test]
fn run_x509_in_resid() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-x509-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap();
    std::fs::copy(workspace.join("lib/der.resid"), dir.join("der.resid")).unwrap();
    std::fs::copy(workspace.join("lib/x509.resid"), dir.join("x509.resid")).unwrap();
    let list = include_str!("fixtures/x509_cert_list.txt");
    let file = dir.join("main.resid");
    std::fs::write(
        &file,
        format!(
            r#"
import "x509.resid";
Int main() {{
    List(Int) cert = {list};
    println("serial=" + IntToString(x509_serial(cert)));
    println("sigalg=" + x509_sigalg_oid(cert));
    println("spki=" + x509_spki_alg_oid(cert));
    println("issuer=" + x509_issuer_str(cert));
    println("subject=" + x509_subject_str(cert));
    println("nb=" + x509_not_before(cert));
    println("na=" + x509_not_after(cert));
    return 0;
}}
"#
        ),
    )
    .unwrap();
    let expected = "serial=7331\n\
                    sigalg=1.2.840.113549.1.1.11\n\
                    spki=1.2.840.113549.1.1.1\n\
                    issuer=C=US,O=Resid,CN=Resid Test CA\n\
                    subject=C=US,O=Resid,CN=Resid Test CA\n\
                    nb=260823162426Z\n\
                    na=260922162426Z";
    // Stage-1 (Rust pipeline).
    let out = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("rust pipeline");
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    let rust_out = String::from_utf8_lossy(&out.stdout).into_owned();
    assert_eq!(rust_out.trim(), expected, "{rust_out:?}");
    // Stage-2 (bootstrap driver pipeline).
    let bin = dir.join("x509_bin");
    let out = Command::new(residc_bin())
        .arg(workspace.join("examples/driver.resid"))
        .arg("run")
        .arg(&file)
        .arg("-o")
        .arg(&bin)
        .arg("-rt")
        .arg(workspace.join("crates/residc/resid_rt.c"))
        .current_dir(workspace)
        .output()
        .expect("driver run");
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    let out = Command::new(&bin).output().expect("stage-2 binary");
    let stage2_out = String::from_utf8_lossy(&out.stdout).into_owned();
    if stage2_out.trim() != expected {
        // preserve forensics: the suspicious binary + raw output bytes
        let _ = std::fs::copy(&bin, "/tmp/opencode/ghost/fail_bin");
        std::fs::write("/tmp/opencode/ghost/fail_out.raw", &out.stdout).unwrap();
        println!("FORENSICS saved; stdout len={} expected len={}", out.stdout.len(), expected.len());
    }
    assert_eq!(stage2_out.trim(), expected, "{stage2_out:?}");
    assert_eq!(rust_out.trim_end(), stage2_out.trim_end());
    let _ = std::fs::remove_dir_all(&dir);
}

/// Pure-Resid RSA PKCS#1v1.5 SHA-256 signature verification (lib/rsa.resid
/// bignum + Montgomery reduction over lib/x509.resid + lib/crypto.resid).
/// The self-signed certificate from the x509 fixture verifies its own
/// tbsCertificate signature with its embedded RSA-2048 key, through BOTH
/// pipelines. Ground truth computed independently in Python:
///   sha256(tbs) starts 234 95 53 43; sig^65537 mod n == expected EM.
#[test]
fn run_rsa_pkcs1_verify_in_resid() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-rsa-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap();
    for f in ["der.resid", "x509.resid", "crypto.resid", "rsa.resid"] {
        std::fs::copy(workspace.join("lib").join(f), dir.join(f)).unwrap();
    }
    let cert = include_str!("fixtures/x509_cert_list.txt");
    let file = dir.join("main.resid");
    std::fs::write(
        &file,
        format!(
            r#"
import "crypto.resid";
import "x509.resid";
import "rsa.resid";

Int main() {{
    List(Int) cert = {cert};
    Int tbs = x509_tbs_pos(cert);
    DerTlv tv = der_next(cert, tbs);
    Int tbody = tbs + tv.hdr_len;
    Int tend = tbody + tv.val_len;
    Int tstop = tend - 1;
    List(Int) tb = der_slice_seeded(cert, tbs, tstop);
    List(Int) digest = sha256_bytes(tb);
    Int d1 = digest[1];
    Int d2 = digest[2];
    Int d3 = digest[3];
    Int d4 = digest[4];
    println("digest=" + IntToString(d1) + " " + IntToString(d2) + " " + IntToString(d3) + " " + IntToString(d4));
    Int p1 = x509_skip_tlv(cert, tbs);
    Int p2 = x509_skip_tlv(cert, p1);
    Int bsc = der_content_pos(cert, p2);
    Int sb = bsc + 1;
    Int se = sb + 255;
    List(Int) sigb = der_slice_seeded(cert, sb, se);
    Int sp = x509_spki_pos(cert);
    Int algp = der_content_pos(cert, sp);
    Int bitp = x509_skip_tlv(cert, algp);
    Int kseq = der_content_pos(cert, bitp) + 1;
    Int npos = der_content_pos(cert, kseq);
    Int epos = x509_skip_tlv(cert, npos);
    List(Int) nc = der_content(cert, npos);
    Int ncl = nc.len() - 1;
    List(Int) nb = der_slice_seeded(nc, 2, ncl);
    Int ev = der_int_value(cert, epos);
    Int w = 128;
    List(Int) nl = bn_from_be(nb, w);
    List(Int) sl = bn_from_be(sigb, w);
    List(Int) rec = bn_montexp(sl, ev, nl, w);
    List(Int) em = pkcs1_em_sha256(digest, 256);
    List(Int) eml = bn_from_be(em, w);
    Int c = bn_cmp(rec, eml, w);
    if (c == 0) {{
        println("signature VALID");
    }} else {{
        println("signature INVALID");
    }}
    return 0;
}}
"#
        ),
    )
    .unwrap();
    let expected = "digest=234 95 53 43\nsignature VALID";
    // Deep tail recursions (4096-frame modexp loops) need a roomy stack.
    let unlimit = |prog: &str, args: &[String]| {
        let mut cmdline = format!("ulimit -s unlimited; exec {}", prog);
        for a in args {
            cmdline.push_str(&format!(" '{}'", a));
        }
        let mut sh = Command::new("sh");
        sh.arg("-c").arg(cmdline);
        sh
    };
    // Stage-1 (Rust pipeline).
    let out = unlimit(residc_bin(), &[file.to_string_lossy().into_owned(), "run".into()])
        .output()
        .expect("rust pipeline");
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    let rust_out = String::from_utf8_lossy(&out.stdout).into_owned();
    assert_eq!(rust_out.trim(), expected, "{rust_out:?}");
    // Stage-2 (bootstrap driver pipeline).
    let bin = dir.join("rsa_bin");
    let drv_args = vec![
        workspace.join("examples/driver.resid").to_string_lossy().into_owned(),
        "run".into(),
        file.to_string_lossy().into_owned(),
        "-o".into(),
        bin.to_string_lossy().into_owned(),
        "-rt".into(),
        workspace.join("crates/residc/resid_rt.c").to_string_lossy().into_owned(),
    ];
    let mut drv = unlimit(residc_bin(), &drv_args);
    let out = drv.current_dir(workspace).output().expect("driver run");
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    let out = unlimit(&bin.to_string_lossy(), &[]).output().expect("stage-2 binary");
    let stage2_out = String::from_utf8_lossy(&out.stdout).into_owned();
    assert_eq!(stage2_out.trim(), expected, "{stage2_out:?}");
    let _ = std::fs::remove_dir_all(&dir);
}

/// Pure-Resid NIST P-256 ECDSA verification (lib/ec256.resid: Int(256)
/// field elements, Int(512) products reduced by binary long division).
/// The ECDSA self-signed certificate fixture verifies its own
/// tbsCertificate signature through the Rust pipeline. Ground truth
/// computed independently in Python (pure-Python EC point arithmetic):
/// sha256(tbs) starts 152 153 152 159; x(u1*G + u2*Q) mod N == r.
///
/// Known issue: the bootstrap driver (stage-2) currently rejects the
/// merged source with "function `=` is already defined" — the legacy
/// signature collector mis-scans Int(256)/Int(512)-typed libraries.
#[test]
fn run_ecdsa_p256_verify_in_resid() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-ec-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap();
    for f in ["der.resid", "x509.resid", "crypto.resid", "rsa.resid", "ec256.resid", "chain.resid"] {
        std::fs::copy(workspace.join("lib").join(f), dir.join(f)).unwrap();
    }
    let cert = include_str!("fixtures/ecdsa_cert_list.txt");
    let file = dir.join("main.resid");
    std::fs::write(
        &file,
        format!(
            r#"
import "chain.resid";
import "crypto.resid";
import "x509.resid";
import "rsa.resid";
import "ec256.resid";

pub Int low16256(Int(256) v) {{
    Int(256) m = 65535;
    return (Int) (v & m);
}}

pub Int(256) be_acc(List(Int) bytes, Int i, Int(256) acc) {{
    if (i > 32) {{ return acc; }}
    Int byte = bytes[i];
    Int(256) bv = (Int(256)) byte;
    Int(256) acc8 = acc * 256;
    Int(256) acc2 = acc8 + bv;
    Int ni = i + 1;
    return be_acc(bytes, ni, acc2);
}}

Int main() {{
    List(Int) cert = {cert};
    Int tbs = x509_tbs_pos(cert);
    DerTlv tv = der_next(cert, tbs);
    Int tbody = tbs + tv.hdr_len;
    Int tend = tbody + tv.val_len;
    Int tstop = tend - 1;
    List(Int) tb = der_slice_seeded(cert, tbs, tstop);
    List(Int) digest = sha256_bytes(tb);
    println("d1=" + IntToString(digest[1]));
    Int p1 = x509_skip_tlv(cert, tbs);
    Int p2 = x509_skip_tlv(cert, p1);
    DerTlv btv = der_next(cert, p2);
    Int bsc = der_content_pos(cert, p2);
    Int sb0 = bsc + 1;
    Int sstop = sb0 + btv.val_len - 2;
    List(Int) sigb = der_slice_seeded(cert, sb0, sstop);
    Int seqc = der_content_pos(sigb, 1);
    List(Int) rb = der_content(sigb, seqc);
    Int spos = x509_skip_tlv(sigb, seqc);
    List(Int) sb2v = der_content(sigb, spos);
    Int sp = x509_spki_pos(cert);
    Int algp = der_content_pos(cert, sp);
    Int bitp = x509_skip_tlv(cert, algp);
    Int ksc = der_content_pos(cert, bitp);
    Int ks2 = ksc + 1;
    Int kx1 = ks2 + 1;
    Int ky0 = kx1 + 31;
    Int ky1 = kx1 + 32;
    Int ky2 = ky1 + 31;
    List(Int) xb = der_slice_seeded(cert, kx1, ky0);
    List(Int) yb = der_slice_seeded(cert, ky1, ky2);
    Int(256) eint = be_acc(digest, 1, 0);
    Int(256) rvv = ec_from_be(rb);
    Int(256) svv = ec_from_be(sb2v);
    Int(256) qx = be_acc(xb, 1, 0);
    Int(256) qy = be_acc(yb, 1, 0);
    println("in=" + IntToString(low16256(rvv)) + " " + IntToString(low16256(qx)));
    List(Int) h1 = [0, 119, 119, 119, 46, 114, 101, 115, 105, 100, 46, 116, 101, 115, 116];
    Bool m1 = san_has_match(cert, h1);
    List(Int) h2 = [0, 102, 111, 111, 46, 114, 101, 115, 105, 100, 46, 116, 101, 115, 116];
    Bool m2 = san_has_match(cert, h2);
    List(Int) h3 = [0, 97, 112, 105, 46, 111, 116, 104, 101, 114, 46, 99, 111, 109];
    Bool m3 = san_has_match(cert, h3);
    println("san=" + BoolToString(m1) + BoolToString(m2) + BoolToString(m3));
    Int now_ok = 20260924000000;
    Int past = 20200101000000;
    Bool vnow = x509_valid_now(cert, now_ok);
    Bool vpast = x509_valid_now(cert, past);
    println("valid=" + BoolToString(vnow) + BoolToString(vpast));
    Int(256) vx = ecdsa_vx(eint, rvv, svv, qx, qy);
    println("vxlow=" + IntToString(low16256(vx)));
    return 0;
}}
"#
        ),
    )
    .unwrap();
    // ec_cert.der carries no SAN extension and expired 2026-09-22, so
    // san_has_match is false for every host and validity is false at
    // now=20260924 — both are CORRECT results (openssl-verified cert).
    let expected = "d1=152\nin=65294 7421\nsan=falsefalsefalse\nvalid=falsefalse\nvxlow=65294";
    let out = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("rust pipeline");
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    let rust_out = String::from_utf8_lossy(&out.stdout).into_owned();
    assert_eq!(rust_out.trim(), expected, "{rust_out:?}");
    let _ = std::fs::remove_dir_all(&dir);
}


/// Chain fixture positive case: SAN matching (exact, wildcard, negative)
/// and validity windows for the leaf certificate (SAN DNS:www.resid.test
/// + DNS:*.resid.test; valid 2026-08-23 .. 2027-08-23). Ground truth via
/// openssl x509 -text and direct date comparison.
#[test]
fn run_chain_san_validity_in_resid() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-chain-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap();
    for f in ["der.resid", "x509.resid", "crypto.resid", "rsa.resid", "ec256.resid", "chain.resid"] {
        std::fs::copy(workspace.join("lib").join(f), dir.join(f)).unwrap();
    }
    let cert = include_str!("fixtures/chain_leaf_list.txt");
    let root = include_str!("fixtures/chain_root_list.txt");
    let file = dir.join("main.resid");
    std::fs::write(
        &file,
        format!(
            r#"
import "chain.resid";
Int main() {{
    List(Int) cert = {cert};
    List(Int) rootc = {root};
    List(Int) h1 = [0, 119, 119, 119, 46, 114, 101, 115, 105, 100, 46, 116, 101, 115, 116];
    Bool m1 = san_has_match(cert, h1);
    List(Int) h2 = [0, 102, 111, 111, 46, 114, 101, 115, 105, 100, 46, 116, 101, 115, 116];
    Bool m2 = san_has_match(cert, h2);
    List(Int) h3 = [0, 97, 112, 105, 46, 111, 116, 104, 101, 114, 46, 99, 111, 109];
    Bool m3 = san_has_match(cert, h3);
    println("san=" + BoolToString(m1) + BoolToString(m2) + BoolToString(m3));
    Int now_ok = 20260924000000;
    Int past = 20200101000000;
    Int future = 20350101000000;
    Bool vnow = x509_valid_now(cert, now_ok);
    Bool vpast = x509_valid_now(cert, past);
    Bool vfuture = x509_valid_now(cert, future);
    println("valid=" + BoolToString(vnow) + BoolToString(vpast) + BoolToString(vfuture));
    Bool cv = chain_verify(cert, rootc, now_ok);
    println("chain=" + BoolToString(cv));
    return 0;
}}
"#
        ),
    )
    .unwrap();
    let expected = "san=truetruefalse\nvalid=truefalsefalse\nchain=true";
    let out = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("rust pipeline");
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    let rust_out = String::from_utf8_lossy(&out.stdout).into_owned();
    assert_eq!(rust_out.trim(), expected, "{rust_out:?}");
    let _ = std::fs::remove_dir_all(&dir);
}

/// LIVE end-to-end TLS 1.3: examples/tls_client.resid performs a full
/// handshake (ClientHello, X25519, key schedule, server Finished verify,
/// ECDSA-P256 CertificateVerify, client Finished) plus an HTTP GET against
/// a real `openssl s_server`. Skipped when openssl is unavailable.
#[test]
fn run_tls13_live_openssl_in_resid() {
    let openssl = match which_openssl() {
        Some(p) => p,
        None => { eprintln!("skipping: openssl not found"); return; }
    };
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent().unwrap().parent().unwrap();
    let dir = std::env::temp_dir().join(format!("residc-e2e-tlslive-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    for f in ["tls_client.resid"] {
        std::fs::copy(workspace.join("examples").join(f), dir.join(f)).unwrap();
    }
    for f in ["crypto.resid","aesgcm.resid","ed25519.resid","x25519.resid","tls.resid","tlsmsg.resid","chain.resid","rsa.resid","ec256.resid","der.resid","x509.resid","chacha.resid"] {
        std::fs::copy(workspace.join("lib").join(f), dir.join(f)).unwrap();
    }
    // pick a port
    let base_port = 18443u16 + (std::process::id() % 500) as u16;
    let mut port = base_port;
    // cert/key — exercise BOTH CertificateVerify algorithms
    for keyalg in ["ec", "rsa"] {
    let mut gen_args = vec!["req".to_string(),"-x509".to_string(),"-newkey".to_string()];
    let popt = if keyalg == "rsa" { "rsa_keygen_bits:2048" } else { "ec_paramgen_curve:prime256v1" };
    gen_args.push(keyalg.to_string());
    gen_args.push("-pkeyopt".to_string());
    gen_args.push(popt.to_string());
    gen_args.push("-keyout".to_string()); gen_args.push(dir.join("k.pem").to_str().unwrap().to_string());
    gen_args.push("-out".to_string()); gen_args.push(dir.join("c.pem").to_str().unwrap().to_string());
    gen_args.push("-subj".to_string()); gen_args.push("/CN=localhost".to_string());
    gen_args.push("-addext".to_string()); gen_args.push("subjectAltName=DNS:localhost".to_string());
    gen_args.push("-days".to_string()); gen_args.push("30".to_string());
    gen_args.push("-nodes".to_string());
    let gen_out = Command::new(&openssl).args(&gen_args)
        .output().expect("failed to run openssl req");
    assert!(gen_out.status.success(), "{}", String::from_utf8_lossy(&gen_out.stderr));
    let der = Command::new(&openssl).args(["x509","-in", dir.join("c.pem").to_str().unwrap(),"-outform","der"])
        .output().unwrap();
    let certhex: String = der.stdout.iter().map(|b| format!("{:02x}", b)).collect();

    // pick a port
    let mut server = Command::new(&openssl)
        .args(["s_server","-tls1_3","-accept",&format!("{}",port),
               "-cert",dir.join("c.pem").to_str().unwrap(),
               "-key",dir.join("k.pem").to_str().unwrap(),"-www"])
        .stdout(std::process::Stdio::null())
        .stderr(std::process::Stdio::null())
        .spawn()
        .expect("failed to spawn s_server");
    std::thread::sleep(std::time::Duration::from_millis(1200));

    let client = dir.join("tls_client.resid");
    let out = Command::new(residc_bin())
        .arg(&client).arg("run")
        .arg("localhost").arg(port.to_string()).arg(&certhex).arg("")
        .output();
    let _ = server.kill();
    let out = out.expect("client run failed");
    let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
    assert!(stdout.contains("REPLY:"), "no HTTP reply ({keyalg}): stdout={stdout:?} stderr={}", String::from_utf8_lossy(&out.stderr));
    }

    // Negative: a cert with NO SAN must fail validation (CERT-FAIL).
    std::fs::remove_file(dir.join("c.pem")).unwrap();
    let gen_out = Command::new(&openssl).args(["req","-x509","-newkey","ec",
        "-pkeyopt","ec_paramgen_curve:prime256v1","-keyout", dir.join("k.pem").to_str().unwrap(),
        "-out", dir.join("c.pem").to_str().unwrap(),
        "-subj","/CN=otherhost","-days","30","-nodes"])
        .output().expect("failed to run openssl req");
    assert!(gen_out.status.success(), "{}", String::from_utf8_lossy(&gen_out.stderr));
    let der = Command::new(&openssl).args(["x509","-in", dir.join("c.pem").to_str().unwrap(),"-outform","der"])
        .output().unwrap();
    let certhex: String = der.stdout.iter().map(|b| format!("{:02x}", b)).collect();
    let port = base_port + 1;
    let mut server = Command::new(&openssl)
        .args(["s_server","-tls1_3","-accept",&format!("{}",port),
               "-cert",dir.join("c.pem").to_str().unwrap(),
               "-key",dir.join("k.pem").to_str().unwrap(),"-www"])
        .stdout(std::process::Stdio::null())
        .stderr(std::process::Stdio::null())
        .spawn()
        .expect("failed to spawn s_server");
    std::thread::sleep(std::time::Duration::from_millis(1200));
    let out = Command::new(residc_bin())
        .arg(dir.join("tls_client.resid")).arg("run")
        .arg("localhost").arg(port.to_string()).arg(&certhex).arg("")
        .output()
        .expect("client run failed");
    let _ = server.kill();
    let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
    assert!(stdout.contains("CERT-FAIL"), "expected CERT-FAIL: {stdout:?}");
    let _ = std::fs::remove_dir_all(&dir);
}

fn which_openssl() -> Option<std::path::PathBuf> {
    for p in ["/usr/bin/openssl", "/bin/openssl", "/usr/local/bin/openssl"] {
        if std::path::Path::new(p).exists() { return Some(std::path::PathBuf::from(p)); }
    }
    None
}

/// HTTP/1.1 client: Content-Length bodies, chunked transfer decoding and
/// keep-alive (two requests over one connection) against a real
/// python http.server peer. Skipped when python3 is unavailable.
#[test]
fn run_http11_client_in_resid() {
    let python = match which_python() {
        Some(p) => p,
        None => { eprintln!("skipping: python3 not found"); return; }
    };
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent().unwrap().parent().unwrap();
    let dir = std::env::temp_dir().join(format!("residc-e2e-http11-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    for f in ["http.resid", "crypto.resid"] {
        std::fs::copy(workspace.join("lib").join(f), dir.join(f)).unwrap();
    }
    let port = 19200u16 + (std::process::id() % 500) as u16;
    std::fs::write(dir.join("srv.py"), format!(r#"
import http.server, socketserver
class H(http.server.BaseHTTPRequestHandler):
    protocol_version = "HTTP/1.1"
    def log_message(self,*a): pass
    def do_GET(self):
        if self.path == "/cl":
            body=b"hello-content-length-world"
            self.send_response(200); self.send_header("Content-Length",str(len(body)))
            self.end_headers(); self.wfile.write(body)
        elif self.path == "/chunked":
            self.send_response(200); self.send_header("Transfer-Encoding","chunked")
            self.end_headers()
            for part in [b"chunk-one-", b"chunk-two!", b"done"]:
                self.wfile.write(hex(len(part))[2:].encode()+b"\r\n"+part+b"\r\n")
            self.wfile.write(b"0\r\n\r\n")
        else:
            self.send_response(404); self.send_header("Content-Length","0"); self.end_headers()
socketserver.TCPServer.allow_reuse_address=True
s=socketserver.ThreadingTCPServer(("127.0.0.1",{port}),H)
s.serve_forever()
"#)).unwrap();
    let mut server = Command::new(&python).arg(dir.join("srv.py"))
        .stdout(std::process::Stdio::null())
        .stderr(std::process::Stdio::null())
        .spawn()
        .expect("failed to spawn test server");
    std::thread::sleep(std::time::Duration::from_millis(800));
    let file = dir.join("main.resid");
    std::fs::write(&file, format!(r#"
import "http.resid";
Int main() {{
    Int fd = resid_tcp_connect("127.0.0.1", {port});
    if (fd < 0) {{ println("CONNECT-FAIL"); return 1; }}
    HttpResponse r1 = http_call(fd, "GET", "/cl", "127.0.0.1:{port}", "");
    println("R1=" + IntToString(r1.status) + "|" + r1.body);
    HttpResponse r2 = http_call(fd, "GET", "/chunked", "127.0.0.1:{port}", "");
    println("R2=" + IntToString(r2.status) + "|" + r2.body);
    HttpResponse r3 = http_get("127.0.0.1", {port}, "/nope");
    println("R3=" + IntToString(r3.status));
    resid_tcp_close(fd);
    return 0;
}}
"#)).unwrap();
    let out = Command::new(residc_bin()).arg(&file).arg("run").output()
        .expect("client run failed");
    let _ = server.kill();
    let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
    let _ = std::fs::remove_dir_all(&dir);
    assert!(stdout.contains("R1=200|hello-content-length-world"), "{stdout}");
    assert!(stdout.contains("R2=200|chunk-one-chunk-two!done"), "{stdout}");
    assert!(stdout.contains("R3=404"), "{stdout}");
}

fn which_python() -> Option<std::path::PathBuf> {
    for p in ["/usr/bin/python3", "/bin/python3", "/usr/local/bin/python3"] {
        if std::path::Path::new(p).exists() { return Some(std::path::PathBuf::from(p)); }
    }
    None
}

/// HTTP/2 framing + HPACK (lib/h2.resid) — frame header decode/encode,
/// HPACK integer coding, static/dynamic tables, indexed + literal
/// representations, validated against RFC 7541 C.3-style vectors
/// cross-checked with the python `hpack` library. Both pipelines.
#[test]
fn run_h2_hpack_in_resid() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-h2-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap();
    std::fs::copy(workspace.join("lib/h2.resid"), dir.join("h2.resid")).unwrap();
    std::fs::copy(workspace.join("lib/crypto.resid"), dir.join("crypto.resid")).unwrap();
    std::fs::copy(workspace.join("lib/aesgcm.resid"), dir.join("aesgcm.resid")).unwrap();
    let file = dir.join("main.resid");
    std::fs::write(
        &file,
        r#"
import "h2.resid";

Int main() {
    // Frame header: SETTINGS len=12 stream 263.
    List(Int) f = [0, 0, 0, 12, 4, 0, 0, 0, 1, 7];
    H2FrameHdr h = h2_frame_hdr(f, 1);
    println("hdr=" + IntToString(h.length) + "," + IntToString(h.stype) + "," + IntToString(h.sid));
    // HPACK integers (RFC 7541 C.1): 10 with 5-bit prefix; 1337 multi-byte.
    List(Int) i1 = [0, 10];
    HpInt r1 = hp_read_int(i1, 1, 10, 31);
    List(Int) i2 = [0, 31, 154, 10];
    HpInt r2 = hp_read_int(i2, 1, 31, 31);
    println("int=" + IntToString(r1.val) + " " + IntToString(r2.val));
    // C.3.1 block.
    List(Int) b1 = [0, 130, 134, 132, 65, 15, 119, 119, 119, 46, 101, 120, 97, 109, 112, 108, 101, 46, 99, 111, 109];
    Int e1 = b1.len() - 1;
    HpBlock r3 = hp_decode_block(b1, 1, e1, [""], [HpField { name: "", value: "" }]);
    List(HpField) fs1 = r3.fields;
    HpField a1 = fs1[1];
    HpField a4 = fs1[4];
    println("b1=" + a1.name + "|" + a1.value + " " + a4.name + "|" + a4.value);
    // C.3.2 block: dynamic index 62 must resolve through r3's table.
    List(Int) b2 = [0, 130, 134, 190, 88, 8, 110, 111, 45, 99, 97, 99, 104, 101];
    Int e2 = b2.len() - 1;
    List(Str) dyn1 = r3.dyn;
    HpBlock r4 = hp_decode_block(b2, 1, e2, dyn1, [HpField { name: "", value: "" }]);
    List(HpField) fs2 = r4.fields;
    HpField a5 = fs2[3];
    HpField a6 = fs2[4];
    println("b2=" + a5.name + "|" + a5.value + " " + a6.name + "|" + a6.value);
    // Literal without indexing, new name.
    List(Int) b3 = [0, 0, 3, 102, 111, 111, 3, 98, 97, 114];
    Int e3 = b3.len() - 1;
    HpBlock r5 = hp_decode_block(b3, 1, e3, [""], [HpField { name: "", value: "" }]);
    List(HpField) fs3 = r5.fields;
    HpField a7 = fs3[1];
    println("b3=" + a7.name + "|" + a7.value);
    // Huffman string literals (RFC 7541 Appendix B codes).
    List(Int) h1 = [0, 64, 136, 37, 168, 73, 233, 91, 169, 125, 127, 137, 37, 168, 73, 233, 90, 114, 142, 66, 217];
    Int eh1 = h1.len() - 1;
    HpBlock rh = hp_decode_block(h1, 1, eh1, [""], [HpField { name: "", value: "" }]);
    List(HpField) fsh = rh.fields;
    HpField ah = fsh[1];
    println("huf=" + ah.name + "|" + ah.value);
    List(Int) h2b = [0, 129, 31];
    HpStr sh2 = hp_read_str(h2b, 1);
    println("huf1=" + sh2.s);
    // Never-indexed literal, indexed name via multi-byte integer (28).
    List(Int) b4 = [0, 31, 13, 2, 55, 55];
    Int e4 = b4.len() - 1;
    HpBlock r6 = hp_decode_block(b4, 1, e4, [""], [HpField { name: "", value: "" }]);
    List(HpField) fs4 = r6.fields;
    HpField a8 = fs4[1];
    println("b4=" + a8.name + "|" + a8.value);
    return 0;
}
"#,
    )
    .unwrap();
    let expected = "hdr=12,4,263\nint=10 1337\nb1=:method|GET :authority|www.example.com\nb2=:authority|www.example.com cache-control|no-cache\nb3=foo|bar\nhuf=custom-key|custom-header\nhuf1=a\nb4=content-length|77";
    // Huffman decoding recurses deeply; give both pipelines room.
    let unlimit = |prog: &str, args: &[String]| {
        let mut cmdline = format!("ulimit -s unlimited; exec {}", prog);
        for a in args {
            cmdline.push_str(&format!(" '{}'", a));
        }
        let mut sh = Command::new("sh");
        sh.arg("-c").arg(cmdline);
        sh
    };
    // Stage-1 (Rust pipeline).
    let out = unlimit(residc_bin(), &[file.to_string_lossy().into_owned(), "run".into()])
        .output()
        .expect("rust pipeline");
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    let rust_out = String::from_utf8_lossy(&out.stdout).into_owned();
    assert_eq!(rust_out.trim(), expected, "{rust_out:?}");
    // Stage-2 (bootstrap driver pipeline).
    let bin = dir.join("h2_bin");
    let drv_args = vec![
        workspace.join("examples/driver.resid").to_string_lossy().into_owned(),
        "run".into(),
        file.to_string_lossy().into_owned(),
        "-o".into(),
        bin.to_string_lossy().into_owned(),
        "-rt".into(),
        workspace.join("crates/residc/resid_rt.c").to_string_lossy().into_owned(),
    ];
    let out = unlimit(residc_bin(), &drv_args).current_dir(workspace).output().expect("driver run");
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    let out = unlimit(&bin.to_string_lossy(), &[]).output().expect("stage-2 binary");
    assert_eq!(
        String::from_utf8_lossy(&out.stdout).trim_end(),
        expected,
        "{:?}",
        String::from_utf8_lossy(&out.stdout)
    );
    let _ = std::fs::remove_dir_all(&dir);
}

/// LIVE HTTP/2 over TLS 1.3: examples/h2_client.resid negotiates ALPN h2,
/// completes the handshake, sends the connection preface + SETTINGS, then
/// issues a GET on stream 1 and decodes the response HEADERS (HPACK incl.
/// Huffman) and DATA. Server = tools/h2_server.py (python hyper-h2).
/// Skipped when python3 or the h2 package is unavailable.
#[test]
fn run_h2_live_request_in_resid() {
    let py = match which_python() {
        Some(p) => p,
        None => { eprintln!("skipping: python3 not found"); return; }
    };
    // h2 module check
    let chk = Command::new(&py).args(["-c", "import h2"]).output().expect("python check");
    if !chk.status.success() {
        eprintln!("skipping: python h2 module unavailable");
        return;
    }
    let openssl = match which_openssl() {
        Some(p) => p,
        None => { eprintln!("skipping: openssl not found"); return; }
    };
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent().unwrap().parent().unwrap();
    let dir = std::env::temp_dir().join(format!("residc-e2e-h2live-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    for f in ["h2_client.resid"] {
        std::fs::copy(workspace.join("examples").join(f), dir.join(f)).unwrap();
    }
    for f in ["tlsmsg.resid","tls.resid","crypto.resid","aesgcm.resid","x25519.resid",
              "chain.resid","h2.resid","rsa.resid","der.resid","x509.resid",
              "ec256.resid","ed25519.resid"] {
        std::fs::copy(workspace.join("lib").join(f), dir.join(f)).unwrap();
    }
    let gen_out = Command::new(&openssl).args(["req","-x509","-newkey","ec",
        "-pkeyopt","ec_paramgen_curve:prime256v1","-keyout", dir.join("k.pem").to_str().unwrap(),
        "-out", dir.join("c.pem").to_str().unwrap(),
        "-subj","/CN=localhost","-days","30","-nodes",
        "-addext","subjectAltName=DNS:localhost"])
        .output().expect("openssl req");
    assert!(gen_out.status.success(), "{}", String::from_utf8_lossy(&gen_out.stderr));
    let der = Command::new(&openssl).args(["x509","-in", dir.join("c.pem").to_str().unwrap(),
        "-outform","der"]).output().unwrap();
    let certhex: String = der.stdout.iter().map(|b| format!("{:02x}", b)).collect();

    let base = 19900u16 + (std::process::id() % 400) as u16;
    let port = base;
    let mut server = Command::new(&py)
        .arg(workspace.join("tools/h2_server.py"))
        .arg(port.to_string())
        .arg(dir.join("c.pem").to_str().unwrap())
        .arg(dir.join("k.pem").to_str().unwrap())
        .stdout(std::process::Stdio::null())
        .stderr(std::process::Stdio::null())
        .spawn()
        .expect("failed to spawn h2 server");
    std::thread::sleep(std::time::Duration::from_millis(1500));

    let client = dir.join("h2_client.resid");
    let out = Command::new(residc_bin())
        .arg(&client).arg("run")
        .arg("localhost").arg(port.to_string()).arg(&certhex).arg("")
        .output();
    let _ = server.kill();
    let out = out.expect("client run failed");
    let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
    assert!(stdout.contains("STATUS=200"), "no 200 ({stdout:?}) stderr={}",
            String::from_utf8_lossy(&out.stderr));
    assert!(stdout.contains("BODY=hello from resid h2"), "no body ({stdout:?})");
    let _ = std::fs::remove_dir_all(&dir);
}

/// Regression pin for two previously-documented "compiler bugs" that turned
/// out not to be codegen defects:
///   1. a bare `.len()` value passed as an `Int` argument (direct, nested,
///      as a recursion bound, and on a callee's return value);
///   2. a cross-module recursive list builder using the concat-accumulator
///      shape (`lib/h2.resid`'s h2_cat / der_slice_acc pattern).
/// Both shapes must compile AND produce correct values through the Rust
/// pipeline and the stage-2 bootstrap driver pipeline.
#[test]
fn len_arg_and_cross_module_recursive_list_builder() {
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap();
    let dir = std::env::temp_dir().join(format!("residc-e2e-lenarg-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    std::fs::write(
        dir.join("listlib.resid"),
        r#"
pub List(Int) cat_acc(List(Int) b, Int start, Int last, Int i, List(Int) acc) {
    if (i > last) { return acc; }
    Int bv = b[i];
    List(Int) acc2 = acc.concat([bv]);
    Int ni = i + 1;
    return cat_acc(b, start, last, ni, acc2);
}

pub List(Int) cat(List(Int) a, List(Int) b) {
    Int last = b.len() - 1;
    return cat_acc(b, 1, last, 1, a);
}

pub Int probe(Int n, Int tag) {
    if (n > 100) { return 1; }
    return 2;
}
"#,
    )
    .unwrap();
    let file = dir.join("main.resid");
    std::fs::write(
        &file,
        r#"
import "listlib.resid";

List(Int) mk() {
    return [1, 2, 3, 4];
}

Int use_id(Int n) {
    return n;
}

Int use_pair(Int a, Int b) {
    return a * 10 + b;
}

List(Int) grow(List(Int) acc, Int k) {
    if (k == 0) { return acc; }
    List(Int) acc2 = acc.concat([48 + k]);
    Int nk = k - 1;
    return grow(acc2, nk);
}

Int main() {
    List(Int) xs = [5, 6, 7];
    // Bare .len() as an Int argument, several positions.
    println("p1=" + IntToString(probe(xs.len(), 0)));
    println("p2=" + IntToString(use_id(mk().len())));
    println("p3=" + IntToString(use_pair(mk().len(), xs.len())));
    println("p4=" + IntToString(probe(str_len("hello"), 1)));
    Str s = "abcd";
    println("p5=" + IntToString(use_id(str_len(s))));
    // Bare .len() as a recursion bound.
    println("r=" + IntToString(grow([0], xs.len()).len()));
    // Cross-module recursive list builder.
    List(Int) a = [0, 1, 2];
    List(Int) b = [0, 3, 4];
    List(Int) c = cat(a, b);
    println("c=" + IntToString(c.len()) + IntToString(c[1]) + IntToString(c[2]) + IntToString(c[3]) + IntToString(c[4]));
    return 0;
}
"#,
    )
    .unwrap();
    let expected = "p1=2\np2=4\np3=43\np4=2\np5=4\nr=4\nc=51234";

    let unlimit = |prog: &str, args: &[String]| {
        let mut cmdline = format!("ulimit -s unlimited; exec {}", prog);
        for arg in args {
            cmdline.push_str(&format!(" '{}'", arg));
        }
        let mut sh = Command::new("sh");
        sh.arg("-c").arg(cmdline);
        sh
    };

    // Stage-1 (Rust pipeline).
    let out = unlimit(residc_bin(), &[file.to_string_lossy().into_owned(), "run".into()])
        .output()
        .expect("rust pipeline");
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    let rust_out = String::from_utf8_lossy(&out.stdout).into_owned();
    assert_eq!(rust_out.trim(), expected, "{rust_out:?}");

    // Stage-2 (bootstrap driver pipeline).
    let bin = dir.join("lenarg_bin");
    let drv_args = vec![
        workspace.join("examples/driver.resid").to_string_lossy().into_owned(),
        "run".into(),
        file.to_string_lossy().into_owned(),
        "-o".into(),
        bin.to_string_lossy().into_owned(),
        "-rt".into(),
        workspace.join("crates/residc/resid_rt.c").to_string_lossy().into_owned(),
    ];
    let out = unlimit(residc_bin(), &drv_args).current_dir(workspace).output().expect("driver run");
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    let out = unlimit(&bin.to_string_lossy(), &[]).output().expect("stage-2 binary");
    assert_eq!(
        String::from_utf8_lossy(&out.stdout).trim_end(),
        expected,
        "{:?}",
        String::from_utf8_lossy(&out.stdout)
    );
    let _ = std::fs::remove_dir_all(&dir);
}

/// HTTP/2 hardening over live TLS 1.3: POST with a request body
/// (HEADERS without END_STREAM + DATA frames) echoed by the server,
/// WINDOW_UPDATE flow-control credit sent for consumed DATA, and a
/// ~42KB response header block split by hyper-h2 across HEADERS +
/// CONTINUATION frames, reassembled and HPACK-decoded by the client.
#[test]
fn run_h2_post_and_continuation_in_resid() {
    let py = match which_python() {
        Some(p) => p,
        None => { eprintln!("skipping: python3 not found"); return; }
    };
    let chk = Command::new(&py).args(["-c", "import h2"]).output().expect("python check");
    if !chk.status.success() {
        eprintln!("skipping: python h2 module unavailable");
        return;
    }
    let openssl = match which_openssl() {
        Some(p) => p,
        None => { eprintln!("skipping: openssl not found"); return; }
    };
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent().unwrap().parent().unwrap();
    let dir = std::env::temp_dir().join(format!("residc-e2e-h2post-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    std::fs::copy(workspace.join("examples/h2_client.resid"), dir.join("h2_client.resid")).unwrap();
    for f in ["tlsmsg.resid","tls.resid","crypto.resid","aesgcm.resid","chacha.resid","x25519.resid",
              "chain.resid","h2.resid","rsa.resid","der.resid","x509.resid",
              "ec256.resid","ed25519.resid"] {
        std::fs::copy(workspace.join("lib").join(f), dir.join(f)).unwrap();
    }
    let gen_out = Command::new(&openssl).args(["req","-x509","-newkey","ec",
        "-pkeyopt","ec_paramgen_curve:prime256v1","-keyout", dir.join("k.pem").to_str().unwrap(),
        "-out", dir.join("c.pem").to_str().unwrap(),
        "-subj","/CN=localhost","-days","30","-nodes",
        "-addext","subjectAltName=DNS:localhost"])
        .output().expect("openssl req");
    assert!(gen_out.status.success(), "{}", String::from_utf8_lossy(&gen_out.stderr));
    let der = Command::new(&openssl).args(["x509","-in", dir.join("c.pem").to_str().unwrap(),
        "-outform","der"]).output().unwrap();
    let certhex: String = der.stdout.iter().map(|b| format!("{:02x}", b)).collect();

    let port = 19900u16 + 400 + (std::process::id() % 400) as u16;
    let mut server = Command::new(&py)
        .arg(workspace.join("tools/h2_server.py"))
        .arg(port.to_string())
        .arg(dir.join("c.pem").to_str().unwrap())
        .arg(dir.join("k.pem").to_str().unwrap())
        .stdout(std::process::Stdio::null())
        .stderr(std::process::Stdio::null())
        .spawn()
        .expect("failed to spawn h2 server");
    std::thread::sleep(std::time::Duration::from_millis(1500));

    let client = dir.join("h2_client.resid");

    // POST /echo — the server echoes the request body back.
    let out = Command::new(residc_bin())
        .arg(&client).arg("run")
        .arg("localhost").arg(port.to_string()).arg(&certhex).arg("")
        .arg("POST").arg("/echo").arg("post-body-123")
        .output();
    let post_out = out.expect("post run failed");
    let stdout = String::from_utf8_lossy(&post_out.stdout).into_owned();

    // GET /bigheaders — response headers exceed the max frame size,
    // forcing hyper-h2 to emit CONTINUATION frames.
    let out = Command::new(residc_bin())
        .arg(&client).arg("run")
        .arg("localhost").arg(port.to_string()).arg(&certhex).arg("")
        .arg("GET").arg("/bigheaders").arg("")
        .output();
    let _ = server.kill();
    let cont_out = out.expect("continuation run failed");
    let stdout2 = String::from_utf8_lossy(&cont_out.stdout).into_owned();

    assert!(stdout.contains("STATUS=200"), "no POST 200 ({stdout:?}) stderr={}",
            String::from_utf8_lossy(&post_out.stderr));
    assert!(stdout.contains("BODY=post-body-123"), "body not echoed ({stdout:?})");
    assert!(stdout2.contains("STATUS=200"), "no continuation 200 ({stdout:?}) stderr={}",
            String::from_utf8_lossy(&cont_out.stderr));
    assert!(stdout2.contains("BODY=continuation-ok"),
            "continuation body missing ({stdout:?})");
    let _ = std::fs::remove_dir_all(&dir);
}

/// The build cache key must include the contents of every transitively
/// imported local file: editing a library invalidates cached binaries.
/// This was a real footgun — library edits silently produced stale runs.
#[test]
fn build_cache_invalidates_on_import_change() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-cacheimp-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    // Isolate from the workspace cache file.
    let cwd = std::env::current_dir().unwrap();
    std::fs::write(dir.join("libx.resid"), "pub Int val() {\n    return 1;\n}\n").unwrap();
    let file = dir.join("main.resid");
    std::fs::write(
        &file,
        "import \"libx.resid\";\n\nInt main() {\n    println(\"v=\" + IntToString(val()));\n    return 0;\n}\n",
    )
    .unwrap();

    let run = |assert_stderr_no_hit: bool| {
        let out = Command::new(residc_bin())
            .arg(&file).arg("run")
            .current_dir(&dir)
            .output()
            .expect("run failed");
        let stderr = String::from_utf8_lossy(&out.stderr).into_owned();
        let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
        assert_eq!(out.status.code(), Some(0), "{stdout} {stderr}");
        if assert_stderr_no_hit {
            assert!(!stderr.contains("cache: hit"), "stale cache hit! {stderr}");
        }
        stdout.trim().to_string()
    };

    let first = run(false);
    assert_eq!(first, "v=1");

    // Second unchanged run may hit the cache — fine either way.
    let _ = run(false);

    // Edit the LIBRARY: the next run must NOT serve the stale binary.
    std::fs::write(dir.join("libx.resid"), "pub Int val() {\n    return 7;\n}\n").unwrap();
    let third = run(true);
    assert_eq!(third, "v=7");

    // Transitive imports are covered too: main -> mid -> leaf.
    std::fs::write(dir.join("leaf.resid"), "pub Int leaf() {\n    return 10;\n}\n").unwrap();
    std::fs::write(dir.join("mid.resid"), "import \"leaf.resid\";\n\npub Int mid() {\n    return leaf();\n}\n").unwrap();
    std::fs::write(
        &file,
        "import \"mid.resid\";\n\nInt main() {\n    println(\"v=\" + IntToString(mid()));\n    return 0;\n}\n",
    )
    .unwrap();
    let t1 = run(false);
    assert_eq!(t1, "v=10");
    std::fs::write(dir.join("leaf.resid"), "pub Int leaf() {\n    return 20;\n}\n").unwrap();
    let t2 = run(true);
    assert_eq!(t2, "v=20");

    let _ = std::fs::remove_dir_all(&dir);
    let _ = std::env::set_current_dir(cwd);
}

/// User-defined behavior `Ord(T) = cmp_fn;` drives `sort(xs, using = Ord(T))`
/// through a generated qsort comparator trampoline (spec §11).
#[test]
fn run_behavior_ord_sort() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-beh-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("beh.resid");
    std::fs::write(
        &file,
        r#"type Point = { x: Int, y: Int };

Int by_y(Point a, Point b) {
    return a.y - b.y;
}

Ord(Point) = by_y;

Int cmp_int(Int a, Int b) {
    return a - b;
}

Ord(Int) = cmp_int;

Int y_of(Point p) {
    return p.y;
}

Int main() {
    List(Point) ps = [Point { x: 1, y: 3 }, Point { x: 2, y: 1 }, Point { x: 3, y: 2 }];
    List(Point) sorted = sort(ps, using = Ord(Point));
    println(IntToString(y_of(sorted[0])));
    println(IntToString(y_of(sorted[1])));
    println(IntToString(y_of(sorted[2])));

    List(Int) xs = [5, 2, 9, 2];
    List(Int) s = sort(xs, using = Ord(Int));
    println(IntToString(s[0]));
    println(IntToString(s[3]));
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
    assert_eq!(
        out.status.code(),
        Some(0),
        "residc failed: {}",
        String::from_utf8_lossy(&out.stderr)
    );
    assert_eq!(stdout.trim(), "1\n2\n3\n2\n9", "unexpected output: {stdout:?}");

    // A comparator with the wrong signature must fail type checking.
    let bad = dir.join("bad.resid");
    std::fs::write(
        &bad,
        r#"
Int f(Int a) { return a; }
Ord(Int) = f;
Int main() { return 0; }
"#,
    )
    .unwrap();
    let out = Command::new(residc_bin())
        .arg(&bad)
        .arg("emit-ir")
        .output()
        .unwrap();
    assert_ne!(out.status.code(), Some(0));
    let err = String::from_utf8_lossy(&out.stderr);
    assert!(err.contains("must have signature"), "{err}");

    let _ = std::fs::remove_dir_all(&dir);
}

/// Behaviors are compile-time knowledge visible across imports (spec §11):
/// a library defines the comparator + instance; an importer sorts through it.
#[test]
fn run_behavior_import_visibility_and_reverse() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-behimp-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    std::fs::write(
        dir.join("ordering.resid"),
        r#"pub Int desc(Int a, Int b) {
    return b - a;
}

Ord(Int) = desc;
"#,
    )
    .unwrap();
    let file = dir.join("usebeh.resid");
    std::fs::write(
        &file,
        r#"import "ordering.resid";

Int main() {
    List(Int) xs = [4, 1, 3];
    List(Int) up = sort(xs, using = Ord(Int));
    println(IntToString(up[0]));
    List(Int) down = sort(xs, using = Reverse(Ord(Int)));
    println(IntToString(down[0]));
    println(IntToString(down[2]));
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
    assert_eq!(
        out.status.code(),
        Some(0),
        "residc failed: {}",
        String::from_utf8_lossy(&out.stderr)
    );
    // Ord(Int) = desc sorts descending; Reverse flips it to ascending.
    assert_eq!(stdout.trim(), "4\n1\n4", "unexpected output: {stdout:?}");

    let _ = std::fs::remove_dir_all(&dir);
}

/// Dual-pipeline behavior parity (spec §11): the stage-2 driver compiles
/// behavior-driven sorts identically to the Rust pipeline — struct sort,
/// Int sort, and Reverse composition produce byte-equal stdout.
#[test]
fn bootstrap_behavior_ord_parity() {
    let workspace = std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap()
        .to_path_buf();
    let dir = std::env::temp_dir().join(format!("residc-beh-parity-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("parity.resid");
    std::fs::write(
        &file,
        r#"type Point = { x: Int, y: Int };

Int by_y(Point a, Point b) {
    return a.y - b.y;
}

Ord(Point) = by_y;

Int cmp_int(Int a, Int b) {
    return a - b;
}

Ord(Int) = cmp_int;

Int y_of(Point p) {
    return p.y;
}

Int main() {
    List(Point) ps = [Point { x: 1, y: 3 }, Point { x: 2, y: 1 }, Point { x: 3, y: 2 }];
    List(Point) sorted = sort(ps, using = Ord(Point));
    println(IntToString(y_of(sorted[0])));
    println(IntToString(y_of(sorted[2])));

    List(Int) xs = [5, 2, 9, 2];
    List(Int) up = sort(xs, using = Ord(Int));
    println(IntToString(up[0]));
    List(Int) down = sort(xs, using = Reverse(Ord(Int)));
    println(IntToString(down[0]));
    return 0;
}
"#,
    )
    .unwrap();

    // Stage-1: Rust pipeline.
    let s1 = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("stage-1 residc run failed");
    assert_eq!(s1.status.code(), Some(0), "{}", String::from_utf8_lossy(&s1.stderr));
    let out1 = String::from_utf8_lossy(&s1.stdout).into_owned();

    // Stage-2: self-hosted driver.
    let bin = dir.join("parity_drv");
    let s2 = Command::new(residc_bin())
        .arg(workspace.join("examples/driver.resid"))
        .arg("run")
        .arg(&file)
        .arg("-o")
        .arg(&bin)
        .arg("-rt")
        .arg(workspace.join("crates/residc/resid_rt.c"))
        .output()
        .expect("stage-2 driver run failed");
    assert_eq!(
        s2.status.code(),
        Some(0),
        "driver failed: {}",
        String::from_utf8_lossy(&s2.stderr)
    );
    let run = Command::new(&bin).output().expect("binary failed");
    assert_eq!(run.status.code(), Some(0));
    let out2 = String::from_utf8_lossy(&run.stdout).into_owned();

    // Byte-identical program output across both compilers.
    assert_eq!(out1.trim(), "1\n3\n2\n9");
    assert_eq!(out1, out2, "pipeline divergence:\nstage1={out1:?}\nstage2={out2:?}");

    // Rejections through the driver: wrong comparator arity/element mismatch.
    for (name, src) in [
        ("badsig.resid", "Int f(Int a) { return a; }\nOrd(Int) = f;\nInt main() { return 0; }\n"),
        ("noinst.resid", "Int main() {\n    List(Int) xs = [2];\n    List(Int) s = sort(xs, using = Ord(Str));\n    return 0;\n}\n"),
    ] {
        let bad = dir.join(name);
        std::fs::write(&bad, src).unwrap();
        let out = Command::new(residc_bin())
            .arg(workspace.join("examples/driver.resid"))
            .arg("run")
            .arg(&bad)
            .arg("-rt")
            .arg(workspace.join("crates/residc/resid_rt.c"))
            .output()
            .unwrap();
        assert_ne!(out.status.code(), Some(0), "{name} should fail");
        let out_text = String::from_utf8_lossy(&out.stdout);
        assert!(out_text.contains("type error"), "{name}: {out_text}");
    }

    let _ = std::fs::remove_dir_all(&dir);
}

/// Map/Set literals and methods through the stage-2 self-hosted driver must
/// behave identically to the stage-1 Rust pipeline (bootstrap parity). Uses
/// only operations the driver currently supports (no `match`/`unwrap`).
#[test]
fn bootstrap_map_set_parity() {
    let workspace = std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap()
        .to_path_buf();
    let dir = std::env::temp_dir().join(format!("residc-mset-parity-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("parity.resid");
    std::fs::write(
        &file,
        r#"Int main() {
    Map(Str, Int) m = {"a": 1, "b": 2, "c": 3};
    println(IntToString(m.len()));
    println(IntToString(m.insert("d", 4).len()));
    Map(Str, Int) r = m.remove("a");
    println(IntToString(r.len()));
    List(Str) ks = m.keys();
    println(IntToString(ks.len()));
    List(Int) vs = m.values();
    println(IntToString(vs.len()));
    Bool has = m.contains("a");
    if (has) {
        println("has-a");
    } else {
        println("no-a");
    }
    Set(Int) s = {1, 2, 3};
    println(IntToString(s.len()));
    Bool has2 = s.contains(2);
    if (has2) {
        println("has-2");
    } else {
        println("no-2");
    }
    Set(Int) s2 = s.insert(4);
    println(IntToString(s2.len()));
    Set(Int) s3 = {1, 2};
    println(IntToString(s2.union(s3).len()));
    println(IntToString(s2.difference(s3).len()));
    println(IntToString(s2.intersection(s3).len()));
    List(Int) sl = s2.intersection(s3).to_list();
    println(IntToString(sl.len()));
    return 0;
}
"#,
    )
    .unwrap();

    // Stage-1: Rust pipeline.
    let s1 = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("stage-1 residc run failed");
    assert_eq!(s1.status.code(), Some(0), "{}", String::from_utf8_lossy(&s1.stderr));
    let out1 = String::from_utf8_lossy(&s1.stdout).into_owned();

    // Stage-2: self-hosted driver.
    let bin = dir.join("parity_drv");
    let s2 = Command::new(residc_bin())
        .arg(workspace.join("examples/driver.resid"))
        .arg("run")
        .arg(&file)
        .arg("-o")
        .arg(&bin)
        .arg("-rt")
        .arg(workspace.join("crates/residc/resid_rt.c"))
        .output()
        .expect("stage-2 driver run failed");
    assert_eq!(
        s2.status.code(),
        Some(0),
        "driver failed: {}",
        String::from_utf8_lossy(&s2.stderr)
    );
    let run = Command::new(&bin).output().expect("binary failed");
    assert_eq!(run.status.code(), Some(0));
    let out2 = String::from_utf8_lossy(&run.stdout).into_owned();

    // Byte-identical program output across both compilers.
    assert_eq!(out1, "3\n4\n2\n3\n3\nhas-a\n3\nhas-2\n4\n4\n2\n2\n2\n");
    assert_eq!(out1, out2, "pipeline divergence:\nstage1={out1:?}\nstage2={out2:?}");

    // Empty `{}` literals are rejected by both pipelines (spec parity).
    for (name, src) in [
        ("emptymap.resid", "Int main() {\n    Map(Str, Int) m = {};\n    return 0;\n}\n"),
        ("emptyset.resid", "Int main() {\n    Set(Int) s = {};\n    return 0;\n}\n"),
    ] {
        let bad = dir.join(name);
        std::fs::write(&bad, src).unwrap();
        let s1b = Command::new(residc_bin()).arg(&bad).arg("run").output().unwrap();
        assert_ne!(s1b.status.code(), Some(0), "{name} should fail in stage-1");
        let s2b = Command::new(residc_bin())
            .arg(workspace.join("examples/driver.resid"))
            .arg("run")
            .arg(&bad)
            .arg("-rt")
            .arg(workspace.join("crates/residc/resid_rt.c"))
            .output()
            .unwrap();
        assert_ne!(s2b.status.code(), Some(0), "{name} should fail in stage-2");
    }

    let _ = std::fs::remove_dir_all(&dir);
}

#[test]
fn bootstrap_option_sum_parity() {
    let workspace = std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap()
        .to_path_buf();
    let dir = std::env::temp_dir().join(format!("residc-opt-parity-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("parity.resid");
    std::fs::write(
        &file,
        r#"Option(Int) maybe() { return Some(42); }
Option(Int) none() { return None; }
Int main() {
    println(ToString(maybe()));
    println(ToString(none()));
    Option(Int) direct = Some(7);
    println(ToString(direct));
    Option(Int) none2 = None;
    println(ToString(none2));
    Int x = 9;
    Option(Int) viavar = Some(x);
    println(ToString(viavar));
    return 0;
}
"#,
    )
    .unwrap();

    // Stage-1: Rust pipeline.
    let s1 = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("stage-1 residc run failed");
    assert_eq!(s1.status.code(), Some(0), "{}", String::from_utf8_lossy(&s1.stderr));
    let out1 = String::from_utf8_lossy(&s1.stdout).into_owned();

    // Stage-2: self-hosted driver.
    let bin = dir.join("parity_drv");
    let s2 = Command::new(residc_bin())
        .arg(workspace.join("examples/driver.resid"))
        .arg("run")
        .arg(&file)
        .arg("-o")
        .arg(&bin)
        .arg("-rt")
        .arg(workspace.join("crates/residc/resid_rt.c"))
        .output()
        .expect("stage-2 driver run failed");
    assert_eq!(
        s2.status.code(),
        Some(0),
        "driver failed: {}",
        String::from_utf8_lossy(&s2.stderr)
    );
    let run = Command::new(&bin).output().expect("binary failed");
    assert_eq!(run.status.code(), Some(0));
    let out2 = String::from_utf8_lossy(&run.stdout).into_owned();

    // Byte-identical program output across both compilers.
    assert_eq!(out1, "Some(42)\nnull\nSome(7)\nnull\nSome(9)\n");
    assert_eq!(out1, out2, "pipeline divergence:\nstage1={out1:?}\nstage2={out2:?}");

    let _ = std::fs::remove_dir_all(&dir);
}
/// `value?` sugar and `else` fallback (spec §23) for Option AND Result,
/// with the Result type-hole adoption at bind sites (the newly-completed
/// driver SSA hole-filling). Self-hosting parity: byte-identical output
/// across the Rust pipeline and the stage-2 driver.
#[test]
fn bootstrap_question_else_parity() {
    let workspace = std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap()
        .to_path_buf();
    let dir = std::env::temp_dir().join(format!("residc-q-else-parity-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("qel.resid");
    std::fs::write(
        &file,
        r#"Result(Int, Str) divide(Int a, Int b) {
    if (b == 0) { return Err("div0"); }
    return Ok(a / b);
}

Result(Int, Str) half(Result(Int, Str) r) {
    Int v = r?;
    Int d = v / 2;
    return Ok(d);
}

Option(Int) twice(Option(Int) m) {
    Int x = m?;
    Int d = x * 2;
    if (d > 100) { return None; }
    return Some(d);
}

Int main() {
    Result(Int, Str) c = half(divide(10, 2));
    Int cv = c else { -1 };
    println(IntToString(cv));
    Result(Int, Str) e = half(divide(3, 0));
    Int ev = e else { -1 };
    println(IntToString(ev));
    Result(Int, Str) a = Err("boom");
    Int av = a else { -5 };
    println(IntToString(av));
    Result(Int, Str) ok = Ok(7);
    Int okv = ok else { -1 };
    println(IntToString(okv));
    Option(Int) n = None;
    Int nv = n else { -1 };
    println(IntToString(nv));
    Option(Int) s = Some(21);
    Option(Int) t = twice(s);
    Int tv = t else { -1 };
    println(IntToString(tv));
    Option(Int) n2 = None;
    Option(Int) t2 = twice(n2);
    Int t2v = t2 else { -2 };
    println(IntToString(t2v));
    return 0;
}
"#,
    )
    .unwrap();

    // Stage-1: Rust pipeline.
    let s1 = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("stage-1 residc run failed");
    assert_eq!(s1.status.code(), Some(0), "{}", String::from_utf8_lossy(&s1.stderr));
    let out1 = String::from_utf8_lossy(&s1.stdout).into_owned();

    // Stage-2: self-hosted driver.
    let bin = dir.join("qel_drv");
    let s2 = Command::new(residc_bin())
        .arg(workspace.join("examples/driver.resid"))
        .arg("run")
        .arg(&file)
        .arg("-o")
        .arg(&bin)
        .arg("-rt")
        .arg(workspace.join("crates/residc/resid_rt.c"))
        .output()
        .expect("stage-2 driver run failed");
    assert_eq!(
        s2.status.code(),
        Some(0),
        "driver failed: {}",
        String::from_utf8_lossy(&s2.stderr)
    );
    let run = Command::new(&bin).output().expect("binary failed");
    assert_eq!(run.status.code(), Some(0));
    let out2 = String::from_utf8_lossy(&run.stdout).into_owned();

    // Byte-identical program output across both compilers.
    assert_eq!(out1, "2\n-1\n-5\n7\n-1\n42\n-2\n");
    assert_eq!(out1, out2, "pipeline divergence:\nstage1={out1:?}\nstage2={out2:?}");

    let _ = std::fs::remove_dir_all(&dir);
}
/// Consuming Option values via `match` (spec §13) — Some/None arms, payload
/// binding, arm order independent of variant. Self-hosting parity check.
#[test]
fn bootstrap_match_parity() {
    let workspace = std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap()
        .to_path_buf();
    let dir = std::env::temp_dir().join(format!("residc-match-parity-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("match.resid");
    std::fs::write(
        &file,
        r#"Option(Int) maybe() { return Some(3); }
Option(Int) none() { return None; }
Int main() {
    Int a = match maybe() { Some(x) => x, None => 0 };
    println(IntToString(a));
    Int b = match none() { None => 7, Some(y) => y };
    println(IntToString(b));
    Option(Int) m = maybe();
    Int c = match m { Some(z) => z + 1, None => -1 };
    println(IntToString(c));
    Option(Int) n = None;
    Int d = match n { Some(w) => w, None => 42 };
    println(IntToString(d));
    return 0;
}
"#,
    )
    .unwrap();

    // Stage-1: Rust pipeline.
    let s1 = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("stage-1 residc run failed");
    assert_eq!(s1.status.code(), Some(0), "{}", String::from_utf8_lossy(&s1.stderr));
    let out1 = String::from_utf8_lossy(&s1.stdout).into_owned();

    // Stage-2: self-hosted driver.
    let bin = dir.join("match_drv");
    let s2 = Command::new(residc_bin())
        .arg(workspace.join("examples/driver.resid"))
        .arg("run")
        .arg(&file)
        .arg("-o")
        .arg(&bin)
        .arg("-rt")
        .arg(workspace.join("crates/residc/resid_rt.c"))
        .output()
        .expect("stage-2 driver run failed");
    assert_eq!(
        s2.status.code(),
        Some(0),
        "driver failed: {}",
        String::from_utf8_lossy(&s2.stderr)
    );
    let run = Command::new(&bin).output().expect("binary failed");
    assert_eq!(run.status.code(), Some(0));
    let out2 = String::from_utf8_lossy(&run.stdout).into_owned();

    // Byte-identical program output across both compilers.
    assert_eq!(out1, "3\n7\n4\n42\n");
    assert_eq!(out1, out2, "pipeline divergence:\nstage1={out1:?}\nstage2={out2:?}");

    let _ = std::fs::remove_dir_all(&dir);
}
#[test]
fn run_wide_int_boxing() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-wb-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("widebox.resid");
    std::fs::write(
        &file,
        r#"Int main() {
    Int(128) big = 1000000 * 1000000;
    Option(Int(128)) o = Some(big);
    Int(128) got = match o { Some(v) => v, None => 0 * 0 };
    if (got == big) { println("I128:PASS"); } else { println("I128:FAIL"); }
    Str is = f"{got}";
    println(is);
    return 0;
}
"#,
    )
    .unwrap();

    // Stage-1: Rust pipeline.
    let s1 = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("stage-1 residc run failed");
    assert_eq!(s1.status.code(), Some(0), "{}", String::from_utf8_lossy(&s1.stderr));
    let out1 = String::from_utf8_lossy(&s1.stdout).into_owned();
    assert_eq!(out1, "I128:PASS\n1000000000000\n");

    // Stage-2: self-hosted driver.
    let workspace = std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap()
        .to_path_buf();
    let bin = dir.join("widebox_drv");
    let s2 = Command::new(residc_bin())
        .arg(workspace.join("examples/driver.resid"))
        .arg("run")
        .arg(&file)
        .arg("-o")
        .arg(&bin)
        .arg("-rt")
        .arg(workspace.join("crates/residc/resid_rt.c"))
        .output()
        .expect("stage-2 driver run failed");
    assert_eq!(
        s2.status.code(),
        Some(0),
        "driver failed: {}",
        String::from_utf8_lossy(&s2.stderr)
    );
    let run = Command::new(&bin).output().expect("binary failed");
    assert_eq!(run.status.code(), Some(0));
    let out2 = String::from_utf8_lossy(&run.stdout).into_owned();
    assert_eq!(out1, out2, "pipeline divergence:\nstage1={out1:?}\nstage2={out2:?}");

    let _ = std::fs::remove_dir_all(&dir);
}
#[test]
fn run_question_sugar_option_and_result() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-q-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("q.resid");
    std::fs::write(
        &file,
        r#"Option(Int) maybe(Int v) {
    if (v > 0) { return Some(v); }
    return None;
}

Option(Int) twice(Option(Int) m) {
    Int x = m?;
    Int d = x * 2;
    if (d > 100) { return None; }
    return Some(d);
}

Result(Int, Str) divide(Int a, Int b) {
    if (b == 0) { return Err("div0"); }
    return Ok(a / b);
}

Result(Int, Str) half(Result(Int, Str) r) {
    Int v = r?;
    Int d = v / 2;
    return Ok(d);
}

Int main() {
    Option(Int) a = twice(Some(21));
    Int av = a else { -1 };
    println(IntToString(av));
    Option(Int) b = twice(None);
    Int bv = b else { -1 };
    println(IntToString(bv));
    Result(Int, Str) c = half(divide(10, 2));
    Int cv = c else { -1 };
    println(IntToString(cv));
    Result(Int, Str) e = half(divide(3, 0));
    Int ev = e else { -1 };
    println(IntToString(ev));
    return 0;
}
"#,
    )
    .unwrap();
    let out = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("residc run failed");
    let stdout = String::from_utf8_lossy(&out.stdout).into_owned();
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    assert_eq!(stdout.trim(), "42\n-1\n2\n-1", "{stdout:?}");
    let _ = std::fs::remove_dir_all(&dir);
}

/// Visibility (spec §22): `pub` items are importable; private helpers stay
/// module-local — callable inside their own file, rejected cross-module.
#[test]
fn run_pub_visibility_enforced() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-vis-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    std::fs::write(
        dir.join("privlib.resid"),
        "Int secret() {\n    return 99;\n}\n\npub Int open_fn() {\n    return secret();\n}\n",
    )
    .unwrap();

    // Legal: calling the pub export.
    let ok = dir.join("ok.resid");
    std::fs::write(
        &ok,
        "import \"privlib.resid\";\n\nInt main() {\n    println(IntToString(open_fn()));\n    return 0;\n}\n",
    )
    .unwrap();
    let out = Command::new(residc_bin()).arg(&ok).arg("run").output().unwrap();
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    assert_eq!(String::from_utf8_lossy(&out.stdout).trim(), "99");

    // Illegal: calling the private helper cross-module.
    let bad = dir.join("bad.resid");
    std::fs::write(
        &bad,
        "import \"privlib.resid\";\n\nInt main() {\n    println(IntToString(secret()));\n    return 0;\n}\n",
    )
    .unwrap();
    let out = Command::new(residc_bin()).arg(&bad).arg("emit-ir").output().unwrap();
    assert_ne!(out.status.code(), Some(0), "private call must fail");
    let err = String::from_utf8_lossy(&out.stderr);
    assert!(err.contains("is not pub"), "{err}");

    let _ = std::fs::remove_dir_all(&dir);
}

/// Per-width wrapping/saturating arithmetic (spec §32): native LLVM lowering
/// for any integer width. The runtime i64 helpers are only used for div.
#[test]
fn run_per_width_wrapping_saturating() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-wsat-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("wsat.resid");
    std::fs::write(
        &file,
        r#"Int main() {
    UInt(8) a = 250;
    UInt(8) b = 20;
    UInt(8) w = wrapping_uadd(a, b);
    println("wuadd: " + UIntToString(w));
    Int(8) sa = 100;
    Int(8) sb = 100;
    Int(8) c = saturating_add(sa, sb);
    println("sat_add: " + IntToString(c));
    UInt(8) ua = 250;
    UInt(8) ub = 20;
    UInt(8) d = saturating_uadd(ua, ub);
    println("suadd: " + UIntToString(d));
    UInt(8) e = 0;
    UInt(8) f = 1;
    UInt(8) g = saturating_usub(e, f);
    println("susub: " + UIntToString(g));
    Int(8) ma = 127;
    Int(8) mb = 2;
    Int(8) h = saturating_mul(ma, mb);
    println("smul: " + IntToString(h));
    UInt(8) mu1 = 128;
    UInt(8) mu2 = 128;
    UInt(8) i = saturating_umul(mu1, mu2);
    println("umul: " + UIntToString(i));
    Int(256) xa = 1;
    Int(256) xb = 2;
    Int(256) x = wrapping_add(xa, xb);
    println("256wrap: " + Int256ToString(x));
    return 0;
}"#,
    )
    .unwrap();
    let out = Command::new(residc_bin()).arg(&file).arg("run").output().unwrap();
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    let stdout = String::from_utf8_lossy(&out.stdout);
    assert!(stdout.contains("wuadd: 14"), "{stdout}");
    assert!(stdout.contains("sat_add: 127"), "{stdout}");
    assert!(stdout.contains("suadd: 255"), "{stdout}");
    assert!(stdout.contains("susub: 0"), "{stdout}");
    assert!(stdout.contains("smul: 127"), "{stdout}");
    assert!(stdout.contains("umul: 255"), "{stdout}");
    assert!(stdout.contains("256wrap: 3"), "{stdout}");
    let _ = std::fs::remove_dir_all(&dir);
}

/// Sandboxing (spec §21): sandbox constrains what capabilities code inside can
/// use. A function inside a sandbox whose @requires exceeds the sandbox ceiling
/// is rejected at compile time.
#[test]
fn run_sandbox_enforcement() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-sandbox-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();

    // Legal: function inside sandbox with no @requires.
    let ok = dir.join("ok.resid");
    std::fs::write(
        &ok,
        r#"sandbox (filesystem) {
    Int read_data() { return 42; }
}

Int main() {
    println(IntToString(read_data()));
    return 0;
}"#,
    )
    .unwrap();
    let out = Command::new(residc_bin()).arg(&ok).arg("run").output().unwrap();
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    assert_eq!(String::from_utf8_lossy(&out.stdout).trim(), "42");

    // Illegal: function inside sandbox @requires(network) exceeds sandbox (filesystem).
    let bad = dir.join("bad.resid");
    std::fs::write(
        &bad,
        r#"sandbox (filesystem) {
    @requires(network)
    Int fetch_data() { return 1; }
}

Int main() {
    println(IntToString(fetch_data()));
    return 0;
}"#,
    )
    .unwrap();
    let out = Command::new(residc_bin()).arg(&bad).arg("emit-ir").output().unwrap();
    assert_ne!(out.status.code(), Some(0), "sandbox ceiling violation must fail");
    let err = String::from_utf8_lossy(&out.stderr);
    assert!(err.contains("network"), "error should mention exceeding capability: {err}");

    let _ = std::fs::remove_dir_all(&dir);
}

/// Sandboxing (spec §21.3): attenuation is transitive across the call
/// closure. A sandboxed function may not transitively reach code that
/// requires a capability beyond the ceiling, even through a helper that
/// declares no requirements of its own.
#[test]
fn run_sandbox_transitive_attenuation() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-sandbox-trans-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();

    // Legal: callee declares network, sandbox grants network.
    let ok = dir.join("ok.resid");
    std::fs::write(
        &ok,
        r#"@requires(network)
Int fetch() { return 42; }

sandbox (network) {
    Int read() { Int x = fetch(); return x; }
}

Int main() {
    println(IntToString(read()));
    return 0;
}"#,
    )
    .unwrap();
    let out = Command::new(residc_bin()).arg(&ok).arg("run").output().unwrap();
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    assert_eq!(String::from_utf8_lossy(&out.stdout).trim(), "42");

    // Illegal: sandbox grants filesystem, callee needs network -> the call
    // inside the sandbox is rejected at compile time.
    let bad = dir.join("bad.resid");
    std::fs::write(
        &bad,
        r#"@requires(network)
Int fetch() { return 42; }

sandbox (filesystem) {
    Int read() { Int x = fetch(); return x; }
}

Int main() {
    println(IntToString(read()));
    return 0;
}"#,
    )
    .unwrap();
    let out = Command::new(residc_bin()).arg(&bad).arg("emit-ir").output().unwrap();
    assert_ne!(out.status.code(), Some(0), "transitive capability violation must fail");
    let err = String::from_utf8_lossy(&out.stderr);
    assert!(err.contains("network"), "error should mention capability: {err}");
    assert!(err.contains("fetch"), "error should mention callee: {err}");

    // Illegal through an undecorated middle-man: `fetch` is only reachable
    // from the sandbox via `helper`, whose effective ceiling narrows to the
    // sandbox's by the closure rule.
    let chain = dir.join("chain.resid");
    std::fs::write(
        &chain,
        r#"@requires(network)
Int fetch() { return 42; }

Int helper() { Int x = fetch(); return x; }

sandbox (filesystem) {
    Int read() { Int x = helper(); return x; }
}

Int main() {
    println(IntToString(read()));
    return 0;
}"#,
    )
    .unwrap();
    let out = Command::new(residc_bin()).arg(&chain).arg("emit-ir").output().unwrap();
    assert_ne!(out.status.code(), Some(0), "closure violation through helper must fail");
    let err = String::from_utf8_lossy(&out.stderr);
    assert!(err.contains("fetch"), "error should mention the closure callee: {err}");

    let _ = std::fs::remove_dir_all(&dir);
}
#[test]
fn run_sandbox_handle_entry_file_param() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-sandbox-handle-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();

    // Legal: a File handle parameter may enter a sandbox whose ceiling grants
    // `filesystem`; `read_handle` in the restricted region uses the handle.
    let ok = dir.join("ok.resid");
    let data = dir.join("data.txt");
    std::fs::write(&data, "hello").unwrap();
    std::fs::write(
        &ok,
        r#"sandbox (filesystem) {
    Int read(File h) {
        Str d = filesystem.read_handle(h);
        return str_len(d);
    }
}

Int main() {
    File h = filesystem.open("data.txt");
    Int n = read(h);
    println(IntToString(n));
    Bool ok = filesystem.close(h);
    return 0;
}"#,
    )
    .unwrap();
    let out = Command::new(residc_bin()).arg(&ok).arg("run").current_dir(&dir).output().unwrap();
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    assert_eq!(String::from_utf8_lossy(&out.stdout).trim(), "5");

    // Illegal: a File handle parameter may NOT enter a sandbox that does not
    // grant `filesystem` — rejected at compile time (spec §21.3).
    let bad = dir.join("bad.resid");
    std::fs::write(
        &bad,
        r#"sandbox (network) {
    Int read(File h) {
        Str d = filesystem.read_handle(h);
        return str_len(d);
    }
}

Int main() {
    File h = filesystem.open("data.txt");
    Int n = read(h);
    println(IntToString(n));
    return 0;
}"#,
    )
    .unwrap();
    let out = Command::new(residc_bin()).arg(&bad).arg("emit-ir").current_dir(&dir).output().unwrap();
    assert_ne!(out.status.code(), Some(0), "File param into non-filesystem sandbox must fail");
    let err = String::from_utf8_lossy(&out.stderr);
    assert!(err.contains("handle parameter"), "error should mention handle parameter: {err}");
    assert!(err.contains("filesystem"), "error should mention filesystem: {err}");

    let _ = std::fs::remove_dir_all(&dir);
}
#[test]
fn run_sandbox_handle_entry_file_argument() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-sandbox-handle-arg-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();

    // Legal: a File handle *value* passed as an inline call argument into a
    // sandbox whose ceiling grants `filesystem` compiles and runs.
    let ok = dir.join("ok.resid");
    let data = dir.join("data.txt");
    std::fs::write(&data, "hello").unwrap();
    std::fs::write(
        &ok,
        r#"Int sink(File h) {
    return 1;
}

sandbox (filesystem) {
    Int forward(File f) {
        Int r = sink(f);
        return r;
    }
}

Int main() {
    File h = filesystem.open("data.txt");
    Int n = forward(h);
    println(IntToString(n));
    Bool ok = filesystem.close(h);
    return 0;
}"#,
    )
    .unwrap();
    let out = Command::new(residc_bin()).arg(&ok).arg("run").current_dir(&dir).output().unwrap();
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    assert_eq!(String::from_utf8_lossy(&out.stdout).trim(), "1");

    // Illegal: a File handle *value* passed as an inline call argument into a
    // sandbox that does NOT grant `filesystem` is rejected at compile time
    // (spec §21.3 value provenance).
    let bad = dir.join("bad.resid");
    std::fs::write(
        &bad,
        r#"Int sink(File h) {
    return 1;
}

sandbox (network) {
    Int forward(File f) {
        Int r = sink(f);
        return r;
    }
}

Int main() {
    File h = filesystem.open("data.txt");
    Int n = forward(h);
    println(IntToString(n));
    return 0;
}"#,
    )
    .unwrap();
    let out = Command::new(residc_bin()).arg(&bad).arg("emit-ir").current_dir(&dir).output().unwrap();
    assert_ne!(out.status.code(), Some(0), "File value as inline arg into non-filesystem sandbox must fail");
    let err = String::from_utf8_lossy(&out.stderr);
    assert!(err.contains("File handle value"), "error should mention File handle value: {err}");
    assert!(err.contains("filesystem"), "error should mention filesystem: {err}");

    let _ = std::fs::remove_dir_all(&dir);
}
#[test]
fn run_sandbox_capability_mode_readonly() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-sandbox-mode-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let data = dir.join("data.txt");
    std::fs::write(&data, "hello").unwrap();

    // Legal: a read-only filesystem grant permits reads (read_all) and
    // compiles + runs end to end.
    let ok = dir.join("ok.resid");
    std::fs::write(
        &ok,
        r#"sandbox (filesystem(readonly)) {
    Int read_demo() {
        Str d = filesystem.read_all("data.txt");
        return str_len(d);
    }
}
Int main() { println(IntToString(read_demo())); return 0; }"#,
    )
    .unwrap();
    let out = Command::new(residc_bin()).arg(&ok).arg("run").current_dir(&dir).output().unwrap();
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    assert_eq!(String::from_utf8_lossy(&out.stdout).trim(), "5");

    // Illegal: a read-only filesystem grant may NOT permit a write verb
    // (filesystem.write_all) — rejected at compile time (spec §21/§20).
    let bad = dir.join("bad.resid");
    std::fs::write(
        &bad,
        r#"sandbox (filesystem(readonly)) {
    Int write_demo() {
        Bool ok = filesystem.write_all("data.txt", "hello");
        return 0;
    }
}
Int main() { write_demo(); return 0; }"#,
    )
    .unwrap();
    let out = Command::new(residc_bin()).arg(&bad).arg("emit-ir").current_dir(&dir).output().unwrap();
    assert_ne!(out.status.code(), Some(0), "write under readonly grant must fail");
    let err = String::from_utf8_lossy(&out.stderr);
    assert!(err.contains("write operation"), "error should mention write operation: {err}");
    assert!(err.contains("read-only"), "error should mention read-only grant: {err}");

    // Illegal: a misspelled mode keyword must NOT silently escalate to
    // read-write (soundness). `readoly` is rejected as unknown.
    let typo = dir.join("typo.resid");
    std::fs::write(
        &typo,
        r#"sandbox (filesystem(readoly)) {
    Int write_demo() {
        Bool ok = filesystem.write_all("data.txt", "hello");
        return 0;
    }
}
Int main() { write_demo(); return 0; }"#,
    )
    .unwrap();
    let out = Command::new(residc_bin()).arg(&typo).arg("emit-ir").current_dir(&dir).output().unwrap();
    assert_ne!(out.status.code(), Some(0), "unknown mode must fail");
    let err = String::from_utf8_lossy(&out.stderr);
    assert!(err.contains("unknown capability mode `readoly`"), "error should mention unknown mode: {err}");

    // Illegal: `process.run` executes an external command (may mutate the
    // system), so a read-only `process` grant must reject it at emit-ir.
    let procr = dir.join("procr.resid");
    std::fs::write(
        &procr,
        r#"sandbox (process(readonly)) {
    Int run_demo() {
        Int code = process.run("echo hi");
        return code;
    }
}
Int main() { run_demo(); return 0; }"#,
    )
    .unwrap();
    let out = Command::new(residc_bin()).arg(&procr).arg("emit-ir").current_dir(&dir).output().unwrap();
    assert_ne!(out.status.code(), Some(0), "readonly process grant must reject process.run");
    let err = String::from_utf8_lossy(&out.stderr);
    assert!(err.contains("write operation") && err.contains("read-only"), "error should mention write under read-only: {err}");

    let _ = std::fs::remove_dir_all(&dir);
}
#[test]
fn run_generic_numeric_behaviors() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-genbeh-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("genbeh.resid");
    std::fs::write(
        &file,
        r#"Int main() {
    List(Int) a = [3, 1, 2];
    List(Int) sa = sort(a, using = Ord(Int));
    println(IntToString(sa[0]));
    println(IntToString(sa[2]));
    List(Int) da = sort(a, using = Reverse(Ord(Int)));
    println(IntToString(da[0]));
    List(UInt(16)) b = [u16(300), u16(100), u16(200)];
    List(UInt(16)) sb = sort(b, using = Ord(UInt(16)));
    println(UIntToString(sb[0]));
    List(Int(8)) c = [i8(3), i8(1), i8(2)];
    List(Int(8)) sc = sort(c, using = Ord(Int(8)));
    List(Float) f = [3.5, 1.25, 2.0];
    List(Float) sf = sort(f, using = Ord(Float));
    println(FloatToString(sf[0]));
    List(Float) df = sort(f, using = Reverse(Ord(Float)));
    println(FloatToString(df[0]));
    return 0;
}"#,
    )
    .unwrap();
    let out = Command::new(residc_bin()).arg(&file).arg("run").output().unwrap();
    assert_eq!(out.status.code(), Some(0), "{}", String::from_utf8_lossy(&out.stderr));
    let stdout = String::from_utf8_lossy(&out.stdout);
    let lines: Vec<&str> = stdout.trim().split('\n').collect();
    assert_eq!(lines[0], "1", "ascending Int: {}", lines[0]);
    assert_eq!(lines[1], "3", "ascending Int tail: {}", lines[1]);
    assert_eq!(lines[2], "3", "descending Int head: {}", lines[2]);
    assert_eq!(lines[3], "100", "ascending UInt(16): {}", lines[3]);
    assert_eq!(lines[4], "1.25", "ascending Float: {}", lines[4]);
    assert_eq!(lines[5], "3.5", "descending Float: {}", lines[5]);

    // Wrong-width instance is rejected at type-check time, before codegen.
    let bad = dir.join("bad.resid");
    std::fs::write(
        &bad,
        r#"Int main() {
    List(Int) xs = [2, 1];
    List(Int) s = sort(xs, using = Ord(Int(8)));
    return 0;
}"#,
    )
    .unwrap();
    let out = Command::new(residc_bin()).arg(&bad).arg("emit-ir").output().unwrap();
    assert_ne!(out.status.code(), Some(0), "width mismatch must fail");
    let err = String::from_utf8_lossy(&out.stderr);
    assert!(err.contains("applies to"), "error should explain the width mismatch: {err}");

    let _ = std::fs::remove_dir_all(&dir);
}
#[test]
fn run_constraint_types() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-contype-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("contype.resid");
    std::fs::write(
        &file,
        r#"type Positive = Int[value > 0];
type Even = Int[value % 2 == 0];
type Natural = Int where value >= 0;

Int main() {
    Positive p = 5;
    println(IntToString(p));
    Even e = 10;
    println(IntToString(e));
    Natural n = 0;
    println(IntToString(n));
    Int y = p * e;
    println(IntToString(y));
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
    assert_eq!(stdout.trim(), "5\n10\n0\n50", "unexpected output: {stdout:?}");

    let _ = std::fs::remove_dir_all(&dir);
}

#[test]
fn constraint_type_violation_rejected() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-contype-bad-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let bad = dir.join("bad.resid");
    std::fs::write(
        &bad,
        r#"type Positive = Int[value > 0];
Int main() {
    Positive p = -1;
    return p;
}
"#,
    )
    .unwrap();
    let out = Command::new(residc_bin()).arg(&bad).arg("emit-ir").output().unwrap();
    assert_ne!(out.status.code(), Some(0), "constraint violation must fail");
    let err = format!(
        "{}{}",
        String::from_utf8_lossy(&out.stdout),
        String::from_utf8_lossy(&out.stderr)
    );
    assert!(err.contains("constraint"), "error should mention constraint: {err}");
    assert!(err.contains("not satisfied by value -1"), "wrong message: {err}");

    let _ = std::fs::remove_dir_all(&dir);
}

#[test]
fn run_map_set_types() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-mapset-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("mapset.resid");
    std::fs::write(
        &file,
        r#"Int main() {
    Map(Str, Int) m = {"a": 1, "b": 2, "c": 3};
    println(IntToString(m.len()));
    Option(Int) got = m.get("b");
    Int v = match got {
        Some(x) => x,
        None => -1,
    };
    println(IntToString(v));
    Option(Int) miss = m.get("z");
    Int mv = match miss {
        Some(x) => x,
        None => -1,
    };
    println(IntToString(mv));
    println(IntToString(m.insert("d", 4).len()));
    Map(Str, Int) r = m.remove("a");
    println(IntToString(r.len()));
    List(Str) ks = m.keys();
    println(IntToString(ks.len()));
    List(Int) vs = m.values();
    println(IntToString(vs.len()));
    Option(Int) ix = m["c"];
    Int iv = match ix {
        Some(x) => x,
        None => -1,
    };
    println(IntToString(iv));
    Bool has = m.contains("a");
    if (has) {
        println("has-a");
    } else {
        println("no-a");
    }
    Set(Int) s = {1, 2, 3};
    println(IntToString(s.len()));
    Bool has2 = s.contains(2);
    if (has2) {
        println("has-2");
    } else {
        println("no-2");
    }
    Set(Int) s2 = s.insert(4);
    println(IntToString(s2.len()));
    Set(Int) s3 = {1, 2};
    println(IntToString(s2.union(s3).len()));
    println(IntToString(s2.difference(s3).len()));
    println(IntToString(s2.intersection(s3).len()));
    List(Int) sl = s2.intersection(s3).to_list();
    println(IntToString(sl.len()));
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
        "3\n2\n-1\n4\n2\n3\n3\n3\nhas-a\n3\nhas-2\n4\n4\n2\n2\n2",
        "unexpected program output: {stdout:?}"
    );

    let _ = std::fs::remove_dir_all(&dir);
}

#[test]
fn reduction_known_fib_comptime_print() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-redfib-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("redfib.resid");
    std::fs::write(
        &file,
        r#"
Int fib(Int n) {
    return if (n < 2) { n } else { fib(n - 1) + fib(n - 2) };
}

Int main() {
    comptime_print(fib(10));
    return fib(10);
}
"#,
    )
    .unwrap();

    let out = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("failed to run residc run");

    let stderr = String::from_utf8_lossy(&out.stderr).into_owned();
    let code = out.status.code().unwrap();
    assert_eq!(
        code,
        55,
        "residc failed: {stderr}"
    );
    // comptime_print goes to stderr with the reduced value
    assert!(stderr.contains("55"), "comptime_print not reduced: {stderr:?}");

    let _ = std::fs::remove_dir_all(&dir);
}

#[test]
fn reduction_falls_back_to_runtime() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-redfallback-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let file = dir.join("redfallback.resid");
    std::fs::write(
        &file,
        r#"
Int count(Int n) {
    return if (n == 0) { 0 } else { count(n - 1) };
}

Int main() {
    // Deep recursion exceeds step budget → runtime fallback
    return count(100000);
}
"#,
    )
    .unwrap();

    let out = Command::new(residc_bin())
        .arg(&file)
        .arg("run")
        .output()
        .expect("failed to run residc run");

    let stderr = String::from_utf8_lossy(&out.stderr).into_owned();
    let code = out.status.code().unwrap();
    assert_eq!(
        code,
        0,
        "residc failed: {stderr}"
    );
    // No comptime_print here, so stderr should be empty or minimal
    assert!(!stderr.contains("computed"), "unexpected comptime output: {stderr:?}");

    let _ = std::fs::remove_dir_all(&dir);
}
