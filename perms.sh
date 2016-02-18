#!/bin/bash
# Permissions / Ownership Fix by Perk
# v.01  - 11/29/08 - Original
# v.02  - 3/24/09 - Added /home protection
# v.03  - 3/25/09 - Added /home/<username> fix
# v.04  - 4/1/09  - Added /home/$username/ chown fix
# v.05  - 4/1/09  - Added Full File System Protection
# v.06  - 4/21/09 - Added /etc/ fix + fixes for shadow, passwd and quota files in addon domains
# v.07  - 4/22/09 - Added public_html check
# v.08  - 6/30/09 - Re-ordered for 'find' issue
# v.09  - 7/09/09 - Final fix (hopefully) before major cleanup
# v.091 - 8/24/09 - Added user check
# v.092 - 9/15/09 - Added Mail Perms
# v.093 - 9/30/09 - Added FCGI Fix
# v.094 - 11/4/09 - Fixed .htpasswd order
# v.095 - 3/11/10 - Fixed /etc/<domain> ownerships
# v.096 - 3/11/10 - Fixed shadow perms
# v.097	- 7/06/10 - Fixed .fantasticodata dir perms
# v.098 - 7/30/10 - Added DSO PHP Configuration Check
# v.099 - 8/16/10 - Added addon domain check
# v.0991 - 9/14/10 - Prepped for Auto-Update and /root/bin addition

SC="Permissionairy"
VSN=".0991"
UN=$(pwd | cut -d / -f3)

print() { printf "[${blue}+${NC}] $* \n" ; }

declare -x blue='\e[0;34m'
declare -x NC='\e[0m'

error() {
                print "If you believe this to be an error, please email jacob.perkins@arvixe.com"
		print "with details of the errors, what you did, and how he can get the error"
                print "and when he stops drinking, he will fix this bad-boy up"
		quit
}

quit() {
	print "[Peace, I'm outtie!]" 
	echo $1
	exit 2
}

pre_checks() {
        print "$SC $VSN By Perk"
        #DSO Check
        if [[ $(/usr/local/cpanel/bin/rebuild_phpconf --current | grep dso) =~ "PHP[4-5][ \t]+SAPI:[ \t]dso" ]]; then
                print "ALERT!  This server is DSO.  Do not run this script with this PHP Configuration"
                error
	fi
        if [[ $(pwd) =~ "^(/root|/bin|/usr|/var|/boot|/tmp|/dev|/home$)" ]]; then
                print "You are in $(pwd).  Do not run this script here " 
		error
	fi
}

user_check() {
        if [ ! -f /var/cpanel/users/${UN} ]; then
                print "User doesn't exist, exiting"
                error
        fi
}

public_html_check(){
	if [ ! -d /home/${UN}/public_html ]; then
	print "Public_html doesn't exist, creating it"
                mkdir /home/${UN}/public_html; fi
}


public_html_perms(){
       cd /home/${UN}/public_html
        print "Fixing 755 Permissions in /home/${UN}/public_html"
                find -type d -exec chmod 755 '{}' \;
        print "Fixing 644 Permissions in /home/${UN}/public_html"
                find -type f -exec chmod 644 '{}' \;
        print "Fixing Executable Permissions in /home/${UN}/public_html"
                find -iname "*.pl" -exec chmod 755 '{}' \; -o -iname "*.cgi" -exec chmod 755 '{}' \; -o -iname "*.fcgi" -exec chmod 755 '{}' \;
        print "Chowning"
                chown ${UN}. -R .
}


htpass_fix(){
	if [ -d /home/${UN}/.htpasswds ]; then
                print "Fixing ${UN}'s .htpasswds file & Misc"
                chown ${UN}.nobody /home/${UN}/.htpasswds && chmod 750 /home/${UN}/.htpasswds
        fi
}


home_fix(){
        print "Fixing ${UN}'s public_html and home Folder"
                chmod 711 /home/${UN}
                chown ${UN}.${UN} /home/${UN} -R > /dev/null 2>&1
                chmod 750 /home/${UN}/public_html
                chown ${UN}.nobody /home/${UN}/public_html
        if [ ! -L /home/${UN}/www ]; then
                cd /home/${UN}
                print "Fixing ${UN}'s www Symlink"
                ln -s public_html www
        fi
}


pass_shadow_quota_fix(){
	print "Fixing /home/${UN}/etc/* passwd, shadow and quota files"
                chown ${UN}.mail /home/${UN}/etc/
		find /home/${UN}/etc/ -maxdepth 1 -type d -exec chown ${UN}.mail '{}' \;
		chown ${UN}.${UN} /home/${UN}/etc/quota > /dev/null 2>&1 && chmod 644 /home/${UN}/etc/quota > /dev/null 2>&1
		chown ${UN}.mail /home/${UN}/etc/shadow > /dev/null 2>&1 && chmod 600 /home/${UN}/etc/shadow > /dev/null 2>&1
                chown ${UN}.mail /home/${UN}/etc/passwd > /dev/null 2>&1 && chmod 644 /home/${UN}/etc/passwd > /dev/null 2>&1
	for shad in `ls /home/${UN}/etc/*/shadow`;do
                        chown ${UN}.mail $shad && chmod 640 $shad; done > /dev/null 2>&1
        for quot in `ls /home/${UN}/etc/*/quota` ;do
                        chown ${UN}.${UN} $quot && chmod 644 $quot; done > /dev/null 2>&1
        for pawd in `ls /home/${UN}/etc/*/passwd`;do
                        chown ${UN}.mail $pawd && chmod 644 $pawd; done > /dev/null 2>&1
}


fix_mail_perms(){
	print "Fixing Mail Perms for ${UN}"
	/scripts/mailperm ${UN} > /dev/null 2>&1
}

fix_fantastico_perms(){
	if [ -d /home/${UN}/.fantasticodata ]; then
	print "Fixing Fantastico Perms"
	cd /home/${UN}/.fantasticodata
	find -type d -exec chmod 750 {} \;
	fi
}

fix_addon_docroot(){
        print "Fixing Domain doc_root's"
        for addonroot in $(grep "/home/${UN}" "/usr/local/apache/conf/httpd.conf" | grep DocumentRoot | awk '{print $2}');do
                if [[ -d ${addonroot} ]]; then
			if [[ ${addonroot} != $PUB_HTML ]]; then
		                chmod 755 ${addonroot} > /dev/null 2>&1
                	fi
		fi
        done
}


pre_checks
user_check
public_html_check
public_html_perms
home_fix
htpass_fix
pass_shadow_quota_fix
fix_fantastico_perms
fix_mail_perms
fix_addon_docroot
quit
