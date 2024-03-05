#!/usr/bin/env python
# -*- encoding: utf-8
# for creating specific weights of one layer horizontal map 

# reading NC data
#import scipy.io.netcdf as nio
from netCDF4 import Dataset as NCDataset
import numpy as np


#nc_file = '/tmp/STERCP/SP_nudging/t0_Standard_wiNud-12hr/Data/CommonData_template_1var1L_32B.nc'
nc_file = '../../unit_map_1var1L_t779.nc'
varS = 't'


tData = NCDataset(nc_file, 'r')
Lati = tData.variables['latitude'][:]
Long = tData.variables['longitude'][:]
tData.close()

#var_data[:] = 1.0
mLong, mCos = np.meshgrid(Long, np.cos(Lati/180*np.pi), sparse = False)
map_data = np.reshape(mCos, (1, 1, Lati.shape[0], Long.shape[0] ))

tData = NCDataset(nc_file, 'r+')
tData.variables[varS][:] = map_data
tData.sync()
tData.close()


