version 17.0
clear all
set more off

capture log close

global root "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE"
global datain "$root/output_data/"
global codex "$root/codex"
global out "$codex/output"
global gen "$codex/generated"
global logs "$codex/logs"

log using "$logs/revision_02_migration_macro.log", replace text

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

display as text "Loading municipality panel"
use "${datain}dataset.dta", clear

capture confirm variable alive
if _rc != 0 {
    gen alive = alive_birth
}

gen female1544_1930 = popwomen_agegroup3_1930 + popwomen_agegroup4_1930 + popwomen_agegroup5_1930
gen female1544_1940 = popwomen_agegroup3_1940 + popwomen_agegroup4_1940 + popwomen_agegroup5_1940
gen female1544_1950 = popwomen_agegroup3_1950 + popwomen_agegroup4_1950 + popwomen_agegroup5_1950
gen female1544_1960 = popwomen_agegroup3_1960 + popwomen_agegroup4_1960 + popwomen_agegroup5_1960
gen female1544_1970 = popwomen_agegroup3_1970 + popwomen_agegroup4_1970 + popwomen_agegroup5_1970

gen female1544_step = .
replace female1544_step = female1544_1930 if year >= 1930 & year < 1940
replace female1544_step = female1544_1940 if year >= 1940 & year < 1950
replace female1544_step = female1544_1950 if year >= 1950 & year < 1960
replace female1544_step = female1544_1960 if year >= 1960 & year < 1970
replace female1544_step = female1544_1970 if year >= 1970 & year < .

gen female1544_lin = .
replace female1544_lin = female1544_1930 + ((year - 1930) / 10) * (female1544_1940 - female1544_1930) if year >= 1930 & year < 1940
replace female1544_lin = female1544_1940 + ((year - 1940) / 10) * (female1544_1950 - female1544_1940) if year >= 1940 & year < 1950
replace female1544_lin = female1544_1950 + ((year - 1950) / 10) * (female1544_1960 - female1544_1950) if year >= 1950 & year < 1960
replace female1544_lin = female1544_1960 + ((year - 1960) / 10) * (female1544_1970 - female1544_1960) if year >= 1960 & year < 1970
replace female1544_lin = female1544_1970 if year >= 1970 & year < .

gen births_per_female1544_step = (alive / female1544_step) * 1000 if female1544_step > 0
gen births_per_female1544_lin = (alive / female1544_lin) * 1000 if female1544_lin > 0
gen ln_female1544_lin = ln(female1544_lin) if female1544_lin > 0

gen popsharewomen_agegroup1 = (popsharewomen_agegroup1_1940 + popsharewomen_agegroup2_1940) * 100
gen popsharemen_agegroup1 = (popsharemen_agegroup1_1940 + popsharemen_agegroup2_1940) * 100

gen flag4_3 = .
gen flag4_4 = .
gen flag4_5 = .

replace flag4_3 = ln(popwomen_agegroup3_1930) if year >= 1930 & year < 1940
replace flag4_3 = ln(popwomen_agegroup3_1940) if year >= 1940 & year < 1950
replace flag4_3 = ln(popwomen_agegroup3_1950) if year >= 1950 & year < 1960
replace flag4_3 = ln(popwomen_agegroup3_1960) if year >= 1960 & year < 1970
replace flag4_3 = ln(popwomen_agegroup3_1970) if year >= 1970 & year < .

replace flag4_4 = ln(popwomen_agegroup4_1930) if year >= 1930 & year < 1940
replace flag4_4 = ln(popwomen_agegroup4_1940) if year >= 1940 & year < 1950
replace flag4_4 = ln(popwomen_agegroup4_1950) if year >= 1950 & year < 1960
replace flag4_4 = ln(popwomen_agegroup4_1960) if year >= 1960 & year < 1970
replace flag4_4 = ln(popwomen_agegroup4_1970) if year >= 1970 & year < .

replace flag4_5 = ln(popwomen_agegroup5_1930) if year >= 1930 & year < 1940
replace flag4_5 = ln(popwomen_agegroup5_1940) if year >= 1940 & year < 1950
replace flag4_5 = ln(popwomen_agegroup5_1950) if year >= 1950 & year < 1960
replace flag4_5 = ln(popwomen_agegroup5_1960) if year >= 1960 & year < 1970
replace flag4_5 = ln(popwomen_agegroup5_1970) if year >= 1970 & year < .

