#Daily Task for Demadshore Mail: BG
cd /var/log/
#Check messages
grep "error" messages -i
grep "warning" messages -i
grep "crit" messages -i
grep "kernel" messages -i 

#Check Mailog
grep "error" maillog -i
grep "warning" maillog -i
grep "crit" maillog -i

#Check Secure
grep "error" secure -i 
grep "warning" secure -i
grep "crit" secure -i

#HTTP
tail -50 /var/log/httpd/error_log

#Disk Space
df -h
