//! Registry transport (spec §28): local directories or remote HTTP.
//!
//! Remote is deliberately dependency-free: a minimal HTTP/1.1 GET over
//! `std::net::TcpStream`, enough for a static archive server (`resid-build
//! serve`). TLS/redirects are out of scope — put an HTTPS reverse proxy in
//! front for production use.

use std::path::{Path, PathBuf};

pub const PKG_SUFFIX: &str = "-pkg";
pub const SHA_SUFFIX: &str = "-sha256";
pub const SIG_SUFFIX: &str = "-sig";

/// Where archives come from.
#[derive(Debug, Clone)]
pub enum Registry {
    /// Directory containing `<name>-<version>.resid-pkg` etc.
    Local(PathBuf),
    /// Base URL like `http://host:port`.
    Remote(String),
}

impl Registry {
    /// Raw object name under the registry: `<base>/<name>-<version>.resid-<kind>`.
    fn url_for(&self, name: &str, version: &str, suffix: &str) -> String {
        match self {
            Registry::Local(_) => unreachable!("url_for on local registry"),
            Registry::Remote(base) => {
                let base = base.trim_end_matches('/');
                format!("{base}/pkg/{name}-{version}.resid{suffix}")
            }
        }
    }

    fn local_candidates(&self, name: &str, version: &str, suffix: &str) -> Vec<PathBuf> {
        let file = format!("{name}-{version}.resid{suffix}");
        match self {
            Registry::Local(dir) => vec![dir.join("pkg").join(&file), dir.join(&file)],
            Registry::Remote(_) => vec![],
        }
    }

    /// The canonical write location for a published object: `<dir>/pkg/`.
    pub fn local_write_path(&self, name: &str, version: &str, suffix: &str) -> PathBuf {
        let file = format!("{name}-{version}.resid{suffix}");
        match self {
            Registry::Local(dir) => dir.join("pkg").join(file),
            Registry::Remote(_) => unreachable!("local_write_path on remote registry"),
        }
    }

    /// Fetch the archive bytes for one package version.
    pub fn fetch_pkg(&self, name: &str, version: &str) -> Result<Vec<u8>, String> {
        match self {
            Registry::Local(_) => {
                for p in self.local_candidates(name, version, PKG_SUFFIX) {
                    if let Ok(b) = std::fs::read(&p) {
                        return Ok(b);
                    }
                }
                Err(format!(
                    "cannot read registry archive '{}'",
                    self.local_write_path(name, version, PKG_SUFFIX).display()
                ))
            }
            Registry::Remote(_) => {
                http_get(&self.url_for(name, version, PKG_SUFFIX)).map(|r| r.body)
            }
        }
    }

    /// Fetch the content-hash sidecar, if present.
    pub fn fetch_sha(&self, name: &str, version: &str) -> Option<String> {
        let text = match self {
            Registry::Local(_) => self
                .local_candidates(name, version, SHA_SUFFIX)
                .iter()
                .find_map(|p| std::fs::read_to_string(p).ok()),
            Registry::Remote(_) => {
                http_get(&self.url_for(name, version, SHA_SUFFIX)).ok().map(|r| String::from_utf8_lossy(&r.body).into_owned())
            }
        }?;
        Some(text.trim().to_string())
    }
}

/// Minimal parsed HTTP response.
pub struct HttpResponse {
    pub status: u16,
    pub body: Vec<u8>,
}

/// Parse `http://host[:port][/prefix]`.
fn parse_url(url: &str) -> Result<(String, u16, String), String> {
    let rest = url
        .strip_prefix("http://")
        .ok_or_else(|| format!("only http:// URLs are supported: '{url}'"))?;
    let (hostport, path) = match rest.find('/') {
        Some(i) => (&rest[..i], &rest[i..]),
        None => (rest, "/"),
    };
    let (host, port) = match hostport.rsplit_once(':') {
        Some((h, p)) => (
            h.to_string(),
            p.parse::<u16>().map_err(|_| format!("bad port in '{url}'"))?,
        ),
        None => (hostport.to_string(), 80),
    };
    Ok((host, port, path.to_string()))
}

/// Perform an HTTP/1.1 GET; reads Content-Length or until connection close.
pub fn http_get(url: &str) -> Result<HttpResponse, String> {
    use std::io::{Read, Write};
    let (host, port, path) = parse_url(url)?;
    let mut stream =
        std::net::TcpStream::connect((host.as_str(), port)).map_err(|e| {
            format!("cannot connect to {host}:{port}: {e}")
        })?;
    let req = format!(
        "GET {path} HTTP/1.1\r\nHost: {host}:{port}\r\nUser-Agent: resid-build\r\nAccept: */*\r\nConnection: close\r\n\r\n"
    );
    stream
        .write_all(req.as_bytes())
        .map_err(|e| format!("request write failed: {e}"))?;
    let mut raw = Vec::new();
    stream
        .read_to_end(&mut raw)
        .map_err(|e| format!("response read failed: {e}"))?;
    let header_end = raw
        .windows(4)
        .position(|w| w == b"\r\n\r\n")
        .ok_or_else(|| "malformed HTTP response (no header terminator)".to_string())?;
    let headers = String::from_utf8_lossy(&raw[..header_end]).into_owned();
    let mut lines = headers.lines();
    let status_line = lines.next().unwrap_or_default();
    let status: u16 = status_line
        .split_whitespace()
        .nth(1)
        .and_then(|s| s.parse().ok())
        .ok_or_else(|| format!("malformed HTTP status line: '{status_line}'"))?;
    let mut content_length: Option<usize> = None;
    for line in lines {
        if let Some((k, v)) = line.split_once(':') {
            if k.eq_ignore_ascii_case("content-length") {
                content_length = v.trim().parse().ok();
            }
        }
    }
    let body_start = header_end + 4;
    let body = match content_length {
        Some(n) if n <= raw.len() - body_start => raw[body_start..body_start + n].to_vec(),
        _ => raw[body_start..].to_vec(),
    };
    Ok(HttpResponse { status, body })
}

