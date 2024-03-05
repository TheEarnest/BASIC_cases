#! /bin/bash
######################################################################
JobStartTime=`date`; echo ${Line_Break}; echo ${Line_Break}
JobName=func_create_outputs
tempPrefix=t_${JobName}
echo "Starting "${JobName}" ...... "
######################################################################

tempwork=/cluster/work/users/earnest/temp/ERAI
ERA_source=/cluster/projects/nn9039k/CAM_Nudging/met_data/ERAL26
nprefix=ERAint_nuCAM
nsuffix=MLS310315
Tprefix=ERA5-f09L32_s0SP_en1

mkdir -p ${tempwork}

cd ${tempwork}
years="1980 "
#years=`seq -w 1978 1989`

#set -ex
for year in ${years}; do 
  #echo ${year}
  for mm in `seq -w 01 12`; do 
    echo ${year}-${mm}
    Sfile=${ERA_source}/${year}/${nprefix}_${year}${mm}_${nsuffix}.nc
     
    if [ -f ${Sfile} ] ; then
      #echo ${Sfile}
      Dprefix=ERA_${year}${mm}-
      cdo -O splitday ${Sfile} ${Dprefix}
      for day in `seq -w 01 31`; do 
        if [ -f ${Dprefix}${day}.nc ]; then
          echo ${year}-${mm}-${day}
          cdo -O splithour ${Dprefix}${day}.nc ${Tprefix}.${year}-${mm}-${day}-
          rm -f ${Dprefix}${day}.nc
        fi
      done
    fi
  done
done



######################################################################
echo ${JobStartTime}
echo `date`" || "${JobName}
echo ${Line_Break}

