version 17.0
clear all
set more off
set varabbrev off

capture log close

* ============================================================================
* JOLE reviewer package: selected revision design only
* ----------------------------------------------------------------------------
* This master do-file does not try to replace the full original paper pipeline.
* Instead, it does three things in one place:
*
* 1. refreshes the selected reviewer-facing analyses that we decided to keep;
* 2. exports paper-style LaTeX tables using outreg2 whenever the output is a
*    regression table or a compact descriptive table that can be summarized;
* 3. keeps each reviewer issue in a separate commented subsection so that the
*    logic is easy to follow when we rewrite the paper and the response letter.
*
* The source of truth for the original paper remains:
*   Marco/DO/new/Main_analysis.do
*
* This file is the curated revision companion.
* ============================================================================

global root "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE"
global paper_root "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/Applicazioni/Overleaf/Educated to Be Mothers-slides"
global cis "$root/original_data/CIS/_data_cis/"
global datain "$root/output_data/"
global datain2 "$root/original_data/INE_microdatos/"
global province "$root/output_data/dataset_PROVINCElevel.dta"
global extdata "$root/codex/external_data/processed"
global extrev "$root/codex/external_revisions"
global codex "$root/codex"
global jole "$paper_root/JOLE_comments"
global code "$jole/code"
global tables "$jole/tables"
global logs "$jole/logs"

capture mkdir "$tables"
capture mkdir "$logs"

log using "$logs/Main_analysis_selected_revision.log", replace text

* ============================================================================
* SECTION 0. Inputs used by this curated file
* ----------------------------------------------------------------------------
* We intentionally do NOT call the old revision scripts from inside this master
* file. Those scripts open and close their own logs, which makes a unified log
* hard to read and easy to break. Instead, this file assumes that the codex
* outputs already exist and then rebuilds the selected paper-style tables in one
* place. If we need to refresh upstream csv/dta outputs, we run the original
* revision scripts separately and only then rerun this master file.
* ============================================================================

* ============================================================================
* SECTION 1. Law 56 / 1961 horse-race
* ----------------------------------------------------------------------------
* Reviewer issue:
* Could the cohort pattern reflect differential exposure to the 1961 labor law
* rather than the school reform package?
*
* What we keep:
* - baseline completed-fertility regression
* - horse-race with Law 56 exposure over ages 20-35
*
* Paper use:
* This belongs in the micro robustness section that discusses competing cohort
* explanations.
* ============================================================================

display as text "JOLE section 1: Law 56 horse-race tables"
use "${cis}barometros.dta", clear

egen id_type = group(type)
drop if year_birth < 1910
gen age_c = floor(age / 10)

gen treat = .
replace treat = 0 if year_birth <= 1929
replace treat = 1 if year_birth > 1929 & year_birth < 1939
replace treat = 2 if year_birth >= 1939
tab treat, gen(treat_)
label var treat_2 "1930/1938"
label var treat_3 "1939/1950"
label var nkids "N. kids"

replace kids = 0 if nkids == 0 & kids == .
gen flag = age_together - age_partner_together
gen year_partner = year_birth + flag

merge m:1 year_birth using "$codex/generated/law56_cohort_exposure.dta", keep(match master) nogen

