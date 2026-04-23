 ***************************************
 * This dofile merges the baseline dataset that contains municipality and province 
 * codes with the dataset on the number of victims by municipality (APROX. 30MIN)
 *************************************** before baseline
use "$Data\purge\2019.dta", clear 
gen id2019= _n
*rename prov19 province
*rename mun19 municip
replace province = upper(province)
replace municip = upper(municip)

replace municip = stritrim(municip) // with all consecutive, internal blanks collapsed to one blank
replace province = stritrim(province) // with all consecutive, internal blanks collapsed to one blank
replace municip = strtrim(municip) // leading and trailing blanks removed.
replace province = stritrim(province) // with all consecutive, internal blanks collapsed to one blank
replace province = strtrim(province) // leading and trailing blanks removed.
*replace municip = subinstr(municip, " ", "", .) //supress the blank spaces

replace municip = subinstr(municip, "Á", "A", .) //supress the accents
replace municip = subinstr(municip, "á", "A", .) //supress the accents
replace municip = subinstr(municip, "à", "A", .) //supress the accents
replace province = subinstr(province, "á", "A", .) //supress the accents
replace province = subinstr(province, "Á", "A", .) //supress the accents
replace municip = subinstr(municip, "É", "E", .) //supress the accents
replace municip = subinstr(municip,"é", "E", .) //supress the accents
replace municip = subinstr(municip, "è", "E", .) //supress the accents
replace province = subinstr(province,"é", "E", .) //supress the accents
replace municip = subinstr(municip, "Í", "I", .) //supress the accents
replace province = subinstr(province, "Í", "I", .) //supress the accents
replace province = subinstr(province, "í", "I", .) //supress the accents
replace municip = subinstr(municip, "ï", "I", .) //supress the accents
replace municip = subinstr(municip, "í", "I", .) //supress the accents
replace municip = subinstr(municip, "ì", "I", .) //supress the accents
replace municip = subinstr(municip, "Ó", "O", .) //supress the accents
replace province = subinstr(province,"ó", "O", .) //supress the accents
replace municip = subinstr(municip,"ó", "O", .) //supress the accents
replace municip = subinstr(municip, "ò", "O", .) //supress the accents
replace municip = subinstr(municip, "Ú", "U", .) //supress the accents
replace province = subinstr(province, "Ú", "U", .) //supress the accents
replace province = subinstr(province, "ú", "U", .) //supress the accents
replace municip = subinstr(municip, "ú", "U", .) //supress the accents
replace municip = subinstr(municip, "ù", "U", .) //supress the accents
replace municip = subinstr(municip, "ñ", "Ñ", .) //eñe
replace municip = subinstr(municip, "ç", "C", .) //
replace province = subinstr(province, "ñ", "Ñ", .) //eñe

replace province ="ALICANTE" if strpos(province , "ALICANT") > 0
replace province ="VALENCIA" if strpos(province , "VALENCIA") > 0
replace province ="CASTELLON"  if strpos(province , "CASTELLON") > 0

reclink2 municip province using "$dir\$Output_data\purge\victims_mun.dta", idmaster(id2019) idusing(idvictim) gen(match) minscore(0.9)
//7218 matched(exact 5603) unmatched 913
format %20s municip
format %10s province
format %20s Umunicip
format %10s Uprovince
order codprov codmun match _merge
sort match codprov codmun 
drop Umunicip Uprovince

keep codprov codmun victim_mun victim_male
replace victim_mun =0 if victim_mun ==.
replace victim_male =0 if victim_male ==.
sort codprov codmun
// there are duplicates, so let's sum the victims by municipalities duplicates and drop them
by  codprov codmun: egen victims =sum(victim_mun)
by  codprov codmun: egen victims_male =sum(victim_male)
drop victim_mun
drop victim_male
duplicates drop codprov codmun, force
drop if codprov ==35 | codprov ==38 // Canary Islands
drop if codprov ==51 | codprov ==52 // Ceuta, Melilla

save  "$dir\$Output_data\purge\victims_muncode.dta", replace
use  "$dir\$Output_data\purge\victims_muncode.dta", clear

 ***************************************
 *By archive. Number of victims by municipality and archive
 ***************************************
 use "$Data\purge\2019.dta", clear 

* use "$Output_data\electoral\2_post_dictatorship\congress\baseline.dta", clear
*rename prov19 province
*rename mun19 municip
gen id2019= _n
replace province = upper(province)
replace municip = upper(municip)

