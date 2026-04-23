
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
**# 1. Regression -- By gender 
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
clear all					
global dir "C:\Users\laxge\Dropbox\GEMA\RESEARCH\" // portatil

cd $dir
global Do 				"PURGE\progs"
global Output_data 		"PURGE\output_data"
global Data 			"PURGE\original_data"
global Results 			"PURGE\results"
use "$Output_data/dataset.dta", clear

* Female
gen popsharewomen_agegroup1=popsharewomen_agegroup1_1940+popsharewomen_agegroup2_1940
gen popsharewomen_agegroup2=popsharewomen_agegroup3_1940+popsharewomen_agegroup4_1940+popsharewomen_agegroup5_1940

sum popsharewomen_agegroup1,d
gen median_popw1=popsharewomen_agegroup1>r(p50) & popsharewomen_agegroup1!=.
sum popsharewomen_agegroup2,d
gen median_popw2=popsharewomen_agegroup2>r(p50) & popsharewomen_agegroup2!=.

* Male
gen popsharemen_agegroup1=popsharemen_agegroup1_1940+popsharemen_agegroup2_1940
gen popsharemen_agegroup2=popsharemen_agegroup3_1940+popsharemen_agegroup4_1940+popsharemen_agegroup5_1940

sum popsharemen_agegroup1,d
gen median_popm1=popsharemen_agegroup1>r(p50) & popsharemen_agegroup1!=.
sum popsharemen_agegroup2,d
gen median_popm2=popsharemen_agegroup2>r(p50) & popsharemen_agegroup2!=.

* Dependent variables
gen flag4=(alive_birth/(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940))*1000
gen flag6=(total_wedding/(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940))*1000

