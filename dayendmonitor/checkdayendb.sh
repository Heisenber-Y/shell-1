######################################################################
# Copyright C 2014 CFETS Financial Data Co.,LTD                      #
# All rights reserved                                                #
# File Name: checkdayendb.sh
# Version:                                                           #
# Writen by canux chengwei@chinamoney.com.cn                         #
# Created Time: Fri 24 Oct 2014 10:18:25 PM CST
# Description:                                                       #
######################################################################
#!/bin/bash

SSHPASS=/arch/comstar/sshpass/bin/sshpass
#for uat b
SCRIPT2=/home/fis/checkdayend_all_main.sh

SSH=/usr/bin/ssh

HOSTB=fis@200.31.154.30
$SSHPASS -p *** $SSH $HOSTB "$SCRIPT2"
