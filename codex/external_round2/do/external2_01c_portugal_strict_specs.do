version 17.0
clear all
set more off
set varabbrev off

capture log close

global root "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE"
global ext2 "$root/codex/external_round2"
global gen "$ext2/generated"
global out "$ext2/output"
global logs "$ext2/logs"
global ivs "$root/original_data/IVS"

log using "$logs/external2_01c_portugal_strict_specs.log", replace text

capture program drop post_coef
program define post_coef
    syntax , Handle(name) Source(string) Outcome(string) Spec(string) Coef(string)

    capture scalar b = _b[`coef']
    if _rc == 0 {
        local b = _b[`coef']
        local se = _se[`coef']
        local p = .
        capture local p = 2 * ttail(e(df_r), abs(`b' / `se'))
        if missing(`p') {
            capture local p = 2 * normal(-abs(`b' / `se'))
        }
        post `handle' ("`source'") ("`outcome'") ("`spec'") ("`coef'") (`b') (`se') (`p') (e(N)) (0)
    }
    else {
        post `handle' ("`source'") ("`outcome'") ("`spec'") ("`coef'") (.) (.) (.) (.) (1)
    }
end

tempfile strict_results
tempname posth
postfile `posth' str8 source str12 outcome str32 spec str20 coefname double b se p N byte omitted using "`strict_results'", replace

* HFD aggregate country-cohort placebo
use "$gen/portugal_spain_hfd_completed_fertility.dta", clear
rename cohort year_birth
keep if inrange(year_birth, 1920, 1950)

gen treat = .
replace treat = 0 if year_birth <= 1929
replace treat = 1 if inrange(year_birth, 1930, 1938)
replace treat = 2 if inrange(year_birth, 1939, 1950)
tab treat, gen(treat_)

gen cohort_c = year_birth - 1930
gen cohort_c2 = cohort_c^2
gen spain_treat2 = spain * treat_2
gen spain_treat3 = spain * treat_3
gen spain_cohort = spain * cohort_c
gen spain_cohort2 = spain * cohort_c2

