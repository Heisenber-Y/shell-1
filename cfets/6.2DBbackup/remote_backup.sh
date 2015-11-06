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

TMPBACKUP=/export/home/user/tmpbackup
LOGFILE=${TMPBACKUP}/remote_backup.log

if [ -e ${LOGFILE} ]
then
    echo "" > ${LOGFILE} 
else
    touch ${LOGFILE}
fi

###################################
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

#################################
SRCHOST=oracle@192.168.6.2
SRCPASSWORD=******
SRCBACKUP=/export/home/oracle/backup_db

REMOTEHOST=user@222.66.16.96
PORT=9001
PASSWORD=******
REMOTEBACKUP=/home/user/backup/6_2_backup_db
REMOTESCRIPT=local_backup.sh

SSHPASS=/export/home/user/util/bin/sshpass
RSYNC="/usr/local/bin/rsync -avzPH"
SSH=/bin/ssh

SUFFIX=JianHangDmp
NUM=2000m
PREFIX=split

#################################
function main
{
    echo `date` 

#############################find the file name, the filename some times changed.
    LABEL=1
    count=0 
    while [[ ${LABEL} -ne 0 ]] && [[ $count -le 10 ]]
    do
        TMPNAME=`${SSHPASS} -p ${SRCPASSWORD} ${SSH} ${SRCHOST} "find ${SRCBACKUP} -type f -name *${LASTDATE}.${SUFFIX}"`
        LABEL=$?
        count=`expr $count + 1`
    done
    NAME=`basename $TMPNAME`
    LOGNAME=${NAME}.log

#############################if file exist, then backup it. 
if [[ ${NAME} != . ]]
then

#############################split the remote file on 6.2.
        LABEL=1
        count=1
        while [[ ${LABEL} -ne 0 ]] && [[ $count -le 10 ]]
        do
            echo "split on 6.2"
            ${SSHPASS} -p ${SRCPASSWORD} ${SSH} ${SRCHOST} "cd ${SRCBACKUP};split -b ${NUM} ${NAME} ${PREFIX}"
            LABEL=$?
            count=`expr $count + 1`
        done
	
#############################process the log first.
        LABEL=1
        count=1
        while [[ ${LABEL} -ne 0 ]] && [[ $count -le 10 ]]
        do
            echo "rsync log from 6.2"
            ${SSHPASS} -p ${SRCPASSWORD} ${RSYNC} ${SRCHOST}:$SRCBACKUP/${LOGNAME} ${TMPBACKUP}
            LABEL=$?
            count=`expr $count + 1`
        done
 
        LABEL=1
        count=1
        while [[ ${LABEL} -ne 0 ]] && [[ $count -le 10 ]]
        do
           echo "rsync log from 8.1"
           ${SSHPASS} -p ${PASSWORD} ${RSYNC} -e "${SSH} -p ${PORT}" --rsync-path=/usr/bin/rsync ${TMPBACKUP}/${LOGNAME} ${REMOTEHOST}:${REMOTEBACKUP}
           LABEL=$?
           count=`expr $count + 1`
        done

        echo "rm log from 8.1"
        rm -f ${TMPBACKUP}/${LOGNAME}
 
############################get the split file name.
LABEL=1
count=0 
while [[ ${LABEL} -ne 0 ]] && [[ $count -le 10 ]]
do 
    ${SSHPASS} -p ${SRCPASSWORD} ${SSH} ${SRCHOST} "find ${SRCBACKUP} -type f -name ${PREFIX}* > ${SRCBACKUP}/file.dat"
    LABEL=$?
    count=`expr $count + 1`
done

#############################process the split file.
LABEL=1
count=0    
while [[ ${LABEL} -ne 0 ]] && [[ $count -le 10 ]]
do   
    LOOP=`${SSHPASS} -p ${SRCPASSWORD} ${SSH} ${SRCHOST} "cat ${SRCBACKUP}/file.dat"`
    LABEL=$?
    count=`expr $count + 1`
done

    for ALLFILE in ${LOOP}
    do
        FILE=`basename ${ALLFILE}`
        echo "$FILE" 
        LABEL=1
        count=1
        while [[ ${LABEL} -ne 0 ]] && [[ $count -le 10 ]]
        do
            echo "rsync ${FILE} from 6.2"
            if [[ -f ${TMPBACKUP}/${FILE} ]]
            then
                rm -f ${TMPBACKUP}/${FILE}
            fi
	    ${SSHPASS} -p ${SRCPASSWORD} ${RSYNC} ${SRCHOST}:${ALLFILE} ${TMPBACKUP} 
	    LABEL=$?
            count=`expr $count + 1` 
        done
		
	if [[ ${LABEL} -eq 0 ]] 
	then
	    LABEL=1
            count=1
            while [[ ${LABEL} -ne 0 ]] && [[ $count -le 10 ]] 
            do
               echo "rsync ${FILE} from 8.1"
               if [[ -f ${REMOTEBACKUP}/${FILE} ]]
               then
                   ${SSHPASS} -p ${PASSWORD} ${SSH} -p ${PORT} ${REMOTEHOST} "rm -f ${REMOTEBACKUP}/${FILE}"    
               fi
	       ${SSHPASS} -p ${PASSWORD} ${RSYNC} -e "${SSH} -p ${PORT}" --rsync-path=/usr/bin/rsync ${TMPBACKUP}/${FILE} ${REMOTEHOST}:${REMOTEBACKUP}
	       LABEL=$?
               count=`expr $count + 1`
	    done
        fi
		
        if [[ ${LABEL} -eq 0 ]]
	then
            echo "rm from 8.1"
	    rm -f ${TMPBACKUP}/${FILE} 
            LABEL=$?	
        fi
    done

##################################delete the split file on 6.2.
    echo "rm from 6.2"
    ${SSHPASS} -p ${SRCPASSWORD} ${SSH} ${SRCHOST} "rm -f ${SRCBACKUP}/${PREFIX}*"

#################################start the remote script on 2.202.
    if [[ ${LABEL} -eq 0 ]]
    then
        LABEL=1
        count=1
        while [[ ${LABEL} -ne 0 ]] && [[ $count -le 10 ]]
        do	
            echo "start remote script on 2.202"
            ${SSHPASS} -p ${PASSWORD} ${SSH} -p ${PORT} ${REMOTEHOST} "${REMOTEBACKUP}/${REMOTESCRIPT} ${DATE_NO} ${LASTDATE} ${NAME}"
            LABEL=$?
            count=`expr $count + 1`
        done
    fi

###################file not exist, exit.
else
    echo exit...
    exit 
fi

    echo `date` 
}

main > ${LOGFILE} 2>& 1

exit 
