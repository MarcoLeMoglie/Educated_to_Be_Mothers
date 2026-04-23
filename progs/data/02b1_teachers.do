***************************************
* 
***************************************
use "$dir\$Output_data\purge\victimsarchive_muncode_v2.dta",clear
drop     province 
rename archive_agm teachers
rename archive_agm_male teachers_male
*rename archive_agm_entered teachers_entered
sort codprov
by codprov: egen teachers_prov = sum(teachers) 
by codprov: egen teachers_male_prov = sum(teachers_male) 
*by codprov: egen teachers_entered_prov = sum(teachers_entered) 

order codprov codmun municip teachers_prov 
replace municip = subinstr(municip, "Ñ", "ñ", .) //EÑE

gen type ="municipality"


merge 1:1 codprov municip type using "$Data\census\census_1940.dta"
drop pop_1940 pop_agegroup* popshare_ageg*
drop pop*
sort type
sort codprov

*replace type ="capital" if _merge == 3

foreach v of varlist teachers teachers_male { //teachers_entered
    by codprov: egen `v'_rest = sum(`v') if _merge == 1 
	sort codprov
	drop `v'_prov
}
bysort codprov (teachers_rest): replace teachers_rest = teachers_rest[1] if missing(teachers_rest)
bysort codprov (teachers_male_rest): replace teachers_male_rest = teachers_rest[1] if missing(teachers_male_rest)
*bysort codprov (teachers_entered_rest): replace teachers_entered_rest = teachers_rest[1] if missing(teachers_entered_rest)

foreach v of varlist teachers teachers_male { //teachers_entered
  replace `v' = `v'_rest if _merge==1 
	drop `v'_rest
}
replace municip = "rest province" if _merge==1 
replace type = "rest province" if _merge==1 

 

drop if _merge== 2

drop _merge province codmun

duplicates drop
replace teachers =. if teachers == 0
replace teachers_male=. if teachers == .
replace teachers_male=. if teachers_male == 0
*replace teachers_entered =. if teachers_ent == 0 
save "$dir\$Output_data\purge\teachers.dta", replace

* * * * * * * * * * * * *

use "$dir\$Output_data\purge\teachers.dta", clear
gen var1 = 1
bysort var1 :egen sumteachers = sum(teachers)


gen var1 = 1
bysort var1 :egen sumteachers = sum(victim_mun)
