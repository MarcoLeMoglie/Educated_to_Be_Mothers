use "$Data\CIS\_data_cis\barometros.dta", clear
egen id_type = group(type)
*gen duce=sh_area_front>50 & sh_area_front!=.
tab year_birth
*drop if year_birth>=1960 | year_birth<1920 // keep 1920-1959
drop if year_birth>=1950 | year_birth<1925 // keep 1925-1949
*drop if year_birth>=1950 | year_birth<1930 // keep 1930-1949
tab year_birth
tab ESTU


gen teachers_pc=teachers/pop_1930*10000
gen treated = 1 if year_birth >=1940
replace treated = 0 if missing(treated)

* Women
gen popsharewomen_agegroup1=popsharewomen_agegroup1_1940+popsharewomen_agegroup2_1940 // T
gen popsharewomen_agegroup2=popsharewomen_agegroup3_1940+popsharewomen_agegroup4_1940+popsharewomen_agegroup5_1940 // C

* Men
gen popsharemen_agegroup1=popsharemen_agegroup1_1940+popsharemen_agegroup2_1940
gen popsharemen_agegroup2=popsharemen_agegroup3_1940+popsharemen_agegroup4_1940+popsharemen_agegroup5_1940


foreach x of varlist catholic catholic2 right right_ideology  sex_education* pro_abort*{
	forvalues i=1(1)1 {
	
drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
gen sum`i'=popsharewomen_agegroup`i' //women
gen sum2`i'=popsharemen_agegroup`i' //men

gen interaction=treated*sum`i'*teachers_pc
gen interaction2=treated*sum2`i'*teachers_pc

label var interaction "Treat (W) X Post 1945"
label var interaction2 "Treat (M) X Post 1945"


reghdfe `x'  interaction interaction2 1.treated##c.sum`i'##c.teachers_pc 1.treated##c.sum2`i'##c.teachers_pc female illiterate age, a(i.codprov i.year_birth i.id_type) cluster(id)  
est sto est_`x'`i'
	mat fstat = e(N_clust)	
	estadd ysumm
	drop interaction interaction2 sum*
}
}

*reghdfe `x' sum`i' sum2`i' teachers_pc interaction interaction2  female age at_leastprimary, a(i.codprov i.year_birth ) cluster(id)  

*reghdfe `x'  interaction interaction2 1.post##c.sum`i'##c.teachers_pc 1.post##c.sum2`i'##c.teachers_pc, a(i.id i.year ) cluster(id)
** Group 1 
estfe est_catholic1 est_catholic21 est_right1 est_right_ideology1 est_sex_education11 est_sex_education21 est_pro_abort_mumthreat1 est_pro_abort_mumdanger1 est_pro_abort_illbaby1 est_pro_abort_rape1 est_pro_abort_decisionmum1 est_pro_abort_eco1, labels(year_birth "Cohort FE" codprov "Prov. FE")
	
	* Save table  
	esttab est_catholic1 est_catholic21 est_right1 est_right_ideology1 est_sex_education11 est_sex_education21 est_pro_abort_mumthreat1 est_pro_abort_mumdanger1 est_pro_abort_illbaby1 est_pro_abort_rape1 est_pro_abort_decisionmum1 est_pro_abort_eco1 using "$Results\channels\table_cis_1.tex",  stats(N N_clust ymean , fmt(%9.0fc %8.0f %8.2f %8.1f) label("Observations" "N. Clusters" "Mean of Dep. Variable" )) keep(interaction interaction2)	replace  label nobaselevels interaction(" $\times$ ") style(tex)  se cells(b (star fmt(%10.3f)) se(par fmt(%10.3f)))  starlevels(* 0.10 ** 0.05 *** 0.01) indicate(`r(indicate_fe)' )  mgroups("Religion" "Political ideology" "Sex. education" "Pro abortion", pattern(1 0 1 0 1 0 1 0 ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))   mtitle("Catholic" "Catholic" "Right" "Right 2" "Sex. education" "Sex. education 2" "Threat mum" "Mum's life danger" "Illness baby" "Rape" "Mum's decision" "Ec. conditions")  collabels(none) 


** Group 2
estfe est_catholic2 est_catholic22 est_right2 est_right_ideology2 est_sex_education12 est_sex_education22 est_pro_abort_mumthreat2 est_pro_abort_mumdanger2 est_pro_abort_illbaby2 est_pro_abort_rape2 est_pro_abort_decisionmum2 est_pro_abort_eco2, labels(year_birth "Cohort FE" codprov "Prov. FE")
	
	* Save table  
	esttab est_catholic2 est_catholic22 est_right2 est_right_ideology2 est_sex_education12 est_sex_education22 est_pro_abort_mumthreat2 est_pro_abort_mumdanger2 est_pro_abort_illbaby2 est_pro_abort_rape2 est_pro_abort_decisionmum2 est_pro_abort_eco2 using "$Results\channels\table_cis_2.tex",  stats(N N_clust ymean , fmt(%9.0fc %8.0f %8.2f %8.1f) label("Observations" "N. Clusters" "Mean of Dep. Variable" )) keep(interaction interaction2)	replace  label nobaselevels interaction(" $\times$ ") style(tex)  se cells(b (star fmt(%10.3f)) se(par fmt(%10.3f)))  starlevels(* 0.10 ** 0.05 *** 0.01) indicate(`r(indicate_fe)' )  mgroups("Religion" "Political ideology" "Sex. education" "Pro abortion", pattern(1 0 1 0 1 0 1 0 ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))   mtitle("Catholic" "Catholic" "Right" "Right 2" "Sex. education" "Sex. education 2" "Threat mum" "Mum's life danger" "Illness baby" "Rape" "Mum's decision" "Ec. conditions")  collabels(none) 

****************************************
* Previous placebo is not super clear
* Do Placebo: 1920 vs 1930?
**************************************** 