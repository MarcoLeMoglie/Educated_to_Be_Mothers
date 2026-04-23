*******************************
**# 1. Distance to the Front (in meters)
*******************************
/*
import dbase using "$Data\maps_civilwar\distance\distance_front_met.dbf", clear
save "$Data\maps_civilwar\distance\distance_front_met.dta", replace
* Translate
clear all
global dir "C:\Users\laxge\Dropbox\" 
cd $dir

global Data 			"GEMA\RESEARCH\PURGE\original_data"
cd  $Data\maps_civilwar\distance
 
unicode analyze  distance_front_met.dta
unicode encoding set   ISO-8859-1
unicode translate distance_front_met.dta, invalid
*/
use "$Data\maps_civilwar\distance\distance_front_met.dta", clear
format %10.0f distance
format %12s NAMEUNIT
gen codprov = substr(NATCODE,5,2)
destring codprov, replace
keep NATLEVNAME NATCODE NAMEUNIT distance codprov

sort distance NATLEVNAME
rename NATLEVNAME type
replace type = "capital" if type =="Municipio"
replace type = "rest province" if type =="Provincia"

*Total distance
replace distance = distance/1000 // Transform to kms
format %3.1f distance 
label variable distance "Distance to front (kms)"
save "$Data\maps_civilwar\distance\distance_front.dta",replace

*******************************
**# 2. Comlete map with dummy variable for presence of the National bloc
*******************************
/*
import dbase using "$Data\maps_civilwar\complete_map\map_frente_area1.dbf", clear
save "$Data\maps_civilwar\complete_map\map_frente_area1.dta", replace
* Translate
clear all
global dir "C:\Users\laxge\Dropbox\" 
cd $dir

global Data 			"GEMA\RESEARCH\PURGE\original_data"
cd  $Data\maps_civilwar\complete_map
 
unicode analyze  map_frente_area1.dta
unicode encoding set   ISO-8859-1
unicode translate map_frente_area1.dta, invalid
*/

use "$Data\maps_civilwar\complete_map\map_frente_area1.dta", clear
format %10.3f area_sqkm
format %12s NAMEUNIT
gen codprov = substr(NATCODE,5,2)
destring codprov, replace
keep layer area_sqkm bnacional NAMEUNIT codprov
replace codprov = 41 if NAMEUNIT=="Sevilla"
replace codprov = 14 if NAMEUNIT=="Córdoba"
rename layer type
replace type = "capital" if type =="municipio"
replace type = "capital" if type =="guadalajara"
replace type = "rest province" if type ==""
replace type = "rest province" if type =="province"
*Total area
bysort NAMEUNIT type: egen total_area= sum(area_sqkm)
*Area occupied by the National front
bysort NAMEUNIT type: egen front_area= sum(area_sqkm) if bnacional==1
gen sh_area_front = (front_area/total_area)*100
format %3.1f sh_area_front
label var sh_area_front "Area share in National Front"
label var total_area "Total Area (sq kms)"
bysort NAMEUNIT type: replace sh_area_front = sh_area_front[1] if missing(sh_area_front)
bysort NAMEUNIT type : replace sh_area_front = sh_area_front[_N]
replace sh_area_front = 0 if missing(sh_area_front)


bysort NAMEUNIT type: egen front= mean(bnacional)
replace front = 1 if front >0 

drop area_sqkm bnacional front*
duplicates drop


save "$Data\maps_civilwar\complete_map\area_front.dta",replace

*******************************
**# 3. Merge (1) & (2) 
*******************************
use "$Data\maps_civilwar\distance\distance_front.dta", clear
merge 1:1 NAMEUNIT type using "$Data\maps_civilwar\complete_map\area_front.dta"
drop _merge NATCODE
replace distance = 0 if sh_area_front ==100
rename NAMEUNIT municip
replace municip = "rest province" if type =="rest province"
replace municip = lower(municip)

replace municip = strtrim(municip)
replace municip = subinstr(municip, "á", "a",.) 
replace municip = subinstr(municip, "é", "e",.) 
replace municip = subinstr(municip, "í", "i",.) 
replace municip = subinstr(municip, "ó", "o",.) 
replace municip = subinstr(municip, "ú", "u",.)

replace municip = subinstr(municip, "Á", "a",.) 
replace municip = subinstr(municip, "É", "e",.) 
replace municip = subinstr(municip, "è", "e",.) 

replace municip = "alicante/alacant" if municip =="alacant/alicante"
replace municip = "coruña, a" if municip =="a coruña"
replace type = "municipality" if type =="capital"
save "$Data\maps_civilwar\complete_map\data_front_complete.dta",replace

* * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * *
**# PROVINCE LEVEL DATASET
* * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * *
use "$Data\maps_civilwar\complete_map\data_front_complete.dta", clear
drop if type == "municipality"
drop type
drop municip
save "$Data\maps_civilwar\complete_map\data_front_complete_PROVINCElevel.dta",replace