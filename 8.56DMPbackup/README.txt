######################################################
��backup@192.168.8.56����remote_backup.sh��������ļ�����root@192.168.2.209

����ssh tunnel ֱ����ת����
ssh -p 20922 user@192.168.8.1   password:usercomstar  -> user@192.168.2.209

ssh -p 9001 -F /home/svn/tunnel/ssh_config -f -NgL 192.168.176.252:20922:192.168.2.209:22 user@222.66.16.96
ssh -F /home/svn/tunnel/ssh_config -f -NgR 192.168.8.1:20922:192.168.176.252:20922 user@210.22.151.39

cron 04��30

25GB

9��
���ݻ��ƣ�
����1��        
�����5�����屣��              
�����1���µ����һ������ı���   

192.168.8.56��
#1_dev_src_file  
export_home_mms_data_20140814.tar.gz
������
63      930M
02��00֮ǰ���챸����

#2_oracle_dmp_file  
9.2G    fis_cms_wms_eds_etluser_bdx_comstp_comstpdev_inter_20140812.dmp
552K    fis_cms_wms_eds_etluser_bdx_comstp_comstpdev_inter_20140812.log
02��00֮ǰ���챸���꣬����ÿ�춼��

#2_oracle_dmp_file_devtest01  
7.2G    fis_cms_wms_etluser_wbs_comstplc_comstp_20140813.dmp
200K    fis_cms_wms_etluser_wbs_comstplc_comstp_20140813.log
�ڶ����02��00֮ǰ���챸���꣬����ÿ�춼��

#60_sec_dmp_file
1.8G    sec_20140813.dmp
36K     sec_20140813.log
02��00֮ǰ���챸����

#99_oracle_dmp_file
4.1G    fis_cms_wms_etluser_20140813.dmp
176K    fis_cms_wms_etluser_20140813.log
02��00֮ǰ���챸����

192.168.8.56�� 25G      /home/backup/backup

############################################################################################

1_dev_src_file(from sec@192.168.8.1:/export/home/sec/other/backupsrc/backup)�����ԣ�

���¶��Ǵ���Ӧ��oracle���ݿ���expdp��������Ȼ�󴫵�8.56�ϣ�

2_oracle_dmp_file(from oracle@192.168.8.2:/oracledata/backup_db)��kobra��
SYSTEM.SYS_EXPORT_SCHEMA_05
system/********
dumpfile=fis_cms_wms_eds_etluser_bdx_comstp_comstpdev_inter_20140911.dmp 
directory=dpdir 
schemas=fis,cms,wms,eds,etluser,bdx,comstp,comstpdev,inter 
logfile=fis_cms_wms_eds_etluser_bdx_comstp_comstpdev_inter_20140911.log 
compression=all 

2_oracle_dmp_file_devtest01(from oracle@192.168.8.2:/oracledata/devtest01_home/backup_db)
SYSTEM.SYS_EXPORT_SCHEMA_02
system/********
dumpfile=fis_cms_wms_etluser_wbs_comstplc_comstp_20140910.dmp 
directory=dpdir
schemas=fis,cms,wms,etluser,wbs,comstplc,comstp
logfile=fis_cms_wms_etluser_wbs_comstplc_comstp_20140910.log 
compression=all 

99_oracle_dmp_file(from oracle@192.168.8.99:/home/oracle/backup_db��
SYSTEM.SYS_EXPORT_SCHEMA_20 
system/******** 
dumpfile=fis_cms_wms_etluser_20140911.dmp 
directory=dpdir 
schemas=fis,cms,wms,etluser 
logfile=fis_cms_wms_etluser_20140911.log 
compression=all 

60_sec_dmp_file(from oracle@192.168.8.60:/home/oracle/backup_db)
SEC.SYS_EXPORT_SCHEMA_19
sec/******** 
dumpfile=sec_20140911.dmp 
directory=dpdir 
schemas=sec 
logfile=sec_20140911.log 
compression=all 
