"""A DNS server for dns_search.resid: on 127.0.0.1:53, an A record of
127.0.0.1 for pylonhost.second.test, no AAAA record for it, NXDOMAIN for
every other name. Prints "ready" once bound, then each name asked, and
exits after argv[1] seconds."""
import socket
import struct
import sys
import time

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.bind(("127.0.0.1", 53))
s.settimeout(0.2)
print("ready", flush=True)
end = time.time() + float(sys.argv[1])
while time.time() < end:
    try:
        q, peer = s.recvfrom(512)
    except socket.timeout:
        continue
    p, labels = 12, []
    while q[p]:
        labels.append(q[p + 1:p + 1 + q[p]].decode())
        p += 1 + q[p]
    name = ".".join(labels).lower()
    qtype = struct.unpack(">H", q[p + 1:p + 3])[0]
    question = q[12:p + 5]
    print(name, qtype, flush=True)
    known = name == "pylonhost.second.test"
    rcode = 0 if known else 3
    answer = b""
    if known and qtype == 1:
        answer = b"\xc0\x0c" + struct.pack(">HHIH", 1, 1, 60, 4) + bytes([127, 0, 0, 1])
    head = q[:2] + struct.pack(">BBHHHH", 0x81, 0x80 | rcode, 1, 1 if answer else 0, 0, 0)
    s.sendto(head + question + answer, peer)
