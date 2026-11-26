# Runs display_inherit (argv[1]) as a launcher would: "pass" hands it one
# end of a socket pair as descriptor 3 in RSP_SOCKET and prints what
# arrives at the other end; "stale" names descriptor 3 without opening it.
import fcntl, os, socket, subprocess, sys
binary, mode = sys.argv[1], sys.argv[2]
env = dict(os.environ, RSP_SOCKET="3", MODE=mode)
if mode == "pass":
    a0, b = socket.socketpair()
    # The launcher's own end moves out of the way of descriptor 3.
    a = socket.socket(fileno=fcntl.fcntl(a0.fileno(), fcntl.F_DUPFD_CLOEXEC, 10))
    a0.close()
    os.dup2(b.fileno(), 3, inheritable=True)
    out = subprocess.run([binary], env=env, pass_fds=(3,), capture_output=True, text=True, timeout=30).stdout
    os.close(3)
    b.close()
    a.settimeout(2)
    try:
        got = a.recv(16)
    except socket.timeout:
        got = b""
    sys.stdout.write(out + f"launcher got: {got!r}\n")
else:
    for fd in range(3, 64):
        try:
            os.close(fd)
        except OSError:
            pass
    out = subprocess.run([binary], env=env, close_fds=True, capture_output=True, text=True, timeout=30).stdout
    sys.stdout.write(out)