quietly reg completed_cohort_fertility treat_2 treat_3 spain spain_treat2 spain_treat3, vce(robust)
post_coef, handle(`posth') source("HFD") outcome("cfr") spec("baseline") coef("spain_treat2")
post_coef, handle(`posth') source("HFD") outcome("cfr") spec("baseline") coef("spain_treat3")

quietly reg completed_cohort_fertility spain spain_treat2 spain_treat3 i.year_birth, vce(robust)
post_coef, handle(`posth') source("HFD") outcome("cfr") spec("cohort_FE") coef("spain_treat2")
post_coef, handle(`posth') source("HFD") outcome("cfr") spec("cohort_FE") coef("spain_treat3")

quietly reg completed_cohort_fertility treat_2 treat_3 spain spain_treat2 spain_treat3 ///
    c.cohort_c spain_cohort, vce(robust)
post_coef, handle(`posth') source("HFD") outcome("cfr") spec("lin_country_trend") coef("spain_treat2")
post_coef, handle(`posth') source("HFD") outcome("cfr") spec("lin_country_trend") coef("spain_treat3")

quietly reg completed_cohort_fertility treat_2 treat_3 spain spain_treat2 spain_treat3 ///
    c.cohort_c c.cohort_c2 spain_cohort spain_cohort2, vce(robust)
post_coef, handle(`posth') source("HFD") outcome("cfr") spec("quad_country_trend") coef("spain_treat2")
post_coef, handle(`posth') source("HFD") outcome("cfr") spec("quad_country_trend") coef("spain_treat3")

quietly reg completed_cohort_fertility treat_2 treat_3 spain spain_treat2 spain_treat3 ///
    i.year_birth##i.spain, vce(robust)
post_coef, handle(`posth') source("HFD") outcome("cfr") spec("spainXcohort_FE") coef("spain_treat2")
post_coef, handle(`posth') source("HFD") outcome("cfr") spec("spainXcohort_FE") coef("spain_treat3")

* IVS micro placebo with subnational FE
use "$ivs/Integrated_values_surveys_1981-2022.dta", clear
rename X001 gender
rename S009 country
rename X002 year_birth
rename X003 age
rename S020 year

keep if inlist(country, "ES", "PT")
keep if gender == 2
keep if inrange(year_birth, 1920, 1950)

gen age_c = floor(age / 10)
egen id_region_country = group(country x048b_n2)
egen id_nuts2 = group(x048b_n2)

gen treat = .
replace treat = 0 if year_birth <= 1929
replace treat = 1 if inrange(year_birth, 1930, 1938)
replace treat = 2 if inrange(year_birth, 1939, 1950)
tab treat, gen(treat_)

gen nkids = X011
gen kids = X011A
replace kids = 1 if nkids > 0 & nkids != .
replace kids = 0 if nkids == 0

gen spain = country == "ES"
gen spain_treat2 = spain * treat_2
gen spain_treat3 = spain * treat_3
gen cohort_c = year_birth - 1930
gen cohort_c2 = cohort_c^2
gen spain_cohort = spain * cohort_c
gen spain_cohort2 = spain * cohort_c2
egen clust_year_birth = group(year year_birth)

foreach outcome in kids nkids {
    quietly reghdfe `outcome' treat_2 treat_3 spain spain_treat2 spain_treat3, ///
        a(i.year i.age_c) vce(cluster year_birth) version(5)
    post_coef, handle(`posth') source("IVS") outcome("`outcome'") spec("baseline") coef("spain_treat2")
    post_coef, handle(`posth') source("IVS") outcome("`outcome'") spec("baseline") coef("spain_treat3")

    quietly reghdfe `outcome' treat_2 treat_3 ///
        if country == "PT" & year_birth <= 1950, ///
        a(i.id_nuts2##i.age_c##i.year) vce(cluster clust_year_birth) version(5)
    post_coef, handle(`posth') source("IVS") outcome("`outcome'") spec("pt_only_nuts2_age_year_FE") coef("treat_2")
    post_coef, handle(`posth') source("IVS") outcome("`outcome'") spec("pt_only_nuts2_age_year_FE") coef("treat_3")

    quietly reghdfe `outcome' treat_2 treat_3 spain spain_treat2 spain_treat3, ///
        a(i.id_region_country i.year i.age_c) vce(cluster year_birth) version(5)
    post_coef, handle(`posth') source("IVS") outcome("`outcome'") spec("region_FE") coef("spain_treat2")
    post_coef, handle(`posth') source("IVS") outcome("`outcome'") spec("region_FE") coef("spain_treat3")

    quietly reghdfe `outcome' treat_2 treat_3 spain spain_treat2 spain_treat3 ///
        if inlist(country, "PT", "ES") & year_birth <= 1950, ///
        a(i.id_nuts2##i.age_c##i.year) vce(cluster clust_year_birth) version(5)
    post_coef, handle(`posth') source("IVS") outcome("`outcome'") spec("nuts2_age_year_FE") coef("spain_treat2")
    post_coef, handle(`posth') source("IVS") outcome("`outcome'") spec("nuts2_age_year_FE") coef("spain_treat3")

    quietly reghdfe `outcome' spain spain_treat2 spain_treat3, ///
        a(i.id_region_country i.year i.age_c i.year_birth) vce(cluster year_birth) version(5)
    post_coef, handle(`posth') source("IVS") outcome("`outcome'") spec("region_FE+cohort_FE") coef("spain_treat2")
    post_coef, handle(`posth') source("IVS") outcome("`outcome'") spec("region_FE+cohort_FE") coef("spain_treat3")

    quietly reghdfe `outcome' treat_2 treat_3 spain spain_treat2 spain_treat3 ///
        c.cohort_c spain_cohort, a(i.id_region_country i.year i.age_c) ///
        vce(cluster year_birth) version(5)
    post_coef, handle(`posth') source("IVS") outcome("`outcome'") spec("region_FE+lin_trend") coef("spain_treat2")
    post_coef, handle(`posth') source("IVS") outcome("`outcome'") spec("region_FE+lin_trend") coef("spain_treat3")

    quietly reghdfe `outcome' treat_2 treat_3 spain spain_treat2 spain_treat3 ///
        c.cohort_c c.cohort_c2 spain_cohort spain_cohort2, a(i.id_region_country i.year i.age_c) ///
        vce(cluster year_birth) version(5)
    post_coef, handle(`posth') source("IVS") outcome("`outcome'") spec("region_FE+quad_trend") coef("spain_treat2")
    post_coef, handle(`posth') source("IVS") outcome("`outcome'") spec("region_FE+quad_trend") coef("spain_treat3")

    quietly regress `outcome' treat_2 treat_3 spain spain_treat2 spain_treat3 ///
        i.year_birth##i.spain i.year i.age_c i.id_region_country, vce(cluster year_birth)
    post_coef, handle(`posth') source("IVS") outcome("`outcome'") spec("spainXcohort_FE") coef("spain_treat2")
    post_coef, handle(`posth') source("IVS") outcome("`outcome'") spec("spainXcohort_FE") coef("spain_treat3")
}

postclose `posth'

use "`strict_results'", clear
sort source outcome coefname spec
save "$out/external2_01c_portugal_strict_specs.dta", replace
export delimited using "$out/external2_01c_portugal_strict_specs.csv", replace

log close
