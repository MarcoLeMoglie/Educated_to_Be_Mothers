version 17.0
clear all
set more off
set varabbrev off

do "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/Marco/DO/code_2026_04_10/code/00_globals.do"

capture log close
log using "$rep_logs/01_build_final_analysis_data.log", replace text

* ============================================================================
* Build minimal final analysis datasets used by the CURRENT paper
* ----------------------------------------------------------------------------
* This script does not rebuild the original raw sources from scratch. Instead,
* it performs the last-mile step that every replication package should expose:
* it creates a small set of final .dta files that contain only the variables
* needed by the current paper's main text and appendix.
*
* Why keep separate final datasets instead of one giant file?
* - The paper uses conceptually distinct designs:
*   1. CIS repeated cross-sections
*   2. Census microdata
*   3. Macro locality-by-year panel
*   4. External 1981 census tabulations and externally-built province proxies
* - Keeping them separate makes the replication workflow easier to read and
*   limits each file to the variables actually needed by that design.
* ============================================================================

* ----------------------------------------------------------------------------
* SECTION A. CIS analysis dataset
* ----------------------------------------------------------------------------
* This is the minimal individual-level survey file used for:
* - main text Table "table_baseline" and Figure "nkids_female"
* - Appendix cluster-robustness table
* - Appendix employment / education / ideology table
* - Appendix Law 56 horse-race
* - the beliefs figure discussed in the mechanisms section
*
* The raw CIS file contains many additional fields. Here we only keep the
* variables needed to re-create the derived treatment indicators, the fertility
* outcomes, the main mechanism outcomes, and the attitudes block used in Figure
* 3 of the paper.
* ----------------------------------------------------------------------------
use "$raw_cis/barometros.dta", clear

drop if year_birth < 1910
keep if inrange(year_birth, 1920, 1970)

* Survey-age bins used repeatedly in the CIS specifications.
gen age_c = floor(age / 10)
label var age_c "Age class (10-year bins)"

* Cohort-treatment indicators used throughout the paper.
gen treat = .
replace treat = 0 if year_birth <= 1929
replace treat = 1 if year_birth > 1929 & year_birth < 1939
replace treat = 2 if year_birth >= 1939
tab treat, gen(treat_)
label var treat  "Cohort exposure group"
label var treat_2 "1930/1938"
label var treat_3 "1939/1950"

* Extensive-margin fertility is missing when a respondent has zero children.
* We explicitly set those observations to zero so that "kids" becomes usable as
* a binary fertility outcome in the baseline table.
replace kids = 0 if nkids == 0 & missing(kids)
label var kids  "Has at least one child"
label var nkids "N. kids"

* Labor-market outcomes used in the mechanisms table.
* In the harmonized CIS file the raw variable is called "lab_situation".
gen lab2_1 = 1 if lab_situation == 1
replace lab2_1 = 0 if inlist(lab_situation, 2, 5)
label var lab2_1 "Employed"

gen lab2_2 = 1 if lab_situation == 2
replace lab2_2 = 0 if inlist(lab_situation, 1, 5)
label var lab2_2 "Unemployed"

gen lab2_5 = 1 if lab_situation == 5
replace lab2_5 = 0 if inlist(lab_situation, 1, 2)
label var lab2_5 "Housewife"

* Education recoding used in the original main analysis.
gen edu = education == 5 if education < .
label var edu "Tertiary education"

* Merge the cohort-level Law 56 timing measure used in the horse-race.
merge m:1 year_birth using "$raw_generated/law56_cohort_exposure.dta", keep(match master) nogen
label var law56_share_20_35 "Share of ages 20-35 lived after 1961"

* Keep only the beliefs outcomes that are actually plotted/discussed now.
local belief_vars ideal_fam_equal school_meet_wife absentwork_wife ///
    husb_lesshouseworks stab_sharehousework stab_kids realwoman_kids ///
    women_work import_work2 stab_wifework pro_abort_church pro_art_fert pro_contracep

local keep_cis codprov id type year year_birth age age_c female ///
    kids nkids treat treat_2 treat_3 lab2_1 lab2_2 lab2_5 edu right ///
    law56_share_20_35

foreach v of local belief_vars {
    capture confirm variable `v'
    if !_rc {
        local keep_cis `keep_cis' `v'
    }
}

