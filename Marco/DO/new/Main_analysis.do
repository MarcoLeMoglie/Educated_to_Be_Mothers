global datain "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/output_data/"
global datain2 "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/original_data/INE_microdatos/"
global dataout "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/Marco/Results/"
global ESS "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/Marco/Data/"
global IVS "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/original_data/IVS/"

/*
global datain "C:\Users\laxge\Dropbox\GEMA\RESEARCH\PURGE\output_data\"
global dataout "C:\Users\laxge\Dropbox\GEMA\RESEARCH\PURGE\Results\"
*/




*_______________________________________________ Individual analysis CIS

global cis "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/original_data/CIS/_data_cis/"
*global cis "C:\Users\laxge\Dropbox\GEMA\RESEARCH\PURGE\original_data\CIS\_data_cis\"
use ${cis}barometros.dta, clear

egen id_type = group(type)
drop if year_birth<1910
tab ESTU

g age_c = floor(age/10)
g age_c2=.
replace age_c2=1 if age<20
replace age_c2=2 if age>=20 & age<25
replace age_c2=3 if age>=25 & age<30
replace age_c2=4 if age>=30 & age<35
replace age_c2=5 if age>=35 & age<40
replace age_c2=6 if age>=40 & age<45
replace age_c2=7 if age>=45 & age<50
replace age_c2=8 if age>=50 & age<55
replace age_c2=9 if age>=55 & age<60
replace age_c2=10 if age>=60 & age<65
replace age_c2=11 if age>=65 & age<70
replace age_c2=12 if age>=70 


g age_c3=.
replace age_c3=1 if age<25
replace age_c3=2 if age>=25 & age<=34
replace age_c3=3 if age>=35 & age<=44
replace age_c3=4 if age>=45 & age<=54
replace age_c3=5 if age>=55 & age<=64
replace age_c3=6 if age>=65 & age<=74
replace age_c3=7 if age>=75

g age_c4=.
replace age_c4=1 if age<30
replace age_c4=2 if age>=30 & age<50
replace age_c4=3 if age>=50 & age<70
replace age_c4=4 if age>=70 



gen treat=.
replace treat=0 if year_birth<=1929
replace treat=1 if year_birth>1929 & year_birth<1939
replace treat=2 if year_birth>=1939



ta treat, gen(treat_)
label var treat_2 "1930/1938"
label var treat_3 "1939/1950"

replace kids=0 if nkids==0 & kids==.

gen flag= age_together-age_partner_together
gen year_partner=year_birth+flag

gen treat_p=.
replace treat_p=0 if year_partner<=1929
replace treat_p=1 if year_partner>1929 & year_partner<1939
replace treat_p=2 if year_partner>=1939 & year_partner!=.



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

ta lab_situ, gen(lab_)
gen emp=1 if lab_1==1
replace emp=0 if lab_2==1
replace emp=0 if lab_5==1

gen lab2_1=1 if lab_situ==1
replace lab2_1=0 if lab_situ==2 | lab_situ==5

gen lab2_2=1 if lab_situ==2
replace lab2_2=0 if lab_situ==1 | lab_situ==5

gen lab2_5=1 if lab_situ==5
replace lab2_5=0 if lab_situ==1 | lab_situ==2


gen edu=education==5 

gen educ=education
replace educ=7 if education==6
replace educ=6 if education==5
replace educ=5 if educ==7


egen id2=group(id age_c )

gen treat2=.
replace treat2=0 if year_birth<=1929
replace treat2=1 if year_birth>1929 & year_birth<1932
replace treat2=2 if year_birth>=1932 & year_birth<1939
replace treat2=3 if year_birth>=1939



ta treat2, gen(treat2_)
label var treat2_2 "1930/1932"
label var treat2_3 "1933/1939"
label var treat2_4 "1940/1950"



