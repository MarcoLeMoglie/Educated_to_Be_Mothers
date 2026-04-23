version 17.0
clear all
set more off
set varabbrev off

global root "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE"
global paper_root "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/Applicazioni/Overleaf/Educated to Be Mothers-slides"
global datain2 "$root/original_data/INE_microdatos/"
global jole "$paper_root/JOLE_comments"
global tables "$jole/tables"
global logs "$jole/logs"

capture mkdir "$tables"
capture mkdir "$logs"
capture log close
log using "$logs/refresh_birthplace_table.log", replace text

display as text "Refreshing birthplace / movers-stayers table only"

use "$datain2/censos_spain_2011.dta", clear
rename nchborn nhijos
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
tempfile c2011_base
save "`c2011_base'"

use "$datain2/censos_spain_1991.dta", clear
keep if inrange(anac, 1920, 1970)
gen kids = nhijo > 0 & nhijo != .
replace kids = . if nhijo == .
gen kids2 = hijos == 1
replace kids2 = . if hijos == .
replace nhijos = 0 if kids2 == 0
gen year = 1991
rename mun cmun
rename prov codprov
rename provn codprov_born
gen weight = fe
append using "`c2011_base'"

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

log close
