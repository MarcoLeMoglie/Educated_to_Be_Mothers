*****************************************
**# 1931 elections province level
*****************************************
import excel "$Data\prewar_elections\province_level\1931\1931_prov_concejales_filiacion.xlsx", sheet("Sheet1") firstrow clear
gen type = "rest province" //important: need to compute the real value "rest of province". I do it below

save "$Data\prewar_elections\province_level\1931\1931_prov_concejales_filiacion.dta", replace
*****************************************
**# 1931 elections capital level
*****************************************
import excel "$Data\prewar_elections\province_level\1931\1931_cap_concejales_filiacion.xlsx", sheet("Sheet1") firstrow clear

gen type = "municipality" //capital
save "$Data\prewar_elections\province_level\1931\1931_cap_concejales_filiacion.dta", replace




*****************************************
**# Append and save
*****************************************
append using "$Data\prewar_elections\province_level\1931\1931_prov_concejales_filiacion.dta"
rename A province
sort prov
order province type 

foreach v of varlist republicanos-no_consta {
	replace `v' = 0 if missing(`v')
    replace `v' = -`v' if type == "rest province"
	egen `v'_restprov = total(`v'), by(province)
	replace `v' = -`v'_restprov if type == "rest province"
	drop `v'_restprov
}
egen total = rowtotal(repub social monarq comun otros no_consta)

foreach v of varlist republicanos-no_consta {
	gen share_`v' = (`v'/total)*100
	drop `v'
}
drop total

rename share* share*1931

**# Province code #
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
replace province = "laspalmas"  if province == "palmas (las)" 
replace province = "laspalmas"  if province == "las palmas" 

replace codprov =35 if province == "laspalmas" 
replace province = "santa cruz de tenerife" if province == "tenerife" 
replace province = "santa cruz de tenerife" if province == "sta. c. tenerife" |province == "santacruztenerife"
replace codprov =38 if province == "santa cruz de tenerife" 
replace codprov =38 if province == "santa cruz tenerife" 
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
replace codprov =25 if province == "lerida" |province=="lleida"
replace codprov =43 if province == "tarragona"
replace codprov =3 if province == "alicante" 
replace codprov =12 if province == "castellon" 
replace codprov =12 if province == "castellon de la p." 
replace codprov =12 if province == "castellon de la plana" 
replace codprov =46 if province == "valencia" 
replace codprov =6 if province == "badajoz" 
replace codprov =10 if province == "caceres" 
replace province = "a coruña"  if province == "coruna" 
replace province = "a coruña"  if province == "coruña" 
replace province = "a coruña"  if province == "coruña (la)" 
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
replace codprov =26 if province == "larioja"| province == "logroño"| province == "logrono"

save "$Data\prewar_elections\province_level\1931\1931_all_concejales_filiacion.dta", replace

use  "$Data\prewar_elections\province_level\1931\1931_all_concejales_filiacion.dta", clear

*****************************************
**# Referendum de auscultacion politica
* Note: adictos is the pertentage of people in each area which is aligned to the regime. In order to compute the aprox share of people aligned in the rest of province areas, then we compute the number of electorate in the rest of province 
* Adictos in rest of province = adictos total province x (Electorate rest/Electorate total)
*****************************************
import excel "$Data\prewar_elections\referendum_1947\unofficial_results\referendum.xlsx", sheet("Sheet2") firstrow clear

rename A type
rename B province

order province type 
sort province type
replace province=lower(province)

gen electores_INE_total = electores_INE if type=="total province"
bysort province (type): replace electores_INE_total = electores_INE_total[2]
replace type= "rest province" if type =="total province"
foreach v of varlist electores_INE {
	replace `v' = 0 if missing(`v')
    replace `v' = -`v' if type == "rest province"
	egen `v'_restprov = total(`v'), by(province)
	replace `v' = -`v'_restprov if type == "rest province"
	drop `v'_restprov
}
*gen adictos_rest = adictos*(electores_INE/electores_INE_total) if type =="rest province"


gen n_adictos_province = int((adictos/100)* electores_INE_total) if type =="rest province"
gen n_adictos_capital = int((adictos/100)* electores_INE) if type =="municipality"
bysort province (type): replace n_adictos_province = n_adictos_province[2]
bysort province (type): replace n_adictos_capital = n_adictos_capital[1] 
gen n_adictos_restp = n_adictos_province-n_adictos_capital 
gen adictos_rest = int((n_adictos_restp/electores_INE)*100) if type =="rest province"
replace adictos = adictos_rest if type =="rest province"
drop adictos_rest  electores_INE electores_INE_total n_adictos_province n_adictos_capital n_adictos_restp
 
 
replace province = subinstr(province, "í", "i",.) 
replace province = subinstr(province, "ó", "o",.) 
replace province = subinstr(province, "á", "a",.) 
replace province = subinstr(province, "é", "e",.) 
replace province = subinstr(province, "ú", "u",.) 
**# Province code #
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
replace province = "laspalmas"  if province == "palmas" |province=="palmas (las)"
replace codprov =35 if province == "laspalmas" 
replace codprov =38 if province == "tenerife" |province=="santa cruz de tenerife"
replace province = "santa cruz de tenerife" if province == "tenerife" 
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
replace codprov =25 if province == "lleida" |province == "lerida"
replace codprov =43 if province == "tarragona"
replace codprov =3 if province == "alicante" 
replace codprov =12 if province == "castellon" 
replace codprov =46 if province == "valencia" 
replace codprov =6 if province == "badajoz" 
replace codprov =10 if province == "caceres" 
replace province = "a coruña"  if province == "coruna" |province == "coruña (la)"
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
replace province = "larioja"  if province == "logrono" |province=="logroño"
replace codprov =26 if province == "larioja"

order codprov
drop province

save "$Data\prewar_elections\referendum_1947\unofficial_results\referendum.dta", replace

use  "$Data\prewar_elections\referendum_1947\unofficial_results\referendum.dta", clear
* * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * *
**# PROVINCE LEVEL DATASET
* * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * *
*****************************************
**# 1931 elections province level
*****************************************
import excel "$Data\prewar_elections\province_level\1931\1931_prov_concejales_filiacion.xlsx", sheet("Sheet1") firstrow clear
 
rename A province
sort prov
order province   

foreach v of varlist republicanos-no_consta {
	replace `v' = 0 if missing(`v')
   
}
egen total = rowtotal(repub social monarq comun otros no_consta)

