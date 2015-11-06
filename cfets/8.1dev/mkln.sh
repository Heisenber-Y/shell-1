#!/bin/bash
#
#Copyright C 2014 CFETS Financial Data Co.,LTD
#All rights reserved.
#192.168.8.1:/export/home/TESTDATA/mkln.sh
#v1.0
#Writen by canux chengwei@chinamoney.com.cn
#make dir and link

PATH=/export/home
DIR=$PATH/TESTDATA

ls=/usr/bin/ls
grep=/usr/bin/grep
awk=/usr/bin/awk
cat=/usr/bin/cat
rm=/usr/bin/rm
mkdir=/usr/bin/mkdir
chmod=/usr/bin/chmod
ln=/usr/bin/ln

cd $PATH
$ls -l | $grep ^d | $awk '{ print $9 }' > $DIR/data.txt
LOOP=`$cat $DIR/data.txt`

for USER in $LOOP
do
    if [ $USER != TESTDATA ]
    then
        cd $DIR
        $rm -r $USER
        $mkdir $USER
        $chmod a+w $USER
       
        cd $USER
        $mkdir TESTDATA
        $chmod a+w TESTDATA

        cd $PATH/$USER
        $rm -rf TESTDATA
        $ln -s $DIR/$USER/TESTDATA $PATH/$USER/TESTDATA
    fi
done 
