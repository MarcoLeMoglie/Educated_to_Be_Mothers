*This dofile imports and appends raw datasets about birth, abortions, etc
*****************************************
**# Municipalities above 20.000 inhabitants
*****************************************
import excel "$Data\MNP\MNP_municip.xlsx", sheet("Sheet1") firstrow clear
gen d_municip = 1
gen d_capital = 0
gen d_province = 0

local year ""1951" "1952" "1953""
 foreach x of local year{ 
egen born_alive_`x' = rowtotal(born_alive_male_`x' born_alive_fem_`x')
egen abort_`x' = rowtotal(abort_male_`x' abort_fem_`x')
drop born_alive_male_`x' born_alive_fem_`x' abort_male_`x' abort_fem_`x'
}
gen type = "municipality"
save "$Data\MNP\temp\MNP_municip.dta", replace
*****************************************
**# Capital of provinces. Variables:
/*
abort_1951 
born_leg_male_1951  born_leg_fem_1951 
born_ileg_male_1951 born_ileg_fem_1951 
nac_viv_male_1951 nac_viv_fem_1951 nac_viv_total_1951 nac_exposit_male_1951 nac_exposit_fem_1951 
marriag_tot_1951 
marr_single_1951 
marr_widower_1951 
marr_widow_1951 
marr_widows_1951*/
*****************************************
import excel "$Data\MNP\MNP_province.xlsx", sheet("prov_cap") firstrow clear
gen d_capital = 1
gen d_municip = 0
gen d_province = 0
rename capital municip
gen type = "capital"

save "$Data\MNP\temp\MNP_capprovince.dta", replace
*****************************************
**# Total province
*****************************************
import excel "$Data\MNP\MNP_province.xlsx", sheet("prov_total") firstrow clear
gen d_capital = 0
gen d_municip = 0
gen d_province = 1
gen type = "full province"

save "$Data\MNP\temp\MNP_province.dta", replace

*****************************************
**# APPEND 3 datasets
*****************************************
use "$Data\MNP\temp\MNP_province.dta", clear
append using "$Data\MNP\temp\MNP_capprovince.dta"
append using "$Data\MNP\temp\MNP_municip.dta"

order d_* province municip  
replace province = municip if d_capital ==1
sort province
replace municip = "total province" if municip ==""

**# Province code #1
gen codprov =4 if province == "almeria" 
replace codprov =11 if province == "cadiz" 
replace codprov =14 if province == "cordoba"  
replace codprov =18 if province == "granada"  
replace codprov =21 if province == "huelva" 
replace codprov =23 if province == "jaen" 
replace codprov =29 if province == "malaga" 
replace codprov =41 if province == "sevilla" 
replace codprov =22 if province == "huesca" 
replace codprov =44 if province == "teruel" 
replace codprov =50 if province == "zaragoza"
replace province = "asturias"  if province == "oviedo" 
replace codprov =33 if province == "asturias" 
replace codprov =7 if province == "baleares" 
replace province = "laspalmas"  if province == "palmas" 
replace codprov =35 if province == "laspalmas" 
replace codprov =38 if province == "tenerife" 
replace province = "cantabria"  if province == "santander" 
replace codprov =39 if province == "cantabria" 
replace codprov =5 if province == "avila"
replace codprov =9 if province == "burgos" 
replace codprov =24 if province == "leon" 
replace codprov =34 if province == "palencia" 
replace codprov =37 if province == "salamanca" 
replace codprov =40 if province == "segovia" 
replace codprov =42 if province == "soria" 
replace codprov =47 if province == "valladolid"
replace codprov =49 if province == "zamora" 
replace codprov =2 if province == "albacete"
replace codprov =13 if province == "ciudad real" 
replace codprov =16 if province == "cuenca" 
replace codprov =19 if province == "guadalajara"
replace codprov =45 if province == "toledo"
replace codprov =8 if province == "barcelona" 
replace province = "gerona"  if province == "gerona" 
replace codprov =17 if province == "gerona" 
replace codprov =25 if province == "lleida" 
replace codprov =43 if province == "tarragona"
replace codprov =3 if province == "alicante" 
replace codprov =12 if province == "castellon" 
replace codprov =46 if province == "valencia" 
replace codprov =6 if province == "badajoz" 
replace codprov =10 if province == "caceres" 
replace province = "a coruña"  if province == "coruna" 
replace codprov =15 if province == "a coruña"
replace codprov =27 if province == "lugo"
replace province = "ourense"  if province == "orense" 
replace codprov =32 if province == "ourense"
replace codprov =36 if province == "pontevedra" 
replace codprov =28 if province == "madrid"
replace codprov =30 if province == "murcia"
replace codprov =31 if province == "navarra" 
replace codprov =1 if province == "alava" 
replace codprov =48 if province == "vizcaya"
replace codprov =20 if province == "guipuzcoa"
replace province = "larioja"  if province == "logrono" 
replace codprov =26 if province == "larioja"


egen id_province = group(province)
order id_province

sort id_province d_province
order type

* Compute the value "rest of province" for each single variable by substracting the value of each capital of province and the municipalities (if any) to the total value of the province
foreach v of varlist abort_1951 -born_alive_1953 {
    replace `v' = -`v' if d_province ==1 & `v' !=. //this is because variables born_alive_1953 is missing for total province
	egen `v'_restprov = total(`v'), by(codprov) 
	replace `v' = -`v'_restprov if d_province ==1 & `v' !=.
	drop `v'_restprov
}

replace municip = "rest province" if municip =="full province"
replace type = "rest province" if type =="full province"
replace municip = "valdés" if municip =="luarca"
replace province = "santa cruz de tenerife" if province == "tenerife" 
replace type = "municipality" if type =="capital" & municip == "tenerife" 
replace municip = "santa cruz de tenerife" if municip == "tenerife" 

order province municip codprov d_*
gen id_using = _n
 
save "$Data\MNP\MNP.dta", replace