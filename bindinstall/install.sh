#!/bin/bash

echo "Which domain name would you like to configure with the named install?"
read domain

IP=`ifconfig | grep eth0 -C 1 | grep inet | awk '{print $2}'`

echo "$IP $domain" >> /etc/hosts

if grep -q "127.0.0.1" /etc/resolv.conf; then
        echo "already there"
else
        echo "nameserver 127.0.0.1" >> /etc/resolv.conf
fi


yum install bind bind-utils -y
sed -i "s/listen-on-v6/#listen-on-v6/g" /etc/named.conf
sed -i "s/ 127.0.0.1;/127.0.0.1; $IP;/g" /etc/named.conf



echo "zone \"$domain\" IN {   "  > /etc/named/zones.zone
echo "type master;"  >> /etc/named/zones.zone
echo 'file "/var/named/'"$domain.zone"\"';' >> /etc/named/zones.zone
echo 'allow-update { none; };' >> /etc/named/zones.zone
echo '};' >> /etc/named/zones.zone

echo 'include "/etc/named/zones.zone";' >> /etc/named.conf

sed -e "s/domain/$domain/g" -e "s/IP/$IP/g" -e "s/serial/`date +"%Y%m%d01"`/g" zonefile > /var/named/$domain.zone

systemctl enable named
systemctl start named
