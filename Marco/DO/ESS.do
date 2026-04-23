global datain "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/output_data/"
global dataout "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/Marco/Results/"
global ESS "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/Marco/Data/"


use ${ESS}ESS_households_data.dta, clear
rename gndr gender
rename cntry country
rename yrbrn year_birth

keep if country=="IT" | country=="PT" | countr=="GR" | country=="ES"
keep if gender==2

keep if year==2006 | year==2018

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
replace treat=0 if year_birth<=1930
replace treat=1 if year_birth>1930 & year_birth<1940
replace treat=2 if year_birth>=1940 

ta treat, gen(treat_)
label var treat_2 "1931/1939"
label var treat_3 "1940/1952"


gen nkids=nbthcld
replace nkids=0 if nkids==.a | nkids==.b

gen kids=bthcld==1

egen id_country=group(country)


***** Fertility in Portugal

** DID
foreach var in kids nkids {
reghdfe `var' treat_2 treat_3 if country=="PT" & year_birth<=1952, a(i.id_country#age_c i.year  ) cluster(i.year_birth)
if "`var'" == "kids" {
	label var `var' "Kids" 
outreg2 using ${dataout}table_ess_kids, dec(3)  label nonotes addtext( Mun. X Age class FE, YES, Year FE, YES)   tex(frag) keep(treat_2 treat_3)  nocons replace 
    }
	else if "`var'" != "kids" {
			label var `var' "N. kids" 
outreg2 using ${dataout}table_ess_kids, dec(3)  label nonotes addtext( Mun. X Age class FE, YES, Year FE, YES)   tex(frag) keep(treat_2 treat_3) nocons 
	}
*reghdfe `var' treat_2 treat_3 year_partner  if female==0 & year_birth<=1952, a(i.id#i.age_c i.ESTU )  cluster(i.id#age_c)
*outreg2 using ${dataout}table_cis_kids, dec(3)  label nonotes addtext( Mun. X Age class FE, YES, Year FE, YES)   tex(frag) keep(treat_2 treat_3) nocons 
}


	


