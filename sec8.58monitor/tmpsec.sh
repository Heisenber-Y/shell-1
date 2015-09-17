######################################################################
# Copyright C 2014 CFETS Financial Data Co.,LTD                      #
# All rights reserved                                                #
# File Name:tmpsec.sh
# Version:                                                           #
# Writen by canux chengwei@chinamoney.com.cn                         #
# Created Time: Thu 23 Oct 2014 04:43:39 PM CST
# Description:                                                       #
######################################################################
#!/bin/bash

HOUR=`date +%H`
MIN=`date +%M`

if [[ $HOUR -eq 00 ]]
then
    $HOUR=24
fi

CURM=`expr $HOUR \* 60 + $MIN`

########################################
REFFILE=/export/home/user/tmpbackup/sec_config.txt
ACTFILE=/export/home/user/tmpbackup/sec_process.txt
DIR=/export/home/user/tmpbackup
SSHPASS=/export/home/user/util/bin/sshpass
PW=`cat /export/home/user/tmpbackup/shadow | grep -v ^# | grep -w sec | awk -F, 'NR==1 {print $2}'`

echo N > $DIR/flag.dat
echo "" > $ACTFILE
echo "" > $DIR/res.dat
echo "" > $DIR/sec.dat

NUM=1
LABEL=1
while [[ $LABEL -ne 0 ]] && [[ $NUM -le 5 ]]
do
    $SSHPASS -p $PW ssh sec@192.168.8.58 "/export/home/sec/bin/checkmsg.sh" > $DIR/res.dat
    LABEL=$?
    NUM=`expr $NUM + 1`
done

cat $REFFILE | grep -v ^# | awk -F, '{print $1}' > $DIR/sec.dat
LOOP=`cat $DIR/sec.dat`
for NAME in $LOOP
do 
    REFVAL=`cat $REFFILE | grep -w $NAME | awk -F, '{print $2}'`
    START=`cat $REFFILE | grep -w $NAME | awk -F, '{print $3}'`
    END=`cat $REFFILE | grep -w $NAME | awk -F, '{print $4}'`
    STARTHOU=`echo $START | awk '{ print substr($0,1,2) }'`
    STARTMIN=`echo $START | awk '{ print substr($0,3,2) }'`
    ENDHOU=`echo $END | awk '{ print substr($0,1,2) }'`
    ENDMIN=`echo $END | awk '{ print substr($0,3,2) }'`
    ENDM=`expr $ENDHOU \* 60 + $ENDMIN`
    ENDMAX=`expr $ENDM + 15`

    ACTVAL=`cat $DIR/res.dat | grep -w $NAME | awk -F= 'NR==1 {print $2}'`

    if [[ $NAME != Uts ]] && [[ $NAME != Uts2 ]] && [[ $NAME != cmds ]] && [[ $NAME != OICAPV ]]
    then
        if [[ ${ACTVAL} -lt ${REFVAL} ]] 
        then
            if [[ $CURM -gt $ENDM ]] && [[ $CURM -lt $ENDMAX ]]
            then
                echo "N $NAME $ACTVAL $REFVAL" >> $ACTFILE 
            fi
        fi
    elif [[ $NAME = Uts ]] || [[ $NAME = Uts2 ]] || [[ $NAME = cmds ]] || [[ $NAME = OICAPV ]]
    then
        if [[ $ACTVAL != $REFVAL ]]
        then
            if [[ $CURM -gt $ENDM ]] && [[ $CURM -lt $ENDMAX ]]
            then
                echo "N $NAME $ACTVAL $REFVAL" >> $ACTFILE    
            fi
        fi
    fi
done

echo Y > $DIR/flag.dat

exit
