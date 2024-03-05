#! /bin/bash
######################################################################
JobStartTime=`date`; echo ${Line_Break}; echo ${Line_Break}
JobName=func_sp2gp
tempPrefix=t_${JobName}
echo "Starting "${JobName}" ...... "
######################################################################
module load NCO/5.0.3-intel-2021b 
module load CDO/2.0.5-gompi-2021b

#work=/cluster/work/users/earnest/stercp_exp/s0SP_en1/ERA5-ML_s0SP_en1
#ERA_source=/cluster/work/users/earnest/stercp_exp/s0SP_en1/ERA5-ML_s0SP_en1/raw
work=/cluster/work/users/earnest/stercp_exp/s0SP_en1/ERA5-ML_s0SP_en1
#tempwork=/scratch/earnest/temp/ERA5/temp
#work=/scratch/earnest/temp/ERA5/work
ERA_source=/cluster/work/users/earnest/temp/ERA5
nprefix=ERA5-MLsp
Tprefix=ERA5-ML_s0SP_en1
Tpath=/cluster/work/users/earnest/stercp_exp/s0SP_en1/ERA5-ML_s0SP_en1


#set -ex
years="2022 "

for year in ${years}; do 
  #echo ${year}
  sfiles=`ls ${ERA_source}/*${year}*`
  for sfile in ${sfiles}; do 
    cd ${work}
    suffix=`echo ${sfile} | awk -F "${nprefix}." '{print $NF}'`
    echo ${suffix}
    TarFile=${Tpath}/${Tprefix}.${suffix}
    if [ ! -f ${TarFile} ]; then
      cdo -chname,lnsp,PS -exp -sp2gp -selvar,lnsp ${sfile} temp_PS
      ncwa -a lev temp_PS temp_PS_nolev
      cdo -chname,t,T,u,U,v,V -sp2gp -selvar,t,u,v ${sfile} temp_TUV
      cdo -O -merge temp_PS_nolev temp_TUV ${TarFile}
      rm temp_*
    fi
#exit 555
  done
done





######################################################################
echo ${JobStartTime}
echo `date`" || "${JobName}
echo ${Line_Break}

