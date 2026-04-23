
*drop if geo_name == "lleida" // because it is missing in placebo data
/*
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
**# Specification 2: using 1930 census 
* Important: change the variable post in dofile 02_dataset to define post if > 1950
foreach x of varlist sh_alive_birth sh_male_abortion- sh_wedding_widows {
reghdfe `x' popshare_agegroup1_1930 teachers_pc  pop_teachers pop_post teachers_post pop_teach_post, absorb(year id) cluster(id) nocons
est sto est_`x'
estadd ysumm
}
estfe  est_sh_alive_birth est_sh_male_abortion est_sh_female_abortion est_sh_total_abortion est_sh_total_wedding est_sh_wedding_singles est_sh_wedding_widow est_sh_wedding_widower est_sh_wedding_widows, labels(codprov "Province FE" year "Year FE") 

esttab est_sh_alive_birth est_sh_male_abortion est_sh_female_abortion est_sh_total_abortion est_sh_total_wedding est_sh_wedding_singles est_sh_wedding_widow est_sh_wedding_widower est_sh_wedding_widows using "$dir\$Results\table_treated_tr50.tex",  stats(N N_clust ymean, fmt(%9.0fc %9.0fc %9.2fc) label("Observations" "N. Clusters" "Mean of Dep. Variable")) replace label  se cells (b (star fmt(%10.3f)) se(par fmt(%10.3f)))  starlevels(* 0.10 ** 0.05 *** 0.01) indicate(`r(indicate_fe)')   mtitle( "Alive births"  "Male Abortion" "Fem. Abortion" "Abortion" "T. Weddings" "Weddings 1" "Weddings 2" "Weddings 3" "Weddings 4")  collabels(none) order(popshare_agegroup1_1930 teachers_pc   pop_post teachers_post  pop_teachers pop_teach_post) mgroups("Births" "Abortion" "Weddings", pattern(1 1 0 0 1 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) 
est clear
*/
use  "$Output_data/dataset.dta", clear
gen duce=sh_area_front>50 & sh_area_front!=.
*gen duce2=popshare_agegroup1_1930+popshare_ageg1_treated
 reghdfe sh_alive_birth post##c.popshare_agegroup1_1930##c.teachers_pc , a(i.id  i.year#i.duce) cluster(id) 
preserve
*drop if popshare_agegroup1_1930==.
*drop if teachers_pc==.
sum popshare_agegroup1_1930, detail
local pop_f=r(p50)
sum teachers_pc, detail
local te_f=r(p50)

gen d_pop=popshare_agegroup1_1930>`pop_f'
gen d_te=teachers_pc>`te_f'
gen interaction=d_te*d_pop
gen interaction2=popshare_agegroup1_1930*teachers_pc
 

