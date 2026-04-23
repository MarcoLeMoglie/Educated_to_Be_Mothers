* * * * * * * * * * * * 
**# Total
* * * * * * * * * * * * 
import excel "$Data\census\1940_provinces_capprovince\digitized\cap_total.xlsx", sheet("Sheet1")   clear

rename A province

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
replace codprov =35 if province == "laspalmas" 
replace codprov =38 if province == "tenerife" 
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

gen type = "capital"
gen year = 1940
order codprov type
rename (B C D E F G H I J K L M) pop_agegroup#, addnumber
label variable pop_agegroup1 "Pop. below 5" 
label variable pop_agegroup2 "Pop. 5-14" 
label variable pop_agegroup3 "Pop. 15-24" 
label variable pop_agegroup4 "Pop. 25-34" 
label variable pop_agegroup5 "Pop. 35-44" 
label variable pop_agegroup6 "Pop. 45-54"
label variable pop_agegroup7 "Pop. 55-64" 
label variable pop_agegroup8 "Pop. 65-74" 
label variable pop_agegroup9 "Pop. 75-84" 
label variable pop_agegroup10 "Pop. 85-94" 
label variable pop_agegroup11 "Pop. 95-99" 


* Sum
egen pop_total = rowtotal(pop_agegroup*)


drop pop_agegroup12
drop if province == "tarragona"|province == "barcelona"|province == "lleida"|province == "gerona" // they are already in the dataset from Catalunya

* recover codmun from INE
gen municip = province
replace municip = lower(municip)
replace municip = strtrim(municip)
replace municip = subinstr(municip, "á", "a",.) 
replace municip = subinstr(municip, "é", "e",.) 
replace municip = subinstr(municip, "í", "i",.) 
replace municip = subinstr(municip, "ó", "o",.) 
replace municip = subinstr(municip, "ú", "u",.)

replace municip = subinstr(municip, "Á", "a",.) 
replace municip = subinstr(municip, "É", "e",.) 



replace municip = "oviedo" if municip =="asturias"
replace municip = "vitoria-gasteiz" if municip =="alava"
replace municip = "santander" if municip =="cantabria"
replace municip = "palma" if municip =="baleares"
replace municip = "castello de la plana" if municip =="castellon"
replace municip = "pamplona" if municip =="navarra"
replace municip = "logrono" if municip =="larioja"
replace municip = "san sebastian" if municip =="guipuzcoa"
replace municip = "bilbao" if municip =="vizcaya"


gen id_master =_n
reclink2 municip codprov using "$Data\codmun_lower.dta", idmaster(id_master) idusing(id_using) gen(merge) minscore(0.51)

drop merge U* _merge id_*

save "$Data\census\census_provinces_byage\1940\capitalcensus1940_clean.dta", replace
use "$Data\census\census_provinces_byage\1940\capitalcensus1940_clean.dta", clear
* * * * * * * * * * * * 
**# Men
* * * * * * * * * * * * 
import excel "$Data\census\1940_provinces_capprovince\digitized\cap_men.xlsx", sheet("Sheet1") clear

rename A province

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
replace codprov =35 if province == "laspalmas" 
replace codprov =38 if province == "tenerife" 
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

gen type = "capital"
gen year = 1940
order codprov type
rename (B C D E F G H I J K L M) popmen_agegroup#, addnumber
label variable popmen_agegroup1 "Pop. below 5" 
label variable popmen_agegroup2 "Pop. 5-14" 
label variable popmen_agegroup3 "Pop. 15-24" 
label variable popmen_agegroup4 "Pop. 25-34" 
label variable popmen_agegroup5 "Pop. 35-44" 
label variable popmen_agegroup6 "Pop. 45-54"
label variable popmen_agegroup7 "Pop. 55-64" 
label variable popmen_agegroup8 "Pop. 65-74" 
label variable popmen_agegroup9 "Pop. 75-84" 
label variable popmen_agegroup10 "Pop. 85-94" 
label variable popmen_agegroup11 "Pop. 95-99" 

* Sum
egen popmen = rowtotal(popmen_agegroup*)


drop popmen_agegroup12
drop if province == "tarragona"|province == "barcelona"|province == "lleida"|province == "gerona" // they are already in the dataset from Catalunya

* recover codmun from INE
gen municip = province
replace municip = lower(municip)
replace municip = strtrim(municip)
replace municip = subinstr(municip, "á", "a",.) 
replace municip = subinstr(municip, "é", "e",.) 
replace municip = subinstr(municip, "í", "i",.) 
replace municip = subinstr(municip, "ó", "o",.) 
replace municip = subinstr(municip, "ú", "u",.)

