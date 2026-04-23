* This dofile imports 
* 1. Catalunya census
* 2. Data from pictures taken by Gema from the original books. Data at municipality level (above 20.000 inhabitants)

*********************
**# 1. Catalunya census. Original file CED32. Població per edat, sexe i estat civil. Catalunya. Capitals i municipis majors de 20000 habitants. 1940. Source: "Censo de la población de España según el empadronamiento hecho en la peninsula e Islas Adyacentes y posesiones del Norte y Costa Occidental de Africa el 31 de diciembre de 1940" Dirección General de Estadística, Madrid 1943
*********************
import excel "$Data\census\catalunya\1940\CED32.xls", sheet("Dades") cellrange(A20:F7390) firstrow clear
drop if EDAT==.
drop ESTAT
rename (PROVINCIA MUNICIPI POBLAC SEXE) (codprov codmun pop sex)
destring codprov codmun sex, replace
gen province = "barcelona" if codprov == 8
replace province = "gerona" if codprov == 17
replace province = "lleida" if codprov == 25
replace province = "tarragona" if codprov == 43
order province

gen gender = "male" if sex == 1
replace gender = "female" if sex == 6

sort codmun
by codmun: egen pop_agegroup2 = sum(pop) if EDAT >4 & EDAT < 15
label variable pop_agegroup2 "Pop. 5-14" 

by codmun: egen pop_agegroup1 = sum(pop) if EDAT < 5
label variable pop_agegroup1 "Pop. below 5" 
by codmun: egen pop_agegroup3 = sum(pop) if EDAT >=15 & EDAT <= 24
label variable pop_agegroup3 "Pop. 15-24" 
by codmun: egen pop_agegroup4 = sum(pop) if EDAT >=25 & EDAT <= 34
label variable pop_agegroup4 "Pop. 25-34" 
by codmun: egen pop_agegroup5 = sum(pop) if EDAT >=35 & EDAT <= 44
label variable pop_agegroup5 "Pop. 35-44" 
by codmun: egen pop_agegroup6 = sum(pop) if EDAT >=45 & EDAT <= 54
label variable pop_agegroup6 "Pop. 45-54"
by codmun: egen pop_agegroup7 = sum(pop) if EDAT >=55 & EDAT <= 64
label variable pop_agegroup7 "Pop. 55-64" 
by codmun: egen pop_agegroup8 = sum(pop) if EDAT >=65 & EDAT <= 74
label variable pop_agegroup8 "Pop. 65-74" 
by codmun: egen pop_agegroup9 = sum(pop) if EDAT >=75 & EDAT <= 84
label variable pop_agegroup9 "Pop. 75-84" 
by codmun: egen pop_agegroup10 = sum(pop) if EDAT >=85 & EDAT <=94
label variable pop_agegroup10 "Pop. 85-94" 
by codmun: egen pop_agegroup11 = sum(pop) if EDAT >=95 & EDAT <= 110
label variable pop_agegroup11 "Pop. 95-99" 
** male
by codmun: egen popmen_agegroup1 = sum(pop) if EDAT < 5 & sex==1
label variable popmen_agegroup1 "Male Pop. below 5" 
by codmun: egen popmen_agegroup2 = sum(pop) if EDAT >4 & EDAT < 15  & sex==1
label variable popmen_agegroup2 "Male Pop. 5-14" 
by codmun: egen popmen_agegroup3 = sum(pop) if EDAT >=15 & EDAT <= 24 & sex==1
label variable popmen_agegroup3 "Male Pop. 15-24" 
by codmun: egen popmen_agegroup4 = sum(pop) if EDAT >=25 & EDAT <= 34 & sex==1
label variable popmen_agegroup4 "Male Pop. 25-34" 
by codmun: egen popmen_agegroup5 = sum(pop) if EDAT >=35 & EDAT <= 44 & sex==1
label variable popmen_agegroup5 "Male Pop. 35-44" 
by codmun: egen popmen_agegroup6 = sum(pop) if EDAT >=45 & EDAT <= 54 & sex==1
label variable popmen_agegroup6 "Male Pop. 45-54"
by codmun: egen popmen_agegroup7 = sum(pop) if EDAT >=55 & EDAT <= 64 & sex==1
label variable popmen_agegroup7 "Male Pop. 55-64" 
by codmun: egen popmen_agegroup8 = sum(pop) if EDAT >=65 & EDAT <= 74 & sex==1
label variable popmen_agegroup8 "Male Pop. 65-74" 
by codmun: egen popmen_agegroup9 = sum(pop) if EDAT >=75 & EDAT <= 84 & sex==1
label variable popmen_agegroup9 "Male Pop. 75-84" 
by codmun: egen popmen_agegroup10 = sum(pop) if EDAT >=85 & EDAT <=94 & sex==1
label variable popmen_agegroup10 "Male Pop. 85-94" 
by codmun: egen popmen_agegroup11 = sum(pop) if EDAT >=95 & EDAT <= 110 & sex==1
label variable popmen_agegroup11 "Male Pop. 95-99" 
** female 
by codmun: egen popwomen_agegroup1 = sum(pop) if EDAT < 5 & sex==6
label variable popwomen_agegroup1 "Female Pop. below 5" 
by codmun: egen popwomen_agegroup2 = sum(pop) if EDAT >4 & EDAT < 15  & sex==1
label variable popwomen_agegroup2 "Female Pop. 5-14" 
by codmun: egen popwomen_agegroup3 = sum(pop) if EDAT >=15 & EDAT <= 24 & sex==6
label variable popwomen_agegroup3 "Female Pop. 15-24" 
by codmun: egen popwomen_agegroup4 = sum(pop) if EDAT >=25 & EDAT <= 34 & sex==6
label variable popwomen_agegroup4 "Female Pop. 25-34" 
by codmun: egen popwomen_agegroup5 = sum(pop) if EDAT >=35 & EDAT <= 44 & sex==6
label variable popwomen_agegroup5 "Female Pop. 35-44" 
by codmun: egen popwomen_agegroup6 = sum(pop) if EDAT >=45 & EDAT <= 54 & sex==6
label variable popwomen_agegroup6 "Female Pop. 45-54"
by codmun: egen popwomen_agegroup7 = sum(pop) if EDAT >=55 & EDAT <= 64 & sex==6
label variable popwomen_agegroup7 "Female Pop. 55-64" 
by codmun: egen popwomen_agegroup8 = sum(pop) if EDAT >=65 & EDAT <= 74 & sex==6
label variable popwomen_agegroup8 "Female Pop. 65-74" 
by codmun: egen popwomen_agegroup9 = sum(pop) if EDAT >=75 & EDAT <= 84 & sex==6
label variable popwomen_agegroup9 "Female Pop. 75-84" 
by codmun: egen popwomen_agegroup10 = sum(pop) if EDAT >=85 & EDAT <=94 & sex==6
label variable popwomen_agegroup10 "Female Pop. 85-94" 
by codmun: egen popwomen_agegroup11 = sum(pop) if EDAT >=95 & EDAT <= 110 & sex==6
label variable popwomen_agegroup11 "Female Pop. 95-99" 


