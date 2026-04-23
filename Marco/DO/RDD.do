global datain "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/output_data/"
global datain2 "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/original_data/INE_microdatos/"
global dataout "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/Marco/Results/"


****** 1991 --- provincial
use ${datain2}censo1991/por_provincias/censo1991_provincias.dta, clear
rename *, lower
replace fecha=. if fecha>100
gen anac=1992-fecha

keep if anac<=1970
keep if anac>=1920
*replace hijos=0 if sexo==6 & hijos==.

gen kids2=hijos>0 & hijos!=.
replace kids2=. if hijos==.

*gen kids=kids2

ta eciv, gen(civil_status_)
foreach var in civil_status_1 civil_status_2 civil_status_3 civil_status_4 civil_status_5{
	replace `var'=. if eciv==.
}
replace civil_status_4=1 if civil_status_4==0 & civil_status_5==1
drop civil_status_5
rename civil_status_1 single
rename civil_status_2 married
rename civil_status_3 widowed
rename civil_status_4 separated_divorced

gen year=1991
rename munacin cmunn
rename prov codprov
rename pronacin codprov_born
rename mun cmun
rename hijos nhijos


gen weight=fe/10000


save ${datain}dataset_microdata1991_cleanedMarco.dta, replace

/*
****** 1991 --- national
use ${datain}dataset_microdata1991_2pc.dta, clear
rename *, lower
replace fecha=. if fecha>100
gen anac=1992-fecha

keep if anac<=1970
keep if anac>=1920

gen kids2=hijos>0 & hijos!=.
replace kids2=. if hijos==.

ta eciv, gen(civil_status_)
foreach var in civil_status_1 civil_status_2 civil_status_3 civil_status_4 civil_status_5{
	replace `var'=. if eciv==.
}
replace civil_status_4=1 if civil_status_4==0 & civil_status_5==1
drop civil_status_5
rename civil_status_1 single
rename civil_status_2 married
rename civil_status_3 widowed
rename civil_status_4 separated_divorced

gen year=1991
rename munacin cmunn
rename hijos nhijos
rename prov codprov
rename pronacin codprov_born
rename mes mnac
rename mun cmun
gen weight=fe/10000


save ${datain}dataset_microdata1991_cleanedMarco.dta, replace
*/

****** 2011
use ${datain2}censo2011/por_provincias/censo2011_provincias.dta, clear
rename *, lower

keep if anac<=1970
keep if anac>=1920

gen kids=nhijo>0 & nhijo!=.
replace kids=. if nhijo==.

gen kids2=hijos==1
replace kids2=. if hijos==.

replace nhijos=0 if kids2==0

ta ecivil, gen(civil_status_)
foreach var in civil_status_1 civil_status_2 civil_status_3 civil_status_4 civil_status_5{
	replace `var'=. if ecivil==.
}
replace civil_status_4=1 if civil_status_4==0 & civil_status_5==1
drop civil_status_5
rename civil_status_1 single
rename civil_status_2 married
rename civil_status_3 widowed
rename civil_status_4 separated_divorced

gen year=2011
rename cpro codprov
rename cpron codprov_born
gen weight=factor
save ${datain}dataset_microdata2011_cleanedMarco.dta, replace


****** 2001
use ${datain2}censo2001/por_provincias/censo2001_provincias.dta, clear
rename *, lower

keep if anac<=1970
keep if anac>=1920

gen kids2=ntothij>0 & ntothij!=.
replace kids2=. if ntothij==.

ta ecivil, gen(civil_status_)
foreach var in civil_status_1 civil_status_2 civil_status_3 civil_status_4 civil_status_5{
	replace `var'=. if ecivil==.
}
replace civil_status_4=1 if civil_status_4==0 & civil_status_5==1
drop civil_status_5
rename civil_status_1 single
rename civil_status_2 married
rename civil_status_3 widowed
rename civil_status_4 separated_divorced

gen year=2001
rename cpro codprov
rename cpron codprov_born

append using ${datain}dataset_microdata1991_cleanedMarco.dta
append using ${datain}dataset_microdata2011_cleanedMarco.dta

gen anac_m=ym(anac, mnac)
format %tm anac_m

gen treat=.
replace treat=0 if anac<=1930
replace treat=1 if anac>1930 & anac<1940
replace treat=2 if anac>=1940 

ta treat, gen(treat_)
label var treat_2 "1931/1939"
label var treat_3 "1940/1952"



