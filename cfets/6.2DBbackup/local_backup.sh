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

TMPBACKUP="/home/user/backup/6_2_backup_db"
LOGFILE=${TMPBACKUP}/local_backup.log

if [ -e ${LOGFILE} ]
then
    echo "" > ${LOGFILE}
else
    touch ${LOGFILE}
fi

DATE_NO=$1
CURDATE=$2
NAME=$3

RSYNC="/usr/bin/rsync -avzPH"

REMOTEHOST=root@192.168.2.209
REMOTEBACKUP=/home/oracle/backup_db

PREFIX=split

function main
{
    echo `date`
	
    echo "cat the file"
    cat ${TMPBACKUP}/${PREFIX}* > ${TMPBACKUP}/${NAME}

    if [[ -e ${TMPBACKUP}/${NAME} ]]
    then
        LABEL=1
        count=1
        while [ ${LABEL} -ne 0 ] && [[ $count -le 10 ]]
        do    
            echo "rsync from 2.202 to 2.209"
            ${RSYNC} ${TMPBACKUP}/*${CURDATE}* ${REMOTEHOST}:${REMOTEBACKUP}
            LABEL=$?
            count=`expr $count + 1`
        done
    fi
    rm -f ${TMPBACKUP}/*${CURDATE}* ${TMPBACKUP}/${PREFIX}*
	
    echo `date`	
}

main > ${LOGFILE} 2>& 1

exit
