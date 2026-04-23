*******************************
**# 1. Prepare Census 1930: Compute value rest of province
*******************************
import excel "$Data\anuarios_estadisticos\finanzas\presupuestos\pop1930census.xlsx", sheet("Sheet1") firstrow clear
replace type = "full province" if type == "province"
foreach v of varlist pop_1930{
    replace `v' = -`v' if type == "full province"
	egen `v'_restprov = total(`v'), by(province)
	replace `v' = -`v'_restprov if type == "full province"
	drop `v'_restprov
}


replace type = "rest province" if type =="full province"
replace type = "municipality" if type =="capital"

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
replace province ="asturias" if province == "oviedo"
replace codprov =33 if province == "asturias" 
replace codprov =7 if province == "baleares" 
replace codprov =35 if province == "las palmas" 
replace province ="santa cruz de tenerife" if province == "tenerife"
replace codprov =38 if province == "santa cruz de tenerife" 
replace codprov =39 if province == "cantabria" |province=="santander"
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
replace codprov =17 if province == "girona" |province=="gerona"
replace codprov =25 if province == "lleida" 
replace codprov =43 if province == "tarragona"
replace codprov =3 if province == "alicante" 
replace codprov =12 if province == "castellon" 
replace codprov =46 if province == "valencia" 
replace codprov =6 if province == "badajoz" 
replace codprov =10 if province == "caceres" 
replace province ="a coruña" if province == "coruna"
replace codprov =15 if province == "a coruña"
replace codprov =27 if province == "lugo"
replace codprov =32 if province == "ourense"|province=="orense"
replace codprov =36 if province == "pontevedra" 
replace codprov =28 if province == "madrid"
replace codprov =30 if province == "murcia"
replace codprov =31 if province == "navarra" // 8 OBSERV
replace codprov =1 if province == "alava" |province=="vitoria" // 8 OBSERV
replace province ="bizkaia" if province == "vizcaya"|province=="bilbao"
replace codprov =48 if province == "bizkaia" // 14 OBSERV
replace codprov =20 if province == "gipuzkoa"  |province=="guipuzcoa" |province=="san sebastian"
replace codprov =26 if province == "larioja"|province=="logrono"
save "$Data\anuarios_estadisticos\finanzas\presupuestos\census_1930.dta", replace
*******************************
**# 2. Start with Census 1940 (no need to compute values for rest of provinces as they are already done in the other dofile)
*******************************
use "$Data\census\census_1940.dta", clear
 
*******************************
**# Merge with Census 1950  (no need to compute values for rest of provinces as they are already done in the other dofile)
*******************************
merge 1:1 codprov type using  "$Data\census\census_1950.dta"
sort codprov type
drop _merge
keep codprov codmun type province municip pop_1940 pop_1950
*******************************
**# Merge with Census 1930  
*******************************
merge 1:1 codprov type using "$Data\anuarios_estadisticos\finanzas\presupuestos\census_1930.dta"
sort codprov type
drop _merge municip codmun

 
** Create panel
gen year =.
foreach p of numlist 1930/1950 {
	quietly: replace year = `p' if year==.
	append using "$Data\anuarios_estadisticos\finanzas\presupuestos\census_1930.dta"
}	
drop if year==.
sort codprov type year
order codprov type year

bysort codprov type: egen pop_1940_= total(pop_1940)
bysort codprov type: egen pop_1950_= total(pop_1950)
drop pop_1940 pop_1950
rename pop_1940_ pop_1940
rename pop_1950_ pop_1950 
gen pop =.

foreach p of numlist 1930 1940 1950 {
replace pop = pop_`p'  if year ==`p' 
}	
drop pop_19*


gen obs_id = _n
by codprov type: ipolate pop obs_id, gen(pop_int)
drop obs_id pop
save "$Data\anuarios_estadisticos\finanzas\presupuestos\census_data.dta", replace
 
*******************************
**# Presupuestos data 
*******************************
import excel "$Data\anuarios_estadisticos\finanzas\presupuestos\presupuestos.xlsx", sheet("Sheet1") firstrow clear
drop ing_*
rename ing ing_pc
rename gastos gastos_pc
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
replace province ="asturias" if province == "oviedo"
replace codprov =33 if province == "asturias" 
replace codprov =7 if province == "baleares" 
replace codprov =35 if province == "las palmas" 
replace province ="santa cruz de tenerife" if province == "tenerife"
replace codprov =38 if province == "santa cruz de tenerife" 
replace codprov =39 if province == "cantabria" |province=="santander"
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
replace codprov =17 if province == "girona" |province=="gerona"
replace codprov =25 if province == "lleida" 
replace codprov =43 if province == "tarragona"
replace codprov =3 if province == "alicante" 
replace codprov =12 if province == "castellon" 
replace codprov =46 if province == "valencia" 
replace codprov =6 if province == "badajoz" 
replace codprov =10 if province == "caceres" 
replace province ="a coruña" if province == "coruna"
replace codprov =15 if province == "a coruña"
replace codprov =27 if province == "lugo"
replace codprov =32 if province == "ourense"|province=="orense"
replace codprov =36 if province == "pontevedra" 
replace codprov =28 if province == "madrid"
replace codprov =30 if province == "murcia"
replace codprov =31 if province == "navarra" // 8 OBSERV
replace codprov =1 if province == "alava" |province=="vitoria" // 8 OBSERV
replace province ="bizkaia" if province == "vizcaya"|province=="bilbao"
replace codprov =48 if province == "bizkaia" // 14 OBSERV
replace codprov =20 if province == "gipuzkoa"  |province=="guipuzcoa" |province=="san sebastian"
replace codprov =26 if province == "la rioja"|province=="logrono"

** Create panel
preserve
keep if year ==1942
keep codprov type
save "$Data\anuarios_estadisticos\finanzas\presupuestos\tmp_forpanel.dta",replace
gen year=.
foreach p of numlist 1930/1950 {
	quietly: replace year = `p' if year==.
	append using "$Data\anuarios_estadisticos\finanzas\presupuestos\tmp_forpanel.dta"
	save "$Data\anuarios_estadisticos\finanzas\presupuestos\tmp_forpanel2.dta",replace
}
drop if year ==.
restore

merge 1:1 codprov type year using "$Data\anuarios_estadisticos\finanzas\presupuestos\tmp_forpanel2.dta"
drop _merge
drop if year ==.

erase "$Data\anuarios_estadisticos\finanzas\presupuestos\tmp_forpanel.dta"
erase "$Data\anuarios_estadisticos\finanzas\presupuestos\tmp_forpanel2.dta"
sort codprov type year
order codprov type year


* I am doing this change for merge, but the values of ingresos and gastos need to be computed for rest of province!
replace type = "rest province" if type == "province"
replace type = "municipality" if type =="capital"
merge 1:1 year codprov type using "$Data\anuarios_estadisticos\finanzas\presupuestos\census_data.dta"
drop _merge
sort codprov type year
order codprov type year


keep if ing!=.

gen ing = ing_pc *pop_int
gen gastos = gastos_pc *pop_int

drop ing_pc gastos_pc


sort codprov province codprov type 
foreach v of varlist ing gastos {
    replace `v' = -`v' if type == "full province"
	egen `v'_restprov = total(`v'), by(codprov)
	replace `v' = -`v'_restprov if type == "full province"
	drop `v'_restprov
}
 
 
save "$Data\anuarios_estadisticos\finanzas\presupuestos\presupuestos.dta", replace