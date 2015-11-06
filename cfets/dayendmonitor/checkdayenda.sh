######################################################################
# Copyright C 2014 CFETS Financial Data Co.,LTD                      #
# All rights reserved                                                #
# File Name: checkdayenda.sh
# Version:                                                           #
# Writen by canux chengwei@chinamoney.com.cn                         #
# Created Time: Fri 24 Oct 2014 10:18:25 PM CST
# Description:                                                       #
######################################################################
#!/bin/bash

SSHPASS=/arch/comstar/sshpass/bin/sshpass
#for uat a
SCRIPT=/export/home/fis/checkdayend_all_main.sh

SSH=/usr/bin/ssh

HOSTA=fis@200.31.157.214
$SSHPASS -p *** $SSH $HOSTA "$SCRIPT"