******* DID ED EVENT CENSUS
foreach var in kids2 nhijos   {
preserve
drop if year==2001
gen interaction0a=(treat==1)
gen interaction0b=(treat==2)
g age_c = floor(edad/10)

gen age_c2=1 if age_c>=2 & age_c<=3
replace age_c2=2 if age_c>=4 & age_c<=5
replace age_c2=3 if age_c>=6 & age_c<=7
replace age_c2=4 if age_c>=8 & age_c<=9

reghdfe `var' treat_2 treat_3  if sexo==6 & anac>=1920 & anac<=1951, a(cmun#i.age_c year) cluster(cmun#i.age_c )
if "`var'" == "kids2" {
outreg2 using ${dataout}table_census_kids, dec(3)  label nonotes addtext( Mun. X Age class FE, YES, Year FE, YES)   tex(frag) keep( treat_2 treat_3) nocons replace 
    }
	else if "`var'" != "kids2" {
outreg2 using ${dataout}table_census_kids, dec(3)  label nonotes addtext( Mun. X Age class FE, YES, Year FE, YES)   tex(frag) keep( treat_2 treat_3) nocons 
	}

restore
}


* Event study
preserve
g age_c = floor(edad/10)


drop if year==2001
ta anac, gen (anac_)


label var anac_1 "1920"  
label var anac_2 " "  
label var anac_3 "1922"  
label var anac_4 " "  
label var anac_5 "1924"  
label var anac_6 " "  
label var anac_7 "1926"  
label var anac_8 " "  
label var anac_9 "1928"  
label var anac_10 " "  
label var anac_11 "1930"   
label var anac_12 " " 
label var anac_13 "1932" 
label var anac_14 " " 
label var anac_15 "1934" 
label var anac_16 " " 
label var anac_17 "1936" 
label var anac_18 " " 
label var anac_19 "1938" 
label var anac_20 " " 
label var anac_21 "1940" 
label var anac_22 " " 
label var anac_23 "1942" 
label var anac_24 " " 
label var anac_25 "1944" 
label var anac_26 " " 
label var anac_27 "1946" 
label var anac_28 " " 
label var anac_29 "1948" 
label var anac_30" " 
label var anac_31 "1950" 
label var anac_32 " " 
label var anac_33 "1952" 
label var anac_34 " " 
label var anac_35 "1954" 
label var anac_36 " " 
label var anac_37 "1956" 
label var anac_38 " " 
label var anac_39 "1958" 
label var anac_40 " " 
label var anac_41 "1960" 
label var anac_42 " " 
label var anac_43 "1962" 
label var anac_44 " " 
label var anac_45 "1964" 
label var anac_46 " " 
label var anac_47 "1966" 
label var anac_48 " " 
label var anac_49 "1968" 
label var anac_50 " " 
label var anac_51 "1970" 

gen age_c2=1 if age_c>=2 & age_c<=3
replace age_c2=2 if age_c>=4 & age_c<=5
replace age_c2=3 if age_c>=6 & age_c<=7
replace age_c2=4 if age_c>=8 & age_c<=9

local varlist "nhijos"
	

foreach var in `varlist' {
    if "`var'" == "nhijo" {
        local name = "Number of kids"
    }

reghdfe `var'  anac_1-anac_10 o.anac_11 anac_12-anac_32  if sexo==6 & anac>=1920 & anac<=1951, a(cmun#i.age_c year)  cluster(cmun#i.age_c )

coefplot , vertical keep(anac_*)  base omitted  yline(0, lc(red) lp(dash)) xline(11, lcolor(blue) lpattern(dash)) xline(21, lcolor(green) lpattern(dash)) ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) /*title("`name'", s(small) c(black))*/ title("`name'", s(small)) scheme(s2mono) xtick(1(2)31) xlabel(, angle(45) labs(tiny))   

