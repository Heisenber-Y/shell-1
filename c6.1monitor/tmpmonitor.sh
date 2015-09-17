######################################################################
# Copyright C 2014 CFETS Financial Data Co.,LTD                      #
# All rights reserved                                                #
# Name: tmpmonitor.sh
# Author: Canux chengwei@chinamoney.com.cn                           #
# Version: V1.0                                                      #
# Time: Thu 06 Nov 2014 04:31:19 PM CST
# Description:                                                       #
######################################################################
#!/bin/bash

SSHPASS=/export/home/user/util/bin/sshpass
TMPDIR=/export/home/user/tmpbackup

echo N > $TMPDIR/label.dat

if [[ "$1" = fis ]] || [[ "$1" = cms ]] || [[ "$1" = wms ]] 
then
    PW=`cat $TMPDIR/shadow | grep -v ^# | grep -w $1 | awk -F, 'NR==1 {print $2}'` 
    HOST=$1@192.168.6.1
    DIR=/export/home/$1/other/monitor
    SCRIPT=$DIR/$1.sh

    NUM=1
    LABEL=1
    while [[ $LABEL -ne 0 ]] && [[ $NUM -le 5 ]]
    do
        $SSHPASS -p $PW ssh $HOST "bash $SCRIPT"
        LABEL=$?
        NUM=`expr $NUM + 1`
    done

    echo "" > $TMPDIR/$1.dat

    NUM=1
    LABEL=1
    while [[ $LABEL -ne 0 ]] && [[ $NUM -le 5 ]]
    do
        $SSHPASS -p $PW ssh $HOST "cat $DIR/$1.dat" > $TMPDIR/$1.dat
        LABEL=$?
        NUM=`expr $NUM + 1`
    done 

elif [[ "$1" = inter ]]
then
    PW=`cat $TMPDIR/shadow | grep -v ^# | grep -w $1 | awk -F, 'NR==1 {print $2}'` 
    HOST=$1@192.168.6.1
    DIR=/export/home/$1/other/monitor
    SCRIPT=$DIR/$2.sh

    NUM=1
    LABEL=1
    while [[ $LABEL -ne 0 ]] && [[ $NUM -le 5 ]]
    do
        $SSHPASS -p $PW ssh $HOST "bash $SCRIPT"
        LABEL=$?
        NUM=`expr $NUM + 1`
    done

    echo "" > $TMPDIR/$2.dat

    NUM=1
    LABEL=1
    while [[ $LABEL -ne 0 ]] && [[ $NUM -le 5 ]]
    do
        $SSHPASS -p $PW ssh $HOST "cat $DIR/$2.dat" > $TMPDIR/$2.dat
        LABEL=$?
        NUM=`expr $NUM + 1`
    done

elif [[ "$1" = comstp ]] || [[ "$1" = user ]] || [[ "$1" = wbs ]]
then
    PW=`cat $TMPDIR/shadow | grep -v ^# | grep -w fis | awk -F, 'NR==1 {print $2}'`
    PW2=`cat $TMPDIR/shadow | grep -v ^# | grep -w $1 | awk -F, 'NR==1 {print $2}'`
    HOST=fis@192.168.6.1
    DIR=/export/home/fis/other/monitor
    SCRIPT=$DIR/$1.sh

    NUM=1
    LABEL=1
    while [[ $LABEL -ne 0 ]] && [[ $NUM -le 5 ]]
    do
        $SSHPASS -p $PW ssh $HOST "bash $SCRIPT $PW2"
        LABEL=$?
        NUM=`expr $NUM + 1`
    done

    echo "" > $TMPDIR/$1.dat

    NUM=1
    LABEL=1
    while [[ $LABEL -ne 0 ]] && [[ $NUM -le 5 ]]
    do
        $SSHPASS -p $PW ssh $HOST "cat $DIR/$1.dat" > $TMPDIR/$1.dat 
        LABEL=$?
        NUM=`expr $NUM + 1`
    done
fi

echo Y > $TMPDIR/label.dat

exit
