#!/bin/sh
####################################
#Zimbra Backup Script
####################################
echo "QeD rsync started for zimbra mail server data sync from 192.168.5.6 to 192.168.5.59"
touch /home/jay_rsync_$(date +%d%m%y).txt
touch /home/qed_rsync_$(date +%d%m%y).log
su - zimbra -c "/opt/zimbra/bin/zmcontrol stop"
#echo "Hello, zimbra services are stopped on live server and script started at :" > /home/jay_rsync_$(date +%d%m%y).txt
#sleep 10s
su - zimbra -c "/opt/zimbra/libexec/zmslapcat /home/ldap-bkp/"
#sleep 20s
echo "Hello, zimbra ldap backup is taken in current and backup server at /home/ldap-bkp/ :" >> /home/jay_rsync_$(date +%d%m%y).txt
scp /home/ldap-bkp/* root@192.168.5.59:/home/ldap-bkp/
date >> /home/jay_rsync_$(date +%d%m%y).txt
rsync -avH -e ssh --delete -i /opt/zimbra/ root@192.168.5.59:/opt/zimbra/ > /home/qed_rsync_$(date +%d%m%y).log
echo "Hello, zimbra services started and script ended at :" >> /home/jay_rsync_$(date +%d%m%y).txt
su - zimbra -c "/opt/zimbra/bin/zmcontrol start"
date >> /home/jay_rsync_$(date +%d%m%y).txt
echo "Find rsync logs at /home/qed_rsync_$(date +%d%m%y).log"
cat /home/jay_rsync_$(date +%d%m%y).txt
