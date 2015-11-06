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

source /export/home/kobra/.bash_profile

echo `date`

DIR=/export/home/kobra/monitor
SENDMAIL=$DIR/comstpmail.sh

SSHPASS=/bin/sshpass
PW=`cat $DIR/shadow | grep -v ^# | grep -w user | grep -w 210.22.151.39 | awk -F, 'NR==1 {print $3}'`
HOST=user@210.22.151.39
TMP=/export/home/user/tmpbackup
SCRIPT=$TMP/tmpcomstp.sh

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
    FLAG=`$SSHPASS -p $PW ssh $HOST "cat $TMP/cs.dat"`
    LABEL=$?
    NUM=`expr $NUM + 1`
done

if [[ $FLAG = Y ]]
then
        LABEL=1
        NUM=1
        while [[ $LABEL -ne 0 ]] && [[ $NUM -le 5 ]]
        do
            echo "" > $DIR/ds_chk_result
            $SSHPASS -p $PW ssh $HOST "cat $TMP/tmpcomstp.dat" > $DIR/ds_chk_result
            LABEL=$?
            NUM=`expr $NUM + 1`
        done
        RES=`grep warning $DIR/ds_chk_result`
        if [[ $RES = "" ]]
        then
            STR="OK"    
        else
            STR="ERROR"
        fi

        TODAY=`date`
        mailx -s "[$STR] comstp_pl@192.168.6.1 <$TODAY>" chengwei@chinamoney.com.cn,wangdong@chinamoney.com.cn,yangxuezhi@chinamoney.com.cn,huangzhensheng@chinamoney.com.cn,maoyingjun@chinamoney.com.cn,yaoxingzhong@chinamoney.com.cn < /export/home/kobra/monitor/ds_chk_result

fi

echo `date`

exit
