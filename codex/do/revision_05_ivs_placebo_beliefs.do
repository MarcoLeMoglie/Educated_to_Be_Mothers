version 17.0
clear all
set more off

capture log close

global root "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE"
global ivs "$root/original_data/IVS/"
global codex "$root/codex"
global out "$codex/output"
global logs "$codex/logs"

log using "$logs/revision_05_ivs_placebo_beliefs.log", replace text

capture program drop post_selected_coefs
program define post_selected_coefs
    syntax , Handle(name) Sample(string) Outcome(string) Spec(string) Coefs(string)

    foreach coef of local coefs {
        capture scalar b = _b[`coef']
        if _rc == 0 {
            local b = _b[`coef']
            local se = _se[`coef']
            local p = .
            capture local p = 2 * ttail(e(df_r), abs(`b' / `se'))
            post `handle' ("`sample'") ("`outcome'") ("`spec'") ("`coef'") (`b') (`se') (`p') (e(N))
        }
    }
end

use "${ivs}Integrated_values_surveys_1981-2022.dta", clear
rename X001 gender
rename S009 country
rename X002 year_birth
rename X003 age
rename S020 year

keep if inlist(country, "ES", "PT")
keep if gender == 2
keep if inrange(year_birth, 1920, 1970)

gen age_c = floor(age / 10)
gen treat = .
replace treat = 0 if year_birth <= 1929
replace treat = 1 if year_birth > 1929 & year_birth < 1939
replace treat = 2 if year_birth >= 1939
tab treat, gen(treat_)

gen nkids = X011
gen kids = X011A
replace kids = 1 if nkids > 0 & nkids != .
replace kids = 0 if nkids == 0

egen id_region = group(x048b_n2)

gen spain = country == "ES"
gen spain_treat2 = spain * treat_2
gen spain_treat3 = spain * treat_3

tempfile ivs_results
tempname posth
postfile `posth' str16 sample str20 outcome str20 spec str24 coefname double b se p N using "`ivs_results'", replace

foreach outcome in kids nkids {
    quietly reghdfe `outcome' treat_2 treat_3 if country == "PT" & year_birth <= 1950, ///
        a(i.id_region##age_c##i.year) cluster(year#i.year_birth) version(5)
    post_selected_coefs, handle(`posth') sample("PT") outcome("`outcome'") spec("pt_only") ///
        coefs("treat_2 treat_3")

    quietly reghdfe `outcome' treat_2 treat_3 spain spain_treat2 spain_treat3 ///
        if inlist(country, "PT", "ES") & year_birth <= 1950, ///
        a(i.id_region##age_c##i.year) cluster(year#i.year_birth) version(5)
    post_selected_coefs, handle(`posth') sample("ESPT") outcome("`outcome'") spec("pooled_diff") ///
        coefs("treat_2 treat_3 spain_treat2 spain_treat3")
}

local beliefvars "C001 D019 D057 D058 D061 D062 F120"
foreach outcome of local beliefvars {
    quietly reghdfe `outcome' treat_2 treat_3 if country == "ES" & year_birth <= 1950, ///
        a(i.id_region##age_c##i.year) cluster(year#i.year_birth) version(5)
    post_selected_coefs, handle(`posth') sample("ES") outcome("`outcome'") spec("belief") ///
        coefs("treat_2 treat_3")
}

postclose `posth'

use "`ivs_results'", clear
sort outcome spec coefname
save "$out/revision_05_ivs_results.dta", replace
export delimited using "$out/revision_05_ivs_results.csv", replace

log close
