#!/bin/bash
#INSTALAÇÃO DO ZABBIX


ZTMP="/tmp/zabbix"
ZUSER="zabbix"
ZWEBDIR="/var/www/html/zabbix"
ZPWD="zabbix"


mkdir $ZTMP
cd $ZTMP
wget -q http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX
rpm --import RPM-GPG-KEY-ZABBIX

wget http://repo.zabbix.com/zabbix/2.4/rhel/6/x86_64/zabbix-release-2.4-1.el6.noarch.rpm
rpm -ivh zabbix-release-2.4-1.el6.noarch.rpm

yum install zabbix-server-mysql zabbix-web-mysql zabbix-agent mysql-server httpd -y


service mysqld start


echo "create database zabbix character set utf8 collate utf8_bin;" | mysql
echo "grant all privileges on zabbix.* to zabbix@localhost identified by zabbix;" | mysql

cd /usr/share/doc/zabbix-server-mysql-2.4.6/create
mysql -uroot zabbix < schema.sql
mysql -uroot zabbix < images.sql
mysql -uroot zabbix < data.sql


sed -i 's/;date.timezone =/date.timezone = America\/Bahia/' /etc/php.ini
sed -i 's/    # php_value date.timezone Europe\/Riga/    php_value data.timezone America\/Bahia/' /etc/httpd/conf.d/zabbix.conf
cp -f /usr/share/zoneinfo/America/Bahia /etc/localtime

service httpd restart

chkconfig mysqld on
chkconfig httpd on

echo "instalado com sucesso ---"
