监控原理：
在kobra@192.168.176.252:/home/kobra/monitor 上的monitor.sh来启动user@192.168.8.1:/export/home/user/tmpbackup上的tmpmonitor.sh然后根据参数查出结果，如果有问题就用kobra上的sendmail.sh来发邮件。

user用户：
自动启动的
/export/home/user/apache/bin/httpd

wbs用户：
10 00 * * * $HOME/wbs_deploy/bin/start.sh启动的
/export/home/wbs/java/jdk/bin/java -Dpname=wbs_server -Dwbs.root=/export/home/wbs/wbs_deploy -Dpna

fis、cms、wms：
monitor.sh
监控客户端可以查看监控的内容
在bin目录

参考值
more monitor_config.txt

实际值   
more server_process.txt

inter用户：
monitor.sh

自动启动的
/export/home/inter/java/jre/bin/java -Xms256m -Xmx512m -jar ccbwmsfm.jar

/export/home/inter/jkdata/backup目录
白天11:00的验证文vi件：
END_KEY_5_20141105_M.dat
晚上21:00的验证文件：
END_KEY_5_20141105_N.dat

6.2上的monitor.sh获取这两个数据。
凌晨04:30和12:30两个时间点都要执行这两个sql

sqlplus   inter/face@comstar

count1
SELECT count(*) FROM ccb_record_status a
where a.business_date = &1 and a.filename like 'FESP%'||&1||'%N.dat'
;

count2
SELECT count(*) FROM ccb_record_status a
where a.business_date = &1 and a.filename like 'FESP%'||&1||'%N.dat'
and a.status <> 0
;

上述count=0都表示不正常

comstp用户：
/export/home/comstp/Tomcat/jre/bin/java -Djava.util.logging.config.file=/export
DMPS一些进程
/export/home/comstp/DMPSSVR/bin/server_monitor
/export/home/comstp/DMPSSVR/bin/cframe

comstp_server有一个，每个有2个jsvc进程， 

comstp_local有很多个，每个有2个jsvc进程， 
