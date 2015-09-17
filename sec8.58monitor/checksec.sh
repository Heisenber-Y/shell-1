######################################################################
# Copyright C 2014 CFETS Financial Data Co.,LTD                      #
# All rights reserved                                                #
# File Name:checksec.sh
# Version:                                                           #
# Writen by canux chengwei@chinamoney.com.cn                         #
# Created Time: Thu 23 Oct 2014 04:43:39 PM CST
# Description:                                                       #
######################################################################
#!/bin/bash

if [[ "$1" = "" ]]
then
        ToDay=`date +%Y%m%d`
else
        ToDay=$1
fi

NextWorkDay_Temp=`sqlplus -s $DB_NAME <<EOF
select 'NextWorkDay:'||GET_PN_TRADE_DATES('${ToDay}', '2', 1) from dual; 
quit; 
EOF`
NextWorkDay=`echo "$NextWorkDay_Temp" | grep -i NextWorkDay:2 | awk 'BEGIN{FS=":"}{print $2}'`

YesterdayDate_Temp=`sqlplus -s $DB_NAME <<EOF
select 'YestDay:'||GET_PN_TRADE_DATES('${ToDay}', '2', -1) from dual;
quit;
EOF`
YesterdayDate_Temp_1=`echo "${YesterdayDate_Temp}" | grep YestDay`
YesterdayDate=`echo ${YesterdayDate_Temp_1} | awk 'BEGIN{FS=":"}{print $2}'`

#####################################
SQL[1]="select 'cmds_repo_fixing='||count(*) from cmds_repo_fixing where  t_date='${ToDay}';"
SQL[2]="select 'cmds_repo_fr007_fixing='||count(*) from cmds_repo_fr007_fixing where t_date='${NextWorkDay}';"
SQL[3]="select 'cmds_shibor_fixing='||count(*) from cmds_shibor_fixing where  t_date='${ToDay}';"
SQL[4]="select 'cmds_shibor_moving_avg='||count(*) from cmds_shibor_moving_avg where  t_date='${ToDay}';"
SQL[5]="select 'CMDS_LPR_FIXING='||count(*) from CMDS_LPR_FIXING where t_date='${ToDay}';"
SQL[6]="select 'CMDS_LPR_MOVING_AVG='||count(*) from CMDS_LPR_MOVING_AVG where t_date='${ToDay}';"
SQL[7]="select 'OFX='||count(*) from ohlcv o where o.pricing_date='${ToDay}' and o.id like 'FX%';"
SQL[8]="select 'OIRS='||count(*) from ohlcv o where o.pricing_date='${ToDay}' and o.id like 'IRS%';"
SQL[9]="select 'RLI='||count(*) from rate_index_value r where r.rate_date=${YesterdayDate} and r.rate_index like 'LI%';"
SQL[10]="select 'OLI='||count(*) from ohlcv o where o.pricing_date=${YesterdayDate} and o.id like 'LI%';"
SQL[11]="select 'Sibor='||count(*) from ohlcv o where o.pricing_date=${YesterdayDate} and o.id like 'SI%';"
SQL[12]="select 'Hibor='||count(*) from ohlcv o where o.pricing_date=${YesterdayDate} and o.id like 'HI%';"
SQL[13]="select 'icap_irs='||count(*) from ohlcv where pricing_date='${ToDay}' and id like '%CFIC%';"
SQL[14]="select 'tullett_IRS='||count(*) from ohlcv where pricing_date='${ToDay}' and  id like '%TPSC%';"
SQL[15]="select 'OCGB='||count(*) from ohlcv where pricing_date='${ToDay}' and id='CGBYTM1.0Y';"
SQL[16]="select 'NR='||count(*) from rate_index_value where rate_date=
(select BUSINESS_DATE from system_data where BUSINESS_DATE > to_char(sysdate,'YYYYMMDD'));"
SQL[17]="select 'OIDX='||count(*) as ohlcv_index_count from ohlcv where pricing_date='${ToDay}' and id in
(select source_id from rate_index);"
SQL[18]="select 'RIDX='||count(*) as rate_index_value_count from rate_index_value where rate_date='${ToDay}';"
SQL[19]="select 'CMDSOHLCV='||count(*) from ohlcv where pricing_date in ('${ToDay}') and (id like '%CFHB%' or id like '%CFHA%');"
SQL[20]="select 'CMDS_CCS_CURVE_REAL='||count(*) from CMDS_CCS_CURVE_REAL where t_date='${ToDay}'  and t_time>='16:00:00';"
SQL[21]="select 'CMDS_SWAP_CURVE_REAL='||count(*) from CMDS_SWAP_CURVE_REAL  where t_date='${ToDay}' and t_time>='16:00:00';"
SQL[22]="select 'CMDS_SWAPRATE_CURVE_REAL='||count(*) from CMDS_SWAPRATE_CURVE_REAL where t_date='${ToDay}' and t_time>='16:00:00';"
SQL[23]="select 'CMDS_IRS_CURVE_REAL='||count(*) from CMDS_IRS_CURVE_REAL where t_date='${ToDay}' and t_time>='16:00:00';"
SQL[24]="select 'CMDS_SEC_CLOSE_CURVE_NEW='||count(*) from CMDS_SEC_CLOSE_CURVE_NEW  where t_date='${ToDay}' and t_time>='16:00:00';"
SQL[25]="select 'cmds_fx_market='||count(*) from cmds_fx_market t_time where t_date='${ToDay}' and (t_time>='16:00:00' and t_time<='16:40:00');"
SQL[26]="select 'cmds_quotation='||count(*) from cmds_quotation where t_date='${ToDay}' and t_time>='16:00:00' and c_5 is not null;"
SQL[27]="select 'cmds_fx_mid='||count(*) from cmds_fx_mid where  t_date='${ToDay}';"
SQL[28]="select 'cmds_shibor3m_irs_curve='||count(*) from cmds_shibor3m_irs_curve where  t_date='${ToDay}';"
SQL[29]="select 'OHLCV_cmds='||count(*) from (select * from ohlcv where pricing_date ='${ToDay}' and (id='CNY=CFHB' or id='CNY=CFHBMID'));"
SQL[30]="select 'OHLCV_icap_irs='||count(*) from (select distinct(substr(id,1,4)) from ohlcv where pricing_date='${ToDay}' and id like '%CFIC%');"
SQL[31]="select 'OHLCV_tullett_irs='||count(*) from (select distinct(substr(id,1,4)) from ohlcv where pricing_date='${ToDay}' and  id like '%TPSC%');"
SQL[32]="select 'CDCFP='||count(*) a_count from cdc_fp where pricing_date=to_char(sysdate,'YYYYMMDD') and valid=1;"
SQL[33]="select 'FPMORE='||count(*) as b_count from cdc_fp where pricing_date=to_char(sysdate,'YYYYMMDD') and valid=1 and security_code not in
(select security_code from security where maturity_date >= to_char(sysdate,'YYYYMMDD')
 and substr(security_code,1,1) in ('0','1','2','3','4','5','6','7','8','9'));"
