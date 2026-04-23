version 17.0
clear all
set more off

use "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/output_data/dataset_forcis.dta", clear
describe
lookfor lab2 unemployed women_work import_work year_birth female treat year age