keep `keep_cis'

label var codprov "Province code"
label var id      "Residence unit identifier"
label var type    "Residence-unit type"
label var year    "Survey year"
label var year_birth "Birth year"
label var age     "Age at interview"
label var female  "Female respondent"
capture label var right "Right-wing vote"
capture label var ideal_fam_equal "Both spouses should work equally"
capture label var school_meet_wife "School meeting: wife should attend"
capture label var absentwork_wife "Wife should miss work for family"
capture label var husb_lesshouseworks "Husband should do less housework"
capture label var stab_sharehousework "Shared housework helps stability"
capture label var stab_kids "Children help couple stability"
capture label var realwoman_kids "A real woman has children"
capture label var women_work "Women should work"
capture label var import_work2 "Importance of working for women"
capture label var stab_wifework "Wife working helps stability"
capture label var pro_abort_church "Agree with Church on abortion"
capture label var pro_art_fert "Agree with Church on artificial fertility"
capture label var pro_contracep "Agree with Church on contraception"

compress
save "$rep_data/final_cis_analysis.dta", replace

* ----------------------------------------------------------------------------
* SECTION B. Census analysis dataset
* ----------------------------------------------------------------------------
* This final file is used for:
* - main text census table
* - birthplace / movers-stayers appendix table
* - birthplace Civil War control
* - birthplace oil-structure controls
*
* We harmonize the 1991 and 2011 census microdata exactly along the dimensions
* used in the paper: year of birth, current municipality/province, birthplace
* province, fertility outcomes, weights, and the extra birthplace-level merges.
* ----------------------------------------------------------------------------
tempfile c1991

use "$raw_census/censo1991/por_provincias/censo1991_provincias.dta", clear
rename *, lower

replace fecha = . if fecha > 100
gen anac = 1992 - fecha
keep if inrange(anac, 1920, 1970)

gen kids2 = hijos > 0 if hijos < .
label var kids2 "Has at least one child"
gen year = 1991

rename mun cmun
rename prov codprov
rename pronacin codprov_born
rename hijos nhijos
gen weight2 = fe

keep year anac edad sexo cmun codprov codprov_born nhijos kids2 weight2
save "`c1991'", replace

use "$raw_census/censo2011/por_provincias/censo2011_provincias.dta", clear
rename *, lower
keep if inrange(anac, 1920, 1970)

gen kids2 = hijos == 1 if hijos < .
replace nhijos = 0 if kids2 == 0
gen year = 2011

rename cpro codprov
rename cpron codprov_born
rename factor weight2

keep year anac edad sexo cmun codprov codprov_born nhijos kids2 weight2
append using "`c1991'"

gen age_c = floor(edad / 10)
label var age_c "Age class (10-year bins)"

gen treat = .
replace treat = 0 if anac <= 1929
replace treat = 1 if anac > 1929 & anac < 1939
replace treat = 2 if anac >= 1939
tab treat, gen(treat_)
label var treat   "Cohort exposure group"
label var treat_2 "1930/1938"
label var treat_3 "1939/1950"

gen stayer_birthprov = codprov == codprov_born if codprov < . & codprov_born < .
gen mover_birthprov  = 1 - stayer_birthprov if stayer_birthprov < .
label var stayer_birthprov "Lives in province of birth"
label var mover_birthprov  "Lives outside province of birth"

* Birthplace-level Civil War proxy. The province-level source stores the key as
* "codprov", so we rename it in a temporary file before merging on birthplace.
tempfile province_war
preserve
use "$raw_macro/dataset_PROVINCElevel.dta", clear
keep codprov sh_area_front
duplicates drop
rename codprov codprov_born
save "`province_war'", replace
restore

merge m:1 codprov_born using "`province_war'", keep(match master) nogen
label var sh_area_front "Birth-province war-front exposure"

* Birthplace-level pre-1973 economic structure proxies used in the oil-shock
* robustness block.
tempfile province_pre73
preserve
use "$raw_extrev/generated/province_pre73_crisis_proxies.dta", clear
keep codprov industrial_core_share_1950 oil_sensitive_share_1950 ///
    manuf_trade_share_1950 nonag_share_1950 proxy_usable_pre73
duplicates drop
rename codprov codprov_born
save "`province_pre73'", replace
restore

merge m:1 codprov_born using "`province_pre73'", keep(match master) nogen

