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
Tprefix=ERAI-f19L26_b_0_I03_N1M_850hPa

mkdir -p ${tempwork}

cd ${tempwork}
#years="2002 "
years=`seq -w 1989 2011`

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

