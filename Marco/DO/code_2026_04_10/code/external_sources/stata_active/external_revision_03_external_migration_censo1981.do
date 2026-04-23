version 17.0
clear all
set more off

capture log close

global root "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE"
global ext "$root/codex/external_revisions"
global extdata "$root/codex/external_data/processed"
global logs "$ext/logs"
global out "$ext/output"

log using "$logs/external_revision_03_external_migration_censo1981.log", replace text

capture program drop post_selected_coefs
program define post_selected_coefs
    syntax , Handle(name) Spec(string) Coefs(string)

    foreach coef of local coefs {
        capture scalar b = _b[`coef']
        if _rc == 0 {
            scalar se = _se[`coef']
            capture scalar p = 2 * ttail(e(df_r), abs(b / se))
            if _rc != 0 {
                scalar p = .
            }
            capture scalar r2 = e(r2)
            if _rc != 0 {
                scalar r2 = .
            }
            post `handle' ("`spec'") ("`coef'") (b) (se) (p) (e(N)) (r2)
        }
    }
end

display as text "Building mover/stayer activity table for women"
use "$extdata/ine_01057_clean.dta", clear
keep if sexo == "MUJERES"
keep if inlist(grupos_de_edad, "de 16 a 24 años", "de 25 a 34", "de 35 a 44")
keep if inlist(relacion_municipio_1970_y_1981, ///
    "EN EL MISMO MUNICIPIO QUE EN 1981", ///
    "EN DISTINTO MUNICIPIO QUE EN 1981", ///
    "Misma Provincia, Total", ///
    "Misma CCAA, distinta Provincia, Total", ///
    "Distinta CCAA, Total")
keep if inlist(activos, "Total", "Activos")
reshape wide total, i(relacion_municipio_1970_y_1981 grupos_de_edad) j(activos) string
gen active_share = totalActivos / totalTotal
rename relacion_municipio_1970_y_1981 mobility_status
rename grupos_de_edad age_group
tempfile female_active
save "`female_active'"

display as text "Building mover/stayer employment table for women"
use "$extdata/ine_01058_clean.dta", clear
keep if sexo == "MUJERES"
keep if inlist(grupos_de_edad, "de 16 a 24 años", "de 25 a 34", "de 35 a 44")
keep if inlist(relacion_municipio_1970_y_1981, ///
    "EN EL MISMO MUNICIPIO QUE EN 1981", ///
    "EN DISTINTO MUNICIPIO QUE EN 1981", ///
    "Misma Provincia, Total", ///
    "Misma CCAA, distinta Provincia, Total", ///
    "Distinta CCAA, Total")
keep if inlist(ocupados_parados, "Ocupados", "Parados")
reshape wide total, i(relacion_municipio_1970_y_1981 grupos_de_edad) j(ocupados_parados) string
gen labor_force = totalOcupados + totalParados
gen employed_share = totalOcupados / labor_force
rename relacion_municipio_1970_y_1981 mobility_status
rename grupos_de_edad age_group
merge 1:1 mobility_status age_group using "`female_active'", nogen
save "$out/external_revision_03_female_mobility_activity.dta", replace
export delimited using "$out/external_revision_03_female_mobility_activity.csv", replace

display as text "Building sector composition among female movers and stayers"
use "$extdata/ine_01059_clean.dta", clear
keep if sexo == "MUJERES"
keep if inlist(relacion_municipio_1970_y_1981, ///
    "EN EL MISMO MUNICIPIO QUE EN 1981", ///
    "EN DISTINTO MUNICIPIO QUE EN 1981", ///
    "Misma Provincia, Total", ///
    "Misma CCAA, distinta Provincia, Total", ///
    "Distinta CCAA, Total")
drop if rama_de_actividad == "TOTAL" | rama_de_actividad == "No Clasificables"
bysort relacion_municipio_1970_y_1981: egen denom = total(total)
gen sector_share = total / denom
rename relacion_municipio_1970_y_1981 mobility_status
save "$out/external_revision_03_female_mobility_sectors.dta", replace
export delimited using "$out/external_revision_03_female_mobility_sectors.csv", replace

display as text "Building province-level staying shares"
use "$extdata/ine_01061_clean.dta", clear
drop if provincia_de_residencia_en_1970 == "Total" | provincia_de_residencia_en_1981 == "Total"
gen same_province = provincia_de_residencia_en_1970 == provincia_de_residencia_en_1981
bysort provincia_de_residencia_en_1970: egen origin_total = total(total)
gen stayers = total if same_province == 1
bysort provincia_de_residencia_en_1970: egen total_stayers = total(stayers)
keep provincia_de_residencia_en_1970 origin_total total_stayers
duplicates drop
gen stay_share = total_stayers / origin_total
rename provincia_de_residencia_en_1970 origin_province
save "$out/external_revision_03_province_stay_share_1970_1981.dta", replace
export delimited using "$out/external_revision_03_province_stay_share_1970_1981.csv", replace

