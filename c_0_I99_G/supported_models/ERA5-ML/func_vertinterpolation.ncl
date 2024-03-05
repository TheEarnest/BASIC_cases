;*************************************************
; Based on NCL script: vert_3.ncl
; 
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
; Hybfn = "/cluster/home/earnest/Analysis/stercp/Spectral_nudging/functions/hybab_ERA_Interim_L60.nc"
 SHYBin = addfile(HybRefFilename,"r")
 THYBin = addfile(TargetHybRefFilename,"r")

; *********************************************************
; load reference file 
;
  Rhyam = THYBin->hyam                               ; get a coefficiants
  Rhybm = THYBin->hybm                               ; get b coefficiants
  ;Rlev  = Rin->lev

  ;RefT  = Rin->T
  load "func_read_nc_variable_T_T.ncl"
  ;RefU  = Rin->U
  load "func_read_nc_variable_T_U.ncl"
  ;RefV  = Rin->V
  load "func_read_nc_variable_T_V.ncl"
  ;RefQ  = Rin->Q
  ;load "func_read_nc_variable_T_Q.ncl"
  ;RefPS = Rin->PS
  load "func_read_nc_variable_T_PS.ncl"
  hyam = SHYBin->hyam                 ; get a coefficiants
  ;hyam = temp/100. 
  hybm = SHYBin->hybm                 ; get b coefficiants
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
   P0mb =1000.  ; for ERA5
   P0 = 100000. ; for ERA5
;   load "func_ncl_testing.ncl"

;************************************************
; calculate T on pressure levels
;************************************************
;
  Datain  = addfile(SourceFilename,"r")            ; open netcdf file

  load "func_read_nc_variable_S_PS.ncl"
 
;  printVarSummary(temp)
;  print (ifN)

  PS_Data = temp

  printVarSummary (PS_Data)
  delete([/temp/])

  load "func_read_nc_variable_S_T.ncl"
  inDIM = dimsizes(temp)

  printVarSummary(temp)

  T   = hyi2hyo(P0, hyam, hybm, PS_Data, temp, Rhyam, Rhybm,1)
;  delete(Tlores)
  printVarSummary (T)
  temp_eraL = hyam*P0 + hybm*PS_Data(0,47,71)
  temp_level = Rhyam*P0 + Rhybm * PS_Data(0,47,71)
  printVarSummary (temp_level)
  print (temp_eraL(:) + "  " + temp(0,:,47,71))
  print (temp_level(:) + "  " + T(0,:,47,71))
;  print (temp_eraL(:) + "  " + temp(0,:,47,71))
;  print (temp_level(:) + "  " + T(0,:,47,71))


  delete([/temp/])
  load "func_read_nc_variable_S_U.ncl" 
  U   = hyi2hyo(P0, hyam, hybm, PS_Data, temp, Rhyam, Rhybm,1)
  delete([/temp/])
  printVarSummary (U)


  load "func_read_nc_variable_S_V.ncl"
  V   = hyi2hyo(P0, hyam, hybm, PS_Data, temp, Rhyam, Rhybm,1)
  asciiwrite ("zeros_check.txt" , sprintf("%4.0f", num(temp(:,inDIM(1)-1,:,:) .eq. 0) ))
  delete([/temp/])
  printVarSummary (V)

; loop over variables and copy to netCDF file
;
  do i=0, dimsizes(names)-1
    if ((names(i) .eq. "hyam") .or. (names(i) .eq. "hybm")  \ 
   .or. (names(i) .eq. "hyai") .or. (names(i) .eq. "hybi")  \
   .or. (names(i) .eq. "lev")  .or. (names(i) .eq. "ilev") ) then
        print("writing ncdf: i,name="+ i+ "   "+ names(i) + " modfied ")
        ncdf->$names(i)$ = Rin->$names(i)$
    else if ( names(i) .eq. "PS" ) .or. ( names(i) .eq. "sp" ) then
      print("writing ncdf: i,name="+ i+ "   "+ names(i) + " modfied ")
;      printVarSummary (RefPS)
;      printVarSummary (PS_Data)
      filevardef(ncdf, names(i),typeof(RefPS)  ,getvardims(RefPS))
      filevarattdef(ncdf,names(i),RefPS)
      ncdf->$names(i)$ (:(inDIM(0)-1):,:,:) = (/PS_Data/)
    else if ( names(i) .eq. "T" ) .or. ( names(i) .eq. "t" ) then 
      print("writing ncdf: i,name="+ i+ "   "+ names(i) + " modfied ")
        filevardef(ncdf, names(i),typeof(RefT)  ,getvardims(RefT))
        filevarattdef(ncdf, names(i),RefT)
;      printVarSummary (RefT)
;;      printVarSummary (T)
;      ncdf->$names(i)$ (itime:(inDIM(0)*4-1):4,:,:,:) = (/T/)  
      ncdf->$names(i)$ (:(inDIM(0)-1):,:,:,:) = (/T/) 
    else if ( names(i) .eq. "U" ) .or. ( names(i) .eq. "u" ) then             
      print("writing ncdf: i,name="+ i+ "   "+ names(i) + " modfied ")
      filevardef(ncdf, names(i),typeof(RefU)  ,getvardims(RefU))
      filevarattdef(ncdf,names(i),RefU)
      ncdf->$names(i)$ (:(inDIM(0)-1):,:,:,:)  = (/U/)
    else if ( names(i) .eq. "V" ) .or. ( names(i) .eq. "v" ) then
      print("writing ncdf: i,name="+ i+ "   "+ names(i) + " modfied ")
         filevardef(ncdf,names(i),typeof(RefV)  ,getvardims(RefV))
        filevarattdef(ncdf,names(i),RefV)
      ncdf->$names(i)$ (:(inDIM(0)-1):,:,:,:)  = (/V/)
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

  delete(ncdf)
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


