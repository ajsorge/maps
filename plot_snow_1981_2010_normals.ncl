;===============================================================================
; Modified by Andrew Ansorge; adapted from:
;
;===============================================================================
; Load NCL library files. Always load "Shea_util" AFTER contributed
;===============================================================================
load "/usr/local/ncl/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "/usr/local/ncl/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "/usr/local/ncl/lib/ncarg/nclscripts/csm/contributed.ncl"
load "/usr/local/ncl/lib/ncarg/nclscripts/csm/shea_util.ncl"
;===============================================================================
begin

dir = "/home/ajsorge/opg/"
; The highest quality stations (C=complete); 20 stations
;filename = dir + "data/snow_C.txt"

; High quality stations (C=complete; S=standard); 1375 stations
;filename = dir + "data/snow_CS.txt"

; All stations; 12754 stations in db (may be outside domain too!)
filename = dir + "data/snow_ALL.txt"

fin = asciiread(filename,-1,"string")
lat  = stringtofloat(str_get_field(fin(1:),1,","))
lon  = stringtofloat(str_get_field(fin(1:),2,","))
snow = stringtofloat(str_get_field(fin(1:),3,","))
flag = str_get_field(fin(1:),4,",")

; Following example: http://www.ncl.ucar.edu/Applications/Scripts/shapefiles_4.ncl
sfil = addfile(dir + "shapefiles/nws/s_06se12.shp", "r")
slat = sfil->y
slon = sfil->x
ns = dimsizes(slon)

min_slat = min(slat)
max_slat = max(slat)
min_slon = min(slon)
max_slon = max(slon)

ilt_mn = ind(min_slat.gt.lat1d)
ilt_mx = ind(max_slat.lt.lat1d)
iln_mn = ind(min_slon.gt.lon1d)
iln_mx = ind(max_slon.lt.lon1d)
ilt1 = ilt_mn(dimsizes(ilt_mn)-1) ;start of lat box
iln1 = iln_mn(dimsizes(iln_mn)-1) ;start of lon box
ilt2 = ilt_mx(0)                  ;end of lat box
iln2 = iln_mx(0)                  ;end of lon box

data_mask = new(dimsizes(snow),typeof(snow))

do ilt=ilt1,ilt2
  do iln=iln1,iln2
    if (gc_inout(lat1d(ilt),lon1d(iln),slat,slon)) then
      data_mask(ilt,iln) = snow(ilt,iln)
    end if
  end do
end do


;===========================================================================
; Begin plotting/resources section.
;===========================================================================
wks = gsn_open_wks("png","1981_2010_annual_mean_total_snow")
gsn_define_colormap(wks,"snow_normals")
             
res                             = True
res@gsnMaximize                 = True             ; Maximize plot in frame.
res@gsnFrame                    = False            ; Don't advance the frame
res@mpGridAndLimbOn             = False            ; turn on/off lat/lon lines
res@mpPerimOn                   = False            ; turn off box around plot
res@mpGridLatSpacingF           = 6.0              ; spacing for lat lines
res@mpGridLonSpacingF           = 6.0              ; spacing for lon lines
res@pmTickMarkDisplayMode       = "Always"

res@gsnSpreadColors = True

res@cnLineLabelPlacementMode    = "Constant"
res@cnLineDashSegLenF           = 0.3

res@cnLevelSelectionMode        = "ExplicitLevels"
res@cnLevels                    = (/0.1, 3., 6., 12., 24., 36., 48., 72./)

res@pmLabelBarDisplayMode       = "Always"
res@pmLabelBarHeightF           = 0.05
res@pmLabelBarWidthF            = 0.45
res@pmLabelBarOrthogonalPosF    = 0.15

res@lbLabelBarOn                = True
res@lbTitlePosition             = "Bottom"
res@lbTitleJust                 = "CenterCenter"
res@lbTitleString               = "inches"
res@lbTitleOffsetF              = 0.15
res@lbTitleFontHeightF          = 0.012

res@lbBoxCount                  = 9
res@lbBoxLinesOn                = True
res@lbBoxLineColor              = "black"
res@lbLabelFontHeightF          = 0.01
res@lbLabelAlignment            = "ExternalEdges"
res@lbLabelStrings              = (/"0.0", "0.1", "3.0", "6.0", "12.0", "24.0", "36.0", "48.0", ">72.0", ""/)
res@lbFillColors                = (/2,3,4,5,6,7,8,9,10/)


res@cnSmoothingOn               = True
res@cnSmoothingTensionF         = -2.5

res@cnFillOn                    = True
res@cnLinesOn                   = True
res@cnLineLabelsOn              = True
;res@cnLevelFlags		            = new(139,"string")
;res@cnLevelFlags(:)		          = "NoLine"
;res@cnLevelFlags(0::20)         = "LineAndLabel"
res@cnInfoLabelOn               = False

res@tiMainString                = "1981-2010 Annual Mean Total Snow"

res@sfXArray                    = lon
res@sfYArray                    = lat

res@mpProjection                = "LambertConformal"
res@mpLambertParallel1F         = 24.5
res@mpLambertParallel2F         = 50.
res@mpLambertMeridianF          = -96.

res@mpLimitMode                 = "LatLon"
res@mpMinLatF                   = 24.5  ;min(lat)
res@mpMaxLatF                   = 50.   ;max(lat)
res@mpMinLonF                   = -125. ;min(lon)
res@mpMaxLonF                   = -67.  ;max(lon)

res@mpFillOn                    = False
res@mpOutlineDrawOrder          = "PostDraw"
res@mpFillDrawOrder             = "PreDraw"
res@mpOutlineBoundarySets       = "GeophysicalAndUSStates"
res@mpUSStateLineColor          = "Gray10"
res@mpUSStateLineDashPattern    = 2
res@mpDataBaseVersion           = "MediumRes"               ; use finer database
res@mpDataSetName               = "Earth..4"
res@pmTickMarkDisplayMode       = "Always"                  ; turn on tickmarks

map = gsn_csm_contour_map(wks,snow,res)

frame(wks)

exit
end     

