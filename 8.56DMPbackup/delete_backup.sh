######################################################################
# Copyright C 2014 CFETS Financial Data Co.,LTD                      #
# All rights reserved                                                #
# Name: delete_backup.sh
# Author: Canux chengwei@chinamoney.com.cn                           #
# Version: V2.0                                                      #
# Time: Thu 06 Nov 2014 04:31:19 PM CST
# Description:                                                       #
######################################################################
#!/bin/bash

DIR=/home/backup/backup
LOGFILE=/home/backup/backup/delete_backup.log

if [ -e ${LOGFILE} ]
then
    echo "" > ${LOGFILE}
else
    touch ${LOGFILE}
fi

CURWEEK=`date +%w`
CURDAY=`date +%d`
CURMONTH=`date +%m`
CURYEAR=`date +%Y`
	
####################################
function main {

echo `date`

cd $DIR;ls -l | awk '/^[d,l]/ {print $9}' > $BACKUP/dir.dat 
DIRLOOP=`cat $DIR/dir.dat`

for DIR1 in $DIRLOOP
do
    find $DIR/$DIR1  -type f -wholename "*" > $DIR/file.dat   
    LOOP=`cat $DIR/file.dat`
    for FILE in $LOOP
    do
        DATE=`stat $FILE | grep Modify | awk '{ print $2 }'`
        WEEK=`date -d $DATE +%w`
        DAY=`date -d $DATE +%d`
        MONTH=`date -d $DATE +%m`
        YEAR=`date -d $DATE +%Y`
	
        if [[ $((10#$WEEK)) -ne 6 ]] && [[ ${MONTH}$((10#$DAY)) != ${CURMONTH}1 ]] 
        then
	        rm -f $FILE
        elif [[ $((10#$WEEK)) -eq 6 ]] && [[ ${MONTH}$((10#$DAY)) != ${CURMONTH}1 ]]
        then
	        find $DIR -mtime +20 -type f -wholename $FILE -print | xargs rm -f
        fi
    done
done

echo `date`
}

main > $LOGFILE 2>& 1

exit
