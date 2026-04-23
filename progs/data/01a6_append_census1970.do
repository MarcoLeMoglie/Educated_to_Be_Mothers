*******************************
**# 1970 Census derecho
*******************************

*******************************
**# 1. 1970 Total population
*******************************
import excel "$Data\census\1970\census_1970.xlsx", sheet("Sheet1") cellrange(A1:D101) firstrow clear
drop Populationdederecho
rename Pop* population_total

replace province = lower(province)
replace province = subinstr(province, "Á", "a",.) 
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
replace province = "laspalmas"  if province == "palmas" 
replace province = "laspalmas"  if province == "palmas (las)" 

replace codprov =35 if province == "laspalmas" 
replace codprov =38 if province == "santa cruz de tenerife" |province == "sta . cruz de tenerife"
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
replace codprov =17 if province == "gerona" 
replace codprov =25 if province == "lerida" 
replace codprov =43 if province == "tarragona"
replace codprov =3 if province == "alicante" 
replace codprov =12 if province == "castellon" 
replace codprov =46 if province == "valencia" 
replace codprov =6 if province == "badajoz" 
replace codprov =10 if province == "caceres" 
replace province = "a coruña"  if province == "coruna" 
replace province = "a coruña"  if province == "coruña"| province == "coruña (la)" 
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
replace codprov =26 if province == "larioja"| province == "logroño"

replace type="full province" if type =="total province"
sort codprov province codprov type 
foreach v of varlist population_total {
    replace `v' = -`v' if type == "full province"
	egen `v'_restprov = total(`v'), by(codprov)
	replace `v' = -`v'_restprov if type == "full province"
	drop `v'_restprov
}
replace type ="rest province" if type =="full province"

save "$Data\census\census_1970_step1.dta", replace

*******************************
**# 2. 1970 population by age
*******************************
import excel "$Data\census\1970\by_age\censo1970_byage.xlsx", cellrange(A1:T386)  sheet("Sheet1") firstrow clear
drop if province==""

replace group2=group2+group3
drop group3
gen group3 = group4+group5 //15-24
drop group4 group5
gen group4 = group6+group7 //25-34
drop group6 group7
gen group5 = group8+group9
drop group8 group9
gen group6 = group10+group11
drop group10 group11
gen group7 = group12+ group13
gen group8=group14+group15+group16
drop group12-group16

replace province = lower(province)
replace province = subinstr(province, "Á", "a",.) 
replace province = subinstr(province, "í", "i",.) 
replace province = subinstr(province, "ó", "o",.) 
replace province = subinstr(province, "á", "a",.) 
replace province = subinstr(province, "é", "e",.) 
replace province = subinstr(province, "ú", "u",.) 
replace province = lower(province)
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
replace province = "santa cruz de tenerife" if province == "santacruztenerife" 
replace province = "santa cruz de tenerife" if province == "sta. c. tenerife" 
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
replace codprov =25 if province == "lleida" 
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

sort province type sex
egen id = group(province type)
egen Sex = group(sex)
order id  sex type
reshape wide total type sex group*, i(id) j(Sex)


order province
rename total1 pop_male
rename total2 pop_total
rename total3 pop_female
drop sex* type2 type3 
rename type1 type
rename group(#)1 group(#)_male
rename group(#)2 group(#)_total
rename group(#)3 group(#)_female

drop id  
order prov type codprov pop* 

replace type ="full province" if type =="total province"
foreach v of varlist pop_male - group8_female {
    replace `v' = -`v' if type == "full province"
	egen `v'_restprov = total(`v'), by(codprov)
	replace `v' = -`v'_restprov if type == "full province"
	drop `v'_restprov
}
replace type ="rest province" if type =="full province"

foreach v of numlist 1/8{
rename group`v'_female popwomen_agegroup`v'_1970
rename group`v'_male popmen_agegroup`v'_1970
rename group`v'_total pop_agegroup`v'_1970

}

