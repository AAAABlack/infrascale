
#!/usr/bin/env python3

"""
InfraScale Health Check Service
Serves a simple JSON status endpoint.
"""

from http.server import HTTPServer, BaseHTTPRequestHandler
import json
import socket
import datetime
import os


class HealthHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/health':
            payload = {
                "status": "ok",
                "hostname": socket.getfqdn(),
                "timestamp": datetime.datetime.utcnow().isoformat() + "Z",
                "service": "infrascale-health",
                "version": os.getenv("INFRASCALE_VERSION", "1.0.0")
            }

            body = json.dumps(payload, indent=2).encode()

            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)
        else:
            self.send_error(404)

    def log_message(self, format, *args):
        # Output to stdout so journald captures it
        print(
            f"[{datetime.datetime.utcnow().isoformat()}] "
            f"{self.address_string()} - {format % args}",
            flush=True
        )


if __name__ == "__main__":
    port = int(os.getenv("HEALTH_PORT", "8081"))  # changed default to 8081
    server = HTTPServer(("0.0.0.0", port), HealthHandler)

    print(f"InfraScale Health service starting on port {port}", flush=True)
    server.serve_forever()
