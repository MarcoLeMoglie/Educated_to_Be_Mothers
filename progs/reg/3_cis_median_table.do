use "$Data\CIS\_data_cis\barometros.dta", clear
egen id_type = group(type)
*gen duce=sh_area_front>50 & sh_area_front!=.
drop if year_birth<1910
drop if year_birth<1920
drop if year_birth>1969
drop if year_birth ==1973
tab year_birth

tab ESTU


gen teachers_pc=teachers/pop_1930*10000
gen treated = 1 if year_birth >=1940
replace treated = 0 if missing(treated)

* Women
gen popsharewomen_agegroup1=popsharewomen_agegroup1_1940+popsharewomen_agegroup2_1940 // T
gen popsharewomen_agegroup2=popsharewomen_agegroup3_1940+popsharewomen_agegroup4_1940+popsharewomen_agegroup5_1940 // C

sum popsharewomen_agegroup1,d
gen median_popw1=popsharewomen_agegroup1>r(p50) & popsharewomen_agegroup1!=.
sum popsharewomen_agegroup2,d
gen median_popw2=popsharewomen_agegroup2>r(p50) & popsharewomen_agegroup2!=.

* Men
gen popsharemen_agegroup1=popsharemen_agegroup1_1940+popsharemen_agegroup2_1940
gen popsharemen_agegroup2=popsharemen_agegroup3_1940+popsharemen_agegroup4_1940+popsharemen_agegroup5_1940

sum popsharemen_agegroup1,d
gen median_popm1=popsharemen_agegroup1>r(p50) & popsharemen_agegroup1!=.
sum popsharemen_agegroup2,d
gen median_popm2=popsharemen_agegroup2>r(p50) & popsharemen_agegroup2!=.
***************************************************
**# 1 table
***************************************************
** 1 regression
	forvalues i=1(1)1 {
* Mean
sum catholic if median_popw`i' ==0 & median_tea==0
local mean_depvar = r(mean)

drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
gen sum`i'=median_popw`i' //women
gen sum2`i'=median_popm`i' //men

gen interaction=treated*sum`i'*median_tea
gen interaction2=treated*sum2`i'*median_tea

gen post_sum`i'=treated*sum`i'
gen post_sum2`i'=treated*sum2`i'
gen post_teachers=treated*median_tea

label var interaction "Fem. pop X Teachers X Treat"
label var interaction2 "Male pop X Teachers X Treat"

label var post_sum`i' "Female pop X Treat"
label var post_sum2`i' "Male pop X Treat"
label var post_teachers "Teachers X Treat"

reghdfe catholic post_sum`i' post_sum2`i' post_teachers interaction interaction2 1.treated##1.sum`i'##1.median_tea 1.treated##1.sum2`i'##1.median_tea, a(i.id i.year_birth i.age i.female) cluster(id) 
outreg2 using $Results\channels\median\table_cis`i'_1, dec(3)  label nonotes addstat(Mean of depvar, `mean_depvar') addtext( Mun. FE, YES, Cohort, YES)  ct("`tit'") tex(frag) keep(post_sum`i' post_sum2`i' post_teachers interaction interaction2) nocons replace 
	
}
drop interaction interaction2 sum* post_*
	
** Rest of regressions
foreach x of varlist catholic2 right right_ideology live_notmarried divorced_sep sex_education1 sex_education2 relig_educ_any relig_educ_atleast1{ // 
	forvalues i=1(1)1 {
sum `x' if median_popw`i' ==0 & median_tea==0
local mean_depvar = r(mean)
	
drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
gen sum`i'=median_popw`i' //women
gen sum2`i'=median_popm`i' //men

gen interaction=treated*sum`i'*median_tea
gen interaction2=treated*sum2`i'*median_tea

gen post_sum`i'=treated*sum`i'
gen post_sum2`i'=treated*sum2`i'
gen post_teachers=treated*median_tea

label var interaction "Fem. pop X Teachers X Treat"
label var interaction2 "Male pop X Teachers X Treat"

label var post_sum`i' "Female pop X Treat"
label var post_sum2`i' "Male pop X Treat"
label var post_teachers "Teachers X Treat"

reghdfe `x' post_sum`i' post_sum2`i' post_teachers interaction interaction2 1.treated##1.sum`i'##1.median_tea 1.treated##1.sum2`i'##1.median_tea, a(i.id i.year_birth i.age i.female) cluster(id) 
outreg2 using $Results\channels\median\table_cis`i'_1, dec(3)  label nonotes addstat(Mean of depvar, `mean_depvar') addtext( Mun. FE, YES, Cohort, YES)  ct("`tit'") tex(frag) keep(post_sum`i' post_sum2`i' post_teachers interaction interaction2) nocons 
	}
	drop interaction interaction2 sum* post_*
	}
