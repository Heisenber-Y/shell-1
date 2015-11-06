######################################################################
# Copyright C 2014 CFETS Financial Data Co.,LTD                      #
# All rights reserved                                                #
# Name: comstp.sh
# Author: Canux chengwei@chinamoney.com.cn                           #
# Version: V1.0                                                      #
# Time: Thu 06 Nov 2014 04:31:19 PM CST
# Description:                                                       #
######################################################################
#!/bin/bash

SSHPASS=/export/home/fis/bin/sshpass
COMSTPPW=******
DIR=/export/home/fis/other/monitor
echo "" > $DIR/comstp.dat

    STR=Tomcat
    VAR=`$SSHPASS -p $COMSTPPW ssh comstp@192.168.6.1 "ps -fu comstp | grep -v grep | grep $STR"`
    PID=`echo $VAR | awk 'NR==1 {print $2}'`
    if [[ $PID = "" ]]
    then
        echo "N $STR" > $DIR/comstp.dat  
    fi

    STR=monitor
    VAR=`$SSHPASS -p $COMSTPPW ssh comstp@192.168.6.1 "ps -fu comstp | grep -v grep | grep $STR"`
    PID=`echo $VAR | awk 'NR==1 {print $2}'`
    if [[ $PID = "" ]]
    then
        echo "N $STR" >> $DIR/comstp.dat  
    fi

    STR=cframe
    VAR=`$SSHPASS -p $COMSTPPW ssh comstp@192.168.6.1 "ps -fu comstp | grep -v grep | grep $STR"`
    PID=`echo $VAR | awk 'NR==1 {print $2}'`
    if [[ $PID = "" ]]
    then
        echo "N $STR" >> $DIR/comstp.dat  
    fi

    STR=server
    NUM=`$SSHPASS -p $COMSTPPW ssh comstp@192.168.6.1 "ps -fu comstp | grep jsvc | grep -v grep | grep err.log | wc -l"`
    if [[ $NUM -ne 2 ]]
    then
        echo "N $STR" >> $DIR/comstp.dat  
    fi

    STR=local
    NUM=`$SSHPASS -p $COMSTPPW ssh comstp@192.168.6.1 "ps -fu comstp | grep jsvc | grep -v grep | grep local | wc -l"`
    FILE=`$SSHPASS -p $COMSTPPW ssh comstp@192.168.6.1 "ls -l |  grep ^d | grep comstp_local | grep -v grep | wc -l"`
    FNUM=`expr $FILE \* 2`
    if [[ $NUM -ne $FNUM ]]
    then
        echo "N $STR $NUM $FNUM" >> $DIR/comstp.dat  
    fi
