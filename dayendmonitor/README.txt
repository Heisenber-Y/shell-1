monitor dayend

iplist.txt
192.168.6.1
192.168.8.6
192.168.8.1
192.168.8.70
192.168.8.98
200.31.157.214
200.31.154.30

$ip_config.txt
fis,fis,1830
cms,cms,2030
cms,ib_loan,2030
wms,wms,2030
wms,ib_loan,2030

kobra@192.168.176.252:/home/kobra/monitor/dayend.sh调用
user@192.168.8.1:/export/home/user/tmpbackup/tmpdayend.sh
读取iplist.txt获取一个ip和一个密码
然后读取相应的$ip_config.txt文件获取相应的用户和选项，查dayend。

然后把结果写入到dayend_process.txt文件然后同步到kobra。
然后分析这个文件发邮件。

