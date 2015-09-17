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
echo `date`

DIR=/export/home/kobra/monitor
SENDMAIL=$DIR/monitormail.sh

SSHPASS=/bin/sshpass
PW=`cat $DIR/shadow | grep -v ^# | grep -w user | grep -w 210.22.151.39 | awk -F, 'NR==1 {print $3}'`
HOST=user@210.22.151.39
TMP=/export/home/user/tmpbackup
SCRIPT=$TMP/tmpmonitor.sh

LABEL=1
NUM=1
while [[ $LABEL -ne 0 ]] && [[ $NUM -le 5 ]]
do
    $SSHPASS -p $PW ssh $HOST "bash $SCRIPT $1 $2"
    LABEL=$?
    NUM=`expr $NUM + 1`
done

LABEL=1
NUM=1
while [[ $LABEL -ne 0 ]] && [[ $NUM -le 5 ]]
do
    FLAG=`$SSHPASS -p $PW ssh $HOST "cat $TMP/label.dat"`
    LABEL=$?
    NUM=`expr $NUM + 1`
done

if [[ $FLAG = Y ]]
then
    if [[ "$1" = inter ]]
    then
        LABEL=1
        NUM=1
        while [[ $LABEL -ne 0 ]] && [[ $NUM -le 5 ]]
        do
            echo "" > $DIR/$2.dat
            $SSHPASS -p $PW ssh $HOST "cat $TMP/$2.dat" > $DIR/$2.dat
            LABEL=$?
            NUM=`expr $NUM + 1`
        done
        LOOP=`cat $DIR/$2.dat`
        IFSOLD=$IFS
        IFS=$'\n'
        for DAT in $LOOP
        do
            PRO=`echo "$DAT" | awk '{print $1}'`
            STR=`echo "$DAT" | awk '{print $2}'`
            if [[ $PRO = N ]]
            then
                bash $SENDMAIL $1 $2 $STR 
            fi
        done
        IFS=$IFSOLD

    elif [[ "$1" = fis ]] || [[ "$1" = cms ]] || [[ "$1" = wms ]] 
    then
        LABEL=1
        NUM=1
        while [[ $LABEL -ne 0 ]] && [[ $NUM -le 5 ]]
        do
            echo "" > $DIR/$1.dat  
            $SSHPASS -p $PW ssh $HOST "cat $TMP/$1.dat" > $DIR/$1.dat
            LABEL=$?
            NUM=`expr $NUM + 1`
        done
        LOOP=`cat $DIR/$1.dat`
        IFSOLD=$IFS
        IFS=$'\n'
        for DAT in $LOOP
        do
            PRO=`echo "$DAT" | awk '{print $1}'`
            STR=`echo "$DAT" | awk '{print $2}'`
            ACTVAL=`echo "$DAT" | awk '{print $3}'`
            REFVAL=`echo "$DAT" | awk '{print $4}'`
            if [[ $PRO = N ]]
            then
                bash $SENDMAIL $1 $STR $ACTVAL $REFVAL
            fi
        done
        IFS=$IFSOLD

    elif [[ "$1" = comstp ]] || [[ "$1" = user ]] || [[ "$1" = wbs ]]
    then
        LABEL=1
        NUM=1
        while [[ $LABEL -ne 0 ]] && [[ $NUM -le 5 ]]
        do
            echo "" > $DIR/$1.dat
            $SSHPASS -p $PW ssh $HOST "cat $TMP/$1.dat" > $DIR/$1.dat
            LABEL=$?
            NUM=`expr $NUM + 1`
        done
        LOOP=`cat $DIR/$1.dat`
        IFSOLD=$IFS
        IFS=$'\n'
        for DAT in $LOOP
        do
            PRO=`echo "$DAT" | awk '{print $1}'`
            STR=`echo "$DAT" | awk '{print $2}'`
            ACTVAL=`echo "$DAT" | awk '{print $3}'`
            REFVAL=`echo "$DAT" | awk '{print $4}'`
            if [[ $PRO = N ]]
            then
                if [[ $STR = "local" ]]
                then
                    bash $SENDMAIL $1 $STR $ACTVAL $REFVAL
                else
                    bash $SENDMAIL $1 $STR
                fi
            fi
        done
        IFS=$IFSOLD
    fi
fi

exit