graph export ${dataout}`var'_census.pdf,replace
}
restore



/*
** DID CON DISCONTINUITY

preserve
drop if year==2001
g age_c = floor(edad/10)
foreach var in kids2 /*nhijo married */  {

gen treat2=anac>1930
reghdfe `var'  1.treat2  [aw=weight] if sexo==6 & (anac<=1931 &anac>=1930), a(cmun edad) vce(robust)
outreg2 using ${dataout}table_census_`var', dec(3)  label nonotes addtext( Mun. FE, YES, Period, 1930/1931)   tex(frag) keep(1.treat2) nocons replace

reghdfe `var'  1.treat2  [aw=weight]  if sexo==6 & (anac<=1939 &anac>=1921), a(cmun edad) vce(robust)
outreg2 using ${dataout}table_census_`var', dec(3)  label nonotes addtext( Mun. FE, YES, Period, 1921-30/1931-39)   tex(frag) keep(1.treat2 ) nocons 
/*
reghdfe `var'  1.treat2   if sexo==1 & (anac<=1931 &anac>=1930), a(cmun edad ) vce(robust)
outreg2 using ${dataout}table_census_`var', dec(3)  label nonotes addtext( Mun. FE, YES, Period, 1930/1931)   tex(frag) keep(1.treat2) nocons 

reghdfe `var'  1.treat2 if sexo==1 & (anac<=1939 &anac>=1921), a(cmun edad) vce(robust)
outreg2 using ${dataout}table_census_`var', dec(3)  label nonotes addtext( Mun. FE, YES, Period, 1921-30/1931-39)   tex(frag) keep(1.treat2 ) nocons */
}
restore


preserve
drop if year==2001
foreach var in kids2 /*nhijo married */  {
gen treat2=anac>1939
reghdfe `var'  1.treat2  if sexo==6 & (anac<=1940 &anac>=1939), a(cmun edad ) vce(robust)
outreg2 using ${dataout}table_census_`var', dec(3)  label nonotes addtext( Mun. FE, YES, Period, 1939/1940)   tex(frag) keep(1.treat2) nocons 

reghdfe `var'  1.treat2 if sexo==6 & (anac<=1948 &anac>=1931), a(cmun edad ) vce(robust)
outreg2 using ${dataout}table_census_`var', dec(3)  label nonotes addtext( Mun. FE, YES, Period, 1931-39/1940-48)   tex(frag) keep(1.treat2 ) nocons 
/*
reghdfe `var'  1.treat2 edad if sexo==1 & (anac<=1940 &anac>=1939), a(cmun edad ) vce(robust)
outreg2 using ${dataout}table_census_`var', dec(3)  label nonotes addtext( Mun. FE, YES, Period, 1939/1940)   tex(frag) keep(1.treat2) nocons 

reghdfe `var'  1.treat2 edad if sexo==1 & (anac<=1948 &anac>=1931), a(cmun edad ) vce(robust)
outreg2 using ${dataout}table_census_`var', dec(3)  label nonotes addtext( Mun. FE, YES, Period, 1931-39/1940-48)   tex(frag) keep(1.treat2 ) nocons */
}
restore


** Event

preserve
drop if year==2001
g age_c = floor(edad/10)
keep if anac>=1921 & anac<=1939
ta anac, gen (anac_)

label var anac_1 "1921"  
label var anac_2 " "  
label var anac_3 "1923"  
label var anac_4 " "  
label var anac_5 "1925"  
label var anac_6 " "  
label var anac_7 "1927"  
label var anac_8 " "  
label var anac_9 "1929"  
label var anac_10 " "  
label var anac_11 "1931"   
label var anac_12 " " 
label var anac_13 "1933" 
label var anac_14 " " 
label var anac_15 "1935" 
label var anac_16 " " 
label var anac_17 "1937" 
label var anac_18 " " 
label var anac_19 "1939" 


foreach var in kids2 /*nhijo married */  {

reghdfe `var'  anac_1-anac_9 o.anac_10 anac_11-anac_19 [aw=weight]  if sexo==6, a(  cmun#age_c#year  ) vce(robust)
coefplot , keep(anac_*) vertical base omitted  yline(0, lc(red) lp(dash)) xline(10, lcolor(black) lpattern(dash))  ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) /*title("`name'", s(small) c(black))*/ title("`name'", s(small)) scheme(s2mono) xtick(1(2)19) xlabel(, angle(45) labs(tiny))   
graph save ${dataout}`var'_female.gph,replace

/*
reghdfe `var'  anac_1-anac_9 o.anac_10 anac_11-anac_19  if sexo==1, a(cmun edad ) vce(robust)
coefplot , keep(anac_*) vertical base omitted  yline(0, lc(red) lp(dash)) xline(10, lcolor(black) lpattern(dash))  ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) /*title("`name'", s(small) c(black))*/ title("`name'", s(small)) scheme(s2mono) xtick(1(2)19) xlabel(, angle(45) labs(tiny))  
graph save ${dataout}`var'_male.gph,replace*/
}
restore



preserve
drop if year==2001
g age_c = floor(edad/10)
keep if anac>=1931 & anac<=1948
ta anac, gen (anac_)

label var anac_1 "1931"  
label var anac_2 " "  
label var anac_3 "1933"  
label var anac_4 " "  
label var anac_5 "1935"  
label var anac_6 " "  
label var anac_7 "1937"  
label var anac_8 " "  
label var anac_9 "1939"  
label var anac_10 " "  
label var anac_11 "1941"   
label var anac_12 " " 
label var anac_13 "1943" 
label var anac_14 " " 
label var anac_15 "1945" 
label var anac_16 " " 
label var anac_17 "1947" 
label var anac_18 " " 


foreach var in kids2 /*nhijo married */  {

reghdfe `var'  anac_1-anac_8 o.anac_9 anac_10-anac_18   if sexo==6, a( cmun#age_c#year  ) vce(robust)
coefplot , keep(anac_*) vertical base omitted  yline(0, lc(red) lp(dash)) xline(9, lcolor(black) lpattern(dash))  ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) /*title("`name'", s(small) c(black))*/ title("`name'", s(small)) scheme(s2mono) xtick(1(2)18) xlabel(, angle(45) labs(tiny))   ///

