version 17.0
clear all
set more off

capture log close

global root "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE"
global codex "$root/codex"
global logs "$codex/logs"

log using "$logs/revision_run_all.log", replace text

display as text "Running Law 56 horse-race"
do "$codex/do/revision_01_law56_horserace.do"

display as text "Running migration macro diagnostics"
do "$codex/do/revision_02_migration_macro.do"

display as text "Running birthplace and stayers diagnostics"
do "$codex/do/revision_03_birthplace_stayers.do"

display as text "Running macro pretrends and heterogeneity"
do "$codex/do/revision_04_macro_pretrends_heterogeneity.do"

display as text "Running IVS Portugal placebo and beliefs"
do "$codex/do/revision_05_ivs_placebo_beliefs.do"

display as text "Running post-1950 cohort profiles"
do "$codex/do/revision_06_post1950_census.do"

display as result "Revision bundle completed"

log close