foreach x of varlist sh_alive_birth /*sh_male_abortion- sh_wedding_widows*/ {

reghdfe `x'  1.post##c.popsharemen_agegroup2_1940##c.teachers_pc , a(i.id i.year#i.duce) cluster(id) 
*outreg2 using ${dir}table_diffdisc_lag, dec(3)  label nonotes addtext(Poly., 2nd, Specification, Regions, Within R-squared, `withinr', Bootstrap, `p', Mun. FE, YES, Year FE, YES,  Base value 2006, `tot')  ct("Inf.") tex(frag) keep(interaction)
*egen idprovinceyear= group(codprov year)
*
reghdfe `x' b1935.year##c.popsharemen_agegroup2_1940##c.teachers_pc if sh_area_front!=., a(i.id i.year#i.duce i.year#c.popsharewomen_agegroup2_1940) cluster(id) //i.year#c.sh_area_front logdistance i.year#c.sh_area_front  i.year#c.conc_camp

coefplot , keep(*.year#c.popsharemen_agegroup2_1940#c.teachers_pc) vertical base omitted  yline(0, lc(red) lp(dash)) xline(6, lcolor(blue) lpattern(dash)) ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) title("", s(small) c(black)) ytitle("Point estimates", s(vsmall)) scheme(s2mono) xlabel(, angle(45) labs(vsmall))   ///
coeflabels( ///
1930.year#c.popsharemen_agegroup2_1940#c.teachers_pc= "1930" ///  
1931.year#c.popsharemen_agegroup2_1940#c.teachers_pc= "1931" ///
1932.year#c.popsharemen_agegroup2_1940#c.teachers_pc= "1932" ///
1933.year#c.popsharemen_agegroup2_1940#c.teachers_pc= "1933" ///
1934.year#c.popsharemen_agegroup2_1940#c.teachers_pc= "1934" ///
1935.year#c.popsharemen_agegroup2_1940#c.teachers_pc= "1935" ///
1936.year#c.popsharemen_agegroup2_1940#c.teachers_pc= "1936" ///
1937.year#c.popsharemen_agegroup2_1940#c.teachers_pc= "1937" ///
1938.year#c.popsharemen_agegroup2_1940#c.teachers_pc= "1938" ///
1939.year#c.popsharemen_agegroup2_1940#c.teachers_pc= "1939" ///
1940.year#c.popsharemen_agegroup2_1940#c.teachers_pc= "1940" ///
1941.year#c.popsharemen_agegroup2_1940#c.teachers_pc= "1941" ///
1942.year#c.popsharemen_agegroup2_1940#c.teachers_pc= "1942" ///
1943.year#c.popsharemen_agegroup2_1940#c.teachers_pc= "1943" ///
1944.year#c.popsharemen_agegroup2_1940#c.teachers_pc= "1944" ///
1945.year#c.popsharemen_agegroup2_1940#c.teachers_pc= "1945" ///
1946.year#c.popsharemen_agegroup2_1940#c.teachers_pc= "1946" ///
1947.year#c.popsharemen_agegroup2_1940#c.teachers_pc= "1947" ///
1948.year#c.popsharemen_agegroup2_1940#c.teachers_pc= "1948" ///
1949.year#c.popsharemen_agegroup2_1940#c.teachers_pc= "1949" ///
1950.year#c.popsharemen_agegroup2_1940#c.teachers_pc= "1950" ///
1951.year#c.popsharemen_agegroup2_1940#c.teachers_pc= "1951" ///
1952.year#c.popsharemen_agegroup2_1940#c.teachers_pc= "1952" ///
1953.year#c.popsharemen_agegroup2_1940#c.teachers_pc= "1953" ///
1954.year#c.popsharemen_agegroup2_1940#c.teachers_pc= "1954" ///
1955.year#c.popsharemen_agegroup2_1940#c.teachers_pc= "1955" ///
1956.year#c.popsharemen_agegroup2_1940#c.teachers_pc= "1956" ///
1957.year#c.popsharemen_agegroup2_1940#c.teachers_pc= "1957" ///
1958.year#c.popsharemen_agegroup2_1940#c.teachers_pc= "1958" ///
1959.year#c.popsharemen_agegroup2_1940#c.teachers_pc= "1959" ///
1960.year#c.popsharemen_agegroup2_1940#c.teachers_pc= "1960" ///
1961.year#c.popsharemen_agegroup2_1940#c.teachers_pc= "1961" ///
1962.year#c.popsharemen_agegroup2_1940#c.teachers_pc= "1962" ///
1963.year#c.popsharemen_agegroup2_1940#c.teachers_pc= "1963" ///
1964.year#c.popsharemen_agegroup2_1940#c.teachers_pc= "1964" ///
1965.year#c.popsharemen_agegroup2_1940#c.teachers_pc= "1965" ///
1966.year#c.popsharemen_agegroup2_1940#c.teachers_pc= "1966" ///
1967.year#c.popsharemen_agegroup2_1940#c.teachers_pc= "1967" ///
1968.year#c.popsharemen_agegroup2_1940#c.teachers_pc= "1968" ///
1969.year#c.popsharemen_agegroup2_1940#c.teachers_pc= "1969" ///
1970.year#c.popsharemen_agegroup2_1940#c.teachers_pc= "1970" ///
) ///

*graph export $Results\graph_`x'_area.png,replace
}

*##

foreach x of varlist sh_alive_birth /*sh_male_abortion- sh_wedding_widows*/ {

reghdfe `x' b1938.year##c.popsharewomen_agegroup2_1940##c.teachers_pc if sh_area_front!=., a(i.id i.year#i.duce i.year#c.popsharemen_agegroup2_1940) cluster(id) //i.year#c.sh_area_front logdistance i.year#c.sh_area_front  i.year#c.conc_camp

coefplot , keep(*.year#c.popsharewomen_agegroup2_1940#c.teachers_pc) vertical base omitted  yline(0, lc(red) lp(dash)) xline(9, lcolor(blue) lpattern(dash)) ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) title("", s(small) c(black)) ytitle("Point estimates", s(vsmall)) scheme(s2mono) xlabel(, angle(45) labs(vsmall))   ///
coeflabels( ///
1930.year#c.popsharewomen_agegroup2_1940#c.teachers_pc= "1930" ///  
1931.year#c.popsharewomen_agegroup2_1940#c.teachers_pc= "1931" ///
1932.year#c.popsharewomen_agegroup2_1940#c.teachers_pc= "1932" ///
1933.year#c.popsharewomen_agegroup2_1940#c.teachers_pc= "1933" ///
1934.year#c.popsharewomen_agegroup2_1940#c.teachers_pc= "1934" ///
1935.year#c.popsharewomen_agegroup2_1940#c.teachers_pc= "1935" ///
1936.year#c.popsharewomen_agegroup2_1940#c.teachers_pc= "1936" ///
1937.year#c.popsharewomen_agegroup2_1940#c.teachers_pc= "1937" ///
1938.year#c.popsharewomen_agegroup2_1940#c.teachers_pc= "1938" ///
1939.year#c.popsharewomen_agegroup2_1940#c.teachers_pc= "1939" ///
1940.year#c.popsharewomen_agegroup2_1940#c.teachers_pc= "1940" ///
1941.year#c.popsharewomen_agegroup2_1940#c.teachers_pc= "1941" ///
1942.year#c.popsharewomen_agegroup2_1940#c.teachers_pc= "1942" ///
1943.year#c.popsharewomen_agegroup2_1940#c.teachers_pc= "1943" ///
1944.year#c.popsharewomen_agegroup2_1940#c.teachers_pc= "1944" ///
1945.year#c.popsharewomen_agegroup2_1940#c.teachers_pc= "1945" ///
1946.year#c.popsharewomen_agegroup2_1940#c.teachers_pc= "1946" ///
1947.year#c.popsharewomen_agegroup2_1940#c.teachers_pc= "1947" ///
1948.year#c.popsharewomen_agegroup2_1940#c.teachers_pc= "1948" ///
1949.year#c.popsharewomen_agegroup2_1940#c.teachers_pc= "1949" ///
1950.year#c.popsharewomen_agegroup2_1940#c.teachers_pc= "1950" ///
1951.year#c.popsharewomen_agegroup2_1940#c.teachers_pc= "1951" ///
1952.year#c.popsharewomen_agegroup2_1940#c.teachers_pc= "1952" ///
1953.year#c.popsharewomen_agegroup2_1940#c.teachers_pc= "1953" ///
1954.year#c.popsharewomen_agegroup2_1940#c.teachers_pc= "1954" ///
1955.year#c.popsharewomen_agegroup2_1940#c.teachers_pc= "1955" ///
1956.year#c.popsharewomen_agegroup2_1940#c.teachers_pc= "1956" ///
1957.year#c.popsharewomen_agegroup2_1940#c.teachers_pc= "1957" ///
1958.year#c.popsharewomen_agegroup2_1940#c.teachers_pc= "1958" ///
1959.year#c.popsharewomen_agegroup2_1940#c.teachers_pc= "1959" ///
1960.year#c.popsharewomen_agegroup2_1940#c.teachers_pc= "1960" ///
1961.year#c.popsharewomen_agegroup2_1940#c.teachers_pc= "1961" ///
1962.year#c.popsharewomen_agegroup2_1940#c.teachers_pc= "1962" ///
1963.year#c.popsharewomen_agegroup2_1940#c.teachers_pc= "1963" ///
1964.year#c.popsharewomen_agegroup2_1940#c.teachers_pc= "1964" ///
1965.year#c.popsharewomen_agegroup2_1940#c.teachers_pc= "1965" ///
1966.year#c.popsharewomen_agegroup2_1940#c.teachers_pc= "1966" ///
1967.year#c.popsharewomen_agegroup2_1940#c.teachers_pc= "1967" ///
1968.year#c.popsharewomen_agegroup2_1940#c.teachers_pc= "1968" ///
1969.year#c.popsharewomen_agegroup2_1940#c.teachers_pc= "1969" ///
1970.year#c.popsharewomen_agegroup2_1940#c.teachers_pc= "1970" ///
) ///

*graph export $Results\graph_`x'_area.png,replace
}





7
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
use  "$Output_data/dataset.dta", clear
reghdfe sh_alive_birth popshare_agegroup1_1930 teachers_pc  pop_teachers pop_post teachers_post pop_teach_post , absorb(year id  i.year#i.codauto   ) cluster(id) 
* Table
**# Specification 2: using 1930 census 
* Important: change the variable post in dofile 02_dataset to define post if > 1936
foreach x of varlist sh_alive_birth sh_male_abortion- sh_wedding_widows {
reghdfe `x' popshare_agegroup1_1930 teachers_pc  pop_teachers pop_post teachers_post pop_teach_post , absorb(year id  i.year#i.codauto i.year#c.sh_area_front ) cluster(id) 
est sto est_`x'
estadd ysumm
}
estfe  est_sh_alive_birth est_sh_male_abortion est_sh_female_abortion est_sh_total_abortion est_sh_total_wedding est_sh_wedding_singles est_sh_wedding_widow est_sh_wedding_widower est_sh_wedding_widows, labels(codprov "Province FE" year "Year FE" year#codauto "Region-year FE" year#c.sh_area_front "Area sh in Nat. front-year FE") 

esttab est_sh_alive_birth est_sh_male_abortion est_sh_female_abortion est_sh_total_abortion est_sh_total_wedding est_sh_wedding_singles est_sh_wedding_widow est_sh_wedding_widower est_sh_wedding_widows using "$dir\$Results\table_treated_tr.tex",  stats(N N_clust ymean, fmt(%9.0fc %9.0fc %9.2fc) label("Observations" "N. Clusters" "Mean of Dep. Variable")) replace label  se cells (b (star fmt(%10.3f)) se(par fmt(%10.3f)))  starlevels(* 0.10 ** 0.05 *** 0.01) indicate(`r(indicate_fe)')   mtitle( "Alive births"  "Male Abortion" "Fem. Abortion" "Abortion" "T. Marriage" "Marriage 1" "Marriage 2" "Marriage 3" "Marriage 4")  collabels(none) order(  pop_post teachers_post   pop_teach_post) drop(popshare_agegroup1_1930 teachers_pc pop_teachers) mgroups("Births" "Abortion" "Marriage", pattern(1 1 0 0 1 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) 
est clear
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


