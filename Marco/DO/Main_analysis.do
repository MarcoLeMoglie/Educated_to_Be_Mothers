global datain "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/output_data/"
global dataout "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/Marco/Results/"
/*
global datain "C:\Users\laxge\Dropbox\GEMA\RESEARCH\PURGE\output_data\"
global dataout "C:\Users\laxge\Dropbox\GEMA\RESEARCH\PURGE\Results\"
*/
use  ${datain}dataset.dta, clear

 
***************************************
**# GRAPH Qualitative evidence -- By gender 
***************************************
preserve
drop if popsharewomen_agegroup1_1940==. | popsharemen_agegroup1_1940==. | popsharewomen_agegroup2_1940==. | popsharemen_agegroup2_1940==.
gen flag4=(alive_birth/(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940))*1000

*drop if year<1941
drop pop_w pop_m
gen pop_w=popsharewomen_agegroup1_1940+popsharewomen_agegroup2_1940
sum pop_w, detail
gen m_popw=pop_w>r(p50) & pop_w!=.
gen pop_m=popsharemen_agegroup1_1940+popsharemen_agegroup2_1940
sum pop_m, detail
gen m_popm=pop_m>r(p50) & pop_m!=.

collapse flag4, by(year m_popw)

twoway (line flag4 year if m_popw==0 ) (line flag4 year if m_popw==1), graphregion(color(white)) legend(order(1 "Low exposure" 2 "High exposure")  forces symx(vsmall) size(vsmall)) ytitle("Alive births per 1,000 inh.", s(small)) xtitle("") title("", s(small) c(black)) ylab(, labs(vsmall)) xlab(1930(5)1985, labs(vsmall))
graph export ${dataout}desc_1940_female_fertility.pdf,replace
restore

***************************************
**# GRAPH Composition fertile age groups -- 1 
***************************************
preserve
use  ${datain}dataset.dta, clear
*keep if province !="burgos" & province !="malaga" & province !="badajoz" & province !="cadiz" 

foreach i of numlist 1930 1940 1950 1960 1970{
egen total`i'=rowtotal( pop_agegroup3_`i' pop_agegroup4_`i' pop_agegroup5_`i')
gen popsharewomen2_agegroup3_`i'=pop_agegroup3_`i'/total`i'
gen popsharewomen2_agegroup4_`i'=pop_agegroup4_`i'/total`i'
gen popsharewomen2_agegroup5_`i'=pop_agegroup5_`i'/total`i'

}
drop total*

keep if pop_census!=.
keep codprov type year pop_19* province popsharewomen2_agegroup* median*
keep if median_popw==1
drop pop_19*
* Check that all is fine
sort codprov province type 
collapse popsharewomen2_agegroup*, by(year)


foreach i of numlist 1930 1940 1950 1960 1970{
gen group5_`i' =popsharewomen2_agegroup3_`i' +popsharewomen2_agegroup4_`i' +popsharewomen2_agegroup5_`i' 

gen group4_`i' =popsharewomen2_agegroup3_`i' +popsharewomen2_agegroup4_`i'

gen group3_`i' =popsharewomen2_agegroup3_`i' 

}

drop popshare*

foreach i of numlist 3/5{
	gen group`i' = group`i'_1930 if year ==1930
replace group`i' = group`i'_1940 if year ==1940
replace group`i' = group`i'_1950 if year ==1950
replace group`i' = group`i'_1960 if year ==1960
replace group`i' = group`i'_1970 if year ==1970
drop group`i'_19*
}

twoway area group3 year, color(purple*0.1) ||  rarea group3 group4 year, color(purple*1.2) || rarea group4 group5 year, color(purple*1.8)  legend(order(1 "15-24"  2  "25-34" 3 "35-44" ) pos(6) col(3)) xtitle("") xla(1930(10)1970) ytitle(Percent) graphregion(color(white)) title("c) Composition - High exposure", s(small)) ylabel(0(.2)1)
graph save ${dataout}women_1.gph,replace
restore

***************************************
**# GRAPH Composition fertile age groups -- 0 
***************************************
preserve
*keep if province !="burgos" & province !="malaga" & province !="badajoz" & province !="cadiz" 
use  ${datain}dataset.dta, clear
foreach i of numlist 1930 1940 1950 1960 1970{
egen total`i'=rowtotal( pop_agegroup3_`i' pop_agegroup4_`i' pop_agegroup5_`i')
gen popsharewomen2_agegroup3_`i'=pop_agegroup3_`i'/total`i'
gen popsharewomen2_agegroup4_`i'=pop_agegroup4_`i'/total`i'
gen popsharewomen2_agegroup5_`i'=pop_agegroup5_`i'/total`i'

}
drop total*

keep if pop_census!=.
keep codprov type year pop_19* province popsharewomen2_agegroup* median*
keep if median_popw==0 
drop pop_19*
* Check that all is fine
sort codprov province type 
collapse popsharewomen2_agegroup*, by(year)


foreach i of numlist 1930 1940 1950 1960 1970{
gen group5_`i' =popsharewomen2_agegroup3_`i' +popsharewomen2_agegroup4_`i' +popsharewomen2_agegroup5_`i' 

gen group4_`i' =popsharewomen2_agegroup3_`i' +popsharewomen2_agegroup4_`i'

gen group3_`i' =popsharewomen2_agegroup3_`i' 

}

drop popshare*

foreach i of numlist 3/5{
	gen group`i' = group`i'_1930 if year ==1930
replace group`i' = group`i'_1940 if year ==1940
replace group`i' = group`i'_1950 if year ==1950
replace group`i' = group`i'_1960 if year ==1960
replace group`i' = group`i'_1970 if year ==1970
drop group`i'_19*
}

twoway area group3 year, color(purple*0.1) ||  rarea group3 group4 year, color(purple*1.2) || rarea group4 group5 year, color(purple*1.8)  legend(order(1 "15-24"  2  "25-34" 3 "35-44" ) pos(6) col(3)) xtitle("") xla(1930(10)1970) ytitle(Percent) graphregion(color(white)) title("d) Composition - Low exposure", s(small))  ylabel(0(.2)1)
graph save ${dataout}women_0.gph,replace
restore

cd ${dataout}
grc1leg2  women_1.gph  women_0.gph, graphregion(color(white))
graph export ${dataout}women.pdf, replace



***************************************
**# Size fertile age groups -- 1 
***************************************
preserve
use  ${datain}dataset.dta, clear
*keep if province !="burgos" & province !="malaga" & province !="badajoz" & province !="cadiz" 
rename pop_women1930 pop_female_1930
rename popwomen_1940 pop_female_1940

foreach i of numlist 1930 1940 1950 1960 1970{
egen total`i'=rowtotal( pop_agegroup1_`i'-pop_agegroup8_`i')
gen popsharewomen2_total_014_`i'=( pop_agegroup1_`i'+ pop_agegroup2_`i')/total`i'
gen popsharewomen2_total_1544_`i'=( pop_agegroup3_`i'+ pop_agegroup4_`i'+ pop_agegroup5_`i')/total`i'
gen popsharewomen2_total_4564_`i'=( pop_agegroup6_`i'+ pop_agegroup7_`i')/total`i'
gen popsharewomen2_total_65_`i'=pop_agegroup8_`i'/total`i'
}

keep if pop_census!=.
keep codprov type year pop_19* province popsharewomen2_total* median*
keep if median_popw==1
drop pop_19*
* Check that all is fine
sort codprov province type 
collapse popsharewomen2_total*, by(year)


foreach i of numlist 1930 1940 1950 1960 1970{
gen group6_`i' =popsharewomen2_total_014_`i' +popsharewomen2_total_1544_`i' +popsharewomen2_total_4564_`i' + popsharewomen2_total_65_`i'

gen group5_`i' =popsharewomen2_total_014_`i' +popsharewomen2_total_1544_`i' +popsharewomen2_total_4564_`i' 

gen group4_`i' =popsharewomen2_total_014_`i' +popsharewomen2_total_1544_`i'

gen group3_`i' =popsharewomen2_total_014_`i' 

}

drop popshare*

foreach i of numlist 3/6{
	gen group`i' = group`i'_1930 if year ==1930
replace group`i' = group`i'_1940 if year ==1940
replace group`i' = group`i'_1950 if year ==1950
replace group`i' = group`i'_1960 if year ==1960
replace group`i' = group`i'_1970 if year ==1970
drop group`i'_19*
}

twoway area group3 year, color(blue) ||  rarea group3 group4 year, color(purple) || rarea group4 group5 year, color(red) || rarea group5 group6 year , color(orange) legend(order(1 "0-14"  2  "15-44" 3 "45-64" 4 "65+" ) pos(6) col(4)) xtitle("") xla(1930(10)1970) ytitle(Percent) graphregion(color(white)) title("a) Composition - High exposure", s(small)) ylabel(0(.2)1)
graph save ${dataout}women2_1.gph,replace
restore
***************************************
**# Size fertile age groups -- 0
***************************************
preserve
use   ${datain}dataset.dta, clear
*keep if province !="burgos" & province !="malaga" & province !="badajoz" & province !="cadiz" 
rename pop_women1930 pop_female_1930
rename popwomen_1940 pop_female_1940

foreach i of numlist 1930 1940 1950 1960 1970{
egen total`i'=rowtotal( pop_agegroup1_`i'-pop_agegroup8_`i')
gen popsharewomen2_total_014_`i'=( pop_agegroup1_`i'+ pop_agegroup2_`i')/total`i'
gen popsharewomen2_total_1544_`i'=( pop_agegroup3_`i'+ pop_agegroup4_`i'+ pop_agegroup5_`i')/total`i'
gen popsharewomen2_total_4564_`i'=( pop_agegroup6_`i'+ pop_agegroup7_`i')/total`i'
gen popsharewomen2_total_65_`i'=pop_agegroup8_`i'/total`i'
}

keep if pop_census!=.
keep codprov type year pop_19* province popsharewomen2_total* median*
keep if median_popw==0
drop pop_19*
* Check that all is fine
sort codprov province type 
collapse popsharewomen2_total*, by(year)


foreach i of numlist 1930 1940 1950 1960 1970{
gen group6_`i' =popsharewomen2_total_014_`i' +popsharewomen2_total_1544_`i' +popsharewomen2_total_4564_`i' + popsharewomen2_total_65_`i'

