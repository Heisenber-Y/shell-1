######################################################################
# Copyright (C) 2014 CFETS Financial Data Co.,LTD                    #
# All rights reserved                                                #
# Name: tomorrow.sh
# Author: Canux canuxcheng@gmail.com                                 #
# Version: V1.0                                                      #
# Time: Wed 12 Nov 2014 04:52:14 PM CST
# Description:                                                       #
######################################################################
#!/bin/bash

#get the date of tomorrow, formated by YYYYMMDD

#####################################
if [ "$1" = "" ]
then
    CURDATE=`date +%Y%m%d`
    CURDAY=`date +%d`
    CURMONTH=`date +%m`
    CURYEAR=`date +%Y`
    CURHOUR=`date +%H`
    CURMIN=`date +%M`
else
    CURDATE=$1
    CURYEAR=`echo $1 | awk '{print substr($0,1,4)}'`
    CURMONTH=`echo $1 | awk '{print substr($0,5,2)}'`
    CURDAY=`echo $1 | awk '{print substr($0,7,2)}'`
fi

####################################
NEXTYEAR=`expr $CURYEAR + 1`

if [[ $((10#$CURMONTH)) -eq 12 ]]
then
    NEXTMONTH=1
else
    NEXTMONTH=`expr $CURMONTH + 1`
fi
if [[ $((10#$NEXTMONTH)) -ge 1 ]] && [[ $((10#$NEXTMONTH)) -le 9 ]]
then
	NEXTMONTH=0$NEXTMONTH
else
    NEXTMONTH=$NEXTMONTH
fi

if [[ $CURMONTH -eq 4 ]] || [[ $CURMONTH -eq 6 ]] || [[ $CURMONTH -eq 9 ]] || [[ $CURMONTH -eq 11 ]]
then
    LASTDAY=30
elif [[ $CURMONTH -eq 2 ]]
then
	LASTDAY=28
else
	LASTDAY=31
fi

if [[ $((10#$CURMONTH)) -eq 12 ]] && [[ $((10#$CURDAY)) -eq 31 ]]
then
    NEXTDATE=${NEXTYEAR}0101
elif [[ $((10#$CURDAY)) -eq $((10#$LASTDAY)) ]] && [[ $((10#$CURMONTH)) -ne 12 ]]
then
    NEXTDATE=${CURYEAR}${NEXTMONTH}01
else
    NEXTDATE=`expr $CURDATE + 1`
fi

echo $NEXTDATE