foreach x of varlist  flag4   {

forvalues i=1(1)2 {
sum `x' if median_popw`i' ==0 & median_tea==0
local mean_depvar = r(mean)
		
drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
gen sum`i'=median_popw`i'
gen sum2`i'=median_popm`i' 

gen interaction=post*sum`i'*median_tea
gen interaction2=post*sum2`i'*median_tea

gen post_sum`i'=post*sum`i'
gen post_sum2`i'=post*sum2`i'
gen post_teachers=post*median_tea

label var interaction "Treat (W) X Post"
label var interaction2 "Treat (M) X Post"
label var post_sum`i' "Female pop X Post"
label var post_sum2`i' "Male pop X Post"
label var post_teachers "Teachers X Post"
if  "`x'"== "flag4"{
			local name2 = "Alive births per 1,000 inh."
			local tit = "Births"

			label var post_sum`i' "Female pop X Post"
			label var post_sum2`i' "Male pop X Post"
		}

		else if  "`x'"== "flag6"{
			local name2 = "Weddings per 1,000 inh."
			local tit = "Weddings"
			
			label var post_sum`i' "Female pop X Post"
			label var post_sum2`i' "Male pop X Post"
		}
		

if `i'==1 &  "`x'"== "flag4" {
local name = "0-14"
reghdfe `x' post_sum`i' post_sum2`i' post_teachers interaction interaction2 1.post##1.sum`i'##1.median_tea 1.post##1.sum2`i'##1.median_tea, a(i.id i.year ) cluster(id) 

outreg2 using $Results\median\table_reg_female, dec(3)  label nonotes addtext( Mun. FE, YES, Prov. X Year FE, YES, Cohort, `name')  ct("`tit'") tex(frag) keep(interaction ) nocons replace  addstat(Mean of depvar, `mean_depvar')

*drop interaction interaction2 sum* post_*

*
reghdfe `x' b1945.year##1.sum`i'##1.median_tea  b1945.year##1.sum2`i'##1.median_tea, a(i.id i.year ) cluster(id) 

coefplot , keep(*.year#1.sum`i'#1.median_tea) vertical base omitted  yline(0, lc(red) lp(dash)) xline(16, lcolor(blue) lpattern(dash)) ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) title("`name'", s(small) c(black)) ytitle("`name2'", s(vsmall)) scheme(s2mono) xlabel(, angle(45) labs(tiny))   ///
coeflabels( ///
1930.year#1.sum`i'#1.median_tea= "1930" ///  
1931.year#1.sum`i'#1.median_tea= "1931" ///
1932.year#1.sum`i'#1.median_tea= "1932" ///
1933.year#1.sum`i'#1.median_tea= "1933" ///
1934.year#1.sum`i'#1.median_tea= "1934" ///
1935.year#1.sum`i'#1.median_tea= "1935" ///
1936.year#1.sum`i'#1.median_tea= "1936" ///
1937.year#1.sum`i'#1.median_tea= "1937" ///
1938.year#1.sum`i'#1.median_tea= "1938" ///
1939.year#1.sum`i'#1.median_tea= "1939" ///
1940.year#1.sum`i'#1.median_tea= "1940" ///
1941.year#1.sum`i'#1.median_tea= "1941" ///
1942.year#1.sum`i'#1.median_tea= "1942" ///
1943.year#1.sum`i'#1.median_tea= "1943" ///
1944.year#1.sum`i'#1.median_tea= "1944" ///
1945.year#1.sum`i'#1.median_tea= "1945" ///
1946.year#1.sum`i'#1.median_tea= "1946" ///
1947.year#1.sum`i'#1.median_tea= "1947" ///
1948.year#1.sum`i'#1.median_tea= "1948" ///
1949.year#1.sum`i'#1.median_tea= "1949" ///
1950.year#1.sum`i'#1.median_tea= "1950" ///
1951.year#1.sum`i'#1.median_tea= "1951" ///
1952.year#1.sum`i'#1.median_tea= "1952" ///
1953.year#1.sum`i'#1.median_tea= "1953" ///
1954.year#1.sum`i'#1.median_tea= "1954" ///
1955.year#1.sum`i'#1.median_tea= "1955" ///
1956.year#1.sum`i'#1.median_tea= "1956" ///
1957.year#1.sum`i'#1.median_tea= "1957" ///
1958.year#1.sum`i'#1.median_tea= "1958" ///
1959.year#1.sum`i'#1.median_tea= "1959" ///
1960.year#1.sum`i'#1.median_tea= "1960" ///
1961.year#1.sum`i'#1.median_tea= "1961" ///
1962.year#1.sum`i'#1.median_tea= "1962" ///
1963.year#1.sum`i'#1.median_tea= "1963" ///
1964.year#1.sum`i'#1.median_tea= "1964" ///
1965.year#1.sum`i'#1.median_tea= "1965" ///
1966.year#1.sum`i'#1.median_tea= "1966" ///
1967.year#1.sum`i'#1.median_tea= "1967" ///
1968.year#1.sum`i'#1.median_tea= "1968" ///
1969.year#1.sum`i'#1.median_tea= "1969" ///
1970.year#1.sum`i'#1.median_tea= "1970" ///
1971.year#1.sum`i'#1.median_tea= "1971" ///
1972.year#1.sum`i'#1.median_tea= "1972" ///
1973.year#1.sum`i'#1.median_tea= "1973" ///
1974.year#1.sum`i'#1.median_tea= "1974" ///
1975.year#1.sum`i'#1.median_tea= "1975" ///
1976.year#1.sum`i'#1.median_tea= "1976" ///
1977.year#1.sum`i'#1.median_tea= "1977" ///
1978.year#1.sum`i'#1.median_tea= "1978" ///
1979.year#1.sum`i'#1.median_tea= "1979" ///
1980.year#1.sum`i'#1.median_tea= "1980" ///
1981.year#1.sum`i'#1.median_tea= "1981" ///
1982.year#1.sum`i'#1.median_tea= "1982" ///
1983.year#1.sum`i'#1.median_tea= "1983" ///
1984.year#1.sum`i'#1.median_tea= "1984" ///
1985.year#1.sum`i'#1.median_tea= "1985" ///
) ///

graph save $Results/median/event_1940_`x'`i'.gph,replace
graph export $Results/median/event_1940_`x'`i'.pdf,replace

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

reghdfe `x' post_sum`i' post_sum2`i' post_teachers interaction interaction2 1.post##1.sum`i'##1.median_tea 1.post##1.sum2`i'##1.median_tea, a(i.id i.year  ) cluster(id) 
outreg2 using $Results/median/table_reg_female, dec(3)  label nonotes addtext( Mun. FE, YES, Prov. X Year FE, YES, Cohort, `name')  ct("`tit'") tex(frag) keep(interaction ) nocons  addstat(Mean of depvar, `mean_depvar')

reghdfe `x' b1945.year##1.sum`i'##1.median_tea  b1945.year##1.sum2`i'##1.median_tea, a(i.id i.year) cluster(id) 

coefplot , keep(*.year#1.sum`i'#1.median_tea) vertical base omitted  yline(0, lc(red) lp(dash)) xline(16, lcolor(blue) lpattern(dash)) ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) title("`name'", s(small) c(black)) ytitle("`name2'", s(vsmall)) scheme(s2mono) xlabel(, angle(45) labs(tiny))   ///
coeflabels( ///
1930.year#1.sum`i'#1.median_tea= "1930" ///  
1931.year#1.sum`i'#1.median_tea= "1931" ///
1932.year#1.sum`i'#1.median_tea= "1932" ///
1933.year#1.sum`i'#1.median_tea= "1933" ///
1934.year#1.sum`i'#1.median_tea= "1934" ///
1935.year#1.sum`i'#1.median_tea= "1935" ///
1936.year#1.sum`i'#1.median_tea= "1936" ///
1937.year#1.sum`i'#1.median_tea= "1937" ///
1938.year#1.sum`i'#1.median_tea= "1938" ///
1939.year#1.sum`i'#1.median_tea= "1939" ///
1940.year#1.sum`i'#1.median_tea= "1940" ///
1941.year#1.sum`i'#1.median_tea= "1941" ///
1942.year#1.sum`i'#1.median_tea= "1942" ///
1943.year#1.sum`i'#1.median_tea= "1943" ///
1944.year#1.sum`i'#1.median_tea= "1944" ///
1945.year#1.sum`i'#1.median_tea= "1945" ///
1946.year#1.sum`i'#1.median_tea= "1946" ///
1947.year#1.sum`i'#1.median_tea= "1947" ///
1948.year#1.sum`i'#1.median_tea= "1948" ///
1949.year#1.sum`i'#1.median_tea= "1949" ///
1950.year#1.sum`i'#1.median_tea= "1950" ///
1951.year#1.sum`i'#1.median_tea= "1951" ///
1952.year#1.sum`i'#1.median_tea= "1952" ///
1953.year#1.sum`i'#1.median_tea= "1953" ///
1954.year#1.sum`i'#1.median_tea= "1954" ///
1955.year#1.sum`i'#1.median_tea= "1955" ///
1956.year#1.sum`i'#1.median_tea= "1956" ///
1957.year#1.sum`i'#1.median_tea= "1957" ///
1958.year#1.sum`i'#1.median_tea= "1958" ///
1959.year#1.sum`i'#1.median_tea= "1959" ///
1960.year#1.sum`i'#1.median_tea= "1960" ///
1961.year#1.sum`i'#1.median_tea= "1961" ///
1962.year#1.sum`i'#1.median_tea= "1962" ///
1963.year#1.sum`i'#1.median_tea= "1963" ///
1964.year#1.sum`i'#1.median_tea= "1964" ///
1965.year#1.sum`i'#1.median_tea= "1965" ///
1966.year#1.sum`i'#1.median_tea= "1966" ///
1967.year#1.sum`i'#1.median_tea= "1967" ///
1968.year#1.sum`i'#1.median_tea= "1968" ///
1969.year#1.sum`i'#1.median_tea= "1969" ///
1970.year#1.sum`i'#1.median_tea= "1970" ///
1971.year#1.sum`i'#1.median_tea= "1971" ///
1972.year#1.sum`i'#1.median_tea= "1972" ///
1973.year#1.sum`i'#1.median_tea= "1973" ///
1974.year#1.sum`i'#1.median_tea= "1974" ///
1975.year#1.sum`i'#1.median_tea= "1975" ///
1976.year#1.sum`i'#1.median_tea= "1976" ///
1977.year#1.sum`i'#1.median_tea= "1977" ///
1978.year#1.sum`i'#1.median_tea= "1978" ///
1979.year#1.sum`i'#1.median_tea= "1979" ///
1980.year#1.sum`i'#1.median_tea= "1980" ///
1981.year#1.sum`i'#1.median_tea= "1981" ///
1982.year#1.sum`i'#1.median_tea= "1982" ///
1983.year#1.sum`i'#1.median_tea= "1983" ///
1984.year#1.sum`i'#1.median_tea= "1984" ///
1985.year#1.sum`i'#1.median_tea= "1985" ///
) ///

graph save $Results/median/event_1940_`x'`i'.gph,replace
graph export $Results/median/event_1940_`x'`i'.pdf,replace
}
drop interaction interaction2 sum* post_*
}
}

cd $Results\median\

graph combine event_1940_flag41.gph event_1940_flag42.gph , graphregion(color(white)) ycommon title("Births", s(small) c(black)) r(1)
graph save event_1940_female_fertility.gph, replace 
graph export event_1940_female_fertility.pdf, replace

graph combine event_1940_flag61.gph event_1940_flag62.gph , graphregion(color(white)) ycommon title("Weddings", s(small) c(black)) r(1)
graph save event_1940_female_wedding.gph, replace 
graph export event_1940_female_wedding.pdf, replace

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

* Female
gen popsharewomen_agegroup1=popsharewomen_agegroup1_1940+popsharewomen_agegroup2_1940
gen popsharewomen_agegroup2=popsharewomen_agegroup3_1940+popsharewomen_agegroup4_1940+popsharewomen_agegroup5_1940

sum popsharewomen_agegroup1,d
gen median_popw1=popsharewomen_agegroup1>r(p50) & popsharewomen_agegroup1!=.
sum popsharewomen_agegroup2,d
gen median_popw2=popsharewomen_agegroup2>r(p50) & popsharewomen_agegroup2!=.

* Male
gen popsharemen_agegroup1=popsharemen_agegroup1_1940+popsharemen_agegroup2_1940
gen popsharemen_agegroup2=popsharemen_agegroup3_1940+popsharemen_agegroup4_1940+popsharemen_agegroup5_1940

sum popsharemen_agegroup1,d
gen median_popm1=popsharemen_agegroup1>r(p50) & popsharemen_agegroup1!=.
sum popsharemen_agegroup2,d
gen median_popm2=popsharemen_agegroup2>r(p50) & popsharemen_agegroup2!=.

* Dependent variables
gen flag4=(alive_birth/(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940))*1000
gen flag6=(total_wedding/(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940))*1000

foreach x of varlist  flag4   {

forvalues i=1(1)2 {
sum `x' if median_popw`i' ==0 & median_tea==0
local mean_depvar = r(mean)
		
drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
gen sum`i'=median_popw`i'
gen sum2`i'=median_popm`i' 

gen interaction=post*sum`i'*median_tea
gen interaction2=post*sum2`i'*median_tea

gen post_sum`i'=post*sum`i'
gen post_sum2`i'=post*sum2`i'
gen post_teachers=post*median_tea

label var interaction "Treat (W) X Post"
label var interaction2 "Treat (M) X Post"
label var post_sum`i' "Female pop X Post"
label var post_sum2`i' "Male pop X Post"
label var post_teachers "Teachers X Post"
if  "`x'"== "flag4"{
			local name2 = "Alive births per 1,000 inh."
			local tit = "Births"

			label var post_sum`i' "Female pop X Post"
			label var post_sum2`i' "Male pop X Post"
		}

		else if  "`x'"== "flag6"{
			local name2 = "Weddings per 1,000 inh."
			local tit = "Weddings"
			
			label var post_sum`i' "Female pop X Post"
			label var post_sum2`i' "Male pop X Post"
		}
		

if `i'==1 &  "`x'"== "flag4" {
local name = "0-14"
reghdfe `x' post_sum`i' post_sum2`i' median_tea interaction interaction2 1.post##1.sum`i'##1.median_tea 1.post##1.sum2`i'##1.median_tea, a(i.id i.year#i.codprov ) cluster(id) 

outreg2 using $Results\median\table_reg_female_trends, dec(3)  label nonotes addtext( Mun. FE, YES, Prov. X Year FE, YES, Cohort, `name')  ct("`tit'") tex(frag) keep(interaction ) nocons replace  addstat(Mean of depvar, `mean_depvar')

*drop interaction interaction2 sum* post_*

*
reghdfe `x' b1945.year##1.sum`i'##1.median_tea  b1945.year##1.sum2`i'##1.median_tea, a(i.id i.year#i.codprov ) cluster(id) 

coefplot , keep(*.year#1.sum`i'#1.median_tea) vertical base omitted  yline(0, lc(red) lp(dash)) xline(16, lcolor(blue) lpattern(dash)) ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) title("`name'", s(small) c(black)) ytitle("`name2'", s(vsmall)) scheme(s2mono) xlabel(, angle(45) labs(tiny))   ///
coeflabels( ///
1930.year#1.sum`i'#1.median_tea= "1930" ///  
1931.year#1.sum`i'#1.median_tea= "1931" ///
1932.year#1.sum`i'#1.median_tea= "1932" ///
1933.year#1.sum`i'#1.median_tea= "1933" ///
1934.year#1.sum`i'#1.median_tea= "1934" ///
1935.year#1.sum`i'#1.median_tea= "1935" ///
1936.year#1.sum`i'#1.median_tea= "1936" ///
1937.year#1.sum`i'#1.median_tea= "1937" ///
1938.year#1.sum`i'#1.median_tea= "1938" ///
1939.year#1.sum`i'#1.median_tea= "1939" ///
1940.year#1.sum`i'#1.median_tea= "1940" ///
1941.year#1.sum`i'#1.median_tea= "1941" ///
1942.year#1.sum`i'#1.median_tea= "1942" ///
1943.year#1.sum`i'#1.median_tea= "1943" ///
1944.year#1.sum`i'#1.median_tea= "1944" ///
1945.year#1.sum`i'#1.median_tea= "1945" ///
1946.year#1.sum`i'#1.median_tea= "1946" ///
1947.year#1.sum`i'#1.median_tea= "1947" ///
1948.year#1.sum`i'#1.median_tea= "1948" ///
1949.year#1.sum`i'#1.median_tea= "1949" ///
1950.year#1.sum`i'#1.median_tea= "1950" ///
1951.year#1.sum`i'#1.median_tea= "1951" ///
1952.year#1.sum`i'#1.median_tea= "1952" ///
1953.year#1.sum`i'#1.median_tea= "1953" ///
1954.year#1.sum`i'#1.median_tea= "1954" ///
1955.year#1.sum`i'#1.median_tea= "1955" ///
1956.year#1.sum`i'#1.median_tea= "1956" ///
1957.year#1.sum`i'#1.median_tea= "1957" ///
1958.year#1.sum`i'#1.median_tea= "1958" ///
1959.year#1.sum`i'#1.median_tea= "1959" ///
1960.year#1.sum`i'#1.median_tea= "1960" ///
1961.year#1.sum`i'#1.median_tea= "1961" ///
1962.year#1.sum`i'#1.median_tea= "1962" ///
1963.year#1.sum`i'#1.median_tea= "1963" ///
1964.year#1.sum`i'#1.median_tea= "1964" ///
1965.year#1.sum`i'#1.median_tea= "1965" ///
1966.year#1.sum`i'#1.median_tea= "1966" ///
1967.year#1.sum`i'#1.median_tea= "1967" ///
1968.year#1.sum`i'#1.median_tea= "1968" ///
1969.year#1.sum`i'#1.median_tea= "1969" ///
1970.year#1.sum`i'#1.median_tea= "1970" ///
1971.year#1.sum`i'#1.median_tea= "1971" ///
1972.year#1.sum`i'#1.median_tea= "1972" ///
1973.year#1.sum`i'#1.median_tea= "1973" ///
1974.year#1.sum`i'#1.median_tea= "1974" ///
1975.year#1.sum`i'#1.median_tea= "1975" ///
1976.year#1.sum`i'#1.median_tea= "1976" ///
1977.year#1.sum`i'#1.median_tea= "1977" ///
1978.year#1.sum`i'#1.median_tea= "1978" ///
1979.year#1.sum`i'#1.median_tea= "1979" ///
1980.year#1.sum`i'#1.median_tea= "1980" ///
1981.year#1.sum`i'#1.median_tea= "1981" ///
1982.year#1.sum`i'#1.median_tea= "1982" ///
1983.year#1.sum`i'#1.median_tea= "1983" ///
1984.year#1.sum`i'#1.median_tea= "1984" ///
1985.year#1.sum`i'#1.median_tea= "1985" ///
) ///

graph save $Results/median/event_1940_`x'`i'.gph,replace
graph export $Results/median/event_1940_`x'`i'.pdf,replace

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

reghdfe `x' post_sum`i' post_sum2`i' interaction interaction2 1.post##1.sum`i'##1.median_tea 1.post##1.sum2`i'##1.median_tea, a(i.id i.year#i.codprov ) cluster(id) 
outreg2 using $Results/median/table_reg_female_trends , dec(3)  label nonotes addtext( Mun. FE, YES, Prov. X Year FE, YES, Cohort, `name')  ct("`tit'") tex(frag) keep(interaction) nocons  addstat(Mean of depvar, `mean_depvar')

reghdfe `x' b1945.year##1.sum`i'##1.median_tea  b1945.year##1.sum2`i'##1.median_tea, a(i.id i.year#i.codprov ) cluster(id) 

coefplot , keep(*.year#1.sum`i'#1.median_tea) vertical base omitted  yline(0, lc(red) lp(dash)) xline(16, lcolor(blue) lpattern(dash)) ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) title("`name'", s(small) c(black)) ytitle("`name2'", s(vsmall)) scheme(s2mono) xlabel(, angle(45) labs(tiny))   ///
coeflabels( ///
1930.year#1.sum`i'#1.median_tea= "1930" ///  
1931.year#1.sum`i'#1.median_tea= "1931" ///
1932.year#1.sum`i'#1.median_tea= "1932" ///
1933.year#1.sum`i'#1.median_tea= "1933" ///
1934.year#1.sum`i'#1.median_tea= "1934" ///
1935.year#1.sum`i'#1.median_tea= "1935" ///
1936.year#1.sum`i'#1.median_tea= "1936" ///
1937.year#1.sum`i'#1.median_tea= "1937" ///
1938.year#1.sum`i'#1.median_tea= "1938" ///
1939.year#1.sum`i'#1.median_tea= "1939" ///
1940.year#1.sum`i'#1.median_tea= "1940" ///
1941.year#1.sum`i'#1.median_tea= "1941" ///
1942.year#1.sum`i'#1.median_tea= "1942" ///
1943.year#1.sum`i'#1.median_tea= "1943" ///
1944.year#1.sum`i'#1.median_tea= "1944" ///
1945.year#1.sum`i'#1.median_tea= "1945" ///
1946.year#1.sum`i'#1.median_tea= "1946" ///
1947.year#1.sum`i'#1.median_tea= "1947" ///
1948.year#1.sum`i'#1.median_tea= "1948" ///
1949.year#1.sum`i'#1.median_tea= "1949" ///
1950.year#1.sum`i'#1.median_tea= "1950" ///
1951.year#1.sum`i'#1.median_tea= "1951" ///
1952.year#1.sum`i'#1.median_tea= "1952" ///
1953.year#1.sum`i'#1.median_tea= "1953" ///
1954.year#1.sum`i'#1.median_tea= "1954" ///
1955.year#1.sum`i'#1.median_tea= "1955" ///
1956.year#1.sum`i'#1.median_tea= "1956" ///
1957.year#1.sum`i'#1.median_tea= "1957" ///
1958.year#1.sum`i'#1.median_tea= "1958" ///
1959.year#1.sum`i'#1.median_tea= "1959" ///
1960.year#1.sum`i'#1.median_tea= "1960" ///
1961.year#1.sum`i'#1.median_tea= "1961" ///
1962.year#1.sum`i'#1.median_tea= "1962" ///
1963.year#1.sum`i'#1.median_tea= "1963" ///
1964.year#1.sum`i'#1.median_tea= "1964" ///
1965.year#1.sum`i'#1.median_tea= "1965" ///
1966.year#1.sum`i'#1.median_tea= "1966" ///
1967.year#1.sum`i'#1.median_tea= "1967" ///
1968.year#1.sum`i'#1.median_tea= "1968" ///
1969.year#1.sum`i'#1.median_tea= "1969" ///
1970.year#1.sum`i'#1.median_tea= "1970" ///
1971.year#1.sum`i'#1.median_tea= "1971" ///
1972.year#1.sum`i'#1.median_tea= "1972" ///
1973.year#1.sum`i'#1.median_tea= "1973" ///
1974.year#1.sum`i'#1.median_tea= "1974" ///
1975.year#1.sum`i'#1.median_tea= "1975" ///
1976.year#1.sum`i'#1.median_tea= "1976" ///
1977.year#1.sum`i'#1.median_tea= "1977" ///
1978.year#1.sum`i'#1.median_tea= "1978" ///
1979.year#1.sum`i'#1.median_tea= "1979" ///
1980.year#1.sum`i'#1.median_tea= "1980" ///
1981.year#1.sum`i'#1.median_tea= "1981" ///
1982.year#1.sum`i'#1.median_tea= "1982" ///
1983.year#1.sum`i'#1.median_tea= "1983" ///
1984.year#1.sum`i'#1.median_tea= "1984" ///
1985.year#1.sum`i'#1.median_tea= "1985" ///
) ///

graph save $Results/median/event_1940_`x'`i'.gph,replace
graph export $Results/median/event_1940_`x'`i'.pdf,replace
}
drop interaction interaction2 sum* post_*
}
}

cd $Results\median\

graph combine event_1940_flag41.gph event_1940_flag42.gph , graphregion(color(white)) ycommon title("Births", s(small) c(black)) r(1)
graph save event_1940_female_fertility.gph, replace 
graph export event_1940_female_trends_fertility.pdf, replace

graph combine event_1940_flag61.gph event_1940_flag62.gph , graphregion(color(white)) ycommon title("Weddings", s(small) c(black)) r(1)
graph save event_1940_female_wedding.gph, replace 
graph export event_1940_female_trends_wedding.pdf, replace

graph combine event_1940_female_fertility.gph event_1940_female_wedding.gph, graphregion(color(white)) r(2)
graph export event_1940_female_trends.pdf, replace




/*
****** Regression -- By gender & three age-groups
preserve
*replace teachers_male=0 if teachers_male==. & teachers!=.
*gen w_teachers=teachers-teachers_male
drop teachers_pc
gen teachers_pc=teachers/pop_1930*10000

gen popsharewomen_agegroup1=popsharewomen_agegroup1_1940
gen popsharewomen_agegroup2=popsharewomen_agegroup2_1940
gen popsharewomen_agegroup3=popsharewomen_agegroup3_1940+popsharewomen_agegroup4_1940+popsharewomen_agegroup5_1940
gen popsharemen_agegroup1=popsharemen_agegroup1_1940
gen popsharemen_agegroup2=popsharemen_agegroup2_1940
gen popsharemen_agegroup3=popsharemen_agegroup3_1940+popsharemen_agegroup4_1940+popsharemen_agegroup5_1940
gen flag4=(alive_birth/(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940))*1000
gen flag6=(total_wedding/(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940))*1000
foreach x of varlist  flag4 flag6 {

forvalues i=1(1)3 {
	
drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
gen sum`i'=popsharewomen_agegroup`i'
gen sum2`i'=popsharemen_agegroup`i' 

*drop if year<1941

gen interaction=post*sum`i'*teachers_pc
gen interaction2=post*sum2`i'*teachers_pc


label var interaction "Treat (W) X Post"
label var interaction2 "Treat (M) X Post"

if  "`x'"== "flag4"{
			local name2 = "Alive births per 1,000 inh."
			local tit = "Births"

		}

		else if  "`x'"== "flag6"{
			local name2 = "Weddings per 1,000 inh."
			local tit = "Weddings"
		}
		

if `i'==1 &  "`x'"== "flag4" {
local name = "0-5"
reghdfe `x'  interaction interaction2 1.post##1.sum`i'##c.teachers_pc 1.post##1.sum2`i'##c.teachers_pc, a(i.id i.year ) cluster(id) 
outreg2 using $Results\table_reg_female, dec(3)  label nonotes addtext( Mun. FE, YES, Prov. X Year FE, YES, Cohort, `name')  ct("`tit'") tex(frag) keep(interaction interaction2) nocons replace
*egen idprovinceyear= group(codprov year)
*
reghdfe `x' b1945.year##1.sum`i'##c.teachers_pc  b1945.year##1.sum2`i'##c.teachers_pc, a(i.id i.year) cluster(id) 

coefplot , keep(*.year#1.sum`i'#c.teachers_pc) vertical base omitted  yline(0, lc(red) lp(dash)) xline(16, lcolor(blue) lpattern(dash)) ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) title("`name'", s(small) c(black)) ytitle("`name2'", s(vsmall)) scheme(s2mono) xlabel(, angle(45) labs(tiny))   ///
coeflabels( ///
1930.year#1.sum`i'#c.teachers_pc= "1930" ///  
1931.year#1.sum`i'#c.teachers_pc= "1931" ///
1932.year#1.sum`i'#c.teachers_pc= "1932" ///
1933.year#1.sum`i'#c.teachers_pc= "1933" ///
1934.year#1.sum`i'#c.teachers_pc= "1934" ///
1935.year#1.sum`i'#c.teachers_pc= "1935" ///
1936.year#1.sum`i'#c.teachers_pc= "1936" ///
1937.year#1.sum`i'#c.teachers_pc= "1937" ///
1938.year#1.sum`i'#c.teachers_pc= "1938" ///
1939.year#1.sum`i'#c.teachers_pc= "1939" ///
1940.year#1.sum`i'#c.teachers_pc= "1940" ///
1941.year#1.sum`i'#c.teachers_pc= "1941" ///
1942.year#1.sum`i'#c.teachers_pc= "1942" ///
1943.year#1.sum`i'#c.teachers_pc= "1943" ///
1944.year#1.sum`i'#c.teachers_pc= "1944" ///
1945.year#1.sum`i'#c.teachers_pc= "1945" ///
1946.year#1.sum`i'#c.teachers_pc= "1946" ///
1947.year#1.sum`i'#c.teachers_pc= "1947" ///
1948.year#1.sum`i'#c.teachers_pc= "1948" ///
1949.year#1.sum`i'#c.teachers_pc= "1949" ///
1950.year#1.sum`i'#c.teachers_pc= "1950" ///
1951.year#1.sum`i'#c.teachers_pc= "1951" ///
1952.year#1.sum`i'#c.teachers_pc= "1952" ///
1953.year#1.sum`i'#c.teachers_pc= "1953" ///
1954.year#1.sum`i'#c.teachers_pc= "1954" ///
1955.year#1.sum`i'#c.teachers_pc= "1955" ///
1956.year#1.sum`i'#c.teachers_pc= "1956" ///
1957.year#1.sum`i'#c.teachers_pc= "1957" ///
1958.year#1.sum`i'#c.teachers_pc= "1958" ///
1959.year#1.sum`i'#c.teachers_pc= "1959" ///
1960.year#1.sum`i'#c.teachers_pc= "1960" ///
1961.year#1.sum`i'#c.teachers_pc= "1961" ///
1962.year#1.sum`i'#c.teachers_pc= "1962" ///
1963.year#1.sum`i'#c.teachers_pc= "1963" ///
1964.year#1.sum`i'#c.teachers_pc= "1964" ///
1965.year#1.sum`i'#c.teachers_pc= "1965" ///
1966.year#1.sum`i'#c.teachers_pc= "1966" ///
1967.year#1.sum`i'#c.teachers_pc= "1967" ///
1968.year#1.sum`i'#c.teachers_pc= "1968" ///
1969.year#1.sum`i'#c.teachers_pc= "1969" ///
1970.year#1.sum`i'#c.teachers_pc= "1970" ///
1971.year#1.sum`i'#c.teachers_pc= "1971" ///
1972.year#1.sum`i'#c.teachers_pc= "1972" ///
1973.year#1.sum`i'#c.teachers_pc= "1973" ///
1974.year#1.sum`i'#c.teachers_pc= "1974" ///
1975.year#1.sum`i'#c.teachers_pc= "1975" ///
1976.year#1.sum`i'#c.teachers_pc= "1976" ///
1977.year#1.sum`i'#c.teachers_pc= "1977" ///
1978.year#1.sum`i'#c.teachers_pc= "1978" ///
1979.year#1.sum`i'#c.teachers_pc= "1979" ///
1980.year#1.sum`i'#c.teachers_pc= "1980" ///
1981.year#1.sum`i'#c.teachers_pc= "1981" ///
1982.year#1.sum`i'#c.teachers_pc= "1982" ///
1983.year#1.sum`i'#c.teachers_pc= "1983" ///
1984.year#1.sum`i'#c.teachers_pc= "1984" ///
1985.year#1.sum`i'#c.teachers_pc= "1985" ///
) ///

graph save $Results\event_1940_`x'`i'.gph,replace
graph export $Results\event_1940_`x'`i'.pdf,replace

}
else if `i'!=1 | (`i'==1 &  "`x'"== "flag6") {
if `i'==1 {
local name = "0-5"
}	
if `i'==2 {
local name = "6-14"
}
else if `i'==3 {
local name = "15-44"
}

reghdfe `x'  interaction interaction2 1.post##1.sum`i'##c.teachers_pc 1.post##1.sum2`i'##c.teachers_pc, a(i.id i.year ) cluster(id) 
outreg2 using $Results\table_reg_female, dec(3)  label nonotes addtext( Mun. FE, YES, Prov. X Year FE, YES, Cohort, `name')  ct("`tit'") tex(frag) keep(interaction interaction2) nocons 
*egen idprovinceyear= group(codprov year)
*
reghdfe `x' b1945.year##1.sum`i'##c.teachers_pc  b1945.year##1.sum2`i'##c.teachers_pc, a(i.id i.year ) cluster(id) 

coefplot , keep(*.year#1.sum`i'#c.teachers_pc) vertical base omitted  yline(0, lc(red) lp(dash)) xline(16, lcolor(blue) lpattern(dash)) ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) title("`name'", s(small) c(black)) ytitle("`name2'", s(vsmall)) scheme(s2mono) xlabel(, angle(45) labs(tiny))   ///
coeflabels( ///
1930.year#1.sum`i'#c.teachers_pc= "1930" ///  
1931.year#1.sum`i'#c.teachers_pc= "1931" ///
1932.year#1.sum`i'#c.teachers_pc= "1932" ///
1933.year#1.sum`i'#c.teachers_pc= "1933" ///
1934.year#1.sum`i'#c.teachers_pc= "1934" ///
1935.year#1.sum`i'#c.teachers_pc= "1935" ///
1936.year#1.sum`i'#c.teachers_pc= "1936" ///
1937.year#1.sum`i'#c.teachers_pc= "1937" ///
1938.year#1.sum`i'#c.teachers_pc= "1938" ///
1939.year#1.sum`i'#c.teachers_pc= "1939" ///
1940.year#1.sum`i'#c.teachers_pc= "1940" ///
1941.year#1.sum`i'#c.teachers_pc= "1941" ///
1942.year#1.sum`i'#c.teachers_pc= "1942" ///
1943.year#1.sum`i'#c.teachers_pc= "1943" ///
1944.year#1.sum`i'#c.teachers_pc= "1944" ///
1945.year#1.sum`i'#c.teachers_pc= "1945" ///
1946.year#1.sum`i'#c.teachers_pc= "1946" ///
1947.year#1.sum`i'#c.teachers_pc= "1947" ///
1948.year#1.sum`i'#c.teachers_pc= "1948" ///
1949.year#1.sum`i'#c.teachers_pc= "1949" ///
1950.year#1.sum`i'#c.teachers_pc= "1950" ///
1951.year#1.sum`i'#c.teachers_pc= "1951" ///
1952.year#1.sum`i'#c.teachers_pc= "1952" ///
1953.year#1.sum`i'#c.teachers_pc= "1953" ///
1954.year#1.sum`i'#c.teachers_pc= "1954" ///
1955.year#1.sum`i'#c.teachers_pc= "1955" ///
1956.year#1.sum`i'#c.teachers_pc= "1956" ///
1957.year#1.sum`i'#c.teachers_pc= "1957" ///
1958.year#1.sum`i'#c.teachers_pc= "1958" ///
1959.year#1.sum`i'#c.teachers_pc= "1959" ///
1960.year#1.sum`i'#c.teachers_pc= "1960" ///
1961.year#1.sum`i'#c.teachers_pc= "1961" ///
1962.year#1.sum`i'#c.teachers_pc= "1962" ///
1963.year#1.sum`i'#c.teachers_pc= "1963" ///
1964.year#1.sum`i'#c.teachers_pc= "1964" ///
1965.year#1.sum`i'#c.teachers_pc= "1965" ///
1966.year#1.sum`i'#c.teachers_pc= "1966" ///
1967.year#1.sum`i'#c.teachers_pc= "1967" ///
1968.year#1.sum`i'#c.teachers_pc= "1968" ///
1969.year#1.sum`i'#c.teachers_pc= "1969" ///
1970.year#1.sum`i'#c.teachers_pc= "1970" ///
1971.year#1.sum`i'#c.teachers_pc= "1971" ///
1972.year#1.sum`i'#c.teachers_pc= "1972" ///
1973.year#1.sum`i'#c.teachers_pc= "1973" ///
1974.year#1.sum`i'#c.teachers_pc= "1974" ///
1975.year#1.sum`i'#c.teachers_pc= "1975" ///
1976.year#1.sum`i'#c.teachers_pc= "1976" ///
1977.year#1.sum`i'#c.teachers_pc= "1977" ///
1978.year#1.sum`i'#c.teachers_pc= "1978" ///
1979.year#1.sum`i'#c.teachers_pc= "1979" ///
1980.year#1.sum`i'#c.teachers_pc= "1980" ///
1981.year#1.sum`i'#c.teachers_pc= "1981" ///
1982.year#1.sum`i'#c.teachers_pc= "1982" ///
1983.year#1.sum`i'#c.teachers_pc= "1983" ///
1984.year#1.sum`i'#c.teachers_pc= "1984" ///
1985.year#1.sum`i'#c.teachers_pc= "1985" ///
) ///

graph save $Results\event_1940_`x'`i'.gph,replace
graph export $Results\event_1940_`x'`i'.pdf,replace
}
drop interaction interaction2 sum*
}
}
restore

cd $Results\
graph combine event_1940_flag41.gph event_1940_flag42.gph event_1940_flag43.gph, graphregion(color(white)) ycommon title("Births", s(small) c(black)) r(1)
graph save event_1940_female_fertility.gph, replace 


cd $Results\
graph combine event_1940_flag61.gph event_1940_flag62.gph event_1940_flag63.gph, graphregion(color(white)) ycommon title("Weddings", s(small) c(black)) r(1)
graph save event_1940_female_wedding.gph, replace 

cd $Results\
graph combine event_1940_female_fertility.gph event_1940_female_wedding.gph, graphregion(color(white)) r(2)
graph export event_1940_female_threegroups.pdf, replace
*/


* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
**# 3. Regression -- By gender  -- PLACEBO
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
clear all					
global dir "C:\Users\laxge\Dropbox\GEMA\RESEARCH\" // portatil

cd $dir
global Do 				"PURGE\progs"
global Output_data 		"PURGE\output_data"
global Data 			"PURGE\original_data"
global Results 			"PURGE\results"
use "$Output_data/dataset.dta", clear

* Female
gen popsharewomen_agegroup1=popsharewomen_agegroup1_1930+popsharewomen_agegroup2_1930
gen popsharewomen_agegroup2=popsharewomen_agegroup3_1930+popsharewomen_agegroup4_1930+popsharewomen_agegroup5_1930

sum popsharewomen_agegroup1,d
gen median_popw1=popsharewomen_agegroup1>r(p50) & popsharewomen_agegroup1!=.
sum popsharewomen_agegroup2,d
gen median_popw2=popsharewomen_agegroup2>r(p50) & popsharewomen_agegroup2!=.

* Male
gen popsharemen_agegroup1=popsharemen_agegroup1_1930+popsharemen_agegroup2_1930
gen popsharemen_agegroup2=popsharemen_agegroup3_1930+popsharemen_agegroup4_1930+popsharemen_agegroup5_1930
sum popsharemen_agegroup1,d
gen median_popm1=popsharemen_agegroup1>r(p50) & popsharemen_agegroup1!=.
sum popsharemen_agegroup2,d
gen median_popm2=popsharemen_agegroup2>r(p50) & popsharemen_agegroup2!=.

* Dependent variables
gen flag4=(alive_birth/(popwomen_agegroup3_1930 +popwomen_agegroup4_1930 +popwomen_agegroup5_1930))*1000
gen flag6=(total_wedding/(popwomen_agegroup3_1930 +popwomen_agegroup4_1930 +popwomen_agegroup5_1930))*1000

foreach x of varlist  flag4 flag6  {

forvalues i=1(1)2 {
sum `x' if median_popw`i' ==0 & median_tea==0
local mean_depvar = r(mean)
		
drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
gen sum`i'=median_popw`i'
gen sum2`i'=median_popm`i' 

gen interaction=post*sum`i'*median_tea
gen interaction2=post*sum2`i'*median_tea


label var interaction "Treat (W) X Post"
label var interaction2 "Treat (M) X Post"

gen post_sum`i'=post*sum`i'
gen post_sum2`i'=post*sum2`i'
gen post_teachers=post*median_tea
        label var post_sum`i' "Female pop (Age `agegroup') X Post 1945 - `outcome'"
        label var post_sum2`i' "Male pop (Age `agegroup') X Post 1945 - `outcome'"
        label var post_teachers "Teachers X Post"
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
reghdfe `x' post_sum`i' post_sum2`i' median_tea interaction interaction2 1.post##1.sum`i'##1.median_tea 1.post##1.sum2`i'##1.median_tea, a(i.id i.year) cluster(id) 
outreg2 using $Results/median/table_reg_female_placebo, dec(3)  label nonotes addtext( Mun. FE, YES, Prov. X Year FE, YES, Cohort, `name')  ct("`tit'") tex(frag) keep(interaction ) nocons replace  addstat(Mean of depvar, `mean_depvar')
*egen idprovinceyear= group(codprov year)
*
reghdfe `x' b1945.year##1.sum`i'##1.median_tea  b1945.year##1.sum2`i'##1.median_tea, a(i.id i.year ) cluster(id) 

coefplot , keep(*.year#1.sum`i'#1.median_tea) vertical base omitted  yline(0, lc(red) lp(dash)) xline(16, lcolor(blue) lpattern(dash)) ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) title("`name'", s(small) c(black)) ytitle("`name2'", s(vsmall)) scheme(s2mono) xlabel(, angle(45) labs(tiny))   ///
coeflabels( ///
1930.year#1.sum`i'#1.median_tea= "1930" ///  
1931.year#1.sum`i'#1.median_tea= "1931" ///
1932.year#1.sum`i'#1.median_tea= "1932" ///
1933.year#1.sum`i'#1.median_tea= "1933" ///
1934.year#1.sum`i'#1.median_tea= "1934" ///
1935.year#1.sum`i'#1.median_tea= "1935" ///
1936.year#1.sum`i'#1.median_tea= "1936" ///
1937.year#1.sum`i'#1.median_tea= "1937" ///
1938.year#1.sum`i'#1.median_tea= "1938" ///
1939.year#1.sum`i'#1.median_tea= "1939" ///
1940.year#1.sum`i'#1.median_tea= "1940" ///
1941.year#1.sum`i'#1.median_tea= "1941" ///
1942.year#1.sum`i'#1.median_tea= "1942" ///
1943.year#1.sum`i'#1.median_tea= "1943" ///
1944.year#1.sum`i'#1.median_tea= "1944" ///
1945.year#1.sum`i'#1.median_tea= "1945" ///
1946.year#1.sum`i'#1.median_tea= "1946" ///
1947.year#1.sum`i'#1.median_tea= "1947" ///
1948.year#1.sum`i'#1.median_tea= "1948" ///
1949.year#1.sum`i'#1.median_tea= "1949" ///
1950.year#1.sum`i'#1.median_tea= "1950" ///
1951.year#1.sum`i'#1.median_tea= "1951" ///
1952.year#1.sum`i'#1.median_tea= "1952" ///
1953.year#1.sum`i'#1.median_tea= "1953" ///
1954.year#1.sum`i'#1.median_tea= "1954" ///
1955.year#1.sum`i'#1.median_tea= "1955" ///
1956.year#1.sum`i'#1.median_tea= "1956" ///
1957.year#1.sum`i'#1.median_tea= "1957" ///
1958.year#1.sum`i'#1.median_tea= "1958" ///
1959.year#1.sum`i'#1.median_tea= "1959" ///
1960.year#1.sum`i'#1.median_tea= "1960" ///
1961.year#1.sum`i'#1.median_tea= "1961" ///
1962.year#1.sum`i'#1.median_tea= "1962" ///
1963.year#1.sum`i'#1.median_tea= "1963" ///
1964.year#1.sum`i'#1.median_tea= "1964" ///
1965.year#1.sum`i'#1.median_tea= "1965" ///
1966.year#1.sum`i'#1.median_tea= "1966" ///
1967.year#1.sum`i'#1.median_tea= "1967" ///
1968.year#1.sum`i'#1.median_tea= "1968" ///
1969.year#1.sum`i'#1.median_tea= "1969" ///
1970.year#1.sum`i'#1.median_tea= "1970" ///
1971.year#1.sum`i'#1.median_tea= "1971" ///
1972.year#1.sum`i'#1.median_tea= "1972" ///
1973.year#1.sum`i'#1.median_tea= "1973" ///
1974.year#1.sum`i'#1.median_tea= "1974" ///
1975.year#1.sum`i'#1.median_tea= "1975" ///
1976.year#1.sum`i'#1.median_tea= "1976" ///
1977.year#1.sum`i'#1.median_tea= "1977" ///
1978.year#1.sum`i'#1.median_tea= "1978" ///
1979.year#1.sum`i'#1.median_tea= "1979" ///
1980.year#1.sum`i'#1.median_tea= "1980" ///
1981.year#1.sum`i'#1.median_tea= "1981" ///
1982.year#1.sum`i'#1.median_tea= "1982" ///
1983.year#1.sum`i'#1.median_tea= "1983" ///
1984.year#1.sum`i'#1.median_tea= "1984" ///
1985.year#1.sum`i'#1.median_tea= "1985" ///
) ///

graph save $Results/median/event_1930_`x'`i'.gph,replace
graph export $Results/median/event_1930_`x'`i'.pdf,replace

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

reghdfe `x' post_sum`i' post_sum2`i' interaction interaction2 1.post##1.sum`i'##1.median_tea 1.post##1.sum2`i'##1.median_tea, a(i.id i.year) cluster(id) 
outreg2 using $Results/median/table_reg_female_placebo, dec(3)  label nonotes addtext( Mun. FE, YES, Prov. X Year FE, YES, Cohort, `name')  ct("`tit'") tex(frag) keep(interaction ) nocons  addstat(Mean of depvar, `mean_depvar')
*
reghdfe `x' b1945.year##1.sum`i'##1.median_tea  b1945.year##1.sum2`i'##1.median_tea, a(i.id i.year ) cluster(id) 

coefplot , keep(*.year#1.sum`i'#1.median_tea) vertical base omitted  yline(0, lc(red) lp(dash)) xline(16, lcolor(blue) lpattern(dash)) ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) title("`name'", s(small) c(black)) ytitle("`name2'", s(vsmall)) scheme(s2mono) xlabel(, angle(45) labs(tiny))   ///
coeflabels( ///
1930.year#1.sum`i'#1.median_tea= "1930" ///  
1931.year#1.sum`i'#1.median_tea= "1931" ///
1932.year#1.sum`i'#1.median_tea= "1932" ///
1933.year#1.sum`i'#1.median_tea= "1933" ///
1934.year#1.sum`i'#1.median_tea= "1934" ///
1935.year#1.sum`i'#1.median_tea= "1935" ///
1936.year#1.sum`i'#1.median_tea= "1936" ///
1937.year#1.sum`i'#1.median_tea= "1937" ///
1938.year#1.sum`i'#1.median_tea= "1938" ///
1939.year#1.sum`i'#1.median_tea= "1939" ///
1940.year#1.sum`i'#1.median_tea= "1940" ///
1941.year#1.sum`i'#1.median_tea= "1941" ///
1942.year#1.sum`i'#1.median_tea= "1942" ///
1943.year#1.sum`i'#1.median_tea= "1943" ///
1944.year#1.sum`i'#1.median_tea= "1944" ///
1945.year#1.sum`i'#1.median_tea= "1945" ///
1946.year#1.sum`i'#1.median_tea= "1946" ///
1947.year#1.sum`i'#1.median_tea= "1947" ///
1948.year#1.sum`i'#1.median_tea= "1948" ///
1949.year#1.sum`i'#1.median_tea= "1949" ///
1950.year#1.sum`i'#1.median_tea= "1950" ///
1951.year#1.sum`i'#1.median_tea= "1951" ///
1952.year#1.sum`i'#1.median_tea= "1952" ///
1953.year#1.sum`i'#1.median_tea= "1953" ///
1954.year#1.sum`i'#1.median_tea= "1954" ///
1955.year#1.sum`i'#1.median_tea= "1955" ///
1956.year#1.sum`i'#1.median_tea= "1956" ///
1957.year#1.sum`i'#1.median_tea= "1957" ///
1958.year#1.sum`i'#1.median_tea= "1958" ///
1959.year#1.sum`i'#1.median_tea= "1959" ///
1960.year#1.sum`i'#1.median_tea= "1960" ///
1961.year#1.sum`i'#1.median_tea= "1961" ///
1962.year#1.sum`i'#1.median_tea= "1962" ///
1963.year#1.sum`i'#1.median_tea= "1963" ///
1964.year#1.sum`i'#1.median_tea= "1964" ///
1965.year#1.sum`i'#1.median_tea= "1965" ///
1966.year#1.sum`i'#1.median_tea= "1966" ///
1967.year#1.sum`i'#1.median_tea= "1967" ///
1968.year#1.sum`i'#1.median_tea= "1968" ///
1969.year#1.sum`i'#1.median_tea= "1969" ///
1970.year#1.sum`i'#1.median_tea= "1970" ///
1971.year#1.sum`i'#1.median_tea= "1971" ///
1972.year#1.sum`i'#1.median_tea= "1972" ///
1973.year#1.sum`i'#1.median_tea= "1973" ///
1974.year#1.sum`i'#1.median_tea= "1974" ///
1975.year#1.sum`i'#1.median_tea= "1975" ///
1976.year#1.sum`i'#1.median_tea= "1976" ///
1977.year#1.sum`i'#1.median_tea= "1977" ///
1978.year#1.sum`i'#1.median_tea= "1978" ///
1979.year#1.sum`i'#1.median_tea= "1979" ///
1980.year#1.sum`i'#1.median_tea= "1980" ///
1981.year#1.sum`i'#1.median_tea= "1981" ///
1982.year#1.sum`i'#1.median_tea= "1982" ///
1983.year#1.sum`i'#1.median_tea= "1983" ///
1984.year#1.sum`i'#1.median_tea= "1984" ///
1985.year#1.sum`i'#1.median_tea= "1985" ///
) ///

graph save $Results/median/event_1930_`x'`i'.gph,replace
graph export $Results/median/event_1930_`x'`i'.pdf,replace
}
drop interaction interaction2 sum* post_*
}
}

cd $Results/median/
graph combine event_1930_flag41.gph event_1930_flag42.gph, graphregion(color(white)) ycommon title("Births", s(small) c(black)) r(1)
graph save event_1930_female_fertility.gph, replace 
graph export event_1930_female_fertility.pdf, replace

graph combine event_1930_flag61.gph event_1930_flag62.gph , graphregion(color(white)) ycommon title("Weddings", s(small) c(black)) r(1)
graph save event_1930_female_wedding.gph, replace 
graph export event_1930_female_wedding.pdf, replace

graph combine event_1930_female_fertility.gph event_1930_female_wedding.gph, graphregion(color(white)) r(2)
graph export event_1930_female.pdf, replace


* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
**# 1. WEDDINGS Regression -- By gender 
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
clear all					
global dir "C:\Users\laxge\Dropbox\GEMA\RESEARCH\" // portatil

cd $dir
global Do 				"PURGE\progs"
global Output_data 		"PURGE\output_data"
global Data 			"PURGE\original_data"
global Results 			"PURGE\results"
use "$Output_data/dataset.dta", clear

* Female
gen popsharewomen_agegroup1=popsharewomen_agegroup1_1940+popsharewomen_agegroup2_1940
gen popsharewomen_agegroup2=popsharewomen_agegroup3_1940+popsharewomen_agegroup4_1940+popsharewomen_agegroup5_1940

sum popsharewomen_agegroup1,d
gen median_popw1=popsharewomen_agegroup1>r(p50) & popsharewomen_agegroup1!=.
sum popsharewomen_agegroup2,d
gen median_popw2=popsharewomen_agegroup2>r(p50) & popsharewomen_agegroup2!=.

* Male
gen popsharemen_agegroup1=popsharemen_agegroup1_1940+popsharemen_agegroup2_1940
gen popsharemen_agegroup2=popsharemen_agegroup3_1940+popsharemen_agegroup4_1940+popsharemen_agegroup5_1940

sum popsharemen_agegroup1,d
gen median_popm1=popsharemen_agegroup1>r(p50) & popsharemen_agegroup1!=.
sum popsharemen_agegroup2,d
gen median_popm2=popsharemen_agegroup2>r(p50) & popsharemen_agegroup2!=.

* Dependent variables
gen flag4=(alive_birth/(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940))*1000
gen flag6=(total_wedding/(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940))*1000

foreach x of varlist  flag6 {

forvalues i=1(1)2 {
sum `x' if median_popw`i' ==0 & median_tea==0
local mean_depvar = r(mean)
		
drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
gen sum`i'=median_popw`i'
gen sum2`i'=median_popm`i' 

gen interaction=post*sum`i'*median_tea
gen interaction2=post*sum2`i'*median_tea

gen post_sum`i'=post*sum`i'
gen post_sum2`i'=post*sum2`i'
gen post_teachers=post*median_tea

label var interaction "Treat (W) X Post"
label var interaction2 "Treat (M) X Post"
label var post_sum`i' "Female pop X Post"
label var post_sum2`i' "Male pop X Post"
label var post_teachers "Teachers X Post"
if  "`x'"== "flag4"{
			local name2 = "Alive births per 1,000 inh."
			local tit = "Births"

			label var post_sum`i' "Female pop X Post"
			label var post_sum2`i' "Male pop X Post"
		}

		else if  "`x'"== "flag6"{
			local name2 = "Weddings per 1,000 inh."
			local tit = "Weddings"
			
			label var post_sum`i' "Female pop X Post"
			label var post_sum2`i' "Male pop X Post"
		}
		

if `i'==1 &  "`x'"== "flag4" {
local name = "0-14"
reghdfe `x' post_sum`i' post_sum2`i' post_teachers interaction interaction2 1.post##1.sum`i'##1.median_tea 1.post##1.sum2`i'##1.median_tea, a(i.id i.year ) cluster(id) 

outreg2 using $Results\median\table_reg_female_weddings, dec(3)  label nonotes addtext( Mun. FE, YES, Prov. X Year FE, YES, Cohort, `name')  ct("`tit'") tex(frag) keep(interaction ) nocons replace  addstat(Mean of depvar, `mean_depvar')

*drop interaction interaction2 sum* post_*

*
reghdfe `x' b1945.year##1.sum`i'##1.median_tea  b1945.year##1.sum2`i'##1.median_tea, a(i.id i.year ) cluster(id) 

coefplot , keep(*.year#1.sum`i'#1.median_tea) vertical base omitted  yline(0, lc(red) lp(dash)) xline(16, lcolor(blue) lpattern(dash)) ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) title("`name'", s(small) c(black)) ytitle("`name2'", s(vsmall)) scheme(s2mono) xlabel(, angle(45) labs(tiny))   ///
coeflabels( ///
1930.year#1.sum`i'#1.median_tea= "1930" ///  
1931.year#1.sum`i'#1.median_tea= "1931" ///
1932.year#1.sum`i'#1.median_tea= "1932" ///
1933.year#1.sum`i'#1.median_tea= "1933" ///
1934.year#1.sum`i'#1.median_tea= "1934" ///
1935.year#1.sum`i'#1.median_tea= "1935" ///
1936.year#1.sum`i'#1.median_tea= "1936" ///
1937.year#1.sum`i'#1.median_tea= "1937" ///
1938.year#1.sum`i'#1.median_tea= "1938" ///
1939.year#1.sum`i'#1.median_tea= "1939" ///
1940.year#1.sum`i'#1.median_tea= "1940" ///
1941.year#1.sum`i'#1.median_tea= "1941" ///
1942.year#1.sum`i'#1.median_tea= "1942" ///
1943.year#1.sum`i'#1.median_tea= "1943" ///
1944.year#1.sum`i'#1.median_tea= "1944" ///
1945.year#1.sum`i'#1.median_tea= "1945" ///
1946.year#1.sum`i'#1.median_tea= "1946" ///
1947.year#1.sum`i'#1.median_tea= "1947" ///
1948.year#1.sum`i'#1.median_tea= "1948" ///
1949.year#1.sum`i'#1.median_tea= "1949" ///
1950.year#1.sum`i'#1.median_tea= "1950" ///
1951.year#1.sum`i'#1.median_tea= "1951" ///
1952.year#1.sum`i'#1.median_tea= "1952" ///
1953.year#1.sum`i'#1.median_tea= "1953" ///
1954.year#1.sum`i'#1.median_tea= "1954" ///
1955.year#1.sum`i'#1.median_tea= "1955" ///
1956.year#1.sum`i'#1.median_tea= "1956" ///
1957.year#1.sum`i'#1.median_tea= "1957" ///
1958.year#1.sum`i'#1.median_tea= "1958" ///
1959.year#1.sum`i'#1.median_tea= "1959" ///
1960.year#1.sum`i'#1.median_tea= "1960" ///
1961.year#1.sum`i'#1.median_tea= "1961" ///
1962.year#1.sum`i'#1.median_tea= "1962" ///
1963.year#1.sum`i'#1.median_tea= "1963" ///
1964.year#1.sum`i'#1.median_tea= "1964" ///
1965.year#1.sum`i'#1.median_tea= "1965" ///
1966.year#1.sum`i'#1.median_tea= "1966" ///
1967.year#1.sum`i'#1.median_tea= "1967" ///
1968.year#1.sum`i'#1.median_tea= "1968" ///
1969.year#1.sum`i'#1.median_tea= "1969" ///
1970.year#1.sum`i'#1.median_tea= "1970" ///
1971.year#1.sum`i'#1.median_tea= "1971" ///
1972.year#1.sum`i'#1.median_tea= "1972" ///
1973.year#1.sum`i'#1.median_tea= "1973" ///
1974.year#1.sum`i'#1.median_tea= "1974" ///
1975.year#1.sum`i'#1.median_tea= "1975" ///
1976.year#1.sum`i'#1.median_tea= "1976" ///
1977.year#1.sum`i'#1.median_tea= "1977" ///
1978.year#1.sum`i'#1.median_tea= "1978" ///
1979.year#1.sum`i'#1.median_tea= "1979" ///
1980.year#1.sum`i'#1.median_tea= "1980" ///
1981.year#1.sum`i'#1.median_tea= "1981" ///
1982.year#1.sum`i'#1.median_tea= "1982" ///
1983.year#1.sum`i'#1.median_tea= "1983" ///
1984.year#1.sum`i'#1.median_tea= "1984" ///
1985.year#1.sum`i'#1.median_tea= "1985" ///
) ///

graph save $Results/median/event_1940_`x'`i'.gph,replace
graph export $Results/median/event_1940_`x'`i'.pdf,replace

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

reghdfe `x' post_sum`i' post_sum2`i' post_teachers interaction interaction2 1.post##1.sum`i'##1.median_tea 1.post##1.sum2`i'##1.median_tea, a(i.id i.year  ) cluster(id) 
outreg2 using $Results/median/table_reg_female_weddings, dec(3)  label nonotes addtext( Mun. FE, YES, Prov. X Year FE, YES, Cohort, `name')  ct("`tit'") tex(frag) keep(interaction ) nocons  addstat(Mean of depvar, `mean_depvar')

reghdfe `x' b1945.year##1.sum`i'##1.median_tea  b1945.year##1.sum2`i'##1.median_tea, a(i.id i.year) cluster(id) 

coefplot , keep(*.year#1.sum`i'#1.median_tea) vertical base omitted  yline(0, lc(red) lp(dash)) xline(16, lcolor(blue) lpattern(dash)) ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) title("`name'", s(small) c(black)) ytitle("`name2'", s(vsmall)) scheme(s2mono) xlabel(, angle(45) labs(tiny))   ///
coeflabels( ///
1930.year#1.sum`i'#1.median_tea= "1930" ///  
1931.year#1.sum`i'#1.median_tea= "1931" ///
1932.year#1.sum`i'#1.median_tea= "1932" ///
1933.year#1.sum`i'#1.median_tea= "1933" ///
1934.year#1.sum`i'#1.median_tea= "1934" ///
1935.year#1.sum`i'#1.median_tea= "1935" ///
1936.year#1.sum`i'#1.median_tea= "1936" ///
1937.year#1.sum`i'#1.median_tea= "1937" ///
1938.year#1.sum`i'#1.median_tea= "1938" ///
1939.year#1.sum`i'#1.median_tea= "1939" ///
1940.year#1.sum`i'#1.median_tea= "1940" ///
1941.year#1.sum`i'#1.median_tea= "1941" ///
1942.year#1.sum`i'#1.median_tea= "1942" ///
1943.year#1.sum`i'#1.median_tea= "1943" ///
1944.year#1.sum`i'#1.median_tea= "1944" ///
1945.year#1.sum`i'#1.median_tea= "1945" ///
1946.year#1.sum`i'#1.median_tea= "1946" ///
1947.year#1.sum`i'#1.median_tea= "1947" ///
1948.year#1.sum`i'#1.median_tea= "1948" ///
1949.year#1.sum`i'#1.median_tea= "1949" ///
1950.year#1.sum`i'#1.median_tea= "1950" ///
1951.year#1.sum`i'#1.median_tea= "1951" ///
1952.year#1.sum`i'#1.median_tea= "1952" ///
1953.year#1.sum`i'#1.median_tea= "1953" ///
1954.year#1.sum`i'#1.median_tea= "1954" ///
1955.year#1.sum`i'#1.median_tea= "1955" ///
1956.year#1.sum`i'#1.median_tea= "1956" ///
1957.year#1.sum`i'#1.median_tea= "1957" ///
1958.year#1.sum`i'#1.median_tea= "1958" ///
1959.year#1.sum`i'#1.median_tea= "1959" ///
1960.year#1.sum`i'#1.median_tea= "1960" ///
1961.year#1.sum`i'#1.median_tea= "1961" ///
1962.year#1.sum`i'#1.median_tea= "1962" ///
1963.year#1.sum`i'#1.median_tea= "1963" ///
1964.year#1.sum`i'#1.median_tea= "1964" ///
1965.year#1.sum`i'#1.median_tea= "1965" ///
1966.year#1.sum`i'#1.median_tea= "1966" ///
1967.year#1.sum`i'#1.median_tea= "1967" ///
1968.year#1.sum`i'#1.median_tea= "1968" ///
1969.year#1.sum`i'#1.median_tea= "1969" ///
1970.year#1.sum`i'#1.median_tea= "1970" ///
1971.year#1.sum`i'#1.median_tea= "1971" ///
1972.year#1.sum`i'#1.median_tea= "1972" ///
1973.year#1.sum`i'#1.median_tea= "1973" ///
1974.year#1.sum`i'#1.median_tea= "1974" ///
1975.year#1.sum`i'#1.median_tea= "1975" ///
1976.year#1.sum`i'#1.median_tea= "1976" ///
1977.year#1.sum`i'#1.median_tea= "1977" ///
1978.year#1.sum`i'#1.median_tea= "1978" ///
1979.year#1.sum`i'#1.median_tea= "1979" ///
1980.year#1.sum`i'#1.median_tea= "1980" ///
1981.year#1.sum`i'#1.median_tea= "1981" ///
1982.year#1.sum`i'#1.median_tea= "1982" ///
1983.year#1.sum`i'#1.median_tea= "1983" ///
1984.year#1.sum`i'#1.median_tea= "1984" ///
1985.year#1.sum`i'#1.median_tea= "1985" ///
) ///

graph save $Results/median/event_1940_`x'`i'.gph,replace
graph export $Results/median/event_1940_`x'`i'.pdf,replace
}
drop interaction interaction2 sum* post_*
}
}

cd $Results\median\

graph combine event_1940_flag41.gph event_1940_flag42.gph , graphregion(color(white)) ycommon title("Births", s(small) c(black)) r(1)
graph save event_1940_female_fertility.gph, replace 

graph combine event_1940_flag61.gph event_1940_flag62.gph , graphregion(color(white)) ycommon title("Weddings", s(small) c(black)) r(1)
graph save event_1940_female_wedding.gph, replace 

graph combine event_1940_female_fertility.gph event_1940_female_wedding.gph, graphregion(color(white)) r(2)
graph export event_1940_female.pdf, replace


* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
**# 2. WEDDINGS Regression -- By gender & prov*year FE
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
clear all					
global dir "C:\Users\laxge\Dropbox\GEMA\RESEARCH\" // portatil

cd $dir
global Do 				"PURGE\progs"
global Output_data 		"PURGE\output_data"
global Data 			"PURGE\original_data"
global Results 			"PURGE\results"
use "$Output_data/dataset.dta", clear

* Female
gen popsharewomen_agegroup1=popsharewomen_agegroup1_1940+popsharewomen_agegroup2_1940
gen popsharewomen_agegroup2=popsharewomen_agegroup3_1940+popsharewomen_agegroup4_1940+popsharewomen_agegroup5_1940

sum popsharewomen_agegroup1,d
gen median_popw1=popsharewomen_agegroup1>r(p50) & popsharewomen_agegroup1!=.
sum popsharewomen_agegroup2,d
gen median_popw2=popsharewomen_agegroup2>r(p50) & popsharewomen_agegroup2!=.

* Male
gen popsharemen_agegroup1=popsharemen_agegroup1_1940+popsharemen_agegroup2_1940
gen popsharemen_agegroup2=popsharemen_agegroup3_1940+popsharemen_agegroup4_1940+popsharemen_agegroup5_1940

sum popsharemen_agegroup1,d
gen median_popm1=popsharemen_agegroup1>r(p50) & popsharemen_agegroup1!=.
sum popsharemen_agegroup2,d
gen median_popm2=popsharemen_agegroup2>r(p50) & popsharemen_agegroup2!=.

* Dependent variables
gen flag4=(alive_birth/(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940))*1000
gen flag6=(total_wedding/(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940))*1000

foreach x of varlist flag6 {

forvalues i=1(1)2 {
sum `x' if median_popw`i' ==0 & median_tea==0
local mean_depvar = r(mean)
		
drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
gen sum`i'=median_popw`i'
gen sum2`i'=median_popm`i' 

gen interaction=post*sum`i'*median_tea
gen interaction2=post*sum2`i'*median_tea

gen post_sum`i'=post*sum`i'
gen post_sum2`i'=post*sum2`i'
gen post_teachers=post*median_tea

label var interaction "Treat (W) X Post"
label var interaction2 "Treat (M) X Post"
label var post_sum`i' "Female pop X Post"
label var post_sum2`i' "Male pop X Post"
label var post_teachers "Teachers X Post"
if  "`x'"== "flag4"{
			local name2 = "Alive births per 1,000 inh."
			local tit = "Births"

			label var post_sum`i' "Female pop X Post"
			label var post_sum2`i' "Male pop X Post"
		}

		else if  "`x'"== "flag6"{
			local name2 = "Weddings per 1,000 inh."
			local tit = "Weddings"
			
			label var post_sum`i' "Female pop X Post"
			label var post_sum2`i' "Male pop X Post"
		}
		

if `i'==1 &  "`x'"== "flag4" {
local name = "0-14"
reghdfe `x' post_sum`i' post_sum2`i' median_tea interaction interaction2 1.post##1.sum`i'##1.median_tea 1.post##1.sum2`i'##1.median_tea, a(i.id i.year#i.codprov ) cluster(id) 

outreg2 using $Results\median\table_reg_female_trends_weddings, dec(3)  label nonotes addtext( Mun. FE, YES, Prov. X Year FE, YES, Cohort, `name')  ct("`tit'") tex(frag) keep(interaction ) nocons replace  addstat(Mean of depvar, `mean_depvar')

*drop interaction interaction2 sum* post_*

*
reghdfe `x' b1945.year##1.sum`i'##1.median_tea  b1945.year##1.sum2`i'##1.median_tea, a(i.id i.year#i.codprov ) cluster(id) 

coefplot , keep(*.year#1.sum`i'#1.median_tea) vertical base omitted  yline(0, lc(red) lp(dash)) xline(16, lcolor(blue) lpattern(dash)) ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) title("`name'", s(small) c(black)) ytitle("`name2'", s(vsmall)) scheme(s2mono) xlabel(, angle(45) labs(tiny))   ///
coeflabels( ///
1930.year#1.sum`i'#1.median_tea= "1930" ///  
1931.year#1.sum`i'#1.median_tea= "1931" ///
1932.year#1.sum`i'#1.median_tea= "1932" ///
1933.year#1.sum`i'#1.median_tea= "1933" ///
1934.year#1.sum`i'#1.median_tea= "1934" ///
1935.year#1.sum`i'#1.median_tea= "1935" ///
1936.year#1.sum`i'#1.median_tea= "1936" ///
1937.year#1.sum`i'#1.median_tea= "1937" ///
1938.year#1.sum`i'#1.median_tea= "1938" ///
1939.year#1.sum`i'#1.median_tea= "1939" ///
1940.year#1.sum`i'#1.median_tea= "1940" ///
1941.year#1.sum`i'#1.median_tea= "1941" ///
1942.year#1.sum`i'#1.median_tea= "1942" ///
1943.year#1.sum`i'#1.median_tea= "1943" ///
1944.year#1.sum`i'#1.median_tea= "1944" ///
1945.year#1.sum`i'#1.median_tea= "1945" ///
1946.year#1.sum`i'#1.median_tea= "1946" ///
1947.year#1.sum`i'#1.median_tea= "1947" ///
1948.year#1.sum`i'#1.median_tea= "1948" ///
1949.year#1.sum`i'#1.median_tea= "1949" ///
1950.year#1.sum`i'#1.median_tea= "1950" ///
1951.year#1.sum`i'#1.median_tea= "1951" ///
1952.year#1.sum`i'#1.median_tea= "1952" ///
1953.year#1.sum`i'#1.median_tea= "1953" ///
1954.year#1.sum`i'#1.median_tea= "1954" ///
1955.year#1.sum`i'#1.median_tea= "1955" ///
1956.year#1.sum`i'#1.median_tea= "1956" ///
1957.year#1.sum`i'#1.median_tea= "1957" ///
1958.year#1.sum`i'#1.median_tea= "1958" ///
1959.year#1.sum`i'#1.median_tea= "1959" ///
1960.year#1.sum`i'#1.median_tea= "1960" ///
1961.year#1.sum`i'#1.median_tea= "1961" ///
1962.year#1.sum`i'#1.median_tea= "1962" ///
1963.year#1.sum`i'#1.median_tea= "1963" ///
1964.year#1.sum`i'#1.median_tea= "1964" ///
1965.year#1.sum`i'#1.median_tea= "1965" ///
1966.year#1.sum`i'#1.median_tea= "1966" ///
1967.year#1.sum`i'#1.median_tea= "1967" ///
1968.year#1.sum`i'#1.median_tea= "1968" ///
1969.year#1.sum`i'#1.median_tea= "1969" ///
1970.year#1.sum`i'#1.median_tea= "1970" ///
1971.year#1.sum`i'#1.median_tea= "1971" ///
1972.year#1.sum`i'#1.median_tea= "1972" ///
1973.year#1.sum`i'#1.median_tea= "1973" ///
1974.year#1.sum`i'#1.median_tea= "1974" ///
1975.year#1.sum`i'#1.median_tea= "1975" ///
1976.year#1.sum`i'#1.median_tea= "1976" ///
1977.year#1.sum`i'#1.median_tea= "1977" ///
1978.year#1.sum`i'#1.median_tea= "1978" ///
1979.year#1.sum`i'#1.median_tea= "1979" ///
1980.year#1.sum`i'#1.median_tea= "1980" ///
1981.year#1.sum`i'#1.median_tea= "1981" ///
1982.year#1.sum`i'#1.median_tea= "1982" ///
1983.year#1.sum`i'#1.median_tea= "1983" ///
1984.year#1.sum`i'#1.median_tea= "1984" ///
1985.year#1.sum`i'#1.median_tea= "1985" ///
) ///

graph save $Results/median/event_1940_`x'`i'.gph,replace
graph export $Results/median/event_1940_`x'`i'.pdf,replace

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

reghdfe `x' post_sum`i' post_sum2`i' interaction interaction2 1.post##1.sum`i'##1.median_tea 1.post##1.sum2`i'##1.median_tea, a(i.id i.year#i.codprov ) cluster(id) 
outreg2 using $Results/median/table_reg_female_trends_weddings , dec(3)  label nonotes addtext( Mun. FE, YES, Prov. X Year FE, YES, Cohort, `name')  ct("`tit'") tex(frag) keep(interaction) nocons  addstat(Mean of depvar, `mean_depvar')

reghdfe `x' b1945.year##1.sum`i'##1.median_tea  b1945.year##1.sum2`i'##1.median_tea, a(i.id i.year#i.codprov ) cluster(id) 

coefplot , keep(*.year#1.sum`i'#1.median_tea) vertical base omitted  yline(0, lc(red) lp(dash)) xline(16, lcolor(blue) lpattern(dash)) ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) title("`name'", s(small) c(black)) ytitle("`name2'", s(vsmall)) scheme(s2mono) xlabel(, angle(45) labs(tiny))   ///
coeflabels( ///
1930.year#1.sum`i'#1.median_tea= "1930" ///  
1931.year#1.sum`i'#1.median_tea= "1931" ///
1932.year#1.sum`i'#1.median_tea= "1932" ///
1933.year#1.sum`i'#1.median_tea= "1933" ///
1934.year#1.sum`i'#1.median_tea= "1934" ///
1935.year#1.sum`i'#1.median_tea= "1935" ///
1936.year#1.sum`i'#1.median_tea= "1936" ///
1937.year#1.sum`i'#1.median_tea= "1937" ///
1938.year#1.sum`i'#1.median_tea= "1938" ///
1939.year#1.sum`i'#1.median_tea= "1939" ///
1940.year#1.sum`i'#1.median_tea= "1940" ///
1941.year#1.sum`i'#1.median_tea= "1941" ///
1942.year#1.sum`i'#1.median_tea= "1942" ///
1943.year#1.sum`i'#1.median_tea= "1943" ///
1944.year#1.sum`i'#1.median_tea= "1944" ///
1945.year#1.sum`i'#1.median_tea= "1945" ///
1946.year#1.sum`i'#1.median_tea= "1946" ///
1947.year#1.sum`i'#1.median_tea= "1947" ///
1948.year#1.sum`i'#1.median_tea= "1948" ///
1949.year#1.sum`i'#1.median_tea= "1949" ///
1950.year#1.sum`i'#1.median_tea= "1950" ///
1951.year#1.sum`i'#1.median_tea= "1951" ///
1952.year#1.sum`i'#1.median_tea= "1952" ///
1953.year#1.sum`i'#1.median_tea= "1953" ///
1954.year#1.sum`i'#1.median_tea= "1954" ///
1955.year#1.sum`i'#1.median_tea= "1955" ///
1956.year#1.sum`i'#1.median_tea= "1956" ///
1957.year#1.sum`i'#1.median_tea= "1957" ///
1958.year#1.sum`i'#1.median_tea= "1958" ///
1959.year#1.sum`i'#1.median_tea= "1959" ///
1960.year#1.sum`i'#1.median_tea= "1960" ///
1961.year#1.sum`i'#1.median_tea= "1961" ///
1962.year#1.sum`i'#1.median_tea= "1962" ///
1963.year#1.sum`i'#1.median_tea= "1963" ///
1964.year#1.sum`i'#1.median_tea= "1964" ///
1965.year#1.sum`i'#1.median_tea= "1965" ///
1966.year#1.sum`i'#1.median_tea= "1966" ///
1967.year#1.sum`i'#1.median_tea= "1967" ///
1968.year#1.sum`i'#1.median_tea= "1968" ///
1969.year#1.sum`i'#1.median_tea= "1969" ///
1970.year#1.sum`i'#1.median_tea= "1970" ///
1971.year#1.sum`i'#1.median_tea= "1971" ///
1972.year#1.sum`i'#1.median_tea= "1972" ///
1973.year#1.sum`i'#1.median_tea= "1973" ///
1974.year#1.sum`i'#1.median_tea= "1974" ///
1975.year#1.sum`i'#1.median_tea= "1975" ///
1976.year#1.sum`i'#1.median_tea= "1976" ///
1977.year#1.sum`i'#1.median_tea= "1977" ///
1978.year#1.sum`i'#1.median_tea= "1978" ///
1979.year#1.sum`i'#1.median_tea= "1979" ///
1980.year#1.sum`i'#1.median_tea= "1980" ///
1981.year#1.sum`i'#1.median_tea= "1981" ///
1982.year#1.sum`i'#1.median_tea= "1982" ///
1983.year#1.sum`i'#1.median_tea= "1983" ///
1984.year#1.sum`i'#1.median_tea= "1984" ///
1985.year#1.sum`i'#1.median_tea= "1985" ///
) ///

graph save $Results/median/event_1940_`x'`i'.gph,replace
graph export $Results/median/event_1940_`x'`i'.pdf,replace
}
drop interaction interaction2 sum* post_*
}
}

cd $Results\median\

graph combine event_1940_flag41.gph event_1940_flag42.gph , graphregion(color(white)) ycommon title("Births", s(small) c(black)) r(1)
graph save event_1940_female_fertility.gph, replace 

graph combine event_1940_flag61.gph event_1940_flag62.gph , graphregion(color(white)) ycommon title("Weddings", s(small) c(black)) r(1)
graph save event_1940_female_wedding.gph, replace 

graph combine event_1940_female_fertility.gph event_1940_female_wedding.gph, graphregion(color(white)) r(2)
graph export event_1940_female_trends.pdf, replace


