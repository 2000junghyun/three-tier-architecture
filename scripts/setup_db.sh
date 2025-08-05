#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

apt update -y
apt install -y mysql-server

# MySQL remote 설정 허용 (보안 테스트용)
sed -i 's/bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

systemctl enable mysql
systemctl restart mysql

# 초기 사용자/DB 생성 예시
mysql -e "CREATE DATABASE appdb;"
mysql -e "CREATE USER 'admin'@'%' IDENTIFIED BY 'Changeme123!';"
mysql -e "GRANT ALL PRIVILEGES ON appdb.* TO 'admin'@'%';" # 실습용
mysql -e "FLUSH PRIVILEGES;"
