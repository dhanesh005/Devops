#!/bin/bash
#read -p 'enter firstname.lastname : ' fn
cd /opt/zimbra/postfix/conf
#echo "${fn}@demandshore.com	local_only" 1>>restricted_senders
/opt/zimbra/postfix/sbin/postmap restricted_senders 
/opt/zimbra/postfix/sbin/postfix reload
exit
