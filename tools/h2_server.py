#!/usr/bin/env python3
"""Minimal TLS1.3 + HTTP/2 test server (memory-BIO driven so the server
flight is flushed immediately after ServerHello, like real servers).

Usage: python3 h2_server.py <port> <cert.pem> <key.pem>
"""
import socket, ssl, sys, threading

import h2.connection
import h2.events
from h2.config import H2Configuration

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

    print("HS-DONE", flush=True)
    def send_app(b):
        print("SENDAPP", len(b), b[:9].hex(), flush=True)
        # Encrypt application bytes through the TLS session.
        try:
            tls.write(b)
        except ssl.SSLWantWriteError:
            pass
        o = out.read()
        while o:
            raw.sendall(o)
            o = out.read()

    cfg = H2Configuration(client_side=False)
    h2c = h2.connection.H2Connection(config=cfg)
    h2c.initiate_connection()
    send_app(h2c.data_to_send())

    streams = {}  # sid -> {"headers": [...], "body": bytearray}

    def respond(sid):
        headers, body = streams.get(sid, ([], b""))
        raw_hdrs = dict(headers)
        path = b"/bigheaders"
        for k, v in raw_hdrs.items():
            if k == b":path":
                path = v
        if path == b"/bigheaders":
            # ~40KB of response headers forces hyper-h2 to split the
            # HEADERS block across CONTINUATION frames.
            big = [(":status", "200"), ("content-type", "text/plain")]
            for i in range(300):
                big.append((f"x-pad-{i}", "v" * 140))
            h2c.send_headers(sid, big)
            h2c.send_data(sid, b"continuation-ok", end_stream=True)
        else:
            h2c.send_headers(sid, [(":status", "200"), ("content-type", "text/plain")])
            payload = bytes(body) if body else b"hello from resid h2"
            h2c.send_data(sid, payload, end_stream=True)

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
        print("EVENTS", len(data), [type(e).__name__ for e in events], flush=True)
        for ev in events:
            if isinstance(ev, h2.events.RequestReceived):
                sid = ev.stream_id
                streams[sid] = (list(ev.headers), bytearray())
                if ev.stream_ended:
                    respond(sid)
            elif isinstance(ev, h2.events.DataReceived):
                sid = ev.stream_id
                if sid in streams:
                    streams[sid][1].extend(ev.data)
                if ev.stream_ended:
                    respond(sid)
            elif isinstance(ev, h2.events.ConnectionTerminated):
                return
        outb = h2c.data_to_send()
        if outb:
            send_app(outb)
        else:
            print("loop-noout", flush=True)



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
