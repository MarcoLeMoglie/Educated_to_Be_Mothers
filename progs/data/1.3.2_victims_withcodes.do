/*
use "$dir\$Output_data\purge\victims_mun.dta" , clear 

replace municip = stritrim(municip) // with all consecutive, internal blanks collapsed to one blank
replace municip = strtrim(municip) // leading and trailing blanks removed.
drop if province =="las palmas"|province =="illes balears"|province =="tenerife"|province =="francia"|province =="cuba"|province =="baleares"
reclink2 municip codprov using "$Data\INE_codes\INE_municip.dta", idmaster(idvictim) idusing(id_ine) gen(match) minscore(0.9)
 *tiempo: 2 min
 *version 3 9 oct 3023: 
 * 12h    matched = 9124 (exact = 7506), unmatched = 10446 // 58475
 * 15:00h matched = 9057 (exact = 7454), unmatched = 10044 // 47452
 * 15:30h matched = 9079 (exact = 7458), unmatched = 10015 // 42804
 * 16 h   matched = 9074 (exact = 7474), unmatched = 9992 // 35388
 *
 br municip codprov victim_mun if match==.
 sort victim_mun
 *egen unmatched_victims = sum(victim_mun ) if match==.
  */
 ***************************************
**# This dofile merges the baseline dataset that contains municipality and province 
 * codes with the dataset on the number of victims by municipality (APROX. 30MIN)
 *************************************** before baseline
use "$Data\INE_codes\INE_municip.dta", clear 

replace municip = stritrim(municip) // with all consecutive, internal blanks collapsed to one blank
replace municip = strtrim(municip) // leading and trailing blanks removed.

reclink2 municip codprov using "$dir\$Output_data\purge\victims_mun.dta", idmaster(id_ine) idusing(idvictim) gen(match) minscore(0.9)
//7218 matched(exact 6263) unmatched 1200

format %20s municip
format %10s province
format %20s Umunicip
rename CMUN codmun
destring codmun, replace
order codprov codmun match _merge
sort match codprov codmun 
drop Umunicip Ucodprov

keep codprov codmun victim_mun victim_male //entered_mun
replace victim_mun =0 if victim_mun ==.
replace victim_male =0 if victim_male ==.
sort codprov codmun
// there are duplicates, so let's sum the victims by municipalities duplicates and drop them
by  codprov codmun: egen victims =sum(victim_mun)
by  codprov codmun: egen victims_male =sum(victim_male)
drop victim_mun
drop victim_male
duplicates drop codprov codmun, force
*drop if codprov ==35 | codprov ==38 // Canary Islands
drop if codprov ==51 | codprov ==52 // Ceuta, Melilla

save  "$dir\$Output_data\purge\victims_muncode.dta", replace
use  "$dir\$Output_data\purge\victims_muncode.dta", clear

***************************************
**# By archive. Number of victims by municipality and archive
***************************************
use "$Data\INE_codes\INE_municip.dta", clear 

replace municip = strtrim(municip) // leading and trailing blanks removed.

replace municip = subinstr(municip, "Á", "A", .) //supress the accents
replace municip = subinstr(municip, "á", "A", .) //supress the accents
replace municip = subinstr(municip, "à", "A", .) //supress the accents
replace municip = subinstr(municip, "É", "E", .) //supress the accents
replace municip = subinstr(municip,"é", "E", .) //supress the accents
replace municip = subinstr(municip, "è", "E", .) //supress the accents
replace municip = subinstr(municip, "Í", "I", .) //supress the accents
replace municip = subinstr(municip, "ï", "I", .) //supress the accents
replace municip = subinstr(municip, "í", "I", .) //supress the accents
replace municip = subinstr(municip, "ì", "I", .) //supress the accents
replace municip = subinstr(municip, "Ó", "O", .) //supress the accents
replace municip = subinstr(municip,"ó", "O", .) //supress the accents
replace municip = subinstr(municip, "ò", "O", .) //supress the accents
replace municip = subinstr(municip, "Ú", "U", .) //supress the accents
replace municip = subinstr(municip, "ú", "U", .) //supress the accents
replace municip = subinstr(municip, "ù", "U", .) //supress the accents
replace municip = subinstr(municip, "ñ", "Ñ", .) //eñe
replace municip = subinstr(municip, "ç", "C", .) //


reclink2 municip codprov using "$dir\$Output_data\purge\victims_archive.dta",  idmaster(id_ine) idusing(idvictim1) gen(match) minscore(0.95)
//7215 matched(exact 5602) unmatched 916
// new version v.1 matched 7407 (exact 5769) unmatched 724
// v.3 matched 7481 (exact 6884 ) unmatched 650
rename CMUN codmun
destring codmun, replace
keep codprov codmun province municip  archive victim_archive victim_mun victim_archive_male victim_male //entered_mun
format %20s municip
format %10s province

replace victim_mun =0 if victim_mun ==.
replace victim_archive =0 if victim_archive ==.
*drop if codprov ==35 | codprov ==38 // Canary Islands
drop if codprov ==51 | codprov ==52 // Ceuta, Melilla

save  "$dir\$Output_data\purge\victimsarchive_muncode.dta", replace // I do this to save time later on

use "$dir\$Output_data\purge\victimsarchive_muncode.dta", clear
sort codprov codmun archive
// after retrieving the codmun, there are duplicates, so let's sum the victims by municipalities duplicates and drop them

by  codprov codmun archive: egen victims_arch =sum(victim_archive)
by  codprov codmun archive: egen victims_arch_male =sum(victim_archive_male)
*by  codprov codmun archive: egen entered_arch =sum(entered_mun)


drop victim_mun victim_male victim_archive victim_archive_male
duplicates drop codprov codmun victims_arch victims_arch_male , force //entered_mun
tab archive
gen arch_agm = victims_arch if  strpos(archive , "Archivo General de la Ad") > 0
replace arch_agm =0 if arch_agm==.


*Male version:
gen arch_agm_male = victims_arch_male if  strpos(archive , "Archivo General de la Ad") > 0
replace arch_agm_male =0 if arch_agm_male==.
* Entered
*gen arch_agm_entered = entered_arch if  strpos(archive , "Archivo General de la Ad") > 0
*replace arch_agm_entered =0 if entered_arch==.

drop victims_arch_male victims_arch //entered_arch
save "$dir\$Output_data\purge\victimsarchive_muncode_v2.dta", replace
* sum for each municipality so that there is a unique obs for each mun
use "$dir\$Output_data\purge\victimsarchive_muncode_v2.dta",clear
sort codprov codmun
by codprov codmun: egen archive_agm=sum(arch_agm)

* male version:
by codprov codmun: egen archive_agm_male=sum(arch_agm_male)

* entered
*by codprov codmun: egen archive_agm_entered=sum(arch_agm_entered)

duplicates drop codprov codmun, force
*drop if codprov ==35 | codprov ==38 // Canary Islands
drop if codprov ==51 | codprov ==52 // Ceuta, Melilla
drop archive arch_*
*drop entered_mun
save "$dir\$Output_data\purge\victimsarchive_muncode_v2.dta", replace

use "$dir\$Output_data\purge\victimsarchive_muncode_v2.dta",clear
