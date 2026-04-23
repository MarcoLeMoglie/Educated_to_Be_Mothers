*********************************************************
**# Only one treatment: teachers
*********************************************************
use "$Data\CIS\_data_cis\barometros.dta", clear
egen id_type = group(type)
drop if year_birth<1910
drop if year_birth<1920
drop if year_birth >=1973
tab year_birth
tab ESTU

gen teachers_pc=teachers/pop_1930*10000
gen treated = 1 if year_birth >=1940
replace treated = 0 if missing(treated)


**# 
foreach x of varlist unemployed pro_abort_illbaby pro_art_fert pro_abort_church teachers_extrpolit husb_nothouseworks stab_fidelity stab_kids decision_husb everyb_works free_housework union{ // 
	forvalues i=1(1)1 {
sum  `x'   
local mean_depvar = r(mean)
	
drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
gen sum`i'=popsharewomen_agegroup`i'
gen sum2`i'=popsharemen_agegroup`i' 

gen interaction=year_birth*sum`i'*teachers_pc
gen interaction2=year_birth*sum2`i'*teachers_pc

gen post_sum`i'=treated*sum`i'
gen post_sum2`i'=treated*sum2`i'
gen post_teachers=treated*teachers_pc

label var interaction "Fem. pop X Teachers X Treat"
label var interaction2 "Male pop X Teachers X Treat"

label var post_sum`i' "Female pop X Treat"
label var post_sum2`i' "Male pop X Treat"
label var post_teachers "Teachers X Treat"

local var_label : variable label `x'

reghdfe `x' b1930.year_birth##c.teachers_pc , a( i.id) cluster(id) 


coefplot , keep(*.year_birth#c.teachers_pc) vertical base omitted  yline(0, lc(red) lp(dash)) xline(11, lcolor(blue) lpattern(dash)) ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) title(, s(small) c(black)) ytitle(, s(vsmall)) scheme(s2mono) xlabel(, angle(45) labs(tiny))   ///
coeflabels( ///
1910.year_birth#c.teachers_pc= "1910" ///
1911.year_birth#c.teachers_pc= "1911" ///
1912.year_birth#c.teachers_pc= "1912" ///
1913.year_birth#c.teachers_pc= "1913" ///
1914.year_birth#c.teachers_pc= "1914" ///
1915.year_birth#c.teachers_pc= "1915" ///
1916.year_birth#c.teachers_pc= "1916" ///
1917.year_birth#c.teachers_pc= "1917" ///
1918.year_birth#c.teachers_pc= "1918" ///
1919.year_birth#c.teachers_pc= "1919" ///
1920.year_birth#c.teachers_pc= "1920" ///
1921.year_birth#c.teachers_pc= "1921" ///
1922.year_birth#c.teachers_pc= "1922" ///
1923.year_birth#c.teachers_pc= "1923" ///
1924.year_birth#c.teachers_pc= "1924" ///
1925.year_birth#c.teachers_pc= "1925" ///
1926.year_birth#c.teachers_pc= "1926" ///
1927.year_birth#c.teachers_pc= "1927" ///
1928.year_birth#c.teachers_pc= "1928" ///
1929.year_birth#c.teachers_pc= "1929" ///
1930.year_birth#c.teachers_pc= "1930" ///  
1931.year_birth#c.teachers_pc= "1931" ///
1932.year_birth#c.teachers_pc= "1932" ///
1933.year_birth#c.teachers_pc= "1933" ///
1934.year_birth#c.teachers_pc= "1934" ///
1935.year_birth#c.teachers_pc= "1935" ///
1936.year_birth#c.teachers_pc= "1936" ///
1937.year_birth#c.teachers_pc= "1937" ///
1938.year_birth#c.teachers_pc= "1938" ///
1939.year_birth#c.teachers_pc= "1939" ///
1940.year_birth#c.teachers_pc= "1940" ///
1941.year_birth#c.teachers_pc= "1941" ///
1942.year_birth#c.teachers_pc= "1942" ///
1943.year_birth#c.teachers_pc= "1943" ///
1944.year_birth#c.teachers_pc= "1944" ///
1945.year_birth#c.teachers_pc= "1945" ///
1946.year_birth#c.teachers_pc= "1946" ///
1947.year_birth#c.teachers_pc= "1947" ///
1948.year_birth#c.teachers_pc= "1948" ///
1949.year_birth#c.teachers_pc= "1949" ///
1950.year_birth#c.teachers_pc= "1950" ///
1951.year_birth#c.teachers_pc= "1951" ///
1952.year_birth#c.teachers_pc= "1952" ///
1953.year_birth#c.teachers_pc= "1953" ///
1954.year_birth#c.teachers_pc= "1954" ///
1955.year_birth#c.teachers_pc= "1955" ///
1956.year_birth#c.teachers_pc= "1956" ///
1957.year_birth#c.teachers_pc= "1957" ///
1958.year_birth#c.teachers_pc= "1958" ///
1959.year_birth#c.teachers_pc= "1959" ///
1960.year_birth#c.teachers_pc= "1960" ///
1961.year_birth#c.teachers_pc= "1961" ///
1962.year_birth#c.teachers_pc= "1962" ///
1963.year_birth#c.teachers_pc= "1963" ///
1964.year_birth#c.teachers_pc= "1964" ///
1965.year_birth#c.teachers_pc= "1965" ///
1966.year_birth#c.teachers_pc= "1966" ///
1967.year_birth#c.teachers_pc= "1967" ///
1968.year_birth#c.teachers_pc= "1968" ///
1969.year_birth#c.teachers_pc= "1969" ///
1970.year_birth#c.teachers_pc= "1970" ///
1971.year_birth#c.teachers_pc= "1971" ///
1972.year_birth#c.teachers_pc= "1972" ///
1973.year_birth#c.teachers_pc= "1973" ///
1974.year_birth#c.teachers_pc= "1974" ///
1975.year_birth#c.teachers_pc= "1975" ///
1976.year_birth#c.teachers_pc= "1976" ///
1977.year_birth#c.teachers_pc= "1977" ///
1978.year_birth#c.teachers_pc= "1978" ///
1979.year_birth#c.teachers_pc= "1979" ///
1980.year_birth#c.teachers_pc= "1980" ///
1981.year_birth#c.teachers_pc= "1981" ///
1982.year_birth#c.teachers_pc= "1982" ///
1983.year_birth#c.teachers_pc= "1983" ///
1984.year_birth#c.teachers_pc= "1984" ///
1985.year_birth#c.teachers_pc= "1985" ///
) 


graph save $Results/channels/continuous/onlyteachers/event_1940_`x'`i'.gph,replace
graph export $Results/channels/continuous/onlyteachers/event_1940_`x'`i'.pdf,replace
	}
	drop  sum* interaction* post_*
	}
	
	i
/*
cd $Results\continuous\

graph combine event_1940_flag41.gph event_1940_flag42.gph , graphregion(color(white)) ycommon title("Births", s(small) c(black)) r(1)
graph save event_1940_female_fertility.gph, replace 
*/
*********************************************************
**# Baseline specification
*********************************************************
use "$Data\CIS\_data_cis\barometros.dta", clear
egen id_type = group(type)
*gen duce=sh_area_front>50 & sh_area_front!=.
drop if year_birth<1910
drop if year_birth<1920
*drop if year_birth>=1960
drop if year_birth >=1973
tab year_birth

tab ESTU


gen teachers_pc=teachers/pop_1930*10000
gen treated = 1 if year_birth >=1940
replace treated = 0 if missing(treated)


**# 
foreach x of varlist pro_abort_illbaby  { //free_housework unemployed  pro_art_fert pro_abort_church teachers_extrpolit husb_nothouseworks stab_fidelity stab_kids decision_husb everyb_works union
	forvalues i=1(1)1 {
sum  `x'   
local mean_depvar = r(mean)
	
drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
gen sum`i'=popsharewomen_agegroup`i'
gen sum2`i'=popsharemen_agegroup`i' 

gen interaction=year_birth*sum`i'*teachers_pc
gen interaction2=year_birth*sum2`i'*teachers_pc

gen post_sum`i'=treated*sum`i'
gen post_sum2`i'=treated*sum2`i'
gen post_teachers=treated*teachers_pc

label var interaction "Fem. pop X Teachers X Treat"
label var interaction2 "Male pop X Teachers X Treat"

label var post_sum`i' "Female pop X Treat"
label var post_sum2`i' "Male pop X Treat"
label var post_teachers "Teachers X Treat"

local var_label : variable label `x'

reghdfe `x' b1930.year_birth##c.sum`i'##c.teachers_pc b1930.year_birth##c.sum2`i'##c.teachers_pc , a(i.female i.id) cluster(id) 

coefplot , keep(*.year_birth#c.sum`i'#c.teachers_pc) vertical base omitted  yline(0, lc(red) lp(dash)) xline(11, lcolor(blue) lpattern(dash)) ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) title(, s(small) c(black)) ytitle(, s(vsmall)) scheme(s2mono) xlabel(, angle(45) labs(tiny))   ///
coeflabels( ///
1910.year_birth#c.sum`i'#c.teachers_pc= "1910" ///
1911.year_birth#c.sum`i'#c.teachers_pc= "1911" ///
1912.year_birth#c.sum`i'#c.teachers_pc= "1912" ///
1913.year_birth#c.sum`i'#c.teachers_pc= "1913" ///
1914.year_birth#c.sum`i'#c.teachers_pc= "1914" ///
1915.year_birth#c.sum`i'#c.teachers_pc= "1915" ///
1916.year_birth#c.sum`i'#c.teachers_pc= "1916" ///
1917.year_birth#c.sum`i'#c.teachers_pc= "1917" ///
1918.year_birth#c.sum`i'#c.teachers_pc= "1918" ///
1919.year_birth#c.sum`i'#c.teachers_pc= "1919" ///
1920.year_birth#c.sum`i'#c.teachers_pc= "1920" ///
1921.year_birth#c.sum`i'#c.teachers_pc= "1921" ///
1922.year_birth#c.sum`i'#c.teachers_pc= "1922" ///
1923.year_birth#c.sum`i'#c.teachers_pc= "1923" ///
1924.year_birth#c.sum`i'#c.teachers_pc= "1924" ///
1925.year_birth#c.sum`i'#c.teachers_pc= "1925" ///
1926.year_birth#c.sum`i'#c.teachers_pc= "1926" ///
1927.year_birth#c.sum`i'#c.teachers_pc= "1927" ///
1928.year_birth#c.sum`i'#c.teachers_pc= "1928" ///
1929.year_birth#c.sum`i'#c.teachers_pc= "1929" ///
1930.year_birth#c.sum`i'#c.teachers_pc= "1930" ///  
1931.year_birth#c.sum`i'#c.teachers_pc= "1931" ///
1932.year_birth#c.sum`i'#c.teachers_pc= "1932" ///
1933.year_birth#c.sum`i'#c.teachers_pc= "1933" ///
1934.year_birth#c.sum`i'#c.teachers_pc= "1934" ///
1935.year_birth#c.sum`i'#c.teachers_pc= "1935" ///
1936.year_birth#c.sum`i'#c.teachers_pc= "1936" ///
1937.year_birth#c.sum`i'#c.teachers_pc= "1937" ///
1938.year_birth#c.sum`i'#c.teachers_pc= "1938" ///
1939.year_birth#c.sum`i'#c.teachers_pc= "1939" ///
1940.year_birth#c.sum`i'#c.teachers_pc= "1940" ///
1941.year_birth#c.sum`i'#c.teachers_pc= "1941" ///
1942.year_birth#c.sum`i'#c.teachers_pc= "1942" ///
1943.year_birth#c.sum`i'#c.teachers_pc= "1943" ///
1944.year_birth#c.sum`i'#c.teachers_pc= "1944" ///
1945.year_birth#c.sum`i'#c.teachers_pc= "1945" ///
1946.year_birth#c.sum`i'#c.teachers_pc= "1946" ///
1947.year_birth#c.sum`i'#c.teachers_pc= "1947" ///
1948.year_birth#c.sum`i'#c.teachers_pc= "1948" ///
1949.year_birth#c.sum`i'#c.teachers_pc= "1949" ///
1950.year_birth#c.sum`i'#c.teachers_pc= "1950" ///
1951.year_birth#c.sum`i'#c.teachers_pc= "1951" ///
1952.year_birth#c.sum`i'#c.teachers_pc= "1952" ///
1953.year_birth#c.sum`i'#c.teachers_pc= "1953" ///
1954.year_birth#c.sum`i'#c.teachers_pc= "1954" ///
1955.year_birth#c.sum`i'#c.teachers_pc= "1955" ///
1956.year_birth#c.sum`i'#c.teachers_pc= "1956" ///
1957.year_birth#c.sum`i'#c.teachers_pc= "1957" ///
1958.year_birth#c.sum`i'#c.teachers_pc= "1958" ///
1959.year_birth#c.sum`i'#c.teachers_pc= "1959" ///
1960.year_birth#c.sum`i'#c.teachers_pc= "1960" ///
1961.year_birth#c.sum`i'#c.teachers_pc= "1961" ///
1962.year_birth#c.sum`i'#c.teachers_pc= "1962" ///
1963.year_birth#c.sum`i'#c.teachers_pc= "1963" ///
1964.year_birth#c.sum`i'#c.teachers_pc= "1964" ///
1965.year_birth#c.sum`i'#c.teachers_pc= "1965" ///
1966.year_birth#c.sum`i'#c.teachers_pc= "1966" ///
1967.year_birth#c.sum`i'#c.teachers_pc= "1967" ///
1968.year_birth#c.sum`i'#c.teachers_pc= "1968" ///
1969.year_birth#c.sum`i'#c.teachers_pc= "1969" ///
1970.year_birth#c.sum`i'#c.teachers_pc= "1970" ///
1971.year_birth#c.sum`i'#c.teachers_pc= "1971" ///
1972.year_birth#c.sum`i'#c.teachers_pc= "1972" ///
1973.year_birth#c.sum`i'#c.teachers_pc= "1973" ///
1974.year_birth#c.sum`i'#c.teachers_pc= "1974" ///
1975.year_birth#c.sum`i'#c.teachers_pc= "1975" ///
1976.year_birth#c.sum`i'#c.teachers_pc= "1976" ///
1977.year_birth#c.sum`i'#c.teachers_pc= "1977" ///
1978.year_birth#c.sum`i'#c.teachers_pc= "1978" ///
1979.year_birth#c.sum`i'#c.teachers_pc= "1979" ///
1980.year_birth#c.sum`i'#c.teachers_pc= "1980" ///
1981.year_birth#c.sum`i'#c.teachers_pc= "1981" ///
1982.year_birth#c.sum`i'#c.teachers_pc= "1982" ///
1983.year_birth#c.sum`i'#c.teachers_pc= "1983" ///
1984.year_birth#c.sum`i'#c.teachers_pc= "1984" ///
1985.year_birth#c.sum`i'#c.teachers_pc= "1985" ///
) 


graph save $Results/channels/continuous/baseline/event_1940_`x'`i'.gph,replace
graph export $Results/channels/continuous/baseline/event_1940_`x'`i'.pdf,replace
	}
	drop  sum* interaction* post_*
	}
0	
cd $Results\continuous\

graph combine event_1940_flag41.gph event_1940_flag42.gph , graphregion(color(white)) ycommon title("Births", s(small) c(black)) r(1)
graph save event_1940_female_fertility.gph, replace 

