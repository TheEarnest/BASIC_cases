;*************************************************
; NCL script: vert_3.ncl
;
; As of V5.2.0 and later, you can use int2p_n for
; faster interpolation (no reordering required).
;************************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
;************************************************
begin
;************************************************
; file handling
;************************************************
; datestamp = systemfunc ( " date  " )
; yearStr = tostring_with_format(year, "%4.4d")
; dateStr = yearStr + tostring_with_format(month, "%2.2d")


 ; SourceFilename = "temp_SourceData"
 ; TargetFilename = "temp_TargetData"
 ; T_vname, U_vname, V_vname, PS_vname are set in ncl arguments 
 ; print ( SourceFilename + " " + TargetFilename)

 Rin  = addfile(TemplateFilename,"r") 
 Hybfn = "/cluster/home/earnest/Analysis/stercp/Spectral_nudging/functions/hybab_ERA_Interim_L60.nc"
 HYBin = addfile(Hybfn,"r")

; *********************************************************
; load reference file 
;
  Rhyam = Rin->hyam                               ; get a coefficiants
  Rhybm = Rin->hybm                               ; get b coefficiants
  Rlev  = Rin->lev
  Rlon  = Rin->lon
  Rlat  = Rin->lat
  RefT  = Rin->T
  RefU  = Rin->U
  RefV  = Rin->V
  RefQ  = Rin->Q
  RefPS = Rin->PS
  hyam = HYBin->hyam                 ; get a coefficiants
  ;hyam = temp/100. 
  hybm = HYBin->hybm                 ; get b coefficiants
;  Reftime = Rin->time
;  Reftime = Reftime - Reftime(0)
;  print (Reftime)
; *********************************************************
; create target file
;
  system (" rm -f " + TargetFilename )
  ncdf   = addfile(TargetFilename,"c")      ; create new netCDF file

  att_names = getvaratts(Rin)           ; get CCM file's global attributes
  if(.not.all(ismissing(att_names))) then
    do i = 0,dimsizes(att_names)-1
      print("copy_fileatts: global attributes->" + att_names(i))
      ncdf@$att_names(i)$ = Rin@$att_names(i)$ ;copy input file's global attributes
    end do
  end if

  names = getfilevarnames(Rin)   ; get CCM file's variable names and print them
;************************************************
; read needed variables from file
;************************************************
   P0mb =1000.  ; for ERA-Interim
   P0 = 100000. ; for ERA-Interim
;   load "func_ncl_testing.ncl"

;************************************************
; calculate T on pressure levels
;************************************************
;
  Datain  = addfile(SourceFilename,"r")            ; open netcdf file

  load "func_read_nc_variable_PS.ncl"
 
;  printVarSummary(temp)
;  print (ifN)

  load "func_read_nc_variable_lonlat.ncl"

  PS_Data = temp2

  printVarSummary (PS_Data)
  delete([/temp, temp2/])

  load "func_read_nc_variable_T.ncl"
  inDIM = dimsizes(temp2)

  T   = hyi2hyo(P0, hyam/P0, hybm, PS_Data, temp2, Rhyam, Rhybm,1)
;  delete(Tlores)
  printVarSummary (T)
  temp_eraL = hyam + hybm*PS_Data(0,47,71)
  temp_level = Rhyam + Rhybm * PS_Data(0,47,71)
  printVarSummary (temp_level)
  print (temp_eraL(46:) + "  " + temp2(0,46:,47,71))
  print (temp_level(21:) + "  " + T(0,21:,47,71))
;  print (temp_eraL(:) + "  " + temp2(0,:,47,71))
;  print (temp_level(:) + "  " + T(0,:,47,71))



  delete([/temp, temp2/])
  load "func_read_nc_variable_U.ncl" 
  U   = hyi2hyo(P0, hyam/P0, hybm, PS_Data, temp2, Rhyam, Rhybm,1)
  delete([/temp, temp2/])
  printVarSummary (U)


  load "func_read_nc_variable_V.ncl"
  V   = hyi2hyo(P0, hyam/P0, hybm, PS_Data, temp2, Rhyam, Rhybm,1)
  delete([/temp, temp2/])
  printVarSummary (V)

; loop over variables and copy to netCDF file
;
  do i=0, dimsizes(names)-1
    if ((names(i) .eq. "hyam") .or. (names(i) .eq. "hybm")  \ 
   .or. (names(i) .eq. "hyai") .or. (names(i) .eq. "hybi")  \
   .or. (names(i) .eq. "lev")  .or. (names(i) .eq. "ilev") ) then
        print("writing ncdf: i,name="+ i+ "   "+ names(i) + " modfied ")
        ncdf->$names(i)$ = Rin->$names(i)$
    else if ( names(i) .eq. "PS" ) then
      print("writing ncdf: i,name="+ i+ "   "+ names(i) + " modfied ")
      filevardef(ncdf, "PS"    ,typeof(RefPS)  ,getvardims(RefPS))
      filevarattdef(ncdf,"PS"  ,RefPS)
      ncdf->$names(i)$ (:(inDIM(0)-1):,:,:) = (/doubletofloat(PS_Data)/)
    else if ( names(i) .eq. "T" ) then 
      print("writing ncdf: i,name="+ i+ "   "+ names(i) + " modfied ")
        filevardef(ncdf, "T"    ,typeof(RefT)  ,getvardims(RefT))
        filevarattdef(ncdf,"T"  ,RefT)
;      printVarSummary (RefT)
;      printVarSummary (T)
;      ncdf->$names(i)$ (itime:(inDIM(0)*4-1):4,:,:,:) = (/T/)  
      ncdf->$names(i)$ (:(inDIM(0)-1):,:,:,:) = (/doubletofloat(T)/) 
    else if ( names(i) .eq. "U" ) then                       
      print("writing ncdf: i,name="+ i+ "   "+ names(i) + " modfied ")
      filevardef(ncdf, "U"    ,typeof(RefU)  ,getvardims(RefU))
      filevarattdef(ncdf,"U"  ,RefU)
      ncdf->$names(i)$ (:(inDIM(0)-1):,:,:,:)  = (/doubletofloat(U)/)
    else if ( names(i) .eq. "V" ) then                       
      print("writing ncdf: i,name="+ i+ "   "+ names(i) + " modfied ")
         filevardef(ncdf, "V"    ,typeof(RefV)  ,getvardims(RefV))
        filevarattdef(ncdf,"V"  ,RefV)
      ncdf->$names(i)$ (:(inDIM(0)-1):,:,:,:)  = (/doubletofloat(V)/)
;    else if ( names(i) .eq. "Q" ) then                       
;      print("writing ncdf: i,name="+ i+ "   "+ names(i) + " modfied ")
;        filevardef(ncdf, "Q"    ,typeof(RefQ)  ,getvardims(RefQ))
;        filevarattdef(ncdf,"Q"  ,RefQ)
;      ncdf->$names(i)$ (:(inDIM(0)-1):,:,:,:)  = (/doubletofloat(Q)/)
    else
        print("writing ncdf: i,name="+ i+ "   "+ names(i))
        ncdf->$names(i)$ = Rin->$names(i)$
    end if
    end if
    end if 
    end if
 ;   end if
    end if
  end do
;***********************************************
; calculate TonP on a different set of pressure levels
;************************************************
;************************************************
; plot parameters that do not change
;************************************************
  print ("Finish interpolating. ")
  ; print (T(0,:,47,71))
;  print ("mlschk: 207 " )
exit
end


