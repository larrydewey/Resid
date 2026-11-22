#!/usr/bin/env python3
"""The client of long_deadline.resid: connects to SOCKET as soon as it
exists, then sends b"late\\n" 32 s later.

    long_deadline_client.py SOCKET
"""
import os
import socket
import sys
import time

path = sys.argv[1]
for _ in range(300):
    if os.path.exists(path):
        break
    time.sleep(0.1)
s = socket.socket(socket.AF_UNIX)
s.connect(path)
time.sleep(32)
try:
    s.sendall(b"late\n")
    time.sleep(1)
except OSError:
    pass  # the receiver gave up early (the failure the test reports)
s.close()
