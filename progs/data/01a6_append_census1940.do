* This dofile appends the 4 census datasets with information of pop by age group as well as total population.

*******************************
**# 1. 1940 CENSUS at province level (total,men and women)
*******************************
use "$Data\census\census_provinces_byage\1940\census.dta", clear

*******************************
**# 2. 1940 CENSUS at capital of province level
*******************************
append using "$Data\census\census_provinces_byage\1940\capitalcensus1940all_clean.dta"

sort codprov type
order codprov type province year pop_total
/* IMPORTANT: Do not do steps 3 4 to have the dataset for capital and rest of province only (to be consistent with the census of 1930)
*******************************
**# 3. 1940 CENSUS at municipality (> 20.000 inhab) level
*******************************
append using  "$Data\census\censo_1940_municipios_fotos\municip_census1940_clean.dta"
*/
*******************************
**# 4. 1940 CENSUS at municipality (> 20.000 inhab) level for Catalunya only
*******************************
append using "$Data\census\catalunya\municip_catalunya_clean.dta"
order codprov codmun type province municip
sort province
* keep only capital *(to be consistent with the census of 1930)
drop if codprov ==8 & type =="municipality" & municip!= "barcelona"
drop if codprov ==43 & type =="municipality" & municip!= "tarragona"

*******************************
**# Clean dataset
*******************************
* Compute the value "rest of province" for each single variable by substracting the value of each capital of province and the municipalities (if any) to the total value of the province
foreach v of varlist pop_total -popwomen {
    replace `v' = -`v' if type == "full province"
	egen `v'_restprov = total(`v'), by(codprov)
	replace `v' = -`v'_restprov if type == "full province"
	drop `v'_restprov
}
replace municip = "rest province" if type =="full province"
replace municip = province if type =="capital"
replace municip = "logroño" if municip == "larioja"

*******************************
**# Create age groups 1-8 to be consistent with data from other censuses
*******************************
replace pop_agegroup11= 0 if missing(pop_agegroup11)
replace pop_agegroup8 = pop_agegroup8+pop_agegroup9+pop_agegroup10+pop_agegroup11
drop pop_agegroup9 pop_agegroup10 pop_agegroup11

foreach x in women men {
replace pop`x'_agegroup8= 0 if missing(pop`x'_agegroup8)
replace pop`x'_agegroup9= 0 if missing(pop`x'_agegroup9)
replace pop`x'_agegroup10= 0 if missing(pop`x'_agegroup10)
replace pop`x'_agegroup11= 0 if missing(pop`x'_agegroup11)
replace pop`x'_agegroup8 = pop`x'_agegroup8+pop`x'_agegroup9+pop`x'_agegroup10+pop`x'_agegroup11
drop pop`x'_agegroup9 pop`x'_agegroup10 pop`x'_agegroup11
}


* Compute Pop share by age groups
local group ""1" "2" "3" "4" "5" "6" "7" "8""
 foreach x of local group{ 
bysort codprov: gen popshare_agegroup`x' =pop_agegroup`x'/ pop_total
bysort codprov: gen popsharemen_agegroup`x' =popmen_agegroup`x'/ popmen
bysort codprov: gen popsharewomen_agegroup`x' =popwomen_agegroup`x'/ popwomen

label variable popshare_agegroup`x' "Pop. share age gr.`x'"
}

sort codmun

order codprov codmun type province municip year pop_total popmen popwomen codauto codauto popshare_agegroup*
egen total = rowtotal(popshare_agegroup1-popshare_agegroup8)

* For simplicity (for now) as we dont have this data for the other datasets at municipality level we delete other age groups info:
*keep codprov codmun type province municip year pop_total  pop_agegroup1-pop_agegroup5 popshare_agegroup1-popshare_agegroup5  popshare_agegroup1-popshare_agegroup5  popsharemen_agegroup1-popsharemen_agegroup5   popsharewomen_agegroup1-popsharewomen_agegroup5 pop_agegroup1-pop_agegroup5 popmen_agegroup1 popmen_agegroup2 popmen_agegroup3 popmen_agegroup4 popmen_agegroup5 popwomen_agegroup1 popwomen_agegroup2 popwomen_agegroup3 popwomen_agegroup4 popwomen_agegroup5

