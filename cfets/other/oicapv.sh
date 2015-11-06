######################################################################
# Copyright C 2014 CFETS Financial Data Co.,LTD                      #
# All rights reserved                                                #
# File Name:oicapv.sh
# Version:                                                           #
# Writen by canux chengwei@chinamoney.com.cn                         #
# Created Time: Thu 23 Oct 2014 04:43:39 PM CST
# Description:                                                       #
######################################################################
#!/bin/bash

####################################
if [ "$1" = "" ]
then
    DATE_NO=`date +%Y%m%d`
    CURDAY=`date +%d`
    CURMONTH=`date +%m`
    CURYEAR=`date +%Y`
else
    DATE_NO=$1
    CURYEAR=`echo $1 | awk '{print substr($0,1,4)}'`
    CURMONTH=`echo $1 | awk '{print substr($0,5,2)}'`
    CURDAY=`echo $1 | awk '{print substr($0,7,2)}'`
fi

LASTYEAR=`expr $CURYEAR - 1`

if [[ $((10#$CURMONTH)) -eq 1 ]]
then
    LASTMONTH=12
else
    LASTMONTH=`expr $CURMONTH - 1`
fi
if [[ $LASTMONTH -ge 1 ]] && [[ $LASTMONTH -le 9 ]]
then
    LASTMONTH=0$LASTMONTH
else
    LASTMONTH=$LASTMONTH
fi

NUM1=`cal $LASTMONTH $CURYEAR | awk 'NR==6{print $NF}'`
NUM2=`cal $LASTMONTH $CURYEAR | awk 'NR==7{print $NF}'`
NUM3=`cal $LASTMONTH $CURYEAR | awk 'NR==8{print $NF}'`
if [[ $NUM3 -ne 0 ]]
then
    LMLASTDAY=$NUM3
elif [[ $NUM3 -eq 0 ]] && [[ $NUM2 -ne 0 ]]
then
    LMLASTDAY=$NUM2
else
    LMLASTDAY=$NUM1
fi

if [[ $((10#$CURDAY)) -eq 1 ]] 
then
    if [[ $((10#$CURMONTH)) -eq 1 ]]
    then
        LASTDATE=$LASTYEAR$LASTMONTH$LMLASTDAY
    else
        LASTDATE=$CURYEAR$LASTMONTH$LMLASTDAY
    fi
else
    LASTDATE=`expr $DATE_NO - 1`
fi

##################################################

DIR=/export/home/sec/data/security

SFILE=$DIR/test_table
SFILE1=$SFILE/ohlcv_icap_ask.txt
SFILE2=$SFILE/ohlcv_icap_mid.txt
SFILE3=$SFILE/ohlcv_icap_bid.txt

DFILE=$DIR/update
DFILE1=$DFILE/ohlcv_icap_ask.txt
DFILE2=$DFILE/ohlcv_icap_mid.txt
DFILE3=$DFILE/ohlcv_icap_bid.txt

TODAY=`date +%Y%m%d`
YESTODAY=$LASTDATE

sed "s/$YESTODAY/$TODAY/g" $SFILE1 > $DFILE1
sed "s/$YESTODAY/$TODAY/g" $SFILE2 > $DFILE2
sed "s/$YESTODAY/$TODAY/g" $SFILE3 > $DFILE3

cd $DFILE
#upload ${DFILE1}
#upload ${DFILE2}
#upload ${DFILE3}

rm ${DFILE1} ${DFILE2} ${DFILE3}

exit
