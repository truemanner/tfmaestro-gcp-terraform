#!/bin/bash
apt-get update -y
apt-get install -y python3 python3-pip

mkdir -p /opt/app

cat << 'EOF' > /opt/app/app.py
from flask import Flask
app = Flask(__name__)
@app.route("/")
def hello():
    return "hello tfmaestro"
app.run(host="0.0.0.0", port=8080)
EOF

pip3 install flask

cat << 'EOF' > /etc/systemd/system/tfmaestro.service
[Unit]
Description=tfmaestro python app
After=network.target

[Service]
ExecStart=/usr/bin/python3 /opt/app/app.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reexec
systemctl daemon-reload
systemctl enable tfmaestro
systemctl start tfmaestro