graph save ${dataout}`var'_female.gph,replace
/*
reghdfe `var'  anac_1-anac_8 o.anac_9 anac_10-anac_18   if sexo==1, a(cmun edad ) vce(robust)
coefplot , keep(anac_*) vertical base omitted  yline(0, lc(red) lp(dash)) xline(9, lcolor(black) lpattern(dash))  ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) /*title("`name'", s(small) c(black))*/ title("`name'", s(small)) scheme(s2mono) xtick(1(2)18) xlabel(, angle(45) labs(tiny))  
graph save ${dataout}`var'_male.gph,replace
ta year if e(sample)*/

}
restore
*/

/*
** Event

preserve
keep if anac==1930 | anac==1931
ta anac_m, gen (anac_m_)

label var anac_m_1 "Jan 1930"  
label var anac_m_2 " "  
label var anac_m_3 "Mar 1930"  
label var anac_m_4 " "  
label var anac_m_5 "May 1930"  
label var anac_m_6 " "  
label var anac_m_7 "Jul 1930"  
label var anac_m_8 " "  
label var anac_m_9 "Sept 1930"  
label var anac_m_10 " "  
label var anac_m_11 "Nov 1930"   
label var anac_m_12 " " 
label var anac_m_13 "Jan 1931" 
label var anac_m_14 " " 
label var anac_m_15 "Mar 1931" 
label var anac_m_16 " " 
label var anac_m_17 "May 1931" 
label var anac_m_18 " " 
label var anac_m_19 "Jul 1931" 
label var anac_m_20 " " 
label var anac_m_21 "Sept 1931" 
label var anac_m_22 " " 
label var anac_m_23 "Nov 1931" 
label var anac_m_24 " " 


foreach var in kids /*nhijo married */  {

reghdfe `var'  anac_m_1-anac_m_11 o.anac_m_12 anac_m_13-anac_m_24 edad if sexo==6, a(cmun  ) cluster(anac)
coefplot , keep(anac_m*) vertical base omitted  yline(0, lc(red) lp(dash)) xline(12, lcolor(black) lpattern(dash))  ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) /*title("`name'", s(small) c(black))*/ title("`name'", s(small)) scheme(s2mono) xtick(1(2)24) xlabel(, angle(45) labs(tiny))   ///

graph save ${dataout}`var'_female.gph,replace

reghdfe `var'  anac_m_1-anac_m_11 o.anac_m_12 anac_m_13-anac_m_24  edad if sexo==1, a(cmun ) cluster(anac)
coefplot , keep(anac_m*) vertical base omitted  yline(0, lc(red) lp(dash)) xline(12, lcolor(black) lpattern(dash))  ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) /*title("`name'", s(small) c(black))*/ title("`name'", s(small)) scheme(s2mono) xtick(1(2)24) xlabel(, angle(45) labs(tiny))   ///

graph save ${dataout}`var'_male.gph,replace
}
restore



preserve
keep if anac==1939 | anac==1940
ta anac_m, gen (anac_m_)

label var anac_m_1 "Jan 1939"  
label var anac_m_2 " "  
label var anac_m_3 "Mar 1939"  
label var anac_m_4 " "  
label var anac_m_5 "May 1939"  
label var anac_m_6 " "  
label var anac_m_7 "Jul 1939"  
label var anac_m_8 " "  
label var anac_m_9 "Sept 1939"  
label var anac_m_10 " "  
label var anac_m_11 "Nov 1939"   
label var anac_m_12 " " 
label var anac_m_13 "Jan 1940" 
label var anac_m_14 " " 
label var anac_m_15 "Mar 1940" 
label var anac_m_16 " " 
label var anac_m_17 "May 1940" 
label var anac_m_18 " " 
label var anac_m_19 "Jul 1940" 
label var anac_m_20 " " 
label var anac_m_21 "Sept 1940" 
label var anac_m_22 " " 
label var anac_m_23 "Nov 1940" 
label var anac_m_24 " " 


foreach var in kids /*nhijo married */  {

reghdfe `var'  anac_m_1-anac_m_11 o.anac_m_12 anac_m_13-anac_m_24 edad  if sexo==6, a(cmun ) cluster(anac)
coefplot , keep(anac_m*) vertical base omitted  yline(0, lc(red) lp(dash)) xline(12, lcolor(black) lpattern(dash))  ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) /*title("`name'", s(small) c(black))*/ title("`name'", s(small)) scheme(s2mono) xtick(1(2)24) xlabel(, angle(45) labs(tiny))   ///

graph save ${dataout}`var'_female.gph,replace

reghdfe `var'  anac_m_1-anac_m_11 o.anac_m_12 anac_m_13-anac_m_24 edad if sexo==1, a(cmun ) cluster(anac)
coefplot , keep(anac_m*) vertical base omitted  yline(0, lc(red) lp(dash)) xline(12, lcolor(black) lpattern(dash))  ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99) /*title("`name'", s(small) c(black))*/ title("`name'", s(small)) scheme(s2mono) xtick(1(2)24) xlabel(, angle(45) labs(tiny))   ///

