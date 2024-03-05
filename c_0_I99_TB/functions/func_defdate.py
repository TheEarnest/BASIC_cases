#!/usr/bin/env python
#--------------------------------------------------------------------
# load module
#
from datetime import datetime
from datetime import timedelta
from calendar import isleap
import sys
#--------------------------------------------------------------------

# from Scientific.IO.NetCDF import NetCDFFile as NCDataset  # No Scientific on Hexagon
#--------------------------------------------------------------------
# define parameters
y1 = int(sys.argv[1])  # 
m1 = int(sys.argv[2]) # 
d1 = int(sys.argv[3])
s1 = int(sys.argv[4])

s2 = int(sys.argv[5])

newdate = datetime(y1,m1,d1,0,0,0) + timedelta(seconds=s1) + timedelta(seconds=s2)
daysec = newdate - datetime(newdate.year,newdate.month,newdate.day,0,0,0)
if isleap(y1) :
  if (newdate.month == 2) & (newdate.day == 29):
    newdate = datetime(newdate.year,newdate.month,newdate.day,newdate.hour,newdate.minute,newdate.second) + timedelta(seconds=86400*s2/s2.__abs__())


print(newdate.year, newdate.month, newdate.day, int(daysec.total_seconds()),sep=" ")

#--------------------------------------------------------------------
