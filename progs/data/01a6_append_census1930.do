
* This dofile appends the 4 census datasets with information of pop by age group as well as total population.

*******************************
**# 1. 1930 CENSUS at province level
*******************************
use "$Data\census\census_provinces_byage\1930\census.dta", clear
 
*******************************
* Create age groups 1-8 to be consistent with data from other censuses
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

* Compute total by gender
egen pop_women = rowtotal( popwomen_agegroup1 popwomen_agegroup2 popwomen_agegroup3 popwomen_agegroup4 popwomen_agegroup5 popwomen_agegroup6 popwomen_agegroup7 popwomen_agegroup8)

egen pop_men = rowtotal(popmen_agegroup1 popmen_agegroup2 popmen_agegroup3 popmen_agegroup4 popmen_agegroup5 popmen_agegroup6 popmen_agegroup7 popmen_agegroup8)

*******************************
**# 2. 1930 CENSUS at capital of province level
*******************************
append using "$Data\census\census_provinces_byage\1930\capitalcensus1930_complete.dta"
drop geo_name administrative_unit
sort codprov type
order codprov type province year municip codmun pop_total pop_men pop_w

 
*******************************
**# Clean dataset
*******************************
* Compute the value "rest of province" for each single variable by substracting the value of each capital of province and the municipalities (if any) to the total value of the province

foreach v of varlist pop_total -popwomen_agegroup8 {
    replace `v' = -`v' if type == "full province"
	egen `v'_restprov = total(`v'), by(codprov)
	replace `v' = -`v'_restprov if type == "full province"
	drop `v'_restprov
}

replace municip = "rest province" if type =="full province"
replace type = "rest province" if type =="full province"

replace municip = province if type =="capital"
replace municip = "logroño" if municip == "larioja"
replace type = "municipality" if type =="capital"


label variable pop_agegroup8 "Pop >65"
label variable popmen_agegroup8 "Pop >65"
label variable popwomen_agegroup8 "Pop >65"


* Compute Pop share by age groups
local group ""1" "2" "3" "4" "5" "6" "7" "8" "
 foreach x of local group{ 
bysort codprov: gen popshare_agegroup`x' =pop_agegroup`x'/ pop_total
bysort codprov: gen popsharemen_agegroup`x' =popmen_agegroup`x'/ pop_men
bysort codprov: gen popsharewomen_agegroup`x' =popwomen_agegroup`x'/ pop_women

label variable popshare_agegroup`x' "Pop. share age gr.`x'"

rename pop_agegroup`x' pop_agegroup`x'_1930
rename popshare_agegroup`x' popshare_agegroup`x'_1930 

rename popsharemen_agegroup`x' popsharemen_agegroup`x'_1930 
rename popsharewomen_agegroup`x' popsharewomen_agegroup`x'_1930 

rename popmen_agegroup`x' popmen_agegroup`x'_1930 
rename popwomen_agegroup`x' popwomen_agegroup`x'_1930 
}

sort codmun

* To check that the 3 shares are correct:
*egen total = rowtotal(popshare_agegroup1_1930 popshare_agegroup2_1930 popshare_agegroup3_1930 popshare_agegroup4_1930 popshare_agegroup5_1930 popshare_agegroup6_1930 popshare_agegroup7_1930 popshare_agegroup8_1930)
*sum total 

*egen totalwomen = rowtotal(popsharewomen_agegroup1_1930 popsharewomen_agegroup2_1930 popsharewomen_agegroup3_1930 popsharewomen_agegroup4_1930 popsharewomen_agegroup5_1930 popsharewomen_agegroup6_1930 popsharewomen_agegroup7_1930 popsharewomen_agegroup8_1930)
*sum totalwomen

*egen totalmen = rowtotal(popsharemen_agegroup1_1930 popsharemen_agegroup2_1930 popsharemen_agegroup3_1930 popsharemen_agegroup4_1930 popsharemen_agegroup5_1930 popsharemen_agegroup6_1930 popsharemen_agegroup7_1930 popsharemen_agegroup8_1930)
*sum totalmen


* For simplicity (for now) as we dont have this data for the other datasets at municipality level we delete other age groups info:
*keep codprov codmun type province municip year pop_total pop_agegroup1-pop_agegroup5 popshare_agegroup1-popshare_agegroup5  

replace municip = "oviedo" if municip == "asturias"
replace municip = "santander" if municip == "cantabria"
replace municip = "alicante/alacant" if municip =="alicante"
replace municip = "vitoria-gasteiz" if municip =="alava"
replace municip = "palma" if municip =="baleares"
replace municip = "castello de la plana" if municip =="castellon"
replace municip = "coruña, a" if municip =="a coruña"
replace municip = "donostia/san sebastian" if municip =="guipuzcoa"
replace municip = "pamplona/iruña" if municip =="navarra"
replace municip = "palmas de gran canaria, las" if municip =="laspalmas"
replace municip = "bilbao" if municip =="vizcaya"
replace municip = "girona" if municip =="gerona"


sort codprov

drop year
rename pop_total pop_1930
rename pop_men pop_men1930
rename pop_women pop_women1930

drop if province=="ceuta"|province=="melilla"|province=="lleida"

save "$Data\census\census_1930.dta", replace

use "$Data\census\census_1930.dta", clear
* * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * *
**# PROVINCE LEVEL DATASET
* * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * *
* This dofile appends the 4 census datasets with information of pop by age group as well as total population.

*******************************
**# 1. 1930 CENSUS at province level
*******************************
use "$Data\census\census_provinces_byage\1930\census.dta", clear
 
*******************************
* Create age groups 1-8 to be consistent with data from other censuses
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

* Compute total by gender
egen pop_women = rowtotal( popwomen_agegroup1 popwomen_agegroup2 popwomen_agegroup3 popwomen_agegroup4 popwomen_agegroup5 popwomen_agegroup6 popwomen_agegroup7 popwomen_agegroup8)

egen pop_men = rowtotal(popmen_agegroup1 popmen_agegroup2 popmen_agegroup3 popmen_agegroup4 popmen_agegroup5 popmen_agegroup6 popmen_agegroup7 popmen_agegroup8)

 


label variable pop_agegroup8 "Pop >65"
label variable popmen_agegroup8 "Pop >65"
label variable popwomen_agegroup8 "Pop >65"


* Compute Pop share by age groups
local group ""1" "2" "3" "4" "5" "6" "7" "8" "
 foreach x of local group{ 
bysort codprov: gen popshare_agegroup`x' =pop_agegroup`x'/ pop_total
bysort codprov: gen popsharemen_agegroup`x' =popmen_agegroup`x'/ pop_men
bysort codprov: gen popsharewomen_agegroup`x' =popwomen_agegroup`x'/ pop_women

label variable popshare_agegroup`x' "Pop. share age gr.`x'"

rename pop_agegroup`x' pop_agegroup`x'_1930
rename popshare_agegroup`x' popshare_agegroup`x'_1930 

rename popsharemen_agegroup`x' popsharemen_agegroup`x'_1930 
rename popsharewomen_agegroup`x' popsharewomen_agegroup`x'_1930 

rename popmen_agegroup`x' popmen_agegroup`x'_1930 
rename popwomen_agegroup`x' popwomen_agegroup`x'_1930 
}
 

sort codprov

drop year
rename pop_total pop_1930
rename pop_men pop_men1930
rename pop_women pop_women1930

drop if province=="ceuta"|province=="melilla"|province=="lleida"
drop type
save "$Data\census\census_1930_PROVINCElevel.dta", replace

use "$Data\census\census_1930_PROVINCElevel.dta", clear