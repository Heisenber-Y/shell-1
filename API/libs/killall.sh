######################################################################
# Copyright (C) 2014 CFETS Financial Data Co.,LTD                    #
# All rights reserved                                                #
# Name: killall.sh
# Author: Canux canuxcheng@gmail.com                                 #
# Version: V1.0                                                      #
# Time: Thu 04 Dec 2014 04:35:04 PM CST
# Description:                                                       #
######################################################################
#!/bin/bash

#this script used for kill all related process
#you should pass $1 for the key word

if [[ "$#" -lt 1 ]] || [[ "$#" -gt 2 ]]
then
	echo "Usage: killall <process> [username]"
	exit
elif [[ "$#" -eq 1 ]]
then
	echo "Warning: all process include keyword <$1> will be killed!"
	read -p "Enter Y to continue:" VAR
	if [[ $VAR = "Y" ]] || [[ $VAR = "y" ]]
	then
	    PID=`ps -ef | grep -v grep | grep $1 | awk '{print $2}'`
		if [[ $PID = "" ]]
		then
			echo "Process not exist!"
		else
			kill -9 $PID
		fi
	else
		echo "Abort"
		exit
	fi
elif [[ "$#" -eq 2 ]]
then
	echo "Warning: the process include keyword <$1> belong to user <$2> will be killed!"
	read -p "Enter Y to continue:" VAR
	if [[ $VAR = "Y" ]] || [[ $VAR = "y" ]]
	then
		PID=`ps -fu $2 | grep -v grep | grep $1 | awk '{print $2}'`
		if [[ $PID = "" ]]
		then
			echo "Process not exist!"
		else
			kill -9 $PID
		fi
	else
		echo "Abort"
		exit
	fi
fi