SQL[34]="select 'OCDC='||count(*) as c_count from
(select rtrim(ltrim((id))) ohlcv_id from ohlcv A where pricing_date=to_char(sysdate,'YYYYMMDD') and id like 'CN%=CDC%') AA,
(select rtrim(ltrim(B.cdc_symbol)) cdc_symbol from security B,
  (select security_code from cdc_fp where pricing_date=to_char(sysdate,'YYYYMMDD') and valid=1
  ) C where B.security_code=C.security_code
) BB where AA.ohlcv_id=BB.cdc_symbol;"
SQL[35]="select 'OEB='||count(*) from cdc_fp_oeb where pricing_date=${ToDay};"
SQL[36]="select 'diff='||abs(AAA.count1-BBB.count2-CCC.count3) from
(select count(*) count1 from cdc_fp where pricing_date='${ToDay}' and valid=1) AAA,
(select count(*) count2 from cdc_fp where pricing_date='${ToDay}' and valid=1 and security_code not in
  (select security_code from security where maturity_date >='${ToDay}'
    and substr(security_code,1,1) in ('0','1','2','3','4','5','6','7','8','9')
  )
) BBB,
(select count(*) count3 from 
  (select rtrim(ltrim((id))) ohlcv_id from ohlcv A where pricing_date='${ToDay}' and id like 'CN%=CDC%') AA,
  (select rtrim(ltrim(B.cdc_symbol)) cdc_symbol from security B,
    (select security_code from cdc_fp where pricing_date='${ToDay}' and valid=1) C 
    where B.security_code=C.security_code
  ) BB 
  where AA.ohlcv_id=BB.cdc_symbol
) CCC;"
SQL[37]="select 'oebdiff='||abs(AA.today_count-BB.preday_count) from (select count(*) as today_count from cdc_fp_oeb where pricing_date='${ToDay}') AA,(select count(*) as preday_count from cdc_fp_oeb where pricing_date=${YesterdayDate}) BB;"
SQL[38]="select 'OHLCV='||count(*) from ohlcv where pricing_date='${ToDay}';"
SQL[39]="select 'OSHC='||count(*) from ohlcv where pricing_date='${ToDay}' and id like '%=SHC%';"
SQL[40]="select 'SHCFP='||count(*) from shc_fp where pricing_date='${ToDay}';"
SQL[41]="select 'OYC='||count(*) from ohlcv where pricing_date='${ToDay}' and id in
(select ohlcv_id from yield_curve_id);"
SQL[42]="select 'YVol='||count(*) from yield_volatility where to_char(update_date,'YYYYMMDD')='${ToDay}';"
SQL[43]="select 'YHis='||count(*) from yield_volatility_his where to_char(update_date,'YYYYMMDD')='${ToDay}';"

