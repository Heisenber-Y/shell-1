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

MFILE=$DIR/END_KEY_5_${TODAY}_M.dat
MFILE1=$DIR1/END_KEY_5_${TODAY}_M.dat

DAT=/export/home/inter/other/monitor/mfile.dat
 
    echo "" > $DAT
    if [[ -e $MFILE ]] || [[ -e $MFILE1 ]]
    then
        MFLAG=Y
    else
        MFLAG=N
    fi
    if [[ $MFLAG = "N" ]]
    then
        echo "N END_KEY_5_${TODAY}_M.dat" > $DAT 
    fi

