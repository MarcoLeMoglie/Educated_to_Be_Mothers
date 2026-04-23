version 17.0
clear all
set more off

capture log close

global root "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE"
global ext "$root/codex/external_revisions"
global logs "$ext/logs"

log using "$logs/external_revision_run_all.log", replace text

display as text "Running external revision bundle"
do "$ext/do/external_revision_01_law56_legal_timing.do"
do "$ext/do/external_revision_02_crisis73_macro_proxies.do"
do "$ext/do/external_revision_03_external_migration_censo1981.do"
do "$ext/do/external_revision_04_activity_fertility_censo1981.do"

log close
