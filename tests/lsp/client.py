#!/usr/bin/env python3
"""Drive `residc lsp` over stdio and check its answers (tests/lsp/run.sh)."""
import json, os, subprocess, sys

compiler, root = sys.argv[1], os.path.abspath(sys.argv[2])
main = os.path.join(root, "main.resid")
geo = os.path.join(root, "sub", "geo.resid")
uri = "file://" + main
fails = []
passes = 0


def check(name, ok, got):
    global passes
    if ok:
        passes += 1
    else:
        fails.append(f"{name}: {json.dumps(got)[:300]}")


p = subprocess.Popen([compiler, "lsp"], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL)


def send(msg):
    body = json.dumps(msg).encode()
    p.stdin.write(b"Content-Length: %d\r\n\r\n" % len(body) + body)
    p.stdin.flush()


def recv():
    head = b""
    while not head.endswith(b"\r\n\r\n"):
        c = p.stdout.read(1)
        if not c:
            return None
        head += c
    n = int([l for l in head.decode().split("\r\n") if l.lower().startswith("content-length")][0].split(":")[1])
    return json.loads(p.stdout.read(n))


def query(method, line=0, col=0):
    send({"jsonrpc": "2.0", "id": 7, "method": method,
          "params": {"textDocument": {"uri": uri}, "position": {"line": line, "character": col}}})
    return recv()


def change(text):
    send({"jsonrpc": "2.0", "method": "textDocument/didChange",
          "params": {"textDocument": {"uri": uri}, "contentChanges": [{"text": text}]}})
    return recv()


text = open(main).read()
send({"jsonrpc": "2.0", "id": 1, "method": "initialize", "params": {}})
r = recv()
caps = r["result"]["capabilities"]
check("initialize", caps.get("hoverProvider") and caps.get("definitionProvider"), r)
send({"jsonrpc": "2.0", "method": "initialized", "params": {}})
send({"jsonrpc": "2.0", "method": "textDocument/didOpen",
      "params": {"textDocument": {"uri": uri, "languageId": "resid", "version": 1, "text": text}}})
r = recv()
check("clean diagnostics", r["method"] == "textDocument/publishDiagnostics" and r["params"]["diagnostics"] == [], r)

# An unsaved type error is reported at its line and column.
r = change(text.replace("Int n = norm2(q);", 'Int n = norm2(q) + "a";'))
d = r["params"]["diagnostics"]
check("error diagnostic", len(d) == 1 and d[0]["range"]["start"]["line"] == 4 and d[0]["code"] == "E0001", r)
r = change(text)
check("error cleared", r["params"]["diagnostics"] == [], r)

# Hover on a call: signature and doc comment from the imported file.
r = query("textDocument/hover", 4, 13)
v = (r.get("result") or {}).get("contents", {}).get("value", "")
check("hover signature", "Int norm2(Point p)" in v and "Squared distance" in v, r)
r = query("textDocument/hover", 4, 8)
v = (r.get("result") or {}).get("contents", {}).get("value", "")
check("hover type", "Int" in v, r)

# Definition across the import.
r = query("textDocument/definition", 4, 13)
loc = r.get("result") or {}
check("definition", loc.get("uri", "").endswith("/sub/geo.resid") and loc["range"]["start"]["line"] == 3, r)
r = query("textDocument/definition", 4, 18)
loc = r.get("result") or {}
check("definition of a local", loc.get("uri") == uri and loc["range"]["start"]["line"] == 3, r)

r = query("textDocument/documentSymbol")
names = [s["name"] for s in r.get("result") or []]
check("symbols", names == ["main"], r)
r = query("textDocument/completion")
labels = [i["label"] for i in (r.get("result") or {}).get("items", [])]
check("completion", "norm2" in labels and "Point" in labels and "match" in labels, r)
# Behavior verbs complete; the prelude's own functions do not.
check("completion builtins", "resid_read_byte" in labels and "resid_term_raw" in labels, r)
check("completion verbs", "compare" in labels and "show" in labels and "resid_ord_int" not in labels, r)

# Memory stays flat across edits (each message runs in its own arena).
def rss():
    for l in open(f"/proc/{p.pid}/status"):
        if l.startswith("VmRSS"):
            return int(l.split()[1])
for i in range(5):
    change(text + "\n" * i)
before = rss()
for i in range(40):
    change(text + "\n" * (i % 3))
    query("textDocument/hover", 4, 13)
check("memory flat", rss() - before < 2048, {"before": before, "after": rss()})

send({"jsonrpc": "2.0", "id": 9, "method": "shutdown"})
r = recv()
check("shutdown", r.get("id") == 9 and r.get("result") is None, r)
send({"jsonrpc": "2.0", "method": "exit"})
check("exit code", p.wait(timeout=10) == 0, p.returncode)

for f in fails:
    print("FAIL", f)
print(f"lsp: {passes} passed, {len(fails)} failed")
sys.exit(1 if fails else 0)
