#!/usr/bin/env python
# -*- encoding: utf-8
# for creating specific weights of one layer horizontal map 

# reading NC data
#import scipy.io.netcdf as nio

import os
from netCDF4 import Dataset as NCDataset
import numpy as np


RegionName = 'NAtest'
RW = 0; RE = 360; RS = 65; RN = 90; RR = 10;

nc_file = './map_1var1L_unit_t779.nc'
varS = 't'

RWfilename = nc_file + '_' + RegionName + '.nc'


tData = NCDataset(nc_file, 'r')
Lati = tData.variables['lat'][:]
Long = tData.variables['lon'][:]
tData.close()

if ( RW == -1 ) | ( RE == -1 ):
  print('No zonal difference.')
  Long[:] = 1.0
else:
  print('Applying zonal difference...')
  for iL in range(Long.shape[0]):
    if (Long[iL] >= RW) & (Long[iL] <= RE): 
      Long[iL] = 1.0  
    elif (Long[iL] > RW-RR) & (Long[iL] < RW):   # western taper
      Long[iL] = np.cos((Long[iL]-RW)/RR*np.pi/2)
    elif (Long[iL] > RE) & (Long[iL] < RE+RR):   # eastern taper
      Long[iL] = np.cos((Long[iL]-RE)/RR*np.pi/2)
    else:
      Long[iL] = 0.0

if ( RS == -1 ) | ( RN == -1 ):
  print('No meri. difference.')
  Lati[:] = 1.0
else:
  print('Applying meri. difference.')
  for iL in range(Lati.shape[0]):
    if (Lati[iL] >= RS) & (Lati[iL] <= RN):
      Lati[iL] = 1.0
    elif (Lati[iL] > RS-RR) & (Lati[iL] < RS):   # southern taper
      Lati[iL] = np.cos((Lati[iL]-RS)/RR*np.pi/2)
    elif (Lati[iL] > RN) & (Lati[iL] < RN+RR):   # northern taper
      Lati[iL] = np.cos((Lati[iL]-RN)/RR*np.pi/2)
    else:
      Lati[iL] = 0.0


mLong, mLati = np.meshgrid(Long, Lati, sparse = False)
m_data = mLong * mLati
map_data = np.reshape(m_data, (1, 1, Lati.shape[0], Long.shape[0] ))


#with np.printoptions(threshold=np.inf):
#    print(Lati)

os.system("cp " + nc_file + " " + RWfilename )

tData = NCDataset(RWfilename, 'r+')
tData.variables[varS][:] = map_data
tData.sync()
tData.close()
