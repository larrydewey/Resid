#!/usr/bin/env python3
"""Minimal TLS1.3 + HTTP/2 test server (memory-BIO driven so the server
flight is flushed immediately after ServerHello, like real servers).

Usage: python3 h2_server.py <port> <cert.pem> <key.pem>
"""
import socket, ssl, sys, threading

import h2.connection
import h2.events

PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 9443
CERT = sys.argv[2] if len(sys.argv) > 2 else "c.pem"
KEY = sys.argv[3] if len(sys.argv) > 3 else "k.pem"


def handle(raw):
    ctx = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
    ctx.load_cert_chain(CERT, KEY)
    ctx.set_alpn_protocols(["h2"])
    inc = ssl.MemoryBIO()
    out = ssl.MemoryBIO()
    tls = ctx.wrap_bio(inc, out, server_side=True)
    # drive handshake
    def flush():
        n = 0
        o = out.read()
        while o:
            print("FLUSH", o[0], o[1]*256+o[2], "len", len(o), flush=True)
            raw.sendall(o)
            n += len(o)
            o = out.read()
    try:
        while True:
            try:
                tls.do_handshake()
                flush()
                break
            except ssl.SSLWantReadError:
                flush()
                data = raw.recv(65536)
                if not data:
                    return
                inc.write(data)
            except ssl.SSLWantWriteError:
                flush()
        flush()
    except (ssl.SSLError, OSError) as e:
        print("HS-FAIL:", e, flush=True)
        raw.close()
        return

    def send_app(b):
        # Encrypt application bytes through the TLS session.
        try:
            tls.write(b)
        except ssl.SSLWantWriteError:
            pass
        o = out.read()
        while o:
            raw.sendall(o)
            o = out.read()

    h2c = h2.connection.H2Connection()
    h2c.initiate_connection()
    send_app(h2c.data_to_send())

    while True:
        try:
            data = tls.read(65536)
        except ssl.SSLWantReadError:
            o = out.read()
            while o:
                raw.sendall(o)
                o = out.read()
            d2 = raw.recv(65536)
            if not d2:
                return
            inc.write(d2)
            continue
        except ssl.SSLEOFError:
            return
        if not data:
            return
        events = h2c.receive_data(data)
        for ev in events:
            if isinstance(ev, h2.events.RequestReceived):
                sid = ev.stream_id
                h2c.send_headers(sid, [(":status", "200"), ("content-type", "text/plain")])
                h2c.send_data(sid, b"hello from resid h2", end_stream=True)
            elif isinstance(ev, h2.events.ConnectionTerminated):
                return
        outb = h2c.data_to_send()
        if outb:
            send_app(outb)



ctx = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
ctx.load_cert_chain(CERT, KEY)
ctx.set_alpn_protocols(["h2"])
srv = socket.socket(socket.AF_INET6)
srv.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
srv.setsockopt(socket.IPPROTO_IPV6, socket.IPV6_V6ONLY, 0)
srv.bind(("::", PORT))
srv.listen(4)
print("READY", flush=True)
while True:
    c, _ = srv.accept()
    threading.Thread(target=handle, args=(c,), daemon=True).start()
