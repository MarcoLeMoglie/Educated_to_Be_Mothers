
* * * * * * * * * * * *
**# capital
* * * * * * * * * * * *
foreach x of numlist 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85{
import excel "C:\Users\laxge\Dropbox\GEMA\RESEARCH\PURGE\original_data\MNP\anuarios_estadisticos_from1954\19`x'_capital.xlsx", sheet("Sheet1") cellrange(A2:E51) clear
sort A
rename A province
gen year = 19`x'
save "$Data\MNP\anuarios_estadisticos_from1954\MNP_1971_1985\19`x'_capital.dta", replace
}

use "$Data\MNP\anuarios_estadisticos_from1954\MNP_1971_1985\1971_capital.dta", clear
foreach x of numlist 72 73 74 75 76 77 78 79 80 81 82 83 84 85{
append using "$Data\MNP\anuarios_estadisticos_from1954\MNP_1971_1985\19`x'_capital.dta"

}
replace province = lower(province)
replace province = subinstr(province, "Á", "a",.) 
replace province = subinstr(province, "í", "i",.) 
replace province = subinstr(province, "ó", "o",.) 
replace province = subinstr(province, "á", "a",.) 
replace province = subinstr(province, "é", "e",.) 
replace province = subinstr(province, "ú", "u",.) 
replace province = lower(province)

sort province
replace province = "baleares" if province=="baleares (palma de mallorca)"
replace province = "guipuzcoa" if province=="guipuzcoa (san sebastian)"
replace province = "a coruña" if province=="coruna (la)"
replace province = "a coruña" if province=="coruña (la)"
replace province = "larioja" if province=="logrono"|province=="logroño"
replace province = "navarra" if province=="navarra (pamplona)"
replace province = "cantabria" if province=="cantabria santander"
replace province = "vizcaya" if province=="vizcaya (bilbao)"
replace province = "larioja" if province=="rioja (la)"
replace province = "larioja" if province=="rioja"
replace province = "asturias" if province=="oviedo"
replace province = "cantabria" if province=="santander"
replace province = "alava" if province=="alava (vitoria)"
gen type ="municipality"
save  "$Data\MNP\anuarios_estadisticos_from1954\MNP_1971_1985\1971_1985_capital.dta", replace

foreach x of numlist 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85{
erase "$Data\MNP\anuarios_estadisticos_from1954\MNP_1971_1985\19`x'_capital.dta"
}
* * * * * * * * * * * *
**# province
* * * * * * * * * * * *
foreach x of numlist 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85{
import excel "C:\Users\laxge\Dropbox\GEMA\RESEARCH\PURGE\original_data\MNP\anuarios_estadisticos_from1954\19`x'_prov.xlsx", sheet("Sheet1") cellrange(A2:E51) clear
sort A
rename A province
gen year = 19`x'
save "$Data\MNP\anuarios_estadisticos_from1954\MNP_1971_1985\19`x'_prov.dta", replace
}

use "$Data\MNP\anuarios_estadisticos_from1954\MNP_1971_1985\1971_prov.dta" , clear
foreach x of numlist 72 73 74 75 76 77 78 79 80 81 82 83 84 85{
append using "$Data\MNP\anuarios_estadisticos_from1954\MNP_1971_1985\19`x'_prov.dta"

}
replace province = lower(province)
replace province = subinstr(province, "Á", "a",.) 
replace province = subinstr(province, "í", "i",.) 
replace province = subinstr(province, "ó", "o",.) 
replace province = subinstr(province, "á", "a",.) 
replace province = subinstr(province, "é", "e",.) 
replace province = subinstr(province, "ú", "u",.) 
replace province = lower(province)

sort province
replace province = "baleares" if province=="baleares (palma de mallorca)"
replace province = "guipuzcoa" if province=="guipuzcoa (san sebastian)"
replace province = "a coruña" if province=="coruna (la)"
replace province = "a coruña" if province=="coruña (la)"
replace province = "larioja" if province=="logrono"|province=="logroño"
replace province = "navarra" if province=="navarra (pamplona)"
replace province = "cantabria" if province=="cantabria santander"
replace province = "vizcaya" if province=="vizcaya (bilbao)"
replace province = "larioja" if province=="rioja (la)"
replace province = "asturias" if province=="oviedo"
replace province = "cantabria" if province=="santander"
replace province = "alava" if province=="alava (vitoria)"
gen type ="full province"
save  "$Data\MNP\anuarios_estadisticos_from1954\MNP_1971_1985\1971_1985_prov.dta", replace

foreach x of numlist 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85{
erase "$Data\MNP\anuarios_estadisticos_from1954\MNP_1971_1985\19`x'_prov.dta"
}
* * * * * * * * * * * *
* * * * * * * * * * * *
**# ALTOGETHER
* * * * * * * * * * * *
* * * * * * * * * * * *
use "$Data\MNP\anuarios_estadisticos_from1954\MNP_1971_1985\1971_1985_prov.dta", clear

append using "$Data\MNP\anuarios_estadisticos_from1954\MNP_1971_1985\1971_1985_capital.dta"

******  			    *******
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
replace province = "santa cruz de tenerife" if province == "sta. c. tenerife" 
replace codprov =38 if province == "santa cruz de tenerife" 
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
replace codprov =25 if province == "lerida" 
replace codprov =43 if province == "tarragona"
replace codprov =3 if province == "alicante" 
replace codprov =12 if province == "castellon" 
replace codprov =12 if province == "castellon de la p." 
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
replace codprov =26 if province == "larioja"
order codprov province year type
format province %10s
format year %7.1g
format codprov %2.1g
rename B total_wedding 
rename C total_birth
rename D birth_male
rename E birth_female

sort codprov type year 
* Compute the value "rest of province" for each single variable by substracting the value of each capital of province and the municipalities (if any) to the total value of the province

foreach v of varlist total_wedding -birth_female {
    replace `v' = -`v' if type == "full province"
	egen `v'_restprov = total(`v'), by(codprov year)
	replace `v' = -`v'_restprov if type == "full province"
	drop `v'_restprov
}

rename total_wedding total_wedding_post1970
replace type = "rest province" if type =="full province"
save "$Data\MNP\anuarios_estadisticos_from1954\MNP_1971_1985\MNP_1971_1985_clean.dta", replace

use "$Data\MNP\anuarios_estadisticos_from1954\MNP_1971_1985\MNP_1971_1985_clean.dta",clear 


* * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * *
**# PROVINCE LEVEL DATASET
* * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * *
use "$Data\MNP\anuarios_estadisticos_from1954\MNP_1971_1985\1971_1985_prov.dta", clear

******  			    *******
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
replace province = "santa cruz de tenerife" if province == "sta. c. tenerife" 
replace codprov =38 if province == "santa cruz de tenerife" 
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
replace codprov =25 if province == "lerida" 
replace codprov =43 if province == "tarragona"
replace codprov =3 if province == "alicante" 
replace codprov =12 if province == "castellon" 
replace codprov =12 if province == "castellon de la p." 
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
replace codprov =26 if province == "larioja"
drop type
order codprov province year  
format province %10s
format year %7.1g
format codprov %2.1g
rename B total_wedding 
rename C total_birth
rename D birth_male
rename E birth_female

sort codprov   year 
 
rename total_wedding total_wedding_post1970 
save "$Data\MNP\anuarios_estadisticos_from1954\MNP_1971_1985\MNP_1971_1985_clean_PROVINCElevel.dta", replace