replace municip = subinstr(municip, "Á", "a",.) 
replace municip = subinstr(municip, "É", "e",.) 

replace municip = "oviedo" if municip =="asturias"
replace municip = "vitoria-gasteiz" if municip =="alava"
replace municip = "santander" if municip =="cantabria"
replace municip = "palma" if municip =="baleares"
replace municip = "castello de la plana" if municip =="castellon"
replace municip = "pamplona" if municip =="navarra"
replace municip = "logrono" if municip =="larioja"
replace municip = "san sebastian" if municip =="guipuzcoa"
replace municip = "bilbao" if municip =="vizcaya"


gen id_master =_n
reclink2 municip codprov using "$Data\codmun_lower.dta", idmaster(id_master) idusing(id_using) gen(merge) minscore(0.51)

drop merge U* _merge id_*

save "$Data\census\census_provinces_byage\1940\capitalcensus1940men_clean.dta", replace
* * * * * * * * * * * * 
**# Women
* * * * * * * * * * * * 
import delimited "$Data\census\1940_provinces_capprovince\digitized\cap_women.csv",   clear 

rename v1 province
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
replace codprov =35 if province == "laspalmas" 
replace codprov =38 if province == "tenerife" 
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

gen type = "capital"
gen year = 1940
order codprov type
rename (v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13) popwomen_agegroup#, addnumber
label variable popwomen_agegroup1 "Pop. below 5" 
label variable popwomen_agegroup2 "Pop. 5-14" 
label variable popwomen_agegroup3 "Pop. 15-24" 
label variable popwomen_agegroup4 "Pop. 25-34" 
label variable popwomen_agegroup5 "Pop. 35-44" 
label variable popwomen_agegroup6 "Pop. 45-54"
label variable popwomen_agegroup7 "Pop. 55-64" 
label variable popwomen_agegroup8 "Pop. 65-74" 
label variable popwomen_agegroup9 "Pop. 75-84" 
label variable popwomen_agegroup10 "Pop. 85-94" 
label variable popwomen_agegroup11 "Pop. 95-99" 

* Sum
egen popwomen = rowtotal(popwomen_agegroup*)

drop popwomen_agegroup12
drop if province == "tarragona"|province == "barcelona"|province == "lleida"|province == "gerona" // they are already in the dataset from Catalunya

* recover codmun from INE
gen municip = province
replace municip = lower(municip)
replace municip = strtrim(municip)
replace municip = subinstr(municip, "á", "a",.) 
replace municip = subinstr(municip, "é", "e",.) 
replace municip = subinstr(municip, "í", "i",.) 
replace municip = subinstr(municip, "ó", "o",.) 
replace municip = subinstr(municip, "ú", "u",.)

replace municip = subinstr(municip, "Á", "a",.) 
replace municip = subinstr(municip, "É", "e",.) 

replace municip = "oviedo" if municip =="asturias"
replace municip = "vitoria-gasteiz" if municip =="alava"
replace municip = "santander" if municip =="cantabria"
replace municip = "palma" if municip =="baleares"
replace municip = "castello de la plana" if municip =="castellon"
replace municip = "pamplona" if municip =="navarra"
replace municip = "logrono" if municip =="larioja"
replace municip = "san sebastian" if municip =="guipuzcoa"
replace municip = "bilbao" if municip =="vizcaya"


gen id_master =_n
reclink2 municip codprov using "$Data\codmun_lower.dta", idmaster(id_master) idusing(id_using) gen(merge) minscore(0.51)

drop merge U* _merge id_*

save "$Data\census\census_provinces_byage\1940\capitalcensus1940women_clean.dta", replace
use "$Data\census\census_provinces_byage\1940\capitalcensus1940women_clean.dta", clear


* * * * * * * * * * * * * * * *
**# Merge total + men + women
* * * * * * * * * * * * * * * *
use "$Data\census\census_provinces_byage\1940\capitalcensus1940_clean.dta", clear
merge 1:1 codprov using "$Data\census\census_provinces_byage\1940\capitalcensus1940men_clean.dta"
drop _merge
merge 1:1 codprov using "$Data\census\census_provinces_byage\1940\capitalcensus1940women_clean.dta"
drop _merge
save "$Data\census\census_provinces_byage\1940\capitalcensus1940all_clean.dta", replace

use "$Data\census\census_provinces_byage\1940\capitalcensus1940all_clean.dta", clear