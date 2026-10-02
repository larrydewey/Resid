#!/usr/bin/env python3
"""Drive examples/http_server.resid on 127.0.0.1:PORT: keep-alive, pipelining,
chunked and Content-Length bodies, HEAD, static files, path safety, the
rejections, and many clients at once. Exits non-zero on the first mismatch."""
import socket, sys, threading

PORT = int(sys.argv[1])
fails = []

def conn():
    s = socket.create_connection(("127.0.0.1", PORT), timeout=10)
    return s

def read_response(f):
    status = f.readline()
    if not status:
        return None, {}, b""
    code = int(status.split()[1])
    headers = {}
    while True:
        line = f.readline()
        if line in (b"\r\n", b""):
            break
        k, v = line.decode().split(":", 1)
        headers[k.strip().lower()] = v.strip()
    n = int(headers.get("content-length", "0"))
    return code, headers, f.read(n)

def check(name, got, want):
    if got != want:
        fails.append(f"{name}: got {got!r}, want {want!r}")

def one(req):
    s = conn(); s.sendall(req); f = s.makefile("rb")
    r = read_response(f); s.close(); return r

# basic routing, keep-alive flagged
code, h, body = one(b"GET /hello/resid HTTP/1.1\r\nHost: t\r\nConnection: close\r\n\r\n")
check("hello", (code, body, h.get("connection")), (200, b"hello, resid\n", "close"))

# static files, content type, HEAD carries no body but the length
code, h, body = one(b"GET /files/a.txt HTTP/1.1\r\nHost: t\r\nConnection: close\r\n\r\n")
check("file", (code, body, h.get("content-type")), (200, b"file body\n", "text/plain; charset=utf-8"))
s = conn(); s.sendall(b"HEAD /files/sub/i.html HTTP/1.1\r\nHost: t\r\nConnection: close\r\n\r\n")
raw = b""
while True:
    d = s.recv(4096)
    if not d: break
    raw += d
s.close()
check("head", raw.endswith(b"\r\n\r\n") and b"Content-Length: 9" in raw and b"text/html" in raw, True)
code, _, _ = one(b"GET /files/../a.txt HTTP/1.1\r\nHost: t\r\nConnection: close\r\n\r\n")
check("dotdot", code, 404)
code, _, _ = one(b"GET /files/sub HTTP/1.1\r\nHost: t\r\nConnection: close\r\n\r\n")
check("dir", code, 404)

# POST bodies: Content-Length and chunked, echoed with the content type
big = bytes(range(256)) * 300
code, h, body = one(b"POST /echo HTTP/1.1\r\nHost: t\r\nContent-Type: application/x-bytes\r\nContent-Length: %d\r\nConnection: close\r\n\r\n" % len(big) + big)
check("echo-cl", (code, body == big, h.get("content-type")), (200, True, "application/x-bytes"))
chunks = b"".join(b"%x\r\n%s\r\n" % (len(big[i:i+1000]), big[i:i+1000]) for i in range(0, len(big), 1000)) + b"0\r\n\r\n"
code, h, body = one(b"POST /echo HTTP/1.1\r\nHost: t\r\nTransfer-Encoding: chunked\r\nConnection: close\r\n\r\n" + chunks)
check("echo-chunked", (code, body == big), (200, True))

# pipelining: all requests sent before any reply is read, in order
s = conn()
s.sendall(b"".join(b"GET /hello/%d HTTP/1.1\r\nHost: t\r\n\r\n" % i for i in range(20)))
f = s.makefile("rb")
got = [read_response(f)[2] for _ in range(20)]
s.close()
check("pipeline", got, [b"hello, %d\n" % i for i in range(20)])

# rejections
for name, req, want in [
    ("no-host", b"GET / HTTP/1.1\r\n\r\n", 400),
    ("version", b"GET / HTTP/3.0\r\nHost: t\r\n\r\n", 505),
    ("garbage", b"\x16\x03\x01 hello\r\n\r\n", 400),
    ("te+cl", b"POST /echo HTTP/1.1\r\nHost: t\r\nContent-Length: 3\r\nTransfer-Encoding: chunked\r\n\r\nabc", 400),
    ("te-gzip", b"POST /echo HTTP/1.1\r\nHost: t\r\nTransfer-Encoding: gzip\r\n\r\n", 501),
    ("bad-cl", b"POST /echo HTTP/1.1\r\nHost: t\r\nContent-Length: -1\r\n\r\n", 400),
    ("fold", b"GET / HTTP/1.1\r\nHost: t\r\nX-A: 1\r\n 2\r\n\r\n", 400),
    ("space-colon", b"GET / HTTP/1.1\r\nHost : t\r\n\r\n", 400),
    ("method", b"DELETE / HTTP/1.1\r\nHost: t\r\n\r\n", 405),
    ("too-big", b"POST /echo HTTP/1.1\r\nHost: t\r\nContent-Length: 9000000\r\n\r\n", 413),
    ("huge-head", b"GET / HTTP/1.1\r\nHost: t\r\nX-P: " + b"a" * 70000 + b"\r\n\r\n", 431),
]:
    code, _, _ = one(req)
    check(name, code, want)

# many clients at once, each on its own keep-alive connection
def client(k):
    try:
        s = conn(); f = s.makefile("rb")
        for i in range(25):
            s.sendall(b"GET /hello/%d-%d HTTP/1.1\r\nHost: t\r\n\r\n" % (k, i))
            code, _, body = read_response(f)
            if (code, body) != (200, b"hello, %d-%d\n" % (k, i)):
                fails.append(f"client {k} request {i}: {code} {body!r}"); return
        s.close()
    except Exception as e:
        fails.append(f"client {k}: {e!r}")
ts = [threading.Thread(target=client, args=(k,)) for k in range(12)]
[t.start() for t in ts]; [t.join() for t in ts]

if fails:
    print("\n".join(fails)); sys.exit(1)
print("client.py: all checks passed")
