# -*- coding: utf-8 -*-
"""
QGIS Server HTTP wrapper

This script launches a QGIS Server listening on port 8081 or on the port
specified on the environment variable QGIS_SERVER_DEFAULT_PORT

.. note:: This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.
"""
from __future__ import print_function
from future import standard_library
standard_library.install_aliases()

__author__ = 'Alessandro Pasotti'
__date__ = '05/15/2016'
__copyright__ = 'Copyright 2016, The QGIS Project'
# This will get replaced with a git SHA1 when you do a git archive
__revision__ = '$Format:%H$'


import os
import urllib.parse
from http.server import BaseHTTPRequestHandler, HTTPServer
from qgis.server import QgsServer

try:
    QGIS_SERVER_DEFAULT_PORT = int(os.environ['QGIS_SERVER_DEFAULT_PORT'])
except KeyError:
    QGIS_SERVER_DEFAULT_PORT = 8081

qgs_server = QgsServer()


class Handler(BaseHTTPRequestHandler):

    def do_GET(self):
        # CGI vars:
        for k, v in self.headers.items():
            qgs_server.putenv('HTTP_%s' % k.replace(' ', '-').replace('-', '_').replace(' ', '-').upper(), v)
        qgs_server.putenv('SERVER_PORT', str(self.server.server_port))
        qgs_server.putenv('SERVER_NAME', self.server.server_name)
        qgs_server.putenv('REQUEST_URI', self.path)
        parsed_path = urllib.parse.urlparse(self.path)
        headers, body = qgs_server.handleRequest(parsed_path.query)
        headers_dict = dict(h.split(': ', 1) for h in headers.decode().split('\n') if h)
        try:
            self.send_response(int(headers_dict['Status'].split(' ')[0]))
        except:
            self.send_response(200)
        for k, v in headers_dict.items():
            self.send_header(k, v)
        self.end_headers()
        self.wfile.write(body)
        return

    def do_POST(self):
        content_len = int(self.headers.get('content-length', 0))
        post_body = self.rfile.read(content_len).decode()
        request = post_body[1:post_body.find(' ')]
        self.path = self.path + '&REQUEST_BODY=' + \
            post_body.replace('&amp;', '') + '&REQUEST=' + request
        return self.do_GET()


if __name__ == '__main__':
    server = HTTPServer(('localhost', QGIS_SERVER_DEFAULT_PORT), Handler)
    print('Starting server on localhost:%s, use <Ctrl-C> to stop' %
          QGIS_SERVER_DEFAULT_PORT)
    server.serve_forever()
