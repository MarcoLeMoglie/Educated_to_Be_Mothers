version 17.0
clear all
set more off
set varabbrev off

capture log close

global root "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE"
global ivs "$root/original_data/IVS"
global ext2 "$root/codex/external_round2"
global out "$ext2/output"
global logs "$ext2/logs"

log using "$logs/external2_02_beliefs_ivs_spain_portugal.log", replace text

capture program drop post_selected
program define post_selected
    syntax , Handle(name) Outcome(string) Spec(string) Coefs(string)

    foreach coef of local coefs {
        capture scalar b = _b[`coef']
        if _rc == 0 {
            local b = _b[`coef']
            local se = _se[`coef']
            local p = .
            capture local p = 2 * ttail(e(df_r), abs(`b' / `se'))
            if missing(`p') {
                capture local p = 2 * normal(-abs(`b' / `se'))
            }
            post `handle' ("`outcome'") ("`spec'") ("`coef'") (`b') (`se') (`p') (e(N))
        }
    }
end

use "$ivs/Integrated_values_surveys_1981-2022.dta", clear

rename X001 gender
rename S009 country
rename X002 year_birth
rename X003 age
rename S020 year

keep if inlist(country, "ES", "PT")
keep if gender == 2
keep if inrange(year_birth, 1920, 1970)
keep if inlist(year, 1990, 1999, 2008)

gen age_c = floor(age / 10)
egen id_region_country = group(country x048b_n2)

gen treat = .
replace treat = 0 if year_birth <= 1929
replace treat = 1 if inrange(year_birth, 1930, 1938)
replace treat = 2 if inrange(year_birth, 1939, 1970)
tab treat, gen(treat_)

gen spain = country == "ES"
gen spain_treat2 = spain * treat_2
gen spain_treat3 = spain * treat_3

foreach var in C001 D019 D057 D058 D061 D062 F120 {
    replace `var' = . if `var' < 0
}

gen trad_jobs = .
replace trad_jobs = 1 if C001 == 1
replace trad_jobs = 0 if C001 == 2
replace trad_jobs = 0.5 if C001 == 3

gen trad_children_fulfilled = D019
gen trad_housewife = 5 - D057
gen trad_dual_income = D058
gen trad_working_mother = 5 - D061
gen trad_home_children = 5 - D062
gen trad_abortion = 11 - F120

foreach var in trad_jobs trad_children_fulfilled trad_housewife trad_dual_income trad_working_mother trad_home_children trad_abortion {
    egen z_`var' = std(`var')
}

egen traditional_index = rowmean( ///
    z_trad_jobs ///
    z_trad_children_fulfilled ///
    z_trad_housewife ///
    z_trad_dual_income ///
    z_trad_working_mother ///
    z_trad_home_children ///
    z_trad_abortion ///
)

egen family_gender_index = rowmean( ///
    z_trad_jobs ///
    z_trad_children_fulfilled ///
    z_trad_housewife ///
    z_trad_dual_income ///
    z_trad_working_mother ///
    z_trad_home_children ///
)

tempfile beliefs_results
tempname posth
postfile `posth' str24 outcome str32 spec str24 coefname double b se p N using "`beliefs_results'", replace

foreach outcome in traditional_index family_gender_index trad_jobs trad_children_fulfilled trad_housewife trad_dual_income trad_working_mother trad_home_children trad_abortion {
    quietly reghdfe `outcome' treat_2 treat_3 if country == "ES" & year_birth <= 1950, ///
        a(i.id_region_country i.year age_c) vce(cluster year_birth) version(5)
    post_selected, handle(`posth') outcome("`outcome'") spec("spain_only") ///
        coefs("treat_2 treat_3")

    quietly reghdfe `outcome' treat_2 treat_3 spain spain_treat2 spain_treat3 ///
        if inlist(country, "ES", "PT") & year_birth <= 1950, ///
        a(i.id_region_country i.year age_c) vce(cluster year_birth) version(5)
    post_selected, handle(`posth') outcome("`outcome'") spec("pooled_spain_diff") ///
        coefs("treat_2 treat_3 spain_treat2 spain_treat3")
}

postclose `posth'

use "`beliefs_results'", clear
sort outcome spec coefname
save "$out/external2_02_beliefs_results.dta", replace
export delimited using "$out/external2_02_beliefs_results.csv", replace

use "$ivs/Integrated_values_surveys_1981-2022.dta", clear
rename X001 gender
rename S009 country
rename X002 year_birth
rename S020 year
keep if inlist(country, "ES", "PT")
keep if gender == 2
keep if inrange(year_birth, 1920, 1970)
keep if inlist(year, 1990, 1999, 2008)
collapse (count) obs = year_birth, by(country year)
sort country year
save "$out/external2_02_belief_sample_counts.dta", replace
export delimited using "$out/external2_02_belief_sample_counts.csv", replace

log close
