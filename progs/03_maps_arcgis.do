**************************************************
*	This dofile keeps the variables needed in qgis to create the descriptive maps:
* share of teachers and share of treated population (women of group ages 1 and 2)
**************************************************
use "$Output_data/dataset.dta", clear
keep codprov codmun geo_name type   pop_w deaths_male_*

**# Above median variables
sum pop_w, detail
gen median_pop_w=pop_w>r(p50) & pop_w!=.
replace median_pop_w =. if missing(pop_w)
label variable median_pop_w "Prop women schooling age above median"


duplicates drop
*Modify some variables in order to do the correct merge in Qgis
replace geo_name = proper(geo_name)
replace type = "Municipio" if type =="municipality"
replace type = "Provincia" if type =="rest province"
br geo_name codprov type
sort codprov type
replace geo_name = "Albacete" if codprov ==2
replace geo_name = "A Coruña" if codprov ==15
replace geo_name = "Alacant/Alicante" if codprov ==3
replace geo_name = "Almería" if codprov ==4
replace geo_name = "Araba/Álava" if codprov == 1 
replace geo_name = "Asturias" if codprov ==33
replace geo_name = "Ávila" if codprov ==5
replace geo_name = "Badajoz" if codprov ==6
replace geo_name = "Barcelona" if codprov ==8
replace geo_name = "Bilbao" if codprov ==48 & type =="Municipio"
replace geo_name = "Bizkaia" if codprov ==48 & type =="Provincia"
replace geo_name = "Burgos" if codprov ==9
replace geo_name = "Cáceres" if codprov ==10
replace geo_name = "Cádiz" if codprov ==11
replace geo_name = "Cantabria" if codprov ==39 
replace geo_name = "Ciudad Real" if codprov ==13
replace geo_name = "Córdoba" if codprov ==14
replace geo_name = "Cuenca" if codprov ==16
replace geo_name = "Donostia/San Sebastián" if codprov ==20 & type =="Municipio"
replace geo_name = "Gipuzkoa" if codprov ==20 & type =="Provincia"
replace geo_name = "Girona" if codprov ==17
replace geo_name = "Granada" if codprov ==18
replace geo_name = "Guadalajara" if codprov ==19
replace geo_name = "Huelva" if codprov ==21
replace geo_name = "Huesca" if codprov ==22
replace geo_name = "Illes Balears" if codprov ==7 & type =="Provincia"
replace geo_name = "Palma" if codprov ==7 & type =="Municipio"
replace geo_name = "Jaén" if codprov ==23
replace geo_name = "La Rioja" if codprov ==26
replace geo_name = "León" if codprov ==24
replace geo_name = "Lleida" if codprov ==25
replace geo_name = "Logroño" if codprov ==26 & type =="Municipio"
replace geo_name = "Lugo" if codprov ==27

replace geo_name = "Madrid" if codprov ==28
replace geo_name = "Málaga" if codprov ==29
replace geo_name = "Murcia" if codprov ==30
replace geo_name = "Navarra" if codprov ==31
replace geo_name = "Pamplona/Iruña" if codprov ==31 & type =="Municipio"
replace geo_name = "Ourense" if codprov ==32
replace geo_name = "Palencia" if codprov ==34
replace geo_name = "Pontevedra" if codprov ==36
replace geo_name = "Salamanca" if codprov ==37
replace geo_name = "Segovia" if codprov ==40
replace geo_name = "Sevilla" if codprov ==41
replace geo_name = "Soria" if codprov ==42
replace geo_name = "Tarragona" if codprov ==43
replace geo_name = "Teruel" if codprov ==44
replace geo_name = "Toledo" if codprov ==45

replace geo_name = "València" if codprov ==46 & type =="Municipio"
replace geo_name = "València/Valencia" if codprov ==46 & type =="Provincia"
replace geo_name = "Valladolid" if codprov ==47
replace geo_name = "Zamora" if codprov ==49
replace geo_name = "Zaragoza" if codprov ==50

rename geo_name NAMEUNIT
rename type NATLEVNAME
//Important id variable as it is the one used for merge in QGIS!
gen id =_n
save "$Output_data/descriptive_maps/maps_qgis.dta", replace
export excel using "$Output_data/descriptive_maps/maps_qgis.xls", firstrow(variables) replace
********************************************
**# 4 groups
********************************************
use "$Output_data/descriptive_maps/maps_qgis.dta", clear
drop pop_w  
drop if median_p==. 

gen group = 1 if median_p ==1 & median_tea==0
replace group = 2 if median_p ==0 & median_tea==1
replace group = 3 if median_p ==0 & median_tea==0
replace group = 4 if median_p ==1 & median_tea==1

drop median*
export excel using "$Output_data/descriptive_maps/maps_qgis_4groups.xls", firstrow(variables) replace
