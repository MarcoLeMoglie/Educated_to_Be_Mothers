* * * * * * * * * * * * * * *
* Age group 1: "Pop. below 5" 
* Age group 2: "Pop. 5-14" 
* Age group 3: "Pop. 15-24" 
* Age group 4: "Pop. 25-34" 
* Age group 5: "Pop. 35-44" 
* Age group 6: "Pop. 45-54" 
* Age group 7: "Pop. 55-64" 
* Age group 8: "Pop. >65" 
* * * * * * * * * * * * * * *

*******************************
**# 1. Census 1940: total, men and women
*******************************
use "$Data\census\census_1940.dta", clear

*******************************
**# 1.2 Census 1950 
*******************************
merge 1:1 codprov type using  "$Data\census\census_1950.dta"
sort codprov type
drop _merge
*******************************
**# 1.2 Census 1960 
*******************************
merge 1:1 codprov type using  "$Data\census\census_1960.dta" 
sort codprov type
drop _merge //not matched: malaga, burgos and badajoz bc there are mistakes in the data
*******************************
**# 1.3 Census 1970 
*******************************
merge 1:1 codprov type using  "$Data\census\census_1970.dta"
sort codprov type
drop _merge

*******************************
**# 1.4.1 MNP: deaths 1936-1939 
*******************************
merge 1:1 codprov type using "$Data\MNP\defunciones\deaths_clean.dta"
sort codprov type
drop _merge

*******************************
**# 1.4 Front of Civil War 
*******************************
merge 1:1 codprov municip type using "$Data\maps_civilwar\complete_map\data_front_complete.dta"
drop _merge
gen logdistance = log(distance+1)
label variable logdistance "Log distance to front"

*******************************
**# 1.5 Anuarios estadisticos I: education 1933
*******************************
merge 1:1 codprov type using "$Data\anuarios_estadisticos\education\1932_33\1933_all.dta"

sort codprov type
drop _merge
*******************************
**# 1.5 Anuarios estadisticos I: com.religiosas 1930
*******************************
merge 1:1 codprov type using "$Data\anuarios_estadisticos\comunidades_religiosas\1930_all.dta"
sort codprov type
drop _merge

*******************************
**# 1.5 Anuarios estadisticos II: education 1942
*******************************
merge 1:1 codprov type using "$Data\anuarios_estadisticos\education\1944_45\1944_45.dta"
sort codprov type
drop _merge
*******************************
**# 1.5 Anuarios estadisticos II: culture (1942,43)
*******************************
merge 1:1 codprov type using "$Data\anuarios_estadisticos\cultura\1944_45\1944_45.dta"
sort codprov type
drop _merge // unmerged because there is only data for capitals
*******************************
**# 1.5 Anuarios estadisticos II: cost of living index 1 trimestre 1943. Madrid=100
*******************************
merge 1:1 codprov type using "$Data\anuarios_estadisticos\precios\1944_45.dta"
sort codprov type
drop _merge // unmerged because there is only data for capitals
*******************************
**# 1.5 Anuarios estadisticos II: morbidity
*******************************
merge 1:1 codprov type using "$Data\anuarios_estadisticos\sanidad\1944_45.dta"
sort codprov type
drop _merge // unmerged because there is only data for capitals
*******************************
**# 1.6 Pre-treatment voting I: 1931 elections
*******************************
merge 1:1 codprov type using "$Data\prewar_elections\province_level\1931\1931_all_concejales_filiacion.dta"
sort codprov type
drop _merge share_no_consta
*******************************
**# 1.6 Pre-treatment voting II: referendum auscultacion
*******************************
merge 1:1 codprov type using  "$Data\prewar_elections\referendum_1947\unofficial_results\referendum.dta"
sort codprov type
drop _merge  

*******************************
**# 2. Purged Teachers 
*******************************
*merge 1:1 codprov municip type using "$dir\$Output_data\purge\teachers.dta"
merge 1:1 codprov type  using "$dir\$Output_data\purge\teachers.dta"
*merge 1:1 codprov type  using "$dir\$Output_data\purge\teachers_new.dta"
drop _merge
replace teachers=0 if codprov ==3 // because Alicante is in the dataset and has teachers that reentered into schools before 1941
*replace teachers=0 if teachers_entered!=. & teachers==.
**********************************
**# Concentracion camps TBD: version with capital and rest of province ONLY
**********************************
*merge 1:1 codprov codmun using "$Data\purge\concentrationcamps\camps_clean.dta"
*drop _merge

*******************************
**# 3. Census 1930 Important: Lleida is missing 
*******************************
merge 1:1 codprov type using  "$Data\census\census_1930.dta"
sort codprov type
drop _merge

