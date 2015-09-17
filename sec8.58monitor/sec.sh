######################################################################
# Copyright C 2014 CFETS Financial Data Co.,LTD                      #
# All rights reserved                                                #
# File Name:sec.sh
# Version:                                                           #
# Writen by canux chengwei@chinamoney.com.cn                         #
# Created Time: Thu 23 Oct 2014 04:43:39 PM CST
# Description:                                                       #
######################################################################
#!/bin/bash

DIR=/export/home/kobra/monitor
SENDMAIL=$DIR/secmail.sh
FILE=$DIR/sec_process.txt

SSHPASS=/bin/sshpass
PW=`cat $DIR/shadow | grep -v ^# | grep -w user | grep -w 210.22.151.39 | awk -F, 'NR==1 {print $3}'`
HOST=user@210.22.151.39
TMP=/export/home/user/tmpbackup
SCRIPT=$TMP/tmpsec.sh
TMPFILE=$TMP/sec_process.txt

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
    FLAG=`$SSHPASS -p $PW ssh $HOST "cat $TMP/flag.dat"`
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

    LOOP=`cat $FILE`
    IFSOLD=$IFS
    IFS=$'\n'
    for DAT in $LOOP
    do
        PRO=`echo "$DAT" | awk '{print $1}'`
        STR=`echo "$DAT" | awk '{print $2}'`
        ACT=`echo "$DAT" | awk '{print $3}'`   
        REF=`echo "$DAT" | awk '{print $4}'`
        if [[ $PRO = N ]]
        then
            echo "$sec@192.168.8.58: <$STR> is error, actual value = $ACT, reference value = $REF." > $DIR/secmail.txt 
        fi
    done
    IFS=$IFSOLD

    TODAY=`date`
    mailx -s "SEC ERROR!!! <$TODAY>" 13681984515@139.com,chengwei@chinamoney.com.cn < $DIR/secmail.txt
fi

exit
