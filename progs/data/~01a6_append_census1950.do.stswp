*******************************
**# 1950 CENSUS 
*******************************

*******************************
**# 1. 1950 Total population  
*******************************
import excel "$Data\census\1950\total_population\Censo_1950_digitized.xlsx", sheet("Sheet1") firstrow clear
order province type
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
replace province = "santa cruz de tenerife" if province == "tenerife" 
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
replace codprov =25 if province == "lerida" 
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
replace codprov =26 if province == "larioja"| province == "logroño"
order codprov province type
sort codprov province codprov type 
foreach v of varlist population_men- population_total {
    replace `v' = -`v' if type == "full province"
	egen `v'_restprov = total(`v'), by(codprov)
	replace `v' = -`v'_restprov if type == "full province"
	drop `v'_restprov
}
replace type ="rest province" if type =="full province"

save "$Data\census\census_1950_step1.dta", replace

use "$Data\census\census_1950_step1.dta", clear

*******************************
**# 2. 1950 population by age
*******************************
import excel "$Data\census\1950\by_age\censo_1950.xlsx", sheet("Sheet1") firstrow clear
drop O
drop if total==.
replace province = lower(province)
replace group2 = group2+group3
drop group3
rename group4 group3
rename group5 group4
rename group6 group5
rename group7 group6
rename group8 group7
rename group9 group8

replace non_stated=0 if missing(non_stated)
*keep province type Sex total 

sort province type Sex
egen id = group(province type)
egen sex = group(Sex)
order id  sex type
reshape wide total type Sex group* non_stated, i(id) j(sex)

order province
rename total1 pop_female
rename total2 pop_male
rename total3 pop_total
drop Sex* type2 type3 
rename type1 type
rename group(#)1 group(#)_female
rename group(#)2 group(#)_male
rename group(#)3 group(#)_total
rename non_stated1 non_stated_female
rename non_stated2 non_stated_male
rename non_stated3 non_stated_total
drop id  
order prov type pop*

replace type ="municipality" if type =="capital"
replace type ="full province" if type =="Total provincial"


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
replace province = "laspalmas"  if province == "palmas (las)" 

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
replace codprov =12 if province == "castellon de la plana" 
replace codprov =46 if province == "valencia" 
replace codprov =6 if province == "badajoz" 
replace codprov =10 if province == "caceres" 
replace province = "a coruña"  if province == "coruna" |province == "coruÑa, (la)"
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
replace codprov =26 if province == "larioja"| province == "logroño"


foreach v of varlist pop_female - non_stated_total {
    replace `v' = -`v' if type == "full province"
	egen `v'_restprov = total(`v'), by(codprov)
	replace `v' = -`v'_restprov if type == "full province"
	drop `v'_restprov
}
replace type ="rest province" if type =="full province"

foreach v of numlist 1/8{
rename group`v'_female popwomen_agegroup`v'_1950
rename group`v'_male popmen_agegroup`v'_1950
rename group`v'_total pop_agegroup`v'_1950

}



* Compute Pop share by age groups
local group ""1" "2" "3" "4" "5" "6" "7" "8""
 foreach x of local group{ 
bysort codprov: gen popshare_agegroup`x' =pop_agegroup`x'/ pop_total
bysort codprov: gen popsharemen_agegroup`x' =popmen_agegroup`x'/ pop_male
bysort codprov: gen popsharewomen_agegroup`x' =popwomen_agegroup`x'/ pop_female

label variable popshare_agegroup`x' "Pop. share age gr.`x'"


rename popshare_agegroup`x' popshare_agegroup`x'_1950 
rename popsharemen_agegroup`x' popsharemen_agegroup`x'_1950 
rename popsharewomen_agegroup`x' popsharewomen_agegroup`x'_1950 
}


foreach x in women men {
label var pop`x'_agegroup1_1950 "Pop. below 5"
label var pop`x'_agegroup2_1950 "Pop. 5-14"
label var pop`x'_agegroup3_1950 "Pop. 15-24"
label var pop`x'_agegroup4_1950 "Pop. 25-34"
label var pop`x'_agegroup5_1950 "Pop. 35-44"
label var pop`x'_agegroup6_1950 "Pop. 45-54"
label var pop`x'_agegroup7_1950 "Pop. 55-64"
label var pop`x'_agegroup8_1950 "Pop. >65"
}
label var pop_agegroup1_1950 "Pop. below 5"
label var pop_agegroup2_1950 "Pop. 5-14"
label var pop_agegroup3_1950 "Pop. 15-24"
label var pop_agegroup4_1950 "Pop. 25-34"
label var pop_agegroup5_1950 "Pop. 35-44"
label var pop_agegroup6_1950 "Pop. 45-54"
label var pop_agegroup7_1950"Pop. 55-64"
label var pop_agegroup8_1950 "Pop. >65"


rename non_stated_female non_stated_women_1950
rename non_stated_male non_stated_men_1950
rename non_stated_total non_stated_1950
label variable non_stated_women_1950 "Non-stated age"
label variable non_stated_men_1950 "Non-stated age"
label variable non_stated_1950 "Non-stated age"

rename pop_total pop_1950 
rename pop_female pop_female_1950 
rename pop_male pop_male_1950 
label variable pop_1950 "Population 1950"
label variable pop_female_1950 "Female population 1950"
label variable pop_male_1950 "Male population 1950"
** Next step it is not necessary (as the current dataset contains total population, I did it just to check all is fine)
*merge 1:1 codprov type using "$Data\census\census_1950_step1.dta"
order province codprov type pop_* popmen_* popwomen* 
save "$Data\census\census_1950.dta",replace
erase "$Data\census\census_1950_step1.dta"

