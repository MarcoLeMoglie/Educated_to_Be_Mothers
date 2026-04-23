version 17.0
clear all
set more off

capture log close

global root "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE"
global datain2 "$root/original_data/INE_microdatos/"
global province "$root/output_data/dataset_PROVINCElevel.dta"
global codex "$root/codex"
global out "$codex/output"
global logs "$codex/logs"

log using "$logs/revision_07_birthplace_civilwar.log", replace text

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

display as text "Preparing province-level war-intensity controls"
preserve
use "$province", clear
keep codprov sh_area_front logdistance sancionados
rename codprov codprov_born
duplicates drop
tempfile province_controls
save "`province_controls'"
restore

display as text "Preparing 1991 census sample"
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

tempfile c1991
save "`c1991'"

display as text "Preparing 2011 census sample"
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

append using "`c1991'"

merge m:1 codprov_born using "`province_controls'", keep(match master) nogen

gen treat = .
replace treat = 0 if anac <= 1929
replace treat = 1 if anac > 1929 & anac < 1939
replace treat = 2 if anac >= 1939
tab treat, gen(treat_)

gen weight2 = fe if year == 1991
replace weight2 = factor if year == 2011

gen age_c = floor(edad / 10)

gen front_treat2 = sh_area_front * treat_2 if sh_area_front < .
gen front_treat3 = sh_area_front * treat_3 if sh_area_front < .

tempfile war_results
tempname posth
postfile `posth' str12 sample str12 outcome str24 spec str24 coefname double b se p N using "`war_results'", replace

foreach outcome in kids2 nhijos {
    quietly reghdfe `outcome' treat_2 treat_3 if sexo == 6 & inrange(anac, 1920, 1950) [aw=weight2], ///
        a(cmun##i.age_c##year##i.codprov_born) cluster(year#anac) version(5)
    post_selected_coefs, handle(`posth') sample("census") outcome("`outcome'") spec("birthprov_fe") ///
        coefs("treat_2 treat_3")

    quietly reghdfe `outcome' treat_2 treat_3 front_treat2 front_treat3 ///
        if sexo == 6 & inrange(anac, 1920, 1950) [aw=weight2], ///
        a(cmun##i.age_c##year##i.codprov_born) cluster(year#anac) version(5)
    post_selected_coefs, handle(`posth') sample("census") outcome("`outcome'") spec("birthprov_front") ///
        coefs("treat_2 treat_3 front_treat2 front_treat3")

    quietly reghdfe `outcome' treat_2 treat_3 if sexo == 6 & inrange(anac, 1920, 1950) [aw=weight2], ///
        a(i.year##i.age_c##i.codprov##i.codprov_born) cluster(year#anac) version(5)
    post_selected_coefs, handle(`posth') sample("census") outcome("`outcome'") spec("birth_current_fe") ///
        coefs("treat_2 treat_3")

    quietly reghdfe `outcome' treat_2 treat_3 front_treat2 front_treat3 ///
        if sexo == 6 & inrange(anac, 1920, 1950) [aw=weight2], ///
        a(i.year##i.age_c##i.codprov##i.codprov_born) cluster(year#anac) version(5)
    post_selected_coefs, handle(`posth') sample("census") outcome("`outcome'") spec("birth_current_front") ///
        coefs("treat_2 treat_3 front_treat2 front_treat3")
}

postclose `posth'

use "`war_results'", clear
sort outcome spec coefname
save "$out/revision_07_birthplace_civilwar_results.dta", replace
export delimited using "$out/revision_07_birthplace_civilwar_results.csv", replace

log close
