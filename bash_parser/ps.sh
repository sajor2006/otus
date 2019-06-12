#!/bin/bash

pid=`cat /proc/*/status|grep ^Pid|awk '{print $2}'`

for i in $pid
do
if [ -e /proc/$i/status ]; then
	uid=`cat /proc/$i/status|grep ^Uid|awk '{print $2}'`
	uid=" `grep ":$uid:" /etc/passwd |awk -F":" '{print $1}'`"
	if [ ${#uid} -gt 7 ]; then
	uid=${uid:0:7}
fi
	else
		continue
fi

state=`cat /proc/$i/status|grep ^State|awk '{print $2}'`

comm=$(tr -d '\0' < /proc/$i/cmdline)

if [ "$comm" == ""  ]; then
	comm=$(tr -d '\0' < /proc/$i/comm)
fi


echo -e "$i\t"$uid"\t$state\t$comm"

done
