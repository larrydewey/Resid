"""Run a compiled program with the core limit raised as far as it goes and
print how it ended: exit <code> | signal <n> core|nocore, then its stderr.
Whether a control's core is written depends on the host's core_pattern;
the secret-mode programs must report nocore regardless."""
import os, resource, sys

soft, hard = resource.getrlimit(resource.RLIMIT_CORE)
resource.setrlimit(resource.RLIMIT_CORE, (hard, hard))
r, w = os.pipe()
pid = os.fork()
if pid == 0:
    os.close(r)
    os.dup2(w, 2)
    os.dup2(os.open(os.devnull, os.O_WRONLY), 1)
    os.execv(sys.argv[1], [sys.argv[1]])
os.close(w)
err = b""
while True:
    b = os.read(r, 4096)
    if not b:
        break
    err += b
_, st = os.waitpid(pid, 0)
if os.WIFEXITED(st):
    print(f"exit {os.WEXITSTATUS(st)}")
else:
    print(f"signal {os.WTERMSIG(st)} {'core' if os.WCOREDUMP(st) else 'nocore'}")
sys.stdout.write(err.decode(errors="replace"))