graph save ${dataout}`var'_male.gph,replace
}
restore

*/


** RDD --- Anno
preserve
drop if year==2001
keep if anac>=1921 & anac<=1939
gen margin= anac-1931
*replace margin=margin-1 if margi<=0
ta cmun, gen(cmun_)
ta edad, gen(edad_)
ta codprov, gen(prov_)
gen flag=anac>=1931
g age_c = floor(edad/10)


*foreach var in kids2 /*nhijo married */  {

*rdrobust  `var'  margin if sexo==6 & abs(margin)<3, c(0) p(1) h(3 3) 

*xi: cmogram `var' margin if -9<margin & margin < 9, control(i.edad) scatter lfitci lfit l(0) cut(0) graphopts(xtitle("duce", s(small)) ytitle("Having a kid", c(black) s(small))) 

*}

reghdfe kids2 flag##c.margin [aw=weight]  if sexo==6 & abs(margin)<9, a(cmun#age_c#year ) vce(robust)

restore


preserve
drop if year==2001
keep if anac>=1931 & anac<=1948
gen margin= anac-1940
*replace margin=margin-1 if margi<=0
ta cmun, gen(cmun_)
ta edad, gen(edad_)
ta codprov, gen(prov_)
gen flag=anac>=1940
g age_c = floor(edad/10)


*foreach var in kids2 /*nhijo married */  {

*rdrobust  `var'  margin if sexo==6 & abs(margin)<3, c(0) p(1) h(3 3) 