drop if popsharewomen_agegroup1 == . | popsharemen_agegroup1 == .
gen sum1 = popsharewomen_agegroup1
gen sum2 = popsharemen_agegroup1
gen interaction = post * sum1
gen interaction2 = post * sum2

xtile median_popw1 = popsharewomen_agegroup1, n(2)
gen dsum1 = median_popw1 == 2
xtile median_popm1 = popsharemen_agegroup1, n(2)
gen dsum2 = median_popm1 == 2
gen dinteraction = post * dsum1
gen dinteraction2 = post * dsum2

save "$gen/dataset_female1544_revision.dta", replace
export delimited id year codprov type alive female1544_step female1544_lin births_per_female1544_lin births_per_female1544_step ///
    using "$out/dataset_female1544_revision_sample.csv", replace

tempfile migration_results
tempname posth
postfile `posth' str12 sample str24 outcome str18 spec str24 coefname double b se p N using "`migration_results'", replace

display as text "Running continuous-treatment migration diagnostics"
quietly reghdfe alive interaction interaction2 1.post##c.sum1 1.post##c.sum2 flag4_3 flag4_4 flag4_5, ///
    a(i.id i.year#i.codprov) cluster(id)
post_selected_coefs, handle(`posth') sample("macro") outcome("alive") spec("baseline_cont") ///
    coefs("interaction interaction2")

quietly reghdfe births_per_female1544_lin interaction interaction2 1.post##c.sum1 1.post##c.sum2 flag4_3 flag4_4 flag4_5, ///
    a(i.id i.year#i.codprov) cluster(id)
post_selected_coefs, handle(`posth') sample("macro") outcome("birthrate_lin") spec("baseline_cont") ///
    coefs("interaction interaction2")

quietly reghdfe ln_female1544_lin interaction interaction2 1.post##c.sum1 1.post##c.sum2 flag4_3 flag4_4 flag4_5, ///
    a(i.id i.year#i.codprov) cluster(id)
post_selected_coefs, handle(`posth') sample("macro") outcome("ln_female1544") spec("baseline_cont") ///
    coefs("interaction interaction2")

quietly reghdfe births_per_female1544_lin interaction interaction2 1.post##c.sum1 1.post##c.sum2 flag4_3 flag4_4 flag4_5 ///
    if year <= 1972, a(i.id i.year#i.codprov) cluster(id)
post_selected_coefs, handle(`posth') sample("macro") outcome("birthrate_lin") spec("through_1972") ///
    coefs("interaction interaction2")

quietly reghdfe births_per_female1544_lin interaction interaction2 1.post##c.sum1 1.post##c.sum2 flag4_3 flag4_4 flag4_5 ///
    if inrange(year, 1940, 1965), a(i.id i.year#i.codprov) cluster(id)
post_selected_coefs, handle(`posth') sample("macro") outcome("birthrate_lin") spec("1940_1965") ///
    coefs("interaction interaction2")

display as text "Running discrete-treatment robustness"
quietly reghdfe births_per_female1544_lin dinteraction dinteraction2 1.post##i.dsum1 1.post##i.dsum2 flag4_3 flag4_4 flag4_5, ///
    a(i.id i.year#i.codprov) cluster(id)
post_selected_coefs, handle(`posth') sample("macro") outcome("birthrate_lin") spec("discrete") ///
    coefs("dinteraction dinteraction2")

quietly reghdfe ln_female1544_lin dinteraction dinteraction2 1.post##i.dsum1 1.post##i.dsum2 flag4_3 flag4_4 flag4_5, ///
    a(i.id i.year#i.codprov) cluster(id)
post_selected_coefs, handle(`posth') sample("macro") outcome("ln_female1544") spec("discrete") ///
    coefs("dinteraction dinteraction2")

postclose `posth'

use "`migration_results'", clear
sort outcome spec coefname
save "$out/revision_02_migration_results.dta", replace
export delimited using "$out/revision_02_migration_results.csv", replace

display as result "Saved:"
display as result "$gen/dataset_female1544_revision.dta"
display as result "$out/revision_02_migration_results.csv"

log close
