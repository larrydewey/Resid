import "crypto.res";

// ─── lib/http.res — HTTP/1.1 client in pure Resid (spec §32) ──────────
// All protocol logic is Resid; the runtime only provides raw TCP
// externs (resid_tcp_connect/send/recv_all/close). HTTP/1.1 with
// `Connection: close`: the response body ends when the peer closes.
// Chunked transfer coding and TLS are out of scope for v1.

type Url = { host: Str, port: Int, path: Str };
type HttpResponse = { status: Int, headers: Str, body: Str };

// Find the first occurrence of `sub` at or after `i`; -1 when absent.
pub Int http_find_from(Str s, Str sub, Int i) {
    Int n = str_len(s);
    Int m = str_len(sub);
    Int limit = n - m;
    if (m == 0) { return i; }
    if (limit < 0) { return 0 - 1; }
    if (i > limit) { return 0 - 1; }
    Int e = i + m;
    Str window = str_slice(s, i, e);
    if (window == sub) { return i; }
    Int ni = i + 1;
    return http_find_from(s, sub, ni);
}

// First occurrence of `sub` anywhere in `s`; -1 when absent.
pub Int http_find(Str s, Str sub) {
    return http_find_from(s, sub, 0);
}

// Join path segments back together after splitting the URL on "/".
pub Str http_join_path(List(Str) segs, Int i, Int n, Str acc) {
    if (i > n) { return acc; }
    Str sep = if (acc == "") { "" } else { "/" };
    Str acc2 = acc + sep + segs[i];
    Int ni = i + 1;
    return http_join_path(segs, ni, n, acc2);
}

// Parse "http://host[:port]/path" (default port 80, default path "/").
// Returns port 0 on malformed input.
pub Url http_parse_url(Str url) {
    List(Str) parts = str_split(url, "//");
    if (str_len(url) < 8) { return Url { host: "", port: 0, path: "" }; }
    Str after = str_slice(url, 7, str_len(url));
    List(Str) halves = str_split(after, "/");
    // halves[0] = host[:port]; the rest rejoins into the path.
    Str netloc = halves[0];
    Int segs_n = str_count(after, "/");
    List(Str) hp = str_split(netloc, ":");
    Str host = if (str_contains(netloc, ":")) { hp[0] } else { netloc };
    Int port = if (str_contains(netloc, ":")) { str_parse_int(hp[1]) } else { 80 };
    Int hlen2 = halves.len();
    Int nseg = hlen2 - 1;
    Str path = if (nseg == 0) { "/" } else { "/" + http_join_path(halves, 1, nseg, "") };
    return Url { host: host, port: port, path: path };
}

// Perform a GET; returns the full raw response. Empty string on any
// transport failure (connect refused, send failed, ...).
pub Str http_get_raw(Str url) {
    Url u = http_parse_url(url);
    if (u.port <= 0) { return ""; }
    Int fd = resid_tcp_connect(u.host, u.port);
    if (fd < 0) { return ""; }
    Str head1 = "GET " + u.path + " HTTP/1.1\r\n";
    Str head2 = "Host: " + u.host + "\r\n";
    Str head3 = "User-Agent: resid-http/1\r\nAccept: */*\r\nConnection: close\r\n\r\n";
    Str req = head1 + head2 + head3;
    if (!resid_tcp_send(fd, req)) {
        resid_tcp_close(fd);
        return "";
    }
    Str resp = resid_tcp_recv_all(fd);
    resid_tcp_close(fd);
    return resp;
}

// Split a raw response into status / headers / body.
pub HttpResponse http_parse_response(Str raw) {
    if (raw == "") { return HttpResponse { status: 0, headers: "", body: "" }; }
    List(Str) head_body = str_split(raw, "\r\n\r\n");
    Str head = head_body[0];
    Int hlen = str_len(head);
    Int blen = str_len(raw);
    Int body_start = hlen + 4;
    Str body = if (blen > body_start) {
        str_slice(raw, body_start, blen)
    } else {
        ""
    };
    // Status line: "HTTP/1.1 200 OK" — locate the two spaces.
    Int sp1 = http_find(head, " ");
    if (sp1 < 0) { return HttpResponse { status: 0, headers: head, body: body }; }
    Int rest_start = sp1 + 1;
    Str after_status = str_slice(head, rest_start, str_len(head));
    Int sp2rel = http_find(after_status, " ");
    Int sp2 = sp2rel + rest_start;
    Int p1p1 = sp1 + 1;
    Str code = str_slice(head, p1p1, sp2);
    return HttpResponse { status: str_parse_int(code), headers: head, body: body };
}

// Convenience: GET and return just the body ("" on failure).
pub Str http_get_body(Str url) {
    HttpResponse r = http_parse_response(http_get_raw(url));
    if (r.status != 200) { return ""; }
    return r.body;
}

// Convenience: GET and return just the numeric status code (0 on failure).
pub Int http_get_status(Str url) {
    HttpResponse r = http_parse_response(http_get_raw(url));
    return r.status;
}