label var year "Census year"
label var anac "Birth year"
label var edad "Age"
label var sexo "Sex"
label var cmun "Current municipality code"
label var codprov "Current province code"
label var codprov_born "Birth province code"
label var nhijos "N. kids"
label var weight2 "Person weight"
label var industrial_core_share_1950 "Industrial core share, 1950"
label var oil_sensitive_share_1950   "Oil-sensitive share, 1950"
label var manuf_trade_share_1950     "Manufacturing and trade share, 1950"
label var nonag_share_1950           "Non-agricultural share, 1950"
label var proxy_usable_pre73         "Usable pre-1973 proxy sample"

keep year anac edad sexo cmun codprov codprov_born weight2 nhijos kids2 ///
    age_c treat treat_2 treat_3 stayer_birthprov mover_birthprov ///
    sh_area_front industrial_core_share_1950 oil_sensitive_share_1950 ///
    manuf_trade_share_1950 nonag_share_1950 proxy_usable_pre73

label var kids2 "Has at least one child"
compress
save "$rep_data/final_census_analysis.dta", replace

* ----------------------------------------------------------------------------
* SECTION C. Macro locality-by-year panel
* ----------------------------------------------------------------------------
* This is the final aggregate panel used for:
* - main macro table and event study
* - main macro robustness table
* - balancing tests
* - marriage placebo
* - post-1973 heterogeneity with pre-1973 provincial structure
*
* We keep the variables required to reconstruct treatment intensity, the age-
* composition controls, the balancing covariates, and the predetermined sector
* proxies merged at the province level.
* ----------------------------------------------------------------------------
use "$raw_macro/dataset.dta", clear

capture confirm variable alive
if _rc != 0 {
    gen alive = alive_birth
}

merge m:1 codprov using "$raw_extrev/generated/province_pre73_crisis_proxies.dta", ///
    keepusing(industrial_core_share_1950 oil_sensitive_share_1950 ///
              manuf_trade_share_1950 nonag_share_1950 proxy_usable_pre73 ///
              industrial_core_share_1950_cap oil_sensitive_share_1950_cap ///
              manuf_trade_share_1950_cap nonag_share_1950_cap proxy_usable_pre73_cap ///
              industrial_core_share_1950_rest oil_sensitive_share_1950_rest ///
              manuf_trade_share_1950_rest nonag_share_1950_rest proxy_usable_pre73_rest) ///
    keep(match master) nogen

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

label var alive "Births"
capture label var alive_birth "Births"
capture label var total_wedding "Marriages"
label var year "Calendar year"
label var province "Province name"
label var codauto "Region code"
label var geo_name "Administrative-unit name"
label var type "Administrative-unit type"
label var id "Administrative-unit identifier"
label var post "Post-1945 indicator"
label var pop_1930 "Population, 1930"
label var pop_1940 "Population, 1940"
label var pop_1950 "Population, 1950"
label var pop_1960 "Population, 1960"
label var pop_1970 "Population, 1970"
label var popsharewomen_agegroup1_1940 "Female share, age group 1, 1940"
label var popsharewomen_agegroup2_1940 "Female share, age group 2, 1940"
label var popsharewomen_agegroup3_1940 "Female share, age group 3, 1940"
label var popsharewomen_agegroup4_1940 "Female share, age group 4, 1940"
label var popsharewomen_agegroup5_1940 "Female share, age group 5, 1940"
label var popsharemen_agegroup1_1940 "Male share, age group 1, 1940"
label var popsharemen_agegroup2_1940 "Male share, age group 2, 1940"
label var pop_agegroup2_1940 "Population, age group 2, 1940"
label var pop_agegroup3_1940 "Population, age group 3, 1940"
label var pop_agegroup4_1940 "Population, age group 4, 1940"
label var pop_agegroup5_1940 "Population, age group 5, 1940"
label var teachers "Purged teachers"
label var relig_com_total1930 "Religious communities, 1930"
label var professed_total1930 "Professed clergy, 1930"
label var novice_total1930 "Novices, 1930"
label var lay_total1930 "Lay members, 1930"
label var share_republicanos1931 "Republican vote share, 1931"
label var share_socialistas1931 "Socialist vote share, 1931"
label var share_monarquicos1931 "Monarchist vote share, 1931"
label var share_comunistas1931 "Communist vote share, 1931"
label var adictos "Supporters of the regime, 1948"
label var nat_school_total42 "National schools, 1942"
label var teachersprimary_total42 "Primary-school teachers, 1942"
label var enrolled_students42 "Enrolled students, 1942"
label var sh_area_front "Share of province on Civil War front"
label var industrial_core_share_1950 "Industrial core share, 1950"
label var oil_sensitive_share_1950   "Oil-sensitive share, 1950"
label var manuf_trade_share_1950     "Manufacturing and trade share, 1950"
label var nonag_share_1950           "Non-agricultural share, 1950"
label var proxy_usable_pre73         "Usable pre-1973 proxy sample"
label var industrial_core_share_1950_cap "Industrial core share, 1950 (capital)"
label var oil_sensitive_share_1950_cap   "Oil-sensitive share, 1950 (capital)"
label var manuf_trade_share_1950_cap     "Manufacturing and trade share, 1950 (capital)"
label var nonag_share_1950_cap           "Non-agricultural share, 1950 (capital)"
label var proxy_usable_pre73_cap         "Usable pre-1973 capital proxy sample"
label var industrial_core_share_1950_rest "Industrial core share, 1950 (rest province)"
label var oil_sensitive_share_1950_rest   "Oil-sensitive share, 1950 (rest province)"
label var manuf_trade_share_1950_rest     "Manufacturing and trade share, 1950 (rest province)"
label var nonag_share_1950_rest           "Non-agricultural share, 1950 (rest province)"
label var proxy_usable_pre73_rest         "Usable pre-1973 rest-of-province proxy sample"
label var industrial_core_share_1950_area "Industrial core share, 1950 (capital/rest assigned)"
label var oil_sensitive_share_1950_area   "Oil-sensitive share, 1950 (capital/rest assigned)"
label var manuf_trade_share_1950_area     "Manufacturing and trade share, 1950 (capital/rest assigned)"
label var nonag_share_1950_area           "Non-agricultural share, 1950 (capital/rest assigned)"
label var proxy_usable_pre73_area         "Usable pre-1973 paired capital/rest sample"