gen group5_`i' =popsharewomen2_total_014_`i' +popsharewomen2_total_1544_`i' +popsharewomen2_total_4564_`i' 

gen group4_`i' =popsharewomen2_total_014_`i' +popsharewomen2_total_1544_`i'

gen group3_`i' =popsharewomen2_total_014_`i' 

}

drop popshare*

foreach i of numlist 3/6{
	gen group`i' = group`i'_1930 if year ==1930
replace group`i' = group`i'_1940 if year ==1940
replace group`i' = group`i'_1950 if year ==1950
replace group`i' = group`i'_1960 if year ==1960
replace group`i' = group`i'_1970 if year ==1970
drop group`i'_19*
}

twoway area group3 year, color(blue) ||  rarea group3 group4 year, color(purple) || rarea group4 group5 year, color(red) || rarea group5 group6 year , color(orange) legend(order(1 "0-14"  2  "15-44" 3 "45-64" 4 "65+" ) pos(6) col(4)) xtitle("") xla(1930(10)1970) ytitle(Percent) graphregion(color(white)) title("b) Size - Low exposure", s(small)) ylabel(0(.2)1)
graph save ${dataout}women2_0.gph,replace
restore

cd ${dataout}
grc1leg2 women2_1.gph  women2_0.gph , graphregion(color(white))
graph save women2.gph, replace
grc1leg2 women_1.gph  women_0.gph , graphregion(color(white))
graph save women1.gph, replace
graph combine  women2.gph  women1.gph,  graphregion(color(white)) c(1) 
graph export ${dataout}women.pdf, replace


/*
* Stability fertile age groups -- Absolute values 
preserve
use  ${datain}dataset.dta, clear
keep if province !="burgos" & province !="malaga" & province !="badajoz" & province !="cadiz" 

foreach i of numlist 1930 1940 1950 1960 1970{
gen popwomen2_agegroup`i'3=pop_agegroup3_`i'
gen popwomen2_agegroup`i'4=pop_agegroup4_`i'
gen popwomen2_agegroup`i'5=pop_agegroup5_`i'

}

keep if pop_census!=.
keep codprov type year pop_19* province popwomen2_agegroup* median*
drop pop_19*
* Check that all is fine
sort codprov province type 
collapse popwomen2_agegroup*, by(year median_popw)
egen id=group(year median_popw)
reshape long popwomen2_agegroup1930 popwomen2_agegroup1940 popwomen2_agegroup1950 popwomen2_agegroup1960 popwomen2_agegroup1970, i(id) j(group)
keep if year==1930
drop year id
egen id=group(group median_popw)

reshape long popwomen2_agegroup, i(id) j(year)
drop id

graph bar popwomen2_agegroup  , bar(1, c(gray%25)) bar(2, c(gray%75))  over(median_popw) over(year, label(labs(small))) over(group, relabel(1 "15-24" 2 "24-34" 3 "35-44") label(labs(small))) graphregion(color(white)) ytitle("Number of women", s(small)) ylabel(, labs(vsmall)) legend(order(1 "Low exp" 2 "High exp"))
*/



/*
****** Continous Treatment ---- Base mobile interaction type of mun
preserve
gen duce2=type=="municipality"
gen popsharewomen_agegroup1=(popsharewomen_agegroup1_1940+popsharewomen_agegroup2_1940)*100
gen popsharemen_agegroup1=(popsharemen_agegroup1_1940+popsharemen_agegroup2_1940)*100
gen flag4=.
replace flag4= ln(popwomen_agegroup3_1930 +popwomen_agegroup4_1930 +popwomen_agegroup5_1930) if year>=1930 & year<1940
replace flag4= ln(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940) if year>=1940 & year<1950
replace flag4= ln(popwomen_agegroup3_1950 +popwomen_agegroup4_1950 +popwomen_agegroup5_1950) if year>=1950 & year<1960
replace flag4= ln(popwomen_agegroup3_1960 +popwomen_agegroup4_1960 +popwomen_agegroup5_1960) if year>=1960 & year<1970
replace flag4= ln(popwomen_agegroup3_1970 +popwomen_agegroup4_1970 +popwomen_agegroup5_1970) if year>=1970 & year<1980
*replace alive=ln(alive)
 foreach x of varlist  alive {
	
sum `x'  if year<1945 & year>1939 
local mean_depvar = r(mean)

local i=1
/*
drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
xtile median_popw`i'=popsharewomen_agegroup`i', n(5)
gen tertile_popw`i'=median_popw`i'==5
xtile median_popm`i'=popsharemen_agegroup`i', n(5)
gen tertile_popm`i'=median_popm`i'==5


gen sum`i'=tertile_popw`i'
gen sum2`i'=tertile_popm`i' 
*/

drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
gen sum`i'=popsharewomen_agegroup`i'
gen sum2`i'=popsharemen_agegroup`i' 

gen interaction=post*sum`i'*duce2
gen interaction2=post*sum2`i'*duce2

label var interaction "Treat (W) X Post 1945"
label var interaction2 "Treat (M) X Post 1945"

local name2 = "Alive births"
local tit = "Births"
local name = "0-14"