**# Per capita 1000 values deaths during civil war period
foreach v of varlist deaths_male_1936 -deaths_female_cwar {
	replace `v'= (`v'/pop_1930)*1000
	replace `v'= . if missing(pop_1930)
}

label variable deaths_male_1936 "Male deaths per 1000 inhab. (1936)"
label variable deaths_female_1936 "Female deaths per 1000 inhab. (1936)"
label variable deaths_male_1937 "Male deaths per 1000 inhab. (1937)"
label variable deaths_female_1937 "Female deaths per 1000 inhab. (1937)"
label variable deaths_male_1938 "Male deaths per 1000 inhab. (1938)"
label variable deaths_female_1938 "Female deaths per 1000 inhab. (1938)"
label variable deaths_male_1939 "Male deaths per 1000 inhab. (1939)"
label variable deaths_female_1939 "Female deaths per 1000 inhab. (1939)"

label variable deaths_total_1936 "Total deaths per 1000 inhab. (1936)"
label variable deaths_total_1937 "Total deaths per 1000 inhab. (1937)"
label variable deaths_total_1938 "Total deaths per 1000 inhab. (1938)"
label variable deaths_total_1939 "Total deaths per 1000 inhab. (1939)"

label variable deaths_male_cwar "Male deaths per 1000 inhab. (1936-39)"
label variable deaths_female_cwar "Female deaths per 1000 inhab. (1936-39)"

**# Per capita 1000 values anuarios estadisticos 1930s
foreach v of varlist sch_pop_male-lay_total1930 {
	replace `v'= (`v'/pop_1930)*1000
}

**# Per capita 1000 values anuarios estadisticos 1940s
* Excluded: cost of living index
foreach v of varlist  nat_school_total42 teachersprimary_total42 enrolled_students42 library_vol42 morbidity_q1_43{
	replace `v'= (`v'/pop_1940)*1000
}


label var sch_pop_male1933 "Male School. pop per 1000 inhab."
label var sch_pop_female1933 "Fem. School. pop per 1000 inhab."
label var stud_enroll_male1933 "Male enroll stud per 1000 inhab."
label var stud_enroll_female1933 "Fem. enroll stud per 1000 inhab."
label var  avg_attend_male1933 "Male avg attend per 1000 inhab."
label var avg_attend_female1933 "Fem. avg attend per 1000 inhab."
label var relig_com_male1930 "Male relig com per 1000 inhab."
label var relig_com_female1930 "Fem. relig com per 1000 inhab."
label var professed_male1930 "Male Professed per 1000 inhab."
label var novice_male1930 "Male Novices per 1000 inhab."
label var lay_brother1930 "Lay brother per 1000 inhab."
label var relig_com_female1930 "Fem. relig com per 1000 inhab."
label var professed_female1930 "Fem. professed per 1000 inhab."
label var novice_female1930 "Fem. novices per 1000 inhab."
label var lay_sister1930 "Lay sister per 1000 inhab."
label var sch_pop_total1933 "Total school pop per 1000 inhab."
label var stud_enroll_total1933 "Total enroll stud per 1000 inhab."
label var avg_attend_total1933 "Total avg attend per 1000 inhab."
label var relig_com_total1930 "Total relig com per 1000 inhab."
label var professed_total1930 "Total Professed per 1000 inhab."
label var novice_total1930 "Total novices per 1000 inhab."
label var lay_total1930 "Total lay per 1000 inhab."

label var share_republicanos1931 "Republican sh."
label var share_socialistas1931 "Socialist sh."
label var share_monarquicos1931 "Monarchic sh."
label var share_comunistas "Communists sh."

*******************************
**# 4. Population data 1951-1960. Creates Panel 1930-1985
*******************************
gen id_geo =_n
expand  56
sort id_geo
by id_geo : gen year = 1930 + _n -1

merge 1:m codprov province municip type year using "$Data\population\poblacion_1950s.dta" // Population data 1954-1960
rename pop_ pop_MNP


drop if _merge == 2 // municipalities for which we dont have 1940 census age data. BALANCED PANEL

drop id_* _merge
order year codprov type province municip codmun

gen pop_census = pop_1940 if year ==1940
replace pop_census = pop_1930 if year ==1930
replace pop_census = pop_1950 if year ==1950
replace pop_census = pop_1960 if year ==1960
replace pop_census = pop_1970 if year ==1970
label variable pop_census "Population census"
*******************************
**# 5. MNP data (abortion, births, etc) Period: 1971-1985
*******************************
merge 1:m codprov type year using "$Data\MNP\anuarios_estadisticos_from1954\MNP_1971_1985\MNP_1971_1985_clean.dta"
drop _merge