***************************************************
**# 2 table
***************************************************
** 1 regression
	forvalues i=1(1)1 {
* Mean
sum pro_euthanasia if median_popw`i' ==0 & median_tea==0
local mean_depvar = r(mean)

drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
gen sum`i'=median_popw`i' //women
gen sum2`i'=median_popm`i' //men

gen interaction=treated*sum`i'*median_tea
gen interaction2=treated*sum2`i'*median_tea

gen post_sum`i'=treated*sum`i'
gen post_sum2`i'=treated*sum2`i'
gen post_teachers=treated*median_tea

label var interaction "Fem. pop X Teachers X Treat"
label var interaction2 "Male pop X Teachers X Treat"

label var post_sum`i' "Female pop X Treat"
label var post_sum2`i' "Male pop X Treat"
label var post_teachers "Teachers X Treat"

reghdfe pro_euthanasia post_sum`i' post_sum2`i' post_teachers interaction interaction2 1.treated##1.sum`i'##1.median_tea 1.treated##1.sum2`i'##1.median_tea, a(i.id i.year_birth i.age i.female) cluster(id) 
outreg2 using $Results\channels\median\table_cis`i'_2, dec(3)  label nonotes addstat(Mean of depvar, `mean_depvar') addtext( Mun. FE, YES, Cohort, YES)  ct("`tit'") tex(frag) keep(post_sum`i' post_sum2`i' post_teachers interaction interaction2) nocons replace 
	
}
drop interaction interaction2 sum* post_*
	
** Rest of regressions
foreach x of varlist   pro_laweuthanasia pro_art_fert pro_contracep impor_stab_family father_lastword divorce_free teachers_extrpolit students_particip gov_withoutconsent{ // 
	forvalues i=1(1)1 {
sum `x' if median_popw`i' ==0 & median_tea==0
local mean_depvar = r(mean)
	
drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
gen sum`i'=median_popw`i' //women
gen sum2`i'=median_popm`i' //men

gen interaction=treated*sum`i'*median_tea
gen interaction2=treated*sum2`i'*median_tea

gen post_sum`i'=treated*sum`i'
gen post_sum2`i'=treated*sum2`i'
gen post_teachers=treated*median_tea

label var interaction "Fem. pop X Teachers X Treat"
label var interaction2 "Male pop X Teachers X Treat"

label var post_sum`i' "Female pop X Treat"
label var post_sum2`i' "Male pop X Treat"
label var post_teachers "Teachers X Treat"

reghdfe `x' post_sum`i' post_sum2`i' post_teachers interaction interaction2 1.treated##1.sum`i'##1.median_tea 1.treated##1.sum2`i'##1.median_tea, a(i.id i.year_birth i.age i.female) cluster(id) 
outreg2 using $Results\channels\median\table_cis`i'_2, dec(3)  label nonotes addstat(Mean of depvar, `mean_depvar') addtext( Mun. FE, YES, Cohort, YES)  ct("`tit'") tex(frag) keep(post_sum`i' post_sum2`i' post_teachers interaction interaction2) nocons 
	}
	drop interaction interaction2 sum* post_*
	}
