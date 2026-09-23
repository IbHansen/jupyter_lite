"""Serve the built JupyterLite site in dist/ on http://127.0.0.1:8000/

Why not "jupyter lite serve": its tornado handler only adds index.html when the
url ends with a slash, so File > Open - which goes to /tree - answers
"HTTP 403: Forbidden (tree is not a file)". Pythons http.server redirects /tree
to /tree/ by itself, like GitHub Pages does, so the site behaves as when it is
deployed.

The mime types are taken from the fileTypes of dist/jupyter-lite.json, the same
ones "jupyter lite serve" uses, because the windows registry has bad types for
.js and does not know .wasm.

Usage: python serve_dist.py [port]
"""

import functools
import http.server
import json
import mimetypes
import socketserver
import sys
from pathlib import Path

PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 8000
DIST = Path(__file__).parent / 'dist'

# for the types which are not in jupyter-lite.json
FALLBACK = {'.html': 'text/html', '.css': 'text/css', '.js': 'text/javascript',
            '.mjs': 'text/javascript', '.json': 'application/json',
            '.map': 'application/json', '.wasm': 'application/wasm',
            '.svg': 'image/svg+xml', '.png': 'image/png', '.ico': 'image/x-icon',
            '.woff': 'font/woff', '.woff2': 'font/woff2', '.ttf': 'font/ttf',
            '.txt': 'text/plain', '.whl': 'application/octet-stream',
            '.zip': 'application/zip', '.ipynb': 'application/json'}


def set_mime_types():
    '''The mime types of the site, add_type wins over the windows registry'''
    mimetypes.init(files=[])
    for ext, mime in FALLBACK.items():
        mimetypes.add_type(mime, ext)
    try:
        config = json.loads((DIST / 'jupyter-lite.json').read_text(encoding='utf-8'))
        file_types = config['jupyter-config-data'].get('fileTypes', {})
    except Exception as e:
        print(f'No fileTypes from jupyter-lite.json: {e}')
        return
    for file_type in file_types.values():
        for ext in file_type.get('extensions', []):
            mimetypes.add_type(file_type['mimeTypes'][0], ext)


class Server(socketserver.TCPServer):
    allow_reuse_address = True   # so a restart does not wait for the old socket


if not (DIST / 'index.html').exists():
    sys.exit(f'There is no site in {DIST}, run build.cmd first')

set_mime_types()
handler = functools.partial(http.server.SimpleHTTPRequestHandler, directory=str(DIST))

print(f'\nServing {DIST}\non http://127.0.0.1:{PORT}/\n\nExit by pressing Ctrl+C\n')
with Server(('127.0.0.1', PORT), handler) as httpd:
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print('\nStopped')