replace municip = "gerona" if municip == "girona"
replace province = "gerona" if province == "girona"
replace municip = "oviedo" if municip == "asturias"
replace municip = "santander" if municip == "cantabria"

rename pop_total pop_1940
rename popmen popmen_1940
rename popwomen popwomen_1940

local group ""1" "2" "3" "4" "5" "6" "7" "8""
 foreach x of local group{ 
rename pop_agegroup`x' pop_agegroup`x'_1940
rename popshare_agegroup`x' popshare_agegroup`x'_1940 

rename popsharemen_agegroup`x' popsharemen_agegroup`x'_1940 

rename popsharewomen_agegroup`x' popsharewomen_agegroup`x'_1940 
rename popmen_agegroup`x' popmen_agegroup`x'_1940 
rename popwomen_agegroup`x' popwomen_agegroup`x'_1940 
}

label variable pop_agegroup8 "Pop >65"
label variable popmen_agegroup8 "Pop >65"
label variable popwomen_agegroup8 "Pop >65"

duplicates drop codprov municip type year, force //REUS duplicated

drop year 
 
 
drop if province == "ceuta"|province =="melilla"
sort codprov

* variable fixed over time (treatment)

/*# Compute the value "rest of province" for each single variable by substracting the value of each capital of province and the municipalities (if any) to the total value of the province
foreach v of varlist pop_1940 pop_agegroup2_1940 popshare_ageg2_treated {
    replace `v' = -`v' if type == "full province" & `v' !=.
	egen `v'_restprov = total(`v'), by(codprov)
	replace `v' = -`v'_restprov if type == "full province" & `v' !=.
	drop `v'_restprov
}
*/
duplicates drop codprov codmun, force //santa cruz de tenerife
replace municip = province if type =="full province"
replace type = "rest province" if type =="full province"
replace type = "municipality" if  type =="capital"
replace municip = "rest province" if type =="rest province"

replace municip = "alicante/alacant" if municip =="alicante"
replace municip = "sagunto/sagunt" if municip =="sagunto"
replace municip = "girona" if municip =="gerona"
replace municip = "santiago de compostela" if municip =="santiago"
replace municip = "peñarroya-pueblonuevo" if municip =="penarroya pueblonuevo"
replace municip = "pamplona/iruña" if municip =="navarra"
replace municip = "barakaldo" if municip =="baracaldo"
replace municip = "puerto de santa maria, el" if municip =="puerto santa maria"
replace municip = "vitoria-gasteiz" if municip =="alava"
replace municip = "santa cruz de tenerife" if municip =="santa cruz tenerife"
replace municip = "cangas del narcea" if municip =="cangas de narcea"
replace municip = "castello de la plana" if municip =="castellon"
replace municip = "palmas de gran canaria, las" if municip =="laspalmas"
replace municip = "linea de la concepcion, la" if municip =="la linea"
replace municip = "vila-real" if municip =="villarreal"
replace municip = "bilbao" if municip =="vizcaya"
replace municip = "alcoy/alcoi" if municip =="alcoy"
replace municip = "donostia/san sebastian" if municip =="guipuzcoa"
replace municip = "san cristobal de la laguna" if municip =="la laguna"
replace municip = "logroño" if municip =="logroño"
replace municip = "ferrol" if municip =="el ferrol del caudillo"
replace municip = "elche/elx" if municip =="elche"
replace municip = "valdepeñas" if municip =="valdepenas"
replace municip = "palma" if municip =="baleares"
replace municip = "alzira" if municip =="alcira"
replace municip = "valdes" if municip =="valdés"
replace municip = "coruña, a" if municip =="a coruña"

replace province = "vizcaya" if province== "bizkaia"
replace province = "las palmas" if province== "laspalmas"
drop codauto total
save "$Data\census\census_1940.dta", replace

****************************************
**# Population 1940 in panel data form
****************************************
use "$Data\census\census_1940.dta",clear
tab province

