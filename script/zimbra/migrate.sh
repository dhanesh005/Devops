#!/bin/bash

#USER=$1
DOMAIN="qedbaton.com"
SERVER1=192.168.5.44
SERVER2=192.168.5.6
PASSWORD1=L0g1x@321
PASSWORD2=L0g1x@4321

DATE=$(/bin/date +"%F_%H.%M%S")
TIMING=$(date)

IMAPLOG="$DOMAIN"_sync_"$DATE".log
IMAPLOG_DETAIL="$DOMAIN"_syncdetails_"$DATE".log

DATE=$(/bin/date +"%F_%H.%M")

/bin/echo -e "Start time: $TIMING\n\n" >> $IMAPLOG

#IFS==","
while IFS=="," read USER1 USER2;
do

echo "Processing $USER1 $USER2" 
echo "Processing $USER1 $USER2" >> $IMAPLOG

imapsync --pidfile /tmp/$USER1.pid --buffersize 8192000 --nosyncacls --subscribe --syncinternaldates --host1 $SERVER1 --user1 $USER1 --authuser1 admin@zimbra.qedbaton.local --authmech1 PLAIN  --password1 $PASSWORD1 --port1 143 --host2 $SERVER2 --user2 $USER1 --authuser2 admin@zimbra.qedbaton.local --password2 $PASSWORD2 --port2 143 --authmech2 PLAIN  --allowsizemismatch --useheader ALL --exclude 'Contacts' --exclude 'Calendar' --maxage 7 >> $IMAPLOG_DETAIL

##imapsync --pidfile /tmp/$1.pid --buffersize 8192000 --nosyncacls --subscribe --syncinternaldates --host1 $SERVER1 --user1 $USER --authuser1 admin@zimbra.qedbaton.local --authmech1 plain  --password1 $PASSWORD1 --ssl1 --port1 993 --host2 $SERVER2 --user2 $USER --authuser2 admin@zimbra.qedbaton.local --password2 $PASSWORD2 --port2 993 --authmech2 plain --ssl2 --allowsizemismatch --useheader ALL --exclude 'Contacts' --exclude 'Calendar' --delete2 >> $IMAPLOG_DETAIL

###imapsync --pidfile /tmp/$1.pid --buffersize 8192000 --nosyncacls --subscribe --syncinternaldates --host1 $SERVER1 --user1 $USER --authuser1 admin@zimbra.qedbaton.local --authmech1 plain  --password1 $PASSWORD1 --ssl1 --port1 993 --host2 $SERVER2 --user2 $USER --authuser2 admin@zimbra.qedbaton.local --password2 $PASSWORD2 --port2 993 --authmech2 plain --ssl2 --allowsizemismatch --useheader ALL --exclude 'Contacts' --exclude 'Calendar' --maxage 2 >> $IMAPLOG_DETAIL
done < $1


TIMING=$(date)

/bin/echo -e "End time: $TIMING\n\n" >> $IMAPLOG

