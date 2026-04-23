use  "$Output_data/dataset.dta", clear
 
global dir "C:\Users\laxge\Dropbox\Results\" // portatil

preserve
drop if popshare_agegroup1_1930==.
drop if teachers_pc==.
sum popshare_agegroup1_1930, detail
local pop_f=r(p50)
sum teachers_pc, detail
local te_f=r(p50)

gen d_pop=popshare_agegroup1_1930>`pop_f'
gen d_te=teachers_pc>`te_f'
gen interaction=d_te*d_pop
gen interaction2=popshare_agegroup1_1930*teachers_pc

foreach x of varlist sh_alive_birth /*sh_alive_birth sh_male_abortion- sh_wedding_widows*/ {

reghdfe `x'  1.post##c.popshare_agegroup1_1930##c.teachers_pc , a(i.id i.year#i.codauto ) cluster(id)
*outreg2 using ${dir}table_diffdisc_lag, dec(3)  label nonotes addtext(Poly., 2nd, Specification, Regions, Within R-squared, `withinr', Bootstrap, `p', Mun. FE, YES, Year FE, YES,  Base value 2006, `tot')  ct("Inf.") tex(frag) keep(interaction)
*egen idprovinceyear= group(codprov year)
*
reghdfe `x' b1936.year##c.popshare_agegroup1_1930##c.teachers_pc, a(i.id i.year#i.codauto) cluster(id)

coefplot ,  keep(*.year#c.popshare_agegroup1_1930#c.teachers_pc) vertical base omitted  yline(0, lc(red) lpattern(dash)) xline(7, lcolor(blue) lpattern(dash)) ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(c(4) size(vsmall))  graphregion(color(white)) msize(vsmall) levels(99 95 90) title("", s(small) c(black)) ytitle("Point estimates", s(vsmall)) scheme(s2mono) xtitle("") xlabel(, angle(45) labs(vsmall)) legend(off)   ///
coeflabels( ///
1930.year#c.popshare_agegroup1_1930#c.teachers_pc= "1930" ///
1931.year#c.popshare_agegroup1_1930#c.teachers_pc= "1931" ///
1932.year#c.popshare_agegroup1_1930#c.teachers_pc= "1932" ///
1933.year#c.popshare_agegroup1_1930#c.teachers_pc= "1933" ///
1934.year#c.popshare_agegroup1_1930#c.teachers_pc= "1934" ///
1935.year#c.popshare_agegroup1_1930#c.teachers_pc= "1935" ///
1936.year#c.popshare_agegroup1_1930#c.teachers_pc= "1936" ///
1937.year#c.popshare_agegroup1_1930#c.teachers_pc= "1937" ///
1938.year#c.popshare_agegroup1_1930#c.teachers_pc= "1938" ///
1939.year#c.popshare_agegroup1_1930#c.teachers_pc= "1939" ///
1940.year#c.popshare_agegroup1_1930#c.teachers_pc= "1940" ///
1941.year#c.popshare_agegroup1_1930#c.teachers_pc= "1941" ///
1942.year#c.popshare_agegroup1_1930#c.teachers_pc= "1942" ///
1943.year#c.popshare_agegroup1_1930#c.teachers_pc= "1943" ///
1944.year#c.popshare_agegroup1_1930#c.teachers_pc= "1944" ///
1945.year#c.popshare_agegroup1_1930#c.teachers_pc= "1945" ///
1946.year#c.popshare_agegroup1_1930#c.teachers_pc= "1946" ///
1947.year#c.popshare_agegroup1_1930#c.teachers_pc= "1947" ///
1948.year#c.popshare_agegroup1_1930#c.teachers_pc= "1948" ///
1949.year#c.popshare_agegroup1_1930#c.teachers_pc= "1949" ///
1950.year#c.popshare_agegroup1_1930#c.teachers_pc= "1950" ///
1951.year#c.popshare_agegroup1_1930#c.teachers_pc= "1951" ///
1952.year#c.popshare_agegroup1_1930#c.teachers_pc= "1952" ///
1953.year#c.popshare_agegroup1_1930#c.teachers_pc= "1953" ///
1954.year#c.popshare_agegroup1_1930#c.teachers_pc= "1954" ///
1955.year#c.popshare_agegroup1_1930#c.teachers_pc= "1955" ///
1956.year#c.popshare_agegroup1_1930#c.teachers_pc= "1956" ///
1957.year#c.popshare_agegroup1_1930#c.teachers_pc= "1957" ///
1958.year#c.popshare_agegroup1_1930#c.teachers_pc= "1958" ///
1959.year#c.popshare_agegroup1_1930#c.teachers_pc= "1959" ///
1960.year#c.popshare_agegroup1_1930#c.teachers_pc= "1960" ///
1961.year#c.popshare_agegroup1_1930#c.teachers_pc= "1961" ///
1962.year#c.popshare_agegroup1_1930#c.teachers_pc= "1962" ///
1963.year#c.popshare_agegroup1_1930#c.teachers_pc= "1963" ///
1964.year#c.popshare_agegroup1_1930#c.teachers_pc= "1964" ///
1965.year#c.popshare_agegroup1_1930#c.teachers_pc= "1965" ///
1966.year#c.popshare_agegroup1_1930#c.teachers_pc= "1966" ///
1967.year#c.popshare_agegroup1_1930#c.teachers_pc= "1967" ///
1968.year#c.popshare_agegroup1_1930#c.teachers_pc= "1968" ///
1969.year#c.popshare_agegroup1_1930#c.teachers_pc= "1969" ///
1970.year#c.popshare_agegroup1_1930#c.teachers_pc= "1970" ///
) ///

*graph export $Results\graph_`x'.png,replace
}


 