*******************************
**# 1. CENSUS Lleida (capital: men and women) age groups differ wrt the rest of data!
* terminar
*******************************
import excel "$Data\census\1930_provinces_capprovince\lleida_complete.xlsx", sheet("Sheet1") firstrow clear
egen pop_total = rowtotal(pop_men pop_women)

gen province="lleida"
gen codprov =25 if province == "lleida" 
bysort codprov: egen pop_menn = sum(pop_men)  
bysort codprov: egen pop_womenn = sum(pop_women)  
bysort codprov: egen pop_totall = sum(pop_total)  
drop pop_men pop_women pop_total
rename pop_menn pop_men
rename pop_womenn pop_women 
rename pop_totall pop_total 

foreach v in men women {
    gen pop`v'_agegroup1 = pop_`v'[1]   
	egen pop`v'_agegroup2 = sum(pop_`v') if age=="5"| age=="6"| age=="7"| age=="8"| age=="9"| age=="10" | age=="11 13" | age=="14 15"
	egen pop`v'_agegroup3 = sum(pop_`v') if  age=="16 17"| age=="18 20"| age=="21 25" 
	egen pop`v'_agegroup4 = sum(pop_`v') if age=="26 30"| age=="31 35" 
	egen pop`v'_agegroup5 = sum(pop_`v') if age=="36 40"| age=="41 45" 
	egen pop`v'_agegroup6 = sum(pop_`v') if age=="46 50"| age=="51 55" 
	egen pop`v'_agegroup7 = sum(pop_`v') if age=="56 60"| age=="61 70" 
	egen pop`v'_agegroup8 = sum(pop_`v') if age=="71 80"| age=="81 90" | age=="91 100" 
}
sort id_age
	egen pop_agegroup1 = sum(pop_total) if id_age==0
	egen pop_agegroup2 = sum(pop_total) if id_age>=1 & id_age<=8
	egen pop_agegroup3 = sum(pop_total) if age=="16 17"| age=="18 20"| age=="21 25" 
	egen pop_agegroup4 = sum(pop_total) if age=="26 30"| age=="31 35" 
	egen pop_agegroup5 = sum(pop_total) if age=="36 40"| age=="41 45" 
	egen pop_agegroup6 = sum(pop_total) if age=="46 50"| age=="51 55" 
	egen pop_agegroup7 = sum(pop_total) if age=="56 60"| age=="61 70" 
	egen pop_agegroup8 = sum(pop_total) if age=="71 80"| age=="81 90" | age=="91 100" 