display as text "Linking province-level stay shares to baseline treatment intensity"
tempfile province_treatment
use "$root/output_data/dataset.dta", clear
keep if year == 1940
gen sum1 = (popsharewomen_agegroup1_1940 + popsharewomen_agegroup2_1940) * 100
gen sum2 = (popsharemen_agegroup1_1940 + popsharemen_agegroup2_1940) * 100
gen type_tag = cond(type == "municipality", "muni", "rest")
keep codprov province type_tag sum1 sum2 pop_1940
reshape wide sum1 sum2 pop_1940, i(codprov province) j(type_tag) string
gen treat_gap_f = sum1muni - sum1rest
gen treat_gap_m = sum2muni - sum2rest
gen muni_share_1940 = pop_1940muni / (pop_1940muni + pop_1940rest)
save "`province_treatment'"

use "$out/external_revision_03_province_stay_share_1970_1981.dta", clear
drop if inlist(origin_province, "Ceuta", "Melilla", "Extranjero y otros")
gen codprov = .
replace codprov = 1 if origin_province == "Álava"
replace codprov = 2 if origin_province == "Albacete"
replace codprov = 3 if origin_province == "Alicante"
replace codprov = 4 if origin_province == "Almería"
replace codprov = 5 if origin_province == "Ávila"
replace codprov = 6 if origin_province == "Badajoz"
replace codprov = 7 if origin_province == "Baleares"
replace codprov = 8 if origin_province == "Barcelona"
replace codprov = 9 if origin_province == "Burgos"
replace codprov = 10 if origin_province == "Cáceres"
replace codprov = 11 if origin_province == "Cádiz"
replace codprov = 12 if origin_province == "Castellón"
replace codprov = 13 if origin_province == "Ciudad Real"
replace codprov = 14 if origin_province == "Córdoba"
replace codprov = 15 if origin_province == "Coruña (La)"
replace codprov = 16 if origin_province == "Cuenca"
replace codprov = 17 if origin_province == "Gerona"
replace codprov = 18 if origin_province == "Granada"
replace codprov = 19 if origin_province == "Guadalajara"
replace codprov = 20 if origin_province == "Guipúzcoa"
replace codprov = 21 if origin_province == "Huelva"
replace codprov = 22 if origin_province == "Huesca"
replace codprov = 23 if origin_province == "Jaén"
replace codprov = 24 if origin_province == "León"
replace codprov = 25 if origin_province == "Lérida"
replace codprov = 26 if origin_province == "Rioja (La)"
replace codprov = 27 if origin_province == "Lugo"
replace codprov = 28 if origin_province == "Madrid"
replace codprov = 29 if origin_province == "Málaga"
replace codprov = 30 if origin_province == "Murcia"
replace codprov = 31 if origin_province == "Navarra"
replace codprov = 32 if origin_province == "Orense"
replace codprov = 33 if origin_province == "Asturias"
replace codprov = 34 if origin_province == "Palencia"
replace codprov = 35 if origin_province == "Palmas (Las)"
replace codprov = 36 if origin_province == "Pontevedra"
replace codprov = 37 if origin_province == "Salamanca"
replace codprov = 38 if origin_province == "S.C.Tenerife"
replace codprov = 39 if origin_province == "Santander"
replace codprov = 40 if origin_province == "Segovia"
replace codprov = 41 if origin_province == "Sevilla"
replace codprov = 42 if origin_province == "Soria"
replace codprov = 43 if origin_province == "Tarragona"
replace codprov = 44 if origin_province == "Teruel"
replace codprov = 45 if origin_province == "Toledo"
replace codprov = 46 if origin_province == "Valencia"
replace codprov = 47 if origin_province == "Valladolid"
replace codprov = 48 if origin_province == "Vizcaya"
replace codprov = 49 if origin_province == "Zamora"
replace codprov = 50 if origin_province == "Zaragoza"
merge 1:1 codprov using "`province_treatment'", keep(match) nogen
gen ln_origin_total = ln(origin_total)
save "$out/external_revision_03_province_mobility_link.dta", replace
export delimited using "$out/external_revision_03_province_mobility_link.csv", replace

tempfile province_regs
tempname posth
postfile `posth' str32 spec str24 coefname double b se p N r2 using "`province_regs'", replace

reg stay_share sum1muni sum2muni, vce(robust)
post_selected_coefs, handle(`posth') spec("stay_on_levels") coefs("sum1muni sum2muni")

reg stay_share treat_gap_f treat_gap_m, vce(robust)
post_selected_coefs, handle(`posth') spec("stay_on_gaps") coefs("treat_gap_f treat_gap_m")

reg stay_share sum1muni sum2muni muni_share_1940 ln_origin_total, vce(robust)
post_selected_coefs, handle(`posth') spec("stay_on_levels_ctrl") coefs("sum1muni sum2muni muni_share_1940 ln_origin_total")

reg stay_share treat_gap_f treat_gap_m muni_share_1940 ln_origin_total, vce(robust)
post_selected_coefs, handle(`posth') spec("stay_on_gaps_ctrl") coefs("treat_gap_f treat_gap_m muni_share_1940 ln_origin_total")

postclose `posth'
use "`province_regs'", clear
sort spec coefname
save "$out/external_revision_03_province_mobility_regs.dta", replace
export delimited using "$out/external_revision_03_province_mobility_regs.csv", replace

log close