*xi: cmogram `var' margin if -9<margin & margin < 9, control(i.edad) scatter lfitci lfit l(0) cut(0) graphopts(xtitle("duce", s(small)) ytitle("Having a kid", c(black) s(small))) 

*}

reghdfe kids2 flag##c.margin [aw=weight]  if sexo==6 & abs(margin)<9, a(cmun#age_c#year ) vce(robust)

restore


** RDD --- Mese
preserve
drop if year==2001
keep if anac>=1921 & anac<=1939
g age_c = floor(edad/10)
gen margin= anac_m-tm(1931m1)
*ta cmun, gen(cmun_)
*ta edad, gen(edad_)
*ta codprov, gen(prov_)
gen flag=anac_m>=tm(1931m1)
g x=.
g eff=.
g eff5=.
g eff95=.
g eff10=.
g eff90=. 

g x_ul=.
g eff_ul=.
g eff5_ul=.
g eff95_ul=.
g eff10_ul=.
g eff90_ul=. 

g x_tq=.
g eff_tq=.
g eff5_tq=.
g eff95_tq=.
g eff10_tq=.
g eff90_tq=. 

g x_uq=.
g eff_uq=.
g eff5_uq=.
g eff95_uq=.
g eff10_uq=.
g eff90_uq=. 

local j = 0
forval threshold=12(12)108 {
local j = `j' + 1
g WEIGHT = weight     *  ((`threshold' - margin)/`threshold') 
g tw=  (`threshold' - margin)/`threshold'

foreach var in nhijos /*nhijo married */  {

*rdrobust  `var'  margin if sexo==6 , c(0) p(1) covs(edad_* cmun_* ) 

reghdfe kids2 flag##c.margin  [aw=WEIGHT]  if sexo==6 & abs(margin)<`threshold', a( cmun#age_c#year  ) vce(robust)
replace x = `threshold' in `j'
	replace eff =  _b[1.flag] in `j'
	replace eff95 =  _b[1.flag] + _se[1.flag]*invttail(e(N),0.025) in `j'
	replace eff5 =  _b[1.flag] - _se[1.flag]*invttail(e(N),0.025) in `j'
	replace eff90 =  _b[1.flag] + _se[1.flag]*invttail(e(N),0.05) in `j'
	replace eff10 =  _b[1.flag] - _se[1.flag]*invttail(e(N),0.05) in `j'
	
reghdfe kids2 flag##c.margin  [aw=weight]  if sexo==6 & abs(margin)<`threshold', a( cmun#age_c#year  ) vce(robust)
replace x_ul = `threshold'+1 in `j'
	replace eff_ul=  _b[1.flag] in `j'
	replace eff95_ul =  _b[1.flag] + _se[1.flag]*invttail(e(N),0.025) in `j'
	replace eff5_ul =  _b[1.flag] - _se[1.flag]*invttail(e(N),0.025) in `j'
	replace eff90_ul =  _b[1.flag] + _se[1.flag]*invttail(e(N),0.05) in `j'
	replace eff10_ul =  _b[1.flag] - _se[1.flag]*invttail(e(N),0.05) in `j'
	
reghdfe kids2 flag##c.margin##c.margin  [aw=WEIGHT]  if sexo==6 & abs(margin)<`threshold', a( cmun#age_c#year  ) vce(robust)
replace x_tq = `threshold'-1 in `j'
	replace eff_tq=  _b[1.flag] in `j'
	replace eff95_tq =  _b[1.flag] + _se[1.flag]*invttail(e(N),0.025) in `j'
	replace eff5_tq =  _b[1.flag] - _se[1.flag]*invttail(e(N),0.025) in `j'
	replace eff90_tq =  _b[1.flag] + _se[1.flag]*invttail(e(N),0.05) in `j'
	replace eff10_tq =  _b[1.flag] - _se[1.flag]*invttail(e(N),0.05) in `j'

reghdfe kids2 flag##c.margin##c.margin  [aw=weight] if sexo==6 & abs(margin)<`threshold', a( cmun#age_c#year  )  vce(robust)
replace x_uq = `threshold'+2 in `j'
	replace eff_uq=  _b[1.flag] in `j'
	replace eff95_uq =  _b[1.flag] + _se[1.flag]*invttail(e(N),0.025) in `j'
	replace eff5_uq =  _b[1.flag] - _se[1.flag]*invttail(e(N),0.025) in `j'
	replace eff90_uq =  _b[1.flag] + _se[1.flag]*invttail(e(N),0.05) in `j'
	replace eff10_uq =  _b[1.flag] - _se[1.flag]*invttail(e(N),0.05) in `j'
	
	
drop WEIGHT tw
}
}


twoway (rspike eff5 eff95 x,lc(black))(rcap eff10 eff90 x,lc(black)) (scatter eff x, mc(black) msize(small)) (rspike eff5_ul eff95_ul x_ul,lc(gs5))(rcap eff10_ul eff90_ul x_ul,lc(gs5)) (scatter eff_ul x_ul, mc(gs5) msize(small)) (rspike eff5_tq eff95_tq x_tq,lc(gs7))(rcap eff10_tq eff90_tq x_tq,lc(gs7)) (scatter eff_tq x_tq, mc(gs7) msize(small)) (rspike eff5_uq eff95_uq x_uq,lc(gs10))(rcap eff10_uq eff90_uq x_uq,lc(gs10)) (scatter eff_uq x_uq, mc(gs10) msize(small))  ,  graphregion(fcolor(white))  yline(0,lp(-) lc(black))   xtitle("Bandwidth (months to/from 1931)", s(vsmall)) ytitle("Effect of being partially affected by the reform", s(vsmall)) xlabel(12(12)108, labs(vsmall)) legend(order(3 "Triangular kernel/linear" 6 "Uniform kernel/linear" 9 "Triangular kernel/quadratic" 12 "Uniform kernel/quadratic") c(2) size(vsmall)) ylabel(, labs(vsmall))
graph export ${dataout}RD_`var'_bw_31.pdf,  replace 
restore



** RDD --- Mese
preserve
drop if year==2001
keep if anac>=1931 & anac<=1948
g age_c = floor(edad/10)
gen margin= anac_m-tm(1940m1)
ta cmun, gen(cmun_)
*ta edad, gen(edad_)
*ta codprov, gen(prov_)
gen flag=anac_m>=tm(1940m1)
g optimal=.
g x=.
g eff=.
g eff5=.
g eff95=.
g eff10=.
g eff90=. 

g optimal_ul=.
g x_ul=.
g eff_ul=.
g eff5_ul=.
g eff95_ul=.
g eff10_ul=.
g eff90_ul=. 

g optimal_tq=.
g x_tq=.
g eff_tq=.
g eff5_tq=.
g eff95_tq=.
g eff10_tq=.
g eff90_tq=. 

g optimal_uq=.
g x_uq=.
g eff_uq=.
g eff5_uq=.
g eff95_uq=.
g eff10_uq=.
g eff90_uq=. 

local j = 0
forval threshold=12(12)108 {
local j = `j' + 1
g WEIGHT = weight     *  ((`threshold' - margin)/`threshold')   

foreach var in nhijos /*nhijo married */  {

*rdrobust  `var'  margin if sexo==6 , c(0) p(1) covs(edad_* cmun_* ) 
*rdrobust `var' margin [aw=WEIGHT] if sexo==6, c(0) p(1) covs(edad cmun_*  )
replace optimal=e(h_l)
reghdfe `var' flag##c.margin  [aw=WEIGHT]  if sexo==6 & abs(margin)<`threshold', a( cmun#age_c#year ) vce(robust)
replace x = `threshold' in `j'
	replace eff =  _b[1.flag] in `j'
	replace eff95 =  _b[1.flag] + _se[1.flag]*invttail(e(N),0.025) in `j'
	replace eff5 =  _b[1.flag] - _se[1.flag]*invttail(e(N),0.025) in `j'
	replace eff90 =  _b[1.flag] + _se[1.flag]*invttail(e(N),0.05) in `j'
	replace eff10 =  _b[1.flag] - _se[1.flag]*invttail(e(N),0.05) in `j'

*rdrobust `var' margin [aw=weight] if sexo==6, kernel(uniform) c(0) p(1) covs(edad cmun_*  )
replace optimal_ul=e(h_l)
reghdfe `var' flag##c.margin  [aw=weight]  if sexo==6 & abs(margin)<`threshold', a( cmun#age_c#year ) vce(robust)
replace x_ul = `threshold'+1 in `j'
	replace eff_ul=  _b[1.flag] in `j'
	replace eff95_ul =  _b[1.flag] + _se[1.flag]*invttail(e(N),0.025) in `j'
	replace eff5_ul =  _b[1.flag] - _se[1.flag]*invttail(e(N),0.025) in `j'
	replace eff90_ul =  _b[1.flag] + _se[1.flag]*invttail(e(N),0.05) in `j'
	replace eff10_ul =  _b[1.flag] - _se[1.flag]*invttail(e(N),0.05) in `j'
	
*rdrobust `var' margin [aw=WEIGHT] if sexo==6, c(0) p(2) covs(edad cmun_*  )
replace optimal_tq=e(h_l)
reghdfe `var' flag##c.margin##c.margin  [aw=WEIGHT]  if sexo==6 & abs(margin)<`threshold', a( cmun#age_c#year) vce(robust)
replace x_tq = `threshold'-1 in `j'
	replace eff_tq=  _b[1.flag] in `j'
	replace eff95_tq =  _b[1.flag] + _se[1.flag]*invttail(e(N),0.025) in `j'
	replace eff5_tq =  _b[1.flag] - _se[1.flag]*invttail(e(N),0.025) in `j'
	replace eff90_tq =  _b[1.flag] + _se[1.flag]*invttail(e(N),0.05) in `j'
	replace eff10_tq =  _b[1.flag] - _se[1.flag]*invttail(e(N),0.05) in `j'

*rdrobust `var' margin [aw=weight] if sexo==6, c(0) p(2) covs(edad cmun_*  )
replace optimal_uq=e(h_l)
reghdfe `var' flag##c.margin##c.margin  [aw=weight]  if sexo==6 & abs(margin)<`threshold', a( cmun#age_c#year)  vce(robust)
replace x_uq = `threshold'+2 in `j'
	replace eff_uq=  _b[1.flag] in `j'
	replace eff95_uq =  _b[1.flag] + _se[1.flag]*invttail(e(N),0.025) in `j'
	replace eff5_uq =  _b[1.flag] - _se[1.flag]*invttail(e(N),0.025) in `j'
	replace eff90_uq =  _b[1.flag] + _se[1.flag]*invttail(e(N),0.05) in `j'
	replace eff10_uq =  _b[1.flag] - _se[1.flag]*invttail(e(N),0.05) in `j'
	
	
drop WEIGHT
}
}


twoway (rspike eff5 eff95 x,lc(black))(rcap eff10 eff90 x,lc(black)) (scatter eff x, mc(black) msize(small)) (rspike eff5_ul eff95_ul x_ul,lc(gs5))(rcap eff10_ul eff90_ul x_ul,lc(gs5)) (scatter eff_ul x_ul, mc(gs5) msize(small)) (rspike eff5_tq eff95_tq x_tq,lc(gs7))(rcap eff10_tq eff90_tq x_tq,lc(gs7)) (scatter eff_tq x_tq, mc(gs7) msize(small)) (rspike eff5_uq eff95_uq x_uq,lc(gs10))(rcap eff10_uq eff90_uq x_uq,lc(gs10)) (scatter eff_uq x_uq, mc(gs10) msize(small))  ,  graphregion(fcolor(white))  yline(0,lp(-) lc(black))   xtitle("Bandwidth (months to/from 1940)", s(vsmall)) ytitle("Effect of being partially affected by the reform", s(vsmall)) xlabel(12(12)108, labs(vsmall)) legend(order(3 "Triangular kernel/linear" 6 "Uniform kernel/linear" 9 "Triangular kernel/quadratic" 12 "Uniform kernel/quadratic") c(2) size(vsmall)) ylabel(, labs(vsmall))
graph export ${dataout}RD_`var'_bw_40.pdf,  replace 
restore





** RDD --- Mese
preserve
drop if year==2001
keep if anac>=1930 & anac<=1931
g age_c = floor(edad/10)
gen margin= anac_m-tm(1931m1)

gen flag=anac_m>=tm(1931m1)
g WEIGHT = weight     *  ((12 - margin)/12) 
egen id=group( age_c year)
label var flag "1931"


reghdfe kids2 flag##c.margin  [aw=WEIGHT]  if sexo==6 , a( id cmun ) vce(robust)
outreg2 using ${dataout}table_rdd, dec(3)  label nonotes addtext(Poly., 1st, Kernel, Tri., Mun. X Age class FE, YES, Year FE, YES)   tex(frag) keep(1.flag)  nocons  replace ct("Kid")
xi: cmogram kids2 margin if -12<margin & margin < 12 & sexo==6, control(id cmun ) scatter lfitci lfit l(0) cut(0) graphopts(xtitle("Months", s(vsmall)) ytitle("Having a kid", c(black) s(vsmall)) ylabel(, labs(vsmall)) title("a): Linear fit - Having a kid", c(black) s(vsmall)) xlabel(, labs(vsmall))) 
graph save ${dataout}rdd_nkids_tri_line.gph, replace

reghdfe nhijos flag##c.margin  [aw=WEIGHT]  if sexo==6 , a( id cmun ) vce(robust)
outreg2 using ${dataout}table_rdd, dec(3)  label nonotes addtext(Poly., 1st, Kernel, Tri., Mun. X Age class FE, YES, Year FE, YES)   tex(frag) keep(1.flag)  nocons  ct("N. Kids")
xi: cmogram nhijos margin if -12<margin & margin < 12 & sexo==6, control(id cmun ) scatter lfitci lfit l(0) cut(0) graphopts(xtitle("Months", s(vsmall)) ytitle("Number of kids", c(black) s(vsmall)) ylabel(, labs(vsmall)) title("b): Linear fit - N. Kids", c(black) s(vsmall)) xlabel(, labs(vsmall))) 
graph save ${dataout}rdd_nkids_tri_line2.gph, replace

reghdfe kids2 flag##c.margin  [aw=weight]  if sexo==6 , a( id cmun ) vce(robust)
outreg2 using ${dataout}table_rdd, dec(3)  label nonotes addtext(Poly., 1st, Kernel, Uni., Mun. X Age class FE, YES, Year FE, YES)   tex(frag) keep(1.flag)  nocons  ct("Kid")

reghdfe nhijos flag##c.margin  [aw=weight]  if sexo==6 , a( id cmun ) vce(robust)
outreg2 using ${dataout}table_rdd, dec(3)  label nonotes addtext(Poly., 1st, Kernel, Uni., Mun. X Age class FE, YES, Year FE, YES)   tex(frag) keep(1.flag)  nocons  ct("N. Kids")

reghdfe kids2 flag##c.margin##c.margin   [aw=WEIGHT]  if sexo==6 , a( id cmun ) vce(robust)
outreg2 using ${dataout}table_rdd, dec(3)  label nonotes addtext(Poly., 2nd, Kernel, Tri., Mun. X Age class FE, YES, Year FE, YES)   tex(frag) keep(1.flag)  nocons  ct("Kid")
xi: cmogram kids2 margin if -12<margin & margin < 12 & sexo==6, control(id  ) scatter qfitci qfit l(0) cut(0) graphopts(xtitle("Months", s(vsmall)) ytitle("having a kid", c(black) s(vsmall)) ylabel(, labs(vsmall)) title("c): Quadratic fit - Having a kid", c(black) s(vsmall)) xlabel(, labs(vsmall))) 
graph save ${dataout}rdd_nkids_tri_quad.gph, replace	

reghdfe nhijos flag##c.margin##c.margin   [aw=WEIGHT]  if sexo==6 , a( id cmun ) vce(robust)
outreg2 using ${dataout}table_rdd, dec(3)  label nonotes addtext(Poly., 2nd, Kernel, Tri., Mun. X Age class FE, YES, Year FE, YES)   tex(frag) keep(1.flag)  nocons  ct("N. Kids")
xi: cmogram nhijos margin if -12<margin & margin < 12 & sexo==6, control(id  ) scatter qfitci qfit l(0) cut(0) graphopts(xtitle("Months", s(vsmall)) ytitle("Number of kids", c(black) s(vsmall)) ylabel(, labs(vsmall)) title("d): Quadratic fit - N. kids", c(black) s(vsmall)) xlabel(, labs(vsmall))) 
graph save ${dataout}rdd_nkids_tri_quad2.gph, replace	

reghdfe kids2 flag##c.margin##c.margin   [aw=weight]  if sexo==6 , a( id  ) vce(robust)
outreg2 using ${dataout}table_rdd, dec(3)  label nonotes addtext(Poly., 2nd, Kernel, Uni., Mun. X Age class FE, YES, Year FE, YES)   tex(frag) keep(1.flag)  nocons  ct("Kid")

reghdfe nhijos flag##c.margin##c.margin   [aw=weight]  if sexo==6 , a( id  ) vce(robust)
outreg2 using ${dataout}table_rdd, dec(3)  label nonotes addtext(Poly., 2nd, Kernel, Uni., Mun. X Age class FE, YES, Year FE, YES)   tex(frag) keep(1.flag)  nocons  ct("N. Kids")


cd ${dataout}
graph combine rdd_nkids_tri_line.gph rdd_nkids_tri_line2.gph  rdd_nkids_tri_quad.gph  rdd_nkids_tri_quad2.gph , graphregion(fcolor(white)) 
graph export ${dataout}nkids_rdd.pdf, replace	

	


