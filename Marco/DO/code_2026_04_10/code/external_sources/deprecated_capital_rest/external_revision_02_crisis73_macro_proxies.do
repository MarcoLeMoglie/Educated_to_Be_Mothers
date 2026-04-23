version 17.0
clear all
set more off

capture log close

global root "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE"
global ext "$root/codex/external_revisions"
global logs "$ext/logs"
global out "$ext/output"
global gen "$ext/generated"
global codexgen "$root/codex/generated"

log using "$logs/external_revision_02_crisis73_macro_proxies.log", replace text

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

display as text "Loading municipality panel for unnormalized births with fertile-age composition controls"
use "$codexgen/dataset_female1544_revision.dta", clear
merge m:1 codprov using "$gen/province_pre73_crisis_proxies.dta", keep(master match) nogen
gen industrial_core_share_1950_area = .
gen oil_sensitive_share_1950_area   = .
gen manuf_trade_share_1950_area     = .
gen nonag_share_1950_area           = .
gen proxy_usable_pre73_area         = .
replace industrial_core_share_1950_area = industrial_core_share_1950_cap if type == "municipality"
replace oil_sensitive_share_1950_area   = oil_sensitive_share_1950_cap   if type == "municipality"
replace manuf_trade_share_1950_area     = manuf_trade_share_1950_cap     if type == "municipality"
replace nonag_share_1950_area           = nonag_share_1950_cap           if type == "municipality"
replace industrial_core_share_1950_area = industrial_core_share_1950_rest if type == "rest province"
replace oil_sensitive_share_1950_area   = oil_sensitive_share_1950_rest   if type == "rest province"
replace manuf_trade_share_1950_area     = manuf_trade_share_1950_rest     if type == "rest province"
replace nonag_share_1950_area           = nonag_share_1950_rest           if type == "rest province"
replace proxy_usable_pre73_area         = proxy_usable_pre73_rest         if inlist(type, "municipality", "rest province")

tempfile results
tempname posth
postfile `posth' str12 sample str24 outcome str40 spec str24 coefname double b se p N using "`results'", replace

quietly reghdfe alive interaction interaction2 1.post##c.sum1 1.post##c.sum2 ///
    flag4_3 flag4_4 flag4_5, a(i.id i.year#i.codprov) cluster(id)
post_selected_coefs, handle(`posth') sample("macro") outcome("alive") spec("full_sample_reference") ///
    coefs("interaction interaction2")

quietly reghdfe alive interaction interaction2 1.post##c.sum1 1.post##c.sum2 ///
    flag4_3 flag4_4 flag4_5 if year <= 1972, a(i.id i.year#i.codprov) cluster(id)
post_selected_coefs, handle(`posth') sample("macro") outcome("alive") spec("full_sample_pre1972") ///
    coefs("interaction interaction2")

keep if proxy_usable_pre73_area == 1

gen post73 = year >= 1973 if year < .

egen z_indcore_area = std(industrial_core_share_1950_area)
egen z_oilsens_area = std(oil_sensitive_share_1950_area)
egen z_manuftr_area = std(manuf_trade_share_1950_area)
egen z_nonag_area   = std(nonag_share_1950_area)
gen post73_f = sum1 * post73
gen post73_m = sum2 * post73

quietly reghdfe alive interaction interaction2 1.post##c.sum1 1.post##c.sum2 ///
    flag4_3 flag4_4 flag4_5, a(i.id i.year#i.codprov) cluster(id)
post_selected_coefs, handle(`posth') sample("macro") outcome("alive") spec("proxy_sample_baseline") ///
    coefs("interaction interaction2")

quietly reghdfe alive interaction interaction2 1.post##c.sum1 1.post##c.sum2 ///
    flag4_3 flag4_4 flag4_5 if year <= 1972, a(i.id i.year#i.codprov) cluster(id)
post_selected_coefs, handle(`posth') sample("macro") outcome("alive") spec("proxy_sample_pre1972") ///
    coefs("interaction interaction2")

foreach proxy in industrial_core_share_1950_area oil_sensitive_share_1950_area manuf_trade_share_1950_area nonag_share_1950_area {
    if "`proxy'" == "industrial_core_share_1950_area" local zvar z_indcore_area
    if "`proxy'" == "oil_sensitive_share_1950_area" local zvar z_oilsens_area
    if "`proxy'" == "manuf_trade_share_1950_area" local zvar z_manuftr_area
    if "`proxy'" == "nonag_share_1950_area" local zvar z_nonag_area
    gen proxy_f   = interaction  * `zvar'
    gen proxy_m   = interaction2 * `zvar'
    gen proxy73_f = interaction  * post73 * `zvar'
    gen proxy73_m = interaction2 * post73 * `zvar'

    quietly reghdfe alive interaction interaction2 post73_f post73_m proxy_f proxy_m proxy73_f proxy73_m ///
        1.post##c.sum1 1.post##c.sum2 ///
        flag4_3 flag4_4 flag4_5, a(i.id i.year#i.codprov) cluster(id)
    post_selected_coefs, handle(`posth') sample("macro") outcome("alive") spec("`proxy'") ///
        coefs("interaction interaction2 post73_f post73_m proxy_f proxy_m proxy73_f proxy73_m")

    drop proxy_f proxy_m proxy73_f proxy73_m
}

postclose `posth'

use "`results'", clear
sort outcome spec coefname
save "$out/external_revision_02_crisis73_macro_proxies.dta", replace
export delimited using "$out/external_revision_02_crisis73_macro_proxies.csv", replace

log close