***** Regression Fertility
sum kids if treat_1==1
local p=round(r(mean), .01)
reghdfe kids treat_2 treat_3  if female==1 & year_birth<=1950  , a(i.year  ) cluster(year#i.year_birth)
	label var kids "Kids" 
outreg2 using ${dataout}table_cis_kids, dec(3)  label nonotes addtext( Year FE, YES, Mun. FE, NO, Age class FE, NO, Year X Age group X Residence FE, NO, Base value, `p')   tex(frag) keep(treat_2 treat_3)  nocons replace     

** DID
foreach var in kids nkids {
sum `var' if treat_1==1
local p=round(r(mean), .01)

if "`var'" == "kids" {
	label var `var' "Kids" 
	reghdfe `var' treat_2 treat_3  if female==1 & year_birth<=1950 , a(i.year i.id  ) cluster(year#i.year_birth)
outreg2 using ${dataout}table_cis_kids, dec(3)  label nonotes addtext(  Year FE, YES, Mun. FE, YES, Age class FE, NO, Year X Age group X Residence FE, NO, Base value, `p')  tex(frag) keep(treat_2 treat_3)  nocons  
reghdfe `var' treat_2 treat_3 if female==1 & year_birth<=1950 , a(i.year i.id age_c) cluster(year#i.year_birth)
outreg2 using ${dataout}table_cis_kids, dec(3)  label nonotes addtext(  Year FE, YES, Mun. FE, YES, Age class FE, YES, Year X Age group X Residence FE, NO, Base value, `p')  tex(frag) keep(treat_2 treat_3)  nocons   
	reghdfe `var' treat_2 treat_3 if female==1 & year_birth<=1950 , a(i.year##i.id##age_c) cluster(year#i.year_birth)
outreg2 using ${dataout}table_cis_kids, dec(3)  label nonotes addtext(  Year FE, YES, Mun. FE, YES, Age class FE, YES, Year X Age group X Residence FE, YES, Base value, `p')  tex(frag) keep(treat_2 treat_3)  nocons    
/*reghdfe `var' treat_2 treat_3 i.year i.id  if female==1 & year_birth<=1950, a(age_c ) cluster(year_birth)  version(5)
boottest treat_3,   nograph reps(9999) boot(wild) seed(999) cluster(year_birth) 
local p=round(r(p), .001)
outreg2 using ${dataout}table_cis_kids, dec(3)  label nonotes addtext( Year FE, YES, Mun. FE, YES, Age class FE, YES, Cluster , Cohort, Bootstrap p-val., `p')   tex(frag) keep(treat_2 treat_3)  nocons      */
}
	else if "`var'" != "kids" {
			label var `var' "N. kids" 
				reghdfe `var' treat_2 treat_3  if female==1 & year_birth<=1950 , a(i.year  )cluster(year#i.year_birth)
			outreg2 using ${dataout}table_cis_kids, dec(3)  label nonotes addtext( Year FE, YES, Mun. FE, NO, Age class FE, NO, Year X Age group X Residence FE, NO, Base value, `p')  tex(frag) keep(treat_2 treat_3)  nocons      
	reghdfe `var' treat_2 treat_3  if female==1 & year_birth<=1950 , a(i.year i.id  ) cluster(year#i.year_birth) 
outreg2 using ${dataout}table_cis_kids, dec(3)  label nonotes addtext(  Year FE, YES, Mun. FE, YES, Age class FE, NO, Year X Age group X Residence FE, NO, Base value, `p')  tex(frag) keep(treat_2 treat_3)  nocons  
reghdfe `var' treat_2 treat_3  if female==1 & year_birth<=1950 , a(i.year i.id age_c) cluster(year#i.year_birth)
outreg2 using ${dataout}table_cis_kids, dec(3)  label nonotes addtext(  Year FE, YES, Mun. FE, YES, Age class FE, YES, Year X Age group X Residence FE, NO, Base value, `p')   tex(frag) keep(treat_2 treat_3)  nocons  
reghdfe `var' treat_2 treat_3  if female==1 & year_birth<=1950 , a(i.year##i.id##age_c) cluster(year#i.year_birth)
outreg2 using ${dataout}table_cis_kids, dec(3)  label nonotes addtext(  Year FE, YES, Mun. FE, YES, Age class FE, YES, Year X Age group X Residence FE, YES, Base value, `p')   tex(frag) keep(treat_2 treat_3)  nocons    
/*reghdfe `var' treat_2 treat_3 i.year i.id  if female==1 & year_birth<=1950, a(age_c ) cluster(year_birth)  version(5)
boottest treat_3,   nograph reps(9999) boot(wild) seed(999) cluster(year_birth) 
local p=round(r(p), .001)
outreg2 using ${dataout}table_cis_kids, dec(3)  label nonotes addtext( Year FE, YES, Mun. FE, YES, Age class FE, YES, Cluster , Cohort, Bootstrap p-val., `p')   tex(frag) keep(treat_2 treat_3)  nocons  */    
	}
}


***** Regression Fertility --- Robustness cluster
sum kids if treat_1==1
local p=round(r(mean), .01)
reghdfe kids treat_2 treat_3  if female==1 & year_birth<=1950, a(i.year##i.id##age_c ) cluster(year_birth)  version(5)
boottest treat_3,   nograph reps(9999) boot(wild) seed(999) cluster(year_birth) 
local pval=round(r(p), .001)
outreg2 using ${dataout}table_cis_kids_cluster, dec(3)  label nonotes addtext(  Year FE, YES, Mun. FE, YES, Age class FE, YES, Year X Age group X Residence FE, YES, Clusters , Cohort, Boot. P-val, `pval', Base value, `p')  tex(frag) keep(treat_2 treat_3)  nocons    replace

** DID
foreach var in kids nkids {
sum `var' if treat_1==1
local p=round(r(mean), .01)

if "`var'" == "kids" {
	label var `var' "Kids"  
	
	reghdfe `var' treat_2 treat_3 if female==1 & year_birth<=1950 , a(i.year##i.id##age_c) cluster(year i.year_birth)
outreg2 using ${dataout}table_cis_kids_cluster, dec(3)  label nonotes addtext(  Year FE, YES, Mun. FE, YES, Age class FE, YES, Year X Age group X Residence FE, YES, Clusters , Two-way, Boot. P-val, -- , Base value, `p')  tex(frag) keep(treat_2 treat_3)  nocons    

}
	else if "`var'" != "kids" {
			label var `var' "N. kids" 
	
	reghdfe `var' treat_2 treat_3 if female==1 & year_birth<=1950, a(i.year##i.id##age_c ) cluster(year_birth)  version(5)
boottest treat_3,   nograph reps(9999) boot(wild) seed(999) cluster(year_birth) 
local pval=round(r(p), .001)
outreg2 using ${dataout}table_cis_kids_cluster, dec(3)  label nonotes addtext(  Year FE, YES, Mun. FE, YES, Age class FE, YES, Year X Age group X Residence FE, YES, Clusters , Cohort, Boot. P-val, `pval', Base value, `p')  tex(frag) keep(treat_2 treat_3)  nocons    
	reghdfe `var' treat_2 treat_3 if female==1 & year_birth<=1950 , a(i.year##i.id##age_c) cluster(year i.year_birth)
outreg2 using ${dataout}table_cis_kids_cluster, dec(3)  label nonotes addtext(  Year FE, YES, Mun. FE, YES, Age class FE, YES, Year X Age group X Residence FE, YES, Clusters , Two-way, Boot. P-val, --, Base value, `p')  tex(frag) keep(treat_2 treat_3)  nocons   
	}
}



/*
***** Regression Fertility ---- separando partially trated
sum kids if treat_1==1
local p=round(r(mean), .01)
** Female
	reghdfe kids treat2_2 treat2_3 treat2_4 if female==1 & year_birth<=1950 , a(i.year##i.id##age_c) cluster(year#i.year_birth)
	label var kids "Kids" 
outreg2 using ${dataout}table_cis_kids_dec, dec(3)  label nonotes addtext( Year FE, YES, Mun. FE, NO, Age class FE, NO, Base value, `p')   tex(frag) keep(treat2_2 treat2_3 treat2_4)  nocons replace     

** DID
foreach var in nkids {
sum `var' if treat_1==1
local p=round(r(mean), .01)
if "`var'" != "kids" {
			label var `var' "N. kids" 
reghdfe `var' treat2_2 treat2_3 treat2_4  if female==1 & year_birth<=1950 , a(i.year##i.id##age_c) cluster(year#i.year_birth)
outreg2 using ${dataout}table_cis_kids_dec, dec(3)  label nonotes addtext(  Year FE, YES, Mun. FE, YES, Age class FE, YES, Base value, `p')   tex(frag) keep(treat2_2 treat2_3 treat2_4)  nocons    
	}
}

*/

/*
**Male
reghdfe kids treat_2 treat_3  if female==0 & year_birth<=1950, a(i.year ) cluster(year#i.year_birth)
	label var kids "Kids" 
outreg2 using ${dataout}table_cis_kids, dec(3)  label nonotes addtext( Year FE, YES, Mun. FE, NO, Age class FE, NO, Robust SE, YES, Cluster SE, NO, Bootstrap p-val., --)   tex(frag) keep(treat_2 treat_3)  nocons replace     

** DID
foreach var in kids nkids {
if "`var'" == "kids" {
	label var `var' "Kids" 
	reghdfe `var' treat_2 treat_3  if female==0 & year_birth<=1950, a(i.year i.id  ) cluster(year#i.year_birth)
outreg2 using ${dataout}table_cis_kids, dec(3)  label nonotes addtext(  Year FE, YES, Mun. FE, YES, Age class FE, NO,  Robust SE, YES, Cluster SE, NO, Bootstrap p-val., --)   tex(frag) keep(treat_2 treat_3)  nocons  
	reghdfe `var' treat_2 treat_3  if female==0 & year_birth<=1950, a(i.year i.id age_c ) cluster(year#i.year_birth)
outreg2 using ${dataout}table_cis_kids, dec(3)  label nonotes addtext(  Year FE, YES, Mun. FE, YES, Age class FE, YES, Robust SE, YES, Cluster SE, NO, Bootstrap p-val., --)   tex(frag) keep(treat_2 treat_3)  nocons    
*reghdfe `var' treat_2 treat_3  if female==1 & year_birth<=1950, a(i.year i.id age_c ) cluster(year_birth) 
*outreg2 using ${dataout}table_cis_kids, dec(3)  label nonotes addtext( Year FE, YES, Mun. FE, YES, Age class FE, YES, Robust SE, YES, Cluster SE, YES, Bootstrap p-val., --)   tex(frag) keep(treat_2 treat_3)  nocons    
}
	else if "`var'" != "kids" {
			label var `var' "N. kids" 
				reghdfe `var' treat_2 treat_3  if female==0 & year_birth<=1950, a(i.year  )cluster(year#i.year_birth)
			outreg2 using ${dataout}table_cis_kids, dec(3)  label nonotes addtext( Year FE, YES, Mun. FE, NO, Age class FE, NO, Robust SE, YES, Cluster SE, NO, Bootstrap p-val., --)   tex(frag) keep(treat_2 treat_3)  nocons      
	reghdfe `var' treat_2 treat_3  if female==0 & year_birth<=1950, a(i.year i.id  ) cluster(year#i.year_birth) 
outreg2 using ${dataout}table_cis_kids, dec(3)  label nonotes addtext(  Year FE, YES, Mun. FE, YES, Age class FE, NO, Robust SE, YES, Cluster SE, NO, Bootstrap p-val., --)   tex(frag) keep(treat_2 treat_3)  nocons  
reghdfe `var' treat_2 treat_3  if female==0 & year_birth<=1950, a(i.year i.id age_c ) cluster(year#i.year_birth)
outreg2 using ${dataout}table_cis_kids, dec(3)  label nonotes addtext(  Year FE, YES, Mun. FE, YES, Age class FE, YES, Robust SE, YES, Cluster SE, NO, Bootstrap p-val., --)   tex(frag) keep(treat_2 treat_3)  nocons    
*reghdfe `var' treat_2 treat_3 i.year i.id  if female==1 & year_birth<=1950, a(age_c ) cluster(year_birth)  version(5)
*boottest treat_3,   nograph reps(9999) boot(wild) seed(999) cluster(year_birth) 
*local p=round(r(p), .001)
*outreg2 using ${dataout}table_cis_kids, dec(3)  label nonotes addtext( Year FE, YES, Mun. FE, YES, Age class FE, YES, Robust SE, YES, Cluster SE, YES, Bootstrap p-val., `p')   tex(frag) keep(treat_2 treat_3)  nocons      
	}
}
*/
/*

**Male
reghdfe kids treat_2##female treat_3##female  year_partner if year_birth<=1950, a(i.year ) cluster(year#i.year_birth)
	label var kids "Kids" 
outreg2 using ${dataout}table_cis_kids, dec(3)  label nonotes addtext( Year FE, YES, Mun. FE, NO, Age class FE, NO, Robust SE, YES, Cluster SE, NO, Bootstrap p-val., --)   tex(frag) keep(treat_2 treat_3)  nocons replace     

** DID
foreach var in kids nkids {
if "`var'" == "kids" {
	label var `var' "Kids" 
	reghdfe `var' treat_2##female treat_3##female year_partner  if year_birth<=1950, a(i.year i.id  ) cluster(year#i.year_birth)
outreg2 using ${dataout}table_cis_kids, dec(3)  label nonotes addtext(  Year FE, YES, Mun. FE, YES, Age class FE, NO,  Robust SE, YES, Cluster SE, NO, Bootstrap p-val., --)   tex(frag) keep(treat_2 treat_3)  nocons  
	reghdfe `var' treat_2##female treat_3##female  year_partner if year_birth<=1950, a(i.year i.id age_c ) cluster(year#i.year_birth)
outreg2 using ${dataout}table_cis_kids, dec(3)  label nonotes addtext(  Year FE, YES, Mun. FE, YES, Age class FE, YES, Robust SE, YES, Cluster SE, NO, Bootstrap p-val., --)   tex(frag) keep(treat_2 treat_3)  nocons    
*reghdfe `var' treat_2 treat_3  if female==1 & year_birth<=1950, a(i.year i.id age_c ) cluster(year_birth) 
*outreg2 using ${dataout}table_cis_kids, dec(3)  label nonotes addtext( Year FE, YES, Mun. FE, YES, Age class FE, YES, Robust SE, YES, Cluster SE, YES, Bootstrap p-val., --)   tex(frag) keep(treat_2 treat_3)  nocons    
}
	else if "`var'" != "kids" {
			label var `var' "N. kids" 
				reghdfe `var' treat_2##female treat_3##female  year_partner if year_birth<=1950, a(i.year  )cluster(year#i.year_birth)
			outreg2 using ${dataout}table_cis_kids, dec(3)  label nonotes addtext( Year FE, YES, Mun. FE, NO, Age class FE, NO, Robust SE, YES, Cluster SE, NO, Bootstrap p-val., --)   tex(frag) keep(treat_2 treat_3)  nocons      
	reghdfe `var' treat_2##female treat_3##female year_partner  if year_birth<=1950, a(i.year i.id  ) cluster(year#i.year_birth) 
outreg2 using ${dataout}table_cis_kids, dec(3)  label nonotes addtext(  Year FE, YES, Mun. FE, YES, Age class FE, NO, Robust SE, YES, Cluster SE, NO, Bootstrap p-val., --)   tex(frag) keep(treat_2 treat_3)  nocons  
reghdfe `var' treat_2##female treat_3##female  year_partner if year_birth<=1950, a(i.year i.id age_c ) cluster(year#i.year_birth)
outreg2 using ${dataout}table_cis_kids, dec(3)  label nonotes addtext(  Year FE, YES, Mun. FE, YES, Age class FE, YES, Robust SE, YES, Cluster SE, NO, Bootstrap p-val., --)   tex(frag) keep(treat_2 treat_3)  nocons    
*reghdfe `var' treat_2 treat_3 i.year i.id  if female==1 & year_birth<=1950, a(age_c ) cluster(year_birth)  version(5)
*boottest treat_3,   nograph reps(9999) boot(wild) seed(999) cluster(year_birth) 
*local p=round(r(p), .001)
*outreg2 using ${dataout}table_cis_kids, dec(3)  label nonotes addtext( Year FE, YES, Mun. FE, YES, Age class FE, YES, Robust SE, YES, Cluster SE, YES, Bootstrap p-val., `p')   tex(frag) keep(treat_2 treat_3)  nocons      
	}
}

*/


********* Event study

** Female
reghdfe nkids year_birth_1-year_birth_9 o.year_birth_10 year_birth_11-year_birth_31  if female==1 & year_birth<=1950  , a(i.year#age_c#id ) cluster(year#i.year_birth)

coefplot , keep(year_birth_*) vertical base omitted  yline(0, lc(red) lp(dash)) xline(10, lcolor(blue) lpattern(dash)) xline(20, lcolor(green) lpattern(dash)) ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) /*title("`name'", s(small) c(black))*/ ytitle("Number of kids", s(small)) scheme(s2mono) xtick(1(2)31) xlabel(, angle(45) labs(tiny))   

graph export ${dataout}nkids_female.pdf,replace
/*
reghdfe nkids b1929.year_birth  if female==1 & year_birth<=1950, a(i.year i.id age_c ) cluster(year#i.year_birth)

matrix l_vec =  0.05 \ 0.05 \ 0.05 \ 0.05\ 0.05 \ 0.05 \ 0.05 \ 0.05 \ 0.05\ 0.05  \ 0.05 \ 0.05 \ 0.05 \ 0.05\ 0.05 \ 0.05 \ 0.05 \ 0.05 \ 0.05\ 0.05 
*matrix l_vec =  0.083 \ 0.083 \ 0.083 \ 0.083 \ 0.083 \ 0.083 \ 0.083 \ 0.083 \ 0.083 \ 0.083 \ 0.083 \ 0.083 

local plotopts  ytitle("90% Robust CI", s(vsmall) c(black)) graphregion(color(white)) yline(0, lc(red))  ylabel(, labs(tiny)) xlabel(, labs(tiny))
honestdid , pre(1/9) post(20/31) l_vec(l_vec) mvec(0.1(0.1)1) coefplot `plotopts' alpha(0.05) 
*/

/*
** Male
reghdfe nkids year_birth_1-year_birth_9 o.year_birth_10 year_birth_11-year_birth_31   if female==0 & year_birth<=1950, a(i.year i.id age_c ) cluster(year#i.year_birth)

coefplot , keep(year_birth_*) vertical base omitted  yline(0, lc(red) lp(dash)) xline(10, lcolor(blue) lpattern(dash)) xline(20, lcolor(green) lpattern(dash)) ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) /*title("`name'", s(small) c(black))*/ ytitle("Number of kids", s(small)) scheme(s2mono) xtick(1(2)31) xlabel(, angle(45) labs(tiny))   

graph export ${dataout}nkids_male.pdf,replace
*/

***** Unemployment, right, education, marriage


** DID
foreach var in lab2_1  {
	sum `var' if treat_1==1
local p=round(r(mean), .01)
reghdfe `var' treat_2 treat_3 if female==1 & year_birth<=1950  & year<1990,  a(i.year#age_c#id )  cluster(year#i.year_birth)
	label var `var' "Employed" 
outreg2 using ${dataout}table_cis_emp, dec(3)  label nonotes addtext(  Year FE, YES, Residence FE, YES, Age class FE, YES, Base value, `p')   tex(frag) keep(treat_2 treat_3)  nocons replace 
    
*reghdfe `var' treat_2 treat_3 year_partner  if female==0 & year_birth<=1952, a(i.id#i.age_c i.ESTU )  cluster(i.id#age_c)
*outreg2 using ${dataout}table_cis_kids, dec(3)  label nonotes addtext( Mun. X Age class FE, YES, Year FE, YES)   tex(frag) keep(treat_2 treat_3) nocons 
}

** DID
foreach var in  lab2_2  lab2_5 edu right  {
	sum `var' if treat_1==1
local p=round(r(mean), .01)
reghdfe `var' treat_2 treat_3 if female==1 & year_birth<=1950 & year<1990,  a(i.year#age_c#id ) cluster(year#i.year_birth)
if "`var'" == "right" {
	label var `var' "Right-wing" 
}
else if "`var'" == "edu" {
	label var `var' "Educated" 
}
else if "`var'" == "lab2_2" {
	label var `var' "Unemployed" 
}

else if "`var'" == "lab2_5" {
	label var `var' "Housewife" 
}

outreg2 using ${dataout}table_cis_emp, dec(3)  label nonotes addtext(  Year FE, YES, Residence FE, YES, Age class FE, YES, Base value, `p')   tex(frag) keep(treat_2 treat_3)  nocons 
    
*reghdfe `var' treat_2 treat_3 year_partner  if female==0 & year_birth<=1952, a(i.id#i.age_c i.ESTU )  cluster(i.id#age_c)
*outreg2 using ${dataout}table_cis_kids, dec(3)  label nonotes addtext( Mun. X Age class FE, YES, Year FE, YES)   tex(frag) keep(treat_2 treat_3) nocons 
}





 
/*
***** Primary beliefs
foreach var in  ideal_fam_equal ideal_fam_wifehome control_natal_both school_meet_wife absentwork_wife  husb_nothouseworks husb_lesshouseworks   stab_sharehousework stab_kids stab_wifework realwoman_kids  cleanhouse_woman   women_work free_housework import_marry import_work import_mother import_family import_religion happ_sharehousework happ_kids pro_abort_church pro_art_fert pro_contracep     {
preserve
rename treat_2 outcome
eststo est_`var':reghdfe `var' outcome treat_3  if female==1  , a(i.id ) vce(r)
restore
preserve
rename treat_3 outcome
eststo est_`var'_3:reghdfe `var' treat_2 outcome   if female==1 , a(i.id ) vce(r)
restore
if "`var'" == "ideal_fam_equal" {
outreg2 using ${dataout}table_cis_primary, dec(3)  label nonotes addtext( Mun. X Age class FE, YES, Year FE, YES)   tex(frag) keep(treat_2 treat_3) nocons replace 
    }
	else if "`var'" != "ideal_fam_equal" {
outreg2 using ${dataout}table_cis_primary, dec(3)  label nonotes addtext( Mun. X Age class FE, YES, Year FE, YES)   tex(frag) keep(treat_2 treat_3) nocons 
	}
	} 
	
	
coefplot ( est_ideal_fam_equal, aseq(ideal_fam_equal) ///
	\ est_school_meet_wife, aseq(school_meet_wife) ///
	\ est_absentwork_wife, aseq(absentwork_wife) ///
	\ est_husb_lesshouseworks, aseq(husb_lesshouseworks) ///
	\ est_stab_sharehousework, aseq(stab_sharehousework) ///
	\ est_stab_kids, aseq(stab_kids) ///
	\ est_realwoman_kids, aseq(realwoman_kids) ///
	\ est_women_work, aseq(women_work) ///
	\ est_stab_wifework, aseq(stab_wifework) ///    
	\ est_pro_abort_church, aseq(pro_abort_church) ///
	\ est_pro_art_fert, aseq(pro_art_fert) ///
	\ est_pro_contracep, aseq(pro_contracep)), by(,graphregion(color(white))) subtitle(, bc(white)) bylabel(Partially treated (1931/39)) ///
	|| ( est_ideal_fam_equal_3, aseq(ideal_fam_equal) ///
	\ est_school_meet_wife_3, aseq(school_meet_wife) ///
	\ est_absentwork_wife_3, aseq(absentwork_wife) ///
	\ est_husb_lesshouseworks_3, aseq(husb_lesshouseworks) ///
	\ est_stab_sharehousework_3, aseq(stab_sharehousework) ///
	\ est_stab_kids_3, aseq(stab_kids) ///
	\ est_realwoman_kids_3, aseq(realwoman_kids) ///
	\ est_women_work_3, aseq(women_work) ///
	\ est_stab_wifework_3, aseq(stab_wifework) ///
	\ est_pro_abort_church_3, aseq(pro_abort_church) ///
	\ est_pro_art_fert_3, aseq(pro_art_fert) ///
	\ est_pro_contracep_3, aseq(pro_contracep)),  by(,graphregion(color(white)))  bylabel(Fully treated (1940/70)) ///
	|| , group(import_family import_marry ideal_fam_equal control_natal_both school_meet_wife absentwork_wife  husb_nothouseworks husb_lesshouseworks stab_sharehousework happ_sharehousework = "{bf:Roles in the family}" ///
	stab_kids happ_kids import_mother realwoman_kids = "{bf:Motherhood}" ///
	women_work stab_wifework import_work = "{bf:Working}" pro_abort_church pro_art_fert pro_contracep  = "{bf:Church}", labgap(0) labs(small)) xline(0, lp(dash) ) pstyle(p10) pstyle(p23)  aseq swapnames  ci(95 90) msize(.5) keep(outcome)  ylabel(  1 "Gender roles: Equal"  2 "School meetings: Wife" 3 "Absent from work: Wife"  4 "Husband less housework"   5 "Couple's stability: Shared housework"    7 "Couple's stability: Kids"      8 "Real woman has kids"  10 "Woman works"  11 "Couple's stability: Wife works"   13 "Agree with Church: Abortion" 14 "Agree with Church: Artificial procreation" 15 "Agree with Church: Contraception" , labs(vsmall) ) yscale(noline   reverse) xlabel(, labs(vsmall))  //legend(off) 
graph save ${dataout}cis_2.gph, replace
graph export ${dataout}cis.pdf, replace	



****** Event study
	local varlist "  import_family import_marry ideal_fam_equal control_natal_both school_meet_wife absentwork_wife  husb_nothouseworks husb_lesshouseworks stab_sharehousework happ_sharehousework stab_kids happ_kids import_mother realwoman_kids women_work stab_wifework import_work   pro_abort_church pro_art_fert pro_contracep    "
	


foreach var in `varlist' {
    if "`var'" == "husb_lesshouseworks" {
        local name = "Husband less housework"
    }

    else if "`var'" == "import_family" {
        local name = "Importance of family"
    }
	else if "`var'" == "control_natal_both" {
        local name = "Birth control: Both"
    }
   
    else if "`var'" == "realwoman_kids" {
        local name = "Real woman has kids"
    }
    
    else if "`var'" == "school_meet_wife" {
        local name = "School meetings: Wife"
    }
	else if "`var'" == "absentwork_wife" {
        local name = "Absent work: Wife"
    }
	else if "`var'" == "husb_nothouseworks" {
        local name = "Husband no housework"
    }
    else if "`var'" == "stab_kids" {
        local name = "Couple's stability: Kids"
    }
    else if "`var'" == "happ_kids" {
        local name = "Couple's happiness: Kids"
    }
    else if "`var'" == "ideal_fam_wifehome" {
        local name = "Gender roles: Wife at home"
    }
	else if "`var'" == "ideal_fam_equal" {
        local name = "Gender roles: Equal"
    }
    else if "`var'" == "import_marry" {
        local name = "Realized woman: Marry"
    }
    else if "`var'" == "import_mother" {
        local name = "Realized woman: Mother"
    }
    else if "`var'" == "import_work" {
        local name = "Realized woman: Work"
    }
	
	else if "`var'" == "women_work" {
        local name = "Woman works"
    }
    
    else if "`var'" == "stab_sharehousework" {
        local name = "Couple's stability: Shared housework"
    }
	else if "`var'" == "happ_sharehousework" {
        local name = "Couple's happiness: Shared housework"
    }
    else if "`var'" == "stab_wifework" {
        local name = "Couple's stability: Wife works"
    }
	else if "`var'" == "pro_abort_church" {
        local name = "Agree with Church: Abortion"
    }
	else if "`var'" == "pro_art_fert" {
        local name = "Agree with Church: Artificial procreation"
    }
	else if "`var'" == "pro_contracep" {
        local name = "Agree with Church: Contraception"
    }
	
    else {
        local name = "ERROR"
    }


reghdfe `var' year_birth_1-year_birth_10 o.year_birth_11 year_birth_12-year_birth_51 if female==1  , a(i.id  ) vce(r)

coefplot , keep(year_birth_*) vertical base omitted  yline(0, lc(red) lp(dash)) xline(11, lcolor(blue) lpattern(dash)) xline(21, lcolor(green) lpattern(dash)) ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) /*title("`name'", s(small) c(black))*/ title("`name'", s(small)) scheme(s2mono) xtick(1(2)33) xlabel(, angle(45) labs(tiny))   ///

graph save ${dataout}`var'.gph,replace
}

cd ${dataout}

graph combine   ideal_fam_equal.gph  school_meet_wife.gph absentwork_wife.gph husb_lesshouseworks.gph stab_sharehousework.gph stab_kids.gph  realwoman_kids.gph women_work.gph stab_wifework.gph pro_abort_church.gph pro_art_fert.gph pro_contracep.gph    , graphregion(color(white))  

graph export ${dataout}cis_event.pdf, replace

*/

***** Primary beliefs
foreach var in  ideal_fam_equal ideal_fam_wifehome control_natal_both school_meet_wife absentwork_wife  husb_nothouseworks husb_lesshouseworks   stab_sharehousework stab_kids stab_wifework realwoman_kids  cleanhouse_woman   women_work free_housework import_marry import_work2 import_mother import_family import_religion happ_sharehousework happ_kids pro_abort_church pro_art_fert pro_contracep     {
preserve
rename treat_2 outcome
eststo est_`var':reghdfe `var' outcome treat_3  if female==1 & year_birth<=1950 , a(i.id ) vce(r)
restore
preserve
rename treat_3 outcome
eststo est_`var'_3:reghdfe `var' treat_2 outcome   if female==1 & year_birth<=1950 , a(i.id ) vce(r)
restore
if "`var'" == "ideal_fam_equal" {
outreg2 using ${dataout}table_cis_primary, dec(3)  label nonotes addtext( Mun. X Age class FE, YES, Year FE, YES)   tex(frag) keep(treat_2 treat_3) nocons replace 
    }
	else if "`var'" != "ideal_fam_equal" {
outreg2 using ${dataout}table_cis_primary, dec(3)  label nonotes addtext( Mun. X Age class FE, YES, Year FE, YES)   tex(frag) keep(treat_2 treat_3) nocons 
	}
	} 
	
	
coefplot  (est_ideal_fam_equal, aseq(ideal_fam_equal) ///
	\ est_husb_lesshouseworks, aseq(husb_lesshouseworks) ///
	\ est_stab_sharehousework, aseq(stab_sharehousework) ///
	\ est_stab_kids, aseq(stab_kids) ///
	\ est_realwoman_kids, aseq(realwoman_kids) ///
	\ est_import_work2, aseq(import_work2) ///
	\ est_stab_wifework, aseq(stab_wifework) ///    
	\ est_pro_abort_church, aseq(pro_abort_church) ///
	\ est_pro_art_fert, aseq(pro_art_fert) ///
	\ est_pro_contracep, aseq(pro_contracep)), by(,graphregion(color(white))) subtitle(, bc(white)) bylabel(Partially treated (1930/38)) ///
	|| ( est_ideal_fam_equal_3, aseq(ideal_fam_equal) ///
	\ est_husb_lesshouseworks_3, aseq(husb_lesshouseworks) ///
	\ est_stab_sharehousework_3, aseq(stab_sharehousework) ///
	\ est_stab_kids_3, aseq(stab_kids) ///
	\ est_realwoman_kids_3, aseq(realwoman_kids) ///
	\ est_import_work2_3, aseq(import_work2) ///
	\ est_stab_wifework_3, aseq(stab_wifework) ///
	\ est_pro_abort_church_3, aseq(pro_abort_church) ///
	\ est_pro_art_fert_3, aseq(pro_art_fert) ///
	\ est_pro_contracep_3, aseq(pro_contracep)),  by(,graphregion(color(white)))  bylabel(Fully treated (1939/50)) ///
	|| , group( import_marry ideal_fam_equal    husb_nothouseworks husb_lesshouseworks stab_sharehousework  = "{bf:Roles in the family}" ///
	stab_kids  realwoman_kids = "{bf:Motherhood}" ///
	import_work2 stab_wifework  = "{bf:Working}" pro_abort_church pro_art_fert pro_contracep  = "{bf:Church}", labgap(0) labs(small)) xline(0, lp(dash) ) pstyle(p10) pstyle(p23)  aseq swapnames  ci(95 90) msize(.5) keep(outcome)  ylabel(   1 "Gender roles: Equal"  2 "Husband less housework"   3 "Couple's stability: Shared housework"  5 "Couple's stability: Kids"   6 "Real woman has kids"  8 "Importance of working for women"  9 "Couple's stability: Wife works"  11 "Agree with Church: Abortion" 12 "Agree with Church: Artificial procreation" 13 "Agree with Church: Contraception" , labs(vsmall) ) yscale(noline   reverse) xlabel(, labs(vsmall))  //legend(off) 
graph save ${dataout}cis_2.gph, replace
graph export ${dataout}cis.pdf, replace	 


****** Event study
	local varlist "  import_family import_marry ideal_fam_equal control_natal_both school_meet_wife absentwork_wife  husb_nothouseworks husb_lesshouseworks stab_sharehousework happ_sharehousework stab_kids happ_kids import_mother realwoman_kids import_work2 stab_wifework   pro_abort_church pro_art_fert pro_contracep    "
	


foreach var in `varlist' {
    if "`var'" == "husb_lesshouseworks" {
        local name = "Husband less housework"
    }

    else if "`var'" == "import_family" {
        local name = "Importance of family (1992)"
    }
	else if "`var'" == "control_natal_both" {
        local name = "Birth control: Both"
    }
   
    else if "`var'" == "realwoman_kids" {
        local name = "Real woman has kids"
    }
    
    else if "`var'" == "school_meet_wife" {
        local name = "School meetings: Wife"
    }
	else if "`var'" == "absentwork_wife" {
        local name = "Absent work: Wife"
    }
	else if "`var'" == "husb_nothouseworks" {
        local name = "Husband no housework"
    }
    else if "`var'" == "stab_kids" {
        local name = "Couple's stability: Kids"
    }
    else if "`var'" == "happ_kids" {
        local name = "Couple's happiness: Kids (1992)"
    }
    else if "`var'" == "ideal_fam_wifehome" {
        local name = "Gender roles: Wife at home"
    }
	else if "`var'" == "ideal_fam_equal" {
        local name = "Gender roles: Equal"
    }
    else if "`var'" == "import_marry" {
        local name = "Realized woman: Marry"
    }
    else if "`var'" == "import_mother" {
        local name = "Realized woman: Mother"
    }
    else if "`var'" == "import_work" {
        local name = "Realized woman: Work"
    }
	
	else if "`var'" == "women_work" {
        local name = "Woman works"
    }
    
    else if "`var'" == "stab_sharehousework" {
        local name = "Couple's stability: Shared housework"
    }
	else if "`var'" == "happ_sharehousework" {
        local name = "Couple's happiness: Shared housework"
    }
    else if "`var'" == "stab_wifework" {
        local name = "Couple's stability: Wife works"
    }
	else if "`var'" == "pro_abort_church" {
        local name = "Agree with Church: Abortion"
    }
	else if "`var'" == "pro_art_fert" {
        local name = "Agree with Church: Artificial procreation"
    }
	else if "`var'" == "pro_contracep" {
        local name = "Agree with Church: Contraception"
    }
	
    else {
        local name = "ERROR"
    }


reghdfe `var' year_birth_1-year_birth_9 o.year_birth_10 year_birth_11-year_birth_31 if female==1 & year_birth<=1950 , a(i.id  ) vce(r)

coefplot , keep(year_birth_*) vertical base omitted  yline(0, lc(red) lp(dash)) xline(10, lcolor(blue) lpattern(dash)) xline(20, lcolor(green) lpattern(dash)) ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) /*title("`name'", s(small) c(black))*/ title("`name'", s(small)) scheme(s2mono) xtick(1(2)31) xlabel(, angle(45) labs(tiny))   ///

graph save ${dataout}`var'.gph,replace
}

cd ${dataout}

graph combine  ideal_fam_equal.gph   husb_lesshouseworks.gph stab_sharehousework.gph stab_kids.gph  realwoman_kids.gph women_work.gph stab_wifework.gph  pro_abort_church.gph pro_art_fert.gph pro_contracep.gph    , graphregion(color(white))  

graph export ${dataout}cis_event.pdf, replace

 
/*
***** Primary beliefs --- male
foreach var in  ideal_fam_equal ideal_fam_wifehome control_natal_both school_meet_wife absentwork_wife  husb_nothouseworks husb_lesshouseworks   stab_sharehousework stab_kids stab_wifework realwoman_kids  cleanhouse_woman   import_marry import_work import_mother import_family import_religion happ_sharehousework happ_kids pro_abort_church pro_art_fert pro_contracep     {
preserve
rename treat_2 outcome
eststo est_`var':reghdfe `var' outcome treat_3  if female==0 & year_birth<=1950 , a(i.id) vce(r)
restore
preserve
rename treat_3 outcome
eststo est_`var'_3:reghdfe `var' treat_2 outcome   if female==0 & year_birth<=1950 , a(i.id )  vce(r)
restore
if "`var'" == "ideal_fam_equal" {
outreg2 using ${dataout}table_cis_primary, dec(3)  label nonotes addtext( Mun. X Age class FE, YES, Year FE, YES)   tex(frag) keep(treat_2 treat_3) nocons replace 
    }
	else if "`var'" != "ideal_fam_equal" {
outreg2 using ${dataout}table_cis_primary, dec(3)  label nonotes addtext( Mun. X Age class FE, YES, Year FE, YES)   tex(frag) keep(treat_2 treat_3) nocons 
	}
	} 
	
	
coefplot (est_import_marry, aseq(import_marry) ///
	\ est_ideal_fam_equal, aseq(ideal_fam_equal) ///
	\ est_husb_nothouseworks, aseq(husb_nothouseworks) ///
	\ est_husb_lesshouseworks, aseq(husb_lesshouseworks) ///
	\ est_stab_sharehousework, aseq(stab_sharehousework) ///
	\ est_stab_kids, aseq(stab_kids) ///
	\ est_realwoman_kids, aseq(realwoman_kids) ///
	\ est_women_work, aseq(women_work) ///
	\ est_stab_wifework, aseq(stab_wifework) ///    
	\ est_pro_abort_church, aseq(pro_abort_church) ///
	\ est_pro_art_fert, aseq(pro_art_fert) ///
	\ est_pro_contracep, aseq(pro_contracep)), by(,graphregion(color(white))) subtitle(, bc(white)) bylabel(Partially treated (1931/39)) ///
	|| (est_import_marry_3, aseq(import_marry) ///
	\ est_ideal_fam_equal_3, aseq(ideal_fam_equal) ///
	\ est_husb_nothouseworks_3, aseq(husb_nothouseworks) ///
	\ est_husb_lesshouseworks_3, aseq(husb_lesshouseworks) ///
	\ est_stab_sharehousework_3, aseq(stab_sharehousework) ///
	\ est_stab_kids_3, aseq(stab_kids) ///
	\ est_realwoman_kids_3, aseq(realwoman_kids) ///
	\ est_women_work_3, aseq(women_work) ///
	\ est_stab_wifework_3, aseq(stab_wifework) ///
	\ est_pro_abort_church_3, aseq(pro_abort_church) ///
	\ est_pro_art_fert_3, aseq(pro_art_fert) ///
	\ est_pro_contracep_3, aseq(pro_contracep)),  by(,graphregion(color(white)))  bylabel(Fully treated (1940/50)) ///
	|| , group( import_marry ideal_fam_equal    husb_nothouseworks husb_lesshouseworks stab_sharehousework  = "{bf:Roles in the family}" ///
	stab_kids  realwoman_kids = "{bf:Motherhood}" ///
	women_work stab_wifework  = "{bf:Working}" pro_abort_church pro_art_fert pro_contracep  = "{bf:Church}", labgap(0) labs(small)) xline(0, lp(dash) ) pstyle(p10) pstyle(p23)  aseq swapnames  ci(95 90) msize(.5) keep(outcome)  ylabel(  1 "Realized woman: Marry (1990)" 2 "Gender roles: Equal (1990)" 3 "Husband no housework (1990)" 4 "Husband less housework (1990)"   5 "Couple's stability: Shared housework (1990)"  7 "Couple's stability: Kids (1990)"   8 "Real woman has kids (1990)"  10 "Woman works (1990)"  11 "Couple's stability: Wife works (1990)"  13 "Agree with Church: Abortion (1990)" 14 "Agree with Church: Artificial procreation (1990)" 15 "Agree with Church: Contraception (1990)" , labs(vsmall) ) yscale(noline   reverse) xlabel(, labs(vsmall))  //legend(off) 
graph save ${dataout}cis_2.gph, replace
graph export ${dataout}cis.pdf, replace	

*/

/*
*_______________________________________________ Robustness Portugal - ESS
use ${ESS}ESS_households_data.dta, clear
rename gndr gender
rename cntry country
rename yrbrn year_birth

keep if country=="IT" | country=="PT" | countr=="GR" | country=="ES"
keep if gender==2

*keep if year==2006 | year==2018

drop age
rename agea age
g age_c = floor(age/10)


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


gen treat=.
replace treat=0 if year_birth<=1929
replace treat=1 if year_birth>1929 & year_birth<1939
replace treat=2 if year_birth>=1939 

ta treat, gen(treat_)
label var treat_2 "1930/1938"
label var treat_3 "1939/1950"


gen nkids=nbthcld
replace nkids=0 if nkids==.a | nkids==.b

gen kids=bthcld
replace kids=0 if kids==2

egen id_country=group(country)
egen id_region=group(region)


***** Fertility in Portugal

** DID
foreach var in kids nkids {
	sum `var' if treat_1==1
local p=round(r(mean), .01)
reghdfe `var' treat_2 treat_3 if (country=="PT" )  & year_birth<=1950, a(i.id_country age_c#i.year  ) cluster(year#i.year_birth)
if "`var'" == "kids" {
	label var `var' "Kids" 
outreg2 using ${dataout}table_ess_kids, dec(3)  label nonotes addtext(  Year FE, YES, Age class FE, YES, Base value, `p')   tex(frag) keep(treat_2 treat_3)  nocons replace 
    }
	else if "`var'" != "kids" {
			label var `var' "N. kids" 
outreg2 using ${dataout}table_ess_kids, dec(3)  label nonotes addtext(  Year FE, YES, Age class FE, YES, Base value, `p')   tex(frag) keep(treat_2 treat_3) nocons 
	}
*reghdfe `var' treat_2 treat_3 year_partner  if female==0 & year_birth<=1952, a(i.id#i.age_c i.ESTU )  cluster(i.id#age_c)
*outreg2 using ${dataout}table_cis_kids, dec(3)  label nonotes addtext( Mun. X Age class FE, YES, Year FE, YES)   tex(frag) keep(treat_2 treat_3) nocons 
}

*/



*_______________________________________________ Robustness Portugal -- IVS
use "${IVS}Integrated_values_surveys_1981-2022.dta", clear
rename X001 gender
rename S009 country
rename X002 year_birth

keep if country=="IT" | country=="PT" | countr=="GR" | country=="ES"
keep if gender==2

*keep if year==2006 | year==2018

rename X003 age
g age_c = floor(age/10)


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


gen treat=.
replace treat=0 if year_birth<=1929
replace treat=1 if year_birth>1929 & year_birth<1939
replace treat=2 if year_birth>=1939 

ta treat, gen(treat_)
label var treat_2 "1930/1938"
label var treat_3 "1939/1950"


gen nkids=X011

gen kids=X011A


egen id_country=group(country)
egen id_region=group(x048b_n2)

rename S020 year

replace kids=1 if nkids>0 & nkids!=.
replace kids=0 if nkids==0 


***** Fertility in Portugal

** DID
foreach var in kids nkids {
	sum `var' if treat_1==1
local p=round(r(mean), .01)
reghdfe `var' treat_2 treat_3 if (country=="PT" )  & year_birth<=1950, a(i.id_region##age_c##i.year  ) cluster(year#i.year_birth)
if "`var'" == "kids" {
	label var `var' "Kids" 
outreg2 using ${dataout}table_ivs_kids, dec(3)  label nonotes addtext(  Year FE, YES, Mun. FE, YES, Age class FE, YES, Year X Age group X Residence FE, YES, Base value, `p')   tex(frag) keep(treat_2 treat_3)  nocons replace 
    }
	else if "`var'" != "kids" {
			label var `var' "N. kids" 
outreg2 using ${dataout}table_ivs_kids, dec(3)  label nonotes addtext(   Year FE, YES, Mun. FE, YES, Age class FE, YES, Year X Age group X Residence FE, YES, Base value, `p')   tex(frag) keep(treat_2 treat_3) nocons 
	}
}

	
*_______________________________________________ Robustness Census
****** 1991 --- provincial
use ${datain2}censo1991/por_provincias/censo1991_provincias.dta, clear
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
rename prov codprov
rename pronacin codprov_born
rename mun cmun
rename hijos nhijos
gen weight=fe/10000
save ${datain}dataset_microdata1991_cleanedMarco.dta, replace


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

append using ${datain}dataset_microdata1991_cleanedMarco.dta

gen anac_m=ym(anac, mnac)
format %tm anac_m

gen treat=.
replace treat=0 if anac<=1929
replace treat=1 if anac>1929 & anac<1939
replace treat=2 if anac>=1939

ta treat, gen(treat_)
label var treat_2 "1930/1938"
label var treat_3 "1939/1950"

gen weight2= fe if year==1991
replace weight2=factor if year==2011

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

sum `var' if treat_1==1
local p=round(r(mean), .01)

reghdfe `var' treat_2 treat_3  if sexo==6 & anac>=1920 & anac<=1950 [aw=weight2], a(cmun##i.age_c##year) cluster(year#anac)
if "`var'" == "kids2" {
		label var `var' "Kids" 

outreg2 using ${dataout}table_census_kids, dec(3)  label nonotes addtext(  Year FE, YES, Residence FE, YES, Age class FE, YES, Base value, `p')    tex(frag) keep( treat_2 treat_3) nocons replace 
    }
	else if "`var'" != "kids2" {
			label var `var' "N.Kids" 

outreg2 using ${dataout}table_census_kids, dec(3)  label nonotes  addtext(  Year FE, YES, Residence FE, YES, Age class FE, YES, Base value, `p')   tex(frag) keep( treat_2 treat_3) nocons 
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

reghdfe `var'  anac_1-anac_9 o.anac_10 anac_11-anac_31  if sexo==6 & anac>=1920 & anac<=1950 [aw=weight2], a(cmun##i.age_c##year) cluster(year#anac)
coefplot , vertical keep(anac_*)  base omitted  yline(0, lc(red) lp(dash)) xline(10, lcolor(blue) lpattern(dash)) xline(20, lcolor(green) lpattern(dash)) ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) /*title("`name'", s(small) c(black))*/ title("`name'", s(small)) scheme(s2mono) xtick(1(2)31) xlabel(, angle(45) labs(tiny))   

graph export ${dataout}`var'_census.pdf,replace
}
restore


**# MACRO


*_______________________________________________ Robustness Macro effects

use  ${datain}dataset.dta, clear
/*
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
**# GRAPH Composition fertile Age classs -- 1 
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
**# GRAPH Composition fertile Age classs -- 0 
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
**# Size fertile Age classs -- 1 
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
**# Size fertile Age classs -- 0
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
* Stability fertile Age classs -- Absolute values 
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
use  ${datain}dataset.dta, clear

gen popsharewomen_agegroup1=(popsharewomen_agegroup1_1940+popsharewomen_agegroup2_1940)*100
gen popsharemen_agegroup1=(popsharemen_agegroup1_1940+popsharemen_agegroup2_1940)*100
gen flag4=.
gen flag4_3=.
gen flag4_4=.
gen flag4_5=.

replace flag4= ln(popwomen_agegroup3_1930 +popwomen_agegroup4_1930 +popwomen_agegroup5_1930) if year>=1930 & year<1940
replace flag4= ln(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940) if year>=1940 & year<1950
replace flag4= ln(popwomen_agegroup3_1950 +popwomen_agegroup4_1950 +popwomen_agegroup5_1950) if year>=1950 & year<1960
replace flag4= ln(popwomen_agegroup3_1960 +popwomen_agegroup4_1960 +popwomen_agegroup5_1960) if year>=1960 & year<1970
replace flag4= ln(popwomen_agegroup3_1970 +popwomen_agegroup4_1970 +popwomen_agegroup5_1970) if year>=1970 & year<1980


replace flag4_3= ln(popwomen_agegroup3_1930) if year>=1930 & year<1940
replace flag4_3= ln(popwomen_agegroup3_1940) if year>=1940 & year<1950
replace flag4_3= ln(popwomen_agegroup3_1950) if year>=1950 & year<1960
replace flag4_3= ln(popwomen_agegroup3_1960) if year>=1960 & year<1970
replace flag4_3= ln(popwomen_agegroup3_1970) if year>=1970 & year<1980

replace flag4_4= ln(popwomen_agegroup4_1930) if year>=1930 & year<1940
replace flag4_4= ln(popwomen_agegroup4_1940) if year>=1940 & year<1950
replace flag4_4= ln(popwomen_agegroup4_1950) if year>=1950 & year<1960
replace flag4_4= ln(popwomen_agegroup4_1960) if year>=1960 & year<1970
replace flag4_4= ln(popwomen_agegroup4_1970) if year>=1970 & year<1980

replace flag4_5= ln(popwomen_agegroup5_1930) if year>=1930 & year<1940
replace flag4_5= ln(popwomen_agegroup5_1940) if year>=1940 & year<1950
replace flag4_5= ln(popwomen_agegroup5_1950) if year>=1950 & year<1960
replace flag4_5= ln(popwomen_agegroup5_1960) if year>=1960 & year<1970
replace flag4_5= ln(popwomen_agegroup5_1970) if year>=1970 & year<1980
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

reghdfe `x'  interaction  1.post##c.sum`i' flag4_3 flag4_4 flag4_5, a(i.id i.year ) cluster(id) 
outreg2 using ${dataout}table_reg_female_trends, dec(3)  label nonotes addtext( Unit FE, YES, Year FE, YES, Prov. X Year FE, NO)  ct("`tit'") tex(frag) keep(interaction) nocons replace addstat(Mean of depvar, `mean_depvar')

reghdfe `x'  interaction  1.post##c.sum`i' flag4_3 flag4_4 flag4_5, a(i.id i.year#i.codprov ) cluster(id) 
outreg2 using ${dataout}table_reg_female_trends, dec(3)  label nonotes addtext( Unit FE, YES, Year FE, YES, Prov. X Year FE, YES)  ct("`tit'") tex(frag) keep(interaction) nocons  addstat(Mean of depvar, `mean_depvar')

reghdfe `x'  interaction interaction2  1.post##c.sum`i' 1.post##c.sum2`i' flag4_3 flag4_4 flag4_5, a(i.id i.year) cluster(id) 
outreg2 using ${dataout}table_reg_female_trends, dec(3)  label nonotes addtext( Unit FE, YES, Year FE, YES, Prov. X Year FE, NO)  ct("`tit'") tex(frag) keep(interaction interaction2) nocons addstat(Mean of depvar, `mean_depvar')

reghdfe `x'  interaction interaction2  1.post##c.sum`i' 1.post##c.sum2`i' flag4_3 flag4_4 flag4_5, a(i.id i.year#i.codprov ) cluster(id) 
outreg2 using ${dataout}table_reg_female_trends, dec(3)  label nonotes addtext( Unit FE, YES, Year FE, YES, Prov. X Year FE, YES)  ct("`tit'") tex(frag) keep(interaction interaction2) nocons addstat(Mean of depvar, `mean_depvar')

*egen idprovinceyear= group(codprov year)
*
reghdfe `x' b1945.year##c.sum`i'  b1945.year##c.sum2`i' flag4_3 flag4_4 flag4_5, a(i.id i.year#i.codprov) cluster(id) 

coefplot , keep(*.year#c.sum`i') vertical base omitted  yline(0, lc(black) lp(dash)) xline(16, lcolor(blue)  lpattern(dash)) xline(25, lcolor(red%25)) xline(35, lcolor(red%50)) xline(45, lcolor(red%75)) ms(m)  ylabel(, angle(horizotal) labsize(tiny)) leg(off)  graphregion(color(white)) msize(vsmall) levels(99 95 90) /*title("`name'", s(small) c(black))*/ ytitle("`name2'", s(vsmall)) scheme(s2mono) xlabel(, angle(45) labs(tiny))   ///
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



** socialist
reghdfe `x'  interaction interaction2  1.post##c.sum`i' 1.post##c.sum2`i' flag4_3 flag4_4 flag4_5, a(i.id i.year#c.share_socialistas1931) cluster(id) 
outreg2 using ${dataout}table_reg_female_rob, dec(3)  label nonotes addtext(Test, Socialists, Fertile pop., YES, Unit FE, YES, Year FE, YES, Prov. X Year FE, YES)  ct("`tit'") tex(frag) keep(interaction) nocons replace addstat(Mean of depvar, `mean_depvar')

reghdfe `x'  interaction interaction2  1.post##c.sum`i' 1.post##c.sum2`i' flag4_3 flag4_4 flag4_5, a(i.id i.year#i.codprov i.year#c.share_socialistas1931) cluster(id) 
outreg2 using ${dataout}table_reg_female_rob, dec(3)  label nonotes addtext(Test, Socialists, Fertile pop., YES, Unit FE, YES, Year FE, YES, Prov. X Year FE, YES)  ct("`tit'") tex(frag) keep(interaction interaction2) nocons  addstat(Mean of depvar, `mean_depvar')




}
restore


/*
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

replace flag4_3= ln(popwomen_agegroup3_1930) if year>=1930 & year<1940
replace flag4_3= ln(popwomen_agegroup3_1940) if year>=1940 & year<1950
replace flag4_3= ln(popwomen_agegroup3_1950) if year>=1950 & year<1960
replace flag4_3= ln(popwomen_agegroup3_1960) if year>=1960 & year<1970
replace flag4_3= ln(popwomen_agegroup3_1970) if year>=1970 & year<1980

replace flag4_4= ln(popwomen_agegroup4_1930) if year>=1930 & year<1940
replace flag4_4= ln(popwomen_agegroup4_1940) if year>=1940 & year<1950
replace flag4_4= ln(popwomen_agegroup4_1950) if year>=1950 & year<1960
replace flag4_4= ln(popwomen_agegroup4_1960) if year>=1960 & year<1970
replace flag4_4= ln(popwomen_agegroup4_1970) if year>=1970 & year<1980

replace flag4_5= ln(popwomen_agegroup5_1930) if year>=1930 & year<1940
replace flag4_5= ln(popwomen_agegroup5_1940) if year>=1940 & year<1950
replace flag4_5= ln(popwomen_agegroup5_1950) if year>=1950 & year<1960
replace flag4_5= ln(popwomen_agegroup5_1960) if year>=1960 & year<1970
replace flag4_5= ln(popwomen_agegroup5_1970) if year>=1970 & year<1980
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

reghdfe `x'  interaction  1.post##c.sum`i' flag4_3 flag4_4 flag4_5, a(i.id i.year ) cluster(id) 
outreg2 using ${dataout}table_reg_female_trends_deaths, dec(3)  label nonotes addtext( Unit FE, YES, Year FE, YES, Prov. X Year FE, NO)  ct("`tit'") tex(frag) keep(interaction) nocons replace addstat(Mean of depvar, `mean_depvar')

reghdfe `x'  interaction  1.post##c.sum`i' flag4_3 flag4_4 flag4_5, a(i.id i.year#i.codprov ) cluster(id) 
outreg2 using ${dataout}table_reg_female_trends_deaths, dec(3)  label nonotes addtext( Unit FE, YES, Year FE, YES, Prov. X Year FE, YES)  ct("`tit'") tex(frag) keep(interaction) nocons  addstat(Mean of depvar, `mean_depvar')

reghdfe `x'  interaction interaction2  1.post##c.sum`i' 1.post##c.sum2`i' flag4_3 flag4_4 flag4_5, a(i.id i.year) cluster(id) 
outreg2 using ${dataout}table_reg_female_trends_deaths, dec(3)  label nonotes addtext( Unit FE, YES, Year FE, YES, Prov. X Year FE, NO)  ct("`tit'") tex(frag) keep(interaction interaction2) nocons addstat(Mean of depvar, `mean_depvar')

reghdfe `x'  interaction interaction2  1.post##c.sum`i' 1.post##c.sum2`i' flag4_3 flag4_4 flag4_5, a(i.id i.year#i.codprov ) cluster(id) 
outreg2 using ${dataout}table_reg_female_trends_deaths, dec(3)  label nonotes addtext( Unit FE, YES, Year FE, YES, Prov. X Year FE, YES)  ct("`tit'") tex(frag) keep(interaction interaction2) nocons addstat(Mean of depvar, `mean_depvar')


reghdfe `x'  interaction interaction2 interaction3 1.post##c.sum`i' 1.post##c.sum2`i' 1.post##c.deaths_male_cwar flag4_3 flag4_4 flag4_5, a(i.id i.year) cluster(id) 
outreg2 using ${dataout}table_reg_female_trends_deaths, dec(3)  label nonotes addtext( Unit FE, YES, Year FE, YES, Prov. X Year FE, NO)  ct("`tit'") tex(frag) keep(interaction interaction2 interaction3) nocons addstat(Mean of depvar, `mean_depvar')

reghdfe `x'  interaction interaction2 interaction3 1.post##c.sum`i' 1.post##c.sum2`i' 1.post##c.deaths_male_cwar flag4_3 flag4_4 flag4_5, a(i.id i.year#i.codprov ) cluster(id) 
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

*/

***************************************
**# Discrete treatment ---- Base mobile 
***************************************
preserve
use  ${datain}dataset.dta, clear

gen popsharewomen_agegroup1=popsharewomen_agegroup1_1940+popsharewomen_agegroup2_1940
gen popsharemen_agegroup1=popsharemen_agegroup1_1940+popsharemen_agegroup2_1940
gen flag4=.
gen flag4_3=.
gen flag4_4=.
gen flag4_5=.

replace flag4= ln(popwomen_agegroup3_1930 +popwomen_agegroup4_1930 +popwomen_agegroup5_1930) if year>=1930 & year<1940
replace flag4= ln(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940) if year>=1940 & year<1950
replace flag4= ln(popwomen_agegroup3_1950 +popwomen_agegroup4_1950 +popwomen_agegroup5_1950) if year>=1950 & year<1960
replace flag4= ln(popwomen_agegroup3_1960 +popwomen_agegroup4_1960 +popwomen_agegroup5_1960) if year>=1960 & year<1970
replace flag4= ln(popwomen_agegroup3_1970 +popwomen_agegroup4_1970 +popwomen_agegroup5_1970) if year>=1970 & year<1980


replace flag4_3= ln(popwomen_agegroup3_1930) if year>=1930 & year<1940
replace flag4_3= ln(popwomen_agegroup3_1940) if year>=1940 & year<1950
replace flag4_3= ln(popwomen_agegroup3_1950) if year>=1950 & year<1960
replace flag4_3= ln(popwomen_agegroup3_1960) if year>=1960 & year<1970
replace flag4_3= ln(popwomen_agegroup3_1970) if year>=1970 & year<1980

replace flag4_4= ln(popwomen_agegroup4_1930) if year>=1930 & year<1940
replace flag4_4= ln(popwomen_agegroup4_1940) if year>=1940 & year<1950
replace flag4_4= ln(popwomen_agegroup4_1950) if year>=1950 & year<1960
replace flag4_4= ln(popwomen_agegroup4_1960) if year>=1960 & year<1970
replace flag4_4= ln(popwomen_agegroup4_1970) if year>=1970 & year<1980

replace flag4_5= ln(popwomen_agegroup5_1930) if year>=1930 & year<1940
replace flag4_5= ln(popwomen_agegroup5_1940) if year>=1940 & year<1950
replace flag4_5= ln(popwomen_agegroup5_1950) if year>=1950 & year<1960
replace flag4_5= ln(popwomen_agegroup5_1960) if year>=1960 & year<1970
replace flag4_5= ln(popwomen_agegroup5_1970) if year>=1970 & year<1980

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

sum popsharewomen_agegroup1 if sum`i'==1
sum popsharewomen_agegroup1 if sum`i'==0

label var interaction "Treat (W) X Post 1945"
label var interaction2 "Treat (M) X Post 1945"

local name2 = "Alive births"
local tit = "Births"
local name = "0-14"

reghdfe `x'  interaction  1.post##c.sum`i' flag4_3 flag4_4 flag4_5, a(i.id i.year#i.codprov ) cluster(id) 
outreg2 using ${dataout}table_reg_female_rob, dec(3)  label nonotes addtext(Test, Discrete, Fertile pop., YES, Unit FE, YES, Year FE, YES, Prov. X Year FE, YES)  ct("`tit'") tex(frag) keep(interaction) nocons  addstat(Mean of depvar, `mean_depvar')

reghdfe `x'  interaction interaction2  1.post##c.sum`i' 1.post##c.sum2`i' flag4_3 flag4_4 flag4_5, a(i.id i.year#i.codprov ) cluster(id) 
outreg2 using ${dataout}table_reg_female_rob, dec(3)  label nonotes addtext(Test, Discrete, Fertile pop., YES, Unit FE, YES, Year FE, YES, Prov. X Year FE, YES)  ct("`tit'") tex(frag) keep(interaction interaction2) nocons addstat(Mean of depvar, `mean_depvar')
*egen idprovinceyear= group(codprov year)
*
reghdfe `x' b1945.year##c.sum`i'  b1945.year##c.sum2`i' flag4_3 flag4_4 flag4_5, a(i.id i.year#i.codprov) cluster(id) 

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




***************************************
**# Placebo 15-24 1940 
***************************************
preserve
use  ${datain}dataset.dta, clear
gen popsharewomen_agegroup2=popsharewomen_agegroup3_1940*100
gen popsharemen_agegroup2=popsharemen_agegroup3_1940*100

gen flag4=.
gen flag4_2=.
gen flag4_3=.
gen flag4_4=.
gen flag4_5=.

replace flag4= ln(popwomen_agegroup3_1930 +popwomen_agegroup4_1930 +popwomen_agegroup5_1930) if year>=1930 & year<1940
replace flag4= ln(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940) if year>=1940 & year<1950
replace flag4= ln(popwomen_agegroup3_1950 +popwomen_agegroup4_1950 +popwomen_agegroup5_1950) if year>=1950 & year<1960
replace flag4= ln(popwomen_agegroup3_1960 +popwomen_agegroup4_1960 +popwomen_agegroup5_1960) if year>=1960 & year<1970
replace flag4= ln(popwomen_agegroup3_1970 +popwomen_agegroup4_1970 +popwomen_agegroup5_1970) if year>=1970 & year<1980

replace flag4_2= ln(popwomen_agegroup2_1930) if year>=1930 & year<1940
replace flag4_2= ln(popwomen_agegroup2_1940) if year>=1940 & year<1950
replace flag4_2= ln(popwomen_agegroup2_1950) if year>=1950 & year<1960
replace flag4_2= ln(popwomen_agegroup2_1960) if year>=1960 & year<1970
replace flag4_2= ln(popwomen_agegroup2_1970) if year>=1970 & year<1980

replace flag4_3= ln(popwomen_agegroup3_1930) if year>=1930 & year<1940
replace flag4_3= ln(popwomen_agegroup3_1940) if year>=1940 & year<1950
replace flag4_3= ln(popwomen_agegroup3_1950) if year>=1950 & year<1960
replace flag4_3= ln(popwomen_agegroup3_1960) if year>=1960 & year<1970
replace flag4_3= ln(popwomen_agegroup3_1970) if year>=1970 & year<1980

replace flag4_4= ln(popwomen_agegroup4_1930) if year>=1930 & year<1940
replace flag4_4= ln(popwomen_agegroup4_1940) if year>=1940 & year<1950
replace flag4_4= ln(popwomen_agegroup4_1950) if year>=1950 & year<1960
replace flag4_4= ln(popwomen_agegroup4_1960) if year>=1960 & year<1970
replace flag4_4= ln(popwomen_agegroup4_1970) if year>=1970 & year<1980

replace flag4_5= ln(popwomen_agegroup5_1930) if year>=1930 & year<1940
replace flag4_5= ln(popwomen_agegroup5_1940) if year>=1940 & year<1950
replace flag4_5= ln(popwomen_agegroup5_1950) if year>=1950 & year<1960
replace flag4_5= ln(popwomen_agegroup5_1960) if year>=1960 & year<1970
replace flag4_5= ln(popwomen_agegroup5_1970) if year>=1970 & year<1980

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

reghdfe `x'  interaction  1.post##c.sum`i' flag4_2  flag4_4 flag4_5, a(i.id i.year#i.codprov ) cluster(id) 
outreg2 using ${dataout}table_reg_female_rob, dec(3)  label nonotes addtext(Test, Placebo, Fertile pop., YES, Unit FE, YES, Year FE, YES, Prov. X Year FE, YES) ct("`tit'") tex(frag) keep(interaction) nocons  addstat(Mean of depvar, `mean_depvar')

reghdfe `x'  interaction interaction2  1.post##c.sum`i' 1.post##c.sum2`i' flag4_2 flag4_4 flag4_5, a(i.id i.year#i.codprov ) cluster(id) 
outreg2 using ${dataout}table_reg_female_rob, dec(3)  label nonotes addtext(Test, Placebo, Fertile pop., YES, Unit FE, YES, Year FE, YES, Prov. X Year FE, YES)  ct("`tit'") tex(frag) keep(interaction interaction2) nocons addstat(Mean of depvar, `mean_depvar')
*egen idprovinceyear= group(codprov year)
*
reghdfe `x' b1945.year##c.sum`i'  b1945.year##c.sum2`i' flag4_2  flag4_4 flag4_5, a(i.id i.year#i.codprov) cluster(id) 

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
use  ${datain}dataset.dta, clear
gen popsharewomen_agegroup1=(popsharewomen_agegroup1_1940+popsharewomen_agegroup2_1940)*100
gen popsharemen_agegroup1=(popsharemen_agegroup1_1940+popsharemen_agegroup2_1940)*100
gen flag4=.
gen flag4_3=.
gen flag4_4=.
gen flag4_5=.

replace flag4= ln(popwomen_agegroup3_1930 +popwomen_agegroup4_1930 +popwomen_agegroup5_1930) if year>=1930 & year<1940
replace flag4= ln(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940) if year>=1940 & year<1950
replace flag4= ln(popwomen_agegroup3_1950 +popwomen_agegroup4_1950 +popwomen_agegroup5_1950) if year>=1950 & year<1960
replace flag4= ln(popwomen_agegroup3_1960 +popwomen_agegroup4_1960 +popwomen_agegroup5_1960) if year>=1960 & year<1970
replace flag4= ln(popwomen_agegroup3_1970 +popwomen_agegroup4_1970 +popwomen_agegroup5_1970) if year>=1970 & year<1980


replace flag4_3= ln(popwomen_agegroup3_1930) if year>=1930 & year<1940
replace flag4_3= ln(popwomen_agegroup3_1940) if year>=1940 & year<1950
replace flag4_3= ln(popwomen_agegroup3_1950) if year>=1950 & year<1960
replace flag4_3= ln(popwomen_agegroup3_1960) if year>=1960 & year<1970
replace flag4_3= ln(popwomen_agegroup3_1970) if year>=1970 & year<1980

replace flag4_4= ln(popwomen_agegroup4_1930) if year>=1930 & year<1940
replace flag4_4= ln(popwomen_agegroup4_1940) if year>=1940 & year<1950
replace flag4_4= ln(popwomen_agegroup4_1950) if year>=1950 & year<1960
replace flag4_4= ln(popwomen_agegroup4_1960) if year>=1960 & year<1970
replace flag4_4= ln(popwomen_agegroup4_1970) if year>=1970 & year<1980

replace flag4_5= ln(popwomen_agegroup5_1930) if year>=1930 & year<1940
replace flag4_5= ln(popwomen_agegroup5_1940) if year>=1940 & year<1950
replace flag4_5= ln(popwomen_agegroup5_1950) if year>=1950 & year<1960
replace flag4_5= ln(popwomen_agegroup5_1960) if year>=1960 & year<1970
replace flag4_5= ln(popwomen_agegroup5_1970) if year>=1970 & year<1980
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

local name2 = "Weddings"
local tit = "Births"
local name = "0-14"

reghdfe `x'  interaction  1.post##c.sum`i' flag4_3 flag4_4 flag4_5 , a(i.id i.year#i.codprov ) cluster(id) 
outreg2 using ${dataout}table_reg_female_rob, dec(3)  label nonotes addtext(Test, Weddings, Fertile pop., YES, Unit FE, YES, Year FE, YES, Prov. X Year FE, YES)  ct("`tit'") tex(frag) keep(interaction) nocons  addstat(Mean of depvar, `mean_depvar')

reghdfe `x'  interaction interaction2  1.post##c.sum`i' 1.post##c.sum2`i' flag4_3 flag4_4 flag4_5, a(i.id i.year#i.codprov ) cluster(id) 
outreg2 using ${dataout}table_reg_female_rob, dec(3)  label nonotes addtext(Test, Weddings, Fertile pop., YES, Unit FE, YES, Year FE, YES, Prov. X Year FE, YES)  ct("`tit'") tex(frag) keep(interaction interaction2) nocons addstat(Mean of depvar, `mean_depvar')
*egen idprovinceyear= group(codprov year)
*
reghdfe `x' b1945.year##c.sum`i'  b1945.year##c.sum2`i' flag4_3 flag4_4 flag4_5, a(i.id i.year#i.codprov) cluster(id) 

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
use  ${datain}dataset.dta, clear

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
			local name = "Comunsits (\%, local 1931)"
			
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


	
	


