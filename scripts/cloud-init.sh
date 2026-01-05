#!/bin/bash
set -e

apt-get update -y
apt-get install -y python3 python3-pip

mkdir -p /opt/app

cat << 'EOF' > /opt/app/app.py
from flask import Flask, jsonify
from sqlalchemy import create_engine, text
import os

app = Flask(__name__)


def _build_database_url() -> str:
    url = os.environ.get("DATABASE_URL")
    if url:
        return url

    user = os.environ.get("DB_USER", "root")
    password = os.environ.get("DB_PASSWORD", "")
    host = os.environ.get("DB_HOST", "127.0.0.1")
    port = os.environ.get("DB_PORT", "3306")
    name = os.environ.get("DB_NAME", "tfmaestro")

    return f"mysql+pymysql://{user}:{password}@{host}:{port}/{name}"


DATABASE_URL = _build_database_url()
engine = create_engine(DATABASE_URL, future=True)


@app.route("/")
def hello():
    return "hello tfmaestro"


@app.route("/db-status")
def db_status():
    try:
        with engine.connect() as conn:
            result = conn.execute(text("SELECT 1"))
            value = result.scalar_one()
        return jsonify({"status": "ok", "result": value})
    except Exception as exc:
        return jsonify({"status": "error", "error": str(exc)}), 500


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
EOF

pip3 install flask sqlalchemy pymysql

cat << 'EOF' > /etc/systemd/system/tfmaestro.service
[Unit]
Description=tfmaestro python app
After=network.target

[Service]
Environment="DB_HOST=tfmaestro-db" "DB_USER=${db_user}" "DB_PASSWORD=${db_password}" "DB_NAME=tfmaestro"
ExecStart=/usr/bin/python3 /opt/app/app.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reexec
systemctl daemon-reload
systemctl enable tfmaestro
systemctl start tfmaestro
