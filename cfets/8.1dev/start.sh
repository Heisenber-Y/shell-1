#!/bin/bash
#
#Copyright c 2014   CFETS Financial Data Co.,LTD 
#All rights reserved.
#192.168.8.1:/export/home/start.sh
#v1.0
#writen by canux chengwei@chinamoney.com.cn
#start limit.sh and monitor.sh 


PID=`ps -fu user | grep -v grep | grep limit.sh | awk '{ print $2 }'`
if [[ ! $PID = "" ]]
then
    kill -9 $PID
fi

/export/home/limit.sh 

exit
