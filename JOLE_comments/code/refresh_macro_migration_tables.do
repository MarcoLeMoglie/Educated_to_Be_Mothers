version 17.0
clear all
set more off
set varabbrev off

global root "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE"
global codex "$root/codex"
global extrev "$root/codex/external_revisions"
global paper_root "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/Applicazioni/Overleaf/Educated to Be Mothers-slides"
global jole "$paper_root/JOLE_comments"
global tables "$jole/tables"
global logs "$jole/logs"

capture mkdir "$tables"
capture mkdir "$logs"
capture log close
log using "$logs/refresh_macro_migration_tables.log", replace text

display as text "Refreshing selected external migration table"

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

log close
