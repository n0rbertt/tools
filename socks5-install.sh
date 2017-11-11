#!/bin/bash

# to get this installed on a fresh digitalocean VM, all I need to enter is : 
# yum install wget -y ; wget https://elaboratethinking.org/socks5-install.sh && chmod +x socks5-install.sh && ./socks5-install.sh 

#this installs the prereqs then my custom .bashrc , feel free to change it to yours. 
cd / && yum install wget gcc.x86_64 rpm-build.x86_64 openldap-devel.x86_64 pam-devel.x86_64 openssl-devel.x86_64 vim -y &&  cd ~ ; wget https://raw.githubusercontent.com/n0rbertt/main/master/.bashrc3 ; mv .bashrc3 .bashrc && source .bashrc && wget http://vault.centos.org/5.11/os/x86_64/CentOS/libgssapi-devel-0.10-2.x86_64.rpm && wget http://vault.centos.org/5.11/os/x86_64/CentOS/libgssapi-0.10-2.x86_64.rpm && wget http://downloads.sourceforge.net/ss5/ss5-3.8.9-8.src.rpm 

rpm -ivh libgssapi-0.10-2.x86_64.rpm 
rpm -ivh libgssapi-devel-0.10-2.x86_64.rpm 
rpmbuild --rebuild ss5-3.8.9-8.src.rpm
rpm -ivh /root/rpmbuild/RPMS/x86_64/ss5-3.8.9-8.x86_64.rpm
sed -i "7i export SS5_SOCKS_PORT=8899" /etc/init.d/ss5 && sed -i "8i export SS5_SOCKS_USER=root" /etc/init.d/ss5
sed -i "1i auth 0.0.0.0/0 - -" /etc/opt/ss5/ss5.conf && sed -i "2i permit - 0.0.0.0/0 - 0.0.0.0/0 - - - -" /etc/opt/ss5/ss5.conf
systemctl daemon-reload && systemctl restart ss5