* Compute Pop share by age groups
local group ""1" "2" "3" "4" "5" "6" "7" "8""
 foreach x of local group{ 
bysort codprov: gen popshare_agegroup`x' =pop_agegroup`x'/ pop_total
bysort codprov: gen popsharemen_agegroup`x' =popmen_agegroup`x'/ pop_male
bysort codprov: gen popsharewomen_agegroup`x' =popwomen_agegroup`x'/ pop_female

label variable popshare_agegroup`x' "Pop. share age gr.`x'"


rename popshare_agegroup`x' popshare_agegroup`x'_1970 
rename popsharemen_agegroup`x' popsharemen_agegroup`x'_1970 
rename popsharewomen_agegroup`x' popsharewomen_agegroup`x'_1970 
}

foreach x in women men {
label var pop`x'_agegroup1_1970 "Pop. below 5"
label var pop`x'_agegroup2_1970 "Pop. 5-14"
label var pop`x'_agegroup3_1970 "Pop. 15-24"
label var pop`x'_agegroup4_1970 "Pop. 25-34"
label var pop`x'_agegroup5_1970 "Pop. 35-44"
label var pop`x'_agegroup6_1970 "Pop. 45-54"
label var pop`x'_agegroup7_1970 "Pop. 55-64"
label var pop`x'_agegroup8_1970 "Pop. >65"
}
label var pop_agegroup1_1970 "Pop. below 5"
label var pop_agegroup2_1970 "Pop. 5-14"
label var pop_agegroup3_1970 "Pop. 15-24"
label var pop_agegroup4_1970 "Pop. 25-34"
label var pop_agegroup5_1970 "Pop. 35-44"
label var pop_agegroup6_1970 "Pop. 45-54"
label var pop_agegroup7_1970 "Pop. 55-64"
label var pop_agegroup8_1970 "Pop. >65"

rename pop_total pop_1970 
rename pop_female pop_female_1970 
rename pop_male pop_male_1970 
label variable pop_1970 "Population 1970"
label variable pop_female_1970 "Female population 1970"
label variable pop_male_1970 "Male population 1970"
* Next step it is not necessary (as the current dataset contains total population, I did it just to check all is fine)
*merge 1:1 codprov type using "$Data\census\census_1970_step1.dta"
order province codprov type pop_* popmen_* popwomen* 
save "$Data\census\census_1970.dta",replace

erase "$Data\census\census_1970_step1.dta"


* * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * *
**# PROVINCE LEVEL DATASET
* * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * *

*******************************
**# 1970 Census derecho
*******************************

*******************************
**# 1. 1970 Total population
*******************************
import excel "$Data\census\1970\census_1970.xlsx", sheet("Sheet1") cellrange(A1:D101) firstrow clear
drop if type == "municipality"
drop Populationdederecho
rename Pop* population_total

replace province = lower(province)
replace province = subinstr(province, "Á", "a",.) 
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
replace province = "laspalmas"  if province == "palmas" 
replace province = "laspalmas"  if province == "palmas (las)" 

replace codprov =35 if province == "laspalmas" 
replace codprov =38 if province == "santa cruz de tenerife" |province == "sta . cruz de tenerife"
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
replace codprov =17 if province == "gerona" 
replace codprov =25 if province == "lerida" 
replace codprov =43 if province == "tarragona"
replace codprov =3 if province == "alicante" 
replace codprov =12 if province == "castellon" 
replace codprov =46 if province == "valencia" 
replace codprov =6 if province == "badajoz" 
replace codprov =10 if province == "caceres" 
replace province = "a coruña"  if province == "coruna" 
replace province = "a coruña"  if province == "coruña"| province == "coruña (la)" 
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
replace codprov =26 if province == "larioja"| province == "logroño"


save "$Data\census\census_1970_step1_PROVINCElevel.dta", replace

*******************************
**# 2. 1970 population by age
*******************************
import excel "$Data\census\1970\by_age\censo1970_byage.xlsx", cellrange(A1:T386)  sheet("Sheet1") firstrow clear
drop if province==""
drop if type== "municipality"
replace group2=group2+group3
drop group3
gen group3 = group4+group5 //15-24
drop group4 group5
gen group4 = group6+group7 //25-34
drop group6 group7
gen group5 = group8+group9
drop group8 group9
gen group6 = group10+group11
drop group10 group11
gen group7 = group12+ group13
gen group8=group14+group15+group16
drop group12-group16

