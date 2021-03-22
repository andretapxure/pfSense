#!/bin/sh
#This script reads a simple text file (in this case, hosts) and gets the hosts info to call the pfbackup.sh script and make the backup of each firewall
while IFS=, read -r host user password desc
do
    echo "Backing up $host"
    ~/pfsense/pfbackup/pfbackup.sh $host $user $password $desc
done < ~/pfsense/pfbackup/hosts
