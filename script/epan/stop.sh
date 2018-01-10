#!/bin/bash
set -x
/etc/init.d/httpd stop
/etc/init.d/postfix stop
/etc/init.d/amavisd stop
/etc/init.d/dovecot stop
/etc/init.d/clamd stop
sleep 5
#/usr/sbin/slapcat -f /etc/openldap/slapd.conf > /home/backup/ldap/LDAP-latest1.ldif
/etc/init.d/ldap stop
#cd /var/lib
#tar -czvf ldap-cold-31-Oct-2011.tar.gz ldap
#sleep 5
#/etc/init.d/ldap start