replace province = lower(province)
replace province = subinstr(province, "Á", "a",.) 
replace province = subinstr(province, "í", "i",.) 
replace province = subinstr(province, "ó", "o",.) 
replace province = subinstr(province, "á", "a",.) 
replace province = subinstr(province, "é", "e",.) 
replace province = subinstr(province, "ú", "u",.) 
replace province = lower(province)
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
replace province = "santa cruz de tenerife" if province == "santacruztenerife" 
replace province = "santa cruz de tenerife" if province == "sta. c. tenerife" 
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
replace codprov =25 if province == "lleida" 
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

sort province type sex
egen id = group(province type)
egen Sex = group(sex)
order id  sex type
reshape wide total type sex group*, i(id) j(Sex)


order province
rename total1 pop_male
rename total2 pop_total
rename total3 pop_female
drop sex* type2 type3 
rename type1 type
rename group(#)1 group(#)_male
rename group(#)2 group(#)_total
rename group(#)3 group(#)_female

drop id  
order prov type codprov pop* 
 
foreach v of numlist 1/8{
rename group`v'_female popwomen_agegroup`v'_1970
rename group`v'_male popmen_agegroup`v'_1970
rename group`v'_total pop_agegroup`v'_1970

}

* Compute Pop share by age groups
local group ""1" "2" "3" "4" "5" "6" "7" "8""
 foreach x of local group{ 
bysort codprov: gen popshare_agegroup`x' =pop_agegroup`x'/ pop_total
bysort codprov: gen popsharemen_agegroup`x' =popmen_agegroup`x'/ pop_male
bysort codprov: gen popsharewomen_agegroup`x' =popwomen_agegroup`x'/ pop_female

label variable popshare_agegroup`x' "Pop. share age gr.`x'"


rename popshare_agegroup`x' popshare_agegroup`x'_1970 
rename popsharemen_agegroup`x' popsharemen_agegroup`x'_1970 
rename popsharewomen_agegroup`x' popsharewomen_agegroup`x'_1970 
}

foreach x in women men {
label var pop`x'_agegroup1_1970 "Pop. below 5"
label var pop`x'_agegroup2_1970 "Pop. 5-14"
label var pop`x'_agegroup3_1970 "Pop. 15-24"
label var pop`x'_agegroup4_1970 "Pop. 25-34"
label var pop`x'_agegroup5_1970 "Pop. 35-44"
label var pop`x'_agegroup6_1970 "Pop. 45-54"
label var pop`x'_agegroup7_1970 "Pop. 55-64"
label var pop`x'_agegroup8_1970 "Pop. >65"
}
label var pop_agegroup1_1970 "Pop. below 5"
label var pop_agegroup2_1970 "Pop. 5-14"
label var pop_agegroup3_1970 "Pop. 15-24"
label var pop_agegroup4_1970 "Pop. 25-34"
label var pop_agegroup5_1970 "Pop. 35-44"
label var pop_agegroup6_1970 "Pop. 45-54"
label var pop_agegroup7_1970 "Pop. 55-64"
label var pop_agegroup8_1970 "Pop. >65"

rename pop_total pop_1970 
rename pop_female pop_female_1970 
rename pop_male pop_male_1970 
label variable pop_1970 "Population 1970"
label variable pop_female_1970 "Female population 1970"
label variable pop_male_1970 "Male population 1970"
* Next step it is not necessary (as the current dataset contains total population, I did it just to check all is fine)
*merge 1:1 codprov type using "$Data\census\census_1970_step1.dta"
order province codprov type pop_* popmen_* popwomen* 
drop type
save "$Data\census\census_1970_PROVINCElevel.dta",replace
use "$Data\census\census_1970_PROVINCElevel.dta", clear
erase "$Data\census\census_1970_step1_PROVINCElevel.dta"