Issues, bugs & todos
===

* define debug level


* parall using ncl & python 

* revisit the strategy of combining surface pressure 



* Not only vertical interpolation but also horizontal interpolation should be maintained by models, instead of DI monitor

* update code in ensemble with the new structure in training 

* Baseline test: two type (with BL and without BL)
  (check for 6hrly forecast error (model level and pressure level), zonal averaged vertical profile)

    CAM5 to ERA-intT21 
    CAM4 to ERA-intT21
    CAM5 to ERA full grid 
    CAM4 to ERA full grid 

    CAM5 to ERA-intT21 without PBL
    CAM4 to ERA-intT21 without PBL
    CAM5 to ERA full grid without PBL
    CAM4 to ERA full grid without PBL


* force rebuild model in the consecutive cycle 

* Switching vertical interpolating off if vertical levels are the same for all models 

* Fail to restart a run in the same script due to flag file, is_cam_nudging_data_ready, is removed in previous run!!!
* (?) How often HPC login node cleans "old" files under /tmp (<- potential source of un-expecting missing files)
*learning implementation 

* moving vertical interpolation to sync <-!!!!! 

* should working on a common restart pool 




* !!! conflic if CN_res has same value with SN_res

* Start working on 2.0 generic approach (postponed) 
 - models -> supported_models (checked)
 - AGCM -> Model (checked )
 - a dedacate repostory for running cases 

CAM4 error growth rate 
e(t) = e(0)*exp(lamda*t) 
lamda = 0.4462 for South H; e-folding time: 1/lamda = 53.7 hr
lamda = 0.2887 for North H; e-folding time: 1/lamda = 83.1 hr
lamda = 0.4037 for Tropic ; e-folding time: 1/lamda = 59.5 hr


* make it more generitic!!! (for enselbme case should be postponed)
* (Should have an external controller .......??)
* Activeate spectral nudging and try nudge only T21 or T20-T22
* May still sufferring by buffering issue -->> Any generic approach to avoid buffering or file issue??
* should active spectral nudging part as a test!!!
* [Bug] can't pass from year end to another year 
* [Issue] CAM4/CAM5 has no leap year!!!!!!!!!!!!!!!!!!!

* functions/func_defdate.py: using non-leap condition for CAM4/CAM5


* ud: minor fix ...
* st: for testing case only 

* functions/func_jobs_monitoring: 
  + job time estimation should based on month cycle
* Buffering issue in CAM4 and ECHAM6!!!!  
* officially link two AGCMs start!!

* try NCL waiting in order to shorten the waiting time 


* atm pressure level
 	1000 	975 	950 	925 	900 	875 	850 	825 	800 	775 	750 	700 	650 	600 	550 	500 	450 	400 	350 	300 	250 	225 	200 	175 	150 	125 	100 	70 	50 	30 	20 	10 	7 	5 	3 	2 	1


* time used for SP:CAM4 only 28/12 2.33
            for SP:CAM5 only 27/5  5.4 
            for SP:CAM4+CAM5 45/10 4.50    
CAM5 using 320 cpu cores, 2.4 min/model day


* possibility to use ncl for gp2sp & sp2gp 

* CAM4/CAM5: has to review all codes used/unused by OFFLINE_DYN
  - dynamics/fv/cd_core.F90:#if defined( OFFLINE_DYN )
   - dynamics/fv/cd_core.F90:!     WS   05.05.24:   Incorporated OFFLINE_DYN; merge of CAM/GEOS5
  - dynamics/fv/cd_core.F90:#if ( defined OFFLINE_DYN )


Math testing
===
- [] (https://www.codecogs.com/eqnedit.php?latex=\left&space;\|&space;test&space;\right&space;\|) {:target="_blank"}