***************************************************
**# 3 table
***************************************************
** 1 regression
	forvalues i=1(1)1 {
* Mean
sum pro_abort_mumthreat if median_popw`i' ==0 & median_tea==0
local mean_depvar = r(mean)

drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
gen sum`i'=median_popw`i' //women
gen sum2`i'=median_popm`i' //men

gen interaction=treated*sum`i'*median_tea
gen interaction2=treated*sum2`i'*median_tea

gen post_sum`i'=treated*sum`i'
gen post_sum2`i'=treated*sum2`i'
gen post_teachers=treated*median_tea

label var interaction "Fem. pop X Teachers X Treat"
label var interaction2 "Male pop X Teachers X Treat"

label var post_sum`i' "Female pop X Treat"
label var post_sum2`i' "Male pop X Treat"
label var post_teachers "Teachers X Treat"

reghdfe pro_abort_mumthreat post_sum`i' post_sum2`i' post_teachers interaction interaction2 1.treated##1.sum`i'##1.median_tea 1.treated##1.sum2`i'##1.median_tea, a(i.id i.year_birth i.age i.female) cluster(id) 
outreg2 using $Results\channels\median\table_cis`i'_3, dec(3)  label nonotes addstat(Mean of depvar, `mean_depvar') addtext( Mun. FE, YES, Cohort, YES)  ct("`tit'") tex(frag) keep(post_sum`i' post_sum2`i' post_teachers interaction interaction2) nocons replace 
	
}
drop interaction interaction2 sum* post_*
	
** Rest of regressions
foreach x of varlist  pro_abort_mumdanger pro_abort_illbaby pro_abort_rape pro_abort_decisionmum pro_abort_eco pro_abort pro_law_abort tooprohib_law_abort reduction_illegabort_sp reduction_illegabort_abr reduction_illegabort pro_abort_12w pro_abort_church{ // 
	forvalues i=1(1)1 {
sum `x' if median_popw`i' ==0 & median_tea==0
local mean_depvar = r(mean)
	
drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
gen sum`i'=median_popw`i' //women
gen sum2`i'=median_popm`i' //men

gen interaction=treated*sum`i'*median_tea
gen interaction2=treated*sum2`i'*median_tea

gen post_sum`i'=treated*sum`i'
gen post_sum2`i'=treated*sum2`i'
gen post_teachers=treated*median_tea

label var interaction "Fem. pop X Teachers X Treat"
label var interaction2 "Male pop X Teachers X Treat"

label var post_sum`i' "Female pop X Treat"
label var post_sum2`i' "Male pop X Treat"
label var post_teachers "Teachers X Treat"

reghdfe `x' post_sum`i' post_sum2`i' post_teachers interaction interaction2 1.treated##1.sum`i'##1.median_tea 1.treated##1.sum2`i'##1.median_tea, a(i.id i.year_birth i.age i.female) cluster(id) 
outreg2 using $Results\channels\median\table_cis`i'_3, dec(3)  label nonotes addstat(Mean of depvar, `mean_depvar') addtext( Mun. FE, YES, Cohort, YES)  ct("`tit'") tex(frag) keep(post_sum`i' post_sum2`i' post_teachers interaction interaction2) nocons 
	}
	drop interaction interaction2 sum* post_*
	}	
	
***************************************************
**# 4 table
***************************************************
** 1 regression
	forvalues i=1(1)1 {
* Mean
sum benefit_marr_husb if median_popw`i' ==0 & median_tea==0
local mean_depvar = r(mean)

drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
gen sum`i'=median_popw`i' //women
gen sum2`i'=median_popm`i' //men

gen interaction=treated*sum`i'*median_tea
gen interaction2=treated*sum2`i'*median_tea

gen post_sum`i'=treated*sum`i'
gen post_sum2`i'=treated*sum2`i'
gen post_teachers=treated*median_tea

label var interaction "Fem. pop X Teachers X Treat"
label var interaction2 "Male pop X Teachers X Treat"

label var post_sum`i' "Female pop X Treat"
label var post_sum2`i' "Male pop X Treat"
label var post_teachers "Teachers X Treat"

reghdfe benefit_marr_husb post_sum`i' post_sum2`i' post_teachers interaction interaction2 1.treated##1.sum`i'##1.median_tea 1.treated##1.sum2`i'##1.median_tea, a(i.id i.year_birth i.age i.female) cluster(id) 
outreg2 using $Results\channels\median\table_cis`i'_4, dec(3)  label nonotes addstat(Mean of depvar, `mean_depvar') addtext( Mun. FE, YES, Cohort, YES)    tex(frag) keep(post_sum`i' post_sum2`i' post_teachers interaction interaction2) nocons replace
	
}
drop interaction interaction2 sum* post_*
	
** Rest of regressions
foreach x of varlist   ideal_fam_equal ideal_fam_wifehome husb_nothouseworks husb_lesshouseworks stab_fidelity stab_respect stab_sharehousework stab_kids stab_wifework { // 
	forvalues i=1(1)1 {
sum `x' if median_popw`i' ==0 & median_tea==0
local mean_depvar = r(mean)
	
drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
gen sum`i'=median_popw`i' //women
gen sum2`i'=median_popm`i' //men

gen interaction=treated*sum`i'*median_tea
gen interaction2=treated*sum2`i'*median_tea

gen post_sum`i'=treated*sum`i'
gen post_sum2`i'=treated*sum2`i'
gen post_teachers=treated*median_tea

label var interaction "Fem. pop X Teachers X Treat"
label var interaction2 "Male pop X Teachers X Treat"

label var post_sum`i' "Female pop X Treat"
label var post_sum2`i' "Male pop X Treat"
label var post_teachers "Teachers X Treat"

reghdfe `x' post_sum`i' post_sum2`i' post_teachers interaction interaction2 median_tea 1.treated##1.sum`i'##1.median_tea 1.treated##1.sum2`i'##1.median_tea, a(i.id i.year_birth i.age i.female) cluster(id) 

outreg2 using $Results\channels\median\table_cis`i'_4, dec(3)  label nonotes addstat(Mean of depvar, `mean_depvar') addtext( Mun. FE, YES, Cohort, YES)  ct("`tit'") tex(frag) keep(post_sum`i' post_sum2`i' post_teachers interaction interaction2) nocons 
	}
	drop interaction interaction2 sum* post_*
	}	
 	