foreach yr in 1930 1940 1950 1960 1970 {
    capture label var popwomen_agegroup2_`yr' "Female population, age group 2, `yr'"
    capture label var popwomen_agegroup3_`yr' "Female population, age group 3, `yr'"
    capture label var popwomen_agegroup4_`yr' "Female population, age group 4, `yr'"
    capture label var popwomen_agegroup5_`yr' "Female population, age group 5, `yr'"
}

keep year province codprov codmun codauto geo_name type id post alive alive_birth ///
    total_wedding pop_1930 pop_1940 pop_1950 pop_1960 pop_1970 ///
    pop_agegroup2_1940 pop_agegroup3_1940 pop_agegroup4_1940 pop_agegroup5_1940 ///
    popsharewomen_agegroup1_1940 popsharewomen_agegroup2_1940 ///
    popsharewomen_agegroup3_1940 popsharewomen_agegroup4_1940 popsharewomen_agegroup5_1940 ///
    popsharemen_agegroup1_1940 popsharemen_agegroup2_1940 ///
    popwomen_agegroup2_1930 popwomen_agegroup2_1940 popwomen_agegroup2_1950 popwomen_agegroup2_1960 popwomen_agegroup2_1970 ///
    popwomen_agegroup3_1930 popwomen_agegroup3_1940 popwomen_agegroup3_1950 popwomen_agegroup3_1960 popwomen_agegroup3_1970 ///
    popwomen_agegroup4_1930 popwomen_agegroup4_1940 popwomen_agegroup4_1950 popwomen_agegroup4_1960 popwomen_agegroup4_1970 ///
    popwomen_agegroup5_1930 popwomen_agegroup5_1940 popwomen_agegroup5_1950 popwomen_agegroup5_1960 popwomen_agegroup5_1970 ///
    teachers relig_com_total1930 professed_total1930 novice_total1930 lay_total1930 ///
    share_republicanos1931 share_socialistas1931 share_monarquicos1931 share_comunistas1931 ///
    adictos nat_school_total42 teachersprimary_total42 enrolled_students42 ///
    sh_area_front deaths_male_cwar deaths_female_cwar ///
    industrial_core_share_1950 oil_sensitive_share_1950 manuf_trade_share_1950 nonag_share_1950 proxy_usable_pre73 ///
    industrial_core_share_1950_cap oil_sensitive_share_1950_cap manuf_trade_share_1950_cap nonag_share_1950_cap proxy_usable_pre73_cap ///
    industrial_core_share_1950_rest oil_sensitive_share_1950_rest manuf_trade_share_1950_rest nonag_share_1950_rest proxy_usable_pre73_rest ///
    industrial_core_share_1950_area oil_sensitive_share_1950_area manuf_trade_share_1950_area nonag_share_1950_area proxy_usable_pre73_area

