######################################################################
# Copyright C 2014 CFETS Financial Data Co.,LTD                      #
# All rights reserved                                                #
# File Name:mail.sh
# Version:                                                           #
# Writen by canux chengwei@chinamoney.com.cn                         #
# Created Time: Thu 23 Oct 2014 04:43:39 PM CST
# Description:                                                       #
######################################################################
#!/bin/bash

DIR=/export/home/kobra/monitor
FILE=$DIR/dayend_process.txt

$DIR/dayend.sh

echo "" > $DIR/dayendmail.txt
LOOP=`cat $FILE`
IFSOLD=$IFS
IFS=$'\n'
for DAT in $LOOP
do
    PRO=`echo "$DAT" | awk '{print $1}'`
    USERNAME=`echo "$DAT" | awk '{print $2}'`
    IP=`echo "$DAT" | awk '{print $3}'`
    SROLL=`echo "$DAT" | awk '{print $4}'`
    if [[ $PRO = N ]] && [[ $IP = "192.168.6.1" ]]
    then
        if [[ $SROLL = "" ]]
        then
            echo "$USERNAME@$IP: <$USERNAME> system_dayend error." >> $DIR/dayendmail.txt
        else
            echo "$USERNAME@$IP: <$SROLL> roll_dayend error." >> $DIR/dayendmail.txt
        fi
    fi
done
IFS=$IFSOLD

rm $DIR/checkdayend.log
touch $DIR/checkdayend.log
LOOP=`cat $DIR/checkdayend.dat`
for VAL in $LOOP
do
    sys=`echo $VAL | awk -F',' '{print $1}'`
    if [[ `echo $VAL | awk -F',' '{print $2}'` != "" ]]
    then
        rol=`echo $VAL | awk -F',' '{print $2}'`
        if [[ `cat $DIR/dayendmail.txt | grep -w $sys` != "" ]]
        then
            if [[ `cat $DIR/dayendmail.txt | grep -w $rol` != "" ]]
            then
                echo "$sys.$rol=N" >> $DIR/checkdayend.log
            else
                echo "$sys.$rol=Y" >> $DIR/checkdayend.log
            fi
        else
            echo "$sys.$rol=Y" >> $DIR/checkdayend.log
        fi
    else
        if [[ `cat $DIR/dayendmail.txt | grep -w $sys` != "" ]]
        then
            echo "$sys=N" >> $DIR/checkdayend.log
        else
            echo "$sys=Y" >> $DIR/checkdayend.log
        fi
    fi
done
            
#get the sec data
SSHPASS=/bin/sshpass
PW=`cat $DIR/shadow | grep -v ^# | grep -w user | grep -w 210.22.151.39 | awk -F, 'NR==1 {print $3}'`
HOST=user@210.22.151.39
TMP=/export/home/user/tmpbackup
SCRIPT=$TMP/tmpmail.sh
$SSHPASS -p $PW ssh $HOST "$SCRIPT"
$SSHPASS -p $PW ssh $HOST "cat $TMP/checksec.log" > $DIR/checksec.log
$SSHPASS -p $PW ssh $HOST "cat $TMP/checkbond.log" > $DIR/checkbond.log

TIME=`$SSHPASS -p $PW ssh $HOST "/export/home/user/tmpbackup/checktime.sh"` 
echo "comstp.time=$TIME" > $DIR/checktime.log
            
rm $DIR/checkall.log
touch $DIR/checkall.log
cat $DIR/checksec.log | awk -F'=' '{print $2}' >> $DIR/checkall.log
cat $DIR/checkbond.log | awk -F'=' '{print $2}' >> $DIR/checkall.log
cat $DIR/checktime.log | awk -F'=' '{print $2}' >> $DIR/checkall.log
cat $DIR/checkdayend.log | awk -F'=' '{print $2}' >> $DIR/checkall.log



python $DIR/excel.py



TODAY=`date +%Y%m%d`
F=`cat $DIR/dayendmail.txt`
if [[ $F != "" ]]
then

    mailx -a "$DIR/${TODAY}.xls" -s "[ERROR] The basic data and C production <`date +%Y%m%d`>" -c littlesun@chinamoney.com.cn,lingzhangfeng@chinamoney.com.cn,zhaoshasha@chinamoney.com.cn,tangjietao@chinamoney.com.cn,yuhang@chinamoney.com.cn chengwei@chinamoney.com.cn,huangzhensheng@chinamoney.com.cn,maoyingjun@chinamoney.com.cn,yaoxingzhong@chinamoney.com.cn,huyanpeng@chinamoney.com.cn,yangpeiqing@chinamoney.com.cn,liangxin@chinamoney.com.cn,wangjinqi@chinamoney.com.cn < $DIR/dayendmail.txt

else

    echo "All ok!" | mailx -a "$DIR/${TODAY}.xls" -s "[OK] The basic data and C production <`date +%Y%m%d`>" -c littlesun@chinamoney.com.cn,lingzhangfeng@chinamoney.com.cn,zhaoshasha@chinamoney.com.cn,tangjietao@chinamoney.com.cn,yuhang@chinamoney.com.cn chengwei@chinamoney.com.cn,huangzhensheng@chinamoney.com.cn,maoyingjun@chinamoney.com.cn,yaoxingzhong@chinamoney.com.cn,huyanpeng@chinamoney.com.cn,yangpeiqing@chinamoney.com.cn 

#for test
#    mailx -a "$DIR/${TODAY}.xls" -s "[ERROR] The basic data and C production <`date +%Y%m%d`>" chengwei@chinamoney.com.cn < $DIR/dayendmail.txt
#else
#    echo "All ok!" | mailx -a "$DIR/${TODAY}.xls" -s "[OK] The basic data and C production <`date +%Y%m%d`>" chengwei@chinamoney.com.cn

fi

rm $DIR/${TODAY}.xls
    
exit
