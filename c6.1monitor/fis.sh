######################################################################
# Copyright C 2014 CFETS Financial Data Co.,LTD                      #
# All rights reserved                                                #
# Name: fis.sh
# Author: Canux chengwei@chinamoney.com.cn                           #
# Version: V1.0                                                      #
# Time: Thu 06 Nov 2014 04:31:19 PM CST
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
REFFILE=/export/home/fis/bin/monitor_config.txt
ACTFILE=/export/home/fis/bin/server_process.txt
DIR=/export/home/fis/other/monitor

echo "" > $DIR/fis.dat

cat $REFFILE | grep -v ^# | awk -F, '{print $1}' > $DIR/mymsg.dat
LOOP=`cat $DIR/mymsg.dat`
for NAME in $LOOP
do 
    REFVAL=`cat $REFFILE | grep -v ^# | grep -w $NAME | awk -F, '{print $8}'`
    echo "refval = $REFVAL"
    START=`cat $REFFILE | grep -w $NAME | awk -F, '{print $9}'`
    END=`cat $REFFILE | grep -w $NAME | awk -F, '{print $10}'`
    STARTHOU=`echo $START | awk '{ print substr($0,1,2) }'`
    STARTMIN=`echo $START | awk '{ print substr($0,3,2) }'`
    ENDHOU=`echo $END | awk '{ print substr($0,1,2) }'`
    ENDMIN=`echo $END | awk '{ print substr($0,3,2) }'`

    STARTM=`expr $STARTHOU \* 60 + $STARTMIN`
    ENDM=`expr $ENDHOU \* 60 + $ENDMIN`

    ACTVAL=""
    while [[ -z $ACTVAL ]]
    do
        ACTVAL=`cat $ACTFILE | grep -w $NAME | awk -F= '{print $2}'`
    done
    echo "actval = $ACTVAL"

    if [[ $((10#$REFVAL)) -ne $((10#$ACTVAL)) ]]
    then
        if [[ $CURM -gt $STARTM ]] && [[ $CURM -lt $ENDM ]]
        then
            echo "N $NAME $ACTVAL $REFVAL" >> $DIR/fis.dat
        fi 
    fi
done
