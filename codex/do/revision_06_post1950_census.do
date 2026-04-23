version 17.0
clear all
set more off

capture log close

global root "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE"
global datain2 "$root/original_data/INE_microdatos/"
global codex "$root/codex"
global out "$codex/output"
global logs "$codex/logs"

log using "$logs/revision_06_post1950_census.log", replace text

use ${datain2}censo2011/por_provincias/censo2011_provincias.dta, clear
rename *, lower

keep if inrange(anac, 1920, 1965)
keep if sexo == 6

gen kids2 = nhijo > 0 & nhijo != .
replace kids2 = . if nhijo == .
replace nhijos = 0 if kids2 == 0

rename cpro codprov
rename cpron codprov_born
gen weight2 = factor

gen age = 2011 - anac
gen age_c = floor(age / 10)

gen cohort_bin = ""
replace cohort_bin = "1920_1929" if inrange(anac, 1920, 1929)
replace cohort_bin = "1930_1938" if inrange(anac, 1930, 1938)
replace cohort_bin = "1939_1950" if inrange(anac, 1939, 1950)
replace cohort_bin = "1951_1955" if inrange(anac, 1951, 1955)
replace cohort_bin = "1956_1960" if inrange(anac, 1956, 1960)
replace cohort_bin = "1961_1965" if inrange(anac, 1961, 1965)

keep if cohort_bin != ""

collapse (mean) kids2 nhijos age (count) N=nhijos, by(cohort_bin)
sort cohort_bin

save "$out/revision_06_post1950_results.dta", replace
export delimited using "$out/revision_06_post1950_results.csv", replace

log close
