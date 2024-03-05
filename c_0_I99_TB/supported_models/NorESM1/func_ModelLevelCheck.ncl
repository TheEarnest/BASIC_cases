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

 THYBin = addfile("Model_hybab.nc","r")

; *********************************************************
; load reference file 
;
  hyam = THYBin->hyam                               ; get a coefficiants
  hybm = THYBin->hybm                               ; get b coefficiants

;************************************************
   P0mb =1000.  ; for ERA-Interim
   P0 = 100000. ; for ERA-Interim

   pb = 85000.
   pt = 75000. 
;   load "func_ncl_testing.ncl"

;************************************************
; calculate T on pressure levels
;************************************************
;
  temp_level = hyam*P0 + hybm * P0

  level_W = hybm * 0.0
; set linear decay of vertical weight 


  do il = 0, dimsizes(temp_level)-1
    level_W(il) = (temp_level(il)-pt)/(pb-pt)
    if ( temp_level(il) .lt. pt ) then
      level_W(il) = 1.
    end if
		if ( temp_level(il) .gt. pb ) then
      level_W(il) = 0.
    end if
  end do 

  print (temp_level(:) + "  " + level_W(:))

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


