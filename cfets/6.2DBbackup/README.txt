backup the data from 192.168.6.2 

oracle@192.168.6.2:/export/home/oracle/backup_db
�ѱ��ݵ�oracle@192.168.6.3:/export/home/oracle/backupdb8.2

fis_cms_wms_etluser_comstp_comstplc_wbs_bond_inter_20140909.JianHangDmp
fis_cms_wms_etluser_comstp_comstplc_wbs_bond_inter_20140909.JianHangDmp.log


cron  02��00

12Gb

�Ȳ��split��3��4g��
��cat�ϲ�
��md5��֤

01:00֮ǰ���ص�����ϣ�01:30��ʼ���ݣ���������ġ�
oracle@192.168.6.2:/export/home/oracle/backup_db
���ݵ�root@192.168.2.209:/export/home/oracle/backup_db

/export/home/user/util/bin/sshpass


����ű���sunos���ܣ����Ժ�linux��������
��bash����������cron������
06 19 * * * bash /export/home/user/tmpbackup/remote_backup.sh &

���ݻ��ƣ�
����1��        
�����5�����屣��              
�����1���µ����һ������ı���   

