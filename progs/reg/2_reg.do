use  "$Output_data/dataset.dta", clear
drop if geo_name == "lleida" // because it is missing in placebo data
egen idyear = group(id year)
 
reghdfe sh_total_abortion popshare_ageg2_treated  teachers_pc int_treated_teachers if year>1949, absorb(year) cluster(id) nocons

reghdfe sh_total_abortion popshare_ageg2_placebo  if year>1939 & year <1944, absorb(year) cluster(id) nocons

**********************************************
**# Specification 1
* Actual treatment: using population share of 1940
**********************************************
foreach x of varlist sh_alive_birth sh_male_abortion - sh_wedding_widows {
reghdfe `x' popshare_ageg2_treated teachers_pc int_treated_teachers if year>1949, absorb( year) cluster(id) nocons
est sto est_`x'
estadd ysumm
}

estfe  est_sh_alive_birth est_sh_male_abortion est_sh_female_abortion est_sh_total_abortion est_sh_total_wedding est_sh_wedding_singles est_sh_wedding_widow est_sh_wedding_widower est_sh_wedding_widows, labels(codprov "Province FE" year "Year FE") 

esttab est_sh_alive_birth est_sh_male_abortion est_sh_female_abortion est_sh_total_abortion est_sh_total_wedding est_sh_wedding_singles est_sh_wedding_widow est_sh_wedding_widower est_sh_wedding_widows using "$dir\$Results\table_treated.tex",  stats(N N_clust ymean, fmt(%9.0fc %9.0fc %9.2fc) label("Observations" "N. Clusters" "Mean of Dep. Variable")) 	replace label  se cells (b (star fmt(%10.3f)) se(par fmt(%10.3f)))     starlevels(* 0.10 ** 0.05 *** 0.01) indicate(`r(indicate_fe)')   mtitle( "Alive births"  "Male Abortion" "Fem. Abortion" "Abortion" "T. Weddings" "Weddings 1" "Weddings 2" "Weddings 3" "Weddings 4")  collabels(none)
est clear
**********************************************
**# Specification 1: placebo
* Placebo: using population share of 1930
* if year>1949
* if year>1939 & year <1944
**********************************************
foreach x of varlist sh_alive_birth sh_male_abortion- sh_wedding_widows {
reghdfe `x' popshare_ageg2_placebo teachers_pc int_placebo_teachers if year>1939 & year <1944, absorb(codprov year) cluster(id) nocons
est sto est_`x'
estadd ysumm
}
estfe est_sh_male_abortion est_sh_female_abortion est_sh_total_abortion est_sh_total_wedding est_sh_wedding_singles est_sh_wedding_widow est_sh_wedding_widower est_sh_wedding_widows, labels(codprov "Province FE" year "Year FE") 

esttab  est_sh_alive_birth est_sh_male_abortion est_sh_female_abortion est_sh_total_abortion est_sh_total_wedding est_sh_wedding_singles est_sh_wedding_widow est_sh_wedding_widower est_sh_wedding_widows using "$dir\$Results\table_placebo.tex",  stats(N N_clust ymean, fmt(%9.0fc %9.0fc %9.2fc) label("Observations" "N. Clusters" "Mean of Dep. Variable")) 	replace label  se cells (b (star fmt(%10.3f)) se(par fmt(%10.3f)))     starlevels(* 0.10 ** 0.05 *** 0.01) indicate(`r(indicate_fe)')   mtitle("Alive births"  "Male Abortion" "Fem. Abortion" "Abortion" "T. Weddings" "Weddings 1" "Weddings 2" "Weddings 3" "Weddings 4")  collabels(none)
est clear


**********************************************
**# Specification 1: Age group treated: 5-24
**# Actual treatment: using population share of 1940
**********************************************
foreach x of varlist sh_alive_birth sh_male_abortion - sh_wedding_widows {
reghdfe `x' popshare_ageg23_treated teachers_pc int2_treated_teachers  if year>1949, absorb(codprov year) cluster(id) nocons
est sto est_`x'
estadd ysumm
}

estfe  est_sh_alive_birth est_sh_male_abortion est_sh_female_abortion est_sh_total_abortion est_sh_total_wedding est_sh_wedding_singles est_sh_wedding_widow est_sh_wedding_widower est_sh_wedding_widows, labels(codprov "Province FE" year "Year FE") 

esttab est_sh_alive_birth est_sh_male_abortion est_sh_female_abortion est_sh_total_abortion est_sh_total_wedding est_sh_wedding_singles est_sh_wedding_widow est_sh_wedding_widower est_sh_wedding_widows using "$dir\$Results\table_treated_ageg23.tex",  stats(N N_clust ymean, fmt(%9.0fc %9.0fc %9.2fc) label("Observations" "N. Clusters" "Mean of Dep. Variable")) 	replace label  se cells (b (star fmt(%10.3f)) se(par fmt(%10.3f)))     starlevels(* 0.10 ** 0.05 *** 0.01) indicate(`r(indicate_fe)')   mtitle( "Alive births"  "Male Abortion" "Fem. Abortion" "Abortion" "T. Weddings" "Weddings 1" "Weddings 2" "Weddings 3" "Weddings 4")  collabels(none)
est clear
**********************************************
**# Specification 1
* Age group treated: 5-24
**# Placebo: using population share of 1930
**********************************************
foreach x of varlist sh_alive_birth sh_male_abortion- sh_wedding_widows {
reghdfe `x' popshare_ageg23_placebo teachers_pc int2_placebo_teachers if year>1939 & year <1944, absorb(codprov year) cluster(id) nocons
est sto est_`x'
estadd ysumm
}
estfe est_sh_male_abortion est_sh_female_abortion est_sh_total_abortion est_sh_total_wedding est_sh_wedding_singles est_sh_wedding_widow est_sh_wedding_widower est_sh_wedding_widows, labels(codprov "Province FE" year "Year FE") 

esttab  est_sh_alive_birth est_sh_male_abortion est_sh_female_abortion est_sh_total_abortion est_sh_total_wedding est_sh_wedding_singles est_sh_wedding_widow est_sh_wedding_widower est_sh_wedding_widows using "$dir\$Results\table_placebo_ageg23.tex",  stats(N N_clust ymean, fmt(%9.0fc %9.0fc %9.2fc) label("Observations" "N. Clusters" "Mean of Dep. Variable")) 	replace label  se cells (b (star fmt(%10.3f)) se(par fmt(%10.3f)))     starlevels(* 0.10 ** 0.05 *** 0.01) indicate(`r(indicate_fe)')   mtitle("Alive births"  "Male Abortion" "Fem. Abortion" "Abortion" "T. Weddings" "Weddings 1" "Weddings 2" "Weddings 3" "Weddings 4")  collabels(none)
est clear

**********************************************
* Age group treated: 15-24
**# Treated: using population share of 1940
**********************************************
foreach x of varlist sh_alive_birth sh_male_abortion- sh_wedding_widows {
reghdfe `x' popshare_ageg3_treated teachers_pc intg3_treated_teachers if year>1949, absorb(codprov year) cluster(id) nocons
est sto est_`x'
estadd ysumm
}
estfe est_sh_male_abortion est_sh_female_abortion est_sh_total_abortion est_sh_total_wedding est_sh_wedding_singles est_sh_wedding_widow est_sh_wedding_widower est_sh_wedding_widows, labels(codprov "Province FE" year "Year FE") 

esttab  est_sh_alive_birth est_sh_male_abortion est_sh_female_abortion est_sh_total_abortion est_sh_total_wedding est_sh_wedding_singles est_sh_wedding_widow est_sh_wedding_widower est_sh_wedding_widows using "$dir\$Results\table_treated_ageg3.tex",  stats(N N_clust ymean, fmt(%9.0fc %9.0fc %9.2fc) label("Observations" "N. Clusters" "Mean of Dep. Variable")) 	replace label  se cells (b (star fmt(%10.3f)) se(par fmt(%10.3f)))     starlevels(* 0.10 ** 0.05 *** 0.01) indicate(`r(indicate_fe)')   mtitle("Alive births"  "Male Abortion" "Fem. Abortion" "Abortion" "T. Weddings" "Weddings 1" "Weddings 2" "Weddings 3" "Weddings 4")  collabels(none)
est clear

**********************************************
* Age group treated: 15-24
**# Placebo: using population share of 1930
**********************************************
foreach x of varlist sh_alive_birth sh_male_abortion- sh_wedding_widows {
reghdfe `x' popshare_ageg3_placebo teachers_pc intg3_placebo_teachers  if year>1939 & year <1944, absorb(codprov year) cluster(id) nocons
est sto est_`x'
estadd ysumm
}
estfe est_sh_male_abortion est_sh_female_abortion est_sh_total_abortion est_sh_total_wedding est_sh_wedding_singles est_sh_wedding_widow est_sh_wedding_widower est_sh_wedding_widows, labels(codprov "Province FE" year "Year FE") 

esttab  est_sh_alive_birth est_sh_male_abortion est_sh_female_abortion est_sh_total_abortion est_sh_total_wedding est_sh_wedding_singles est_sh_wedding_widow est_sh_wedding_widower est_sh_wedding_widows using "$dir\$Results\table_placebo_ageg3.tex",  stats(N N_clust ymean, fmt(%9.0fc %9.0fc %9.2fc) label("Observations" "N. Clusters" "Mean of Dep. Variable")) 	replace label  se cells (b (star fmt(%10.3f)) se(par fmt(%10.3f)))     starlevels(* 0.10 ** 0.05 *** 0.01) indicate(`r(indicate_fe)')   mtitle("Alive births"  "Male Abortion" "Fem. Abortion" "Abortion" "T. Weddings" "Weddings 1" "Weddings 2" "Weddings 3" "Weddings 4")  collabels(none)
est clear