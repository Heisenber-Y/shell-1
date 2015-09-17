######################################################################
# Copyright C 2014 CFETS Financial Data Co.,LTD                      #
# All rights reserved                                                #
# File Name:checkdayend.sh
# Version:                                                           #
# Writen by canux chengwei@chinamoney.com.cn                                 #
# Created Time: Fri 24 Oct 2014 10:18:25 PM CST
# Description:                                                       #
######################################################################
#!/bin/bash

IPLIST=/export/home/user/tmpbackup/iplist.txt
DIR=/export/home/user/tmpbackup
SSHPASS=/export/home/user/util/bin/sshpass

LOOP=`cat $IPLIST | grep -v ^# | awk -F, '{print $1}' | cat` 
for IP in $LOOP
do
    echo "############################################################$IP###################################################################"
    PASSWD=`cat $IPLIST | grep -v ^# | grep -w ${IP} | awk -F, '{print $2}'`
    SCRIPT=`cat $IPLIST | grep -v ^# | grep -w ${IP} | awk -F, '{print $3}'`

    TMP=`echo ${IP} | awk -F. '{print $1}'` 
    if [[ $TMP -eq 192 ]]
    then 
        $SSHPASS -p $PASSWD ssh fis@${IP} "$SCRIPT"
    elif [[ $TMP -eq 200 ]]
    then
        $SSHPASS -p $PASSWD ssh -p 22010 comstar@gagaga "bash $SCRIPT"
    fi
done

exit