*******************************
**# 5. MNP data (abortion, births, etc) Period: 1930-1970 includes population data 1930-1954
*******************************
rename municip geo_name

*merge 1:m codprov geo_name type year using "$Data\MNP\NF\dta\MNP_1930_1953_clean_v2.dta"
merge 1:m codprov geo_name type year using "$Data\MNP\NF\output\MNP_1930_1970_clean_v2.dta"
drop _merge

replace total_wedding = total_wedding_post1970 if year>1970
drop total_wedding_post1970

replace pop_MNP = population if pop_MNP ==.
label var pop_MNP "Population July 1"
drop population

order codprov codmun province geo_name
sort province 

**# Compute alive birth for 1930/31 as alumbramientos=nacidos vivos+abortos
replace alive_birth = total_birth-total_abortion if missing(alive_birth)
** Add total birth from 1971 to 1985 
replace alive_birth = total_birth if year>1970

gen pop_1936_MNP = pop_MNP if year == 1936
bysort codprov type (pop_1936_MNP): replace pop_1936_MNP = pop_1936_MNP[1] if missing(pop_1936_MNP) //geo_name type

gen pop_1935_MNP = pop_MNP if year == 1935
bysort codprov type (pop_1935_MNP): replace pop_1935_MNP = pop_1935_MNP[1] if missing(pop_1935_MNP)

**# Share over total population for MNP data. 	
order codprov codmun province geo_name type  

/* Abortions / births
foreach x of varlist male_abortion female_abortion total_abortion{
bysort id: gen sh_b_`x' = ((`x'/alive_birth)/ pop_ipo)*1000
*label variable sh_`x' "`x' over population"
}

 
foreach x of varlist total_birth -wedding_widows {
bysort codprov: gen sh_`x' = (`x'/ pop_ipo)*1000
label variable sh_`x' "`x' over population"
}

gen pop_1936 = pop_ipo if year ==1936
bysort id (pop_1936): replace pop_1936 = pop_1936[1] if missing(pop_1936)
gen teachers_pc = (teachers/pop_1936)*1000
*/
 
* Alternative definition of treated population: pop aged 5-24 
gen popshare_agegroup23_1940 = popshare_agegroup2_1940 +popshare_agegroup3_1940 


*******************************
**# Presupuestos
*******************************
merge 1:1 codprov type year using "$Data\anuarios_estadisticos\finanzas\presupuestos\presupuestos.dta"
drop _merge

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
**# Order and clean data
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
order province codprov codmun year geo_name type pop_census pop_1940 pop_1930  pop_* popshare*
sort codprov codmun year geo_name

* Teachers, and not teachers_pc
gen teachers_missing = 1 if missing(teachers)
replace teachers_missing=0 if missing(teachers_missing)

gen post=year>1945
gen duce=sh_area_front>50 & sh_area_front!=.

gen teachers_pc=teachers/pop_1930*10000

label variable codprov "Province code"
label variable codmun "Municipality code"
label variable pop_census "Population"
label variable teachers_pc "Teachers"
label variable teachers_male "Male purged teachers"
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
**# Regional codes (Comunidad Autonoma)
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
gen codauto = 1 if codprov ==4|codprov==11|codprov==14|codprov==18|codprov==21|codprov==23|codprov==29|codprov==41 // Andalucia
replace codauto = 2 if codprov ==22|codprov==44|codprov==50 // Aragon
replace codauto = 3 if codprov ==33 // Asturias
replace codauto = 4 if codprov ==7 // Baleares
replace codauto = 5 if codprov ==35|codprov==38 // Canarias
replace codauto = 6 if codprov ==39 // Cantabria
replace codauto = 7 if codprov ==5|codprov==9|codprov==24|codprov==34|codprov==37|codprov==40|codprov==42|codprov==47|codprov==49 //CyL
replace codauto = 8 if codprov ==2|codprov==13|codprov==16|codprov==19|codprov==45 //CLM
replace codauto = 9 if codprov ==8|codprov==17|codprov==25|codprov==43 //Cataluna
replace codauto = 10 if codprov ==3|codprov==12|codprov==46 //CValenciana
replace codauto = 11 if codprov ==6|codprov== 10 //Extremadura
replace codauto = 12 if codprov ==15|codprov==27|codprov==32|codprov==36 //Galicia
replace codauto = 13 if codprov ==28 // Madrid
replace codauto = 14 if codprov ==30 // Murcia
replace codauto = 15 if codprov ==31 // Navarra
replace codauto = 16 if codprov ==1|codprov==48|codprov==20 //PV
replace codauto = 17 if codprov ==26 //LaRioja

