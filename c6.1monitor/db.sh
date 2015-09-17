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

source ~/.profile
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
        CURDATE=$LASTYEAR$LASTMONTH$LMLASTDAY
    else
        CURDATE=$CURYEAR$LASTMONTH$LMLASTDAY
    fi
else   
    CURDATE=`expr $DATE_NO - 1`
fi
###############################################

    DIR=/export/home/inter/other/monitor
    SQLPLUS=sqlplus
    echo "" > $DIR/db.dat

    $SQLPLUS $DB_NAME @$DIR/monitor1.sql $CURDATE > $DIR/monitor.tmp
    COUNT=`awk '/----------/{getline;print}' $DIR/monitor.tmp`
    COUNT1=`echo $COUNT`
    if [[ $COUNT1 -eq 0 ]]
    then
        echo "N sql1" > $DIR/db.dat 
    fi

    $SQLPLUS $DB_NAME @$DIR/monitor2.sql $CURDATE > $DIR/monitor.tmp
    COUNT=`awk '/----------/{getline;print}' $DIR/monitor.tmp`
    COUNT2=`echo $COUNT`
    if [[ $COUNT2 -eq 0 ]]
    then
        echo "N sql2" >> $DIR/db.dat
    fi
exit
