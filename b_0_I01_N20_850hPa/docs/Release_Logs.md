# Release Logs


#### USM V0.9.0 [2023/??/??]

* ensemble_vsp: selecting spectral band becomes possible
* ensemble_vbsp: residuals is not involved in any interpolations.
* Localize HPC secified settings 
* Having variable check (-z) before removing temporary/intermediate or old data 
* Terminate and clean temporary/intermediate data while specified run cycle is reached. 
* Surface pressure will not been touched by any DI methods.
*  


#### General synchronization V1.0.7 internal release [2020/12/18]

* Change model name officially to NorESM1 and CESM112 (v1.1.2)
* Update scripts and model codes for CESM v1.1.2
* Now works with full coupled ESM as well. Model type may be COUPLE or AMIP. OMIP is underconstruction with lower priority.
* Fixed bugs in DIM_ensemble_vsp - Ssp_res & Csp_res 

#### General synchronization V1.0.6 internal release [2020/10/01]
* Add cleaning_all_Drivers so that re-launch USM becomes easilier.
* minor fixs of situations at atmosphere top few layers

#### General synchronization V1.0.5 internal release [2020/06/30]
* Re-define the system to generic data ingestion 
* Remove demo module because the funcationality can be replaced by learning module 
* Modules are re-defined and two basic learning module are implemented 
  - ensemble_gp
    * Pseudo observation is defined by grid-based ensemble mean. 
  - ensemble_sp
    * Pseudo observation is defined by ensemble mean of few spherical harmonic components. Spherical harmonic components are selected on commom model level. 
  - ensemble_vsp
    * An extention of ensemble_sp but spherical harmonic components are selected on model level 
  - learning_gp_syncb
    * synchronization based learning using weighted ensemble mean of grid-based model results 
  - learning_vsp_syncb
    * synchronization based learning using weighted ensemble mean of selected spherical harmonic components 

#### General synchronization V1.0.3 [2019/03/18]
* Change path structure to deal with the bugs when simulation approaches the end of a month to next month
* Fix bugs due to I/O delay/buffering

#### Snapshot Nudging V1.0.0 [2019/03/12]
Scripts for connecting different atmosphere general circulation model (AGCM) of any earth system model
* Current status:
  - CAM4: implemented.
  - CAM5: implemented.
  - ECHAM6: work in progress.
* Implemented approaches 
  - demo  
    * Synchronizing models to ERA-int.
  - ensemble_gp 
    * Synchronizing models to ensemble averaged multi-model outputs on grid-point. 
  - ensemble_sp
    * Synchronizing models to ensemble averaged multi-model outputs on coefficients of spherical harmonics.  



    The Universal Synchronizer Copyright (C) 2020 Mao-Lin Shen
    Contact info: earnestshen@gmail.com; maolin.shen@uib.no
