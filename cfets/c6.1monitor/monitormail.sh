######################################################################
# Copyright C 2014 CFETS Financial Data Co.,LTD                      #
# All rights reserved                                                #
# Name: sendmail.sh
# Author: Canux chengwei@chinamoney.com.cn                           #
# Version: V1.0                                                      #
# Time: Thu 06 Nov 2014 04:31:19 PM CST
# Description:                                                       #
######################################################################
#!/bin/bash

DATE=`date +%Y%m%d`
TODAY=`date`

if [[ "$1" = fis ]] || [[ "$1" = cms ]] || [[ "$1" = wms ]]
then
    echo "$1@192.168.6.1: <$2> is error, actual value = $3, reference value = $4 !" | mailx -s "C ERROR!!! <$TODAY>" chengwei@chinamoney.com.cn,huangzhensheng@chinamoney.com.cn,maoyingjun@chinamoney.com.cn,yaoxingzhong@chinamoney.com.cn,huyanpeng@chinamoney.com.cn,yangpeiqing@chinamoney.com.cn

elif [[ "$1" = user ]] || [[ "$1" = wbs ]] || [[ "$1" = comstp ]]
then
    if [[ "$2" = "local" ]]
    then
        echo "$1@192.168.6.1: <$2> process not exist, actual value = $3, reference value = $4 !" | mailx -s "C ERROR!!! <$TODAY>" chengwei@chinamoney.com.cn,huangzhensheng@chinamoney.com.cn,maoyingjun@chinamoney.com.cn,yaoxingzhong@chinamoney.com.cn,huyanpeng@chinamoney.com.cn,yangpeiqing@chinamoney.com.cn
    else
        echo "$1@192.168.6.1: <$2> process not exist !" | mailx -s "C ERROR!!! <$TODAY>" chengwei@chinamoney.com.cn,huangzhensheng@chinamoney.com.cn,maoyingjun@chinamoney.com.cn,yaoxingzhong@chinamoney.com.cn,huyanpeng@chinamoney.com.cn,yangpeiqing@chinamoney.com.cn
    fi
  
elif [[ "$1" = inter ]]
then
    if [[ "$2" = pro ]]
    then
        echo "$1@192.168.6.1: <$3> process not exist !" | mailx -s "C ERROR!!! <$TODAY>" chengwei@chinamoney.com.cn,huangzhensheng@chinamoney.com.cn,maoyingjun@chinamoney.com.cn,yaoxingzhong@chinamoney.com.cn,huyanpeng@chinamoney.com.cn,yangpeiqing@chinamoney.com.cn
    elif [[ "$2" = db ]]
    then
        if [[ "$3" = sql1 ]]
        then
            echo "$1@192.168.6.1: SELECT count(*) FROM ccb_record_status a where a.business_date = &1 and a.filename like 'FESP%'||&1||'%N.dat' = 0 !" | mailx -s "C ERROR!!! <$TODAY>" chengwei@chinamoney.com.cn,huangzhensheng@chinamoney.com.cn,maoyingjun@chinamoney.com.cn,yaoxingzhong@chinamoney.com.cn,huyanpeng@chinamoney.com.cn,yangpeiqing@chinamoney.com.cn
        elif [[ "$3" = sql2 ]]
        then
            echo "$1@192.168.6.1: SELECT count(*) FROM ccb_record_status a where a.business_date = &1 and a.filename like 'FESP%'||&1||'%N.dat' and a.status <> 0 = 0 !" | mailx -s "C ERROR!!! <$TODAY>" chengwei@chinamoney.com.cn,huangzhensheng@chinamoney.com.cn,maoyingjun@chinamoney.com.cn,yaoxingzhong@chinamoney.com.cn,huyanpeng@chinamoney.com.cn,yangpeiqing@chinamoney.com.cn
        fi
 
    elif [[ "$2" = nfile ]] || [[ "$2" = mfile ]]
    then
        echo "$1@192.168.6.1: <$3> file not exist !" | mailx -s "C ERROR!!! <$TODAY>" chengwei@chinamoney.com.cn,huangzhensheng@chinamoney.com.cn,maoyingjun@chinamoney.com.cn,yaoxingzhong@chinamoney.com.cn,huyanpeng@chinamoney.com.cn,yangpeiqing@chinamoney.com.cn
    fi
fi
