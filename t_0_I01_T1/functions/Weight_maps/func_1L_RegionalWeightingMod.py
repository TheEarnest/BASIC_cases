#!/usr/bin/env python
# -*- encoding: utf-8
# for creating specific weights of one layer horizontal map 

# reading NC data
#import scipy.io.netcdf as nio

import os
from netCDF4 import Dataset as NCDataset
import numpy as np


RegionName = 'NAtest'
RW = 0; RE = 360; RS = -90; RN = 0;
mGaol = 0;


#nc_file = './map_1var1L_unit_t779.nc'
nc_file = './map_1var1L_COMBINED_TB_61k.nc'
varS = 'PS'

RWfilename = nc_file + '_' + RegionName + '.nc'


tData = NCDataset(nc_file, 'r')
Lati = tData.variables['lat'][:]
Long = tData.variables['lon'][:]
m_data = tData.variables[varS][:,:]
tData.close()

print(m_data.shape)

for iE in range(Long.shape[0]):
  for iN in range(Lati.shape[0]):
    if (Lati[iN] >= RS) & (Lati[iN] <= RN) & (Long[iE] >= RW) & (Long[iE] <= RE):
      m_data[0,iN,iE] = 0.0


#with np.printoptions(threshold=np.inf):
#    print(Lati)

os.system("cp " + nc_file + " " + RWfilename )

tData = NCDataset(RWfilename, 'r+')
tData.variables[varS][:] = m_data
tData.sync()
tData.close()
