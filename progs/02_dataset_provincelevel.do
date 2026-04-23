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
use "$Data\census\census_1940_PROVINCElevel.dta", clear

*******************************
**# 1.2 Census 1950 
*******************************
merge 1:1 codprov using  "$Data\census\census_1950_PROVINCElevel.dta"
sort codprov  
drop _merge
*******************************
**# 1.2 Census 1960 
*******************************
merge 1:1 codprov using  "$Data\census\census_1960_PROVINCElevel.dta" 
sort codprov  
drop _merge //not matched: malaga, burgos and badajoz bc there are mistakes in the data
*******************************
**# 1.3 Census 1970 
*******************************
merge 1:1 codprov using  "$Data\census\census_1970_PROVINCElevel.dta"
sort codprov  
drop _merge
*******************************
**# 1.4 Front of Civil War 
*******************************
merge 1:1 codprov using "$Data\maps_civilwar\complete_map\data_front_complete_PROVINCElevel.dta"
drop _merge
gen logdistance = log(distance+1)
label variable logdistance "Log distance to front"

*******************************
**# 1.5 Anuarios estadisticos I: education 1933
*******************************
merge 1:1 codprov using "$Data\anuarios_estadisticos\education\1932_33\1933_PROVINCElevel.dta"

sort codprov  
drop _merge
*******************************
**# 1.5 Anuarios estadisticos I: com.religiosas 1930
*******************************
merge 1:1 codprov using "$Data\anuarios_estadisticos\comunidades_religiosas\1930_PROVINCElevel.dta"
sort codprov 
drop _merge

*******************************
**# 1.5 Anuarios estadisticos II: education 1942
*******************************
merge 1:1 codprov using "$Data\anuarios_estadisticos\education\1944_45\1944_45_PROVINCElevel.dta"
sort codprov 
drop _merge

*******************************
**# 1.5 Anuarios estadisticos II: culture (1942,43)
*******************************
merge 1:1 codprov using "$Data\anuarios_estadisticos\cultura\1944_45\1944_45_PROVINCElevel.dta"
sort codprov  
drop _merge // unmerged because there is only data for capitals
*******************************
**# 1.6 Pre-treatment voting I: 1931 elections
*******************************
merge 1:1 codprov using "$Data\prewar_elections\province_level\1931\1931_all_concejales_filiacion_PROVINCElevel.dta"
sort codprov 
drop _merge share_no_consta
*******************************
**# 1.6 Pre-treatment voting II: referendum auscultacion
*******************************
merge 1:1 codprov using  "$Data\prewar_elections\referendum_1947\unofficial_results\referendum_PROVINCElevel.dta"
sort codprov 
drop _merge  
*******************************
**# 2. Purged Teachers 
*******************************
merge 1:1 codprov using "$Output_data\depuracion\depuracion_province.dta"
 
drop _merge
 
*******************************
**# 3. Census 1930 Important: Lleida is missing 
*******************************
merge 1:1 codprov using  "$Data\census\census_1930_PROVINCElevel.dta"
sort codprov  
drop _merge


**# Per capita 1000 values anuarios estadisticos 1930s
foreach v of varlist sch_pop_male-lay_total1930 {
	replace `v'= (`v'/pop_1930)*1000
}

**# Per capita 1000 values anuarios estadisticos 1940s
* Excluded: cost of living index
foreach v of varlist  nat_school_total42 teachersprimary_total42 enrolled_students42 relig_magaz_newsp43 tot_magaz_newsp43  {
	replace `v'= (`v'/pop_1940)*1000
}


label var sch_pop_male1933 "Male School. pop"
label var sch_pop_female1933 "Fem. School. pop"
label var stud_enroll_male1933 "Male enroll stud"
label var stud_enroll_female1933 "Fem. enroll stud"
label var  avg_attend_male1933 "Male avg attend"
label var avg_attend_female1933 "Fem. avg attend"
label var relig_com_male1930 "Male relig com"
label var relig_com_female1930 "Fem. relig com"
label var professed_male1930 "Male Professed"
label var novice_male1930 "Male Novices"
label var lay_brother1930 "Lay brother"
label var relig_com_female1930 "Fem. relig com"
label var professed_female1930 "Fem. professed"
label var novice_female1930 "Fem. novices"
label var lay_sister1930 "Lay sister"
label var share_republicanos1931 "Republican sh."
label var share_socialistas1931 "Socialist sh."
label var share_monarquicos1931 "Monarchic sh."
label var share_comunistas "Communists sh."
label var sch_pop_total1933 "Total school pop"
label var stud_enroll_total1933 "Total enroll stud"
label var avg_attend_total1933 "Total avg attend"
label var relig_com_total1930 "Total relig com"
label var professed_total1930 "Total Professed"
label var novice_total1930 "Total novices"
label var lay_total1930 "Total lay"

*******************************
**# 4. Population data 1951-1960. Creates Panel 1930-1985
*******************************
gen id_geo =_n
expand  56
sort id_geo
by id_geo : gen year = 1930 + _n -1