***************************************************
**# 5 table
***************************************************
** 1 regression
	forvalues i=1(1)1 {
* Mean
sum money_husband if median_popw`i' ==0 & median_tea==0
local mean_depvar = r(mean)

drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
gen sum`i'=median_popw`i' //women
gen sum2`i'=median_popm`i' //men

gen interaction=treated*sum`i'*median_tea
gen interaction2=treated*sum2`i'*median_tea

gen post_sum`i'=treated*sum`i'
gen post_sum2`i'=treated*sum2`i'
gen post_teachers=treated*median_tea

label var interaction "Fem. pop X Teachers X Treat"
label var interaction2 "Male pop X Teachers X Treat"

label var post_sum`i' "Female pop X Treat"
label var post_sum2`i' "Male pop X Treat"
label var post_teachers "Teachers X Treat"

reghdfe money_husband post_sum`i' post_sum2`i' post_teachers interaction interaction2 1.treated##1.sum`i'##1.median_tea 1.treated##1.sum2`i'##1.median_tea, a(i.id i.year_birth i.age i.female) cluster(id) 
outreg2 using $Results\channels\median\table_cis`i'_5, dec(3)  label nonotes addstat(Mean of depvar, `mean_depvar') addtext( Mun. FE, YES, Cohort, YES)    tex(frag) keep(post_sum`i' post_sum2`i' post_teachers interaction interaction2) nocons replace
	
}
drop interaction interaction2 sum* post_*
	
** Rest of regressions
foreach x of varlist  school_meet_wife school_meet_both absentwork_wife absentwork_both realwoman_kids realman_kids housework_impede decision_husb toomuch_housework import_marry import_freesex import_mother  { // 
	forvalues i=1(1)1 {
sum `x' if median_popw`i' ==0 & median_tea==0
local mean_depvar = r(mean)
	
drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
gen sum`i'=median_popw`i' //women
gen sum2`i'=median_popm`i' //men

gen interaction=treated*sum`i'*median_tea
gen interaction2=treated*sum2`i'*median_tea

gen post_sum`i'=treated*sum`i'
gen post_sum2`i'=treated*sum2`i'
gen post_teachers=treated*median_tea

label var interaction "Fem. pop X Teachers X Treat"
label var interaction2 "Male pop X Teachers X Treat"

label var post_sum`i' "Female pop X Treat"
label var post_sum2`i' "Male pop X Treat"
label var post_teachers "Teachers X Treat"

reghdfe `x' post_sum`i' post_sum2`i'  post_teachers interaction interaction2 1.treated##1.sum`i'##1.median_tea 1.treated##1.sum2`i'##1.median_tea, a(i.id i.year_birth i.age i.female) cluster(id) 

outreg2 using $Results\channels\median\table_cis`i'_5, dec(3)  label nonotes addstat(Mean of depvar, `mean_depvar') addtext( Mun. FE, YES, Cohort, YES)  ct("`tit'") tex(frag) keep(post_sum`i' post_sum2`i' post_teachers interaction interaction2) nocons 
	}
	drop interaction interaction2 sum* post_*
	}	
