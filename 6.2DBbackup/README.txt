backup the data from 192.168.6.2 

oracle@192.168.6.2:/export/home/oracle/backup_db
已备份到oracle@192.168.6.3:/export/home/oracle/backupdb8.2

fis_cms_wms_etluser_comstp_comstplc_wbs_bond_inter_20140909.JianHangDmp
fis_cms_wms_etluser_comstp_comstplc_wbs_bond_inter_20140909.JianHangDmp.log


cron  02：00

12Gb

先拆分split成3个4g的
再cat合并
用md5验证

01:00之前本地到处完毕，01:30开始备份，保留七天的。
oracle@192.168.6.2:/export/home/oracle/backup_db
备份到root@192.168.2.209:/export/home/oracle/backup_db

/export/home/user/util/bin/sshpass


这个脚本在sunos上跑，所以和linux的有区别：
用bash才能正常在cron里面跑
06 19 * * * bash /export/home/user/tmpbackup/remote_backup.sh &

备份机制：
保留1天        
最近的5个周五保留              
最近的1个月的最后一个周五的保留   