* * * * * * * *	
foreach x of numlist 2 3 4 5 6 7 8{
	sort popmen_agegroup`x' 
	replace  popmen_agegroup`x' = popmen_agegroup`x'[1] if missing(popmen_agegroup`x')
	replace  popwomen_agegroup`x' = popwomen_agegroup`x'[1] if missing(popwomen_agegroup`x')
	replace  pop_agegroup`x' = pop_agegroup`x'[1] if missing(pop_agegroup`x')
}
sort id_age
replace  pop_agegroup1 = pop_agegroup1[1] if missing(pop_agegroup1)
sort id_age
drop id_age age 
duplicates drop

gen year =1930
gen type ="capital"
gen administrative_unit ="capital"
gen geo_name=province
save "$Data\census\census_provinces_byage\1930\capitalcensus1930_lleida.dta", replace
use "$Data\census\census_provinces_byage\1930\capitalcensus1930_lleida.dta", clear

*******************************
**# 2. CENSUS AT cap province: total
*******************************
import excel "$Data\census\1930_provinces_capprovince\1930_capital.xlsx", sheet("Sheet1") firstrow clear
rename province_name province
replace province = lower(province)
replace province = subinstr(province, "á", "a",.) 
replace province = subinstr(province, "é", "e",.) 
replace province = subinstr(province, "í", "i",.) 
replace province = subinstr(province, "ó", "o",.) 
replace province = subinstr(province, "ú", "u",.)

*# Province code #
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
replace codprov =25 if province == "lleida" 
drop if province == "lerida" 
replace codprov =43 if province == "tarragona"
replace codprov =3 if province == "alicante" 
replace province = "castellon"  if province == "castellon de la p." 
replace codprov =12 if province == "castellon" 
replace codprov =46 if province == "valencia" 
replace codprov =6 if province == "badajoz" 
replace codprov =10 if province == "caceres" 
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
replace province = "larioja"  if province == "logroño" 
replace codprov =26 if province == "larioja"

gen type = "capital"


order codprov type
egen pop_agegroup1 = rowtotal(census_age_1- census_age_4)
egen pop_agegroup2 = rowtotal(census_age_5- census_age_14)
egen pop_agegroup3 = rowtotal(census_age_15- census_age_24)
egen pop_agegroup4 = rowtotal(census_age_25- census_age_34)
egen pop_agegroup5 = rowtotal(census_age_35- census_age_44)
egen pop_agegroup6 = rowtotal(census_age_45- census_age_54)
egen pop_agegroup7 = rowtotal(census_age_55- census_age_64)
egen pop_agegroup8 = rowtotal(census_age_65- census_age_116)
*egen pop_agegroup9 = rowtotal(census_age_75- census_age_84)
*egen pop_agegroup10 = rowtotal(census_age_85- census_age_94)
*egen pop_agegroup11 = rowtotal(census_age_95- census_age_116)
*egen pop_agegroup12 = rowtotal(census_age_more116)
label variable pop_agegroup1 "Pop. below 5" 
label variable pop_agegroup2 "Pop. 5-14" 
label variable pop_agegroup3 "Pop. 15-24" 
label variable pop_agegroup4 "Pop. 25-34" 
label variable pop_agegroup5 "Pop. 35-44" 
label variable pop_agegroup6 "Pop. 45-54"
label variable pop_agegroup7 "Pop. 55-64" 
label variable pop_agegroup8 "Pop> 65" 
*label variable pop_agegroup12 "Pop. >117" 

drop census_* 

* Sum
egen pop_total = rowtotal(pop_agegroup*)

* recover codmun from INE
gen municip = province

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


save "$Data\census\census_provinces_byage\1930\capitalcensus1930_clean.dta", replace
use "$Data\census\census_provinces_byage\1930\capitalcensus1930_clean.dta", clear
*******************************
**# 3. CENSUS AT cap province MEN
*******************************
import excel "$Data\census\1930_provinces_capprovince\1930_capital_gender.xlsx", sheet("Sheet1") cellrange(A1:C4875) firstrow clear
replace age = "200" if age =="no consta"
destring age, replace
bysort geo_name (age): egen popmen_agegroup1 = sum(men) if age<5
bysort geo_name (age): egen popmen_agegroup2 = sum(men) if age>=5 & age<=14
bysort geo_name (age): egen popmen_agegroup3 = sum(men) if age>=15 & age<=24
bysort geo_name (age): egen popmen_agegroup4 = sum(men) if age>=25 & age<=34
bysort geo_name (age): egen popmen_agegroup5 = sum(men) if age>=35 & age<=44
bysort geo_name (age): egen popmen_agegroup6 = sum(men) if age>=45 & age<=54
bysort geo_name (age): egen popmen_agegroup7 = sum(men) if age>=55 & age<=64
bysort geo_name (age): egen popmen_agegroup8 = sum(men) if age>65 & age<120

bysort geo_name: egen pop_men = sum(men) //total_men

foreach x of numlist  1 2 3 4 5 6 7 8{
bysort geo_name (popmen_agegroup`x'): replace popmen_agegroup`x' = popmen_agegroup`x'[1] if missing(popmen_agegroup`x')
}
drop men age 
duplicates drop
gen type ="capital"
rename geo_name province
replace province = lower(province)
replace province = subinstr(province, "á", "a",.) 
replace province = subinstr(province, "é", "e",.) 
replace province = subinstr(province, "í", "i",.) 
replace province = subinstr(province, "ó", "o",.) 
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
replace codprov =35 if province == "las palmas" 
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
drop if province == "lleida" //it's province!
replace codprov =43 if province == "tarragona"
replace codprov =3 if province == "alicante" 
replace province = "castellon"  if province == "castellon de la p." 
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
replace codprov =31 if province == "navarra" |province=="pamplona"
replace codprov =1 if province == "alava" 
replace codprov =48 if province == "vizcaya"|province=="bilbao"
replace codprov =20 if province == "guipuzcoa"
replace codprov =26 if province == "la rioja"

sort codprov
order codprov province
// Merge with total dataset
merge 1:1 codprov using "$Data\census\census_provinces_byage\1930\capitalcensus1930_clean.dta"
drop _merge
order codprov province pop_total pop_men type year administrative_unit geo_name
* Create women
foreach x of numlist  1 2 3 4 5 6 7 8{
	gen popwomen_agegroup`x' = pop_agegroup`x' -popmen_agegroup`x' 
}

gen pop_women=pop_total-pop_men
* Merge with Lleida that contains total men and women data
append using "$Data\census\census_provinces_byage\1930\capitalcensus1930_lleida.dta"
sort codprov
order codprov province pop_total pop_men pop_women type year administrative_unit geo_name
** atencion a los totales y a no consta
drop if province=="lleida"


save "$Data\census\census_provinces_byage\1930\capitalcensus1930_complete.dta", replace
use "$Data\census\census_provinces_byage\1930\capitalcensus1930_complete.dta", clear