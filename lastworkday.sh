######################################################################
# Copyright (C) 2014 CFETS Financial Data Co.,LTD                    #
# All rights reserved                                                #
# Name: lastworkday.sh
# Author: Canux canuxcheng@gmail.com                                 #
# Version: V1.0                                                      #
# Time: Wed 12 Nov 2014 04:37:37 PM CST
# Description:                                                       #
######################################################################
#!/bin/bash

#get the date of last workday, formated by YYYYMMDD,
#bugs: just ignore the saturday and sunday, but can not process the holidays

####################################
if [[ "$1" = "" ]]
then
    DATE_NO=`date +%Y%m%d`
    CURDAY=`date +%d`
    CURMONTH=`date +%m`
    CURYEAR=`date +%Y`
    CURWEEK=`date +%w`
else
    DATE_NO=$1
    CURYEAR=`echo $1 | awk '{print substr($0,1,4)}'`
    CURMONTH=`echo $1 | awk '{print substr($0,5,2)}'`
    CURDAY=`echo $1 | awk '{print substr($0,7,2)}'`
    CURWEEK=`date -d $1 +%w`
fi

####################################
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

if [[ $LASTMONTH -eq 4 ]] || [[ $LASTMONTH -eq 6 ]] || [[ $LASTMONTH -eq 9 ]] || [[ $LASTMONTH -eq 11 ]]
then
    LMLASTDAY=30
elif [[ $LASTMONTH -eq 2 ]]
then
	LMLASTDAY=28
else
	LMLASTDAY=31
fi

###################################
if [[ $CURWEEK -eq 1 ]]
then
    if [[ $((10#$CURDAY)) -eq 1 ]] 
    then
        if [[ $((10#$CURMONTH)) -eq 1 ]]
        then
            WORKDAY=`expr $LASTYEAR$LASTMONTH$LMLASTDAY - 2`
        else
            WORKDAY=`expr $CURYEAR$LASTMONTH$LMLASTDAY - 2`
        fi
	elif [[ $((10#$CURDAY)) -eq 2 ]]
	then
		if [[ $((10#$CURMONTH)) -eq 1 ]]
		then
		    WORKDAY=`expr $LASTYEAR$LASTMONTH$LMLASTDAY - 1`
		else
			WORKDAY=`expr $CURYEAR$LASTMONTH$LMLASTDAY - 1`
		fi
	elif [[ $((10#$CURDAY)) -eq 3 ]]
	then
		if [[ $((10#$CURMONTH)) -eq 1 ]]
		then
			WORKDAY=$LASTYEAR$LASTMONTH$LMLASTDAY
		else
			WORKDAY=$CURYEAR$LASTMONTH$LMLASTDAY
		fi
	else
		WORKDAY=`expr $DATE_NO - 3`
	fi

elif [[ $CURWEEK -eq 0 ]]
then
    if [[ $((10#$CURDAY)) -eq 1 ]] 
    then
        if [[ $((10#$CURMONTH)) -eq 1 ]]
        then
            WORKDAY=`expr $LASTYEAR$LASTMONTH$LMLASTDAY - 1`
        else
            WORKDAY=`expr $CURYEAR$LASTMONTH$LMLASTDAY - 1`
        fi
	elif [[ $((10#$CURDAY)) -eq 2 ]]
	then
		if [[ $((10#$CURMONTH)) -eq 1 ]]
		then
			WORKDAY=$LASTYEAR$LASTMONTH$LMLASTDAY
		else
			WORKDAY=$CURYEAR$LASTMONTH$LMLASTDAY
		fi
	else
		WORKDAY=`expr $DATE_NO - 2`
	fi

else
	if [[ $((10#$CURDAY)) -eq 1 ]]
	then
		if [[ $((10#$CURMONTH)) -eq 1 ]]
		then
			WORKDAY=`expr $LASTYEAR$LASTMONTH$LMLASTDAY`
		else
			WORKDAY=`expr $CURYEAR$LASTMONTH$LMLASTDAY`
		fi
	else
		WORKDAY=`expr $DATE_NO - 1`
	fi
fi

echo $WORKDAY
