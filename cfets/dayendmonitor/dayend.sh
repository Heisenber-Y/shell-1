######################################################################
# Copyright C 2014 CFETS Financial Data Co.,LTD                      #
# All rights reserved                                                #
# File Name:dayend.sh
# Version:                                                           #
# Writen by canux chengwei@chinamoney.com.cn                         #
# Created Time: Thu 23 Oct 2014 04:43:39 PM CST
# Description:                                                       #
######################################################################
#!/bin/bash

HOU=`date +%H`
MIN=`date +%M`

DIR=/export/home/kobra/monitor
FILE=$DIR/dayend_process.txt

SSHPASS=/bin/sshpass
PW=`cat $DIR/shadow | grep -v ^# | grep -w user | grep -w 210.22.151.39 | awk -F, 'NR==1 {print $3}'`
HOST=user@210.22.151.39
TMP=/export/home/user/tmpbackup
SCRIPT=$TMP/tmpdayend.sh
TMPFILE=$TMP/dayend_process.txt

LABEL=1
NUM=1
while [[ $LABEL -ne 0 ]] && [[ $NUM -le 5 ]]
do
    $SSHPASS -p $PW ssh $HOST "bash $SCRIPT"
    LABEL=$?
    NUM=`expr $NUM + 1`
done

LABEL=1
NUM=1
while [[ $LABEL -ne 0 ]] && [[ $NUM -le 5 ]]
do
    FLAG=`$SSHPASS -p $PW ssh $HOST "cat $TMP/de.dat"`
    LABEL=$?
    NUM=`expr $NUM + 1`
done

if [[ $FLAG = Y ]]
then
    LABEL=1
    NUM=1
    while [[ $LABEL -ne 0 ]] && [[ $NUM -le 5 ]]
    do
        echo "" > $FILE
        $SSHPASS -p $PW ssh $HOST "cat $TMPFILE" > $FILE
        LABEL=$?
        NUM=`expr $NUM + 1`
    done

    echo "" > $DIR/dayendmail.txt 
    LOOP=`cat $FILE`
    IFSOLD=$IFS
    IFS=$'\n'
    for DAT in $LOOP
    do
        PRO=`echo "$DAT" | awk '{print $1}'`
        USERNAME=`echo "$DAT" | awk '{print $2}'`
        IP=`echo "$DAT" | awk '{print $3}'`
        SROLL=`echo "$DAT" | awk '{print $4}'`
        if [[ $PRO = N ]]
        then
            if [[ $SROLL = "" ]]
            then
                echo "$USERNAME@$IP: <$USERNAME> system_dayend error." >> $DIR/dayendmail.txt 
            else
                echo "$USERNAME@$IP: <$SROLL> roll_dayend error." >> $DIR/dayendmail.txt
            fi
        fi
    done
    IFS=$IFSOLD
 
    TODAY=`date`
    mailx -s "dayend error!!! <$TODAY>" 13681984515@139.com,chengwei@chinamoney.com.cn < /export/home/kobra/monitor/dayendmail.txt

fi

exit
