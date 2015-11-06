######################################################################
# Copyright C 2014 CFETS Financial Data Co.,LTD                      #
# All rights reserved                                                #
# Name: local_backup.sh
# Author: Canux chengwei@chinamoney.com.cn                           #
# Version: V2.0                                                      #
# Time: Thu 06 Nov 2014 04:31:19 PM CST
# Description:                                                       #
######################################################################
#!/bin/bash

BACKUP=/home/user/backup/backup_script
LOGFILE="$BACKUP/local_backup.log"

if [ -e ${LOGFILE} ]
then
    echo "" > ${LOGFILE}
else
    touch ${LOGFILE}
fi

DATE_NO=$1

REMOTE=/home/svn/other/backup/backup
HOST=root@192.168.2.209
RSYNC="/usr/bin/rsync -avzHP"

function main
{    
    echo `date`	

    find $BACKUP -type f -name "*${DATE_NO}*" > $BACKUP/filename.dat
    LOOP=`cat $BACKUP/filename.dat`

    if [[ $LOOP != "" ]]
    then
        for NAME in $LOOP
        do
	        LABEL=1
            count=1
            while [ ${LABEL} -ne 0 ] && [[ $count -le 10 ]]
	        do
                ${RSYNC}  $NAME ${HOST}:${REMOTE}
                LABEL=$?
                count=`expr $count + 1`
            done
			rm $NAME
        done
    else
        echo exit...
        exit
    fi
			
    echo `date`
}

main > ${LOGFILE} 2>& 1

exit
