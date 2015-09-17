######################################################################
# Copyright C 2014 CFETS Financial Data Co.,LTD                      #
# All rights reserved                                                #
# Name: monitor.sh
# Author: Canux chengwei@chinamoney.com.cn                           #
# Version: V1.0                                                      #
# Time: Thu 06 Nov 2014 04:31:19 PM CST
# Description:                                                       #
######################################################################
#!/bin/bash

    DIR=/export/home/inter/other/monitor
    echo "" > $DIR/pro.dat

    STR=ccbwmsfm.jar
    PID=`ps -fu inter | grep -v grep | grep $STR | awk '{print $2}'`
    if [[ $PID = "" ]]
    then
        echo "N $STR" > $DIR/pro.dat 
    fi
exit
