######################################################################
# Copyright (C) 2015 Canux CHENG.                                    #
# All rights reserved                                                #
# Name: rsync.sh
# Author: canuxcheng@gmail.com                                       #
# Version: V1.0                                                      #
# Time: 2015年04月16日 星期四 10时24分10秒
######################################################################
# Description: Used to rsync the files between the company and home.
# I use the harddrive to instead my home.
# When I go to work run this program on 9:30 in the morning.
# After work run this program on 17:30 in the afternoon.
######################################################################
#!/usr/bin/env bash

pro=`basename $0`

print_usage() {
    echo "Usage: $pro -c|d"
    echo "-c    from company or home to harddrive."
    echo "-d    from harddrive to home or company."
}

if [[ $# -ne 1 ]]
then
	print_usage
	exit 1
fi

while getopts ":cd" opt
do
	case $opt in
		c)
			echo "From company or home to harddrive."
			read -p "Enter Y/y to confirm: " res
			if [[ $res = Y ]] || [[ $res = y ]]
			then
			    rsync -avzrPH /home/$USER/Share/Share /media/$USER/Z
			    exit 0
			else
				echo "Exit..."
				exit 0
			fi;;
		d)
			echo "From harddrive to company or home."
			read -p "Enter Y/y to confirm: " res
			if [[ $res = Y ]] || [[ $res = y ]]
			then
				cd /media/$USER/Z/Share
			    rsync -avzrPH /media/$USER/Z/Share /home/$USER/Share
			    exit 0
			else
				echo "Exit..."
				exit 0
			fi;;
		*)
			print_usage
			exit 1;
	esac
done
