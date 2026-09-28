#!/usr/bin/env python3
# Drives term/readline.resid's binary through a pseudo-terminal: editing
# keys, UTF-8, history, completion, Ctrl-C and Ctrl-D, and the terminal
# settings during and after the call.
import os, pty, re, select, sys, termios, time

def drain(fd, t=0.2):
    out, end = b"", time.time() + t
    while time.time() < end:
        r, _, _ = select.select([fd], [], [], 0.05)
        if r:
            try:
                out += os.read(fd, 65536)
            except OSError:
                break
    return out

pid, fd = pty.fork()
if pid == 0:
    os.execv(sys.argv[1], [sys.argv[1]])
out = drain(fd, 0.5)
raw = not (termios.tcgetattr(fd)[3] & (termios.ICANON | termios.ECHO))
keys = [b"abc", b"\x1b[D\x1b[D", b"X", b"\r",
        b"h\xc3\xa9llo", b"\x7f\x7f", b"\r",
        b"\x1b[A\x1b[A", b"\r",
        b"foo bar baz", b"\x17", b"\x01", b"\x1b[1;5C", b"Z", b"\r",
        b"12345", b"\x1b[H\x1b[3~\x05\x02\x14", b"\r",
        b"hel\t", b"lo", b"\r",
        b"x", b"\x03",
        b"\x04"]
for k in keys:
    os.write(fd, k)
    out += drain(fd)
_, st = os.waitpid(pid, 0)
out += drain(fd, 0.1)
text = re.sub(r"\x1b\[[0-9;]*[A-Za-z]", "", out.decode("utf-8", "replace"))
got = [l.strip() for l in text.replace("\r", "\n").split("\n") if l.startswith(("got", "help", "interrupted", "eof"))]
print("raw during call:", raw)
print("\n".join(got))
print("exit:", os.WEXITSTATUS(st))
