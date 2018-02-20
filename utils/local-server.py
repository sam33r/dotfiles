"""This binary runs a simple http server only accessible on localhost by default

Usage:
  $ cd dir
  $ python local-server.py 8000          # Serve dir on port 8000.
  $ python local-server.py 0.0.0.0:8000  # Allow access from other locations.
"""

import sys
from SimpleHTTPServer import SimpleHTTPRequestHandler
import BaseHTTPServer


def serve(HandlerClass=SimpleHTTPRequestHandler,
          ServerClass=BaseHTTPServer.HTTPServer):

  protocol = "HTTP/1.0"
  host = "127.0.0.1"
  port = 8000
  if len(sys.argv) > 1:
    arg = sys.argv[1]
    if ":" in arg:
      host, port = arg.split(":")
      port = int(port)
    else:
      try:
        port = int(sys.argv[1])
      except:
        host = sys.argv[1]

  server_address = (host, port)

  HandlerClass.protocol_version = protocol
  httpd = ServerClass(server_address, HandlerClass)

  sa = httpd.socket.getsockname()
  print "Serving HTTP on", sa[0], "port", sa[1], "..."
  httpd.serve_forever()


if __name__ == "__main__":
  serve()
