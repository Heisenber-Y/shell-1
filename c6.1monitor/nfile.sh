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

TODAY=`date +%Y%m%d`

DIR=/export/home/inter/jkdata
DIR1=/export/home/inter/jkdata/backup

NFILE=$DIR/END_KEY_5_${TODAY}_N.dat
NFILE1=$DIR1/END_KEY_5_${TODAY}_N.dat

DAT=/export/home/inter/other/monitor/nfile.dat

    echo "" > $DAT 
    if [[ -e $NFILE ]] || [[ -e $NFILE1 ]]
    then
        NFLAG=Y
    else
        NFLAG=N
    fi
    if [[ $NFLAG = "N" ]]
    then
        echo "N END_KEY_5_${TODAY}_N.dat" > $DAT 
    fi
exit
