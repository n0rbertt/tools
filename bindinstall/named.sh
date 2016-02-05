#!/bin/bash

echo "Which domain name would you like to configure with the named install?"
read domain

echo "Which IP address would you like to configure this domain for?"
read IP

echo "$IP $domain" >> /etc/hosts
#ping -c 1 $domain

if grep -q "127.0.0.1" /etc/resolv.conf; then 
	echo "already there"
else
	echo "nameserver 127.0.0.1" >> /etc/resolv.conf
fi

echo "Would you like to add google's nameservers(8.8.8.8,8.8.4.4) to your server?" 
while true; do 
	read -p "Add Google's nameservers(8.8.8.8,8.8.4.4) to your server? [y/N]" yn
	case $yn in
	[Yy]* ) echo "nameserver 8.8.8.8" >> /etc/resolv.conf && echo "nameserver 8.8.4.4" >> /etc/resolv.conf ; break ;;
	[Nn]* ) echo "okay then, not adding Google's nameservers... I promise ;)" && exit ;;
	* ) echo "Please enter yes or no"
	esac
done 

yum install bind bind-utils -y
sed -i "s/listen-on-v6/#listen-on-v6/g" /etc/named.conf
sed -i "s/ 127.0.0.1;/127.0.0.1; any;/g" /etc/named.conf



echo "zone \"$domain\" IN {   "  > /etc/named/zones.zone
echo "type master;"  >> /etc/named/zones.zone
echo 'file "/var/named/'"$domain.zone"\"';' >> /etc/named/zones.zone
echo 'allow-update { none; };' >> /etc/named/zones.zone
echo '};' >> /etc/named/zones.zone

echo 'include "/etc/named/zones.zone";' >> /etc/named.conf

sed -e "s/domain/$domain/g" -e "s/IP/$IP/g" -e "s/serial/`date +"%Y%m%d01"`/g" zonefile > /var/named/$domain.zone

