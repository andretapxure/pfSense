#!/bin/bash
#This script is the actual backup script. It can be called standalone passing the four parameters bellow. The original script is https://github.com/mintsoft/PFSense-CURL-Backup

hostname=$1;
username=$2;
password=$3;
description=$4;

([ -z "$hostname" ] || [ -z "$username" ] || [ -z "$password" ]) && echo "all 3 arguments must be specified: hostname username password " && exit 1;

csrf=$(curl -Ss --insecure --cookie-jar /tmp/$hostname-cookies.txt https://$hostname/diag_backup.php | sed -n 's/.*name=.__csrf_magic. value="\([^"]*\)".*/\1/p');
csrf2=$(curl -Ss --insecure --location --cookie-jar /tmp/$hostname-cookies.txt --cookie /tmp/$hostname-cookies.txt --data "login=Login&usernamefld=$username&passwordfld=$password&__csrf_magic=$csrf" https://$hostname/diag_backup.php | sed -n 's/.*var csrfMagicToken = "\([^"]*\)".*/\1/p');

backupfile=config-$4-`date +%Y%m%d%H%M%S`.xml;
backupdir=/backup/solid/pfsense

curl -Ss --insecure --cookie /tmp/$hostname-cookies.txt --cookie-jar /tmp/$hostname-cookies.txt --data "download=download&donotbackuprrd=yes&__csrf_magic=$csrf2" https://$hostname/diag_backup.php > $backupdir/$backupfile;

grep --silent '^<?xml ' $backupdir/$backupfile || echo "Downloaded file is not XML; is probably broken."

rm /tmp/$hostname-cookies.txt;
