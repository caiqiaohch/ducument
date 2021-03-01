#!/bin/bash 
# This script run at 00:00 
# The Nginx logs path 
#logs_path="/usr/local/nginx/logs/" 
logs_path="/home/wwwlogs/"
mkdir -p ${logs_path}$(date -d "yesterday" +"%Y")/$(date -d "yesterday" +"%m") 
mv ${logs_path}access.log ${logs_path}$(date -d "yesterday" +"%Y")/$(date -d "yesterday" +"%m")/access_$(date -d "yesterday" +"%Y%m%d").log 
#kill -USR1 `cat /usr/local/nginx/log/nginx.pid`
/usr/local/nginx/sbin/nginx -s reload