import http.server
import socketserver
import socket
import json
import sys


IP_ADDRESS = ''
PORT = 8001

class ConfirmationHandler(http.server.SimpleHTTPRequestHandler):
    def do_POST(self):
        data = json.loads(self.rfile.read(int(self.headers['Content-Length'])))
        print(f'Data received {data}')
        with open(f'device_data/{data["id"]}_data.json', 'w') as file:
            json.dump(data, file, indent=4)  
            
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.end_headers()
        self.wfile.write(json.dumps({'response': 'Export successful'}).encode())
        
    def do_GET(self):
        return

if __name__ == '__main__':
    httpd = socketserver.TCPServer((IP_ADDRESS, PORT), ConfirmationHandler)
    print('Serving at port 8001...')
    httpd.serve_forever()