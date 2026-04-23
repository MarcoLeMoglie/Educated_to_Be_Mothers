* * * * * * * * * * * * * * * * * * * * * * * * * 
**# Census 1991 (10%)
* * * * * * * * * * * * * * * * * * * * * * * * * 
use "$Output_data/dataset_microdata1991.dta", clear
gen birthyear = 1992-FECHA


drop if FECHA==799|FECHA==100
rename HIJOS nkids
rename SEXO gender
gen female = 1 if gender==6
replace female = 0 if missing(female)
order codprov birthyear nkids female
gen id_ind=_n

xi: rdrobust nkids birthyear if birthyear>=1935 & birthyear<=1944, h(15) c(1940) kernel(tri) p(2) vce(cluster codprov) covs(i.id_ind) 

* * * * * * * * * * * * * * * * * * * * * * * * * 
**# Census 2001 (5%)
* * * * * * * * * * * * * * * * * * * * * * * * * 
use "$Output_data/dataset_microdata2001.dta", clear

use "$Output_data/dataset_microdata2011.dta", clear