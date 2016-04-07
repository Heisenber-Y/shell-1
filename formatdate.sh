######################################################################
# Copyright (C) 2014 CFETS Financial Data Co.,LTD                    #
# All rights reserved                                                #
# Name: formatdate.sh
# Author: Canux canuxcheng@gmail.com                                 #
# Version: V1.0                                                      #
# Time: Thu 04 Dec 2014 04:11:41 PM CST
# Description:                                                       #
######################################################################
#!/bin/bash

#the $1 is a date and formated by YYYYMMDD, use this transfer to YYYY-MM-DD

if [[ "$1" = "" ]]
then
	YEAR=`date +%Y`
	MONTH=`date +%m`
	DAY=`date +%d`
else
	YEAR=`echo $1 | awk '{print substr($0, 1, 4)}'`
	MONTH=`echo $1 | awk '{print substr($0, 5, 2)}'`
	DAY=`echo $1 | awk '{print substr($0, 7, 2)}'`
fi
FDATE=${YEAR}-${MONTH}-${DAY}
echo $FDATE
