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

 Rin  = addfile(TemplateFilename,"r") 
  RefT  = Rin->T
  RefU  = Rin->U
  RefV  = Rin->V
  RefQ  = Rin->Q
  RefPS = Rin->PS

; *********************************************************
; load reference file 

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
  Datain  = addfile(SourceFilename,"r")            ; open netcdf file

  PS =  Datain->PS
  T =  Datain->T
  U =  Datain->U
  V =  Datain->V
  Q =  Datain->Q

  inDIM = dimsizes(T)
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
      ncdf->$names(i)$ (:(inDIM(0)-1):,:,:) = (/doubletofloat(PS)/)
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


