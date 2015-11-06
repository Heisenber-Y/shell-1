######################################################################
# Copyright C 2014 CFETS Financial Data Co.,LTD                      #
# All rights reserved                                                #
# File Name:checkmsg.sh
# Version:                                                           #
# Writen by canux chengwei@chinamoney.com.cn                         #
# Created Time: Thu 23 Oct 2014 04:43:39 PM CST
# Description:                                                       #
######################################################################
#!/bin/bash

SSHPASS=/export/home/user/util/bin/sshpass
PW=`cat /export/home/user/tmpbackup/shadow | grep -v ^# | grep -w sec | awk -F, 'NR==1 {print $2}'`
$SSHPASS -p $PW ssh sec@192.168.8.58 "/export/home/sec/bin/checksec.sh"
