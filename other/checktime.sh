######################################################################
# Copyright C 2014 CFETS Financial Data Co.,LTD                      #
# All rights reserved                                                #
# File Name: checktime.sh
# Version:                                                           #
# Writen by canux chengwei@chinamoney.com.cn                                 #
# Created Time: Fri 24 Oct 2014 10:18:25 PM CST
# Description:                                                       #
######################################################################
#!/bin/bash

SSHPASS=/export/home/user/util/bin/sshpass
SSH=/bin/ssh
PW=`cat /export/home/user/tmpbackup/shadow | grep -v ^# | grep -w comstp | awk -F, 'NR==1 {print $2}'`
$SSHPASS -p $PW $SSH comstp@192.168.6.1 "tail /export/home/comstp/bond/log/getbond.log | grep ENDRESULT"
