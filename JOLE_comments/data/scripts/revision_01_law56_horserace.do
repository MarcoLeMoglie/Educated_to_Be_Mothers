version 17.0
clear all
set more off

capture log close

global root "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE"
global cis "$root/original_data/CIS/_data_cis/"
global codex "$root/codex"
global out "$codex/output"
global gen "$codex/generated"
global logs "$codex/logs"

log using "$logs/revision_01_law56_horserace.log", replace text

capture program drop post_selected_coefs
program define post_selected_coefs
    syntax , Handle(name) Sample(string) Outcome(string) Spec(string) Coefs(string)

    foreach coef of local coefs {
        capture scalar b = _b[`coef']
        if _rc == 0 {
            scalar se = _se[`coef']
            capture scalar p = 2 * ttail(e(df_r), abs(b / se))
            if _rc != 0 {
                scalar p = .
            }
            post `handle' ("`sample'") ("`outcome'") ("`spec'") ("`coef'") (b) (se) (p) (e(N))
        }
    }
end

capture program drop make_exposure_share
program define make_exposure_share
    syntax , Start(integer) End(integer) Threshold(integer) Generate(name)

    gen `generate' = .
    forvalues cohort = 1920/1970 {
        local exposed = 0
        forvalues age = `start'/`end' {
            local calyear = `cohort' + `age'
            if `calyear' >= `threshold' {
                local exposed = `exposed' + 1
            }
        }
        replace `generate' = `exposed' / (`end' - `start' + 1) if year_birth == `cohort'
    }
end

display as text "Building Law 56 cohort exposure file"
clear
set obs 51
gen year_birth = 1919 + _n

make_exposure_share, start(18) end(30) threshold(1962) generate(law56_share_18_30)
make_exposure_share, start(20) end(35) threshold(1962) generate(law56_share_20_35)
make_exposure_share, start(25) end(35) threshold(1962) generate(law56_share_25_35)
make_exposure_share, start(25) end(35) threshold(1973) generate(crisis73_share_25_35)

gen law56_age_in_1961 = 1961 - year_birth
gen law56_post1961_under25 = law56_age_in_1961 < 25 if law56_age_in_1961 < .

label var law56_share_18_30 "Share of ages 18-30 lived after 1961 reform"
label var law56_share_20_35 "Share of ages 20-35 lived after 1961 reform"
label var law56_share_25_35 "Share of ages 25-35 lived after 1961 reform"
label var crisis73_share_25_35 "Share of ages 25-35 lived after 1973"
label var law56_age_in_1961 "Age in 1961"
label var law56_post1961_under25 "Under age 25 in 1961"

save "$gen/law56_cohort_exposure.dta", replace
export delimited using "$out/law56_cohort_exposure.csv", replace

display as text "Loading CIS baseline and merging cohort exposure"
use "${cis}barometros.dta", clear

egen id_type = group(type)
drop if year_birth < 1910

gen age_c = floor(age / 10)

gen treat = .
replace treat = 0 if year_birth <= 1929
replace treat = 1 if year_birth > 1929 & year_birth < 1939
replace treat = 2 if year_birth >= 1939
tab treat, gen(treat_)

replace kids = 0 if nkids == 0 & kids == .

gen flag = age_together - age_partner_together
gen year_partner = year_birth + flag

keep if inrange(year_birth, 1920, 1970)
merge m:1 year_birth using "$gen/law56_cohort_exposure.dta", keep(match master) nogen

tempfile law56_results
tempname posth
postfile `posth' str12 sample str8 outcome str18 spec str24 coefname double b se p N using "`law56_results'", replace

local outcome_list "kids nkids"
foreach outcome of local outcome_list {
    display as text "Running Law 56 horse-race for outcome: `outcome'"

    quietly reghdfe `outcome' treat_2 treat_3 ///
        if female == 1 & year_birth <= 1950, ///
        a(i.year##i.id##age_c) cluster(year#i.year_birth) version(5)
    post_selected_coefs, handle(`posth') sample("female") outcome("`outcome'") spec("baseline") ///
        coefs("treat_2 treat_3")

    quietly reghdfe `outcome' treat_2 treat_3 law56_share_20_35 ///
        if female == 1 & year_birth <= 1950, ///
        a(i.year##i.id##age_c) cluster(year#i.year_birth) version(5)
    post_selected_coefs, handle(`posth') sample("female") outcome("`outcome'") spec("law56_2035") ///
        coefs("treat_2 treat_3 law56_share_20_35")

    quietly reghdfe `outcome' treat_2 treat_3 law56_share_20_35 crisis73_share_25_35 ///
        if female == 1 & year_birth <= 1950, ///
        a(i.year##i.id##age_c) cluster(year#i.year_birth) version(5)
    post_selected_coefs, handle(`posth') sample("female") outcome("`outcome'") spec("law56_2035_73") ///
        coefs("treat_2 treat_3 law56_share_20_35 crisis73_share_25_35")

    quietly reghdfe `outcome' treat_2 treat_3 law56_share_18_30 ///
        if female == 1 & inrange(year_birth, 1925, 1950), ///
        a(i.year##i.id##age_c) cluster(year#i.year_birth) version(5)
    post_selected_coefs, handle(`posth') sample("female") outcome("`outcome'") spec("law56_1830") ///
        coefs("treat_2 treat_3 law56_share_18_30")

    quietly reghdfe `outcome' treat_2 treat_3 law56_share_20_35 ///
        if female == 1 & year_birth <= 1950 & !inrange(year_birth, 1936, 1941), ///
        a(i.year##i.id##age_c) cluster(year#i.year_birth) version(5)
    post_selected_coefs, handle(`posth') sample("female") outcome("`outcome'") spec("donut_3641") ///
        coefs("treat_2 treat_3 law56_share_20_35")

    quietly reghdfe `outcome' treat_2 treat_3 law56_share_20_35 year_partner ///
        if female == 1 & year_birth <= 1950, ///
        a(i.year##i.id##age_c) cluster(year#i.year_birth) version(5)
    post_selected_coefs, handle(`posth') sample("female") outcome("`outcome'") spec("partner") ///
        coefs("treat_2 treat_3 law56_share_20_35 year_partner")
}

postclose `posth'

use "`law56_results'", clear
sort outcome spec coefname
save "$out/revision_01_law56_results.dta", replace
export delimited using "$out/revision_01_law56_results.csv", replace

display as result "Saved:"
display as result "$gen/law56_cohort_exposure.dta"
display as result "$out/revision_01_law56_results.csv"

log close
