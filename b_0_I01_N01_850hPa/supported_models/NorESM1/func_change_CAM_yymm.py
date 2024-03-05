#!/usr/bin/env python
#--------------------------------------------------------------------
# load module
#
import time
start_time = time.time()
import sys
import os
import numpy as np
import scipy.io.netcdf as nio
from netCDF4 import Dataset as NCDataset
# from Scientific.IO.NetCDF import NetCDFFile as NCDataset  # No Scientific on Hexagon
print("--- %s s is used for loading libs! ---" % (time.time() - start_time))
#time.sleep(1.1)
#--------------------------------------------------------------------
# define parameters
#
if len(sys.argv) < 1:
  print "The file name and variable name are necessary!!!"
  sys.exit()

DataFilename = sys.argv[1]
#orgdate = float(sys.argv[2])
trgdate = float(sys.argv[2])

#--------------------------------------------------------------------
tData = NCDataset(DataFilename, 'r+')
print("--- %s s is used for loading libs! ---" % (time.time() - start_time))
date = tData.variables['date'][:].copy()
#date = date - (orgdate-trgdate)*100
date = trgdate*100 + date%100
#print date
#sys.exit()
tData.variables['date'][:] = date 
print tData.variables['date'][:]
tData.sync()
tData.close()
#--------------------------------------------------------------------
print("--- %s s is used for loading libs! ---" % (time.time() - start_time))