compress
save "$rep_data/final_macro_panel_analysis.dta", replace

* ----------------------------------------------------------------------------
* SECTION D. External final datasets already built upstream
* ----------------------------------------------------------------------------
* These files are already very close to publication-ready, but here we copy and
* relabel them into the package so that the entire paper can be run from one
* folder without hunting through the larger project tree.
* ----------------------------------------------------------------------------

use "$raw_generated/law56_cohort_exposure.dta", clear
label var year_birth "Birth year"
label var law56_share_18_30 "Share of ages 18-30 lived after 1961"
label var law56_share_20_35 "Share of ages 20-35 lived after 1961"
label var law56_share_25_35 "Share of ages 25-35 lived after 1961"
label var crisis73_share_25_35 "Share of ages 25-35 lived after 1973"
label var law56_age_in_1961 "Age in 1961"
label var law56_post1961_under25 "Younger than 25 in 1961"
save "$rep_data/final_law56_cohort_exposure.dta", replace

use "$raw_extrev/generated/province_pre73_crisis_proxies.dta", clear
label var codprov "Province code"
label var province "Province name"
label var popsharewomen_agegroup1_1970 "Female share, age group 1, 1970"
label var popsharewomen_agegroup2_1970 "Female share, age group 2, 1970"
label var popsharemen_agegroup1_1970 "Male share, age group 1, 1970"
label var popsharemen_agegroup2_1970 "Male share, age group 2, 1970"
label var popsharewomen_agegroup1_1960 "Female share, age group 1, 1960"
label var popsharewomen_agegroup2_1960 "Female share, age group 2, 1960"
label var popsharemen_agegroup1_1960 "Male share, age group 1, 1960"
label var popsharemen_agegroup2_1960 "Male share, age group 2, 1960"
label var source_page_viii "Source page in Censo 1950, Cuadro VIII"
label var raw_chunk_viii "Raw parsed text chunk from Cuadro VIII"
label var parsed_token_count_viii "Parsed token count, Cuadro VIII"
label var active_total_1950 "Active population, 1950"
label var agri_total_1950 "Agriculture workers, 1950"
label var mining_total_1950 "Mining workers, 1950"
label var manufacturing_total_1950 "Manufacturing workers, 1950"
label var construction_total_1950 "Construction workers, 1950"
label var utilities_total_1950 "Utilities workers, 1950"
label var commerce_total_1950 "Commerce workers, 1950"
label var transport_total_1950 "Transport workers, 1950"
label var services_total_1950 "Service workers, 1950"
label var unspecified_total_1950 "Unspecified workers, 1950"
label var sector_sum_viii "Sum across sector counts"
label var sector_gap_viii "Gap between active total and sector sum"
label var sector_gap_share_viii "Sector gap share"
label var usable_viii "Usable Cuadro VIII extraction"
label var agri_share_1950 "Agriculture share, 1950"
label var mining_share_1950 "Mining share, 1950"
label var manufacturing_share_1950 "Manufacturing share, 1950"
label var construction_share_1950 "Construction share, 1950"
label var utilities_share_1950 "Utilities share, 1950"
label var commerce_share_1950 "Commerce share, 1950"
label var transport_share_1950 "Transport share, 1950"
label var services_share_1950 "Services share, 1950"
label var unspecified_share_1950 "Unspecified share, 1950"
label var industrial_core_share_1950 "Industrial core share, 1950"
label var oil_sensitive_share_1950   "Oil-sensitive share, 1950"
label var manuf_trade_share_1950     "Manufacturing and trade share, 1950"
label var nonag_share_1950           "Non-agricultural share, 1950"
capture label var industrial_core_share_1950_cap "Industrial core share, 1950 (capital)"
capture label var oil_sensitive_share_1950_cap   "Oil-sensitive share, 1950 (capital)"
capture label var manuf_trade_share_1950_cap     "Manufacturing and trade share, 1950 (capital)"
capture label var nonag_share_1950_cap           "Non-agricultural share, 1950 (capital)"
capture label var industrial_core_share_1950_rest "Industrial core share, 1950 (rest province)"
capture label var oil_sensitive_share_1950_rest   "Oil-sensitive share, 1950 (rest province)"
capture label var manuf_trade_share_1950_rest     "Manufacturing and trade share, 1950 (rest province)"
capture label var nonag_share_1950_rest           "Non-agricultural share, 1950 (rest province)"
label var female_young_share_1960 "Young-female share, 1960"
label var female_young_share_1970 "Young-female share, 1970"
label var male_young_share_1960 "Young-male share, 1960"
label var male_young_share_1970 "Young-male share, 1970"
label var proxy_usable_pre73         "Usable pre-1973 proxy sample"
capture label var proxy_usable_pre73_cap "Usable pre-1973 capital proxy sample"
capture label var proxy_usable_pre73_rest "Usable pre-1973 rest-of-province proxy sample"
save "$rep_data/final_province_pre73_crisis_proxies.dta", replace

