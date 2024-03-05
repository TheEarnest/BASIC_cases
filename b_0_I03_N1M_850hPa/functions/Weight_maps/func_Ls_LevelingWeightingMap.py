#!/usr/bin/env python
# -*- encoding: utf-8
# for creating specific weights of one layer horizontal map 

# reading NC data
#import scipy.io.netcdf as nio

import os
from netCDF4 import Dataset as NCDataset
import numpy as np


LevelingName = 'T02'

nc_file = './map_1var26L_unit_test_f19.nc'
varS = 'T'

RWfilename = nc_file + '_' + LevelingName + '.nc'


tData = NCDataset(nc_file, 'r')
Lati = tData.variables['lat'][:]
Long = tData.variables['lon'][:]
Lev  = tData.variables['lev'][:]
tData.close()


mLong, mLati = np.meshgrid(Long, Lati, sparse = False)
m_data = mLong * mLati
map_data = np.reshape(m_data, (1, 1, Lati.shape[0], Long.shape[0] ))


os.system("cp " + nc_file + " " + RWfilename )

tData = NCDataset(RWfilename, 'r+')
Data = tData.variables[varS][:]
print(Data.shape)
Data[:,0:2,:,:] = 1.0
#Data[:,1,:,:] = 0.5
print(Data[0,0:2,1,:])
tData.variables[varS][:] = Data

#tData.variables[varS][:] = map_data
tData.sync()
tData.close()