***************************************************
**# 6 table
***************************************************
** 1 regression
	forvalues i=1(1)1 {
* Mean
sum women_politics if median_popw`i' ==0 & median_tea==0
local mean_depvar = r(mean)

drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
gen sum`i'=median_popw`i' //women
gen sum2`i'=median_popm`i' //men

gen interaction=treated*sum`i'*median_tea
gen interaction2=treated*sum2`i'*median_tea

gen post_sum`i'=treated*sum`i'
gen post_sum2`i'=treated*sum2`i'
gen post_teachers=treated*median_tea

label var interaction "Fem. pop X Teachers X Treat"
label var interaction2 "Male pop X Teachers X Treat"

label var post_sum`i' "Female pop X Treat"
label var post_sum2`i' "Male pop X Treat"
label var post_teachers "Teachers X Treat"

reghdfe women_politics post_sum`i' post_sum2`i' post_teachers interaction interaction2 1.treated##1.sum`i'##1.median_tea 1.treated##1.sum2`i'##1.median_tea, a(i.id i.year_birth i.age i.female) cluster(id) 
outreg2 using $Results\channels\median\table_cis`i'_6, dec(3)  label nonotes addstat(Mean of depvar, `mean_depvar') addtext( Mun. FE, YES, Cohort, YES)    tex(frag) keep(post_sum`i' post_sum2`i' post_teachers interaction interaction2) nocons replace
	
}
drop interaction interaction2 sum* post_*
	
** Rest of regressions
foreach x of varlist  abuse_yellprivate abuse_yellpublic abuse_insult abuse_threat abuse_beatup abuse_women abuse_men abuse_report abuse_report_any  { // 
	forvalues i=1(1)1 {
sum `x' if median_popw`i' ==0 & median_tea==0
local mean_depvar = r(mean)
	
drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
gen sum`i'=median_popw`i' //women
gen sum2`i'=median_popm`i' //men

gen interaction=treated*sum`i'*median_tea
gen interaction2=treated*sum2`i'*median_tea

gen post_sum`i'=treated*sum`i'
gen post_sum2`i'=treated*sum2`i'
gen post_teachers=treated*median_tea

label var interaction "Fem. pop X Teachers X Treat"
label var interaction2 "Male pop X Teachers X Treat"

label var post_sum`i' "Female pop X Treat"
label var post_sum2`i' "Male pop X Treat"
label var post_teachers "Teachers X Treat"

reghdfe `x' post_sum`i' post_sum2`i' post_teachers interaction interaction2 1.treated##1.sum`i'##1.median_tea 1.treated##1.sum2`i'##1.median_tea, a(i.id i.year_birth i.age i.female) cluster(id) 

outreg2 using $Results\channels\median\table_cis`i'_6, dec(3)  label nonotes addstat(Mean of depvar, `mean_depvar') addtext( Mun. FE, YES, Cohort, YES)  ct("`tit'") tex(frag) keep(post_sum`i' post_sum2`i' post_teachers interaction interaction2) nocons 
	}
	drop interaction interaction2 sum* post_*
	}	