reghdfe `x'  interaction  1.post##c.sum`i'##1.duce2 flag4, a(i.id i.year ) cluster(id) 
outreg2 using ${dataout}table_reg_female_trends, dec(3)  label nonotes addtext( Mun. FE, YES, Year FE, YES, Mun. X Year FE, NO)  ct("`tit'") tex(frag) keep(interaction) nocons replace addstat(Mean of depvar, `mean_depvar')

reghdfe `x'  interaction  1.post##c.sum`i'##1.duce2 flag4, a(i.id i.year#i.codprov ) cluster(id) 
outreg2 using ${dataout}table_reg_female_trends, dec(3)  label nonotes addtext( Mun. FE, YES, Year FE, YES, Mun. X Year FE, YES)  ct("`tit'") tex(frag) keep(interaction) nocons  addstat(Mean of depvar, `mean_depvar')

reghdfe `x'  interaction interaction2  1.post##c.sum`i'##1.duce2 1.post##c.sum2`i'##1.duce2 flag4, a(i.id i.year) cluster(id) 
outreg2 using ${dataout}table_reg_female_trends, dec(3)  label nonotes addtext( Mun. FE, YES, Year FE, YES, Mun. X Year FE, NO)  ct("`tit'") tex(frag) keep(interaction interaction2) nocons addstat(Mean of depvar, `mean_depvar')

reghdfe `x'  interaction interaction2  1.post##c.sum`i'##1.duce2 1.post##c.sum2`i'##1.duce2 flag4, a(i.id i.year#i.codprov ) cluster(id) 
outreg2 using ${dataout}table_reg_female_trends, dec(3)  label nonotes addtext( Mun. FE, YES, Year FE, YES, Mun. X Year FE, YES)  ct("`tit'") tex(frag) keep(interaction interaction2) nocons addstat(Mean of depvar, `mean_depvar')


*egen idprovinceyear= group(codprov year)
*
reghdfe `x' b1945.year##c.sum`i'  b1945.year##c.sum2`i' flag4, a(i.id i.year#i.codprov) cluster(id) 

coefplot , keep(*.year#c.sum`i') vertical base omitted  yline(0, lc(black) lp(dash)) xline(16, lcolor(blue)  lpattern(dash)) xline(26, lcolor(red%25)) xline(36, lcolor(red%50)) xline(46, lcolor(red%75)) ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) /*title("`name'", s(small) c(black))*/ ytitle("`name2'", s(vsmall)) scheme(s2mono) xlabel(, angle(45) labs(tiny))   ///
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


graph save ${dataout}event_1940_cont_`x'`i'.gph,replace
graph export ${dataout}event_1940_cont_`x'`i'.pdf,replace

}
restore
*/




***************************************
**# Continuous Treatment ---- Base mobile
*************************************** 
preserve
gen popsharewomen_agegroup1=(popsharewomen_agegroup1_1940+popsharewomen_agegroup2_1940)*100
gen popsharemen_agegroup1=(popsharemen_agegroup1_1940+popsharemen_agegroup2_1940)*100
gen flag4=.
replace flag4= ln(popwomen_agegroup3_1930 +popwomen_agegroup4_1930 +popwomen_agegroup5_1930) if year>=1930 & year<1940
replace flag4= ln(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940) if year>=1940 & year<1950
replace flag4= ln(popwomen_agegroup3_1950 +popwomen_agegroup4_1950 +popwomen_agegroup5_1950) if year>=1950 & year<1960
replace flag4= ln(popwomen_agegroup3_1960 +popwomen_agegroup4_1960 +popwomen_agegroup5_1960) if year>=1960 & year<1970
replace flag4= ln(popwomen_agegroup3_1970 +popwomen_agegroup4_1970 +popwomen_agegroup5_1970) if year>=1970 & year<1980
*replace alive=ln(alive)
 foreach x of varlist  alive {
	
sum `x'  if year<1945 & year>1939 
local mean_depvar = r(mean)

local i=1
/*
drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
xtile median_popw`i'=popsharewomen_agegroup`i', n(5)
gen tertile_popw`i'=median_popw`i'==5
xtile median_popm`i'=popsharemen_agegroup`i', n(5)
gen tertile_popm`i'=median_popm`i'==5


gen sum`i'=tertile_popw`i'
gen sum2`i'=tertile_popm`i' 
*/

drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
gen sum`i'=popsharewomen_agegroup`i'
gen sum2`i'=popsharemen_agegroup`i' 

gen interaction=post*sum`i'
gen interaction2=post*sum2`i'

label var interaction "Treat (W) X Post 1945"
label var interaction2 "Treat (M) X Post 1945"

local name2 = "Alive births"
local tit = "Births"
local name = "0-14"

reghdfe `x'  interaction  1.post##c.sum`i' flag4, a(i.id i.year ) cluster(id) 
outreg2 using ${dataout}table_reg_female_trends, dec(3)  label nonotes addtext( Unit FE, YES, Year FE, YES, Prov. X Year FE, NO)  ct("`tit'") tex(frag) keep(interaction) nocons replace addstat(Mean of depvar, `mean_depvar')

reghdfe `x'  interaction  1.post##c.sum`i' flag4, a(i.id i.year#i.codprov ) cluster(id) 
outreg2 using ${dataout}table_reg_female_trends, dec(3)  label nonotes addtext( Unit FE, YES, Year FE, YES, Prov. X Year FE, YES)  ct("`tit'") tex(frag) keep(interaction) nocons  addstat(Mean of depvar, `mean_depvar')

reghdfe `x'  interaction interaction2  1.post##c.sum`i' 1.post##c.sum2`i' flag4, a(i.id i.year) cluster(id) 
outreg2 using ${dataout}table_reg_female_trends, dec(3)  label nonotes addtext( Unit FE, YES, Year FE, YES, Prov. X Year FE, NO)  ct("`tit'") tex(frag) keep(interaction interaction2) nocons addstat(Mean of depvar, `mean_depvar')

reghdfe `x'  interaction interaction2  1.post##c.sum`i' 1.post##c.sum2`i' flag4, a(i.id i.year#i.codprov ) cluster(id) 
outreg2 using ${dataout}table_reg_female_trends, dec(3)  label nonotes addtext( Unit FE, YES, Year FE, YES, Prov. X Year FE, YES)  ct("`tit'") tex(frag) keep(interaction interaction2) nocons addstat(Mean of depvar, `mean_depvar')


*egen idprovinceyear= group(codprov year)
*
reghdfe `x' b1945.year##c.sum`i'  b1945.year##c.sum2`i' flag4, a(i.id i.year#i.codprov) cluster(id) 

coefplot , keep(*.year#c.sum`i') vertical base omitted  yline(0, lc(black) lp(dash)) xline(16, lcolor(blue)  lpattern(dash)) xline(26, lcolor(red%25)) xline(36, lcolor(red%50)) xline(46, lcolor(red%75)) ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) /*title("`name'", s(small) c(black))*/ ytitle("`name2'", s(vsmall)) scheme(s2mono) xlabel(, angle(45) labs(tiny))   ///
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


graph save ${dataout}event_1940_cont_`x'`i'.gph,replace
graph export ${dataout}event_1940_cont_`x'`i'.pdf,replace

}
restore


***************************************
**# Continous Treatment ---- Base mobile with deaths
*************************************** 
preserve
gen popsharewomen_agegroup1=(popsharewomen_agegroup1_1940+popsharewomen_agegroup2_1940)*100
gen popsharemen_agegroup1=(popsharemen_agegroup1_1940+popsharemen_agegroup2_1940)*100
gen flag4=.
replace flag4= ln(popwomen_agegroup3_1930 +popwomen_agegroup4_1930 +popwomen_agegroup5_1930) if year>=1930 & year<1940
replace flag4= ln(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940) if year>=1940 & year<1950
replace flag4= ln(popwomen_agegroup3_1950 +popwomen_agegroup4_1950 +popwomen_agegroup5_1950) if year>=1950 & year<1960
replace flag4= ln(popwomen_agegroup3_1960 +popwomen_agegroup4_1960 +popwomen_agegroup5_1960) if year>=1960 & year<1970
replace flag4= ln(popwomen_agegroup3_1970 +popwomen_agegroup4_1970 +popwomen_agegroup5_1970) if year>=1970 & year<1980
*replace alive=ln(alive)
 foreach x of varlist  alive {
	
sum `x'  if year<1945 & year>1939 
local mean_depvar = r(mean)

local i=1
/*
drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
xtile median_popw`i'=popsharewomen_agegroup`i', n(5)
gen tertile_popw`i'=median_popw`i'==5
xtile median_popm`i'=popsharemen_agegroup`i', n(5)
gen tertile_popm`i'=median_popm`i'==5


gen sum`i'=tertile_popw`i'
gen sum2`i'=tertile_popm`i' 
*/

drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
gen sum`i'=popsharewomen_agegroup`i'
gen sum2`i'=popsharemen_agegroup`i' 

gen interaction=post*sum`i'
gen interaction2=post*sum2`i'
gen interaction3=post*deaths_male_cwar

label var interaction "Treat (W) X Post 1945"
label var interaction2 "Treat (M) X Post 1945"
label var interaction3 "Deaths 1936-39 (M) X Post 1945"

local name2 = "Alive births"
local tit = "Births"
local name = "0-14"

reghdfe `x'  interaction  1.post##c.sum`i' flag4, a(i.id i.year ) cluster(id) 
outreg2 using ${dataout}table_reg_female_trends_deaths, dec(3)  label nonotes addtext( Unit FE, YES, Year FE, YES, Prov. X Year FE, NO)  ct("`tit'") tex(frag) keep(interaction) nocons replace addstat(Mean of depvar, `mean_depvar')

reghdfe `x'  interaction  1.post##c.sum`i' flag4, a(i.id i.year#i.codprov ) cluster(id) 
outreg2 using ${dataout}table_reg_female_trends_deaths, dec(3)  label nonotes addtext( Unit FE, YES, Year FE, YES, Prov. X Year FE, YES)  ct("`tit'") tex(frag) keep(interaction) nocons  addstat(Mean of depvar, `mean_depvar')

reghdfe `x'  interaction interaction2  1.post##c.sum`i' 1.post##c.sum2`i' flag4, a(i.id i.year) cluster(id) 
outreg2 using ${dataout}table_reg_female_trends_deaths, dec(3)  label nonotes addtext( Unit FE, YES, Year FE, YES, Prov. X Year FE, NO)  ct("`tit'") tex(frag) keep(interaction interaction2) nocons addstat(Mean of depvar, `mean_depvar')

reghdfe `x'  interaction interaction2  1.post##c.sum`i' 1.post##c.sum2`i' flag4, a(i.id i.year#i.codprov ) cluster(id) 
outreg2 using ${dataout}table_reg_female_trends_deaths, dec(3)  label nonotes addtext( Unit FE, YES, Year FE, YES, Prov. X Year FE, YES)  ct("`tit'") tex(frag) keep(interaction interaction2) nocons addstat(Mean of depvar, `mean_depvar')


reghdfe `x'  interaction interaction2 interaction3 1.post##c.sum`i' 1.post##c.sum2`i' 1.post##c.deaths_male_cwar flag4, a(i.id i.year) cluster(id) 
outreg2 using ${dataout}table_reg_female_trends_deaths, dec(3)  label nonotes addtext( Unit FE, YES, Year FE, YES, Prov. X Year FE, NO)  ct("`tit'") tex(frag) keep(interaction interaction2 interaction3) nocons addstat(Mean of depvar, `mean_depvar')

reghdfe `x'  interaction interaction2 interaction3 1.post##c.sum`i' 1.post##c.sum2`i' 1.post##c.deaths_male_cwar flag4, a(i.id i.year#i.codprov ) cluster(id) 
outreg2 using ${dataout}table_reg_female_trends_deaths, dec(3)  label nonotes addtext( Unit FE, YES, Year FE, YES, Prov. X Year FE, YES)  ct("`tit'") tex(frag) keep(interaction interaction2 interaction3) nocons addstat(Mean of depvar, `mean_depvar')

*egen idprovinceyear= group(codprov year)
*
reghdfe `x' b1945.year##c.sum`i'  b1945.year##c.sum2`i' flag4, a(i.id i.year#i.codprov) cluster(id) 

coefplot , keep(*.year#c.sum`i') vertical base omitted  yline(0, lc(black) lp(dash)) xline(16, lcolor(blue)  lpattern(dash)) xline(26, lcolor(red%25)) xline(36, lcolor(red%50)) xline(46, lcolor(red%75)) ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) /*title("`name'", s(small) c(black))*/ ytitle("`name2'", s(vsmall)) scheme(s2mono) xlabel(, angle(45) labs(tiny))   ///
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


graph save ${dataout}event_1940_cont_`x'`i'_deaths.gph,replace
graph export ${dataout}event_1940_cont_`x'`i'_deaths.pdf,replace

}
restore



***************************************
**# Discrete treatment ---- Base mobile 
***************************************
preserve
gen popsharewomen_agegroup1=popsharewomen_agegroup1_1940+popsharewomen_agegroup2_1940
gen popsharemen_agegroup1=popsharemen_agegroup1_1940+popsharemen_agegroup2_1940
gen flag4=.
replace flag4= ln(popwomen_agegroup3_1930 +popwomen_agegroup4_1930 +popwomen_agegroup5_1930) if year>=1930 & year<1940
replace flag4= ln(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940) if year>=1940 & year<1950
replace flag4= ln(popwomen_agegroup3_1950 +popwomen_agegroup4_1950 +popwomen_agegroup5_1950) if year>=1950 & year<1960
replace flag4= ln(popwomen_agegroup3_1960 +popwomen_agegroup4_1960 +popwomen_agegroup5_1960) if year>=1960 & year<1970
replace flag4= ln(popwomen_agegroup3_1970 +popwomen_agegroup4_1970 +popwomen_agegroup5_1970) if year>=1970 & year<1980
foreach x of varlist  alive {
	
sum `x'  if year<1945 & year>1939 
local mean_depvar = r(mean)

local i=1
	
drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
xtile median_popw`i'=popsharewomen_agegroup`i', n(2)
gen tertile_popw`i'=median_popw`i'==2
xtile median_popm`i'=popsharemen_agegroup`i', n(2)
gen tertile_popm`i'=median_popm`i'==2


gen sum`i'=tertile_popw`i'
gen sum2`i'=tertile_popm`i' 

gen interaction=post*sum`i'
gen interaction2=post*sum2`i'

label var interaction "Treat (W) X Post 1945"
label var interaction2 "Treat (M) X Post 1945"

local name2 = "Alive births"
local tit = "Births"
local name = "0-14"

reghdfe `x'  interaction  1.post##c.sum`i' flag4, a(i.id i.year#i.codprov ) cluster(id) 
outreg2 using ${dataout}table_reg_female_rob, dec(3)  label nonotes addtext(Test, Discrete, Fertile pop., YES, Unit FE, YES, Year FE, YES, Prov. X Year FE, YES)  ct("`tit'") tex(frag) keep(interaction) nocons replace addstat(Mean of depvar, `mean_depvar')

reghdfe `x'  interaction interaction2  1.post##c.sum`i' 1.post##c.sum2`i' flag4, a(i.id i.year#i.codprov ) cluster(id) 
outreg2 using ${dataout}table_reg_female_rob, dec(3)  label nonotes addtext(Test, Discrete, Fertile pop., YES, Unit FE, YES, Year FE, YES, Prov. X Year FE, YES)  ct("`tit'") tex(frag) keep(interaction interaction2) nocons addstat(Mean of depvar, `mean_depvar')
*egen idprovinceyear= group(codprov year)
*
reghdfe `x' b1945.year##c.sum`i'  b1945.year##c.sum2`i' flag4, a(i.id i.year#i.codprov) cluster(id) 

coefplot , keep(*.year#c.sum`i') vertical base omitted  yline(0, lc(black) lp(dash)) xline(16, lcolor(blue)  lpattern(dash)) xline(26, lcolor(red%25)) xline(36, lcolor(red%50)) xline(46, lcolor(red%75)) ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) /*title("`name'", s(small) c(black))*/ ytitle("`name2'", s(vsmall)) scheme(s2mono) xlabel(, angle(45) labs(tiny))   ///
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

graph save ${dataout}event_1940_discrete_`x'`i'.gph,replace
graph export ${dataout}event_1940_discrete_`x'`i'.pdf,replace

}
restore



/*
****** Continous Treatment ---- Base fissa 
preserve
gen popsharewomen_agegroup1=(popsharewomen_agegroup1_1940+popsharewomen_agegroup2_1940)*100
gen popsharemen_agegroup1=(popsharemen_agegroup1_1940+popsharemen_agegroup2_1940)*100
gen flag4=alive_birth/(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940)
*replace alive=ln(alive)
 foreach x of varlist  flag4 {
	
sum `x'  if year<1945 & year>1939 
local mean_depvar = r(mean)

local i=1
/*
drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
xtile median_popw`i'=popsharewomen_agegroup`i', n(5)
gen tertile_popw`i'=median_popw`i'==5
xtile median_popm`i'=popsharemen_agegroup`i', n(5)
gen tertile_popm`i'=median_popm`i'==5


gen sum`i'=tertile_popw`i'
gen sum2`i'=tertile_popm`i' 
*/

drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
gen sum`i'=popsharewomen_agegroup`i'
gen sum2`i'=popsharemen_agegroup`i' 

gen interaction=post*sum`i'
gen interaction2=post*sum2`i'

label var interaction "Treat (W) X Post 1945"
label var interaction2 "Treat (M) X Post 1945"

local name2 = "Alive births"
local tit = "Births"
local name = "0-14"

reghdfe `x'  interaction  1.post##c.sum`i' , a(i.id i.year#i.codprov ) cluster(id) 
outreg2 using ${dataout}table_reg_female_rob, dec(3)  label nonotes addtext(Fertile pop., YES, Unit FE, YES, Year FE, YES, Prov. X Year FE, YES)  ct("`tit'") tex(frag) keep(interaction) nocons  addstat(Mean of depvar, `mean_depvar') 

reghdfe `x'  interaction interaction2  1.post##c.sum`i' 1.post##c.sum2`i' , a(i.id i.year#i.codprov ) cluster(id) 
outreg2 using ${dataout}table_reg_female_rob, dec(3)  label nonotes addtext(Fertile pop., YES, Unit FE, YES, Year FE, YES, Prov. X Year FE, YES)  ct("`tit'") tex(frag) keep(interaction interaction2) nocons addstat(Mean of depvar, `mean_depvar')


*egen idprovinceyear= group(codprov year)
*
reghdfe `x' b1945.year##c.sum`i'  b1945.year##c.sum2`i', a(i.id i.year#i.codprov) cluster(id) 

coefplot , keep(*.year#c.sum`i') vertical base omitted  yline(0, lc(black) lp(dash)) xline(16, lcolor(blue)  lpattern(dash)) xline(26, lcolor(red%25)) xline(36, lcolor(red%50)) xline(46, lcolor(red%75)) ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) /*title("`name'", s(small) c(black))*/ ytitle("`name2'", s(vsmall)) scheme(s2mono) xlabel(, angle(45) labs(tiny))   ///
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


graph save ${dataout}event_1940_basefissa_`x'`i'.gph,replace
graph export ${dataout}event_1940_basefissa_`x'`i'.pdf,replace

}
restore
*/


***************************************
**# Placebo 15-24 1940 
***************************************
preserve
gen popsharewomen_agegroup2=popsharewomen_agegroup3_1940*100
gen popsharemen_agegroup2=popsharemen_agegroup3_1940*100

gen flag4=.
replace flag4= ln(popwomen_agegroup3_1930 +popwomen_agegroup4_1930 +popwomen_agegroup5_1930) if year>=1930 & year<1940
replace flag4= ln(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940) if year>=1940 & year<1950
replace flag4= ln(popwomen_agegroup3_1950 +popwomen_agegroup4_1950 +popwomen_agegroup5_1950) if year>=1950 & year<1960
replace flag4= ln(popwomen_agegroup3_1960 +popwomen_agegroup4_1960 +popwomen_agegroup5_1960) if year>=1960 & year<1970
replace flag4= ln(popwomen_agegroup3_1970 +popwomen_agegroup4_1970 +popwomen_agegroup5_1970) if year>=1970 & year<1980
foreach x of varlist  alive {

sum `x'  if year<1945 & year>1939 
local mean_depvar = r(mean)

local i=2
	
/*
drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
xtile median_popw`i'=popsharewomen_agegroup`i', n(5)
gen tertile_popw`i'=median_popw`i'==5
xtile median_popm`i'=popsharemen_agegroup`i', n(5)
gen tertile_popm`i'=median_popm`i'==5

gen sum`i'=tertile_popw`i'
gen sum2`i'=tertile_popm`i' 
*/
drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
gen sum`i'=popsharewomen_agegroup`i'
gen sum2`i'=popsharemen_agegroup`i' 

gen interaction=post*sum`i'
gen interaction2=post*sum2`i'

label var interaction "Treat (W) X Post 1945"
label var interaction2 "Treat (M) X Post 1945"

local name2 = "Alive births"
local tit = "Births"
local name = "15-44"

reghdfe `x'  interaction  1.post##c.sum`i' flag4, a(i.id i.year#i.codprov ) cluster(id) 
outreg2 using ${dataout}table_reg_female_rob, dec(3)  label nonotes addtext(Test, Placebo, Fertile pop., YES, Unit FE, YES, Year FE, YES, Prov. X Year FE, YES) ct("`tit'") tex(frag) keep(interaction) nocons  addstat(Mean of depvar, `mean_depvar')

reghdfe `x'  interaction interaction2  1.post##c.sum`i' 1.post##c.sum2`i' flag4, a(i.id i.year#i.codprov ) cluster(id) 
outreg2 using ${dataout}table_reg_female_rob, dec(3)  label nonotes addtext(Test, Placebo, Fertile pop., YES, Unit FE, YES, Year FE, YES, Prov. X Year FE, YES)  ct("`tit'") tex(frag) keep(interaction interaction2) nocons addstat(Mean of depvar, `mean_depvar')
*egen idprovinceyear= group(codprov year)
*
reghdfe `x' b1945.year##c.sum`i'  b1945.year##c.sum2`i' flag4, a(i.id i.year#i.codprov) cluster(id) 

coefplot , keep(*.year#c.sum`i') vertical base omitted  yline(0, lc(black) lp(dash)) xline(16, lcolor(blue)  lpattern(dash)) xline(26, lcolor(red%25)) xline(36, lcolor(red%50)) xline(46, lcolor(red%75)) ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) /*title("`name'", s(small) c(black))*/ ytitle("`name2'", s(vsmall)) scheme(s2mono) xlabel(, angle(45) labs(tiny))   ///
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


graph save ${dataout}event_1940_`x'`i'.gph,replace
graph export ${dataout}event_1940_`x'`i'.pdf,replace

}
restore






***************************************
**# Weddings
***************************************
preserve
gen popsharewomen_agegroup1=(popsharewomen_agegroup1_1940+popsharewomen_agegroup2_1940)*100
gen popsharemen_agegroup1=(popsharemen_agegroup1_1940+popsharemen_agegroup2_1940)*100
gen flag4=.
replace flag4= ln(popwomen_agegroup3_1930 +popwomen_agegroup4_1930 +popwomen_agegroup5_1930) if year>=1930 & year<1940
replace flag4= ln(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940) if year>=1940 & year<1950
replace flag4= ln(popwomen_agegroup3_1950 +popwomen_agegroup4_1950 +popwomen_agegroup5_1950) if year>=1950 & year<1960
replace flag4= ln(popwomen_agegroup3_1960 +popwomen_agegroup4_1960 +popwomen_agegroup5_1960) if year>=1960 & year<1970
replace flag4= ln(popwomen_agegroup3_1970 +popwomen_agegroup4_1970 +popwomen_agegroup5_1970) if year>=1970 & year<1980
foreach x of varlist  total_wedding {
	
sum `x'  if year<1945 & year>1939 
local mean_depvar = r(mean)

local i=1
/*	
drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
xtile median_popw`i'=popsharewomen_agegroup`i', n(5)
gen tertile_popw`i'=median_popw`i'==5
xtile median_popm`i'=popsharemen_agegroup`i', n(5)
gen tertile_popm`i'=median_popm`i'==5


gen sum`i'=tertile_popw`i'
gen sum2`i'=tertile_popm`i' 
*/
drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
gen sum`i'=popsharewomen_agegroup`i'
gen sum2`i'=popsharemen_agegroup`i' 

gen interaction=post*sum`i'
gen interaction2=post*sum2`i'

label var interaction "Treat (W) X Post 1945"
label var interaction2 "Treat (M) X Post 1945"

local name2 = "Alive births"
local tit = "Births"
local name = "0-14"

reghdfe `x'  interaction  1.post##c.sum`i' flag4 , a(i.id i.year#i.codprov ) cluster(id) 
outreg2 using ${dataout}table_reg_female_rob, dec(3)  label nonotes addtext(Test, Weddings, Fertile pop., YES, Unit FE, YES, Year FE, YES, Prov. X Year FE, YES)  ct("`tit'") tex(frag) keep(interaction) nocons  addstat(Mean of depvar, `mean_depvar')

reghdfe `x'  interaction interaction2  1.post##c.sum`i' 1.post##c.sum2`i' flag4, a(i.id i.year#i.codprov ) cluster(id) 
outreg2 using ${dataout}table_reg_female_rob, dec(3)  label nonotes addtext(Test, Weddings, Fertile pop., YES, Unit FE, YES, Year FE, YES, Prov. X Year FE, YES)  ct("`tit'") tex(frag) keep(interaction interaction2) nocons addstat(Mean of depvar, `mean_depvar')
*egen idprovinceyear= group(codprov year)
*
reghdfe `x' b1945.year##c.sum`i'  b1945.year##c.sum2`i' flag4, a(i.id i.year#i.codprov) cluster(id) 

coefplot , keep(*.year#c.sum`i') vertical base omitted  yline(0, lc(black) lp(dash)) xline(16, lcolor(blue)  lpattern(dash)) xline(26, lcolor(red%25)) xline(36, lcolor(red%50)) xline(46, lcolor(red%75)) ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) /*title("`name'", s(small) c(black))*/ ytitle("`name2'", s(vsmall)) scheme(s2mono) xlabel(, angle(45) labs(tiny))   ///
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


graph save ${dataout}event_1940_wedding_`x'`i'.gph,replace
graph export ${dataout}event_1940_wedding_`x'`i'.pdf,replace

}
restore



/*
****** Placebo 0-14 1930 ----- ASSOLUTAMENTE NO
preserve
gen popsharewomen_agegroup1=popsharewomen_agegroup1_1930+popsharewomen_agegroup2_1930
gen popsharemen_agegroup1=popsharemen_agegroup1_1930+popsharemen_agegroup2_1930
gen flag4=.
replace flag4= ln(popwomen_agegroup3_1930 +popwomen_agegroup4_1930 +popwomen_agegroup5_1930) if year>=1930 & year<1940
replace flag4= ln(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940) if year>=1940 & year<1950
replace flag4= ln(popwomen_agegroup3_1950 +popwomen_agegroup4_1950 +popwomen_agegroup5_1950) if year>=1950 & year<1960
replace flag4= ln(popwomen_agegroup3_1960 +popwomen_agegroup4_1960 +popwomen_agegroup5_1960) if year>=1960 & year<1970
replace flag4= ln(popwomen_agegroup3_1970 +popwomen_agegroup4_1970 +popwomen_agegroup5_1970) if year>=1970 & year<1980
foreach x of varlist  alive {


sum `x'  if year<1945 & year>1939 
local mean_depvar = r(mean)

local i=1
	
drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
gen sum`i'=popsharewomen_agegroup`i'
gen sum2`i'=popsharemen_agegroup`i' 

gen interaction=post*sum`i'
gen interaction2=post*sum2`i'

label var interaction "Treat (W) X Post 1945"
label var interaction2 "Treat (M) X Post 1945"

local name2 = "Alive births"
local tit = "Births"
local name = "15-44"

reghdfe `x'  interaction  1.post##c.sum`i' flag4, a(i.id i.year ) cluster(id) 
outreg2 using ${dataout}table_reg_female_1930, dec(3)  label nonotes addtext( Mun. FE, YES, Year FE, YES, Cohorts, `name')  ct("`tit'") tex(frag) keep(interaction) nocons replace addstat(Mean of depvar, `mean_depvar')

reghdfe `x'  interaction interaction2  1.post##c.sum`i' 1.post##c.sum2`i' flag4, a(i.id i.year ) cluster(id) 
outreg2 using ${dataout}table_reg_female_1930, dec(3)  label nonotes addtext( Mun. FE, YES, Year FE, YES, Cohorts, `name')  ct("`tit'") tex(frag) keep(interaction interaction2) nocons addstat(Mean of depvar, `mean_depvar')
*egen idprovinceyear= group(codprov year)
*
reghdfe `x' b1945.year##c.sum`i'  b1945.year##c.sum2`i' flag4, a(i.id i.year) cluster(id) 

coefplot , keep(*.year#c.sum`i') vertical base omitted  yline(0, lc(red) lp(dash)) xline(16, lcolor(blue) lpattern(dash)) ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) /*title("`name'", s(small) c(black))*/ ytitle("`name2'", s(vsmall)) scheme(s2mono) xlabel(, angle(45) labs(tiny))   ///
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


graph save ${dataout}event_1930_`x'`i'.gph,replace
graph export ${dataout}event_1930_`x'`i'.pdf,replace

}
restore
*/

***************************************
**# Balancing
***************************************
preserve
egen idtype = group(type)
drop teachers_pc
gen teachers_pc=(teachers/pop_1930)*10000
keep if year==1940

gen popsharewomen_agegroup1=(popsharewomen_agegroup1_1940+popsharewomen_agegroup2_1940)*100
gen popsharemen_agegroup1=(popsharemen_agegroup1_1940+popsharemen_agegroup2_1940)*100


local i=1
	
drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
gen sum`i'=popsharewomen_agegroup`i'
gen sum2`i'=popsharemen_agegroup`i' 

gen interaction=sum`i'
gen interaction2=sum2`i'

egen total1940=rowtotal( pop_agegroup3_1940 pop_agegroup4_1940 pop_agegroup5_1940)
gen popsharewomen2_agegroup3_1940=pop_agegroup3_1940/total1940
gen popsharewomen2_agegroup4_1940=pop_agegroup4_1940/total1940
gen popsharewomen2_agegroup5_1940=pop_agegroup5_1940/total1940


rename popsharewomen2_agegroup3_1940 popsharewomen_ag3_1940
rename popsharewomen2_agegroup4_1940 popsharewomen_ag4_1940
rename popsharewomen2_agegroup5_1940 popsharewomen_ag5_1940

gen pop=popsharewomen_ag3_1940 + popsharewomen_ag4_1940 + popsharewomen_ag5_1940 


file open myfile using ${dataout}table_balancing.tex, write replace
file write myfile "\begin{tabular}{l c c }\hline\hline  \\[-0.3cm] & (1) & (2)  \\ [0.1cm] & {Coefficient} & {SD}  \\ [0.1cm] \hline \\ " _n

local varlist =  "teachers_pc relig_com_total1930 professed_total1930 novice_total1930 lay_total1930 share_republicanos1931 share_socialistas1931 share_monarquicos1931 share_comunistas1931 adictos nat_school_total42 teachersprimary_total42 enrolled_students42  sh_area_front popsharewomen_ag3_1940 popsharewomen_ag4_1940 popsharewomen_ag5_1940 popwomen_agegroup3_1940 popwomen_agegroup4_1940 popwomen_agegroup5_1940 deaths_male_cwar deaths_female_cwar"   
foreach var in `varlist'{
if "`var'"== "teachers_pc"{
			local name = "Purged teachers"
			
		}

		else if "`var'"== "relig_com_total1930"{
			local name = "Religious communities (1930)"
			
		}
		else if "`var'"== "professed_total1930"{
			local name = "Professed (pc, 1930)"
			
		}
		else if "`var'"== "novice_total1930"{
			local name = "Novices (pc,1930)"
			
		}
		else if "`var'"== "lay_total1930"{
			local name = "Lay (pc, 1930)"
			
		}
		else if "`var'"== "share_republicanos1931"{
			local name = "Republicans (\%, local 1931)"
			
		}
		else if "`var'"== "share_socialistas1931"{
			local name = "Socialists (\%, local 1931)"
			
		}
		else if "`var'"== "share_monarquicos1931"{
			local name = "Monarchic (\%, local 1931)"
			
		}
		else if "`var'"== "share_comunistas1931"{
			local name = "Communists (\%, local 1931)"
			
		}
		else if "`var'"== "adictos"{
			local name = "Pro regime (\%, 1947)"
			
		}
		else if "`var'"== "sh_area_front"{
			local name = "Area in the war front (\%)"
			
		}
		else if "`var'"== "nat_school_total42"{
			local name = "National schools (1000s,1942)"
			
		}
		else if "`var'"== "teachersprimary_total42"{
			local name = "Primary teachers (1000s,1942)"
			
		}
		else if "`var'"== "enrolled_students42"{
			local name = "Enrolled students (1000s,1942)"
			
		}
		
		else if "`var'"== "popsharewomen_ag3_1940"{
			local name = "Women aged 15-24 (\%, 1940) "
			
		}
		else if "`var'"== "popsharewomen_ag4_1940"{
			local name = "Women aged 25-34 (\%, 1940) "
			
		}
		else if "`var'"== "popsharewomen_ag5_1940"{
			local name = "Women aged 35-44 (\%, 1940) "
			
		}
		
		else if "`var'"== "popwomen_agegroup3_1940"{
			local name = "Women aged 15-24 (1940) "
			
		}
		else if "`var'"== "popwomen_agegroup4_1940"{
			local name = "Women aged 25-34 (1940) "
			
		}
		else if "`var'"== "popwomen_agegroup5_1940"{
			local name = "Women aged 35-44 (1940) "
			
		}
	    else if "`var'"== "deaths_male_cwar"{
			local name = "Male deaths (1000s, 1936-39)"
			
		}
	    else if "`var'"== "deaths_female_cwar"{
			local name = "Female deaths (1000s, 1936-39)"
			
		}		
		else {
			local name = "ERROR"
		}
		
if "`var'"== "popwomen_agegroup3_1940" | "`var'"== "popwomen_agegroup4_1940" | "`var'"== "popwomen_agegroup5_1940"{
		
		reghdfe `var'  interaction interaction2, a(i.idtype i.codprov)  nocons
		ta idtype if e(sample)
		local diff3 = _b[interaction]
		local sd3=_se[interaction]
		local pval3 = ttail(47,abs(_b[interaction]/_se[interaction]))*2
		di `pval3'
		
		if `pval3'>0.1  {
			local cc = string(`diff3',"%8.0f") 
		} 
		else if `pval3'>0.05 { 
			local cc = string(`diff3',"%8.0f") + "$^\star$"
		}
		else if `pval3'>0.01 { 
			local cc = string(`diff3',"%8.0f") + "$^\star$" + "$^\star$"
		}
		else {
			local cc = string(`diff3',"%8.0f") + "$^\star$" + "$^\star$" + "$^\star$"
		}
		
		local dd = string(`sd3',"%8.0f") 
		
		
		file write myfile ("`name'") "&" _tab  %8.2f ("`cc'")  "&"_tab  %8.2f ("`dd'") _tab "\\" _n
}
		else {
		reghdfe `var'  interaction interaction2, a(i.idtype i.codprov)  nocons
		ta idtype if e(sample)
		local diff3 = _b[interaction]
		local sd3=_se[interaction]
		local pval3 = ttail(47,abs(_b[interaction]/_se[interaction]))*2
		di `pval3'
		
		if `pval3'>0.1  {
			local cc = string(`diff3',"%8.3f") 
		} 
		else if `pval3'>0.05 { 
			local cc = string(`diff3',"%8.3f") + "$^\star$"
		}
		else if `pval3'>0.01 { 
			local cc = string(`diff3',"%8.3f") + "$^\star$" + "$^\star$"
		}
		else {
			local cc = string(`diff3',"%8.3f") + "$^\star$" + "$^\star$" + "$^\star$"
		}
		
		local dd = string(`sd3',"%8.3f") 
		
		
		file write myfile ("`name'") "&" _tab  %8.2f ("`cc'")  "&"_tab  %8.2f ("`dd'") _tab "\\" _n	
		}
}
file write myfile "\hline\hline \end{tabular}"
file close myfile
restore


*******
**# Meccanismi
/*
global cis "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/original_data/CIS/_data_cis/"
use ${cis}barometros.dta, clear

egen id_type = group(type)
drop if year_birth<1910
tab ESTU

g age_c = floor(age/10)


preserve
gen treat3=year_birth>1930
foreach var in kids nkids  {

reghdfe `var'  1.treat3  if (year_birth<=1931 & year_birth>=1930), a(id#age  )  cluster(id)
outreg2 using ${dataout}table_cis_`var', dec(3)  label nonotes addtext( Mun. FE, YES, Period, 1930/1931)   tex(frag) keep(1.treat3) nocons replace

reghdfe `var'  1.treat3    if  (year_birth<=1939 & year_birth>=1921), a(id#age  )  cluster(id)
outreg2 using ${dataout}table_cis_`var', dec(3)  label nonotes addtext( Mun. FE, YES, Period, 1921-30/1931-39)   tex(frag) keep(1.treat3 ) nocons 

reghdfe `var'  1.treat3  if (year_birth<=1931 & year_birth>=1930), a(id#age  )  cluster(id)
outreg2 using ${dataout}table_cis_`var', dec(3)  label nonotes addtext( Mun. FE, YES, Period, 1930/1931)   tex(frag) keep(1.treat3) nocons 

reghdfe `var'  1.treat3    if  (year_birth<=1939 & year_birth>=1921), a(id#age )  cluster(id)
outreg2 using ${dataout}table_cis_`var', dec(3)  label nonotes addtext( Mun. FE, YES, Period, 1921-30/1931-39)   tex(frag) keep(1.treat3 ) nocons 

}


preserve
gen treat3=year_birth>1939
foreach var in kids nkids  {

reghdfe `var'  1.treat3  if female==1 & (year_birth<=1940 &year_birth>=1939), a(id#age ) cluster(id)
outreg2 using ${dataout}table_cis_`var', dec(3)  label nonotes addtext( Mun. FE, YES, Period, 1930/1931)   tex(frag) keep(1.treat3) nocons replace

reghdfe `var'  1.treat3    if female==1 & (year_birth<=1948 &year_birth>=1931), a(id#age ) cluster(id)
outreg2 using ${dataout}table_cis_`var', dec(3)  label nonotes addtext( Mun. FE, YES, Period, 1921-30/1931-39)   tex(frag) keep(1.treat3 ) nocons 

reghdfe `var'  1.treat3  if female==0 & (year_birth<=1940 &year_birth>=1939), a(id#age ) cluster(id)
outreg2 using ${dataout}table_cis_`var', dec(3)  label nonotes addtext( Mun. FE, YES, Period, 1930/1931)   tex(frag) keep(1.treat3) nocons 

reghdfe `var'  1.treat3    if female==0 & (year_birth<=1948 &year_birth>=1931), a(id#age) cluster(id)
outreg2 using ${dataout}table_cis_`var', dec(3)  label nonotes addtext( Mun. FE, YES, Period, 1921-30/1931-39)   tex(frag) keep(1.treat3 ) nocons 

}
*/

********* Meccanismi
/* PROVARE: ideal_fam_equal benefit_marr_both benefit_marr_husb control_natal_woman control_natal_both school_meet_wife school_meet_both absentwork_wife absentwork_both women_work housework_impede women_workdouble toomuch_housework decision_own decision_husb everyb_works free_housework happ_sharehousework happ_ecoindepend*/


global cis "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/original_data/CIS/_data_cis/"
*global cis "C:\Users\laxge\Dropbox\GEMA\RESEARCH\PURGE\original_data\CIS\_data_cis\"
use ${cis}barometros.dta, clear

egen id_type = group(type)
drop if year_birth<1910
tab ESTU

g age_c = floor(age/10)

gen treat=.
replace treat=0 if year_birth<=1930
replace treat=1 if year_birth>1930 & year_birth<1940
replace treat=2 if year_birth>=1940 

ta treat, gen(treat_)
label var treat_2 "1931/1939"
label var treat_3 "1940/1952"

replace kids=0 if nkids==0 & kids==.

gen flag= age_together-age_partner_together
gen year_partner=year_birth+flag

*keep if female==1
keep if year_birth<=1970
keep if year_birth>=1920

ta year_birth, gen (year_birth_)

label var year_birth_1 "1920"  
label var year_birth_2 " "  
label var year_birth_3 "1922"  
label var year_birth_4 " "  
label var year_birth_5 "1924"  
label var year_birth_6 " "  
label var year_birth_7 "1926"  
label var year_birth_8 " "  
label var year_birth_9 "1928"  
label var year_birth_10 " "  
label var year_birth_11 "1930"   
label var year_birth_12 " " 
label var year_birth_13 "1932" 
label var year_birth_14 " " 
label var year_birth_15 "1934" 
label var year_birth_16 " " 
label var year_birth_17 "1936" 
label var year_birth_18 " " 
label var year_birth_19 "1938" 
label var year_birth_20 " " 
label var year_birth_21 "1940" 
label var year_birth_22 " " 
label var year_birth_23 "1942" 
label var year_birth_24 " " 
label var year_birth_25 "1944" 
label var year_birth_26 " " 
label var year_birth_27 "1946" 
label var year_birth_28 " " 
label var year_birth_29 "1948" 
label var year_birth_30" " 
label var year_birth_31 "1950" 
label var year_birth_32 " " 
label var year_birth_33 "1952" 
label var year_birth_34 " " 
label var year_birth_35 "1954" 
label var year_birth_36 " " 
label var year_birth_37 "1956" 
label var year_birth_38 " " 
label var year_birth_39 "1958" 
label var year_birth_40 " " 
label var year_birth_41 "1960" 
label var year_birth_42 " " 
label var year_birth_43 "1962" 
label var year_birth_44 " " 
label var year_birth_45 "1964" 
label var year_birth_46 " " 
label var year_birth_47 "1966" 
label var year_birth_48 " " 
label var year_birth_49 "1968" 
label var year_birth_50 " " 
label var year_birth_51 "1970" 

*gen unemp=1 if lab_situ==2
*replace unemp=0 if lab_situ==1
gen nonwork=lab_situ==3
gen unemp=lab_situ==2
gen emp=lab_situ==1



***** Fertility

** DID
foreach var in kids nkids {
reghdfe `var' treat_2 treat_3  if female==1 & year_birth<=1952, a(i.id#i.c_age i.year) cluster(i.id#i.c_age) version(5)
if "`var'" == "kids" {
	label var `var' "Kids" 
outreg2 using ${dataout}table_cis_kids, dec(3)  label nonotes addtext( Mun. X Age class FE, YES, Year FE, YES)   tex(frag) keep(treat_2 treat_3)  nocons replace     
}
	else if "`var'" != "kids" {
			label var `var' "N. kids" 
outreg2 using ${dataout}table_cis_kids, dec(3)  label nonotes addtext( Mun. X Age class FE, YES, Year FE, YES)   tex(frag) keep(treat_2 treat_3) nocons 
	}
	
*reghdfe `var' treat_2 treat_3 year_partner  if female==0 & year_birth<=1952, a(i.id#i.age_c i.ESTU )  cluster(i.id#age_c)
*outreg2 using ${dataout}table_cis_kids, dec(3)  label nonotes addtext( Mun. X Age class FE, YES, Year FE, YES)   tex(frag) keep(treat_2 treat_3) nocons 
}


** Event study

* Female
reghdfe nkids year_birth_1-year_birth_10 o.year_birth_11 year_birth_12-year_birth_33   if female==1 & year_birth<=1952, a(i.id#i.c_age i.year) cluster(i.id#age_c) 

coefplot , keep(year_birth_*) vertical base omitted  yline(0, lc(red) lp(dash)) xline(11, lcolor(blue) lpattern(dash)) xline(21, lcolor(green) lpattern(dash)) ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) /*title("`name'", s(small) c(black))*/ ytitle("Number of kids", s(small)) scheme(s2mono) xtick(1(2)33) xlabel(, angle(45) labs(tiny))   

graph export ${dataout}nkids_female.pdf,replace

* Male
reghdfe nkids year_birth_1-year_birth_10 o.year_birth_11 year_birth_12-year_birth_33 year_partner  if female==0 & year_birth<=1952, a( i.id#age_c year ) cluster(i.id##age_c) 

coefplot , keep(year_birth_*) vertical base omitted  yline(0, lc(red) lp(dash)) xline(11, lcolor(blue) lpattern(dash)) xline(21, lcolor(green) lpattern(dash)) ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) /*title("`name'", s(small) c(black))*/ ytitle("Number of kids", s(small)) scheme(s2mono) xtick(1(2)33) xlabel(, angle(45) labs(tiny))   

graph export ${dataout}nkids_male.pdf,replace



***** Unemployment, right, education


** DID
foreach var in emp  {
reghdfe `var' treat_2 treat_3 if female==1 & year_birth<=1952, a(i.id#i.age_c i.year  ) cluster(i.id#age_c)
	label var `var' "Employed" 
outreg2 using ${dataout}table_cis_emp, dec(3)  label nonotes addtext( Mun. X Age class FE, YES, Year FE, YES)   tex(frag) keep(treat_2 treat_3)  nocons replace 
    
*reghdfe `var' treat_2 treat_3 year_partner  if female==0 & year_birth<=1952, a(i.id#i.age_c i.ESTU )  cluster(i.id#age_c)
*outreg2 using ${dataout}table_cis_kids, dec(3)  label nonotes addtext( Mun. X Age class FE, YES, Year FE, YES)   tex(frag) keep(treat_2 treat_3) nocons 
}

** DID
foreach var in  unemp nonwork  right education {
reghdfe `var' treat_2 treat_3 if female==1 & year_birth<=1952, a(i.id#i.age_c i.year  ) cluster(i.id#age_c)
if "`var'" == "right" {
	label var `var' "Right-wing" 
}
else if "`var'" == "education" {
	label var `var' "Education" 
}
else if "`var'" == "unemp" {
	label var `var' "Unemployed" 
}
else if "`var'" == "nonwork" {
	label var `var' "Non-working" 
}
outreg2 using ${dataout}table_cis_emp, dec(3)  label nonotes addtext( Mun. X Age class FE, YES, Year FE, YES)   tex(frag) keep(treat_2 treat_3)  nocons  
    
*reghdfe `var' treat_2 treat_3 year_partner  if female==0 & year_birth<=1952, a(i.id#i.age_c i.ESTU )  cluster(i.id#age_c)
*outreg2 using ${dataout}table_cis_kids, dec(3)  label nonotes addtext( Mun. X Age class FE, YES, Year FE, YES)   tex(frag) keep(treat_2 treat_3) nocons 
}


 

***** Primary beliefs
foreach var in  ideal_fam_equal ideal_fam_wifehome control_natal_both school_meet_wife absentwork_wife  husb_nothouseworks husb_lesshouseworks   stab_sharehousework stab_kids stab_wifework realwoman_kids  cleanhouse_woman   women_work free_housework import_marry import_work import_mother import_family import_religion happ_sharehousework happ_kids pro_abort_church pro_art_fert pro_contracep     {
preserve
rename treat_2 outcome
eststo est_`var':reghdfe `var' outcome treat_3  if female==1  , a(i.id) cluster(id)
restore
preserve
rename treat_3 outcome
eststo est_`var'_3:reghdfe `var' treat_2 outcome   if female==1  , a(i.id ) cluster(id)
restore
if "`var'" == "ideal_fam_equal" {
outreg2 using ${dataout}table_cis_primary, dec(3)  label nonotes addtext( Mun. X Age class FE, YES, Year FE, YES)   tex(frag) keep(treat_2 treat_3) nocons replace 
    }
	else if "`var'" != "ideal_fam_equal" {
outreg2 using ${dataout}table_cis_primary, dec(3)  label nonotes addtext( Mun. X Age class FE, YES, Year FE, YES)   tex(frag) keep(treat_2 treat_3) nocons 
	}
	} 
	
	
coefplot (est_import_family, aseq(import_family) ///
	\ est_import_marry, aseq(import_marry) ///
	\ est_ideal_fam_equal, aseq(ideal_fam_equal) ///
	\ est_control_natal_both, aseq(control_natal_both) ///
	\ est_school_meet_wife, aseq(school_meet_wife) ///
	\ est_absentwork_wife, aseq(absentwork_wife) ///
	\ est_husb_nothouseworks, aseq(husb_nothouseworks) ///
	\ est_husb_lesshouseworks, aseq(husb_lesshouseworks) ///
	\ est_stab_sharehousework, aseq(stab_sharehousework) ///
	\ est_happ_sharehousework, aseq(happ_sharehousework) ///
	\ est_stab_kids, aseq(stab_kids) ///
	\ est_happ_kids, aseq(happ_kids) ///
	\ est_import_mother, aseq(import_mother) ///
	\ est_realwoman_kids, aseq(realwoman_kids) ///
	\ est_women_work, aseq(women_work) ///
	\ est_stab_wifework, aseq(stab_wifework) ///    
	\ est_import_work, aseq(import_work) ///
	\ est_pro_abort_church, aseq(pro_abort_church) ///
	\ est_pro_art_fert, aseq(pro_art_fert) ///
	\ est_pro_contracep, aseq(pro_contracep)), by(,graphregion(color(white))) subtitle(, bc(white)) bylabel(Partially treated (1931/39)) ///
	|| (est_import_family_3, aseq(import_family) ///
	\ est_import_marry_3, aseq(import_marry) ///
	\ est_ideal_fam_equal_3, aseq(ideal_fam_equal) ///
	\ est_control_natal_both_3, aseq(control_natal_both) ///
	\ est_school_meet_wife_3, aseq(school_meet_wife) ///
	\ est_absentwork_wife_3, aseq(absentwork_wife) ///
	\ est_husb_nothouseworks_3, aseq(husb_nothouseworks) ///
	\ est_husb_lesshouseworks_3, aseq(husb_lesshouseworks) ///
	\ est_stab_sharehousework_3, aseq(stab_sharehousework) ///
	\ est_happ_sharehousework_3, aseq(happ_sharehousework) ///
	\ est_stab_kids_3, aseq(stab_kids) ///
	\ est_happ_kids_3, aseq(happ_kids) ///
	\ est_import_mother_3, aseq(import_mother) ///
	\ est_realwoman_kids_3, aseq(realwoman_kids) ///
	\ est_women_work_3, aseq(women_work) ///
	\ est_stab_wifework_3, aseq(stab_wifework) ///
	\ est_import_work_3, aseq(import_work) ///
	\ est_pro_abort_church_3, aseq(pro_abort_church) ///
	\ est_pro_art_fert_3, aseq(pro_art_fert) ///
	\ est_pro_contracep_3, aseq(pro_contracep)),  by(,graphregion(color(white)))  bylabel(Fully treated (1940/70)) ///
	|| , group(import_family import_marry ideal_fam_equal control_natal_both school_meet_wife absentwork_wife  husb_nothouseworks husb_lesshouseworks stab_sharehousework happ_sharehousework = "{bf:Roles in the family}" ///
	stab_kids happ_kids import_mother realwoman_kids = "{bf:Motherhood}" ///
	women_work stab_wifework import_work = "{bf:Working}" pro_abort_church pro_art_fert pro_contracep  = "{bf:Church}", labgap(0) labs(small)) xline(0, lp(dash) ) pstyle(p10) pstyle(p23)  aseq swapnames  ci(95) msize(.5) keep(outcome)  ylabel( 1 "Importance of family (1992)"  2 "Realized woman: Marry (1990)" 3 "Gender roles: Equal (1990)"  4 "Birth control: Both (1990)" 5 "School meetings: Wife (1990)" 6 "Absent from work: Wife (1990)" 7 "Husband no housework (1990)" 8 "Husband less housework (1990)"   9 "Couple's stability: Shared housework (1990)" 10 "Couple's happiness: Shared housework (1992)"    12 "Couple's stability: Kids (1990)"    13 "Couple's happiness: Kids (1992)" 14 "Realized woman: Kids (1990)"  15 "Real woman has kids (1990)"  17 "Woman works (1990)"  18 "Couple's stability: Wife works (1990)" 19 "Realized woman: Work (1990)" 21 "Agree with Church: Abortion (1990)" 22 "Agree with Church: Artificial procreation (1990)" 23 "Agree with Church: Contraception (1990)" , labs(vsmall) ) yscale(noline   reverse) xlabel(, labs(vsmall))  //legend(off) 
graph save ${dataout}cis_2.gph, replace
graph export ${dataout}cis.pdf, replace	



****** Event study
	local varlist "  import_family import_marry ideal_fam_equal control_natal_both school_meet_wife absentwork_wife  husb_nothouseworks husb_lesshouseworks stab_sharehousework happ_sharehousework stab_kids happ_kids import_mother realwoman_kids women_work stab_wifework import_work   pro_abort_church pro_art_fert pro_contracep    "
	


foreach var in `varlist' {
    if "`var'" == "husb_lesshouseworks" {
        local name = "Husband less housework (1990)"
    }

    else if "`var'" == "import_family" {
        local name = "Importance of family (1992)"
    }
	else if "`var'" == "control_natal_both" {
        local name = "Birth control: Both (1990)"
    }
   
    else if "`var'" == "realwoman_kids" {
        local name = "Real woman has kids (1990)"
    }
    
    else if "`var'" == "school_meet_wife" {
        local name = "School meetings: Wife (1990)"
    }
	else if "`var'" == "absentwork_wife" {
        local name = "Absent work: Wife (1990)"
    }
	else if "`var'" == "husb_nothouseworks" {
        local name = "Husband no housework (1990)"
    }
    else if "`var'" == "stab_kids" {
        local name = "Couple's stability: Kids (1990)"
    }
    else if "`var'" == "happ_kids" {
        local name = "Couple's happiness: Kids (1992)"
    }
    else if "`var'" == "ideal_fam_wifehome" {
        local name = "Gender roles: Wife at home (1990)"
    }
	else if "`var'" == "ideal_fam_equal" {
        local name = "Gender roles: Equal (1990)"
    }
    else if "`var'" == "import_marry" {
        local name = "Realized woman: Marry (1990)"
    }
    else if "`var'" == "import_mother" {
        local name = "Realized woman: Mother (1990)"
    }
    else if "`var'" == "import_work" {
        local name = "Realized woman: Work (1990)"
    }
	
	else if "`var'" == "women_work" {
        local name = "Woman works (1990)"
    }
    
    else if "`var'" == "stab_sharehousework" {
        local name = "Couple's stability: Shared housework (1990)"
    }
	else if "`var'" == "happ_sharehousework" {
        local name = "Couple's happiness: Shared housework (1992)"
    }
    else if "`var'" == "stab_wifework" {
        local name = "Couple's stability: Wife works (1990)"
    }
	else if "`var'" == "pro_abort_church" {
        local name = "Agree with Church: Abortion (1990)"
    }
	else if "`var'" == "pro_art_fert" {
        local name = "Agree with Church: Artificial procreation (1990)"
    }
	else if "`var'" == "pro_contracep" {
        local name = "Agree with Church: Contraception (1990)"
    }
	
    else {
        local name = "ERROR"
    }


reghdfe `var' year_birth_1-year_birth_10 o.year_birth_11 year_birth_12-year_birth_51 if female==1  , a(i.id  ) cluster(id)

coefplot , keep(year_birth_*) vertical base omitted  yline(0, lc(red) lp(dash)) xline(11, lcolor(blue) lpattern(dash)) xline(21, lcolor(green) lpattern(dash)) ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) /*title("`name'", s(small) c(black))*/ title("`name'", s(small)) scheme(s2mono) xtick(1(2)33) xlabel(, angle(45) labs(tiny))   ///

graph save ${dataout}`var'.gph,replace
}

cd ${dataout}

graph combine  import_family.gph import_marry.gph ideal_fam_equal.gph control_natal_both.gph school_meet_wife.gph absentwork_wife.gph  husb_nothouseworks.gph husb_lesshouseworks.gph stab_sharehousework.gph happ_sharehousework.gph stab_kids.gph happ_kids.gph import_mother.gph realwoman_kids.gph women_work.gph stab_wifework.gph import_work.gph pro_abort_church.gph pro_art_fert.gph pro_contracep.gph    , graphregion(color(white))  

graph export ${dataout}cis_event.pdf, replace

 
 

***** Secondary belief

foreach var in  pro_law_abort  pro_euthanasia  pro_art_fert pro_contracep pro_abort_church   {
reghdfe `var' treat_2 treat_3  if female==1  , a(i.id  ) vce(robust)
esttab, beta not
est sto est_`var'
if "`var'" == "pro_law_abort" {
outreg2 using ${dataout}table_cis_secondary, dec(3)  label nonotes addtext( Mun. X Age class FE, YES, Year FE, YES)   tex(frag) keep(treat_2 treat_3) nocons replace 
    }
	else if "`var'" != "pro_law_abort" {
outreg2 using ${dataout}table_cis_secondary, dec(3)  label nonotes addtext( Mun. X Age class FE, YES, Year FE, YES)   tex(frag) keep(treat_2 treat_3) nocons 
	}
	} 
	



***** Primary beliefs --- male
foreach var in  ideal_fam_equal ideal_fam_wifehome control_natal_both school_meet_wife absentwork_wife  husb_nothouseworks husb_lesshouseworks   stab_sharehousework stab_kids stab_wifework realwoman_kids  cleanhouse_woman   import_marry import_work import_mother import_family import_religion happ_sharehousework happ_kids pro_abort_church pro_art_fert pro_contracep     {
preserve
rename treat_2 outcome
eststo est_`var':reghdfe `var' outcome treat_3  if female==0  , a(i.id) cluster(id)
restore
preserve
rename treat_3 outcome
eststo est_`var'_3:reghdfe `var' treat_2 outcome   if female==0  , a(i.id ) cluster(id)
restore
if "`var'" == "ideal_fam_equal" {
outreg2 using ${dataout}table_cis_primary, dec(3)  label nonotes addtext( Mun. X Age class FE, YES, Year FE, YES)   tex(frag) keep(treat_2 treat_3) nocons replace 
    }
	else if "`var'" != "ideal_fam_equal" {
outreg2 using ${dataout}table_cis_primary, dec(3)  label nonotes addtext( Mun. X Age class FE, YES, Year FE, YES)   tex(frag) keep(treat_2 treat_3) nocons 
	}
	} 
	
	
coefplot (est_import_family, aseq(import_family) ///
	\ est_import_marry, aseq(import_marry) ///
	\ est_ideal_fam_equal, aseq(ideal_fam_equal) ///
	\ est_control_natal_both, aseq(control_natal_both) ///
	\ est_school_meet_wife, aseq(school_meet_wife) ///
	\ est_absentwork_wife, aseq(absentwork_wife) ///
	\ est_husb_nothouseworks, aseq(husb_nothouseworks) ///
	\ est_husb_lesshouseworks, aseq(husb_lesshouseworks) ///
	\ est_stab_sharehousework, aseq(stab_sharehousework) ///
	\ est_happ_sharehousework, aseq(happ_sharehousework) ///
	\ est_stab_kids, aseq(stab_kids) ///
	\ est_happ_kids, aseq(happ_kids) ///
	\ est_import_mother, aseq(import_mother) ///
	\ est_realwoman_kids, aseq(realwoman_kids) ///
	\ est_stab_wifework, aseq(stab_wifework) ///    
	\ est_import_work, aseq(import_work) ///
	\ est_pro_abort_church, aseq(pro_abort_church) ///
	\ est_pro_art_fert, aseq(pro_art_fert) ///
	\ est_pro_contracep, aseq(pro_contracep)), by(,graphregion(color(white))) subtitle(, bc(white)) bylabel(Partially treated (1931/39)) ///
	|| (est_import_family_3, aseq(import_family) ///
	\ est_import_marry_3, aseq(import_marry) ///
	\ est_ideal_fam_equal_3, aseq(ideal_fam_equal) ///
	\ est_control_natal_both_3, aseq(control_natal_both) ///
	\ est_school_meet_wife_3, aseq(school_meet_wife) ///
	\ est_absentwork_wife_3, aseq(absentwork_wife) ///
	\ est_husb_nothouseworks_3, aseq(husb_nothouseworks) ///
	\ est_husb_lesshouseworks_3, aseq(husb_lesshouseworks) ///
	\ est_stab_sharehousework_3, aseq(stab_sharehousework) ///
	\ est_happ_sharehousework_3, aseq(happ_sharehousework) ///
	\ est_stab_kids_3, aseq(stab_kids) ///
	\ est_happ_kids_3, aseq(happ_kids) ///
	\ est_import_mother_3, aseq(import_mother) ///
	\ est_realwoman_kids_3, aseq(realwoman_kids) ///
	\ est_stab_wifework_3, aseq(stab_wifework) ///
	\ est_import_work_3, aseq(import_work) ///
	\ est_pro_abort_church_3, aseq(pro_abort_church) ///
	\ est_pro_art_fert_3, aseq(pro_art_fert) ///
	\ est_pro_contracep_3, aseq(pro_contracep)),  by(,graphregion(color(white)))  bylabel(Fully treated (1940/70)) ///
	|| , group(import_family import_marry ideal_fam_equal control_natal_both school_meet_wife absentwork_wife  husb_nothouseworks husb_lesshouseworks stab_sharehousework happ_sharehousework = "{bf:Roles in the family}" ///
	stab_kids happ_kids import_mother realwoman_kids = "{bf:Motherhood}" ///
	women_work stab_wifework import_work = "{bf:Working}" pro_abort_church pro_art_fert pro_contracep  = "{bf:Church}", labgap(0) labs(small)) xline(0, lp(dash) ) pstyle(p10) pstyle(p23)  aseq swapnames  ci(95) msize(.5) keep(outcome)  ylabel( 1 "Importance of family (1992)"  2 "Realized woman: Marry (1990)" 3 "Gender roles: Equal (1990)"  4 "Birth control: Both" 5 "School meetings: Wife (1990)" 6 "Absent from work: Wife (1990)" 7 "Husband no housework (1990)" 8 "Husband less housework (1990)"   9 "Couple's stability: Shared housework (1990)" 10 "Couple's happiness: Shared housework (1992)"    12 "Couple's stability: Kids (1990)"    13 "Couple's happiness: Kids (1992)" 14 "Realized woman: Kids (1990)"  15 "Real woman has kids (1990)"    17 "Couple's stability: Wife works (1990)" 18 "Realized woman: Work (1990)" 20 "Agree with Church: Abortion (1990)" 21 "Agree with Church: Artificial procreation (1990)" 22 "Agree with Church: Contraception (1990)" , labs(vsmall) ) yscale(noline   reverse) xlabel(, labs(vsmall))  //legend(off) 
graph save ${dataout}cis_2.gph, replace
graph export ${dataout}cis.pdf, replace	


	
	


