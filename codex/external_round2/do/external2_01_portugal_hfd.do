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

log using "$logs/external2_01_portugal_hfd.log", replace text

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

use "$gen/portugal_spain_hfd_completed_fertility.dta", clear

rename cohort year_birth
gen treat = .
replace treat = 0 if year_birth <= 1929
replace treat = 1 if inrange(year_birth, 1930, 1938)
replace treat = 2 if inrange(year_birth, 1939, 1970)
tab treat, gen(treat_)

gen cohort_c = year_birth - 1930
gen cohort_c2 = cohort_c^2
gen spain_treat2 = spain * treat_2
gen spain_treat3 = spain * treat_3
gen spain_cohort = spain * cohort_c
gen spain_cohort2 = spain * cohort_c2

keep if inrange(year_birth, 1920, 1970)

tempfile results
tempname posth
postfile `posth' str20 outcome str32 spec str24 coefname double b se p N using "`results'", replace

quietly reg completed_cohort_fertility treat_2 treat_3 ///
    if country == "Portugal" & year_birth <= 1950, vce(robust)
post_selected, handle(`posth') outcome("cfr") spec("pt_only_no_trend") ///
    coefs("treat_2 treat_3")

quietly reg completed_cohort_fertility treat_2 treat_3 c.cohort_c ///
    if country == "Portugal" & year_birth <= 1950, vce(robust)
post_selected, handle(`posth') outcome("cfr") spec("pt_only_linear") ///
    coefs("treat_2 treat_3 cohort_c")

quietly reg completed_cohort_fertility treat_2 treat_3 spain spain_treat2 spain_treat3 ///
    if year_birth <= 1950, vce(robust)
post_selected, handle(`posth') outcome("cfr") spec("pooled_no_trend") ///
    coefs("treat_2 treat_3 spain_treat2 spain_treat3")

quietly reg completed_cohort_fertility treat_2 treat_3 spain spain_treat2 spain_treat3 ///
    c.cohort_c spain_cohort if year_birth <= 1950, vce(robust)
post_selected, handle(`posth') outcome("cfr") spec("pooled_linear_country") ///
    coefs("treat_2 treat_3 spain_treat2 spain_treat3 cohort_c spain_cohort")

quietly reg completed_cohort_fertility treat_2 treat_3 spain spain_treat2 spain_treat3 ///
    c.cohort_c c.cohort_c2 spain_cohort spain_cohort2 if year_birth <= 1950, vce(robust)
post_selected, handle(`posth') outcome("cfr") spec("pooled_quadratic_country") ///
    coefs("treat_2 treat_3 spain_treat2 spain_treat3 cohort_c cohort_c2 spain_cohort spain_cohort2")

postclose `posth'

use "`results'", clear
sort spec coefname
save "$out/external2_01_portugal_hfd_results.dta", replace
export delimited using "$out/external2_01_portugal_hfd_results.csv", replace

use "$gen/portugal_spain_hfd_completed_fertility.dta", clear
rename cohort year_birth
keep if inrange(year_birth, 1920, 1970)
gen treat = .
replace treat = 0 if year_birth <= 1929
replace treat = 1 if inrange(year_birth, 1930, 1938)
replace treat = 2 if inrange(year_birth, 1939, 1970)
collapse (mean) completed_cohort_fertility, by(country year_birth treat)
sort country year_birth
save "$out/external2_01_portugal_hfd_series.dta", replace
export delimited using "$out/external2_01_portugal_hfd_series.csv", replace

log close