foreach v of varlist republicanos-no_consta {
	gen share_`v' = (`v'/total)*100
	drop `v'
}
drop total

rename share* share*1931

**# Province code #
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
replace province = "laspalmas"  if province == "palmas (las)" 
replace province = "laspalmas"  if province == "las palmas" 

replace codprov =35 if province == "laspalmas" 
replace province = "santa cruz de tenerife" if province == "tenerife" 
replace province = "santa cruz de tenerife" if province == "sta. c. tenerife" |province == "santacruztenerife"
replace codprov =38 if province == "santa cruz de tenerife" 
replace codprov =38 if province == "santa cruz tenerife" 
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
replace codprov =25 if province == "lerida" |province=="lleida"
replace codprov =43 if province == "tarragona"
replace codprov =3 if province == "alicante" 
replace codprov =12 if province == "castellon" 
replace codprov =12 if province == "castellon de la p." 
replace codprov =12 if province == "castellon de la plana" 
replace codprov =46 if province == "valencia" 
replace codprov =6 if province == "badajoz" 
replace codprov =10 if province == "caceres" 
replace province = "a coruña"  if province == "coruna" 
replace province = "a coruña"  if province == "coruña" 
replace province = "a coruña"  if province == "coruña (la)" 
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
replace codprov =26 if province == "larioja"| province == "logroño"| province == "logrono"

save "$Data\prewar_elections\province_level\1931\1931_all_concejales_filiacion_PROVINCElevel.dta", replace

use  "$Data\prewar_elections\province_level\1931\1931_all_concejales_filiacion_PROVINCElevel.dta", clear

*****************************************
**# Referendum de auscultacion politica
* Note: adictos is the pertentage of people in each area which is aligned to the regime. In order to compute the aprox share of people aligned in the rest of province areas, then we compute the number of electorate in the rest of province 
* Adictos in rest of province = adictos total province x (Electorate rest/Electorate total)
*****************************************
import excel "$Data\prewar_elections\referendum_1947\unofficial_results\referendum.xlsx", sheet("Sheet2") firstrow clear

rename A type
rename B province
drop if type == "municipality"
drop type
order province   
sort province  
replace province=lower(province)

 
replace province = subinstr(province, "í", "i",.) 
replace province = subinstr(province, "ó", "o",.) 
replace province = subinstr(province, "á", "a",.) 
replace province = subinstr(province, "é", "e",.) 
replace province = subinstr(province, "ú", "u",.) 
**# Province code #
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
replace province = "laspalmas"  if province == "palmas" |province=="palmas (las)"
replace codprov =35 if province == "laspalmas" 
replace codprov =38 if province == "tenerife" |province=="santa cruz de tenerife"
replace province = "santa cruz de tenerife" if province == "tenerife" 
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
replace codprov =25 if province == "lleida" |province == "lerida"
replace codprov =43 if province == "tarragona"
replace codprov =3 if province == "alicante" 
replace codprov =12 if province == "castellon" 
replace codprov =46 if province == "valencia" 
replace codprov =6 if province == "badajoz" 
replace codprov =10 if province == "caceres" 
replace province = "a coruña"  if province == "coruna" |province == "coruña (la)"
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
replace province = "larioja"  if province == "logrono" |province=="logroño"
replace codprov =26 if province == "larioja"

order codprov
drop province

save "$Data\prewar_elections\referendum_1947\unofficial_results\referendum_PROVINCElevel.dta", replace

use  "$Data\prewar_elections\referendum_1947\unofficial_results\referendum_PROVINCElevel.dta", clear