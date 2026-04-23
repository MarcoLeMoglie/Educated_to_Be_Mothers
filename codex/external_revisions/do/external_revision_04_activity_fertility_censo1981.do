version 17.0
clear all
set more off

capture log close

global root "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE"
global ext "$root/codex/external_revisions"
global extdata "$root/codex/external_data/processed"
global logs "$ext/logs"
global out "$ext/output"

log using "$logs/external_revision_04_activity_fertility_censo1981.log", replace text

display as text "Building fertility gap by economic activity and marriage timing"
use "$extdata/ine_01072_clean.dta", clear

keep if inlist(tipo_de_zona, "Total Nacional", "Zona rural", "Zona intermedia", "Zona urbana")
keep if actividad == "ECON. ACTIVAS" | actividad == "ECON. INACTIVAS"
drop if ano_de_la_boda == "TOTAL" | edad_de_la_mujer == "Total"

gen marriage_period = ""
replace marriage_period = "1951_1955" if ano_de_la_boda == "En 1951 a 1955"
replace marriage_period = "1956_1960" if ano_de_la_boda == "En 1956 a 1960"
replace marriage_period = "1961_1965" if ano_de_la_boda == "En 1961 a 1965"
replace marriage_period = "1966_1970" if inlist(ano_de_la_boda, "En 1966", "En 1967", "En 1968", "En 1969", "En 1970")
replace marriage_period = "1971_1975" if inlist(ano_de_la_boda, "En 1971", "En 1972", "En 1973", "En 1974", "En 1975")
replace marriage_period = "1976_1981" if inlist(ano_de_la_boda, "En 1976", "En 1977", "En 1978", "En 1979", "En 1980", "En 1981")
drop if marriage_period == ""

collapse (mean) avg_children = total, by(tipo_de_zona actividad marriage_period edad_de_la_mujer)
gen activity_code = ""
replace activity_code = "active" if actividad == "ECON. ACTIVAS"
replace activity_code = "inactive" if actividad == "ECON. INACTIVAS"
keep tipo_de_zona marriage_period edad_de_la_mujer activity_code avg_children
reshape wide avg_children, i(tipo_de_zona marriage_period edad_de_la_mujer) j(activity_code) string
gen active_minus_inactive = avg_childrenactive - avg_childreninactive
rename tipo_de_zona zone
rename edad_de_la_mujer age_group
save "$out/external_revision_04_activity_fertility_gap.dta", replace
export delimited using "$out/external_revision_04_activity_fertility_gap.csv", replace

preserve
keep if inlist(zone, "Total Nacional", "Zona rural", "Zona urbana")
keep if inlist(marriage_period, "1961_1965", "1966_1970", "1971_1975")
keep if inlist(age_group, "De 25 a 29 años", "De 30 a 34 años")
save "$out/external_revision_04_law56_window_cells.dta", replace
export delimited using "$out/external_revision_04_law56_window_cells.csv", replace
restore

display as text "Building 1981 female activity shares by territory"
use "$extdata/ine_01025_clean.dta", clear
keep if sexo == "Mujeres"
keep if inlist(ambito_territorial, "Total Nacional", "Zona rural", "Zona intermedia", "Zona urbana")
keep if inlist(tasa_de_actividad, "Total", "Activos")
reshape wide total, i(ambito_territorial) j(tasa_de_actividad) string
gen female_activity_share_1981 = totalActivos / totalTotal
save "$out/external_revision_04_female_activity_1981.dta", replace
export delimited using "$out/external_revision_04_female_activity_1981.csv", replace

display as text "Building female and male activity comparison by territory"
use "$extdata/ine_01025_clean.dta", clear
keep if inlist(ambito_territorial, "Total Nacional", "Zona rural", "Zona intermedia", "Zona urbana")
keep if inlist(tasa_de_actividad, "Tasa de actividad")
keep if inlist(sexo, "Mujeres", "Varones")
reshape wide total, i(ambito_territorial) j(sexo) string
gen female_male_activity_ratio = totalMujeres / totalVarones
gen activity_gap_male_minus_female = totalVarones - totalMujeres
save "$out/external_revision_04_sex_activity_gap_1981.dta", replace
export delimited using "$out/external_revision_04_sex_activity_gap_1981.csv", replace

display as text "Building female activity structure by territory"
use "$extdata/ine_01024_clean.dta", clear
keep if sexo == "Mujeres"
keep if inlist(ambito_territorial, "Total Nacional", "Zona rural", "Zona intermedia", "Zona urbana")
keep if inlist(relacion_con_la_actividad_econom, ///
    "Total", ///
    "Económicamente activa (Ocupados)", ///
    "Económicamente activa (Parados que buscan empleo por 1ª vez)", ///
    "Económicamente activa (Parados quehan trabajado anteriormente)", ///
    "Económicamente inactiva")
gen activity_code = ""
replace activity_code = "total" if relacion_con_la_actividad_econom == "Total"
replace activity_code = "occupied" if relacion_con_la_actividad_econom == "Económicamente activa (Ocupados)"
replace activity_code = "unemp_first" if relacion_con_la_actividad_econom == "Económicamente activa (Parados que buscan empleo por 1ª vez)"
replace activity_code = "unemp_prev" if relacion_con_la_actividad_econom == "Económicamente activa (Parados quehan trabajado anteriormente)"
replace activity_code = "inactive" if relacion_con_la_actividad_econom == "Económicamente inactiva"
keep ambito_territorial activity_code total
reshape wide total, i(ambito_territorial) j(activity_code) string
gen occupied_share_total = totaloccupied / totaltotal
gen unemployed_first_share_total = totalunemp_first / totaltotal
gen unemployed_prev_share_total = totalunemp_prev / totaltotal
gen inactive_share_total = totalinactive / totaltotal
gen active_share_total = occupied_share_total + unemployed_first_share_total + unemployed_prev_share_total
save "$out/external_revision_04_female_activity_structure_1981.dta", replace
export delimited using "$out/external_revision_04_female_activity_structure_1981.csv", replace

display as text "Building female sector composition by age"
use "$extdata/ine_01030_clean.dta", clear
keep if sexo == "Mujeres"
keep if ambito_poblacional == "Total nacional"
keep if inlist(grupos_de_edad, "De 25 a 29 años", "De 30 a 34 años", "De 35 a 39 años", "De 40 a 44 años")
drop if sectores_economicos == "Total"
bysort grupos_de_edad: egen denom = total(total)
gen sector_share = total / denom
rename grupos_de_edad age_group
save "$out/external_revision_04_female_sector_age_profile.dta", replace
export delimited using "$out/external_revision_04_female_sector_age_profile.csv", replace

log close
