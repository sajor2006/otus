#!/bin/bash
loc=/tmp/loc
tmp=/opt/log.tmp
touch $tmp
if ( set -o noclobber; echo "$$" > "$loc") 2>/dev/null; then
        trap 'rm -f "$loc"; exit $?' INT TERM EXIT
        
        awk -F\" '{print $1}' /var/log/httpd/access*log | awk '{print $1}' | sort | uniq -c | sort -nr
        awk -F\" '{print $2}' /var/log/httpd/access*log | awk '{print $2}' | sort | uniq -c | sort -nr
        awk -F\" '{print $3}' /var/log/httpd/access*log | awk '{print $1}' | sort | uniq -c | sort -nr
        echo `awk -F\" '{print $1}' /var/log/httpd/access_log |awk '{print $4}'|sed -e 's/\[//g' -e 's/\// /g' -e "/:/s/:/ /" -e '$!D'` > $tmp
else
        echo 'started'
fi
