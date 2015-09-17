#!/bin/bash
#
#Copyright c 2014   CFETS Financial Data Co.,LTD 
#All rights reserved.
#192.168.8.1:/export/home/limit.sh
#v1.0
#writen by canux chengwei@chinamoney.com.cn
#limit /export/home/TESTDATA less than 4GB

DIR=/export/home

if [[ -e ${LOGFILE} ]]
then
    echo "file exist" > /dev/null
else
    touch -acm ${LOFGILE}
fi

#4GB=4000000kb
MAX=4000000
    
    NUM=1
    while [[ ${NUM} -eq 1 ]]
    do
        SIZE=`du -sk $DIR/TESTDATA | awk '{ print $1 }'`

        if [[ $SIZE -ge $MAX ]]
        then
            chmod -fR a-w $DIR/TESTDATA
        else
            chmod -fR a+w $DIR/TESTDATA
        fi
        sleep 10
        NUM=1
    done

exit