merge 1:m codprov province year using "$Data\population\poblacion_1950s_PROVINCElevel.dta" // Population data 1954-1960
rename pop_ pop_MNP


drop id_* _merge
order year codprov province 

gen pop_census = pop_1940 if year ==1940
replace pop_census = pop_1930 if year ==1930
replace pop_census = pop_1950 if year ==1950
replace pop_census = pop_1960 if year ==1960
replace pop_census = pop_1970 if year ==1970
label variable pop_census "Population census"

*******************************
**# 5. MNP data (abortion, births, etc) Period: 1971-1985
*******************************
merge 1:m codprov year using "$Data\MNP\anuarios_estadisticos_from1954\MNP_1971_1985\MNP_1971_1985_clean_PROVINCElevel.dta"
drop _merge

*******************************
**# 5. MNP data (abortion, births, etc) Period: 1930-1970 includes population data 1930-1954
*******************************
merge 1:m codprov year using "$Data\MNP\NF\output\MNP_1930_1970_clean_v2_PROVINCElevel.dta"
drop _merge

replace total_wedding = total_wedding_post1970 if year>1970
drop total_wedding_post1970

replace pop_MNP = population if pop_MNP ==.
label var pop_MNP "Population July 1"
drop population

order codprov province 
sort province 

**# Compute alive birth for 1930/31 as alumbramientos=nacidos vivos+abortos
replace alive_birth = total_birth-total_abortion if missing(alive_birth)
** Add total birth from 1971 to 1985 
replace alive_birth = total_birth if year>1970

gen pop_1936_MNP = pop_MNP if year == 1936

bysort codprov (pop_1936_MNP): replace pop_1936_MNP = pop_1936_MNP[1] if missing(pop_1936_MNP) 

gen pop_1935_MNP = pop_MNP if year == 1935
bysort codprov (pop_1935_MNP): replace pop_1935_MNP = pop_1935_MNP[1] if missing(pop_1935_MNP)
 

**# Share over total population for MNP data. 	
order codprov province  
 
* Alternative definition of treated population: pop aged 5-24 
gen popshare_agegroup23_1940 = popshare_agegroup2_1940 +popshare_agegroup3_1940 

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
**# Order and clean data
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
order province codprov year pop_census pop_1940 pop_1930  pop_* popshare*
sort codprov year 

* Teachers, and not teachers_pc
*gen teachers_missing = 1 if missing(teachers)
*replace teachers_missing=0 if missing(teachers_missing)

gen post=year>1945
gen duce=sh_area_front>50 & sh_area_front!=.

gen teachers_pc=sancionados/pop_1930*10000 //NEW DEFINITION
gen teachers_pdep=sancionados/depurados*100 //NEW DEFINITION

label variable codprov "Province code"
label variable pop_census "Population"
label variable teachers_pc "Teachers"
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
order year province codprov codauto pop_census pop_MNP pop_1930 pop_1940  pop_1950 pop_1960 pop_1970  popshare*
sort codprov  year 
drop if alive_birth<0 // 1 obs check it

label var popsharemen_agegroup3_1940 "Pop sh. men g.3 (1940)"
label var popsharemen_agegroup4_1940 "Pop sh. men g.4 (1940)"
label var popsharemen_agegroup3_1930 "Pop sh. men g.3 (1930)"
label var popsharemen_agegroup4_1930 "Pop sh. men g.4 (1930)"

**# Dummy variables Above median, percentiles.
* 1. Teachers

sum teachers_pdep, detail
gen median_tea=teachers_pdep>r(p50) & teachers_pdep!=.
gen p75_tea=teachers_pdep>r(p75) & teachers_pdep!=.

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
drop type
save "$Output_data/dataset_PROVINCElevel.dta", replace

**************************************************
*	*	*	*	*	*	*	*	*	*	*	*	* 
**************************************************
use "$Output_data/dataset_PROVINCElevel.dta", clear

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
collapse flag4, by(year m_tea m_popw)

twoway (line flag4 year if m_popw==0 & m_tea==0) (line flag4 year if m_popw==1 & m_tea==0) (line flag4 year if m_popw==0 & m_tea==1) (line flag4 year if m_popw==1 & m_tea==1), graphregion(color(white)) legend(order(1 "No teachers/small group" 2 "No teachers/big group" 3 "Teachers/small group" 4 "Teachers/big group")  forces symx(vsmall) size(vsmall)) ytitle("Alive births per 1,000 inh.", s(small)) xtitle("") title("", s(small) c(black)) ylab(, labs(vsmall)) xlab(1930(5)1985, labs(vsmall))
*/

 
keep  codprov  pop_1930 pop_1940 pop_1950 pop_1960 pop_1970 popshare* pop_* teachers* median_tea
drop pop_census pop_MNP
duplicates drop
*drop if type =="municipality"
save "$Output_data/dataset_forcis_provincelevel.dta", replace

use "$Output_data/dataset_forcis_provincelevel.dta", clear
