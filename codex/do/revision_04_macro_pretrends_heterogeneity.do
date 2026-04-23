version 17.0
clear all
set more off

capture log close

global root "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE"
global codex "$root/codex"
global out "$codex/output"
global gen "$codex/generated"
global logs "$codex/logs"

log using "$logs/revision_04_macro_pretrends_heterogeneity.log", replace text

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

use "$gen/dataset_female1544_revision.dta", clear

egen church_med = median(relig_com_total1930)
gen high_church = relig_com_total1930 > church_med if relig_com_total1930 < .

egen war_med = median(deaths_male_cwar)
gen high_war = deaths_male_cwar > war_med if deaths_male_cwar < .

tempfile macro_results
tempname posth
postfile `posth' str16 sample str16 outcome str24 spec str24 coefname double b se p N using "`macro_results'", replace

quietly reghdfe births_per_female1544_lin b1945.year##c.sum1 b1945.year##c.sum2 flag4_3 flag4_4 flag4_5, ///
    a(i.id i.year#i.codprov) cluster(id)
testparm 1930.year#c.sum1 1931.year#c.sum1 1932.year#c.sum1 1933.year#c.sum1 1934.year#c.sum1 1935.year#c.sum1 1936.year#c.sum1 1937.year#c.sum1 1938.year#c.sum1 1939.year#c.sum1 1940.year#c.sum1 1941.year#c.sum1 1942.year#c.sum1 1943.year#c.sum1 1944.year#c.sum1
scalar pretrend_p = r(p)
scalar pretrend_F = r(F)
post `posth' ("macro") ("birthrate_lin") ("pretrend_joint") ("pretrend_p") (pretrend_p) (.) (.) (e(N))
post `posth' ("macro") ("birthrate_lin") ("pretrend_joint") ("pretrend_F") (pretrend_F) (.) (.) (e(N))

foreach grp in 0 1 {
    quietly reghdfe alive interaction interaction2 1.post##c.sum1 1.post##c.sum2 flag4_3 flag4_4 flag4_5 ///
        if high_church == `grp', a(i.id i.year#i.codprov) cluster(id)
    post_selected_coefs, handle(`posth') sample("macro") outcome("alive") spec("church_`grp'") ///
        coefs("interaction interaction2")

    quietly reghdfe alive interaction interaction2 1.post##c.sum1 1.post##c.sum2 flag4_3 flag4_4 flag4_5 ///
        if high_war == `grp', a(i.id i.year#i.codprov) cluster(id)
    post_selected_coefs, handle(`posth') sample("macro") outcome("alive") spec("war_`grp'") ///
        coefs("interaction interaction2")
}

postclose `posth'

use "`macro_results'", clear
sort outcome spec coefname
save "$out/revision_04_macro_pretrend_results.dta", replace
export delimited using "$out/revision_04_macro_pretrend_results.csv", replace

log close
