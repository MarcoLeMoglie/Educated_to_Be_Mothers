version 17.0
clear all
set more off
set varabbrev off

global root "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE"
global datain "$root/output_data/"
global datain2 "$root/original_data/INE_microdatos/"
global extrev "$root/codex/external_revisions"
global paper_root "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/Applicazioni/Overleaf/Educated to Be Mothers-slides"
global jole "$paper_root/JOLE_comments"
global tables "$jole/tables"
global logs "$jole/logs"

capture mkdir "$tables"
capture mkdir "$logs"
capture log close
log using "$logs/refresh_oilshock_tables.log", replace text

* ============================================================================
* 4B. 1973 crisis with external provincial proxies
* ============================================================================
use "$datain/dataset.dta", clear
capture confirm variable alive
if _rc != 0 {
    gen alive = alive_birth
}
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
gen post73 = year >= 1973 if year < .
label var alive "Number of births"
label var interaction "Treat (W) X Post 1945"
label var interaction2 "Treat (M) X Post 1945"

quietly reghdfe alive interaction interaction2 1.post##c.sum1 1.post##c.sum2 ///
    flag4_3 flag4_4 flag4_5, a(i.id i.year#i.codprov) cluster(id)
merge m:1 codprov using "$extrev/generated/province_pre73_crisis_proxies.dta", keep(match master) nogen
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
egen z_indcore_area = std(industrial_core_share_1950_area) if proxy_usable_pre73_area == 1
egen z_oilsens_area = std(oil_sensitive_share_1950_area)   if proxy_usable_pre73_area == 1
egen z_manuftr_area = std(manuf_trade_share_1950_area)     if proxy_usable_pre73_area == 1
egen z_nonag_area   = std(nonag_share_1950_area)           if proxy_usable_pre73_area == 1

gen post73_f = sum1 * post73
gen post73_m = sum2 * post73
label var post73_f "Treat (W) X Post-1973"
label var post73_m "Treat (M) X Post-1973"

local proxies industrial_core_share_1950_area oil_sensitive_share_1950_area manuf_trade_share_1950_area nonag_share_1950_area
capture erase "$tables/table_selected_macro_1973_proxies.tex"
foreach proxy of local proxies {
    if "`proxy'" == "industrial_core_share_1950_area" local title "Industrial core"
    if "`proxy'" == "oil_sensitive_share_1950_area" local title "Oil-sensitive"
    if "`proxy'" == "manuf_trade_share_1950_area" local title "Manuf./trade"
    if "`proxy'" == "nonag_share_1950_area" local title "Non-agric."
    if "`proxy'" == "industrial_core_share_1950_area" local zvar z_indcore_area
    if "`proxy'" == "oil_sensitive_share_1950_area" local zvar z_oilsens_area
    if "`proxy'" == "manuf_trade_share_1950_area" local zvar z_manuftr_area
    if "`proxy'" == "nonag_share_1950_area" local zvar z_nonag_area

    gen proxy_f = interaction * `zvar'
    gen proxy_m = interaction2 * `zvar'
    gen proxy73_f = interaction * post73 * `zvar'
    gen proxy73_m = interaction2 * post73 * `zvar'
    label var proxy_f "Treat (W) X Post 1945 X Proxy"
    label var proxy_m "Treat (M) X Post 1945 X Proxy"
    label var proxy73_f "Treat (W) X Post-1973 X Proxy"
    label var proxy73_m "Treat (M) X Post-1973 X Proxy"

    quietly reghdfe alive interaction interaction2 post73_f post73_m proxy_f proxy_m proxy73_f proxy73_m ///
        1.post##c.sum1 1.post##c.sum2 flag4_3 flag4_4 flag4_5 ///
        if proxy_usable_pre73_area == 1, a(i.id i.year#i.codprov) cluster(id)
    quietly sum alive if e(sample), meanonly
    local mean_alive = r(mean)

    if "`proxy'" == "industrial_core_share_1950_area" {
        outreg2 using "$tables/table_selected_macro_1973_proxies.tex", replace tex(frag) label ///
            keep(interaction interaction2 post73_f post73_m proxy_f proxy_m proxy73_f proxy73_m) nocons ///
            ctitle("Births") ///
            addtext("Specification", "`title'", "Unit FE", "YES", "Province-Year FE", "YES", "Fertile-age controls", "YES", ///
                    "Treat X Post-1973", "YES", "Treat X Post 1945 X Proxy", "YES", ///
                    "Treat X Post-1973 X Proxy", "YES") ///
            addstat("Mean of depvar", `mean_alive') nonotes
    }
    else {
        outreg2 using "$tables/table_selected_macro_1973_proxies.tex", append tex(frag) label ///
            keep(interaction interaction2 post73_f post73_m proxy_f proxy_m proxy73_f proxy73_m) nocons ///
            ctitle("Births") ///
            addtext("Specification", "`title'", "Unit FE", "YES", "Province-Year FE", "YES", "Fertile-age controls", "YES", ///
                    "Treat X Post-1973", "YES", "Treat X Post 1945 X Proxy", "YES", ///
                    "Treat X Post-1973 X Proxy", "YES") ///
            addstat("Mean of depvar", `mean_alive') nonotes
    }
    drop proxy_f proxy_m proxy73_f proxy73_m
}
drop post73_f post73_m

* ============================================================================
* 4C. Birthplace pre-1973 industrial proxies
* ============================================================================
use ${datain2}censo1991/por_provincias/censo1991_provincias.dta, clear
rename *, lower
replace fecha = . if fecha > 100
gen anac = 1992 - fecha
keep if inrange(anac, 1920, 1970)
gen year = 1991
rename prov codprov
rename pronacin codprov_born
rename mun cmun
rename hijos nhijos
gen weight = fe / 10000
tempfile c1991_base
save "`c1991_base'"

use ${datain2}censo2011/por_provincias/censo2011_provincias.dta, clear
rename *, lower
keep if inrange(anac, 1920, 1970)
replace nhijos = 0 if hijos == 0
gen year = 2011
rename cpro codprov
rename cpron codprov_born
append using "`c1991_base'"

gen treat = .
replace treat = 0 if anac <= 1929
replace treat = 1 if anac > 1929 & anac < 1939
replace treat = 2 if anac >= 1939
tab treat, gen(treat_)
gen weight2 = fe if year == 1991
replace weight2 = factor if year == 2011
gen age_c = floor(edad / 10)
label var nhijos "N. kids"
label var treat_2 "1930/1938"
label var treat_3 "1939/1950"

preserve
use "$extrev/generated/province_pre73_crisis_proxies.dta", clear
keep codprov proxy_usable_pre73 industrial_core_share_1950 oil_sensitive_share_1950 ///
    manuf_trade_share_1950 nonag_share_1950
rename codprov codprov_born
duplicates drop
tempfile province_pre73
save "`province_pre73'"
restore

merge m:1 codprov_born using "`province_pre73'", keep(match master) nogen
egen z_indcore = std(industrial_core_share_1950) if proxy_usable_pre73 == 1
egen z_oilsens = std(oil_sensitive_share_1950) if proxy_usable_pre73 == 1
egen z_manuftr = std(manuf_trade_share_1950) if proxy_usable_pre73 == 1
egen z_nonag = std(nonag_share_1950) if proxy_usable_pre73 == 1
gen indcore_t2 = z_indcore * treat_2 if z_indcore < .
gen indcore_t3 = z_indcore * treat_3 if z_indcore < .
gen oilsens_t2 = z_oilsens * treat_2 if z_oilsens < .
gen oilsens_t3 = z_oilsens * treat_3 if z_oilsens < .
gen manuftr_t2 = z_manuftr * treat_2 if z_manuftr < .
gen manuftr_t3 = z_manuftr * treat_3 if z_manuftr < .
gen nonag_t2 = z_nonag * treat_2 if z_nonag < .
gen nonag_t3 = z_nonag * treat_3 if z_nonag < .

quietly reghdfe nhijos treat_2 treat_3 if sexo == 6 & inrange(anac, 1920, 1950) & proxy_usable_pre73 == 1 [aw=weight2], ///
    a(cmun##i.age_c##year) cluster(year#anac) version(5)
quietly sum nhijos if e(sample) [aw=weight2], meanonly
local mean_nhijos_proxy : display %4.2f r(mean)
outreg2 using "$tables/table_selected_birthplace_pre73_proxies.tex", replace tex(frag) label ///
    keep(treat_2 treat_3) nocons ctitle("N. kids") ///
    addtext(Specification, Baseline restricted sample, ///
            Mun. X Year X Age-class X Birth Prov. FE, NO) ///
    addstat(Mean of depvar, `mean_nhijos_proxy') nonotes

quietly reghdfe nhijos treat_2 treat_3 if sexo == 6 & inrange(anac, 1920, 1950) & proxy_usable_pre73 == 1 [aw=weight2], ///
    a(cmun##i.age_c##year##i.codprov_born) cluster(year#anac) version(5)
quietly sum nhijos if e(sample) [aw=weight2], meanonly
local mean_nhijos_proxy2 : display %4.2f r(mean)
outreg2 using "$tables/table_selected_birthplace_pre73_proxies.tex", append tex(frag) label ///
    keep(treat_2 treat_3) nocons ctitle("N. kids") ///
    addtext(Specification, + Birthplace FE, ///
            Mun. X Year X Age-class X Birth Prov. FE, YES) ///
    addstat(Mean of depvar, `mean_nhijos_proxy2') nonotes

foreach proxy in indcore oilsens manuftr nonag {
    local pair = cond("`proxy'"=="indcore","indcore_t2 indcore_t3", ///
        cond("`proxy'"=="oilsens","oilsens_t2 oilsens_t3", ///
        cond("`proxy'"=="manuftr","manuftr_t2 manuftr_t3","nonag_t2 nonag_t3")))
    if "`proxy'" == "indcore" {
        label var indcore_t2 "1930/1938 X Industrial core"
        label var indcore_t3 "1939/1950 X Industrial core"
        local title "Industrial core"
    }
    if "`proxy'" == "oilsens" {
        label var oilsens_t2 "1930/1938 X Oil-sensitive"
        label var oilsens_t3 "1939/1950 X Oil-sensitive"
        local title "Oil-sensitive"
    }
    if "`proxy'" == "manuftr" {
        label var manuftr_t2 "1930/1938 X Manuf./trade"
        label var manuftr_t3 "1939/1950 X Manuf./trade"
        local title "Manuf./trade"
    }
    if "`proxy'" == "nonag" {
        label var nonag_t2 "1930/1938 X Non-agric."
        label var nonag_t3 "1939/1950 X Non-agric."
        local title "Non-agric."
    }
    quietly reghdfe nhijos treat_2 treat_3 `pair' ///
        if sexo == 6 & inrange(anac, 1920, 1950) & proxy_usable_pre73 == 1 [aw=weight2], ///
        a(cmun##i.age_c##year##i.codprov_born) cluster(year#anac) version(5)
    quietly sum nhijos if e(sample) [aw=weight2], meanonly
    local mean_nhijos_proxyhet : display %4.2f r(mean)
    outreg2 using "$tables/table_selected_birthplace_pre73_proxies.tex", ///
        append tex(frag) label ///
        keep(treat_2 treat_3 `pair') nocons ctitle("N. kids") ///
        addtext(Specification, `title', ///
                Mun. X Year X Age-class X Birth Prov. FE, YES) ///
        addstat(Mean of depvar, `mean_nhijos_proxyhet') nonotes
}

quietly reghdfe nhijos treat_2 treat_3 ///
    indcore_t2 indcore_t3 oilsens_t2 oilsens_t3 manuftr_t2 manuftr_t3 nonag_t2 nonag_t3 ///
    if sexo == 6 & inrange(anac, 1920, 1950) & proxy_usable_pre73 == 1 [aw=weight2], ///
    a(cmun##i.age_c##year##i.codprov_born) cluster(year#anac) version(5)
quietly sum nhijos if e(sample) [aw=weight2], meanonly
local mean_nhijos_all : display %4.2f r(mean)
outreg2 using "$tables/table_selected_birthplace_pre73_proxies.tex", append tex(frag) label ///
    keep(treat_2 treat_3 indcore_t2 indcore_t3 oilsens_t2 oilsens_t3 manuftr_t2 manuftr_t3 nonag_t2 nonag_t3) nocons ctitle("N. kids") ///
    addtext(Specification, All, ///
            Mun. X Year X Age-class X Birth Prov. FE, YES) ///
    addstat(Mean of depvar, `mean_nhijos_all') nonotes

log close
