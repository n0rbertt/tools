#!/bin/bash

echo "Which domain name would you like to configure with the named install?"
read domain

echo "Which IP address would you like to configure this domain for?"
read ip

yum install bind bind-utils -y
sed -i "s/listen-on-v6/#listen-on-v6/g" /etc/named.conf
sed -i "s/ 127.0.0.1;/127.0.0.1; any;/g" /etc/named.conf



echo "zone \"$domain\" IN {   "  > /etc/named/zones.zone
echo "type master;"  >> /etc/named/zones.zone
echo 'file "/var/named/'"$domain.zone"\"';' >> /etc/named/zones.zone
echo 'allow-update { none; };' >> /etc/named/zones.zone
echo '};' >> /etc/named/zones.zone

echo 'include "/etc/named/zones.zone";' >> /etc/named.conf

sed -e "s/domain/$domain/g" -e "s/IP/$IP/g" -e "s/serial/`date +"%Y%m%d01"`/g" zonefile > /etc/named/$domain.zone
