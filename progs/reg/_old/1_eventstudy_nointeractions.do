use  "$Output_data/dataset.dta", clear

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

reghdfe `x' b1936.year##c.teachers_pc, a(i.id i.year#i.codauto i.year#i.sh_area_front) cluster(id)

coefplot , keep(*.year#c.teachers_pc) vertical base omitted  yline(0, lc(red) lp(dash)) xline(7, lcolor(blue) lpattern(dash)) ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) title("", s(small) c(black)) ytitle("Point estimates", s(vsmall)) scheme(s2mono) xlabel(, angle(45) labs(vsmall)) ///
coeflabels( ///
1930.year#c.teachers_pc= "1930" ///
1931.year#c.teachers_pc= "1931" ///
1932.year#c.teachers_pc= "1932" ///
1933.year#c.teachers_pc= "1933" ///
1934.year#c.teachers_pc= "1934" ///
1935.year#c.teachers_pc= "1935" ///
1936.year#c.teachers_pc= "1936" ///
1937.year#c.teachers_pc= "1937" ///
1938.year#c.teachers_pc= "1938" ///
1939.year#c.teachers_pc= "1939" ///
1940.year#c.teachers_pc= "1940" ///
1941.year#c.teachers_pc= "1941" ///
1942.year#c.teachers_pc= "1942" ///
1943.year#c.teachers_pc= "1943" ///
1944.year#c.teachers_pc= "1944" ///
1945.year#c.teachers_pc= "1945" ///
1946.year#c.teachers_pc= "1946" ///
1947.year#c.teachers_pc= "1947" ///
1948.year#c.teachers_pc= "1948" ///
1949.year#c.teachers_pc= "1949" ///
1950.year#c.teachers_pc= "1950" ///
1951.year#c.teachers_pc= "1951" ///
1952.year#c.teachers_pc= "1952" ///
1953.year#c.teachers_pc= "1953" ///
1954.year#c.teachers_pc= "1954" ///
1955.year#c.teachers_pc= "1955" ///
1956.year#c.teachers_pc= "1956" ///
1957.year#c.teachers_pc= "1957" ///
1958.year#c.teachers_pc= "1958" ///
1959.year#c.teachers_pc= "1959" ///
1960.year#c.teachers_pc= "1960" ///
1961.year#c.teachers_pc= "1961" ///
1962.year#c.teachers_pc= "1962" ///
1963.year#c.teachers_pc= "1963" ///
1964.year#c.teachers_pc= "1964" ///
1965.year#c.teachers_pc= "1965" ///
1966.year#c.teachers_pc= "1966" ///
1967.year#c.teachers_pc= "1967" ///
1968.year#c.teachers_pc= "1968" ///
1969.year#c.teachers_pc= "1969" ///
1970.year#c.teachers_pc= "1970" ///
) ///

graph export $Results\graph_`x'_onlyteachers.png,replace
}
*************************************************
use  "$Output_data/dataset.dta", clear

*drop if popshare_agegroup1_1930==.
*drop if teachers_pc==.

foreach x of varlist sh_alive_birth /*sh_male_abortion- sh_wedding_widows*/ {
*
reghdfe `x' b1936.year##c.popshare_agegroup1_1930, a(i.id i.year#i.codauto i.year#i.sh_area_front) cluster(id) //

coefplot , keep(*.year#c.popshare_agegroup1_1930) vertical base omitted  yline(0, lc(red) lp(dash)) xline(7, lcolor(blue) lpattern(dash)) ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) title("", s(small) c(black)) ytitle("Point estimates", s(vsmall)) scheme(s2mono) xlabel(, angle(45) labs(vsmall)) ///
coeflabels( ///
1930.year#c.popshare_agegroup1_1930= "1930" ///
1931.year#c.popshare_agegroup1_1930= "1931" ///
1932.year#c.popshare_agegroup1_1930= "1932" ///
1933.year#c.popshare_agegroup1_1930= "1933" ///
1934.year#c.popshare_agegroup1_1930= "1934" ///
1935.year#c.popshare_agegroup1_1930= "1935" ///
1936.year#c.popshare_agegroup1_1930= "1936" ///
1937.year#c.popshare_agegroup1_1930= "1937" ///
1938.year#c.popshare_agegroup1_1930= "1938" ///
1939.year#c.popshare_agegroup1_1930= "1939" ///
1940.year#c.popshare_agegroup1_1930= "1940" ///
1941.year#c.popshare_agegroup1_1930= "1941" ///
1942.year#c.popshare_agegroup1_1930= "1942" ///
1943.year#c.popshare_agegroup1_1930= "1943" ///
1944.year#c.popshare_agegroup1_1930= "1944" ///
1945.year#c.popshare_agegroup1_1930= "1945" ///
1946.year#c.popshare_agegroup1_1930= "1946" ///
1947.year#c.popshare_agegroup1_1930= "1947" ///
1948.year#c.popshare_agegroup1_1930= "1948" ///
1949.year#c.popshare_agegroup1_1930= "1949" ///
1950.year#c.popshare_agegroup1_1930= "1950" ///
1951.year#c.popshare_agegroup1_1930= "1951" ///
1952.year#c.popshare_agegroup1_1930= "1952" ///
1953.year#c.popshare_agegroup1_1930= "1953" ///
1954.year#c.popshare_agegroup1_1930= "1954" ///
1955.year#c.popshare_agegroup1_1930= "1955" ///
1956.year#c.popshare_agegroup1_1930= "1956" ///
1957.year#c.popshare_agegroup1_1930= "1957" ///
1958.year#c.popshare_agegroup1_1930= "1958" ///
1959.year#c.popshare_agegroup1_1930= "1959" ///
1960.year#c.popshare_agegroup1_1930= "1960" ///
1961.year#c.popshare_agegroup1_1930= "1961" ///
1962.year#c.popshare_agegroup1_1930= "1962" ///
1963.year#c.popshare_agegroup1_1930= "1963" ///
1964.year#c.popshare_agegroup1_1930= "1964" ///
1965.year#c.popshare_agegroup1_1930= "1965" ///
1966.year#c.popshare_agegroup1_1930= "1966" ///
1967.year#c.popshare_agegroup1_1930= "1967" ///
1968.year#c.popshare_agegroup1_1930= "1968" ///
1969.year#c.popshare_agegroup1_1930= "1969" ///
1970.year#c.popshare_agegroup1_1930= "1970" ///
) ///

graph export $Results\graph_`x'_onlypopshare.png,replace
}