egen idregion = group(codauto)
format province %15s
order year province codprov codmun codauto  geo_name type pop_census pop_MNP pop_1930 pop_1940  pop_1950 pop_1960 pop_1970  popshare*
sort codprov codmun year geo_name
drop if alive_birth<0 // 1 obs check it
*gen flag4=(alive_birth/(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940))*1000


label var popsharemen_agegroup3_1940 "Pop sh. men g.3 (1940)"
label var popsharemen_agegroup4_1940 "Pop sh. men g.4 (1940)"
label var popsharemen_agegroup3_1930 "Pop sh. men g.3 (1930)"
label var popsharemen_agegroup4_1930 "Pop sh. men g.4 (1930)"

**# Dummy variables Above median, percentiles.
* 1. Teachers
sum teachers_pc, detail
gen median_tea=teachers_pc>r(p50) & teachers_pc!=.
gen p75_tea=teachers_pc>r(p75) & teachers_pc!=.

* 2. Female population
gen pop_w=popsharewomen_agegroup1_1940+popsharewomen_agegroup2_1940
sum pop_w, detail

gen median_popw=pop_w>r(p50) & pop_w!=.
gen p75_popw=pop_w>r(p75) & pop_w!=. 
tab p75_popw
* 3. Male population
gen pop_m=popsharemen_agegroup1_1940+popsharemen_agegroup2_1940
sum pop_m, detail
gen median_popm=pop_m>r(p50) & pop_m!=.
gen p75_popm=pop_m>r(p75) & pop_m!=.


egen id = group(codprov geo_name)

save "$Output_data/dataset.dta", replace
keep if year==1940
twoway (scatter pop_w deaths_male_1937 ) (lfit pop_w deaths_male_1937),  xtitle("Male deaths (1937)") ytitle("Female pop share") legend(position(6) cols(2))
**************************************************
*	*	*	*	*	*	*	*	*	*	*	*	*
**# Create dataset for CIS-individual analysis
**************************************************
use "$Output_data/dataset.dta", clear

gen popsharewomen_agegroup1=popsharewomen_agegroup1_1940+popsharewomen_agegroup2_1940
gen popsharewomen_agegroup2=popsharewomen_agegroup3_1940+popsharewomen_agegroup4_1940+popsharewomen_agegroup5_1940

sum popsharewomen_agegroup1,d
gen median_popw1=popsharewomen_agegroup1>r(p50) & popsharewomen_agegroup1!=.
sum popsharewomen_agegroup2,d
gen median_popw2=popsharewomen_agegroup2>r(p50) & popsharewomen_agegroup2!=.

* Male
gen popsharemen_agegroup1=popsharemen_agegroup1_1940+popsharemen_agegroup2_1940
gen popsharemen_agegroup2=popsharemen_agegroup3_1940+popsharemen_agegroup4_1940+popsharemen_agegroup5_1940

sum popsharemen_agegroup1,d
gen median_popm1=popsharemen_agegroup1>r(p50) & popsharemen_agegroup1!=.
sum popsharemen_agegroup2,d
gen median_popm2=popsharemen_agegroup2>r(p50) & popsharemen_agegroup2!=.

* Dependent variables
gen flag4=(alive_birth/(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940))*1000
gen flag6=(total_wedding/(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940))*1000
/*
rename median_tea m_tea
rename median_popw m_popw
*collapse flag4, by(year m_tea m_popw)

*twoway (line flag4 year if m_popw==0 & m_tea==0) (line flag4 year if m_popw==1 & m_tea==0) (line flag4 year if m_popw==0 & m_tea==1) (line flag4 year if m_popw==1 & m_tea==1), graphregion(color(white)) legend(order(1 "No teachers/small group" 2 "No teachers/big group" 3 "Teachers/small group" 4 "Teachers/big group")  forces symx(vsmall) size(vsmall)) ytitle("Alive births per 1,000 inh.", s(small)) xtitle("") title("", s(small) c(black)) ylab(, labs(vsmall)) xlab(1930(5)1985, labs(vsmall))
*/

*keep codprov type
keep  codprov type pop_1930 pop_1940 pop_1950 pop_1960 pop_1970 popshare* pop_* teachers id median_tea  
drop pop_census pop_MNP
duplicates drop
*drop if type =="municipality"
save "$Output_data/dataset_forcis.dta", replace

use "$Output_data/dataset_forcis.dta", clear
