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
    let file = dir.join("rngslc.res");
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
    let lexer = dir.join("lexer.res");
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap();
    std::fs::copy(workspace.join("examples/lexer.res"), &lexer).unwrap();
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
        .env("RESID_LEX_SRC", &src)
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
    let parser = dir.join("parser.res");
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap();
    std::fs::copy(workspace.join("examples/parser.res"), &parser).unwrap();
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
        .env("RESID_PARSER_SRC", &src)
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
