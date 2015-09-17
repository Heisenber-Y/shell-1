#/bin/bash
#
#Copyright c 20140804   CFETS Financial Data Co.,LTD
#All rights reserved.
#shc/shc.sh
#v2.0
#the v1.0 writen by yao
#writen by canux chengwei@chinamoney.com.cn
#get shc data from 222.66.16.96 and copy to 192.168.8.58 and start shc.sh

    WGET=/usr/bin/wget
    UNZIP=/usr/bin/unzip
    SCP=/usr/bin/scp
    SSH=/usr/bin/ssh
    CP=/bin/cp
    MV=/bin/mv
    SSHPASS=/bin/sshpass

    SHC=/export/home/kobra/other/shc
    SHC_FILE=$SHC/shc_file
    TEMP=$SHC_FILE/TEMP
    LOGFILE=$SHC/shc.log

SECHOST=sec@10.11.11.1
SECSSHPORT=10822

if [ "$1" = "" ]
then
    DATE_NO=`date +%Y%m%d`
    CURDAY=`date +%d`
    CURMONTH=`date +%m`
    CURYEAR=`date +%Y`
else
    DATE_NO=$1
    CURYEAR=`echo $1 | awk '{print substr($0,1,4)}'`
    CURMONTH=`echo $1 | awk '{print substr($0,5,2)}'`
    CURDAY=`echo $1 | awk '{print substr($0,7,2)}'`
fi
DATE="${CURYEAR}-${CURMONTH}-${CURDAY}"
TODAY=`date +%Y%m%d`

    SRC_ZIP_NAME1="SHCH_valuation_"
    SRC_ZIP_NAME2=${DATE_NO}
    SRC_ZIP_NAME3="_excel"
    SRC_EXC_NAME=${SRC_ZIP_NAME1}
    ZIP=".zip"
    EXC=".xlsx"

    BOND1="bondNames=""&bondCodes=""&"
    BOND2="bondTypes=402880e5438a816001438a8317730007&bondTypes=402880e5438a816001438a835ab60009&bondTypes=402880e5438a816001438a82ed5d0006&bondTypes=402880e5438a816001438a82cb790005&bondTypes=402880e5438a816001438a839dbb000b&bondTypes=402880e5438a816001438a837f12000a&bondTypes=402880e5438a816001438a82a38f0004&bondTypes=402880e5438a816001438a8273c20003&bondTypes=402880e5438a816001438a833adf0008&bondTypes=ff80808146c9b061014734543a50101f&bondTypes=402880f0437b131f01437b1c606b0003&"
    BOND3="startTime=${DATE}&endTime=${DATE}&exportFlag="0""

    URL1="http://www.shclearing.com/shchapp/web/valuationclient/downloadvaluation"
    URL2="${BOND1}${BOND2}${BOND3}"
    URL="${URL1} --post-data ${URL2}"

function main
{
    echo `date`
    echo "date=${DATE}"
    echo "date_no=${DATE_NO}"
    echo "today=${TODAY}"

    NUM=1

    ${WGET} http://192.168.8.6/webAuth/index.htm --post-data="username=visitor&pwd=visitor"
    rm index.htm.*

while [[ ! -e ${TEMP}/${DATE_NO}${EXC} ]] && [[ ${NUM} -le 60 ]]
do
    echo "#########################num=${NUM}#############################"

    cd $SHC
    echo `pwd`
    if [ -f ${SHC_FILE}/${DATE_NO}${ZIP} ]; then
        rm -f ${SHC_FILE}/${DATE_NO}${ZIP}
    fi

    echo "${WGET} --user-agent=Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:31.0) Gecko/20100101 Firefox/31.0 ${URL} -O ${SHC_FILE}/${DATE_NO}${ZIP}"
    ${WGET} --user-agent="Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:31.0) Gecko/20100101 Firefox/31.0" ${URL} -O ${SHC_FILE}/${DATE_NO}${ZIP}

    cd ${SHC_FILE}
    echo `pwd`
    if [ -d ${TEMP} ]; then
        rm -rf ${TEMP}
    fi
    mkdir -p ${TEMP}
    echo "${CP} ${DATE_NO}${ZIP} ${TEMP}"
    ${CP} ${DATE_NO}${ZIP} ${TEMP}

    cd ${TEMP}
    echo `pwd`
    echo "${UNZIP} ${DATE_NO}${ZIP}"
    ${UNZIP} ${DATE_NO}${ZIP}
    echo "${MV} ${SRC_EXC_NAME}${DATE_NO}${EXC} ${DATE_NO}${EXC}"
    ${MV} ${SRC_EXC_NAME}${TODAY}${EXC} ${DATE_NO}${EXC}

    NUM=`expr ${NUM} + 1`
    sleep 60
done

    cd ${SHC}
    echo `pwd`
    echo "${SCP} -P ${SECSSHPORT} ${TEMP}/${DATE_NO}${EXC} ${SECHOST}:other/shc/shc_file/${DATE_NO}${EXC}"
    ${SSHPASS} -p *** ${SCP} -P ${SECSSHPORT} ${TEMP}/${DATE_NO}${EXC} ${SECHOST}:other/shc/shc_file/${DATE_NO}${EXC}
    echo "${SSH} -p ${SECSSHPORT} ${SECHOST}   other/shc/shc.sh shc_file ${DATE_NO}"
    ${SSHPASS} -p *** ${SSH} -p ${SECSSHPORT} ${SECHOST} "other/shc/shc.sh shc_file ${DATE_NO}"

    echo  `date`
}

main > ${LOGFILE} 2>& 1

