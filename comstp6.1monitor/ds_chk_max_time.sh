#!/bin/bash

This_Date_Time=`date +'%Y%m%d%H%M%S'`
This_Date=`echo ${This_Date_Time} | cut -c1-8`
This_Time=`echo ${This_Date_Time} | cut -c9-14`

V_SYSTEM_FLAG=""
DB_CONN_TEXT=""

WORK_DIR="${HOME}/other/monitor"
LOG_DIR="${WORK_DIR}/log"
LOG_FILE_PN="${LOG_DIR}/ds_chk_log_"`date +'%Y%m%d'`
CUS_SCHD_CFG_FILE_PN="${LOG_DIR}/CHK_CUS_SCHD.${This_Date_Time}.cfg"
CHK_RESULT_PN="${LOG_DIR}/ds_chk_result"

CUS_NUMBER=""
CUS_NAME=""
CUS_SERIAL=""
WMS_SERIAL=""
CUS_CHK_RESULT=""
DATE_FORMAT_STP="YYYYMMDD-HH24:MI:SS"

DS_LOG_PRINT=TRUE

this_pid=$$

tlog()
{
	return 0;
	printf "[`date +'%Y-%m-%d %H:%M:%S'` %5d] $*\n" ${this_pid} >> ${LOG_FILE_PN}
}

allocation_db_conn_text()
{
	DB_CONN_TEXT=`env | grep DB_CONN_TEXT_${V_SYSTEM_FLAG} | sed -n '1,1p' | awk -F"=" '{print $2}'`

	if [ "${DB_CONN_TEXT}" = "" ]
	then
		DB_CONN_TEXT_USR=`echo ${V_SYSTEM_FLAG} | tr ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz`
		DB_CONN_TEXT_PWD=${DB_CONN_TEXT_USR}
		DB_CONN_TEXT_SID=`echo ${DB_NAME} | sed -n '1,1p' | awk -F"@" '{print $2}'`
		DB_CONN_TEXT="${DB_CONN_TEXT_USR}/${DB_CONN_TEXT_PWD}@${DB_CONN_TEXT_SID}"
	fi

	tlog "db connect : [${DB_CONN_TEXT}]"
}

get_cus_schd()
{

	V_SYSTEM_FLAG="COMSTP"
	allocation_db_conn_text
	select_cus_schd=`sqlplus -s $DB_CONN_TEXT  <<CUS_SCHD

	set serveroutput off size 1000000;
	set colsep '${TERM_CHR}'
	set echo off
	set heading off
	set feedback off
	set trimspool on
	set trimout on
	set termout off
	set pagesize 0
	set linesize 20480

	spool ${CUS_SCHD_CFG_FILE_PN}

	select '['||t.cus_number||'] ['||c.cus_name||'] serial=['||nvl(trim(t.last_serial_number),'!null!')||']'
	from comstp_schedule_config t,
	     comstp_inst c
	where t.cus_number = c.cus_number
	and t.task_node = 'SECURITY_PORTFOLIO'
	and t.activate = 'Y'
	order by t.cus_number
	;

	spool off

CUS_SCHD
`
	tlog select schd : ${select_cus_schd}
}

get_wms_max_time()
{

	V_SYSTEM_FLAG="WMS"
	allocation_db_conn_text

	WMS_SERIAL=""

	WMS_SERIAL=`sqlplus -s $DB_CONN_TEXT  <<WMS_MAX

	set serveroutput off ;
	set heading off

	select nvl(trim(max(to_char(t.modify_time,'${DATE_FORMAT_STP}'))),'!null!')
	from security_portfolio t, portfolio p
	where p.customer_number = '${CUS_NUMBER}'
	and t.portfolio = p.portfolio_seq
	;

WMS_MAX
`
	WMS_SERIAL=`echo ${WMS_SERIAL} | awk '{print $1}'`
	tlog select WMS max time : [${WMS_SERIAL}]
}

main()
{
	echo "=== ds check ${This_Date} begin ${This_Time} ===" > ${CHK_RESULT_PN}


	## 取出ComSTP机构时间戳
	get_cus_schd

	touch ${CUS_SCHD_CFG_FILE_PN}


	## 每个机构的时间戳,与WMS的max作比较
	while read cus_cfg_line
	do
		echo $cus_cfg_line

		tlog "---------"

		CUS_CHK_RESULT="ok     "
		CUS_NUMBER=`echo ${cus_cfg_line} | awk -F'[' '{print $2}' | awk -F']' '{print $1}'`
		CUS_NAME=`echo ${cus_cfg_line} | awk -F'[' '{print $3}' | awk -F']' '{print $1}'`
		CUS_SERIAL=`echo ${cus_cfg_line} | awk -F'[' '{print $4}' | awk -F']' '{print $1}'`

		tlog "cus=[${CUS_NUMBER}] serial=[${CUS_SERIAL}]  name=[${CUS_NAME}]"

		get_wms_max_time

		if [ "${WMS_SERIAL}" \> "${CUS_SERIAL}" ]
		then
			CUS_CHK_RESULT="warning"
		fi

		printf "${CUS_CHK_RESULT}\t${CUS_NUMBER}\t${CUS_NAME}\t${CUS_SERIAL}\t${WMS_SERIAL}\n" >> ${CHK_RESULT_PN}

	done < ${CUS_SCHD_CFG_FILE_PN}

	rm -f ${CUS_SCHD_CFG_FILE_PN} ${LOG_FILE_PN}

	echo "=== ds check ${This_Date} end `date +'%Y%m%d%H%M%S'` ===" >> ${CHK_RESULT_PN}
}

main

exit
