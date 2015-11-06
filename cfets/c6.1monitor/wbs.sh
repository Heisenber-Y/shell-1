######################################################################
# Copyright C 2014 CFETS Financial Data Co.,LTD                      #
# All rights reserved                                                #
# Name: wbs.sh
# Author: Canux chengwei@chinamoney.com.cn                           #
# Version: V1.0                                                      #
# Time: Thu 06 Nov 2014 04:31:19 PM CST
# Description:                                                       #
######################################################################
#!/bin/bash

SSHPASS=/export/home/fis/bin/sshpass
WBSPW=wbs-c=wbs
DIR=/export/home/fis/other/monitor
echo "" > $DIR/wbs.dat
    STR=wbs_server
    VAR=`$SSHPASS -p $WBSPW ssh wbs@192.168.6.1 "ps -fu wbs | grep -v grep | grep $STR"`
    PID=`echo $VAR | awk 'NR==1 {print $2}'`
    if [[ $PID = "" ]]
    then
        echo "N $STR" >  $DIR/wbs.dat 
    fi
