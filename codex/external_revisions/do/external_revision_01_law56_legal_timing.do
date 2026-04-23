version 17.0
clear all
set more off

capture log close

global root "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE"
global cis "$root/original_data/CIS/_data_cis/"
global ext "$root/codex/external_revisions"
global extdata "$root/codex/external_data/processed"
global logs "$ext/logs"
global out "$ext/output"
global gen "$ext/generated"

log using "$logs/external_revision_01_law56_legal_timing.log", replace text

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

display as text "Saving legal timeline from BOE"
use "$extdata/boe_legal_timeline.dta", clear
gen event_year_disposition = real(substr(fecha_disposicion, 1, 4))
gen event_year_publication = real(substr(fecha_publicacion, 1, 4))
save "$gen/law56_legal_timeline_external.dta", replace
export delimited using "$out/law56_legal_timeline_external.csv", replace

display as text "Building cohort exposure variants from legal timing"
clear
set obs 51
gen year_birth = 1919 + _n

make_exposure_share, start(18) end(30) threshold(1962) generate(law56_share_18_30_1962)
make_exposure_share, start(20) end(35) threshold(1962) generate(law56_share_20_35_1962)
make_exposure_share, start(20) end(35) threshold(1970) generate(decree70_share_20_35)
make_exposure_share, start(25) end(35) threshold(1973) generate(crisis73_share_25_35)

save "$gen/law56_external_timing_exposure.dta", replace

display as text "Running CIS horse-race with external legal timing"
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

merge m:1 year_birth using "$gen/law56_external_timing_exposure.dta", keep(match master) nogen

tempfile results
tempname posth
postfile `posth' str12 sample str8 outcome str24 spec str28 coefname double b se p N using "`results'", replace

foreach outcome in kids nkids {
    quietly reghdfe `outcome' treat_2 treat_3 ///
        if female == 1 & year_birth <= 1950, ///
        a(i.year##i.id##age_c) cluster(year#i.year_birth) version(5)
    post_selected_coefs, handle(`posth') sample("female") outcome("`outcome'") spec("baseline") ///
        coefs("treat_2 treat_3")

    quietly reghdfe `outcome' treat_2 treat_3 law56_share_20_35_1962 ///
        if female == 1 & year_birth <= 1950, ///
        a(i.year##i.id##age_c) cluster(year#i.year_birth) version(5)
    post_selected_coefs, handle(`posth') sample("female") outcome("`outcome'") spec("plus_1962") ///
        coefs("treat_2 treat_3 law56_share_20_35_1962")

    quietly reghdfe `outcome' treat_2 treat_3 law56_share_20_35_1962 decree70_share_20_35 ///
        if female == 1 & year_birth <= 1950, ///
        a(i.year##i.id##age_c) cluster(year#i.year_birth) version(5)
    post_selected_coefs, handle(`posth') sample("female") outcome("`outcome'") spec("plus_1962_1970") ///
        coefs("treat_2 treat_3 law56_share_20_35_1962 decree70_share_20_35")

    quietly reghdfe `outcome' treat_2 treat_3 law56_share_20_35_1962 decree70_share_20_35 crisis73_share_25_35 ///
        if female == 1 & year_birth <= 1950, ///
        a(i.year##i.id##age_c) cluster(year#i.year_birth) version(5)
    post_selected_coefs, handle(`posth') sample("female") outcome("`outcome'") spec("plus_1962_1970_1973") ///
        coefs("treat_2 treat_3 law56_share_20_35_1962 decree70_share_20_35 crisis73_share_25_35")

    quietly reghdfe `outcome' treat_2 treat_3 law56_share_18_30_1962 ///
        if female == 1 & year_birth <= 1950, ///
        a(i.year##i.id##age_c) cluster(year#i.year_birth) version(5)
    post_selected_coefs, handle(`posth') sample("female") outcome("`outcome'") spec("plus_1830_1962") ///
        coefs("treat_2 treat_3 law56_share_18_30_1962")
}

postclose `posth'

use "`results'", clear
sort outcome spec coefname
save "$out/external_revision_01_law56_legal_timing.dta", replace
export delimited using "$out/external_revision_01_law56_legal_timing.csv", replace

log close
