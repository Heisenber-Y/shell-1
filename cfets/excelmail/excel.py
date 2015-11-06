######################################################################
# Copyright C 2014 CFETS Financial Data Co.,LTD                      #
# All rights reserved                                                #
# File Name:excel.py
# Version:                                                           #
# Writen by canux chengwei@chinamoney.com.cn                         #
# Created Time: Mon 09 Feb 2015 04:43:39 PM CST
# Description:                                                       #
######################################################################
#!/bin/python

from xlrd import open_workbook
from xlwt import Workbook,Style
from xlutils.copy import copy
import sys
import os
import time
import shutil

today = time.strftime("%Y%m%d", time.localtime(time.time()))
filename = today + ".xls"
shutil.copy("tmp.xls", filename)

rb = open_workbook(filename)
wb = copy(rb)
sheet = wb.get_sheet(0)

def writexls(rowx, data):
    sheet.write(rowx, 3, data)

rowx = 3
for data in open("checkall.log"):
    writexls(rowx, data)
    rowx += 1

os.remove(filename) 
wb.save(filename)
