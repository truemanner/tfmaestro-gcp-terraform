#!/bin/bash
set -e

apt-get update -y
apt-get install -y mariadb-server

systemctl enable mariadb
systemctl start mariadb

# Konfiguracja bazy dla aplikacji tfmaestro
mysql -e "CREATE DATABASE IF NOT EXISTS tfmaestro CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -e "CREATE USER IF NOT EXISTS '${db_user}'@'%' IDENTIFIED BY '${db_password}';"
mysql -e "GRANT ALL PRIVILEGES ON tfmaestro.* TO '${db_user}'@'%'; FLUSH PRIVILEGES;"
