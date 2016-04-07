######################################################################
# Copyright (C) 2014 CFETS Financial Data Co.,LTD                    #
# All rights reserved                                                #
# Name: sedreplace.sh
# Author: Canux canuxcheng@gmail.com                                 #
# Version: V1.0                                                      #
# Time: Thu 11 Dec 2014 05:48:45 PM CST
# Description:                                                       #
######################################################################
#!/bin/bash

#used for replace a string from a file
#Usage: sedreplace <oldstring> <newstring> <filename>

if [[ $# -lt 3 ]] || [[ $# -gt 4 ]]
then
	echo "Usage: sedreplace <oldstring> <newstring> <filename> [newfilename]"
	exit
fi

if [[ ! -f $3 ]]
then
	echo "$3 must be a file!"
	exit
fi

OLDSTRING=$1
NEWSTRING=$2
FILENAME=$3

if [[ $# -eq 3 ]]
then
	sed 's/'$OLDSTRING'/'$NEWSTRING'/' $FILENAME
elif [[ $# -eq 4 ]]
then
    NEWFILENAME=$4
	echo "the new line will write to $4."
    sed 's/'$OLDSTRING'/'$NEWSTRING'/w '$NEWFILENAME'' $FILENAME
fi

exit
