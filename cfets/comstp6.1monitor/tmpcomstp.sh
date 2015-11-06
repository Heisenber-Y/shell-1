######################################################################
# Copyright C 2014 CFETS Financial Data Co.,LTD                      #
# All rights reserved                                                #
# Name: tmpcomstp.sh
# Author: Canux chengwei@chinamoney.com.cn                           #
# Version: V1.0                                                      #
# Time: Thu 06 Nov 2014 04:31:19 PM CST
# Description:                                                       #
######################################################################
#!/bin/bash

SSHPASS=/export/home/user/util/bin/sshpass
TMPDIR=/export/home/user/tmpbackup

echo N > $TMPDIR/cs.dat

PW=`cat $TMPDIR/shadow | grep -v ^# | grep -w wms | awk -F, 'NR==1 {print $2}'`
#PW=yangxuezhiA550
HOST=wms@192.168.6.1
#HOST=yangxuezhi@192.168.6.1
DIR=/export/home/wms/other/monitor
#DIR=/export/home/yangxuezhi/bin
SCRIPT=$DIR/ds_chk_max_time.sh
LOG=$DIR/log/ds_chk_result
#LOG=/export/home/yangxuezhi/log/ds_chk_result

    NUM=1
    LABEL=1
    while [[ $LABEL -ne 0 ]] && [[ $NUM -le 5 ]]
    do
        $SSHPASS -p $PW ssh $HOST "$SCRIPT"
        LABEL=$?
        NUM=`expr $NUM + 1`
    done

    echo "" > $TMPDIR/tmpcomstp.dat

    NUM=1
    LABEL=1
    while [[ $LABEL -ne 0 ]] && [[ $NUM -le 5 ]]
    do
        $SSHPASS -p $PW ssh $HOST "cat $LOG" > $TMPDIR/tmpcomstp.dat 
        LABEL=$?
        NUM=`expr $NUM + 1`
    done

echo Y > $TMPDIR/cs.dat

exit
