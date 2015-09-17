开发环境需要限制开发人员对硬盘空间的使用，已经在每个用户$HOME下建了
TESTDATA目录，是否能想办法限制这个目录的大小《4G？是否能将其 共享到一个目录？

export/home/*/TESTDATE

另外想请您写个监控脚本，来监控每个用户下一级目录的大小增长情况，每天发邮件通知。

export/home

3       ./bdi/TESTDATA
3       ./bds/TESTDATA
3       ./bdx/TESTDATA
3       ./bonddev/TESTDATA
3       ./cms/TESTDATA
3       ./comstp/TESTDATA
3       ./fis/TESTDATA
3       ./inter/TESTDATA
3       ./mms/TESTDATA
3       ./news/TESTDATA
3       ./sec/TESTDATA
3       ./user/TESTDATA
67135   ./wbs/TESTDATA
3       ./wms/TESTDATA

linux限制目录大小
dd if=/dev/zero of=/mnt/file.img bs=1k count=4000000     
losetup /dev/loop1 /mnt/file.img           
mkfs -t ext4 /dev/loop1                                   
mount -t ext4 /dev/loop1 /export/home/TESTDATA     
chomd a+w /export/home/TESTDATA

solaris使用lofiadm创建一个UFS文件系统在文件上：
mkfile 4g /export/home/lofi.1
lofiadm -a /export/home/lofi.1 /dev/lofi/1
newfs /dev/lofi/1
mkdir /export/home/TESTDATA
mount /dev/lofi/1 /export/home/TESTDATA
rm -f /export/home/lofi.1
chomd a+w /export/home/TESTDATA

umount /export/home/TESTDATA
lofiadm -d /dev/lofi/1

重启之后没有自动挂在，需要修改文件表/etc/vfstab：
/dev/lofi/1   /dev/lofi/1   /export/home/TESTDATA   ufs   -   yes   -

#device         device          mount           FS      fsck    mount   mount
#to mount       to fsck         point           type    pass    at boot options
#
fd      -       /dev/fd fd      -       no      -
/proc   -       /proc   proc    -       no      -
/dev/zvol/dsk/rpool/swap        -       -       swap    -       no      -
/devices        -       /devices        devfs   -       no      -
sharefs -       /etc/dfs/sharetab       sharefs -       no      -
ctfs    -       /system/contract        ctfs    -       no      -
objfs   -       /system/object  objfs   -       no      -
swap    -       /tmp    tmpfs   -       yes     -
/dev/lofi/1     /dev/lofi/1     /export/home/TESTDATA   ufs     -       no      - 




















