23:55 get sec data and 6.1 dayend data from 8.1 and write then to the excel.

if sedmonitor and dayendmonitor all ritht sned the mail with title ok.
otherwise send the mail with title error.

use the bash script to get the date and use the python script to write the date to the excel.


bondtime at 8.58:/export/home/sec/checkbond.log
secdata at 8.58:/export/home/sec/checksec.log

comstp time: 8.1:/export/home/user/tmpbackup/checktime.sh

176.252:mail.sh get the checkbond.log and checksec.log and checktime 
and the 6.1dayend message, and run the python script to write them to the excel,
then send the message.

cat checksec.log and checkbond.log in the for structure, and call the python script 
with two args data and line number, tnen the line number++.
All the python script to do is write the data to the number.