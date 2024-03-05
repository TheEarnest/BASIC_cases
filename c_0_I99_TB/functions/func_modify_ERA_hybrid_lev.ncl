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
 Rin = addfile("hybab_ERA_Interim_L60_2.nc","r")

; *********************************************************
; load reference file 
;
  P0mb =1000.  ; for ERA-Interim
  P0 = 100000. ; for ERA-Interim

  hyam = Rin->hyam                               ; get a coefficiants
  hyam = hyam/P0
  hybm = Rin->hybm                               ; get b coefficiants

  hyai = Rin->hyai                               ; get a coefficiants
  hyai = hyai/P0
  hybi = Rin->hybi                               ; get b coefficiants

 
  ncdf   = addfile("hybab_ERA_Interim_L60_N.nc","c")      ; create new netCDF file

  att_names = getvaratts(Rin)           ; get CCM file's global attributes
  print (att_names)
  if(.not.all(ismissing(att_names))) then
    do i = 0,dimsizes(att_names)-1
      print("copy_fileatts: global attributes->" + att_names(i))
      ncdf@$att_names(i)$ = Rin@$att_names(i)$ ;copy input file's global attributes
    end do
  end if

  names = getfilevarnames(Rin)   ; get CCM file's variable names and print them


  do i=0, dimsizes(names)-1
    if ((names(i) .eq. "lev") .or. (names(i) .eq. "lev")) then   
        print("writing ncdf: i,name="+ i+ "   "+ names(i) + " modfied ")
        ncdf->$names(i)$ = Rin->$names(i)$
    else if ( names(i) .eq. "hyam" ) then
      print("writing ncdf: i,name="+ i+ "   "+ names(i) + " modfied ")
      ncdf->$names(i)$ = hyam
    else if ( names(i) .eq. "hybm" ) then
      print("writing ncdf: i,name="+ i+ "   "+ names(i) + " modfied ")
      ncdf->$names(i)$ = hybm
    else if ( names(i) .eq. "hyai" ) then
      print("writing ncdf: i,name="+ i+ "   "+ names(i) + " modfied ")
      ncdf->$names(i)$ = hyai
    else if ( names(i) .eq. "hybi" ) then
      print("writing ncdf: i,name="+ i+ "   "+ names(i) + " modfied ")
      ncdf->$names(i)$ = hybi
    end if
    end if
    end if 
    end if
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


