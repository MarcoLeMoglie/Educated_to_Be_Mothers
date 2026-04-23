
use  "$dir\$Output_data\purge\victims_archive_v1.dta", clear

**#keep only teachers
keep if archive=="Archivo General de la Administración"
keep year_2
replace year_2=1945 if year_2 ==19451
replace year_2=1945 if year_2 ==19450
replace year_2=1945 if year_2 ==19453
replace year_2=1940 if year_2 ==194
replace year_2=1939 if year_2 ==1439
drop if year_2 ==1480

tab year_2
drop if year ==.
gen teacher =1
collapse (sum) teacher, by(year)

 twoway  (bar teacher year), xla(1937(2)1970) ytitle("`var'") legend(position(6) cols(2)) ytitle("`var'", size(small)) xtitle("Year") yline(0)  xline(1945)
gr export $Results/graphs_qualitative/teachers_year.pdf, replace
 * 