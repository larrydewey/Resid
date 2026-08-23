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

/// M6a: the self-hosted type checker (examples/typecheck.res) accepts all
/// three bootstrap programs — including its own source.
#[test]
fn bootstrap_typechecker_accepts_bootstrap_sources() {
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap();
    for name in ["typecheck.res", "lexer.res", "parser.res"] {
        let out = Command::new(residc_bin())
            .arg(workspace.join("examples/typecheck.res"))
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
    let bad = dir.join("bad.res");
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
        .arg(workspace.join("examples/typecheck.res"))
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
    let sample = dir.join("sample.res");
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
        .arg(workspace.join("examples/codegen.res"))
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
    let sample = dir.join("sample.res");
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
        .arg(workspace.join("examples/driver.res"))
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
    let bad = dir.join("bad.res");
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
        .arg(workspace.join("examples/driver.res"))
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
/// (examples/codegen.res) compiles the bootstrap lexer into a working
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
        .arg(workspace.join("examples/codegen.res"))
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
        .arg(workspace.join("examples/lexer.res"))
        .arg("-o")
        .arg(&ll)
        .output()
        .expect("failed to run stage-2 emitter");
    assert_eq!(
        out.status.code(),
        Some(0),
        "stage-2 compile of lexer.res failed: {}",
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

/// Unicode case mapping covers ASCII, Latin-1, Latin Extended-A, Greek and
/// Cyrillic; ß has no simple uppercase and passes through.
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
        "HÉLLO WÖRLD ПРИВЕТ ΑΒΓ\nhéllo wörld привет αβγ\nßŸ",
        "unexpected output: {stdout:?}"
    );
    let _ = std::fs::remove_dir_all(&dir);
}

/// SHA-256 written in pure Resid (lib/crypto.res) — self-hosted crypto.
#[test]
fn run_sha256_in_resid() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-sha-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap();
    std::fs::copy(workspace.join("lib/crypto.res"), dir.join("crypto.res")).unwrap();
    let file = dir.join("main.resid");
    std::fs::write(
        &file,
        r#"
import "crypto.res";
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
    std::fs::copy(workspace.join("lib/crypto.res"), dir.join("crypto.res")).unwrap();
    let file = dir.join("main.resid");
    std::fs::write(
        &file,
        r#"
import "crypto.res";
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

/// HMAC-SHA256 in pure Resid — RFC 4231-style vectors via lib/crypto.res.
#[test]
fn run_hmac_sha256_in_resid() {
    let dir = std::env::temp_dir().join(format!("residc-e2e-hmac-{}", std::process::id()));
    std::fs::create_dir_all(&dir).unwrap();
    let workspace = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .unwrap()
        .parent()
        .unwrap();
    std::fs::copy(workspace.join("lib/crypto.res"), dir.join("crypto.res")).unwrap();
    let file = dir.join("main.resid");
    std::fs::write(
        &file,
        r#"
import "crypto.res";
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
    std::fs::copy(workspace.join("lib/crypto.res"), dir.join("crypto.res")).unwrap();
    let file = dir.join("main.resid");
    std::fs::write(
        &file,
        r#"
import "crypto.res";
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
    std::fs::copy(workspace.join("lib/crypto.res"), dir.join("crypto.res")).unwrap();
    let file = dir.join("main.resid");
    std::fs::write(
        &file,
        r#"
import "crypto.res";
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
