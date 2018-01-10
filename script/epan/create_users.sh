#!/bin/bash
set -x

INPUT=/root/epan/rahul.txt
ldif=/root/epan/users.ldif
template=/root/epan/template.ldif

while read line
do
        uname=`cut -d, -f1 <<<"$line"`
        full_name=`cut -d, -f2 <<<"$line"`
        echo
        echo -e "\t    User Name:- $uname"
        echo -e "\t    Full Name:- $full_name"
        echo -e "\tEmail Address:- $uname@epanchayat.co.in"
        userpass=`slappasswd -h {SSHA} -s $uname`
        echo -e "\t    User Pass:- $userpass"
        echo
        sed "s/UNAME/${uname}/g" $template|sed "s/FULL_NAME/${full_name}/g" >$ldif
        echo "userPassword: $userpass" >> $ldif
        echo
   #     ldapadd -h localhost -x -D "cn=Manager,dc=epanchayat,dc=co,dc=in" -f $ldif -w 'password'
        if [ $? -eq 0 ];then
         echo "$uname@epanchayat.co.in created successfully."
        else
         echo "FAILED to create $uname@epanchayat.co.in" >> /tmp/failed.txt
        fi
done<$INPUT |tee /tmp/status.log 2>&1