drop pop_age* popshare*
gen year = 1940

save "$Data\census\pop_1940_temp.dta", replace

* * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * *
**# PROVINCE LEVEL DATASET
* * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * *

* This dofile appends the 4 census datasets with information of pop by age group as well as total population.

*******************************
**# 1. 1940 CENSUS at province level (total,men and women)
*******************************
use "$Data\census\census_provinces_byage\1940\census.dta", clear

*******************************
**# Create age groups 1-8 to be consistent with data from other censuses
*******************************
replace pop_agegroup11= 0 if missing(pop_agegroup11)
replace pop_agegroup8 = pop_agegroup8+pop_agegroup9+pop_agegroup10+pop_agegroup11
drop pop_agegroup9 pop_agegroup10 pop_agegroup11

foreach x in women men {
replace pop`x'_agegroup8= 0 if missing(pop`x'_agegroup8)
replace pop`x'_agegroup9= 0 if missing(pop`x'_agegroup9)
replace pop`x'_agegroup10= 0 if missing(pop`x'_agegroup10)
replace pop`x'_agegroup11= 0 if missing(pop`x'_agegroup11)
replace pop`x'_agegroup8 = pop`x'_agegroup8+pop`x'_agegroup9+pop`x'_agegroup10+pop`x'_agegroup11
drop pop`x'_agegroup9 pop`x'_agegroup10 pop`x'_agegroup11
}


* Compute Pop share by age groups
local group ""1" "2" "3" "4" "5" "6" "7" "8""
 foreach x of local group{ 
bysort codprov: gen popshare_agegroup`x' =pop_agegroup`x'/ pop_total
bysort codprov: gen popsharemen_agegroup`x' =popmen_agegroup`x'/ popmen
bysort codprov: gen popsharewomen_agegroup`x' =popwomen_agegroup`x'/ popwomen

label variable popshare_agegroup`x' "Pop. share age gr.`x'"
}

 
order codprov     province   year pop_total popmen popwomen popshare_agegroup*
egen total = rowtotal(popshare_agegroup1-popshare_agegroup8)

* For simplicity (for now) as we dont have this data for the other datasets at municipality level we delete other age groups info:
*keep codprov codmun type province municip year pop_total  pop_agegroup1-pop_agegroup5 popshare_agegroup1-popshare_agegroup5  popshare_agegroup1-popshare_agegroup5  popsharemen_agegroup1-popsharemen_agegroup5   popsharewomen_agegroup1-popsharewomen_agegroup5 pop_agegroup1-pop_agegroup5 popmen_agegroup1 popmen_agegroup2 popmen_agegroup3 popmen_agegroup4 popmen_agegroup5 popwomen_agegroup1 popwomen_agegroup2 popwomen_agegroup3 popwomen_agegroup4 popwomen_agegroup5

replace province = "gerona" if province == "girona"

rename pop_total pop_1940
rename popmen popmen_1940
rename popwomen popwomen_1940

local group ""1" "2" "3" "4" "5" "6" "7" "8""
 foreach x of local group{ 
rename pop_agegroup`x' pop_agegroup`x'_1940
rename popshare_agegroup`x' popshare_agegroup`x'_1940 

rename popsharemen_agegroup`x' popsharemen_agegroup`x'_1940 

rename popsharewomen_agegroup`x' popsharewomen_agegroup`x'_1940 
rename popmen_agegroup`x' popmen_agegroup`x'_1940 
rename popwomen_agegroup`x' popwomen_agegroup`x'_1940 
}

label variable pop_agegroup8 "Pop >65"
label variable popmen_agegroup8 "Pop >65"
label variable popwomen_agegroup8 "Pop >65"

*duplicates drop codprov  year, force //REUS duplicated

drop year 
 
drop if province == "ceuta"|province =="melilla"
sort codprov

* variable fixed over time (treatment)


replace province = "vizcaya" if province== "bizkaia"
replace province = "las palmas" if province== "laspalmas"
drop   total type
save "$Data\census\census_1940_PROVINCElevel.dta", replace