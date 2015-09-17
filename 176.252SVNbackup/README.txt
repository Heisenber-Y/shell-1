###############################################################################
在svn@192.168.176.252上用remote_backup.sh将当天的文件传到user@222.66.16.96上
传输速度2mb/s
传一个删除一个是因为中转空间不足，空间足够可以一次传完。
将user@222.66.16.96上的文件用local_backup.sh传到root@192.168.2.209上
传输速度12mb/s
建立ssh tunnel 直接从192.168.2.202中转

cron 01：30

备份机制：
保留1天        
最近的5个周五保留              
最近的1个月的最后一个周五的保留   


20G


authz_${DATE_NO}.ComstarDmpFile.tar.gz
conf_${DATE_NO}.ComstarDmpFile.tar.gz
conf.d_${DATE_NO}.ComstarDmpFile.tar.gz
pgsql_${DATE_NO}.ComstarDmpFile.tar.gz
Svn_Comstar_${DATE_NO}.ComstarDmpFile.tar.gz
Svn_ComstarDoc_${DATE_NO}.ComstarDmpFile.tar.gz
Svn_ComstarFMS_${DATE_NO}.ComstarDmpFile.tar.gz
Svn_ComSTP_${DATE_NO}.ComstarDmpFile.tar.gz
Svn_Interface_${DATE_NO}.ComstarDmpFile.tar.gz
Svn_LiHui_${DATE_NO}.ComstarDmpFile.tar.gz
Svn_Project_${DATE_NO}.ComstarDmpFile.tar.gz
Svn_RMS_${DATE_NO}.ComstarDmpFile.tar.gz
Svn_WBS_${DATE_NO}.ComstarDmpFile.tar.gz
Trac_${DATE_NO}.ComstarDmpFile.tar.gz
tunnel_${DATE_NO}.ComstarDmpFile.tar.gz
Updater_${DATE_NO}.ComstarDmpFile.tar.gz


192.168.176.252：20G