replace municip = stritrim(municip) // with all consecutive, internal blanks collapsed to one blank
replace province = stritrim(province) // with all consecutive, internal blanks collapsed to one blank
replace municip = strtrim(municip) // leading and trailing blanks removed.
replace province = stritrim(province) // with all consecutive, internal blanks collapsed to one blank
replace province = strtrim(province) // leading and trailing blanks removed.
*replace municip = subinstr(municip, " ", "", .) //supress the blank spaces
replace municip = subinstr(municip, "Á", "A", .) //supress the accents
replace municip = subinstr(municip, "á", "A", .) //supress the accents
replace municip = subinstr(municip, "à", "A", .) //supress the accents
replace province = subinstr(province, "á", "A", .) //supress the accents
replace province = subinstr(province, "Á", "A", .) //supress the accents
replace municip = subinstr(municip, "É", "E", .) //supress the accents
replace municip = subinstr(municip,"é", "E", .) //supress the accents
replace municip = subinstr(municip, "è", "E", .) //supress the accents
replace province = subinstr(province,"é", "E", .) //supress the accents
replace municip = subinstr(municip, "Í", "I", .) //supress the accents
replace province = subinstr(province, "Í", "I", .) //supress the accents
replace province = subinstr(province, "í", "I", .) //supress the accents
replace municip = subinstr(municip, "ï", "I", .) //supress the accents
replace municip = subinstr(municip, "í", "I", .) //supress the accents
replace municip = subinstr(municip, "ì", "I", .) //supress the accents
replace municip = subinstr(municip, "Ó", "O", .) //supress the accents
replace province = subinstr(province,"ó", "O", .) //supress the accents
replace municip = subinstr(municip,"ó", "O", .) //supress the accents
replace municip = subinstr(municip, "ò", "O", .) //supress the accents
replace municip = subinstr(municip, "Ú", "U", .) //supress the accents
replace province = subinstr(province, "Ú", "U", .) //supress the accents
replace province = subinstr(province, "ú", "U", .) //supress the accents
replace municip = subinstr(municip, "ú", "U", .) //supress the accents
replace municip = subinstr(municip, "ù", "U", .) //supress the accents
replace municip = subinstr(municip, "ñ", "Ñ", .) //eñe
replace municip = subinstr(municip, "ç", "C", .) //
replace province = subinstr(province, "ñ", "Ñ", .) //eñe

replace province ="ALICANTE" if strpos(province , "ALICANT") > 0
replace province ="VALENCIA" if strpos(province , "VALENCIA") > 0
replace province ="CASTELLON"  if strpos(province , "CASTELLON") > 0

reclink2 municip province using "$dir\$Output_data\purge\victims_archive.dta",  ///
idmaster(id2019) idusing(idvictim1) gen(match) minscore(0.9)
//7215 matched(exact 5602) unmatched 916
keep codprov codmun province municip year_1 year_2 profession archive victim_archive victim_mun
format %20s municip
format %10s province

replace victim_mun =0 if victim_mun ==.
replace victim_archive =0 if victim_archive ==.
drop if codprov ==35 | codprov ==38 // Canary Islands
drop if codprov ==51 | codprov ==52 // Ceuta, Melilla

save  "$dir\$Output_data\purge\victimsarchive_muncode.dta", replace

use "$dir\$Output_data\purge\victimsarchive_muncode.dta", clear
sort codprov codmun archive
// there are duplicates, so let's sum the victims by municipalities duplicates and drop them

by  codprov codmun archive: egen victims_arch =sum(victim_archive)
drop victim_mun
drop victim_archive
duplicates drop codprov codmun victims_arch, force
tab archive
gen arch_agm = victims_arch if  strpos(archive , "Archivo General de la Ad") > 0
replace arch_agm =0 if arch_agm==.

gen arch_ahn = victims_arch if  strpos(archive , "Archivo Histórico Nacional") > 0
replace arch_ahn =0 if arch_ahn==.

gen arch_rep= victims_arch if  strpos(archive , "Asociación de Estudios sobre la Rep") > 0
replace arch_rep =0 if arch_rep==.

gen arch_cdm = victims_arch if  strpos(archive , "Centro Documental") > 0
replace arch_cdm =0 if arch_cdm==.

save "$dir\$Output_data\purge\victimsarchive_muncode_v2.dta", replace
* sum for each municipality so that there is a unique obs for each mun
use "$dir\$Output_data\purge\victimsarchive_muncode_v2.dta",clear
sort codprov codmun
by codprov codmun: egen archive_agm=sum(arch_agm)
by codprov codmun: egen archive_ahn=sum(arch_ahn)
by codprov codmun: egen archive_rep=sum(arch_rep)
by codprov codmun: egen archive_cdm=sum(arch_cdm)

duplicates drop codprov codmun, force
drop if codprov ==35 | codprov ==38 // Canary Islands
drop if codprov ==51 | codprov ==52 // Ceuta, Melilla
drop profession archive year_1 year_2 arch_agm arch_ahn arch_rep arch_cdm
save "$dir\$Output_data\purge\victimsarchive_muncode_v2.dta", replace

use "$dir\$Output_data\purge\victimsarchive_muncode_v2.dta",clear
