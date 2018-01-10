#!/bin/bash
#####################################################################################
#                                                                                   #   
#            ********CREATED BY RAHUL KALE************                              #
#                                                                                   #
#####################################################################################
su - zimbra
zmproxyctl stop
zmmailboxdctl stop
exit

if [ -d "/tmp/letsencrypt" ]; then 
     
      cd /tmp/letsencrypt
     /opt/zimbra/postfix/sbin/sendmail techsupport@demandshore.com < /tmp/mail.txt

else 
     echo "Directory is not Present" >>/tmp/sslrenewlog.txt

fi

if [ -f "letsencrypt-auto"]; then
 
	letsencrypt-auto renew --standalone -d mailserv.qedbaton.com
	sleep 600
        echo "Certificate is Renewed successfully" >>/tmp/sslrenewlog.txt
else
        echo "Error in Renewing Certificate" >>/tmp/sslrenewlog.txt
fi  
if [ -d "/opt/zimbra/ssl/letsencrypt/"]; then

	cd /opt/zimbra/ssl/letsencrypt/
	cp /etc/letsencrypt/live/mailserv.qedbaton.com-0001/ .
	echo "Cetificate Copied successfully" >>/tmp/sslrenewlog.txt
else 

	echo "Cetificate Not Copied successfully" >>/tmp/sslrenewlog.txt

fi

sleep 2

if [ -f "/opt/zimbra/ssl/letsencrypt/cert.pem" ]; then

	chown zimbra:zimbra /opt/zimbra/ssl/letsencrypt/*
	echo "Permission Applied successfully" >>/tmp/sslrenewlog.txt
else
	echo "Error In Permission" >>/tmp/sslrenewlog.txt
fi
if [ -r "/opt/zimbra/ssl/letsencrypt/chain.pem"]; then

	cat RootCAX3.txt >> chain.pem
	/opt/zimbra/bin/zmcertmgr verifycrt comm privkey.pem cert.pem chain.pem
	echo "Certificate verified successfully" >>/tmp/sslrenewlog.txt
	sleep 3
	cp -a /opt/zimbra/ssl/zimbra /opt/zimbra/ssl/zimbra.$(date "+%Y%m%d")
	 echo "Old Backup done successfully" >>/tmp/sslrenewlog.txt
	/opt/zimbra/bin/zmcertmgr deploycrt comm cert.pem chain.pem
	echo "Certificate Renewed successfully" >>/tmp/sslrenewlog.txt
 	/opt/zimbra/postfix/sbin/sendmail techsupport@demandshore.com < /tmp/sslinstalled.txt
 su - zimbra
 zmcontrol restart
else
	echo " file is not readable" >>/tmp/sslrenewlog.txt 
	       	 /opt/zimbra/postfix/sbin/sendmail techsupport@demandshore.com < /tmp/sslnotinstalled.txt
fi
#sleep 60

#echo QUIT | openssl s_client -connect mailserv.qedbaton.com:443 | openssl x509 -noout -text >>
#########################################-!END!-#############################################################
