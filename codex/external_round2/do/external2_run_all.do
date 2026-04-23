version 17.0
clear all
set more off
set varabbrev off

capture log close

global root "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE"
global ext2 "$root/codex/external_round2"
global logs "$ext2/logs"

log using "$logs/external2_run_all.log", replace text

do "$ext2/do/external2_01_portugal_hfd.do"
do "$ext2/do/external2_02_beliefs_ivs_spain_portugal.do"
do "$ext2/do/external2_03_employment_support.do"

log close