***************************************************
**# 7 table
***************************************************
** 1 regression
	forvalues i=1(1)1 {
* Mean
sum control_natal_woman if median_popw`i' ==0 & median_tea==0
local mean_depvar = r(mean)

drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
gen sum`i'=median_popw`i' //women
gen sum2`i'=median_popm`i' //men

gen interaction=treated*sum`i'*median_tea
gen interaction2=treated*sum2`i'*median_tea

gen post_sum`i'=treated*sum`i'
gen post_sum2`i'=treated*sum2`i'
gen post_teachers=treated*median_tea

label var interaction "Fem. pop X Teachers X Treat"
label var interaction2 "Male pop X Teachers X Treat"

label var post_sum`i' "Female pop X Treat"
label var post_sum2`i' "Male pop X Treat"
label var post_teachers "Teachers X Treat"

reghdfe control_natal_woman post_sum`i' post_sum2`i' post_teachers interaction interaction2 1.treated##1.sum`i'##1.median_tea 1.treated##1.sum2`i'##1.median_tea, a(i.id i.year_birth i.age i.female) cluster(id) 
outreg2 using $Results\channels\median\table_cis`i'_7, dec(3)  label nonotes addstat(Mean of depvar, `mean_depvar') addtext( Mun. FE, YES, Cohort, YES)    tex(frag) keep(post_sum`i' post_sum2`i' post_teachers interaction interaction2) nocons replace
	
}
drop interaction interaction2 sum* post_*
	
** Rest of regressions
foreach x of varlist   control_natal_both cleanhouse_woman women_workdouble women_work decision_own everyb_works free_housework independent relation_people import_work women_politics_left women_politics_none union lack_preparation kids{ // 
	forvalues i=1(1)1 {
sum `x' if median_popw`i' ==0 & median_tea==0
local mean_depvar = r(mean)
	
drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
gen sum`i'=median_popw`i' //women
gen sum2`i'=median_popm`i' //men

gen interaction=treated*sum`i'*median_tea
gen interaction2=treated*sum2`i'*median_tea

gen post_sum`i'=treated*sum`i'
gen post_sum2`i'=treated*sum2`i'
gen post_teachers=treated*median_tea

label var interaction "Fem. pop X Teachers X Treat"
label var interaction2 "Male pop X Teachers X Treat"

label var post_sum`i' "Female pop X Treat"
label var post_sum2`i' "Male pop X Treat"
label var post_teachers "Teachers X Treat"

reghdfe `x' post_sum`i' post_sum2`i' post_teachers interaction interaction2 1.treated##1.sum`i'##1.median_tea 1.treated##1.sum2`i'##1.median_tea, a(i.id i.year_birth i.age i.female) cluster(id) 

outreg2 using $Results\channels\median\table_cis`i'_7, dec(3)  label nonotes addstat(Mean of depvar, `mean_depvar') addtext( Mun. FE, YES, Cohort, YES)  ct("`tit'") tex(frag) keep(post_sum`i' post_sum2`i' post_teachers interaction interaction2) nocons 
	}
	drop interaction interaction2 sum* post_*
	}	
	
***************************************************
**# 8 table
***************************************************
** 1 regression
	forvalues i=1(1)1 {
* Mean
sum live_notmarried if median_popw`i' ==0 & median_tea==0
local mean_depvar = r(mean)

drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
gen sum`i'=median_popw`i' //women
gen sum2`i'=median_popm`i' //men

gen interaction=treated*sum`i'*median_tea
gen interaction2=treated*sum2`i'*median_tea

gen post_sum`i'=treated*sum`i'
gen post_sum2`i'=treated*sum2`i'
gen post_teachers=treated*median_tea

label var interaction "Fem. pop X Teachers X Treat"
label var interaction2 "Male pop X Teachers X Treat"

label var post_sum`i' "Female pop X Treat"
label var post_sum2`i' "Male pop X Treat"
label var post_teachers "Teachers X Treat"

reghdfe live_notmarried post_sum`i' post_sum2`i' post_teachers interaction interaction2 1.treated##1.sum`i'##1.median_tea 1.treated##1.sum2`i'##1.median_tea, a(i.id i.year_birth i.age i.female) cluster(id) 
outreg2 using $Results\channels\median\table_cis`i'_8, dec(3)  label nonotes addstat(Mean of depvar, `mean_depvar') addtext( Mun. FE, YES, Cohort, YES)    tex(frag) keep(post_sum`i' post_sum2`i' post_teachers interaction interaction2) nocons replace
	
}
drop interaction interaction2 sum* post_*
	
** Rest of regressions
foreach x of varlist  benefit_marr_both unemployed import_family import_politics import_religion import_work2 import_kids_authority import_kids_relig import_parent_authority import_parent_relig shareparent_religion shareparent_sex shareparent_marriage shareparent_educ shareparent_work sharekids_religion sharekids_sex sharekids_marriage sharekids_educ sharekids_work { // 
	forvalues i=1(1)1 {
sum `x' if median_popw`i' ==0 & median_tea==0
local mean_depvar = r(mean)
	
drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
gen sum`i'=median_popw`i' //women
gen sum2`i'=median_popm`i' //men

gen interaction=treated*sum`i'*median_tea
gen interaction2=treated*sum2`i'*median_tea

gen post_sum`i'=treated*sum`i'
gen post_sum2`i'=treated*sum2`i'
gen post_teachers=treated*median_tea

label var interaction "Fem. pop X Teachers X Treat"
label var interaction2 "Male pop X Teachers X Treat"

label var post_sum`i' "Female pop X Treat"
label var post_sum2`i' "Male pop X Treat"
label var post_teachers "Teachers X Treat"

reghdfe `x' post_sum`i' post_sum2`i' post_teachers interaction interaction2 1.treated##1.sum`i'##1.median_tea 1.treated##1.sum2`i'##1.median_tea, a(i.id i.year_birth i.age i.female) cluster(id) 

outreg2 using $Results\channels\median\table_cis`i'_8, dec(3)  label nonotes addstat(Mean of depvar, `mean_depvar') addtext( Mun. FE, YES, Cohort, YES)  ct("`tit'") tex(frag) keep(post_sum`i' post_sum2`i' post_teachers interaction interaction2) nocons 
	}
	drop interaction interaction2 sum* post_*
	}	
	
		
