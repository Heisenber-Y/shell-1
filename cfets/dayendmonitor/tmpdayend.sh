######################################################################
# Copyright C 2014 CFETS Financial Data Co.,LTD                      #
# All rights reserved                                                #
# File Name:tmpdayend.sh
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

########################################
CURDATE=`date +%Y%m%d`
CURDAY=`date +%d`
CURMONTH=`date +%m`
CURYEAR=`date +%Y`

NEXTYEAR=`expr $CURYEAR + 1`

if [[ $((10#$CURMONTH)) -eq 12 ]]
then
    NEXTMONTH=1
else
    NEXTMONTH=`expr $CURMONTH + 1`
fi
if [[ $((10#$NEXTMONTH)) -ge 1 ]] && [[ $((10#$NEXTMONTH)) -le 9 ]]
then
    NEXTMONTH=0$((10#$NEXTMONTH))
else
    NEXTMONTH=$NEXTMONTH
fi

#the last day of curent month
NUM1=`cal $CURMONTH $CURYEAR | awk 'NR==6{print $NF}'`
NUM2=`cal $CURMONTH $CURYEAR | awk 'NR==7{print $NF}'`
NUM3=`cal $CURMONTH $CURYEAR | awk 'NR==8{print $NF}'`
if [[ $NUM3 -ne 0 ]]
then
    LASTDAY=$NUM3
elif [[ $NUM3 -eq 0 ]] && [[ $NUM2 -ne 0 ]]
then
    LASTDAY=$NUM2
else
    LASTDAY=$NUM1
fi

if [[ $((10#$CURMONTH)) -eq 12 ]] && [[ $((10#$CURDAY)) -eq 31 ]]
then
    NEXTDATE=${NEXTYEAR}0101
elif [[ $((10#$CURDAY)) -eq $((10#$LASTDAY)) ]]
then
    NEXTDATE=${CURYEAR}${NEXTMONTH}01
else
    NEXTDATE=`expr $CURDATE + 1`
fi

########################################
IPLIST=/export/home/user/tmpbackup/iplist.txt
DIR=/export/home/user/tmpbackup
SSHPASS=/export/home/user/util/bin/sshpass
ACTFILE=$DIR/dayend_process.txt

echo N > $DIR/de.dat
echo "" > $ACTFILE

cat $IPLIST | grep -v ^# | awk -F, '{print $1}' > $DIR/ip.dat
LOOP=`cat $DIR/ip.dat`
for IP in $LOOP
do
    PASSWD=`cat $IPLIST | grep -v ^# | grep -w ${IP} | awk -F, '{print $2}'`
    SCRIPT=`cat $IPLIST | grep -v ^# | grep -w ${IP} | awk -F, '{print $3}'`

    TMP=`echo ${IP} | awk -F. '{print $1}'` 
    if [[ $TMP -eq 192 ]]
    then 
        LABEL=1
        NUM=1
        while [[ $LABEL -ne 0 ]] && [[ $NUM -le 5 ]]
        do
            echo "" > $DIR/${IP}.dat
            $SSHPASS -p $PASSWD ssh fis@${IP} "$SCRIPT" > $DIR/${IP}.dat 
            LABEL=$?
            NUM=`expr $NUM + 1`
        done
    elif [[ $TMP -eq 200 ]]
    then
        LABEL=1
        NUM=1
        while [[ $LABEL -ne 0 ]] && [[ $NUM -le 5 ]]
        do
            echo "" > $DIR/${IP}.dat
            $SSHPASS -p $PASSWD ssh -p 22010 comstar@gagaga "bash $SCRIPT" > $DIR/${IP}.dat
            LABEL=$?
            NUM=`expr $NUM + 1`
        done
    fi

    REFFILE=$DIR/${IP}_config.txt
    cat $REFFILE | grep -v ^# | awk -F, '{print $1}' > $DIR/dayend.dat
    LOOP=`cat $DIR/dayend.dat`
    for NAME in $LOOP
    do
        USERNAME=`cat $REFFILE | grep -v ^# | grep -w $NAME | awk -F, '{print $2}'`
        SROLL=`cat $REFFILE | grep -v ^# | grep -w $NAME | awk -F, '{print $3}'`
        END=`cat $REFFILE | grep -v ^# | grep -w $NAME | awk -F, '{print $4}'`

        ENDHOU=`echo $END | awk '{ print substr($0,1,2) }'`
        ENDMIN=`echo $END | awk '{ print substr($0,3,2) }'`

        if [[ $USERNAME = fis ]]
        then
            BUSINESS=`cat $DIR/${IP}.dat | awk 'NR>0 && NR<10 {print $1}' | grep 20`
        elif [[ $USERNAME = cms ]]
        then
            if [[ $SROLL = "" ]]
            then
                BUSINESS=`cat $DIR/${IP}.dat | awk 'NR>11 && NR<41 {print $1}' | grep 20`
            else
                BUSINESS=`cat $DIR/${IP}.dat | awk 'NR>11 && NR<41 {print $0}' | grep -iw $SROLL | awk '{print $2}'`
            fi
        elif [[ $USERNAME = wms ]]
        then
            if [[ $SROLL = "" ]]
            then
                BUSINESS=`cat $DIR/${IP}.dat | awk 'NR>42 && NR<66 {print $1}' | grep 20`
            else
                BUSINESS=`cat $DIR/${IP}.dat | awk 'NR>42 && NR<66 {print $0}' | grep -iw $SROLL | awk '{print $2}'`
            fi
        fi

        REFVAL=$NEXTDATE
        ACTVAL=$BUSINESS

        if [[ ${ACTVAL} -lt ${REFVAL} ]] && [[ $ACTVAL != "" ]] 
        then
            if [[ $((10#$HOUR)) -gt $((10#$ENDHOU)) ]]
            then
                echo "N $USERNAME ${IP} $SROLL" >> $ACTFILE 
            elif [[ $((10#$HOUR)) -eq $((10#$ENDHOU)) ]] && [[ $((10#$MIN)) -ge $((10#$ENDMIN)) ]]   
            then
                echo "N $USERNAME ${IP} $SROLL" >> $ACTFILE
            fi
        fi

    done
done

echo Y > $DIR/de.dat

exit
