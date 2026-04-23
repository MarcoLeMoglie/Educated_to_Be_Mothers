
use "$Data\CIS\_data_cis\barometros.dta", clear
egen id_type = group(type)
*gen duce=sh_area_front>50 & sh_area_front!=.
drop if year_birth<1910
drop if year_birth<1920
drop if year_birth>=1960
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
**#  Baseline
***************************************************
** 1 regression
	forvalues i=1(1)1 {
* Mean
sum right if median_popw`i' ==0 & median_tea==0
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

reghdfe right post_sum`i' post_sum2`i' post_teachers interaction interaction2 1.treated##1.sum`i'##1.median_tea 1.treated##1.sum2`i'##1.median_tea, a(i.id i.year_birth i.age i.female) cluster(id)  
	est sto est_right
outreg2 using $Results\channels\median\table_cis`i'_sig, dec(3)  label nonotes addstat(Mean of depvar, `mean_depvar') addtext( Mun. FE, YES, Cohort, YES)  ct("`tit'") tex(frag) keep(post_sum`i' post_sum2`i' post_teachers interaction interaction2) nocons replace 
	
}
drop interaction interaction2 sum* post_*
	
** Rest of regressions
foreach x of varlist   right_ideology relig_educ_any father_lastword cleanhouse_woman  teachers_extrpolit pro_abort pro_law_abort  realwoman_kids realman_kids decision_husb  everyb_works independent relation_people import_work shareparent_religion sharekids_educ happ_ecoindepend{ //     
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
est sto est_`x'
outreg2 using $Results\channels\median\table_cis`i'_sig, dec(3)  label nonotes addstat(Mean of depvar, `mean_depvar') addtext( Mun. FE, YES, Cohort, YES)  ct("`tit'") tex(frag) keep(post_sum`i' post_sum2`i' post_teachers interaction interaction2) nocons 
	}
	drop interaction interaction2 sum* post_*
	}
 
	coefplot (est_right, aseq(Right-wing (1986,87,88,90,91)) ///
	\ est_right_ideology, aseq(Right-wing ideology (1986,87,88,90,91)) ///
	\ est_relig_educ_any, aseq(Relig. or moral instruct. are essential in any school (1990)) ///
	\ est_teachers_extrpolit, aseq(Extremist politicans should not become teachers (1983)) ///
	\ est_pro_abort, aseq(Pro abort (1986,90,91,92)) ///
	\ est_pro_law_abort, aseq(Pro abortion Law (1986,90,91,92)) ///
	\ est_realwoman_kids, aseq(A real woman should have kids (1990)) ///
	\ est_realman_kids, aseq(A real man should have kids (1990))  ///
	\ est_father_lastword , aseq(Father should have last word (1990))  ///
	\ est_cleanhouse_woman , aseq({it:Live tog or married:} Only the woman cleans house (1990)) ///
	\ est_decision_husb, aseq({it:Women that do not work:} the husband decided it (1990)) ///
	\ est_everyb_works, aseq({it:Women working:}  bc everybody should work (1990)) ///
	\ est_independent, aseq({it:Women working:}  to be econ. independent (1990)) ///
	\ est_relation_people , aseq({it:Women working:} to be in contact with other people (1990)) ///
	\ est_import_work, aseq(Working is very important for women (1990) ) ///
	\ est_shareparent_religion, aseq(Share point of view about religion with parents (1992) ) ///
	\ est_sharekids_educ, aseq(Share point of view about education with kids (1992) ) ///
	\ est_happ_ecoindepend, aseq(Import for couple happiness: econ independent (1992) )) ///
	, keep(interaction) xline(0) pstyle(p10) pstyle(p23)  aseq swapnames  graphregion(color(white)) ci(90) /// 
	headings(est_right = "{bf:Politics}" est_relig_educ_any = "{bf:Religious education}" est_pro_abort = "{bf:Abortion}", labcolor(orange))  //legend(off) 
graph export $Results\channels\median\gr_channels.png, replace
***************************************************
***************************************************
**# Dropping teachers
***************************************************
***************************************************
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
**#  Baseline
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
	est sto est_right
outreg2 using $Results\channels\median\table_cis`i'_sig_v2, dec(3)  label nonotes addstat(Mean of depvar, `mean_depvar') addtext( Mun. FE, YES, Cohort, YES)  ct("`tit'") tex(frag) keep(post_sum`i' post_sum2`i' post_teachers interaction interaction2) nocons replace 
	
}
drop interaction interaction2 sum* post_*
	
** Rest of regressions
foreach x of varlist   right_ideology sex_education1 sex_education2 pro_euthanasia pro_art_fert father_lastword divorce_free pro_abort_illbaby reduction_illegabort ideal_fam_equal ideal_fam_wifehome stab_kids women_politics abuse_threat abuse_women abuse_report 	happ_sharehousework happ_ecoindepend 	extra_money	need_econ { //     
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
est sto est_`x'
outreg2 using $Results\channels\median\table_cis`i'_sig_v2, dec(3)  label nonotes addstat(Mean of depvar, `mean_depvar') addtext( Mun. FE, YES, Cohort, YES)  ct("`tit'") tex(frag) keep(post_sum`i' post_sum2`i' post_teachers interaction interaction2) nocons 
	}
	drop interaction interaction2 sum* post_*
	}
 
	coefplot (est_right_ideology, aseq(Right-wing ideology (1986,87,88,90,91)) ///
	\ est_sex_education1 , aseq(In favor sex. education in bachiller (1986)) ///
	\ est_sex_education2 , aseq(In favor sex. education in EGB (1986)) ///
	\ est_pro_euthanasia , aseq(Pro euthanasia (1992)) ///
	\ est_pro_art_fert , aseq(In favor recomm. church artificial fertil methods (1990)) ///
	\ est_father_lastword , aseq(Father should have last word (1990)) ///
	\ est_divorce_free , aseq(People should be free to divorce (1983)) ///
	\ est_pro_abort_illbaby , aseq(Pro abort if serious illness baby)  ///
	\ est_reduction_illegabort  , aseq(Illegal abortions abroad decreased due to law)  ///
	\ est_ideal_fam_equal , aseq(Ideal family: both work equally 1990) ///
	\ est_ideal_fam_wifehome  , aseq(Ideal family: wife at home 1990) ///
	\ est_stab_kids , aseq(Kids are important for couple stability (1990)) ///
	\ est_women_politics , aseq(Presence of women is important in politics (1990)) ///
	\ est_abuse_threat , aseq(Abuse victim if threat of beat up (1990)) ///
	\ est_abuse_women  , aseq(Women are more abused than men (1990)) ///
	\ est_abuse_report 	, aseq(Women should report abuse (1990)) ///
	\ est_happ_sharehousework , aseq(Sharing housework is important for couple stability (1990)) ///
	\ est_happ_ecoindepend 	, aseq(Import for couple happiness: econ independent (1992)) ///
	\ est_extra_money , aseq({it:Women working:} Extra money (1990)) ///
	\ est_need_econ , aseq({it:Women working:} Econ. needed (1990))) ///
	, keep(interaction) xline(0) pstyle(p10) pstyle(p23)  aseq swapnames  graphregion(color(white)) ci(90) /// 
	headings(est_right = "{bf:Politics}" est_relig_educ_any = "{bf:Religious education}" est_pro_abort = "{bf:Abortion}", labcolor(orange))  //legend(off) 
graph export $Results\channels\median\gr_channels_v2.png, replace
