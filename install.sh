#!/bin/bash


echo "Which domain name would you like to use for the server?"
echo "----------------------------------------------"
read domainname
printf "\n"
echo "And for the hostname?"
echo "----------------------------------------------"
read hostname
printf "\n"

#echo "Would you like to use google nameservers"
while true; do
        read -p "Would you like to use google nameservers [Y/N]¿" yn
        case $yn in
        [Yy]* ) printf "\n  ..........." &&  printf "\n fixing nameservers \n ........... \n" && sed -i '3 i nameserver 8.8.8.8 \nnameserver 8.8.4.4' /etc/resolv.conf  && chattr +i /etc/resolv.conf ; break ;;
        [Nn]* ) echo " ☹  ;)" && exit ;;
        * ) echo "Please enter Yes or No"
        esac
done


hostnamectl set-hostname $hostname && echo "$hostname" > /etc/hostname && chattr +i /etc/hostname && printf "\n\n" &&  hostname


printf "\n  \n ........... \n" &&  printf "\n INSTALLING SOFTWARE \n ........... \n" && yum install -y epel-release lvm2 yum-utils bind-utils net-tools wget bzip2 vim nmap mlocate p7zip p7zip-plugins jwhois screen git > /dev/null  ;
printf "\n updating packages \n ........... \n"  && yum update -y > /dev/null && printf "\n fixing  bashrc \n ........... \n" &&  cd ~ ;  cd ~ ; wget https://raw.githubusercontent.com/n0rbertt/main/master/.bashrc3 ; mv .bashrc3 .bashrc   && printf "\n \n ........... \n updating db \n ........... \n" && updatedb  && printf "\n \n ........... \n"

yum update -y > /dev/null



#echo "Would you like escalated privileges¿"
while true; do
        read -p "Would you like escalated privileges¿ [Y/N]" yn
        case $yn in
        [Yy]* ) user=`last | awk '{print $1}' | head -n1` && sed -i "99 i  $user ALL=(ALL)       NOPASSWD: ALL" /etc/sudoers && printf "\n\n" && echo "     Congratz" && printf "\n\n" && grep n0rbertt -B3 /etc/sudoers && printf "\n\n"  grep $user -n2 /etc/sudoers ; break ;;
        [Nn]* ) echo "okay then, your loss ☹  ;)" && exit ;;
        * ) echo "Please enter Yes or No"
        esac
done
