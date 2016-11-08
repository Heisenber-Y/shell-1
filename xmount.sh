######################################################################
# Copyright (C) 2015 Canux CHENG                                     #
# All rights reserved                                                #
# Name: mount.sh
# Author: Canux canuxcheng@gmail.com                                 #
# Version: V1.0                                                      #
# Time: 2015年04月14日 星期二 13时40分53秒
######################################################################
# Description: Used to install the plugin.
# Which used to share the folder between windows and linux on virtualbox.
######################################################################
#!/usr/bin/env bash

if [[ $# -lt 1 ]]
then
	echo "Usage: -i -m [windows-share-folder] [linux-share-folder]"
else
    case $1 in
    	-i)
	    	cd /media/$USER/;cd VBOXADDITIONS*
	    	sudo ./VBoxLinuxAdditions.run
	    	shift;;
    	-m)
			if [[ $# -lt 3 ]]
			then
				echo "Usage: -m [wshare] [lshare]"
			else
			    wshare=$2
			    lshare=$3
                sudo mount -t vboxsf $wshare $lshare
			fi
		    shift;;
		--help)
			echo "Usage: -i -m [windows-share-folder] [linux-share-folder]"
			echo "-i        install addtions"
			echo "-m        mount the shared folder"
			echo "--help    display this help and exit"
			shift;;
	    *)
	        echo "Internal error!"
		    exit 1;;
    esac
fi
