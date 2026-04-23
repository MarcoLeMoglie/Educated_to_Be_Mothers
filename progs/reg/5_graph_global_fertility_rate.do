**************************************************
*	*	Global Fertility Rate	*	*
**************************************************
use "$Output_data/dataset.dta", clear
gen flag4=(alive_birth/(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940))*1000
gen flag6=(total_wedding/(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940))*1000
sum flag4 flag6
keep year flag4 flag6
collapse flag4 flag6, by(year)
twoway line  flag4 year, xla(1930(5)1985) ytitle("")
graph export "$Results/gfr.png",replace

twoway line  flag6 year, xla(1930(5)1985) ytitle("")
graph export "$Results/weddings.png",replace