by codmun: egen pop_total = sum(pop) 
label variable pop_total "Total pop." 

by codmun: egen popmen = sum(pop) if gender == "male"
label variable popmen "Total male pop." 

by codmun: egen popwomen = sum(pop) if gender == "female"
label variable popwomen "Total female pop." 

*Fill in missing values by group
bysort codmun: egen men = min(popmen)
bysort codmun: egen women = min(popwomen)

drop popwomen popmen
rename (men women) (popmen popwomen)

*keep agegroup2 for now
drop pop sex gender EDAT
duplicates drop

local group ""1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11""
 foreach x of local group{ 
bysort codmun: egen pop_agegroup_`x' = min(pop_agegroup`x') 
bysort codmun: egen popmen_agegroup_`x' = min(popmen_agegroup`x') 
bysort codmun: egen popwomen_agegroup_`x' = min(popwomen_agegroup`x') 
drop pop_agegroup`x' popmen_agegroup`x' popwomen_agegroup`x'
rename pop_agegroup_`x' pop_agegroup`x' 
rename popmen_agegroup_`x' popmen_agegroup`x'
rename popwomen_agegroup_`x' popwomen_agegroup`x'
}

gen year = 1940
order year
* gen type municip
gen type = "municipality"
duplicates drop
order codprov codmun

* recover name of municipality from codmun
tostring codmun, replace
gen codmun2 = substr(codmun, -3, 3)
drop codmun
rename codmun2 codmun
destring codmun, replace
merge 1:1 codprov codmun using "$Data\INE_codes\codmun_lower.dta" 
drop if _merge ==2

drop _merge id_*

save "$Data\census\catalunya\municip_catalunya_clean.dta", replace
use "$Data\census\catalunya\municip_catalunya_clean.dta", clear
*********************
**# 2. Data from pictures taken by Gema from the original books. Data at municipality level (above 20.000 inhabitants) 65 observ
*********************
import excel "$Data\census\censo_1940_municipios_fotos\censo_1940_municip.xlsx", sheet("Sheet1") firstrow clear

egen pop_agegroup2 = rowtotal(men_5_9 men_10_14 women_5_9 women_10_14)
label variable pop_agegroup2 "Pop. 5-14" 

egen pop_total = rowtotal(total_men total_women)
label variable pop_total "Total pop." 

drop men_5_9 men_10_14 women_5_9 women_10_14 total_men total_women
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
replace codprov =7 if province == "islas baleares" 
replace codprov =35 if province == "las palmas" 
replace province ="santa cruz de tenerife" if province == "tenerife"
replace codprov =38 if province == "santa cruz de tenerife" 
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
replace codprov =17 if province == "girona" 
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
replace codprov =32 if province == "ourense"
replace codprov =36 if province == "pontevedra" 
replace codprov =28 if province == "madrid"
replace codprov =30 if province == "murcia"
replace codprov =31 if province == "navarra" 
replace codprov =1 if province == "alava" 
replace province ="bizkaia" if province == "vizcaya"
replace codprov =48 if province == "bizkaia"
replace codprov =20 if province == "gipuzkoa"
replace codprov =26 if province == "la rioja"
replace codprov =51 if province == "ceuta"
replace codprov =52 if province == "melilla"

replace municip = "la laguna" if municip =="lalaguna"
replace municip = "valdés" if municip =="luarca"

gen type = "municipality"
gen year = 1940
* recover codmun from INE
gen id_master =_n
reclink2 municip codprov using "$Data\codmun_lower.dta", idmaster(id_master) idusing(id_using) gen(merge) minscore(0.51)

drop merge U* _merge id_*
save "$Data\census\censo_1940_municipios_fotos\municip_census1940_clean.dta", replace
use "$Data\census\censo_1940_municipios_fotos\municip_census1940_clean.dta", clear