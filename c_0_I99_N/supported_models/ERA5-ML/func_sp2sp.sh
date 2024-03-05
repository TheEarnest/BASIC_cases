#! /bin/bash
######################################################################
JobStartTime=`date`; echo ${Line_Break}; echo ${Line_Break}
JobName=func_create_outputs
tempPrefix=t_${JobName}
echo "Starting "${JobName}" ...... "
######################################################################

tsp=255
#work=/cluster/work/users/earnest/stercp_exp/s0SP_en1/ERA5-ML_s0SP_en1
#ERA_source=/cluster/work/users/earnest/stercp_exp/s0SP_en1/ERA5-ML_s0SP_en1/raw
tempwork=/scratch/earnest/temp/ERA5/temp
work=/scratch/earnest/temp/ERA5/work
ERA_source=/scratch/earnest/temp/ERA5/data
nprefix=new_download
nsuffix=""
Tprefix=ERA5-MLsp

#mkdir -fp ${tempwork}
rm -f ${tempwork}/*
#set -ex 

years="2022 "
#years=`seq -w 1980 1989`
vars="ps t u v"

#set -ex
for year in ${years}; do 
  #echo ${year}
  for var in ${vars}; do
    echo ${year} ${var}
    cd ${tempwork}
    file=`ls ${ERA_source}/${nprefix}*${var}*${year}* ` || file="None"
    if [ ${file} != "None" ]; then
      yprefix=${var}_${year}-
      cdo -splitmon ${file} ${yprefix}
      for mm in `seq -w 01 12`; do 
        mprefix=${yprefix}${mm}-
        mfile=`ls ${yprefix}${mm}*` || file="None"
        if [ ${mfile} != "None" ]; then
          cdo -splitday ${mfile} ${mprefix}
        fi
        rm -f ${mfile}
        for dd in `seq -w 01 31`; do 
          echo ${year} ${mm} ${dd}
          dprefix=${mprefix}${dd}-
          dfile=`ls ${mprefix}${dd}*` || file="None"
          if [ ${dfile} != "None" ]; then
            cdo -f nc copy -sp2sp,${tsp} ${dfile} ${mprefix}${dd}.nc
            rm -f ${dfile}; dfile="${mprefix}${dd}.nc "
            cdo -splithour ${dfile} ${dprefix}
          fi
          rm -f ${dfile}
        done
      done
    fi
  done
  psfiles=`ls ps_*`
  for file in ${psfiles}; do 
    suffix=`echo ${file} | awk -F "ps_" '{print $NF}'`
    #echo ${suffix}
    allvars=`ls *${suffix}`
    cdo merge ${allvars} ${Tprefix}.${suffix}
    mv -f ${Tprefix}.${suffix} ${work}
    rm -f ${allvars} 
  done
done



######################################################################
echo ${JobStartTime}
echo `date`" || "${JobName}
echo ${Line_Break}
