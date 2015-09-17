######################################################################
# Copyright C 2014 CFETS Financial Data Co.,LTD                      #
# All rights reserved                                                #
# File Name: lofiadm.sh
# Version:                                                           #
# Writen by canux chengwei@chinamoney.com.cn                         #
# Created Time: Fri 10 Oct 2014 04:18:51 PM CST
# Description:                                                       #
######################################################################
#!/bin/bash

MKFILE=/usr/bin/mkfile
LOFIADM=/usr/bin/lofiadm
NEWFS=/usr/bin/newfs
MOUNT=/usr/bin/mount
LS=/usr/bin/ls
GREP=/usr/bin/grep
AWK=/usr/bin/awk
CAT=/usr/bin/cat
RM=/usr/bin/rm
MKDIR=/usr/bin/mkdir
CHMOD=/usr/bin/chmod
LN=/usr/bin/ln
UMOUNT=/usr/bin/umount

PATH=/export/home
DIR=$PATH/TESTDATA

if [[ -d $DIR ]]
then
    $UMOUNT $DIR
	$RM -r $DIR
fi

if [[ -h /dev/lofi/1 ]]
then
    $LOFIADM -d /dev/lofi/1
	$RM /dev/lofi/1
fi

$MKFILE 4g $PATH/lofi.1
$LOFIADM -a $PATH/lofi.1 /dev/lofi/1
$NEWFS /dev/lofi/1
$MKDIR $DIR
$MOUNT /dev/lofi/1 $DIR
$CHMOD a+rwx $DIR
$RM -f $PATH/lofi.1

$LS -l | $GREP ^d | $AWK '{print $9}' > $DIR/data.txt
LOOP=`$CAT $DIR/data.txt`
for USER in $LOOP
do
	if [[ $USER != TESTDATA ]]
	then
		cd $DIR
		$RM -r $USER
		$MKDIR $USER
		$CHMOD a+rwx $USER

		cd $PATH/$USER
		$RM -r TESTDATA
		$LN -s $DIR/$USER $PATH/$USER/TESTDATA
	fi
done
$RM $DIR/data.txt
exit
