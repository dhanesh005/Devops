#!/bin/bash
########################################################
#Script is Used to backup Mail Sever                  #
#Script Created By Rahul Kale                          #
########################################################
rm -f /tmp/backup.txt
echo "Starting Backup on `date`" > /tmp/backup.txt
cd /Backup/7days/
tar -czf 7days-`date +%a-%d-%b-%Y`.tar.gz /Backup/7days/Mail-`date +%a-%d-%b-%Y`/
if [ $? -eq 0 ]
then
 rm -f /Backup/7days/7days-`date +%a-%d-%b-%Y --date='7 day ago'`.tar.gz
 rm -f /Backup/7days/7days-`date +%a-%d-%b-%Y --date='8 day ago'`.tar.gz
 rm -f /Backup/7days/7days-`date +%a-%d-%b-%Y --date='9 day ago'`.tar.gz
 rm -f /Backup/7days/7days-`date +%a-%d-%b-%Y --date='10 day ago'`.tar.gz
 rm -f /Backup/7days/7days-`date +%a-%d-%b-%Y --date='11 day ago'`.tar.gz
 echo "" >> /tmp/backup.txt
 echo "-----------------------------------------------------------------------------------------------------" >> /tmp/backup.txt
 echo "Backup of Mails Completed at `date` and 7 days old backup deleted Successfully." >> /tmp/backup.txt
 echo "-----------------------------------------------------------------------------------------------------" >> /tmp/backup.txt
else
 echo "--------------------------------------------------------------------------" >> /tmp/backup.txt
 echo "Email Backup of Demandshore Mails failed." >> /tmp/backup.txt
 echo "--------------------------------------------------------------------------" >> /tmp/backup.txt
/opt/zimbra/postfix/sbin/sendmail rahul.kale@demandshore.com < /tmp/backup.txt
#mail -s "Demandshore Mail Server Backup Failed" rahul.kale@demandshore.com < /tmp/backup.txt
fi