use "$raw_extrev/output/external_revision_03_province_mobility_link.dta", clear
label var origin_province "Province of origin"
label var origin_total "Origin population"
label var total_stayers "People staying in origin province"
label var stay_share "Share staying in same province, 1970-1981"
label var codprov "Province code"
label var province "Province name"
label var treat_gap_f "Exposure gap (W)"
label var treat_gap_m "Exposure gap (M)"
label var muni_share_1940 "Municipal share in 1940"
label var ln_origin_total "Log origin population"
save "$rep_data/final_external_migration_1981.dta", replace

use "$raw_extrev/output/external_revision_04_law56_window_cells.dta", clear
label var zone "Geographic scope"
label var age_group "Age group"
label var marriage_period "Marriage cohort window"
label var avg_childrenactive "Average children, active women"
label var avg_childreninactive "Average children, inactive women"
label var active_minus_inactive "Active minus inactive fertility gap"
save "$rep_data/final_law56_window_cells_1981.dta", replace

use "$raw_extrev/output/external_revision_04_female_activity_structure_1981.dta", clear
label var ambito_territorial "Territorial scope"
label var active_share_total "Female activity rate"
label var occupied_share_total "Female employment share"
label var unemployed_first_share_total "Female first-job unemployment share"
label var unemployed_prev_share_total "Female previous-job unemployment share"
label var inactive_share_total "Female inactivity share"
save "$rep_data/final_female_activity_structure_1981.dta", replace

use "$raw_extrev/output/external_revision_04_sex_activity_gap_1981.dta", clear
label var ambito_territorial "Territorial scope"
label var totalMujeres "Female activity rate"
label var totalVarones "Male activity rate"
label var tasa_de_actividad "Overall activity rate"
label var female_male_activity_ratio "Female-to-male activity ratio"
label var activity_gap_male_minus_female "Male minus female activity gap"
save "$rep_data/final_sex_activity_gap_1981.dta", replace

* ----------------------------------------------------------------------------
* SECTION E. Figure inputs that must also be reproducible from scratch
* ----------------------------------------------------------------------------
* The appendix now reproduces Figure B1 (exposure map) and Figure B2 (national
* TFR series) inside the package. For Figure B1 we keep the exact map export
* used in the manuscript, because matching the original QGIS rendering matters
* more than approximating it with a redraw helper. For Figure B2 we keep the
* historical workbook used to reconstruct the time series.
* ----------------------------------------------------------------------------

capture mkdir "$rep_figinputs/exposure_map"
capture mkdir "$rep_figinputs/tfr"

* Figure B1 input: exact exposure map image used in the current manuscript.
copy "$raw_jole/Educated to Be Mothers-slides/descriptive_maps/popw_newlegend.png" ///
    "$rep_figinputs/exposure_map/popw_newlegend.png", replace

* Figure B2 input: long-run Spain TFR series assembled from the historical
* workbook used to create the manuscript's original JPG.
import excel "$purge_root/original_data/TFR_year_country/data.xlsx", sheet("Sheet3") firstrow clear
rename Totalfertilityrate tfr
drop if missing(year) | missing(tfr)
label var source "Source layer for long-run TFR series"
label var year   "Calendar year"
label var tfr    "Total fertility rate"
sort year
save "$rep_data/final_spain_tfr_series.dta", replace

copy "$purge_root/original_data/TFR_year_country/data.xlsx" ///
    "$rep_figinputs/tfr/data.xlsx", replace

log close
