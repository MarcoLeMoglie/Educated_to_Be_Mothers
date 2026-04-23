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
global extrev "$root/codex/external_revisions/output"

log using "$logs/external2_03_employment_support.log", replace text

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

import delimited using "$gen/bde_dt9409_series_annual.csv", clear varn(1)

keep if inrange(year, 1964, 1981)

gen occupied_total = annual_mean if description == "Encuesta de Población Activa. Ocupados. Total economía"
gen occupied_industry = annual_mean if description == "Encuesta de Población Activa. Ocupados. Industria"
gen occupied_construction = annual_mean if description == "Encuesta de Población Activa. Ocupados. Construcción"
gen occupied_services = annual_mean if description == "Encuesta de Población Activa. Ocupados. Servicios"
gen unemployed_total = annual_mean if description == "Encuesta de Población Activa. Parados. Total economía"
gen public_admin_wage = annual_mean if description == "Encuesta de Población Activa. Asalariados. Administración Pública"
gen private_wage = annual_mean if description == "Encuesta de Población Activa. Asalariados. Sector privado"

collapse ///
    (max) occupied_total occupied_industry occupied_construction occupied_services unemployed_total public_admin_wage private_wage, ///
    by(year)

gen industry_share = occupied_industry / occupied_total
gen construction_share = occupied_construction / occupied_total
gen services_share = occupied_services / occupied_total
gen unemployment_share = unemployed_total / (occupied_total + unemployed_total)
gen public_admin_share_wage = public_admin_wage / (public_admin_wage + private_wage)
gen post73 = year >= 1973
gen trend = year - 1964
gen post73_trend = post73 * (year - 1973)

tempfile bde_results
tempname posth
postfile `posth' str24 outcome str32 spec str24 coefname double b se p N using "`bde_results'", replace

foreach outcome in industry_share construction_share services_share unemployment_share public_admin_share_wage {
    quietly reg `outcome' post73 c.trend c.post73_trend, vce(robust)
    post_selected, handle(`posth') outcome("`outcome'") spec("break_1973_annual") ///
        coefs("post73 trend post73_trend")
}

postclose `posth'

use "`bde_results'", clear
sort outcome spec coefname
save "$out/external2_03_bde_break_results.dta", replace
export delimited using "$out/external2_03_bde_break_results.csv", replace

import delimited using "$gen/bde_dt9409_series_annual.csv", clear varn(1)
keep if inrange(year, 1964, 1981)
gen occupied_total = annual_mean if description == "Encuesta de Población Activa. Ocupados. Total economía"
gen occupied_industry = annual_mean if description == "Encuesta de Población Activa. Ocupados. Industria"
gen occupied_construction = annual_mean if description == "Encuesta de Población Activa. Ocupados. Construcción"
gen occupied_services = annual_mean if description == "Encuesta de Población Activa. Ocupados. Servicios"
gen unemployed_total = annual_mean if description == "Encuesta de Población Activa. Parados. Total economía"
gen public_admin_wage = annual_mean if description == "Encuesta de Población Activa. Asalariados. Administración Pública"
gen private_wage = annual_mean if description == "Encuesta de Población Activa. Asalariados. Sector privado"
collapse ///
    (max) occupied_total occupied_industry occupied_construction occupied_services unemployed_total public_admin_wage private_wage, ///
    by(year)
gen industry_share = occupied_industry / occupied_total
gen construction_share = occupied_construction / occupied_total
gen services_share = occupied_services / occupied_total
gen unemployment_share = unemployed_total / (occupied_total + unemployed_total)
gen public_admin_share_wage = public_admin_wage / (public_admin_wage + private_wage)
gen period = "1964_1972"
replace period = "1973_1981" if year >= 1973
collapse (mean) occupied_total occupied_industry occupied_construction occupied_services unemployed_total ///
    industry_share construction_share services_share unemployment_share public_admin_share_wage, by(period)
save "$out/external2_03_bde_period_means.dta", replace
export delimited using "$out/external2_03_bde_period_means.csv", replace

import delimited using "$extrev/external_revision_04_female_activity_structure_1981.csv", clear varn(1)
keep ambito_territorial occupied_share_total unemployed_first_share_total unemployed_prev_share_total inactive_share_total active_share_total
sort ambito_territorial
save "$out/external2_03_female_activity_structure_1981_copy.dta", replace
export delimited using "$out/external2_03_female_activity_structure_1981_copy.csv", replace

log close
