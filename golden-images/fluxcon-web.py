#!/usr/bin/env python3
"""Tiny in-guest HTTP endpoint for the FluxCon demo.

Answers every GET with the guest image version (baked into the golden image at
build time) and this VM's identity, so a curl through the pool Service shows
which VM, on which image, served the request.
"""
import http.server
import socket

VERSION = open("/etc/fluxcon/version").read().strip()


def identity():
    host = socket.gethostname()
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("192.0.2.1", 9))  # no packet is sent; picks the egress IP
        ip = s.getsockname()[0]
        s.close()
    except OSError:
        ip = "unknown"
    return host, ip


class Handler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        host, ip = identity()
        body = f"version={VERSION} guest={host} ip={ip}\n".encode()
        self.send_response(200)
        self.send_header("Content-Type", "text/plain")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, *args):
        pass


http.server.ThreadingHTTPServer(("0.0.0.0", 8080), Handler).serve_forever()