quietly reghdfe nkids treat_2 treat_3 ///
    if female == 1 & year_birth <= 1950, ///
    a(i.year##i.id##age_c) cluster(year#i.year_birth) version(5)
outreg2 using "$tables/table_selected_law56_nkids.tex", replace tex(frag) label ///
    keep(treat_2 treat_3) nocons ctitle("N. kids") ///
    addtext(Specification, Baseline, ///
            Survey-year FE, YES, Residence FE, YES, Age-class FE, YES, ///
            Survey-year X Residence X Age-class FE, YES, ///
            Law 56 exposure control, NO) nonotes

quietly reghdfe nkids treat_2 treat_3 law56_share_20_35 ///
    if female == 1 & year_birth <= 1950, ///
    a(i.year##i.id##age_c) cluster(year#i.year_birth) version(5)
outreg2 using "$tables/table_selected_law56_nkids.tex", append tex(frag) label ///
    keep(treat_2 treat_3 law56_share_20_35) nocons ctitle("N. kids") ///
    addtext(Specification, Baseline + Law 56 exposure, ///
            Survey-year FE, YES, Residence FE, YES, Age-class FE, YES, ///
            Survey-year X Residence X Age-class FE, YES, ///
            Law 56 exposure control, YES) nonotes

* ============================================================================
* SECTION 1B. Law 56 mechanism support from Censo 1981
* ----------------------------------------------------------------------------
* Reviewer issue:
* Maybe the mechanism is female employment rather than schooling / socialization.
*
* What we keep:
* - compact fertility gaps active vs inactive near the 1961-1970 window
* - compact 1981 female activity structure
* - female vs male activity gap
*
* Paper use:
* A short robustness / mechanism appendix table plus one paragraph in the text.
* ============================================================================

display as text "JOLE section 1B: Law 56 mechanism support tables"
use "$extrev/output/external_revision_04_law56_window_cells.dta", clear
keep if zone == "Total Nacional"
keep if inlist(age_group, "De 25 a 29 años", "De 30 a 34 años")
keep if inlist(marriage_period, "1961_1965", "1966_1970", "1971_1975")

quietly sum avg_childrenactive if marriage_period == "1961_1965" & age_group == "De 25 a 29 años", meanonly
local act_6165_2529 : display %4.2f r(mean)
quietly sum avg_childreninactive if marriage_period == "1961_1965" & age_group == "De 25 a 29 años", meanonly
local inact_6165_2529 : display %4.2f r(mean)
quietly sum active_minus_inactive if marriage_period == "1961_1965" & age_group == "De 25 a 29 años", meanonly
local gap_6165_2529 : display %4.2f r(mean)

quietly sum avg_childrenactive if marriage_period == "1966_1970" & age_group == "De 25 a 29 años", meanonly
local act_6670_2529 : display %4.2f r(mean)
quietly sum avg_childreninactive if marriage_period == "1966_1970" & age_group == "De 25 a 29 años", meanonly
local inact_6670_2529 : display %4.2f r(mean)
quietly sum active_minus_inactive if marriage_period == "1966_1970" & age_group == "De 25 a 29 años", meanonly
local gap_6670_2529 : display %4.2f r(mean)

quietly sum avg_childrenactive if marriage_period == "1971_1975" & age_group == "De 25 a 29 años", meanonly
local act_7175_2529 : display %4.2f r(mean)
quietly sum avg_childreninactive if marriage_period == "1971_1975" & age_group == "De 25 a 29 años", meanonly
local inact_7175_2529 : display %4.2f r(mean)
quietly sum active_minus_inactive if marriage_period == "1971_1975" & age_group == "De 25 a 29 años", meanonly
local gap_7175_2529 : display %4.2f r(mean)

use "$extrev/output/external_revision_04_female_activity_structure_1981.dta", clear
keep if inlist(ambito_territorial, "Total Nacional", "Zona urbana", "Zona rural")
quietly sum active_share_total if ambito_territorial == "Total Nacional", meanonly
local active_total_nat : display %4.2f 100*r(mean)
quietly sum occupied_share_total if ambito_territorial == "Total Nacional", meanonly
local occupied_total_nat : display %4.2f 100*r(mean)
quietly sum inactive_share_total if ambito_territorial == "Total Nacional", meanonly
local inactive_total_nat : display %4.2f 100*r(mean)
quietly sum active_share_total if ambito_territorial == "Zona urbana", meanonly
local active_urban : display %4.2f 100*r(mean)
quietly sum active_share_total if ambito_territorial == "Zona rural", meanonly
local active_rural : display %4.2f 100*r(mean)
quietly sum occupied_share_total if ambito_territorial == "Zona urbana", meanonly
local occupied_urban : display %4.2f 100*r(mean)

use "$extrev/output/external_revision_04_sex_activity_gap_1981.dta", clear
keep if ambito_territorial == "Total Nacional"
quietly sum totalMujeres, meanonly
local female_activity_rate : display %4.2f r(mean)
quietly sum totalVarones, meanonly
local male_activity_rate : display %4.2f r(mean)
quietly sum female_male_activity_ratio, meanonly
local female_male_activity_ratio : display %4.3f r(mean)

file open mech using "$tables/table_selected_law56_mechanism.tex", write replace
file write mech "\begin{tabular}{lc} \hline" _n
file write mech " & Value \\\\" _n
file write mech "\hline" _n
file write mech "\multicolumn{2}{l}{\textit{Panel A. Average children: active minus inactive women}} \\\\" _n
file write mech "Married in 1961--1965, age 25--29 & `gap_6165_2529' \\\\" _n
file write mech "Married in 1966--1970, age 25--29 & `gap_6670_2529' \\\\" _n
file write mech "Married in 1971--1975, age 25--29 & `gap_7175_2529' \\\\" _n
file write mech "\multicolumn{2}{l}{\textit{Panel B. Scale of female labor-force attachment in 1981}} \\\\" _n
file write mech "Female activity rate (national, \%) & `female_activity_rate' \\\\" _n
file write mech "Female employment share (national, \%) & `occupied_total_nat' \\\\" _n
file write mech "Female inactivity share (national, \%) & `inactive_total_nat' \\\\" _n
file write mech "Female activity rate (urban, \%) & `active_urban' \\\\" _n
file write mech "Female activity rate (rural, \%) & `active_rural' \\\\" _n
file write mech "Male activity rate (national, \%) & `male_activity_rate' \\\\" _n
file write mech "Female-to-male activity ratio & `female_male_activity_ratio' \\\\" _n
file write mech "Female employment share (urban, \%) & `occupied_urban' \\\\" _n
file write mech "\hline" _n
file write mech "\end{tabular}" _n
file close mech

* ============================================================================
* REPORT MAPPING FOR RETAINED BLOCKS
* ----------------------------------------------------------------------------
* 1a. Law 56 / 1961 horse-race
* 1b. Law 56 mechanism support from Censo 1981
* 3a. External migration evidence from Censo 1981
* 3b. Birthplace, current residence, movers and stayers
* 4a. Pre-1973 provincial proxies as supporting infrastructure
* 4b. 1973 crisis with external provincial proxies
* 4c. Birthplace pre-1973 industrial proxies
* ============================================================================

* ============================================================================
* SECTION 4B. 1973 crisis with external provincial proxies
* ----------------------------------------------------------------------------
* Reviewer issue:
* Maybe the local result is really about oil-shock exposure.
*
* What we keep:
* - one compact proxy table with the four pre-1973 provincial measures
* - direct interpretation of the baseline pre-1973 effect and the common post-1973 shift
* ============================================================================

display as text "JOLE section 4B: 1973 crisis tables"
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
label var alive "Births"
label var interaction "Treat (W) X Post 1945"
label var interaction2 "Treat (M) X Post 1945"
capture confirm variable post73
if _rc != 0 {
    gen post73 = year >= 1973 if year < .
}

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
    quietly reghdfe alive interaction interaction2 post73_f post73_m proxy_f proxy_m proxy73_f proxy73_m 1.post##c.sum1 1.post##c.sum2 ///
        flag4_3 flag4_4 flag4_5 if proxy_usable_pre73_area == 1, a(i.id i.year#i.codprov) cluster(id)
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
* SECTION 3A. External migration evidence from Censo 1981
* ----------------------------------------------------------------------------
* Reviewer issue:
* Maybe treated places simply lost women.
*
* What we keep:
* - movers vs stayers activity/employment comparison
* - province-level staying-share regression linked to treatment intensity
* ============================================================================

display as text "JOLE section 3A: external migration tables"
use "$extrev/output/external_revision_03_female_mobility_activity.dta", clear
keep if age_group == "de 25 a 34"
gen mover_active = active_share if mobility_status == "EN DISTINTO MUNICIPIO QUE EN 1981"
gen stayer_active = active_share if mobility_status == "EN EL MISMO MUNICIPIO QUE EN 1981"
gen mover_employed = employed_share if mobility_status == "EN DISTINTO MUNICIPIO QUE EN 1981"
gen stayer_employed = employed_share if mobility_status == "EN EL MISMO MUNICIPIO QUE EN 1981"
collapse (max) mover_active stayer_active mover_employed stayer_employed
sum mover_active stayer_active mover_employed stayer_employed
outreg2 using "$tables/table_selected_external_migration_descriptive.tex", replace tex(frag) ///
    sum(log) keep(mover_active stayer_active mover_employed stayer_employed) eqkeep(mean) label nonotes

use "$extrev/output/external_revision_03_province_mobility_link.dta", clear
capture confirm variable ln_origin_total
if _rc != 0 {
    gen ln_origin_total = ln(origin_total)
}
label var treat_gap_f "Exposure gap (W)"
label var treat_gap_m "Exposure gap (M)"
label var muni_share_1940 "Municipal share in 1940"
label var ln_origin_total "Log origin population"
quietly reg stay_share treat_gap_f treat_gap_m muni_share_1940 ln_origin_total, vce(robust)
outreg2 using "$tables/table_selected_external_migration_regs.tex", replace tex(frag) label ///
    keep(treat_gap_f treat_gap_m muni_share_1940 ln_origin_total) nocons ctitle("Female staying share, 1970--1981") nonotes

* ============================================================================
* SECTION 3B. Birthplace, residence, movers and stayers
* ----------------------------------------------------------------------------
* Reviewer issue:
* Maybe we are picking up sorting by place of residence rather than birthplace.
*
* What we keep:
* - birthplace FE
* - birthplace + current residence FE
* - movers/stayers split
*
* Paper use:
* This is one of the main reviewer-response tables.
* ============================================================================

display as text "JOLE section 3B: birthplace/residence tables"
use ${datain2}censo1991/por_provincias/censo1991_provincias.dta, clear
rename *, lower
replace fecha = . if fecha > 100
gen anac = 1992 - fecha
keep if inrange(anac, 1920, 1970)
gen kids2 = hijos > 0 & hijos != .
replace kids2 = . if hijos == .
gen year = 1991
rename munacin cmunn
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
gen kids = nhijo > 0 & nhijo != .
replace kids = . if nhijo == .
gen kids2 = hijos == 1
replace kids2 = . if hijos == .
replace nhijos = 0 if kids2 == 0
gen year = 2011
rename cpro codprov
rename cpron codprov_born
gen weight = factor
append using "`c1991_base'"

gen treat = .
replace treat = 0 if anac <= 1929
replace treat = 1 if anac > 1929 & anac < 1939
replace treat = 2 if anac >= 1939
tab treat, gen(treat_)
gen weight2 = fe if year == 1991
replace weight2 = factor if year == 2011
gen age_c = floor(edad / 10)
gen stayer_birthprov = codprov == codprov_born if codprov < . & codprov_born < .
gen mover_birthprov = 1 - stayer_birthprov if stayer_birthprov < .
label var nhijos "Number of children ever had"
label var treat_2 "1930/1938"
label var treat_3 "1939/1950"

quietly reghdfe nhijos treat_2 treat_3 if sexo == 6 & inrange(anac, 1920, 1950) [aw=weight2], ///
    a(cmun##i.age_c##year) cluster(year#anac) version(5)
outreg2 using "$tables/table_selected_birthplace_nhijos.tex", replace tex(frag) label ///
    keep(treat_2 treat_3) nocons ctitle("N. kids") ///
    addtext(Specification, Baseline, ///
            Census. X Mun. X Age-class FE, YES, ///
            Mun. X Year X Age-class X Birth Prov. FE, NO) nonotes

quietly reghdfe nhijos treat_2 treat_3 if sexo == 6 & inrange(anac, 1920, 1950) [aw=weight2], ///
    a(cmun##i.age_c##year##i.codprov_born) cluster(year#anac) version(5)
outreg2 using "$tables/table_selected_birthplace_nhijos.tex", append tex(frag) label ///
    keep(treat_2 treat_3) nocons ctitle("N. kids") ///
    addtext(Specification, Birthplace FE, ///
            Census. X Mun. X Age-class FE, NO, ///
            Mun. X Year X Age-class X Birth Prov. FE, YES) nonotes

quietly reghdfe nhijos treat_2 treat_3 if sexo == 6 & inrange(anac, 1920, 1950) & mover_birthprov == 1 [aw=weight2], ///
    a(cmun##i.age_c##year##i.codprov_born) cluster(year#anac) version(5)
outreg2 using "$tables/table_selected_birthplace_nhijos.tex", append tex(frag) label ///
    keep(treat_2 treat_3) nocons ctitle("N. kids") ///
    addtext(Specification, Movers, ///
            Census. X Mun. X Age-class FE, NO, ///
            Mun. X Year X Age-class X Birth Prov. FE, YES) nonotes

quietly reghdfe nhijos treat_2 treat_3 if sexo == 6 & inrange(anac, 1920, 1950) & stayer_birthprov == 1 [aw=weight2], ///
    a(cmun##i.age_c##year##i.codprov_born) cluster(year#anac) version(5)
outreg2 using "$tables/table_selected_birthplace_nhijos.tex", append tex(frag) label ///
    keep(treat_2 treat_3) nocons ctitle("N. kids") ///
    addtext(Specification, Stayers, ///
            Census. X Mun. X Age-class FE, NO, ///
            Mun. X Year X Age-class X Birth Prov. FE, YES) nonotes

* ============================================================================
* SECTION 3B. Civil war controls at birthplace
* ----------------------------------------------------------------------------
* Reviewer issue:
* Maybe the cohort comparison is really war trauma at birthplace.
* ============================================================================

display as text "JOLE section 3B: birthplace war controls"
preserve
use "$province", clear
keep codprov sh_area_front
rename codprov codprov_born
duplicates drop
tempfile province_war
save "`province_war'"
restore

merge m:1 codprov_born using "`province_war'", keep(match master) nogen
gen front_treat2 = sh_area_front * treat_2 if sh_area_front < .
gen front_treat3 = sh_area_front * treat_3 if sh_area_front < .
label var front_treat2 "1930/1938 X War exposure"
label var front_treat3 "1939/1950 X War exposure"

quietly reghdfe nhijos treat_2 treat_3 if sexo == 6 & inrange(anac, 1920, 1950) [aw=weight2], ///
    a(cmun##i.age_c##year##i.codprov_born) cluster(year#anac) version(5)
quietly sum nhijos if e(sample) [aw=weight2], meanonly
local mean_nhijos_war : display %4.2f r(mean)
outreg2 using "$tables/table_selected_birthplace_war.tex", replace tex(frag) label ///
    keep(treat_2 treat_3) nocons ctitle("N. kids") ///
    addtext(Specification, Baseline with birthplace FE, ///
            Census. X Mun. X Age-class FE, NO, ///
            Mun. X Year X Age-class X Birth Prov. FE, YES, ///
            Birthplace war interactions, NO) ///
    addstat(Mean of depvar, `mean_nhijos_war') nonotes

quietly reghdfe nhijos treat_2 treat_3 front_treat2 front_treat3 ///
    if sexo == 6 & inrange(anac, 1920, 1950) [aw=weight2], ///
    a(cmun##i.age_c##year##i.codprov_born) cluster(year#anac) version(5)
quietly sum nhijos if e(sample) [aw=weight2], meanonly
local mean_nhijos_war2 : display %4.2f r(mean)
outreg2 using "$tables/table_selected_birthplace_war.tex", append tex(frag) label ///
    keep(treat_2 treat_3 front_treat2 front_treat3) nocons ctitle("N. kids") ///
    addtext(Specification, Birthplace FE + war, ///
            Census. X Mun. X Age-class FE, NO, ///
            Mun. X Year X Age-class X Birth Prov. FE, YES, ///
            Birthplace war interactions, YES) ///
    addstat(Mean of depvar, `mean_nhijos_war2') nonotes

* ============================================================================
* SECTION 4C. Birthplace pre-1973 industrial proxies
* ----------------------------------------------------------------------------
* Reviewer issue:
* Maybe the micro result is just pre-existing industrial structure at birthplace.
* ============================================================================

display as text "JOLE section 4C: birthplace pre-1973 proxies"
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
    addtext(Specification, Birthplace FE, ///
            Mun. X Year X Age-class X Birth Prov. FE, NO) ///
    addstat(Mean of depvar, `mean_nhijos_proxy') nonotes

quietly reghdfe nhijos treat_2 treat_3 if sexo == 6 & inrange(anac, 1920, 1950) & proxy_usable_pre73 == 1 [aw=weight2], ///
    a(i.year##i.age_c##i.codprov##i.codprov_born) cluster(year#anac) version(5)
quietly sum nhijos if e(sample) [aw=weight2], meanonly
local mean_nhijos_proxy2 : display %4.2f r(mean)
outreg2 using "$tables/table_selected_birthplace_pre73_proxies.tex", append tex(frag) label ///
    keep(treat_2 treat_3) nocons ctitle("N. kids") ///
    addtext(Specification, Birthplace + current FE, ///
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

* ============================================================================
* SECTION 5. Existing Spanish barometer beliefs
* ----------------------------------------------------------------------------
* We do not add a new external beliefs exercise to the selected package.
* The retained beliefs discussion is the already existing single-wave Spanish
* barometer material in Marco/DO/new/Main_analysis.do, and it should be framed
* explicitly as suggestive evidence only.
*
* Revision-writing implication:
* the paper should state early and clearly that the 1945 reform is estimated
* as a bundled intervention. The beliefs material is therefore not a clean
* mechanism-identification exercise; it is only suggestive evidence on how
* women may have reacted to that broader reform package.
* ============================================================================

display as text "Beliefs note: keep the existing single-wave Spanish barometer block from Main_analysis.do; do not promote external IVS/Portugal results."

log close
