
use "$Data\CIS\_data_cis\barometros.dta", clear
egen id_type = group(type)

drop if year_birth<1910
drop if year_birth<1920
drop if year_birth>1969
drop if year_birth ==1973
tab year_birth

tab ESTU

gen teachers_pc=teachers/pop_1930*10000
gen treated = 1 if year_birth >=1940
replace treated = 0 if missing(treated)


***************************************************
**#  Baseline
***************************************************
** 1 regression
	forvalues i=1(1)1 {
* Mean
sum  unemployed   
local mean_depvar = r(mean)

drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
gen sum`i'=popsharewomen_agegroup`i'
gen sum2`i'=popsharemen_agegroup`i' 

*	
gen interaction=treated*sum`i'*teachers_pc
gen interaction2=treated*sum2`i'*teachers_pc

gen post_sum`i'=treated*sum`i'
gen post_sum2`i'=treated*sum2`i'
gen post_teachers=treated*teachers_pc
	
label var interaction "Fem. pop X Teachers X Treat"
label var interaction2 "Male pop X Teachers X Treat"

label var post_sum`i' "Female pop X Treat"
label var post_sum2`i' "Male pop X Treat"
label var post_teachers "Teachers X Treat"

reghdfe unemployed  post_sum`i' post_sum2`i' post_teachers interaction interaction2 1.treated##c.sum`i'##c.teachers_pc 1.treated##c.sum2`i'##c.teachers_pc, a(i.id i.year_birth i.age i.female) cluster(id) 
	esttab, beta not
	est sto est_unemployed
outreg2 using $Results\channels\continuous\table_cis_sig, dec(3)  label nonotes addstat(Mean of depvar, `mean_depvar') addtext( Mun. FE, YES, Cohort, YES)  ct("`tit'") tex(frag) keep( interaction ) nocons replace 
	
}
drop interaction interaction2 sum* post_*   

** Rest of regressions
foreach x of  varlist nkids pro_abort_illbaby pro_art_fert pro_abort_church teachers_extrpolit husb_nothouseworks stab_fidelity stab_kids decision_husb everyb_works free_housework union{ //     
	forvalues i=1(1)1 {
sum  `x'   
local mean_depvar = r(mean)

drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
gen sum`i'=popsharewomen_agegroup`i'
gen sum2`i'=popsharemen_agegroup`i' 
*
 
*	
gen interaction=treated*sum`i'*teachers_pc
gen interaction2=treated*sum2`i'*teachers_pc

gen post_sum`i'=treated*sum`i'
gen post_sum2`i'=treated*sum2`i'
gen post_teachers=treated*teachers_pc
	
label var interaction "Fem. pop X Teachers X Treat"
label var interaction2 "Male pop X Teachers X Treat"

label var post_sum`i' "Female pop X Treat"
label var post_sum2`i' "Male pop X Treat"
label var post_teachers "Teachers X Treat"

reghdfe `x'  post_sum`i' post_sum2`i' post_teachers interaction interaction2 1.treated##c.sum`i'##c.teachers_pc 1.treated##c.sum2`i'##c.teachers_pc, a(i.id i.year_birth i.age i.female) cluster(id)  
	esttab, beta not
	est sto est_`x'
outreg2 using $Results\channels\continuous\table_cis_sig, dec(3)  label nonotes addstat(Mean of depvar, `mean_depvar') addtext( Mun. FE, YES, Cohort, YES)  ct("`tit'") tex(frag) keep(interaction ) nocons append 
	}
	drop interaction interaction2 sum* post_* 
	}
  		
	          
	coefplot (est_unemployed, aseq(unemployed) ///
	\ est_nkids, aseq(nkids) ///
	\ est_pro_abort_illbaby, aseq(pro_abort_illbaby) ///
	\ est_pro_art_fert, aseq(pro_art_fert) ///			
	\ est_pro_abort_church, aseq(pro_abort_church) ///		
	\ est_husb_nothouseworks, aseq(husb_nothouseworks) ///
	\ est_stab_fidelity, aseq(stab_fidelity) ///	
	\ est_stab_kids, aseq(stab_kids) ///
    \ est_decision_husb, aseq(decision_husb)	///
    \ est_everyb_works, aseq(everyb_works)	///
    \ est_union, aseq(union)	///
    \ est_free_housework, aseq(free_housework))	///
	, keep(interaction) xline(0) pstyle(p10) pstyle(p23)  aseq swapnames  graphregion(color(white)) ci(90) /// 
	headings(est_right = "{bf:Politics}" est_relig_educ_any = "{bf:Religious education}" est_pro_abort = "{bf:Abortion}", labcolor(orange))  //legend(off) 
graph export $Results\channels\continuous\gr_channels.png, replace
stop



