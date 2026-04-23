**************************************************
*	*	*	*	*	*	*	*	*	*	*	*	*
**************************************************
use "$Data\purge\concentrationcamps\distance_camps_centroids.dta", clear
order codprov codmun
sort codprov codmun
keep if dist_camp==0
format %4.0f dist_camp
drop type NEA NATCODE dist_camp ccamp
by codprov: egen camp_prov= sum(conc_camp)
drop camp_stable
save "$Data\purge\concentrationcamps\camps_byprovince.dta", replace

**************************************************
*	*	*	*	*	*	*	*	*	*	*	*	*
**************************************************
use "$Data\census\census_1940.dta", clear
drop pop*

merge 1:1 codprov codmun using "$Data\purge\concentrationcamps\camps_byprovince.dta"
sort codprov codmun
format %15s municip province 

* Replace by 0 if missing in municipalities
replace conc_camp = 0 if missing(conc_camp) & type =="municipality"

* Replace if missing by group
by codprov: egen conccamp_prov = sum(conc_camp)
drop camp_prov

* Rest of province
drop if _merge == 2
drop _merge
by codprov: egen conccamp_norestprov = sum(conc_camp)
gen conc_camp_rest = conccamp_prov-conccamp_norestprov

replace conc_camp = conc_camp_rest if missing(conc_camp) & type== "rest province"
drop conc_camp_rest conccamp_norestprov conccamp_prov
label variable conc_camp "Concentracion camps"
save "$Data\purge\concentrationcamps\camps_clean.dta", replace