##########################################
for((i=1;i<=${#SQL[@]};i++))
do
    Ret[$i]=`sqlplus -s $DB_NAME<<EOF
    ${SQL[i]}
    quit;
    EOF`
    RetCount[$i]=`echo "${Ret[$i]}" | tail -1`
    WriteFile=${WriteFile}"\n""Sql:" 
    WriteFile=${WriteFile}"\n"${SQL[i]}
    WriteFile=${WriteFile}"\n""Sql Ret:" 
    WriteFile=${WriteFile}"\n"${RetCount[i]}"\n"
    WriteFile=${WriteFile}"\n""-------------------------------"
    eval "${RetCount[$i]}"
done

#############cmds##################
isSatSunday=`date +%w`
if [[ "${isSatSunday}" = "6" ]] || [[ "${isSatSunday}" = "0" ]]
then
        CMDSOHLCV=9999
        CMDS_CCS_CURVE_REAL=9999
        CMDS_SWAP_CURVE_REAL=9999
        cmds_fx_market=9999
        cmds_fx_mid=9999
        CMDS_SWAPRATE_CURVE_REAL=9999
fi

if [[ ${CMDSOHLCV} -ne 0 ]] &&\
        [[ ${CMDS_CCS_CURVE_REAL} -ne 0 ]] &&\
        [[ ${CMDS_SWAP_CURVE_REAL} -ne 0 ]] &&\
        [[ ${CMDS_SWAPRATE_CURVE_REAL} -ne 0 ]] &&\
        [[ ${CMDS_IRS_CURVE_REAL} -ne 0 ]] &&\
        [[ ${CMDS_SEC_CLOSE_CURVE_NEW} -ne 0 ]] &&\
        [[ ${cmds_fx_market} -ne 0 ]] &&\
        [[ ${cmds_quotation} -ne 0 ]] &&\
        [[ ${cmds_repo_fixing} -ne 0 ]] &&\
        [[ ${cmds_fx_mid} -ne 0 ]] &&\
        [[ ${cmds_shibor_fixing} -ne 0 ]] &&\
        [[ ${cmds_shibor3m_irs_curve} -ne 0 ]] &&\
        [[ ${cmds_shibor_moving_avg} -ne 0 ]] &&\
        [[ ${icap_irs} -ne 0 ]] &&\
        [[ ${tullett_IRS} -ne 0 ]] &&\
        [[ ${cmds_repo_fr007_fixing} -ne 0 ]]
then
        cmds=S
else
        cmds=F
fi

###################Uts######################
Temp_1=`tail -1 $HOME/log/import_security_price.log | awk '{print $1}'`
Temp_2=`tail -1 $HOME/log/import_security_price.log | awk '{print $6}'`

if [ "X${Temp_1}" = "X${ToDay}" ] && [ "X${Temp_2}" = "Xsuccessful" ];then
        Uts=S 
else
        Uts=F
fi

Temp_1=`tail -1 $HOME/log/import_stock_quote.log | awk '{print $1}'`
Temp_2=`tail -1 $HOME/log/import_stock_quote.log | awk '{print $6}'`

if [ "X${Temp_1}" = "X${ToDay}" ] && [ "X${Temp_2}" = "Xsuccessful" ];then
        Uts2=S
else
        Uts2=F
fi

#############################################
WEEK=`date +%w`
HOUR=`date +%H`
if [[ $WEEK -eq 1 ]] && [[ $HOUR -eq 12 ]]
then
    echo "" > /export/home/sec/checksec.log
fi

function main {
echo "###############`date`###############"

#1630
echo cmds_repo_fixing=${cmds_repo_fixing}
echo cmds_repo_fr007_fixing=${cmds_repo_fr007_fixing}
echo cmds_shibor_fixing=${cmds_shibor_fixing}
echo cmds_shibor_moving_avg=${cmds_shibor_moving_avg}
echo CMDS_LPR_FIXING=${CMDS_LPR_FIXING}
echo CMDS_LPR_MOVING_AVG=${CMDS_LPR_MOVING_AVG}
echo OFX=${OFX}
echo OIRS=${OIRS}
echo RLI=${RLI}
echo OLI=${OLI}
echo Sibor=${Sibor}
echo Hibor=${Hibor}

#1800
echo OICAP=${icap_irs}
echo OTUL=${tullett_IRS}
echo OCGB=${OCGB}
echo cmds=${cmds}

#1830
echo NR=${NR}
echo OIDX=${OIDX}
echo RIDX=${RIDX}
echo CMDS_CCS_CURVE_REAL=${CMDS_CCS_CURVE_REAL}
echo CMDS_SWAP_CURVE_REAL=${CMDS_SWAP_CURVE_REAL}
echo CMDS_SWAPRATE_CURVE_REAL=${CMDS_SWAPRATE_CURVE_REAL}
echo CMDS_IRS_CURVE_REAL=${CMDS_IRS_CURVE_REAL}
echo CMDS_SEC_CLOSE_CURVE_NEW=${CMDS_SEC_CLOSE_CURVE_NEW}
echo cmds_fx_market=${cmds_fx_market}
echo cmds_quotation=${cmds_quotation}
echo cmds_fx_mid=${cmds_fx_mid}
echo cmds_shibor3m_irs_curve=${cmds_shibor3m_irs_curve}
echo OHLCV_cmds=${OHLCV_cmds}
echo OHLCV_icap_irs=${OHLCV_icap_irs}
echo OHLCV_tullett_irs=${OHLCV_tullett_irs}

echo CDCFP=${CDCFP}
echo FPMORE=${FPMORE}
echo OCDC=${OCDC}
echo OEB=${OEB}
echo diff=${diff}
echo oebdiff=${oebdiff}

echo Uts=${Uts}
echo Uts2=${Uts2}

#2000
echo OHLCV=${OHLCV}
echo OSHC=${OSHC}
echo SHCFP=${SHCFP}
echo OYC=${OYC}

#2350
echo YVol=${YVol}
echo YHis=${YHis}

#bond time
tail $HOME/log/sendbond.log | grep ENDRESULT
tail $HOME/log/sendbond_ccbtrial.log | grep ENDRESULT

echo "###############`date`###############"
}

main >> /export/home/sec/checksec.log 

echo cmds_repo_fixing=${cmds_repo_fixing}
echo cmds_repo_fr007_fixing=${cmds_repo_fr007_fixing}
echo cmds_shibor_fixing=${cmds_shibor_fixing}
echo cmds_shibor_moving_avg=${cmds_shibor_moving_avg}
echo CMDS_LPR_FIXING=${CMDS_LPR_FIXING}
echo CMDS_LPR_MOVING_AVG=${CMDS_LPR_MOVING_AVG}
echo OFX=${OFX}
echo OIRS=${OIRS}
echo RLI=${RLI}
echo OLI=${OLI}
echo Sibor=${Sibor}
echo Hibor=${Hibor}
echo OICAP=${icap_irs}
echo OTUL=${tullett_IRS}
echo OCGB=${OCGB}
echo cmds=${cmds}
echo NR=${NR}
echo OIDX=${OIDX}
echo RIDX=${RIDX}
echo CMDS_CCS_CURVE_REAL=${CMDS_CCS_CURVE_REAL}
echo CMDS_SWAP_CURVE_REAL=${CMDS_SWAP_CURVE_REAL}
echo CMDS_SWAPRATE_CURVE_REAL=${CMDS_SWAPRATE_CURVE_REAL}
echo CMDS_IRS_CURVE_REAL=${CMDS_IRS_CURVE_REAL}
echo CMDS_SEC_CLOSE_CURVE_NEW=${CMDS_SEC_CLOSE_CURVE_NEW}
echo cmds_fx_market=${cmds_fx_market}
echo cmds_quotation=${cmds_quotation}
echo cmds_fx_mid=${cmds_fx_mid}
echo cmds_shibor3m_irs_curve=${cmds_shibor3m_irs_curve}
echo OHLCV_cmds=${OHLCV_cmds}
echo OHLCV_icap_irs=${OHLCV_icap_irs}
echo OHLCV_tullett_irs=${OHLCV_tullett_irs}
echo CDCFP=${CDCFP}
echo FPMORE=${FPMORE}
echo OCDC=${OCDC}
echo OEB=${OEB}
echo diff=${diff}
echo oebdiff=${oebdiff}
echo Uts=${Uts}
echo Uts2=${Uts2}
echo OHLCV=${OHLCV}
echo OSHC=${OSHC}
echo SHCFP=${SHCFP}
echo OYC=${OYC}
echo YVol=${YVol}
echo YHis=${YHis}
echo $HOME/log/sendbond.log=`tail $HOME/log/sendbond.log | grep ENDRESULT | awk -F':' '{print $1":"$2":"$3}'`
echo $HOME/log/sendbond_ccbtrial.log=`tail $HOME/log/sendbond_ccbtrial.log | grep ENDRESULT | awk -F':' '{print $1":"$2":"$3}'`

#################################################
exit
