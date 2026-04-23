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

***************************************************
**# ALL 
***************************************************
** 1 regression
	forvalues i=1(1)1 {
* Mean
sum catholic 
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

reghdfe pro_abort_illbaby interaction  1.treated##c.sum`i'##c.teachers_pc 1.treated##c.sum2`i'##c.teachers_pc, a(i.id i.year_birth i.age i.female) cluster(id) 
esttab, beta not
est sto beta_catholic
outreg2 using $Results\channels\continuous\table_cis`i'_1, dec(3)  label nonotes addstat(Mean of depvar, `mean_depvar') addtext( Mun. FE, YES, Cohort, YES)  ct("`tit'") tex(frag) keep(interaction) nocons replace 
	
}

drop interaction interaction2 sum* post_* 
	
** Rest of regressions
foreach x of varlist catholic2 -stab_wifework control_natal_woman-import_work2 shareparent_religion-happ_kids{ // 
	forvalues i=1(1)1 {
sum `x'  
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

reghdfe `x' interaction  1.treated##c.sum`i'##c.teachers_pc 1.treated##c.sum2`i'##c.teachers_pc, a(i.id i.year_birth i.age i.female) cluster(id) 

outreg2 using $Results\channels\continuous\table_cis`i'_1, dec(3)  label nonotes addstat(Mean of depvar, `mean_depvar') addtext( Mun. FE, YES, Cohort, YES)  ct("`tit'") tex(frag) keep(interaction ) nocons 
	}
	drop interaction interaction2 sum* post_* 
	}
	 

	