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

BACKUP=/home/user/backup
LOGFILE=${BACKUP}/local_backup.log
if [ -e ${LOGFILE} ]
then
    echo "" > ${LOGFILE}
else
    touch ${LOGFILE}
fi

RSYNC="/usr/bin/rsync -avzHP"
REMOTEHOST=root@192.168.2.209
REMOTE=/home/backup/backup

DATE=$1
DIR=$2

function main
{
    echo `date`
	
    LOOP=`find $BACKUP/$DIR -type f -name "*$DATE*" | cat`
    if [[ $LOOP != "" ]]
    then
        LABEL=1
        count=1
        while [[ ${LABEL} -ne 0 ]] && [[ $count -le 10 ]]
        do    
	        ${RSYNC} ${BACKUP}/${DIR}/*${DATE}* ${REMOTEHOST}:${REMOTE}/${DIR}
            LABEL=$?
            count=`expr $count + 1`
        done
        rm -f ${BACKUP}/${DIR}/*${DATE}*
    else
        echo exit...
        exit
    fi

    echo `date`
}

main > ${LOGFILE} 2>& 1

exit 