use "$Data\census\census_1950.dta", clear



* * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * *
**# PROVINCE LEVEL DATASET
* * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * *

*******************************
**# 1950 CENSUS 
*******************************

*******************************
**# 1. 1950 Total population  
*******************************
import excel "$Data\census\1950\total_population\Censo_1950_digitized.xlsx", sheet("Sheet1") firstrow clear
order province type
drop if type=="municipality"
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
replace province = "santa cruz de tenerife" if province == "tenerife" 
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
replace codprov =25 if province == "lerida" 
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
replace codprov =26 if province == "larioja"| province == "logroño"
order codprov province type
 
save "$Data\census\census_1950_step1_PROVINCElevel.dta", replace
use "$Data\census\census_1950_step1_PROVINCElevel.dta", clear

*******************************
**# 2. 1950 population by age
*******************************
import excel "$Data\census\1950\by_age\censo_1950.xlsx", sheet("Sheet1") firstrow clear
drop if type =="capital"
drop O
drop if total==.
replace province = lower(province)
replace group2 = group2+group3
drop group3
rename group4 group3
rename group5 group4
rename group6 group5
rename group7 group6
rename group8 group7
rename group9 group8

replace non_stated=0 if missing(non_stated)
*keep province type Sex total 

sort province type Sex
egen id = group(province type)
egen sex = group(Sex)
order id  sex type
reshape wide total type Sex group* non_stated, i(id) j(sex)

order province
rename total1 pop_female
rename total2 pop_male
rename total3 pop_total
drop Sex* type2 type3 
rename type1 type
rename group(#)1 group(#)_female
rename group(#)2 group(#)_male
rename group(#)3 group(#)_total
rename non_stated1 non_stated_female
rename non_stated2 non_stated_male
rename non_stated3 non_stated_total
drop id  
order prov type pop*

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
replace province = "laspalmas"  if province == "palmas (las)" 

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
replace codprov =12 if province == "castellon de la plana" 
replace codprov =46 if province == "valencia" 
replace codprov =6 if province == "badajoz" 
replace codprov =10 if province == "caceres" 
replace province = "a coruña"  if province == "coruna" |province == "coruÑa, (la)"
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
replace codprov =26 if province == "larioja"| province == "logroño"

foreach v of numlist 1/8{
rename group`v'_female popwomen_agegroup`v'_1950
rename group`v'_male popmen_agegroup`v'_1950
rename group`v'_total pop_agegroup`v'_1950

}



* Compute Pop share by age groups
local group ""1" "2" "3" "4" "5" "6" "7" "8""
 foreach x of local group{ 
bysort codprov: gen popshare_agegroup`x' =pop_agegroup`x'/ pop_total
bysort codprov: gen popsharemen_agegroup`x' =popmen_agegroup`x'/ pop_male
bysort codprov: gen popsharewomen_agegroup`x' =popwomen_agegroup`x'/ pop_female

label variable popshare_agegroup`x' "Pop. share age gr.`x'"


rename popshare_agegroup`x' popshare_agegroup`x'_1950 
rename popsharemen_agegroup`x' popsharemen_agegroup`x'_1950 
rename popsharewomen_agegroup`x' popsharewomen_agegroup`x'_1950 
}


foreach x in women men {
label var pop`x'_agegroup1_1950 "Pop. below 5"
label var pop`x'_agegroup2_1950 "Pop. 5-14"
label var pop`x'_agegroup3_1950 "Pop. 15-24"
label var pop`x'_agegroup4_1950 "Pop. 25-34"
label var pop`x'_agegroup5_1950 "Pop. 35-44"
label var pop`x'_agegroup6_1950 "Pop. 45-54"
label var pop`x'_agegroup7_1950 "Pop. 55-64"
label var pop`x'_agegroup8_1950 "Pop. >65"
}
label var pop_agegroup1_1950 "Pop. below 5"
label var pop_agegroup2_1950 "Pop. 5-14"
label var pop_agegroup3_1950 "Pop. 15-24"
label var pop_agegroup4_1950 "Pop. 25-34"
label var pop_agegroup5_1950 "Pop. 35-44"
label var pop_agegroup6_1950 "Pop. 45-54"
label var pop_agegroup7_1950"Pop. 55-64"
label var pop_agegroup8_1950 "Pop. >65"


rename non_stated_female non_stated_women_1950
rename non_stated_male non_stated_men_1950
rename non_stated_total non_stated_1950
label variable non_stated_women_1950 "Non-stated age"
label variable non_stated_men_1950 "Non-stated age"
label variable non_stated_1950 "Non-stated age"

rename pop_total pop_1950 
rename pop_female pop_female_1950 
rename pop_male pop_male_1950 
label variable pop_1950 "Population 1950"
label variable pop_female_1950 "Female population 1950"
label variable pop_male_1950 "Male population 1950"
** Next step it is not necessary (as the current dataset contains total population, I did it just to check all is fine)
*merge 1:1 codprov   using "$Data\census\census_1950_step1_PROVINCElevel.dta"
order province codprov type pop_* popmen_* popwomen* 
drop type
save "$Data\census\census_1950_PROVINCElevel.dta",replace
erase "$Data\census\census_1950_step1_PROVINCElevel.dta"

use "$Data\census\census_1950_PROVINCElevel.dta", clear