/// Serve `<dir>/pkg/<file>` over HTTP for `resid-build serve`. One thread
/// per connection; only GET under `/pkg/` is answered.
pub fn serve_dir(dir: &Path, port: u16) -> Result<(), String> {
    use std::io::{Read, Write};
    let listener = std::net::TcpListener::bind(("0.0.0.0", port))
        .map_err(|e| format!("cannot bind port {port}: {e}"))?;
    println!("resid registry serving '{}' on http://0.0.0.0:{port}", dir.display());
    for conn in listener.incoming() {
        let Ok(mut stream) = conn else { continue };
        let dir = dir.to_path_buf();
        std::thread::spawn(move || {
            let mut buf = Vec::new();
            let mut take = [0u8; 4096];
            // Read just the request head.
            loop {
                match stream.read(&mut take) {
                    Ok(0) | Err(_) => break,
                    Ok(n) => {
                        buf.extend_from_slice(&take[..n]);
                        if buf.windows(4).any(|w| w == b"\r\n\r\n") || buf.len() > 16384 {
                            break;
                        }
                    }
                }
            }
            let head = String::from_utf8_lossy(&buf);
            let target = head
                .lines()
                .next()
                .and_then(|l| l.split_whitespace().nth(1))
                .unwrap_or("/");
            // Only GET /pkg/<safe-name>.
            let name = match target.strip_prefix("/pkg/") {
                Some(n) if head.starts_with("GET ") => n,
                _ => {
                    let _ = stream.write_all(b"HTTP/1.1 404 Not Found\r\nContent-Length: 0\r\nConnection: close\r\n\r\n");
                    return;
                }
            };
            if name.contains("..") || name.contains('/') || name.contains('\\') {
                let _ = stream.write_all(b"HTTP/1.1 400 Bad Request\r\nContent-Length: 0\r\nConnection: close\r\n\r\n");
                return;
            }
            match std::fs::read(dir.join("pkg").join(name)) {
                Ok(body) => {
                    let resp = format!(
                        "HTTP/1.1 200 OK\r\nContent-Type: application/octet-stream\r\nContent-Length: {}\r\nConnection: close\r\n\r\n",
                        body.len()
                    );
                    let _ = stream.write_all(resp.as_bytes());
                    let _ = stream.write_all(&body);
                }
                Err(_) => {
                    let _ = stream.write_all(b"HTTP/1.1 404 Not Found\r\nContent-Length: 0\r\nConnection: close\r\n\r\n");
                }
            }
        });
    }
    Ok(())
}

/// One signed-index line: `<name> <version> <sha256-hex>`.
pub type IndexEntry = (String, String, String);

/// Parse index text (blank/`#` lines skipped).
pub fn parse_index_entries(text: &str) -> Vec<IndexEntry> {
    text.lines()
        .map(str::trim)
        .filter(|l| !l.is_empty() && !l.starts_with('#'))
        .filter_map(|l| {
            let mut it = l.split_whitespace();
            Some((
                it.next()?.to_string(),
                it.next()?.to_string(),
                it.next()?.to_string(),
            ))
        })
        .collect()
}

/// Load `(index_text, signature_hex)` from a registry.
/// Local reads `pkg/index.resid-idx` + `pkg/index.resid-sig`;
/// remote GETs `/pkg/index.resid-idx` + `-sig`.
pub fn load_signed_index(reg: &Registry) -> Result<(String, String), String> {
    fn split(body: Vec<u8>) -> String {
        String::from_utf8_lossy(&body).into_owned()
    }
    match reg {
        Registry::Local(dir) => {
            let idx = std::fs::read_to_string(dir.join("pkg").join("index.resid-idx"))
                .map_err(|e| format!("cannot read pkg/index.resid-idx: {e}"))?;
            let sig = std::fs::read_to_string(dir.join("pkg").join("index.resid-sig"))
                .map_err(|e| format!("cannot read pkg/index.resid-sig: {e}"))?;
            Ok((idx, sig.trim().to_string()))
        }
        Registry::Remote(base) => {
            let base = base.trim_end_matches('/');
            let idx = http_get(&format!("{base}/pkg/index.resid-idx")).map(|r| split(r.body))?;
            if !idx.contains("name ") && !idx.contains('\n') {
                return Err("registry index missing".into());
            }
            let sig = http_get(&format!("{base}/pkg/index.resid-sig")).map(|r| split(r.body))?;
            Ok((idx, sig.trim().to_string()))
        }
    }
}

/// Canonical index text from entries (sorted by name/version).
pub fn index_text(mut entries: Vec<IndexEntry>) -> String {
    entries.sort();
    let mut out = String::from("# resid registry index\n");
    for (n, v, h) in entries {
        out.push_str(&format!("{n} {v} {h}\n"));
    }
    out
}
