#!/bin/bash

# Program for named configuration
# named.sh

BCK=`date +"%m%d.%H%M"`
PROCESS="/etc/rc.d/init.d"
NAMED_CONF="/etc/named.conf"
#RESOLV_CONF="/etc/resolv.conf"
#NETWORK_FL="/etc/sysconfig/network"
#ETH0="/etc/sysconfig/network-scripts/ifcfg-eth0"

#[ -e $NETWORK_FL ] || exit 1
#[ -e $ETH0 ] || exit 1

#source $NETWORK_FL
#source $ETH0

HOST=`echo $HOSTNAME | awk -F"." {'print $1'}`
DOMAIN=`echo $HOSTNAME | awk -F"." {'print $2 "." $3'}`
IPADDR=`ifconfig eth0 | grep -w inet | awk -F " " {'print $2'} | awk -F":" {'print $2'} | awk -F"." {'print $1 "." $2 "." $3 "." $4'}`
#IP=`echo $IPADDR | awk -F= '{print $2}'`
REV_IP=`echo $IPADDR | awk -F"." '{print $3"."$2"."$1}'`
LAST_IP=`echo $IPADDR | awk -F"." '{print $4}'`
#NETWRK=`echo $IPADDR | awk -F"." '{print $1"."$2"."$3}'`

NAMED_FW="/var/named/$DOMAIN.forward"
NAMED_RV="/var/named/$DOMAIN.reverse"

echo "Name Server Setup...."
[ -e NAMED_FW ] && cp $NAMED_FW /tmp/$DOMAIN.forward.$BCK
[ -e NAMED_RV ] && cp $NAMED_RV /tmp/$DOMAIN.reverse.$BCK
[ -e $NAMED_CONF ] && cp $NAMED_CONF /tmp/named.conf.$BCK

cat <<EOF> $NAMED_CONF
options {
        directory "/var/named";
        dump-file "/var/named/data/cache_dump.db";
        statistics-file "/var/named/data/named_stats.txt";
        /*
         * If there is a firewall between you and nameservers you want
         * to talk to, you might need to uncomment the query-source
         * directive below.  Previous versions of BIND always asked
         * questions using port 53, but BIND 8.1 uses an unprivileged
         * port by default.
         */
         // query-source address * port 53;
};

//
// a caching only nameserver config
//
controls {
        inet 127.0.0.1 allow { localhost; } keys { rndckey; };
};

zone "." IN {
        type hint;
        file "named.ca";
};

zone "localdomain" IN {
        type master;
        file "localdomain.zone";
        allow-update { none; };
};

zone "localhost" IN {
        type master;
        file "localhost.zone";
        allow-update { none; };
};

zone "0.0.127.in-addr.arpa" IN {
        type master;
        file "named.local";
        allow-update { none; };
};

zone "0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa" IN {
        type master;
        file "named.ip6.local";
        allow-update { none; };
};

zone "255.in-addr.arpa" IN {
        type master;
        file "named.broadcast";
        allow-update { none; };
};

zone "0.in-addr.arpa" IN {
        type master;
        file "named.zero";
        allow-update { none; };
};

zone  "$DOMAIN" { 
	type master; 
	file  "$DOMAIN.forward"; 
        allow-update { none; };
};

zone  "$REV_IP.in-addr.arpa" { 
	type master; 
	file  "$DOMAIN.reverse"; 
        allow-update { none; };
};

include "/etc/rndc.key";
EOF


cat <<EOF> $NAMED_FW
\$TTL	86400
@		IN	SOA	@ root (
					42		; serial (d. adams)
					3H		; refresh
					15M		; retry
					1W		; expiry
					1D )		; minimum

		IN	NS	@
		IN	MX 	10 @
@		IN	A	$IPADDR
$HOST		IN	A	$IPADDR
local		IN	A	$IPADDR
remote		IN	A	$IPADDR
EOF


cat <<EOF> $NAMED_RV
\$TTL	86400
@       IN      SOA     $DOMAIN. root.$DOMAIN.  (
                                      1997022700 ; Serial
                                      28800      ; Refresh
                                      14400      ; Retry
                                      3600000    ; Expire
                                      86400 )    ; Minimum
              IN      NS      $DOMAIN.

$LAST_IP		IN	PTR	$DOMAIN.
EOF

$PROCESS/named restart

echo "Name Server Setup.... Done."
chkconfig named on
# Program ends

