#!/bin/bash

sudo wget https://repo.zabbix.com/zabbix/6.3/debian/pool/main/z/zabbix-release/zabbix-release_6.3-3%2Bdebian11_all.deb
sudo dpkg -i zabbix-release_6.3-3+debian11_all.deb 
sudo apt update

sudo apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent
sudo systemctl reload apache2
sudo apt install git curl php-curl mc htop -y


sudo mysql -uroot -e "create database zabbix character set utf8 collate utf8_bin;"
sudo mysql -uroot -e "grant all privileges on zabbix.* to zabbix@localhost identified by 'I8gxwRXtohGFum8K5fSR';"
sudo mysql -uroot -e "FLUSH PRIVILEGES;"
sudo mysql -uroot -e "quit"

sudo zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | sudo mysql --default-character-set=utf8mb4 -uzabbix zabbix -pI8gxwRXtohGFum8K5fSR

sudo git clone https://github.com/slacktopuss/zabbix-alerts.git /usr/lib/zabbix/alertscripts
sudo chown -R zabbix:root /usr/lib/zabbix/alertscripts

sudo curl -o /etc/zabbix/zabbix_server.conf 'https://denis.ml/zabbix-server/zabconf/zabbix_server.conf'
sudo curl -o /etc/zabbix/apache.conf 'https://denis.ml/zabbix-server/zabconf/apache.conf'

sudo chown -R zabbix:root /etc/zabbix/zabbix_server.conf
sudo chown -R zabbix:root /etc/zabbix/apache.conf

sudo service apache2 restart
sudo service zabbix-server start
sudo update-rc.d zabbix-server enable