***************************************************
**# 9 table
***************************************************
** 1 regression
	forvalues i=1(1)1 {
* Mean
sum problem_son_divorces if median_popw`i' ==0 & median_tea==0
local mean_depvar = r(mean)

drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
gen sum`i'=median_popw`i' //women
gen sum2`i'=median_popm`i' //men

gen interaction=treated*sum`i'*median_tea
gen interaction2=treated*sum2`i'*median_tea

gen post_sum`i'=treated*sum`i'
gen post_sum2`i'=treated*sum2`i'
gen post_teachers=treated*median_tea

label var interaction "Fem. pop X Teachers X Treat"
label var interaction2 "Male pop X Teachers X Treat"

label var post_sum`i' "Female pop X Treat"
label var post_sum2`i' "Male pop X Treat"
label var post_teachers "Teachers X Treat"

reghdfe problem_son_divorces post_sum`i' post_sum2`i' post_teachers interaction interaction2 1.treated##1.sum`i'##1.median_tea 1.treated##1.sum2`i'##1.median_tea, a(i.id i.year_birth i.age i.female) cluster(id) 
outreg2 using $Results\channels\median\table_cis`i'_9, dec(3)  label nonotes addstat(Mean of depvar, `mean_depvar') addtext( Mun. FE, YES, Cohort, YES)    tex(frag) keep(post_sum`i' post_sum2`i' post_teachers interaction interaction2) nocons replace
	
}
drop interaction interaction2 sum* post_*
	
** Rest of regressions
foreach x of varlist  problem_son_livetog problem_dau_divorces problem_dau_livetog problem_son_kid problem_dau_kid happ_sharehousework happ_kids happ_ecoindepend prefer_marry_church prefer_marry_civil prefer_live_notmarry extra_money need_econ love_job{ // 
	forvalues i=1(1)1 {
sum `x' if median_popw`i' ==0 & median_tea==0
local mean_depvar = r(mean)
	
drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
gen sum`i'=median_popw`i' //women
gen sum2`i'=median_popm`i' //men

gen interaction=treated*sum`i'*median_tea
gen interaction2=treated*sum2`i'*median_tea

gen post_sum`i'=treated*sum`i'
gen post_sum2`i'=treated*sum2`i'
gen post_teachers=treated*median_tea

label var interaction "Fem. pop X Teachers X Treat"
label var interaction2 "Male pop X Teachers X Treat"

label var post_sum`i' "Female pop X Treat"
label var post_sum2`i' "Male pop X Treat"
label var post_teachers "Teachers X Treat"

reghdfe `x' post_sum`i' post_sum2`i' post_teachers interaction interaction2 1.treated##1.sum`i'##1.median_tea 1.treated##1.sum2`i'##1.median_tea, a(i.id i.year_birth i.age i.female) cluster(id) 

outreg2 using $Results\channels\median\table_cis`i'_9, dec(3)  label nonotes addstat(Mean of depvar, `mean_depvar') addtext( Mun. FE, YES, Cohort, YES)  ct("`tit'") tex(frag) keep(post_sum`i' post_sum2`i' post_teachers interaction interaction2) nocons 
	}
	drop interaction interaction2 sum* post_*
	}	