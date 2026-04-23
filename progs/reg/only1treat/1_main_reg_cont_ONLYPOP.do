clear all					
global dir "C:\Users\laxge\Dropbox\GEMA\RESEARCH\" // portatil

cd $dir
global Do 				"PURGE\progs"
global Output_data 		"PURGE\output_data"
global Data 			"PURGE\original_data"
global Results 			"PURGE\results"
use "$Output_data/dataset.dta", clear
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
**# 1. Regression -- By gender 
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
gen popsharewomen_agegroup1=popsharewomen_agegroup1_1940+popsharewomen_agegroup2_1940
gen popsharewomen_agegroup2=popsharewomen_agegroup3_1940+popsharewomen_agegroup4_1940+popsharewomen_agegroup5_1940
gen popsharemen_agegroup1=popsharemen_agegroup1_1940+popsharemen_agegroup2_1940
gen popsharemen_agegroup2=popsharemen_agegroup3_1940+popsharemen_agegroup4_1940+popsharemen_agegroup5_1940
gen flag4=(alive_birth/(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940))*1000
gen flag6=(total_wedding/(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940))*1000
/*
gen flag4=(alive_birth/(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940))*1000 if year>=1940 & year <1950
gen flag6=(total_wedding/(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940))*1000 if year>=1940 & year <1950

replace flag4=(alive_birth/(popwomen_agegroup3_1930 +popwomen_agegroup4_1930 +popwomen_agegroup5_1930))*1000 if year>=1930 & year <1940
replace flag6=(total_wedding/(popwomen_agegroup3_1930 +popwomen_agegroup4_1930 +popwomen_agegroup5_1930))*1000 if year>=1930 & year <1940

replace flag4=(alive_birth/(popwomen_agegroup3_1950 +popwomen_agegroup4_1950 +popwomen_agegroup5_1950))*1000 if year>=1950 & year <1960
replace flag6=(total_wedding/(popwomen_agegroup3_1950 +popwomen_agegroup4_1950 +popwomen_agegroup5_1950))*1000 if year>=1950 & year <1960

replace flag4=(alive_birth/(popwomen_agegroup3_1960 +popwomen_agegroup4_1960 +popwomen_agegroup5_1960))*1000 if year>=1960 & year <1970
replace flag6=(total_wedding/(popwomen_agegroup3_1960 +popwomen_agegroup4_1960 +popwomen_agegroup5_1960))*1000 if year>=1960 & year <1970

replace flag4=(alive_birth/(popwomen_agegroup3_1970 +popwomen_agegroup4_1970 +popwomen_agegroup5_1970))*1000 if year>=1970  
replace flag6=(total_wedding/(popwomen_agegroup3_1970 +popwomen_agegroup4_1970 +popwomen_agegroup5_1970))*1000 if year>=1970 
*/
foreach x of varlist  flag4 flag6 {

forvalues i=1(1)2 {
sum `x'  
local mean_depvar = r(mean)
			
drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
gen sum`i'=popsharewomen_agegroup`i'
gen sum2`i'=popsharemen_agegroup`i' 

*drop if year<1941

gen interaction=post*sum`i'
gen interaction2=post*sum2`i'

label var interaction "Treat (W) X Post"
label var interaction2 "Treat (M) X Post"

gen post_sum`i'=post*sum`i'
gen post_sum2`i'=post*sum2`i'

label var post_sum`i' "Female pop X Post"
label var post_sum2`i' "Male pop X Post"

if  "`x'"== "flag4"{
			local name2 = "Alive births per 1,000 inh."
			local tit = "Births"

		}

		else if  "`x'"== "flag6"{
			local name2 = "Weddings per 1,000 inh."
			local tit = "Weddings"
		}
		

if `i'==1 &  "`x'"== "flag4" {
local name = "0-14"
reghdfe `x' post_sum`i' post_sum2`i'  interaction interaction2 1.post##c.sum`i' 1.post##c.sum2`i', a(i.id i.year ) cluster(id) 
outreg2 using $Results\onlypop\continuous\table_reg_female, dec(3)  label nonotes addtext( Mun. FE, YES, Prov. X Year FE, YES, Cohort, `name')  ct("`tit'") tex(frag) keep(post_sum`i' post_sum2`i'  interaction interaction2) nocons replace addstat(Mean of depvar, `mean_depvar')
*egen idprovinceyear= group(codprov year)
*
reghdfe `x' b1945.year##c.sum`i'  b1945.year##c.sum2`i', a(i.id i.year) cluster(id) 

coefplot , keep(*.year#c.sum`i') vertical base omitted  yline(0, lc(red) lp(dash)) xline(16, lcolor(blue) lpattern(dash)) ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) title("`name'", s(small) c(black)) ytitle("`name2'", s(vsmall)) scheme(s2mono) xlabel(, angle(45) labs(tiny))   ///
coeflabels( ///
1930.year#c.sum`i'= "1930" ///  
1931.year#c.sum`i'= "1931" ///
1932.year#c.sum`i'= "1932" ///
1933.year#c.sum`i'= "1933" ///
1934.year#c.sum`i'= "1934" ///
1935.year#c.sum`i'= "1935" ///
1936.year#c.sum`i'= "1936" ///
1937.year#c.sum`i'= "1937" ///
1938.year#c.sum`i'= "1938" ///
1939.year#c.sum`i'= "1939" ///
1940.year#c.sum`i'= "1940" ///
1941.year#c.sum`i'= "1941" ///
1942.year#c.sum`i'= "1942" ///
1943.year#c.sum`i'= "1943" ///
1944.year#c.sum`i'= "1944" ///
1945.year#c.sum`i'= "1945" ///
1946.year#c.sum`i'= "1946" ///
1947.year#c.sum`i'= "1947" ///
1948.year#c.sum`i'= "1948" ///
1949.year#c.sum`i'= "1949" ///
1950.year#c.sum`i'= "1950" ///
1951.year#c.sum`i'= "1951" ///
1952.year#c.sum`i'= "1952" ///
1953.year#c.sum`i'= "1953" ///
1954.year#c.sum`i'= "1954" ///
1955.year#c.sum`i'= "1955" ///
1956.year#c.sum`i'= "1956" ///
1957.year#c.sum`i'= "1957" ///
1958.year#c.sum`i'= "1958" ///
1959.year#c.sum`i'= "1959" ///
1960.year#c.sum`i'= "1960" ///
1961.year#c.sum`i'= "1961" ///
1962.year#c.sum`i'= "1962" ///
1963.year#c.sum`i'= "1963" ///
1964.year#c.sum`i'= "1964" ///
1965.year#c.sum`i'= "1965" ///
1966.year#c.sum`i'= "1966" ///
1967.year#c.sum`i'= "1967" ///
1968.year#c.sum`i'= "1968" ///
1969.year#c.sum`i'= "1969" ///
1970.year#c.sum`i'= "1970" ///
1971.year#c.sum`i'= "1971" ///
1972.year#c.sum`i'= "1972" ///
1973.year#c.sum`i'= "1973" ///
1974.year#c.sum`i'= "1974" ///
1975.year#c.sum`i'= "1975" ///
1976.year#c.sum`i'= "1976" ///
1977.year#c.sum`i'= "1977" ///
1978.year#c.sum`i'= "1978" ///
1979.year#c.sum`i'= "1979" ///
1980.year#c.sum`i'= "1980" ///
1981.year#c.sum`i'= "1981" ///
1982.year#c.sum`i'= "1982" ///
1983.year#c.sum`i'= "1983" ///
1984.year#c.sum`i'= "1984" ///
1985.year#c.sum`i'= "1985" ///
) ///

graph save $Results\onlypop\continuous\event_1940_`x'`i'.gph,replace
graph export $Results\onlypop\continuous\event_1940_`x'`i'.pdf,replace

}
else if `i'!=1 | (`i'==1 &  "`x'"== "flag6") {
if `i'==1 {
local name = "0-14"
}	
*if `i'==2 {
*local name = "6-14"
*}
else if `i'==2 {
local name = "15-44"
}

reghdfe `x' post_sum`i' post_sum2`i'  interaction interaction2 1.post##c.sum`i' 1.post##c.sum2`i', a(i.id i.year) cluster(id) 
outreg2 using $Results\onlypop\continuous\table_reg_female, dec(3)  label nonotes addtext( Mun. FE, YES, Prov. X Year FE, YES, Cohort, `name')  ct("`tit'") tex(frag) keep(post_sum`i' post_sum2`i'  interaction interaction2) nocons addstat(Mean of depvar, `mean_depvar')
*egen idprovinceyear= group(codprov year)
*
reghdfe `x' b1945.year##c.sum`i'  b1945.year##c.sum2`i', a(i.id i.year) cluster(id) 

coefplot , keep(*.year#c.sum`i') vertical base omitted  yline(0, lc(red) lp(dash)) xline(16, lcolor(blue) lpattern(dash)) ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) title("`name'", s(small) c(black)) ytitle("`name2'", s(vsmall)) scheme(s2mono) xlabel(, angle(45) labs(tiny))   ///
coeflabels( ///
1930.year#c.sum`i'= "1930" ///  
1931.year#c.sum`i'= "1931" ///
1932.year#c.sum`i'= "1932" ///
1933.year#c.sum`i'= "1933" ///
1934.year#c.sum`i'= "1934" ///
1935.year#c.sum`i'= "1935" ///
1936.year#c.sum`i'= "1936" ///
1937.year#c.sum`i'= "1937" ///
1938.year#c.sum`i'= "1938" ///
1939.year#c.sum`i'= "1939" ///
1940.year#c.sum`i'= "1940" ///
1941.year#c.sum`i'= "1941" ///
1942.year#c.sum`i'= "1942" ///
1943.year#c.sum`i'= "1943" ///
1944.year#c.sum`i'= "1944" ///
1945.year#c.sum`i'= "1945" ///
1946.year#c.sum`i'= "1946" ///
1947.year#c.sum`i'= "1947" ///
1948.year#c.sum`i'= "1948" ///
1949.year#c.sum`i'= "1949" ///
1950.year#c.sum`i'= "1950" ///
1951.year#c.sum`i'= "1951" ///
1952.year#c.sum`i'= "1952" ///
1953.year#c.sum`i'= "1953" ///
1954.year#c.sum`i'= "1954" ///
1955.year#c.sum`i'= "1955" ///
1956.year#c.sum`i'= "1956" ///
1957.year#c.sum`i'= "1957" ///
1958.year#c.sum`i'= "1958" ///
1959.year#c.sum`i'= "1959" ///
1960.year#c.sum`i'= "1960" ///
1961.year#c.sum`i'= "1961" ///
1962.year#c.sum`i'= "1962" ///
1963.year#c.sum`i'= "1963" ///
1964.year#c.sum`i'= "1964" ///
1965.year#c.sum`i'= "1965" ///
1966.year#c.sum`i'= "1966" ///
1967.year#c.sum`i'= "1967" ///
1968.year#c.sum`i'= "1968" ///
1969.year#c.sum`i'= "1969" ///
1970.year#c.sum`i'= "1970" ///
1971.year#c.sum`i'= "1971" ///
1972.year#c.sum`i'= "1972" ///
1973.year#c.sum`i'= "1973" ///
1974.year#c.sum`i'= "1974" ///
1975.year#c.sum`i'= "1975" ///
1976.year#c.sum`i'= "1976" ///
1977.year#c.sum`i'= "1977" ///
1978.year#c.sum`i'= "1978" ///
1979.year#c.sum`i'= "1979" ///
1980.year#c.sum`i'= "1980" ///
1981.year#c.sum`i'= "1981" ///
1982.year#c.sum`i'= "1982" ///
1983.year#c.sum`i'= "1983" ///
1984.year#c.sum`i'= "1984" ///
1985.year#c.sum`i'= "1985" ///
) ///

graph save $Results\onlypop\continuous\event_1940_`x'`i'.gph,replace
graph export $Results\onlypop\continuous\event_1940_`x'`i'.pdf,replace
}
drop interaction interaction2 sum* post_*
}
}

cd $Results\onlypop\continuous\
graph combine event_1940_flag41.gph event_1940_flag42.gph , graphregion(color(white)) ycommon title("Births", s(small) c(black)) r(1)
graph save event_1940_female_fertility.gph, replace 

graph combine event_1940_flag61.gph event_1940_flag62.gph , graphregion(color(white)) ycommon title("Weddings", s(small) c(black)) r(1)
graph save event_1940_female_wedding.gph, replace 

graph combine event_1940_female_fertility.gph event_1940_female_wedding.gph, graphregion(color(white)) r(2)
graph export event_1940_female.pdf, replace


* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
**# 2. Regression -- By gender & prov*year FE
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
clear all					
global dir "C:\Users\laxge\Dropbox\GEMA\RESEARCH\" // portatil

cd $dir
global Do 				"PURGE\progs"
global Output_data 		"PURGE\output_data"
global Data 			"PURGE\original_data"
global Results 			"PURGE\results"
use "$Output_data/dataset.dta", clear
 
gen popsharewomen_agegroup1=popsharewomen_agegroup1_1940+popsharewomen_agegroup2_1940
*gen popsharewomen_agegroup2=popsharewomen_agegroup2_1940
gen popsharewomen_agegroup2=popsharewomen_agegroup3_1940+popsharewomen_agegroup4_1940+popsharewomen_agegroup5_1940
gen popsharemen_agegroup1=popsharemen_agegroup1_1940+popsharemen_agegroup2_1940
*gen popsharemen_agegroup2=popsharemen_agegroup2_1940
gen popsharemen_agegroup2=popsharemen_agegroup3_1940+popsharemen_agegroup4_1940+popsharemen_agegroup5_1940
gen flag4=(alive_birth/(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940))*1000
gen flag6=(total_wedding/(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940))*1000
foreach x of varlist  flag4 flag6 {

forvalues i=1(1)2 {
sum `x'  
local mean_depvar = r(mean)
			
drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
gen sum`i'=popsharewomen_agegroup`i'
gen sum2`i'=popsharemen_agegroup`i' 

*drop if year<1941

gen interaction=post*sum`i'
gen interaction2=post*sum2`i'

gen post_sum`i'=post*sum`i'
gen post_sum2`i'=post*sum2`i'

label var interaction "Treat (W) X Post"
label var interaction2 "Treat (M) X Post"
label var post_sum`i' "Female pop X Post"
label var post_sum2`i' "Male pop X Post"

if  "`x'"== "flag4"{
			local name2 = "Alive births per 1,000 inh."
			local tit = "Births"

		}

		else if  "`x'"== "flag6"{
			local name2 = "Weddings per 1,000 inh."
			local tit = "Weddings"
		}
		

if `i'==1 &  "`x'"== "flag4" {
local name = "0-14"
reghdfe `x' post_sum`i' post_sum2`i'  interaction interaction2 1.post##c.sum`i' 1.post##c.sum2`i', a(i.id i.year#i.codprov ) cluster(id) 
outreg2 using $Results\onlypop\continuous\table_reg_female_trends, dec(3)  label nonotes addtext( Mun. FE, YES, Prov. X Year FE, YES, Cohort, `name')  ct("`tit'") tex(frag) keep(post_sum`i' post_sum2`i'  interaction interaction2) nocons replace addstat(Mean of depvar, `mean_depvar')
*egen idprovinceyear= group(codprov year)
*
reghdfe `x' b1945.year##c.sum`i'  b1945.year##c.sum2`i', a(i.id i.year#i.codprov ) cluster(id) 

coefplot , keep(*.year#c.sum`i') vertical base omitted  yline(0, lc(red) lp(dash)) xline(16, lcolor(blue) lpattern(dash)) ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) title("`name'", s(small) c(black)) ytitle("`name2'", s(vsmall)) scheme(s2mono) xlabel(, angle(45) labs(tiny))   ///
coeflabels( ///
1930.year#c.sum`i'= "1930" ///  
1931.year#c.sum`i'= "1931" ///
1932.year#c.sum`i'= "1932" ///
1933.year#c.sum`i'= "1933" ///
1934.year#c.sum`i'= "1934" ///
1935.year#c.sum`i'= "1935" ///
1936.year#c.sum`i'= "1936" ///
1937.year#c.sum`i'= "1937" ///
1938.year#c.sum`i'= "1938" ///
1939.year#c.sum`i'= "1939" ///
1940.year#c.sum`i'= "1940" ///
1941.year#c.sum`i'= "1941" ///
1942.year#c.sum`i'= "1942" ///
1943.year#c.sum`i'= "1943" ///
1944.year#c.sum`i'= "1944" ///
1945.year#c.sum`i'= "1945" ///
1946.year#c.sum`i'= "1946" ///
1947.year#c.sum`i'= "1947" ///
1948.year#c.sum`i'= "1948" ///
1949.year#c.sum`i'= "1949" ///
1950.year#c.sum`i'= "1950" ///
1951.year#c.sum`i'= "1951" ///
1952.year#c.sum`i'= "1952" ///
1953.year#c.sum`i'= "1953" ///
1954.year#c.sum`i'= "1954" ///
1955.year#c.sum`i'= "1955" ///
1956.year#c.sum`i'= "1956" ///
1957.year#c.sum`i'= "1957" ///
1958.year#c.sum`i'= "1958" ///
1959.year#c.sum`i'= "1959" ///
1960.year#c.sum`i'= "1960" ///
1961.year#c.sum`i'= "1961" ///
1962.year#c.sum`i'= "1962" ///
1963.year#c.sum`i'= "1963" ///
1964.year#c.sum`i'= "1964" ///
1965.year#c.sum`i'= "1965" ///
1966.year#c.sum`i'= "1966" ///
1967.year#c.sum`i'= "1967" ///
1968.year#c.sum`i'= "1968" ///
1969.year#c.sum`i'= "1969" ///
1970.year#c.sum`i'= "1970" ///
1971.year#c.sum`i'= "1971" ///
1972.year#c.sum`i'= "1972" ///
1973.year#c.sum`i'= "1973" ///
1974.year#c.sum`i'= "1974" ///
1975.year#c.sum`i'= "1975" ///
1976.year#c.sum`i'= "1976" ///
1977.year#c.sum`i'= "1977" ///
1978.year#c.sum`i'= "1978" ///
1979.year#c.sum`i'= "1979" ///
1980.year#c.sum`i'= "1980" ///
1981.year#c.sum`i'= "1981" ///
1982.year#c.sum`i'= "1982" ///
1983.year#c.sum`i'= "1983" ///
1984.year#c.sum`i'= "1984" ///
1985.year#c.sum`i'= "1985" ///
) ///

graph save $Results\onlypop\continuous\event_1940_`x'`i'.gph,replace
graph export $Results\onlypop\continuous\event_1940_`x'`i'.pdf,replace

}
else if `i'!=1 | (`i'==1 &  "`x'"== "flag6") {
if `i'==1 {
local name = "0-14"
}	
*if `i'==2 {
*local name = "6-14"
*}
else if `i'==2 {
local name = "15-44"
}

reghdfe `x' post_sum`i' post_sum2`i'  interaction interaction2 1.post##c.sum`i' 1.post##c.sum2`i', a(i.id i.year#i.codprov ) cluster(id) 
outreg2 using $Results\onlypop\continuous\table_reg_female_trends, dec(3)  label nonotes addtext( Mun. FE, YES, Prov. X Year FE, YES, Cohort, `name')  ct("`tit'") tex(frag) keep(post_sum`i' post_sum2`i'  interaction interaction2) nocons addstat(Mean of depvar, `mean_depvar')
*egen idprovinceyear= group(codprov year)
*
reghdfe `x' b1945.year##c.sum`i'  b1945.year##c.sum2`i', a(i.id i.year#i.codprov ) cluster(id) 

coefplot , keep(*.year#c.sum`i') vertical base omitted  yline(0, lc(red) lp(dash)) xline(16, lcolor(blue) lpattern(dash)) ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) title("`name'", s(small) c(black)) ytitle("`name2'", s(vsmall)) scheme(s2mono) xlabel(, angle(45) labs(tiny))   ///
coeflabels( ///
1930.year#c.sum`i'= "1930" ///  
1931.year#c.sum`i'= "1931" ///
1932.year#c.sum`i'= "1932" ///
1933.year#c.sum`i'= "1933" ///
1934.year#c.sum`i'= "1934" ///
1935.year#c.sum`i'= "1935" ///
1936.year#c.sum`i'= "1936" ///
1937.year#c.sum`i'= "1937" ///
1938.year#c.sum`i'= "1938" ///
1939.year#c.sum`i'= "1939" ///
1940.year#c.sum`i'= "1940" ///
1941.year#c.sum`i'= "1941" ///
1942.year#c.sum`i'= "1942" ///
1943.year#c.sum`i'= "1943" ///
1944.year#c.sum`i'= "1944" ///
1945.year#c.sum`i'= "1945" ///
1946.year#c.sum`i'= "1946" ///
1947.year#c.sum`i'= "1947" ///
1948.year#c.sum`i'= "1948" ///
1949.year#c.sum`i'= "1949" ///
1950.year#c.sum`i'= "1950" ///
1951.year#c.sum`i'= "1951" ///
1952.year#c.sum`i'= "1952" ///
1953.year#c.sum`i'= "1953" ///
1954.year#c.sum`i'= "1954" ///
1955.year#c.sum`i'= "1955" ///
1956.year#c.sum`i'= "1956" ///
1957.year#c.sum`i'= "1957" ///
1958.year#c.sum`i'= "1958" ///
1959.year#c.sum`i'= "1959" ///
1960.year#c.sum`i'= "1960" ///
1961.year#c.sum`i'= "1961" ///
1962.year#c.sum`i'= "1962" ///
1963.year#c.sum`i'= "1963" ///
1964.year#c.sum`i'= "1964" ///
1965.year#c.sum`i'= "1965" ///
1966.year#c.sum`i'= "1966" ///
1967.year#c.sum`i'= "1967" ///
1968.year#c.sum`i'= "1968" ///
1969.year#c.sum`i'= "1969" ///
1970.year#c.sum`i'= "1970" ///
1971.year#c.sum`i'= "1971" ///
1972.year#c.sum`i'= "1972" ///
1973.year#c.sum`i'= "1973" ///
1974.year#c.sum`i'= "1974" ///
1975.year#c.sum`i'= "1975" ///
1976.year#c.sum`i'= "1976" ///
1977.year#c.sum`i'= "1977" ///
1978.year#c.sum`i'= "1978" ///
1979.year#c.sum`i'= "1979" ///
1980.year#c.sum`i'= "1980" ///
1981.year#c.sum`i'= "1981" ///
1982.year#c.sum`i'= "1982" ///
1983.year#c.sum`i'= "1983" ///
1984.year#c.sum`i'= "1984" ///
1985.year#c.sum`i'= "1985" ///
) ///

graph save $Results\onlypop\continuous\event_1940_`x'`i'.gph,replace
graph export $Results\onlypop\continuous\event_1940_`x'`i'.pdf,replace
}
drop interaction interaction2 sum* post_*
}
}

cd $Results\onlypop\continuous\
graph combine event_1940_flag41.gph event_1940_flag42.gph , graphregion(color(white)) ycommon title("Births", s(small) c(black)) r(1)
graph save event_1940_female_fertility.gph, replace 

graph combine event_1940_flag61.gph event_1940_flag62.gph , graphregion(color(white)) ycommon title("Weddings", s(small) c(black)) r(1)
graph save event_1940_female_wedding.gph, replace 

graph combine event_1940_female_fertility.gph event_1940_female_wedding.gph, graphregion(color(white)) r(2)
graph export event_1940_female_trends.pdf, replace



* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
**# 3.Regression -- By gender  -- PLACEBO
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
clear all					
global dir "C:\Users\laxge\Dropbox\GEMA\RESEARCH\" // portatil

cd $dir
global Do 				"PURGE\progs"
global Output_data 		"PURGE\output_data"
global Data 			"PURGE\original_data"
global Results 			"PURGE\results"
use "$Output_data/dataset.dta", clear

gen popsharewomen_agegroup1=popsharewomen_agegroup1_1930+popsharewomen_agegroup2_1930
*gen popsharewomen_agegroup2=popsharewomen_agegroup2_1930
gen popsharewomen_agegroup2=popsharewomen_agegroup3_1930+popsharewomen_agegroup4_1930+popsharewomen_agegroup5_1930
gen popsharemen_agegroup1=popsharemen_agegroup1_1930+popsharemen_agegroup2_1930
*gen popsharemen_agegroup2=popsharemen_agegroup2_1930
gen popsharemen_agegroup2=popsharemen_agegroup3_1930+popsharemen_agegroup4_1930+popsharemen_agegroup5_1930
gen flag4=(alive_birth/(popwomen_agegroup3_1930 +popwomen_agegroup4_1930 +popwomen_agegroup5_1930))*1000
gen flag6=(total_wedding/(popwomen_agegroup3_1930 +popwomen_agegroup4_1930 +popwomen_agegroup5_1930))*1000
*gen flag4=(alive_birth/(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940))*1000
*gen flag6=(total_wedding/(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940))*1000
foreach x of varlist  flag4 flag6  {

forvalues i=1(1)2 {
sum `x'  
local mean_depvar = r(mean)
			
drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
gen sum`i'=popsharewomen_agegroup`i'
gen sum2`i'=popsharemen_agegroup`i' 

*drop if year<1941

gen interaction=post*sum`i'
gen interaction2=post*sum2`i'

gen post_sum`i'=post*sum`i'
gen post_sum2`i'=post*sum2`i'


label var interaction "Treat (W) X Post"
label var interaction2 "Treat (M) X Post"
label var post_sum`i' "Female pop X Post"
label var post_sum2`i' "Male pop X Post"

if  "`x'"== "flag4"{
			local name2 = "Alive births per 1,000 inh."
			local tit = "Births"

		}

		else if  "`x'"== "flag6"{
			local name2 = "Weddings per 1,000 inh."
			local tit = "Weddings"
		}
		

if `i'==1 &  "`x'"== "flag4" {
local name = "0-14"
reghdfe `x' post_sum`i' post_sum2`i'  interaction interaction2 1.post##c.sum`i' 1.post##c.sum2`i', a(i.id i.year) cluster(id) 
outreg2 using $Results\onlypop\continuous\table_reg_female_placebo, dec(3)  label nonotes addtext( Mun. FE, YES, Prov. X Year FE, YES, Cohort, `name')  ct("`tit'") tex(frag) keep(post_sum`i' post_sum2`i'  interaction interaction2) nocons replace addstat(Mean of depvar, `mean_depvar')
*egen idprovinceyear= group(codprov year)
*
reghdfe `x' b1945.year##c.sum`i'  b1945.year##c.sum2`i', a(i.id i.year ) cluster(id) 

coefplot , keep(*.year#c.sum`i') vertical base omitted  yline(0, lc(red) lp(dash)) xline(16, lcolor(blue) lpattern(dash)) ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) title("`name'", s(small) c(black)) ytitle("`name2'", s(vsmall)) scheme(s2mono) xlabel(, angle(45) labs(tiny))   ///
coeflabels( ///
1930.year#c.sum`i'= "1930" ///  
1931.year#c.sum`i'= "1931" ///
1932.year#c.sum`i'= "1932" ///
1933.year#c.sum`i'= "1933" ///
1934.year#c.sum`i'= "1934" ///
1935.year#c.sum`i'= "1935" ///
1936.year#c.sum`i'= "1936" ///
1937.year#c.sum`i'= "1937" ///
1938.year#c.sum`i'= "1938" ///
1939.year#c.sum`i'= "1939" ///
1940.year#c.sum`i'= "1940" ///
1941.year#c.sum`i'= "1941" ///
1942.year#c.sum`i'= "1942" ///
1943.year#c.sum`i'= "1943" ///
1944.year#c.sum`i'= "1944" ///
1945.year#c.sum`i'= "1945" ///
1946.year#c.sum`i'= "1946" ///
1947.year#c.sum`i'= "1947" ///
1948.year#c.sum`i'= "1948" ///
1949.year#c.sum`i'= "1949" ///
1950.year#c.sum`i'= "1950" ///
1951.year#c.sum`i'= "1951" ///
1952.year#c.sum`i'= "1952" ///
1953.year#c.sum`i'= "1953" ///
1954.year#c.sum`i'= "1954" ///
1955.year#c.sum`i'= "1955" ///
1956.year#c.sum`i'= "1956" ///
1957.year#c.sum`i'= "1957" ///
1958.year#c.sum`i'= "1958" ///
1959.year#c.sum`i'= "1959" ///
1960.year#c.sum`i'= "1960" ///
1961.year#c.sum`i'= "1961" ///
1962.year#c.sum`i'= "1962" ///
1963.year#c.sum`i'= "1963" ///
1964.year#c.sum`i'= "1964" ///
1965.year#c.sum`i'= "1965" ///
1966.year#c.sum`i'= "1966" ///
1967.year#c.sum`i'= "1967" ///
1968.year#c.sum`i'= "1968" ///
1969.year#c.sum`i'= "1969" ///
1970.year#c.sum`i'= "1970" ///
1971.year#c.sum`i'= "1971" ///
1972.year#c.sum`i'= "1972" ///
1973.year#c.sum`i'= "1973" ///
1974.year#c.sum`i'= "1974" ///
1975.year#c.sum`i'= "1975" ///
1976.year#c.sum`i'= "1976" ///
1977.year#c.sum`i'= "1977" ///
1978.year#c.sum`i'= "1978" ///
1979.year#c.sum`i'= "1979" ///
1980.year#c.sum`i'= "1980" ///
1981.year#c.sum`i'= "1981" ///
1982.year#c.sum`i'= "1982" ///
1983.year#c.sum`i'= "1983" ///
1984.year#c.sum`i'= "1984" ///
1985.year#c.sum`i'= "1985" ///
) ///

graph save $Results\onlypop\continuous\event_1930_`x'`i'.gph,replace
graph export $Results\onlypop\continuous\event_1930_`x'`i'.pdf,replace

}
else if `i'!=1 | (`i'==1 &  "`x'"== "flag6") {
if `i'==1 {
local name = "0-14"
}	
if `i'==2 {
local name = "15-44"
}
*else if `i'==3 {
*local name = "15-44"
*}

reghdfe `x' post_sum`i' post_sum2`i'  interaction interaction2 1.post##c.sum`i' 1.post##c.sum2`i', a(i.id i.year) cluster(id) 
outreg2 using $Results\onlypop\continuous\table_reg_female_placebo, dec(3)  label nonotes addtext( Mun. FE, YES, Prov. X Year FE, YES, Cohort, `name')  ct("`tit'") tex(frag) keep(post_sum`i' post_sum2`i'  interaction interaction2) nocons addstat(Mean of depvar, `mean_depvar')
*egen idprovinceyear= group(codprov year)
*
reghdfe `x' b1945.year##c.sum`i'  b1945.year##c.sum2`i', a(i.id i.year ) cluster(id) 

coefplot , keep(*.year#c.sum`i') vertical base omitted  yline(0, lc(red) lp(dash)) xline(16, lcolor(blue) lpattern(dash)) ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) title("`name'", s(small) c(black)) ytitle("`name2'", s(vsmall)) scheme(s2mono) xlabel(, angle(45) labs(tiny))   ///
coeflabels( ///
1930.year#c.sum`i'= "1930" ///  
1931.year#c.sum`i'= "1931" ///
1932.year#c.sum`i'= "1932" ///
1933.year#c.sum`i'= "1933" ///
1934.year#c.sum`i'= "1934" ///
1935.year#c.sum`i'= "1935" ///
1936.year#c.sum`i'= "1936" ///
1937.year#c.sum`i'= "1937" ///
1938.year#c.sum`i'= "1938" ///
1939.year#c.sum`i'= "1939" ///
1940.year#c.sum`i'= "1940" ///
1941.year#c.sum`i'= "1941" ///
1942.year#c.sum`i'= "1942" ///
1943.year#c.sum`i'= "1943" ///
1944.year#c.sum`i'= "1944" ///
1945.year#c.sum`i'= "1945" ///
1946.year#c.sum`i'= "1946" ///
1947.year#c.sum`i'= "1947" ///
1948.year#c.sum`i'= "1948" ///
1949.year#c.sum`i'= "1949" ///
1950.year#c.sum`i'= "1950" ///
1951.year#c.sum`i'= "1951" ///
1952.year#c.sum`i'= "1952" ///
1953.year#c.sum`i'= "1953" ///
1954.year#c.sum`i'= "1954" ///
1955.year#c.sum`i'= "1955" ///
1956.year#c.sum`i'= "1956" ///
1957.year#c.sum`i'= "1957" ///
1958.year#c.sum`i'= "1958" ///
1959.year#c.sum`i'= "1959" ///
1960.year#c.sum`i'= "1960" ///
1961.year#c.sum`i'= "1961" ///
1962.year#c.sum`i'= "1962" ///
1963.year#c.sum`i'= "1963" ///
1964.year#c.sum`i'= "1964" ///
1965.year#c.sum`i'= "1965" ///
1966.year#c.sum`i'= "1966" ///
1967.year#c.sum`i'= "1967" ///
1968.year#c.sum`i'= "1968" ///
1969.year#c.sum`i'= "1969" ///
1970.year#c.sum`i'= "1970" ///
1971.year#c.sum`i'= "1971" ///
1972.year#c.sum`i'= "1972" ///
1973.year#c.sum`i'= "1973" ///
1974.year#c.sum`i'= "1974" ///
1975.year#c.sum`i'= "1975" ///
1976.year#c.sum`i'= "1976" ///
1977.year#c.sum`i'= "1977" ///
1978.year#c.sum`i'= "1978" ///
1979.year#c.sum`i'= "1979" ///
1980.year#c.sum`i'= "1980" ///
1981.year#c.sum`i'= "1981" ///
1982.year#c.sum`i'= "1982" ///
1983.year#c.sum`i'= "1983" ///
1984.year#c.sum`i'= "1984" ///
1985.year#c.sum`i'= "1985" ///
) ///

graph save $Results\onlypop\continuous\event_1930_`x'`i'.gph,replace
graph export $Results\onlypop\continuous\event_1930_`x'`i'.pdf,replace
}
drop interaction interaction2 sum* post_*
}
}

cd $Results\onlypop\continuous\
graph combine event_1930_flag41.gph event_1930_flag42.gph, graphregion(color(white)) ycommon title("Births", s(small) c(black)) r(1)
graph save event_1930_female_fertility.gph, replace 

graph combine event_1930_flag61.gph event_1930_flag62.gph , graphregion(color(white)) ycommon title("Weddings", s(small) c(black)) r(1)
graph save event_1930_female_wedding.gph, replace 

graph combine event_1930_female_fertility.gph event_1930_female_wedding.gph, graphregion(color(white)) r(2)
graph export event_1930_female.pdf, replace
