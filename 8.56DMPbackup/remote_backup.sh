######################################################################
# Copyright C 2014 CFETS Financial Data Co.,LTD                      #
# All rights reserved                                                #
# Name: remote_backup.sh
# Author: Canux chengwei@chinamoney.com.cn                           #
# Version: V2.0                                                      #
# Time: Thu 06 Nov 2014 04:31:19 PM CST
# Description:                                                       #
######################################################################
#!/bin/bash

########################################
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

if [[ $LASTMONTH -eq 4 ]] || [[ $LASTMONTH -eq 6 ]] || [[ $LASTMONTH -eq 9 ]] || [[ $LASTMONTH -eq 11 ]]
then
    LMLASTDAY=30
elif [[ $LASTMONTH -eq 2 ]]
then
	LMLASTDAY=28
else
	LMLASTDAY=31
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

#####################################
BACKUP=/home/backup/backup
LOGFILE=${BACKUP}/remote_backup.log

if [ -e ${LOGFILE} ]
then
    echo "" > ${LOGFILE}
else
    touch ${LOGFILE}
fi

SSHPASS=/home/backup/backup/sshpass
RSYNC=/usr/bin/rsync
SSH=/usr/bin/ssh

REMOTEHOST=user@192.168.8.1
PORT=9622
PASSWORD=******
REMOTE=/home/user/backup
REMOTE_SCRIPT=/home/user/backup/local_backup.sh

function main
{
    echo `date`
######################get the dir name.    
    cd $BACKUP;ls -l | awk '/^[d,l]/ {print $9}' > $BACKUP/dir.dat 
    DIRLOOP=`cat $BACKUP/dir.dat`

    for DIR in $DIRLOOP
    do
        if [[ $DIR = "2_oracle_dmp_file_devtest01" ]]
        then
            DATE=${LASTDATE}
        else 
            DATE=${DATE_NO}
        fi

        if [[ $DIR = "2_oracle_dmp_file" ]]
        then
            FULLDIR=/backup/2_oracle_dmp_file
        elif [[ $DIR = "99_oracle_dmp_file" ]]
        then
            FULLDIR=/backup/backup/99_oracle_dmp_file
        else
            FULLDIR=$BACKUP/$DIR 
        fi

        LOOP=`find $FULLDIR -type f -name "*${DATE}*" | cat`
        if [[ $LOOP != "" ]]
        then
            LABEL=1
            count=1
            while [[ ${LABEL} -ne 0 ]] && [[ $count -le 10 ]]
	    do
	        ${SSHPASS} -p ${PASSWORD} ${RSYNC} -e "${SSH} -p ${PORT}" -avzPH ${FULLDIR}/*${DATE}* ${REMOTEHOST}:${REMOTE}/${DIR}
	        LABEL=$?
                count=`expr $count + 1`
	    done
        else
            continue
        fi

	if [[ ${LABEL} -eq 0 ]] 
        then
	    LABEL=1
            count=1
	    while [[ ${LABEL} -ne 0 ]] && [[ $count -le 10 ]]
            do
                ${SSHPASS} -p ${PASSWORD} ${SSH} -p ${PORT} ${REMOTEHOST} "${REMOTE_SCRIPT} ${DATE} ${DIR}"	
                LABEL=$?
                count=`expr $count + 1`
            done
	fi
    done    
	
    echo `date`
}

main >> ${LOGFILE} 2>& 1

exit
