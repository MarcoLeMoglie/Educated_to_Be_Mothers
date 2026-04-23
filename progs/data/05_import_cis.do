* * * * * * * * * * * * * * * * * * 
**# 1. Aborto 1992 (no peso)
* * * * * * * * * * * * * * * * * * 
import spss using "$Data\CIS\Aborto 1992\MD1996\1996.sav", clear
gen year = 1992
*rename PROV codprov
*merge m:1 codprov using "$Output_data/dataset_forcis.dta"
*drop if _merge==2
*drop _merge
save "$Data\CIS\_data_cis\aborto_1992.dta", replace
use "$Data\CIS\_data_cis\aborto_1992.dta", clear
* * * * * * * * * * * * * * * * * * 
**# Barometro Apr 1991 (no peso)
* * * * * * * * * * * * * * * * * * 
import spss using "$Data\CIS\Barometro Apr 1991\MD1962\1962.sav", clear
rename PROV codprov

gen year = 1991
gen month =4
*merge m:1 codprov using "$Output_data/dataset_forcis.dta"
*drop if _merge==2
*drop _merge


foreach var of varlist * {
  rename `var' `=strupper("`var'")'
}
save "$Data\CIS\_data_cis\barometro_apr1991.dta", replace
use "$Data\CIS\_data_cis\barometro_apr1991.dta", clear
* * * * * * * * * * * * * * * * * * 
**# Barometro Dic 1986 (no peso)
* * * * * * * * * * * * * * * * * * 
*import spss using "$Data\CIS\Barometro Dec 1986\MD1567\1567.sav", clear error reading file
import delimited "$Data\CIS\Barometro Dec 1986\MD1567\1567_num.csv", clear

rename prov codprov
gen year = 1986
gen month =12
foreach var of varlist * {
  rename `var' `=strupper("`var'")'
}
save "$Data\CIS\_data_cis\barometro_dic1986.dta", replace
use "$Data\CIS\_data_cis\barometro_dic1986.dta", clear
* * * * * * * * * * * * * * * * * * 
**# Barometro Dic 1990 (no peso)
* * * * * * * * * * * * * * * * * * 
import spss using "$Data\CIS\Barometro Dec 1990\MD1910\1910.sav", clear
rename PROV codprov
gen year = 1990
gen month =12
*merge m:1 codprov using "$Output_data/dataset_forcis.dta"
*drop if _merge==2
*drop _merge
 foreach var of varlist * {
  rename `var' `=strupper("`var'")'
}
save "$Data\CIS\_data_cis\barometro_dec1990.dta",replace
use "$Data\CIS\_data_cis\barometro_dec1990.dta", clear
* * * * * * * * * * * * * * * * * * 
**# Barometro Feb 1990 (no peso)
* * * * * * * * * * * * * * * * * * 
import spss using "$Data\CIS\Barometro Feb 1990\MD1860\1860.sav", clear
rename PROV codprov
gen year = 1990
gen month =2
*merge m:1 codprov using "$Output_data/dataset_forcis.dta"
*drop if _merge==2
*drop _merge
 
foreach var of varlist * {
  rename `var' `=strupper("`var'")'
}
save "$Data\CIS\_data_cis\barometro_feb1990.dta", replace
* * * * * * * * * * * * * * * * * * 
**# Barometro Jan 1987 (no peso)
* * * * * * * * * * * * * * * * * * 
*import spss using "$Data\CIS\Barometro Jan 1987\MD1595\1595.sav", clear error reading file
import delimited "$Data\CIS\Barometro Jan 1987\MD1595\1595_num.csv", clear 
rename prov codprov
gen year = 1987
gen month =1
foreach var of varlist * {
  rename `var' `=strupper("`var'")'
}
save "$Data\CIS\_data_cis\barometro_jan1987.dta", replace
* * * * * * * * * * * * * * * * * * 
**# Barometro Mar 1990 (no peso)
* * * * * * * * * * * * * * * * * * 
import spss using "$Data\CIS\Barometro Mar 1990\MD1864\1864.sav", clear
rename PROV codprov
gen year = 1990
gen month =3
*merge m:1 codprov using "$Output_data/dataset_forcis.dta"
*drop if _merge==2
*drop _merge
 foreach var of varlist * {
  rename `var' `=strupper("`var'")'
}
save "$Data\CIS\_data_cis\barometro_mar1990.dta", replace
* * * * * * * * * * * * * * * * * * 
**# Barometro Nov 1988 (peso)
* * * * * * * * * * * * * * * * * * 
import spss using "$Data\CIS\Barometro Nov 1988\MD1773\1773.sav", clear
rename PROV codprov
gen year = 1988
gen month =11

*merge m:1 codprov using "$Output_data/dataset_forcis.dta"
*drop if _merge==2
*drop _merge
 
foreach var of varlist * {
  rename `var' `=strupper("`var'")'
} 
 
save "$Data\CIS\_data_cis\barometro_nov1988.dta", replace
* * * * * * * * * * * * * * * * * * 
**# Barometro Oct 1984 THERE IS NO SAV OR CSV FILE
* * * * * * * * * * * * * * * * * * 

* * * * * * * * * * * * * * * * * * 
**# Barometro Oct 1986: 1552 (no peso)
* * * * * * * * * * * * * * * * * * 
import delimited "$Data\CIS\Barometro Oct 1986\MD1552\1552_num.csv", clear
rename prov codprov
gen year = 1986
gen month = 10
foreach var of varlist * {
  rename `var' `=strupper("`var'")'
}
save "$Data\CIS\_data_cis\barometro_oct1986.dta", replace
use "$Data\CIS\_data_cis\barometro_oct1986.dta", clear
* * * * * * * * * * * * * * * * * * 
**# Barometro Oct 1988 (no peso)
* * * * * * * * * * * * * * * * * * 
import spss using "$Data\CIS\Barometro Oct 1988\MD1767\1767.sav", clear
rename PROV codprov
gen year = 1988
gen month =10
*merge m:1 codprov using "$Output_data/dataset_forcis.dta"
*drop if _merge==2
*drop _merge

 foreach var of varlist * {
  rename `var' `=strupper("`var'")'
}
save "$Data\CIS\_data_cis\barometro_oct1988.dta", replace
* * * * * * * * * * * * * * * * * * 
**# Barometro Sept 1979 (peso)
* * * * * * * * * * * * * * * * * * 
import delimited "$Data\CIS\Barometro Sept 1979\MD1196\1196_num.csv", clear 

rename prov codprov
gen year = 1979
gen month = 9
foreach var of varlist * {
  rename `var' `=strupper("`var'")'
}
rename ESTUDIO ESTU
replace PESO = subinstr(PESO, ",", ".", .)
destring PESO, replace
save "$Data\CIS\_data_cis\barometro_sept1979.dta", replace
use "$Data\CIS\_data_cis\barometro_sept1979.dta", clear
* * * * * * * * * * * * * * * * * * 
**# Cuestiones de Actualidad 1980 (peso)
* * * * * * * * * * * * * * * * * * 

import spss using "$Data\CIS\Cuestiones de Actualidad 1980\MD1259\1259.sav", clear
rename PROV codprov
gen year = 1980
*merge m:1 codprov using "$Output_data/dataset_forcis.dta"
*drop if _merge==2
*drop _merge
foreach var of varlist * {
  rename `var' `=strupper("`var'")'
} 
save "$Data\CIS\_data_cis\actualidad_1980.dta", replace

* * * * * * * * * * * * * * * * * * 
**# Cuestiones sobre los Valores 1983 (no peso)
* * * * * * * * * * * * * * * * * * 
import spss using "$Data\CIS\Cuestiones sobre los Valores 1983\MD1382\1382.sav", clear
rename PROV codprov
gen year = 1983
*merge m:1 codprov using "$Output_data/dataset_forcis.dta"
*drop if _merge==2
*drop _merge
foreach var of varlist * {
  rename `var' `=strupper("`var'")'
}
save "$Data\CIS\_data_cis\valores_1983.dta", replace
* * * * * * * * * * * * * * * * * * 
**# Cuestiones sobre los Valores 1992. ESTU 2001 (no peso)
* * * * * * * * * * * * * * * * * * 
import spss using "$Data\CIS\Cuestiones sobre los Valores 1992\MD2001\2001.sav", clear
rename PROV codprov
gen year = 1992
*merge m:1 codprov using "$Output_data/dataset_forcis.dta"
*drop if _merge==2
*drop _merge
foreach var of varlist * {
  rename `var' `=strupper("`var'")'
}
save "$Data\CIS\_data_cis\valores_1992.dta", replace
use "$Data\CIS\_data_cis\valores_1992.dta", clear
* * * * * * * * * * * * * * * * * * 
**# Desigualdad en la Familia 1990 (no peso)
* * * * * * * * * * * * * * * * * * 
import delimited "$Data\CIS\Desigualdad en la Familia 1990\MD1867\1867_num.csv", clear 
gen year = 1990
rename prov codprov
*merge m:1 codprov using "$Output_data/dataset_forcis.dta"
*drop if _merge==2
*drop _merge
foreach var of varlist * {
  rename `var' `=strupper("`var'")'
}
save "$Data\CIS\_data_cis\desigualdad_1990.dta", replace
use "$Data\CIS\_data_cis\desigualdad_1990.dta", clear
* * * * * * * * * * * * * * * * * * 
**# Embarazo y Aborto 1991 (no peso)
* * * * * * * * * * * * * * * * * * 
import spss using "$Data\CIS\Embarazo y Aborto 1991\MD1968\1968.sav", clear
rename PROV codprov
*merge m:1 codprov using "$Output_data/dataset_forcis.dta"
*drop if _merge==2
*drop _merge
gen year = 1991
foreach var of varlist * {
  rename `var' `=strupper("`var'")'
}
save "$Data\CIS\_data_cis\embarazo_aborto_1991.dta", replace
* * * * * * * * * * * * * * * * * * 
**# Expectativas 1985 error reading file
* * * * * * * * * * * * * * * * * * 
*import spss using "$Data\CIS\Expectativas 1985\MD1440\1440.sav", clear
 
* * * * * * * * * * * * * * * * * * 
**# Expectativas 1989 (no peso)
* * * * * * * * * * * * * * * * * * 
import spss using "$Data\CIS\Expectativas 1989\MD1783\1783.sav", clear
rename PROV codprov
*merge m:1 codprov using "$Output_data/dataset_forcis.dta"
*drop if _merge==2
gen year = 1989
*drop _merge
foreach var of varlist * {
  rename `var' `=strupper("`var'")'
}
save "$Data\CIS\_data_cis\expectativas_1989.dta", replace
* * * * * * * * * * * * * * * * * * 
**# Expectativas 1992 (no peso)
* * * * * * * * * * * * * * * * * * 
import spss using "$Data\CIS\Expectativas 1992\MD1992\1992.sav", clear
rename PROV codprov
gen year = 1992
*merge m:1 codprov using "$Output_data/dataset_forcis.dta"
*drop if _merge==2
*drop _merge
foreach var of varlist * {
  rename `var' `=strupper("`var'")'
}
save "$Data\CIS\_data_cis\expectativas_1992.dta", replace
* * * * * * * * * * * * * * * * * * 
**# Familia y Formas de Convivencia 1991
* * * * * * * * * * * * * * * * * * 
import delimited "$Data\CIS\Familia y Formas de Convivencia 1991\MD1965\1965_num.csv", clear
rename prov codprov


* * * * * * * * * * * * * * * * * * 
**# Barometro December 1992 (2044)
* * * * * * * * * * * * * * * * * * 
import spss using "$Data\CIS\Barometro Dec 1992\2044.sav", clear
rename PROV CODPROV
save "$Data\CIS\_data_cis\barometro_dec1992.dta", replace
* * * * * * * * * * * * * * * * * * 
**# Cuestiones de actualidad 1977: no hay province!
* * * * * * * * * * * * * * * * * * 
import delimited "$Data\CIS\Cuestiones de actualidad 1977\1130_num.csv", clear


* * * * * * * * * * * * * * * * * * 
**# Victimizacion 1978: no hay municipio! (solo poblacion del municipio)
* * * * * * * * * * * * * * * * * * 
import spss using "$Data\CIS\victimizacion 1978\1152.sav", clear



* * * * * * * * * * * * * * * * * * 
**# Cuestiones de actualidad 1978 (1141)
* * * * * * * * * * * * * * * * * * 
import delimited "$Data\CIS\Cuestiones de Actualidad 1978\1141_num.csv", clear 
* * * * * * * * * * * * * * * * * * 
**# Funcionarios de Hacienda Oct 1979
* * * * * * * * * * * * * * * * * * 

* * * * * * * * * * * * * * * * * * 
**# Barometro Julio 1979
* * * * * * * * * * * * * * * * * * 
*error reading file

* * * * * * * * * * * * * * * * * * 
**# Funcionarios y Contratados Laborales 1988
* * * * * * * * * * * * * * * * * * 


* * * * * * * * * * * * * * * * * * 
**# Juventud 1984
* * * * * * * * * * * * * * * * * * 


* * * * * * * * * * * * * * * * * * 
**# Ocio y Familia 1991
* * * * * * * * * * * * * * * * * * 


* * * * * * * * * * * * * * * * * * 
**# Pareja Humana 1980
* * * * * * * * * * * * * * * * * * 
*import spss using  "$Data\CIS\Pareja Humana 1980\MD1234\1234.sav", clear
*error reading file

* * * * * * * * * * * * * * * * * * 
**# Poblacion y Familia 1992
* * * * * * * * * * * * * * * * * * 
*import spss using  "$Data\CIS\Poblacion y Familia 1992\MD1990\1990.sav", clear
*error reading file
* * * * * * * * * * * * * * * * * * 
**# Servicio Militar 1986
* * * * * * * * * * * * * * * * * * 

* * * * * * * * * * * * * * * * * * 
**# APPEND BAROMETROS, municipality rest province
* * * * * * * * * * * * * * * * * * 
use "$Data\CIS\_data_cis\barometro_apr1991.dta", clear

append using "$Data\CIS\_data_cis\barometro_sept1979.dta"

append using "$Data\CIS\_data_cis\barometro_dic1986.dta"
append using "$Data\CIS\_data_cis\barometro_dec1990.dta"
append using "$Data\CIS\_data_cis\barometro_feb1990.dta"
append using "$Data\CIS\_data_cis\barometro_jan1987.dta"
append using "$Data\CIS\_data_cis\barometro_mar1990.dta"
append using "$Data\CIS\_data_cis\barometro_nov1988.dta"
append using "$Data\CIS\_data_cis\barometro_oct1986.dta"
append using "$Data\CIS\_data_cis\barometro_oct1988.dta"
append using "$Data\CIS\_data_cis\barometro_dec1992.dta"
* Append other surveys (different from barometros)
append using "$Data\CIS\_data_cis\aborto_1992.dta"
append using "$Data\CIS\_data_cis\embarazo_aborto_1991.dta"
append using "$Data\CIS\_data_cis\valores_1983.dta" // 1382
append using "$Data\CIS\_data_cis\desigualdad_1990.dta"
append using "$Data\CIS\_data_cis\valores_1992.dta" //2001
* Identify capitals of province first
gen type = "rest province" if MUN==0 //no capital
replace type ="municipality" if MUN ==3 //albacete
replace type ="municipality" if MUN ==13 //almeria
replace type ="municipality" if MUN ==37 //caceres
replace type ="municipality" if MUN ==30 //a coruna murcia
replace type ="municipality" if MUN ==19 //avila barcelona
replace type ="municipality" if MUN ==59 //burgos vitoria
replace type ="municipality" if MUN ==201 //pamplona
replace type ="municipality" if MUN ==67 //malaga
replace type ="municipality" if MUN ==250 //valencia
replace type ="municipality" if MUN ==38 //ponetevedra st cruz tenerife
replace type ="municipality" if MUN ==40 //castellon
replace type ="municipality" if MUN ==186 //valladolid
replace type ="municipality" if MUN ==20 //bilbao
replace type ="municipality" if MUN ==89 //logrono
replace type ="municipality" if MUN ==120 //palencia
replace type ="municipality" if MUN ==41 //huelva
replace type ="municipality" if MUN ==12 //cadiz
replace type ="municipality" if MUN ==87 //granada
replace type ="municipality" if MUN ==79 //madrid
replace type ="municipality" if MUN ==44 //oviedo
replace type ="municipality" if MUN ==57 //vigo
replace type ="municipality" if MUN ==75 //santander
replace type ="municipality" if MUN ==21 //cordoba
replace type ="municipality" if MUN ==14 //alicante
replace type ="municipality" if MUN ==91 //sevilla
replace type ="municipality" if MUN ==297 //zaragoza
replace type ="municipality" if MUN ==125 //huesca
replace type ="municipality" if MUN ==274 //salamanca
replace type ="municipality" if MUN ==275 //zamora
replace type ="municipality" if MUN ==69 //donosti
replace type ="municipality" if MUN ==78 //cuenca
replace type ="municipality" if MUN ==148 //tarragona
replace type ="municipality" if MUN ==34 //ciudad real
replace type ="municipality" if MUN ==50 //jaen
replace type ="municipality" if MUN ==28 //lugo
replace type ="municipality" if MUN ==194 //segovia
replace type ="municipality" if MUN ==54 //ourense
replace type ="municipality" if MUN ==216 //teruel
replace type ="municipality" if MUN ==130 //guadalajara

replace type = "rest province" if type=="" //no capital
rename CODPROV codprov
replace codprov = PROV if ESTU==1996
drop PROV
merge m:1 codprov type using "$Output_data/dataset_forcis.dta"
drop if _merge==2 // 5 municipalities (capitals of province) that are not represented in CIS
drop _merge
replace year = YEAR if year ==.
drop YEAR

rename MONTH month
save "$Data\CIS\_data_cis\barometros_data.dta", replace


* * * * * * * * * * * * * * * * * * 
**# QUESTIONS
* * * * * * * * * * * * * * * * * * 
use "$Data\CIS\_data_cis\barometros_data.dta", clear

* Sexo del entrevistado 1hombre  2mujer 
gen female = 1 if (P50==2 & ESTU==1552)| ///
(P31==2 & ESTU==1196)| ///
(P54==2 & ESTU==1567)| ///
(P21==2 & ESTU==1595)| ///
(P42==2 & ESTU==1767)| ///
(P47==2 & ESTU==1773)| ///
(P33==2 & ESTU==1860)| ///
(P36==2 & ESTU==1864)| ///
(P39==2 & ESTU==1910)| ///
(P26==2 & ESTU==1962)| ///
(P27==2 & ESTU==1996)| ///
(P28==2 & ESTU==1968)| ///
(P46==2 & ESTU==1867)| /// des familia 1990
(P47==2 & ESTU==2001)| /// 
(P36==2 & ESTU==2044) // barometro dec 1992
replace female = 0 if missing(female)

* Age del entrevistado 
gen age =  P52 if ESTU==1552
replace age = P34 if ESTU==1196
replace age = P56 if ESTU==1567
replace age =P22 if ESTU==1595 
replace age =P43 if ESTU==1767 
replace age =P48 if ESTU==1773 
replace age =P34 if ESTU==1860 
replace age =P37 if ESTU==1864 
replace age =P40 if ESTU==1910 
replace age =P27 if ESTU==1962 
replace age =P28 if ESTU==1996 //aborto
replace age =P29 if ESTU==1968
replace age =P51 if ESTU==1382
replace age =P47 if ESTU==1867
replace age =P48 if ESTU==2001
replace age =P37 if ESTU==2044 // barometro dec 1992
* QUESTION 1- DEFINITION 1: Como se considera usted en materia religiosa 
gen catholic = 1 if ((P57==1|P57==2) & year==1986 & month==10)| /// 1986
((P36==1|P36==2) & ESTU==1196)| /// 79
((P61==1|P61==2) & year==1986 & month==12)| ///
((P25==1|P25==2) & year==1987 & month==1)| ///
((P37==1|P37==2) & year==1990 & month==2)| /// 
((P40==1|P40==2) & year==1990 & month==3)| ///  
((P44==1|P44==2) & year==1990 & month==12)| /// 
((P31==1|P31==2) & year==1991)| /// 
((P29==1|P29==2) & ESTU==1996)| /// aborto 1992
((P33==1|P33==2) & ESTU==1968)| /// 91
((P50==1|P50==2) & ESTU==1867)| /// des familia 1990
((P50==1|P50==2) & ESTU==2001) // valores 92

replace catholic =0 if missing(catholic) //could be modified NSNC answer
tab catholic

* QUESTION 1- DEFINITION 2: Como se considera usted en materia religiosa  
gen catholic2 = 1 if ((P57==1) & year==1986 & month==10)| ///
((P36==1) & ESTU==1196)| ///
((P61==1) & year==1986 & month==12)| ///
((P25==1) & year==1987 & month==1)| ///
((P37==1) & year==1990 & month==2)| ///  
((P40==1) & year==1990 & month==3)| ///  
((P44==1) & year==1990 & month==12)| ///  
((P31==1) & year==1991)| /// 
((P29==1) & ESTU==1996)| /// 
((P33==1) & ESTU==1968)| /// 
((P50==1) & ESTU==1867)| /// des familia 1990
((P50==1) & ESTU==2001)

replace catholic2 =0 if missing(catholic2) //could be modified NSNC answer
tab catholic

* QUESTION 2: si elecciones manana, a que partido votaria
// center: CDS
// LEFT: IU | PSOE | PA=partido andalucista | otro de izqda pce
// right: pp | "otro de derecha" | AP
gen right = 1 if ((P49==1|P49==18) & ESTU==1552)| ///
((P64==1|P64==18) & ESTU==1567)| ///
((P27==1|P27==17) & ESTU==1595)| ///
((P40==1|P40==16) & ESTU==1767)| ///
((P45==1|P45==16) & ESTU==1773)| ///
((P31==3) & ESTU==1860)| ///
((P33==3|P33==14) & ESTU==1864)| ///
((P36==3|P36==14) & ESTU==1910)| ///
((P25==3|P25==14) & ESTU==1962)| ///
((P18==3|P18==14) & ESTU==2044) //barometro dic 1992

replace right =0 if ((P49==3|P49==19|P49==7) & ESTU==1552)| ///
((P64==3|P64==19|P64==7) & ESTU==1567)| ///
((P27==3|P27==6|P27==18) & ESTU==1595)| ///
((P40==4|P40==5|P40==17) & ESTU==1767)| ///
((P45==4|P45==5|P45==17) & ESTU==1773)| ///
((P31==2|P31==4|P31==15) & ESTU==1860)| ///
((P33==2|P33==4|P33==15) & ESTU==1864)| ///
((P36==2|P36==4|P36==15) & ESTU==1910)| ///
((P25==2|P25==4|P25==15) & ESTU==1962)| ///
((P18==2|P18==4|P18==15) & ESTU==2044) 

* QUESTION 3: por que partido siente mas simpatia o mas cercano a sus ideas
// center: CDS
// LEFT: IU | PSOE | PA=partido andalucista | otro de izqda 
// right: pp | otro de derecha | AP
gen right_ideology = 1 if ((P49A==1|P49A==18) & ESTU==1552)| /// 86
((P64A==1|P64A==18) & ESTU==1567)| /// 86
((P27A==1|P27A==17) & ESTU==1595)| /// 87
((P40A==1|P40A==16) & ESTU==1767)| /// 88
((P45A==1|P45A==16) & ESTU==1773)| /// 88
((P31A==3) & ESTU==1860)| /// 90
((P33A==3|P33A==14) & ESTU==1864)| /// 90
((P36A==3|P36A==14) & ESTU==1910)| /// 90
((P25A==3|P25A==14) & ESTU==1962) // 91

replace right_ideology =0 if ((P49A==3|P49A==19|P49A==7) & ESTU==1552)| ///
((P64A==3|P64A==19|P64A==7) & ESTU==1567)| ///
((P27A==3|P27A==6|P27A==18) & ESTU==1595)| ///
((P40A==4|P40A==5|P40A==17) & ESTU==1767)| ///
((P45A==4|P45A==5|P45A==17) & ESTU==1773)| ///
((P31A==2|P31A==4|P31A==15) & ESTU==1860)| ///
((P33A==2|P33A==4|P33A==15) & ESTU==1864)| ///
((P36A==2|P36A==4|P36A==15) & ESTU==1910)| ///
((P25A==2|P25A==4|P25A==15) & ESTU==1962) 

* QUESTION: political scale
* QUESTION: vivir sin estar casado (not all the surveys have that answer)
gen live_notmarried = 1 if ((P15==2) & ESTU==1860)| /// feb90 hecho
((P18==2) & ESTU==1910)| /// dec90 hecho
((P23==2) & ESTU==1962)| /// apr 91 hecho
((P17==2) & ESTU==1996)| /// aborto 92 hecho
((P25==2) & ESTU==1968)| /// 
((P22==3) & ESTU==2001)
replace live_notmarried = 0 if ((P15!=2) & P15!=9 & ESTU==1860)| /// feb90 hecho
((P18!=2) & P18!=9 & ESTU==1910)| /// dec90 hecho
((P23!=2) & P23!=9 & ESTU==1962)| /// apr 91 hecho
((P17!=2 & P17!=9) & ESTU==1996)| /// aborto 92
((P25!=2 & P25!=9) & ESTU==1968)| /// 
((P22!=3 & P22!=9) & ESTU==2001)

* QUESTION: civil status married  
gen married = 1 if ((P32==2) & ESTU==1196)| ///
((P51==2) & ESTU==1552)| ///
((P55==2) & ESTU==1567)| ///
((P15==1) & ESTU==1860)| /// feb90
((P18==1) & ESTU==1910)| /// dec90
((P23==1) & ESTU==1962)| /// 
((P17==1) & ESTU==1996)| /// aborto 92
((P25==1) & ESTU==1968)| ///  
((P1==2) & ESTU==1867)| /// des familia 1990
((P22==2) & ESTU==2001)
replace married = 0 if ((P32!=2) & P32!=9 & ESTU==1196)| ///
((P51!=2) & P51!=9 & ESTU==1552)| ///
((P55!=2) & P55!=9 & ESTU==1567)| ///
((P15!=1) & P15!=9 & ESTU==1860)| /// feb90
((P18!=1) & P18!=9 & ESTU==1910)| /// dec90
((P23!=1) & P23!=9 & ESTU==1962)| /// apr 91
((P17!=1 & P17!=9) & ESTU==1996)| /// aborto 92
((P25!=1 & P25!=9) & ESTU==1968)| ///  
((P1!=2 & P1!=9) & ESTU==1867)| /// des familia 1990
((P22!=2 & P22!=9) & ESTU==2001)


* QUESTION: civil status divorced or separated
gen divorced_sep = 1 if ((P32==3) & ESTU==1196)| ///
((P51==3) & ESTU==1552)| ///
((P55==3) & ESTU==1567)| ///
((P15==3) & ESTU==1860)| /// feb90
((P18==3) & ESTU==1910)| /// dec90
((P23==3) & ESTU==1962)| /// apr 91
((P25==3) & ESTU==1968)| ///
((P22==4|P22==5) & ESTU==2001)
replace divorced_sep = 0 if ((P32==3) & P32!=9 & ESTU==1196)| ///
((P51!=3) & P51!=9 & ESTU==1552)| ///
((P55!=3) & P55!=9 & ESTU==1567)| ///
((P15!=3) & P15!=9 & ESTU==1860)| /// feb90
((P18!=3) & P18!=9 & ESTU==1910)| /// dec90
((P23!=3) & P23!=9 & ESTU==1962)| /// apr 91
((P25!=3 & P25!=9) & ESTU==1968)| ///
((P22!=4 & P22!=5 & P22!=9) & ESTU==2001)

* QUESTION: Cuantos anos tenia cuando se caso o comenzo a vivir en pareja. Note: 1979 there is no question
gen age_together = P17A if ((P17A!=99) & ESTU==1996) // aborto 1992
replace age_together = P25A if ((P25A!=.) & ESTU==1968)  // embarazo_aborto_1991 (there is no 99)
replace age_together = P1A if (P1A!=99 & ESTU==1867) //Desigualdad 90
replace age_together = P15A if ((P15A!=99) & ESTU==1860) // Feb 1990
replace age_together = P18A if ((P18A!=99) & ESTU==1910) // dec 1990
replace age_together = P23A if ((P23A!=99) & ESTU==1962) // April 1991


* QUESTION: Cuantos anos tenia SU CONYUGE O PAREJA cuando se caso o comenzo a vivir en pareja
* Note: Desigualdad 90(ESTU 1967) no tiene esta pregunta
gen age_partner_together = P17B if ((P17B!=99) & ESTU==1996) // aborto 1992
replace age_partner_together = P25B if ((P25B!=.) & ESTU==1968)  // embarazo_aborto_1991 (there is no 99)
replace age_partner_together = P15B if ((P15B!=99) & ESTU==1860) // Feb 1990
replace age_partner_together = P18B if ((P18B!=99) & ESTU==1910) // dec 1990
replace age_partner_together = P23B if ((P23B!=99) & ESTU==1962) // April 1991

* QUESTION: highest degree completed
/*
1 menos de primaria, no sabe leer
2 menos de primaria, sabe leer
3 primaria
4 bachiller elemental o superior
5 universitarios
6 FP, Otros,grado medio
*/
gen education = .
replace education = 1 if (P35==1 & ESTU==1196) // sept 1979
replace education = 2 if (P35==2 & ESTU==1196) // sept 1979
replace education = 3 if (P35==3 & ESTU==1196) // sept 1979
replace education = 4 if ((P35==5|P35==6) & ESTU==1196) // sept 1979
replace education = 5 if ((P35==8) & ESTU==1196) // sept 1979
replace education = 6 if ((P35==4|P35==9|P35==7) & ESTU==1196) // sept 1979

* * *
replace education = 1 if (P53==1 & ESTU==1552) // oct 1986
replace education = 2 if (P53==2 & ESTU==1552) // oct 1986
replace education = 3 if (P53==3 & ESTU==1552) // oct 1986
replace education = 4 if ((P53==5|P53==6) & ESTU==1552) // oct 1986
replace education = 5 if ((P53==8) & ESTU==1552) // oct 1986
replace education = 6 if ((P53==4|P53==9|P53==7) & ESTU==1552) // oct 1986

* * *
replace education = 1 if (P57==1 & ESTU==1567) // dec 1986
replace education = 2 if (P57==2 & ESTU==1567) // dec 1986
replace education = 3 if (P57==3 & ESTU==1567) // dec 1986
replace education = 4 if ((P57==5|P57==6) & ESTU==1567) // dec 1986
replace education = 5 if ((P57==8) & ESTU==1567) // dec 1986
replace education = 6 if ((P57==4|P57==9|P57==7) & ESTU==1567) // dec 1986

* * *
replace education = 1 if (P23==1 & ESTU==1595) // jan 1987
replace education = 2 if (P23==2 & ESTU==1595) // jan 1987
replace education = 3 if (P23==3 & ESTU==1595) // jan 1987
replace education = 4 if ((P23==5|P23==6) & ESTU==1595) // jan 1987
replace education = 5 if ((P23==8) & ESTU==1595) // jan 1987
replace education = 6 if ((P23==4|P23==9|P23==7) & ESTU==1595) // jan 1987

* * *
replace education = 1 if (P44==1 & ESTU==1767) // oct 1988
replace education = 2 if (P44==2 & ESTU==1767) // oct 1988
replace education = 3 if (P44==3 & ESTU==1767) // oct 1988
replace education = 4 if ((P44==5|P44==6) & ESTU==1767) // oct 1988
replace education = 5 if ((P44==8) & ESTU==1767) // oct 1988
replace education = 6 if ((P44==4|P44==9|P44==7) & ESTU==1767) /// oct 1988

* * *
replace education = 1 if (P49==1 & ESTU==1773) // nov 1988
replace education = 2 if (P49==2 & ESTU==1773) // nov 1988
replace education = 3 if (P49==3 & ESTU==1773) // nov 1988
replace education = 4 if ((P49==5|P49==6) & ESTU==1773) // nov 1988
replace education = 5 if ((P49==8) & ESTU==1773) // nov 1988
replace education = 6 if ((P49==4|P49==9|P49==7) & ESTU==1773) // nov 1988


* * *  
replace education = 1 if (P35==1 & ESTU==1860) //  feb 1990
replace education = 2 if (P35==2 & ESTU==1860) //
replace education = 3 if (P35==3 & ESTU==1860) // 
replace education = 4 if ((P35==5|P35==6) & ESTU==1860) // 
replace education = 5 if ((P35==8) & ESTU==1860) //  
replace education = 6 if ((P35==4|P35==9|P35==7) & ESTU==1860) // 

* * *  
replace education = 1 if (P38==1 & ESTU==1864) //  mar 1990 
replace education = 2 if (P38==2 & ESTU==1864) //  mar 1990
replace education = 3 if (P38==3 & ESTU==1864) //  mar 1990
replace education = 4 if ((P38==5|P38==6) & ESTU==1864) //  mar 1990
replace education = 5 if ((P38==8) & ESTU==1864) // mar 1990
replace education = 6 if ((P38==4|P38==9|P38==7) & ESTU==1864) // mar 1990
 
* * *  
replace education = 1 if (P41==1 & ESTU==1910) //  dec 1990
replace education = 2 if (P41==2 & ESTU==1910) //   
replace education = 3 if (P41==3 & ESTU==1910) //  
replace education = 4 if ((P41==5|P41==6) & ESTU==1910) //   
replace education = 5 if ((P41==8) & ESTU==1910) // 
replace education = 6 if ((P41==4|P41==9|P41==7) & ESTU==1910) // 
 
* * *  
replace education = 1 if (P28==1 & ESTU==1962) //  april 1991  
replace education = 2 if (P28==2 & ESTU==1962) //   
replace education = 3 if (P28==3 & ESTU==1962) //   
replace education = 4 if ((P28==5|P28==6) & ESTU==1962) //   
replace education = 5 if ((P28==8) & ESTU==1962) //  
replace education = 6 if ((P28==4|P28==9|P28==7) & ESTU==1962) //  
 
* * * THIS ONE IS DIFFERENT: ATTENTION TO ANSWERS
replace education = 1 if (P30==1 & ESTU==1996) //  aborto 1992
replace education = 2 if (P30==2 & ESTU==1996) //   
replace education = 3 if (P30==3 & ESTU==1996) //   
replace education = 4 if ((P30==4|P30==5) & ESTU==1996) //  
replace education = 5 if ((P30==7) & ESTU==1996) //  
replace education = 6 if ((P30==6|P30==8) & ESTU==1996) //  
 
* * *   
replace education = 1 if (P30==1 & ESTU==1968) //    EMBARAZO Y ABORTO 1991
replace education = 2 if (P30==2 & ESTU==1968) //   
replace education = 3 if (P30==3 & ESTU==1968) //   
replace education = 4 if ((P30==5|P30==6) & ESTU==1968) //   
replace education = 5 if ((P30==8) & ESTU==1968) //  
replace education = 6 if ((P30==4|P30==9|P30==7) & ESTU==1968) //  
  
* * *  
replace education = 1 if (P48==1 & ESTU==1867) //   DESIGUALDAD 1990 
replace education = 2 if (P48==2 & ESTU==1867) //  
replace education = 3 if (P48==3 & ESTU==1867) //   
replace education = 4 if ((P48==5|P48==6) & ESTU==1867) //  
replace education = 5 if ((P48==8) & ESTU==1867) //  
replace education = 6 if ((P48==4|P48==9|P48==7) & ESTU==1867) //         

    
* * * 

replace education = 1 if (P39==3 & ESTU==2044) //   Barometro dic 1992 
replace education = 2 if (P39==3 & ESTU==2044) //  
replace education = 3 if (P39==4 & ESTU==2044) //   
replace education = 4 if ((P39==5|P39==7) & ESTU==2044) //  
replace education = 5 if ((P39==13|P39==14|P39==15|P39==12|P39==9) & ESTU==2044) //  
replace education = 6 if ((P39==16|P39==8|P39==6) & ESTU==2044) //  
  
 

* QUESTION: at least primary school completed
gen at_leastprimary = 1 if ((P35>=3 & P35<10) & ESTU==1196)| ///
((P53>=3 & P53<10) & ESTU==1552)| ///
((P57>=3 & P57<10) & ESTU==1567)| ///
((P23>=3 & P23<10) & ESTU==1595)| ///
((P44>=3 & P44<10) & ESTU==1767)| ///
((P49>=3 & P49<10) & ESTU==1773)| ///
((P35>=3 & P35<10) & ESTU==1860)| ///
((P38>=3 & P38<10) & ESTU==1864)| ///
((P41>=3 & P41<10) & ESTU==1910)| ///
((P28>=3 & P28<10) & ESTU==1962)| ///
((P30>=3 & P30<9) & ESTU==1996)| /// aborto
((P30>=3 & P30<9 & P30!=0) & ESTU==1968)| ///
((P48>=3 & P48<9 & P48!=0) & ESTU==1867)| ///
((P39>=3 & P39<15 & P39!=0 & P39!=99) & ESTU==2044)

replace at_leastprimary = 0 if ((P35<3) & ESTU==1196)| ///
((P53<3) & ESTU==1552)| ///
((P57<3) & ESTU==1567)| ///
((P23<3) & ESTU==1595)| ///
((P44<3) & ESTU==1767)| ///
((P49<3) & ESTU==1773)| ///
((P35<3) & ESTU==1860)| ///
((P38<3) & ESTU==1864)| ///
((P41<3) & ESTU==1910)| ///
((P28<3) & ESTU==1962)| ///
((P30<3) & ESTU==1996)| ///
((P30<3 & P30!=0 & P30!=9) & ESTU==1968)| ///
((P48<3 & P48!=0 & P48!=9) & ESTU==1867)| ///
((P39==3 & P39!=0 & P39!=99) & ESTU==2044) // barometro dec 1992

* QUESTION: illiterate (no sabe leer)
gen illiterate = 1 if ((P35==1) & ESTU==1196)| ///
((P53==1) & ESTU==1552)| ///
((P57==1) & ESTU==1567)| ///
((P23==1) & ESTU==1595)| ///
((P44==1) & ESTU==1767)| ///
((P49==1) & ESTU==1773)| ///
((P35==1) & ESTU==1860)| ///
((P38==1) & ESTU==1864)| ///
((P41==1) & ESTU==1910)| ///
((P28==1) & ESTU==1962)| ///
((P30==1) & ESTU==1996)| ///
((P30==1) & ESTU==1968)| ///
((P48==1) & ESTU==1867) // des. familia 1990

replace illiterate = 0 if ((P35!=1 & P35!=0) & ESTU==1196)| ///
((P53!=1 & P53!=0) & ESTU==1552)| ///
((P57!=1 & P57!=0) & ESTU==1567)| ///
((P23!=1 & P23!=0) & ESTU==1595)| ///
((P44!=1 & P44!=0) & ESTU==1767)| ///
((P49!=1 & P49!=0) & ESTU==1773)| ///
((P35!=1 & P35!=0) & ESTU==1860)| ///
((P38!=1 & P38!=0) & ESTU==1864)| ///
((P41!=1 & P41!=0) & ESTU==1910)| ///
((P28!=1 & P28!=0) & ESTU==1962)| ///
((P30!=1 & P30!=9) & ESTU==1996)| ///
((P30!=1 & P30!=9 & P30!=0) & ESTU==1968)| ///
((P48!=1 & P48!=9 & P48!=0) & ESTU==1867)

* QUESTION: highschool (BACHILLER)
gen at_leasthighschool = 1 if ((P35>=5 & P35<10) & ESTU==1196)| ///
((P53>=5 & P53<10) & ESTU==1552)| ///
((P57>=5 & P57<10) & ESTU==1567)| ///
((P23>=5 & P23<10) & ESTU==1595)| ///
((P44>=5 & P44<10) & ESTU==1767)| ///
((P49>=5 & P49<10) & ESTU==1773)| ///
((P35>=5 & P35<10) & ESTU==1860)| ///
((P38>=5 & P38<10) & ESTU==1864)| ///
((P41>=5 & P41<10) & ESTU==1910)| ///
((P28>=5 & P28<10) & ESTU==1962)| ///
((P30>=4 & P30<9) & ESTU==1996)| ///
((P30>=5 & P30<9) & ESTU==1968)| ///
((P48>=5 & P48<9) & ESTU==1867)

replace at_leasthighschool = 0 if  ((P35<5) & ESTU==1196)| ///
((P53<5) & ESTU==1552)| ///
((P57<5) & ESTU==1567)| ///
((P23<5) & ESTU==1595)| ///
((P44<5) & ESTU==1767)| ///
((P49<5) & ESTU==1773)| ///
((P35<5) & ESTU==1860)| ///
((P38<5) & ESTU==1864)| ///
((P41<5) & ESTU==1910)| ///
((P28<5) & ESTU==1962)| ///
((P30<4) & ESTU==1996)| ///
((P30<5) & ESTU==1968)| ///
((P48<5) & ESTU==1867)

* QUESTION: job status (answer: "parado")
gen unemployed = 1 if ((P37==2) & ESTU==1196)| /// 1979
((P54==2) & ESTU==1552)| /// 1986
((P58==2) & ESTU==1567)| /// 1986
((P24==2) & ESTU==1595)| /// 1987
((P45==2) & ESTU==1767)| /// 1988
((P50==2) & ESTU==1773)| /// 1988
((P36==2) & ESTU==1860)| /// 1990
((P39==2) & ESTU==1864)| /// 1990
((P42==2) & ESTU==1910)| /// 1990
((P29==2) & ESTU==1962)| /// 1991
((P31==3) & ESTU==1996)| /// 1992
((P31==2) & ESTU==1968)| /// 1991
((P49==2) & ESTU==1867)| /// 1990
((P52==3) & ESTU==2001)| /// 1992
((P41==4) & ESTU==2044) // barometro dec 1992

replace unemployed =0 if ((P37!=2 & P37!=9) & ESTU==1196)| ///
((P54!=2 & P54!=9) & ESTU==1552)| ///
((P58!=2 & P58!=9) & ESTU==1567)| ///
((P24!=2 & P24!=9) & ESTU==1595)| ///
((P45!=2 & P45!=9) & ESTU==1767)| ///
((P50!=2 & P50!=9) & ESTU==1773)| ///
((P36!=2 & P36!=9) & ESTU==1860)| ///
((P39!=2 & P39!=9) & ESTU==1864)| ///
((P42!=2 & P42!=9) & ESTU==1910)| ///
((P29!=2 & P29!=9) & ESTU==1962)| ///
((P31!=3 & P31!=9) & ESTU==1996)| ///
((P31!=2 & P31!=9) & ESTU==1968)| ///
((P49!=2 & P49!=9) & ESTU==1867)| ///
((P52!=3 & P52!=9) & ESTU==2001)| ///
((P41!=4 & P41!=9) & ESTU==2044) // barometro dec 1992

* QUESTION: lab situation
* trabaja
gen lab_situation = 1 if ((P37==1) & ESTU==1196)| /// 1979
((P54==1) & ESTU==1552)| /// 1986 oct
((P58==1) & ESTU==1567)| /// 1986 dec
((P24==1) & ESTU==1595)| /// 1987
((P45==1) & ESTU==1767)| /// 1988
((P50==1) & ESTU==1773)| /// 1988
((P36==1) & ESTU==1860)| /// 1990
((P39==1) & ESTU==1864)| /// 1990
((P42==1) & ESTU==1910)| /// 1990
((P29==1) & ESTU==1962)| /// 1991
((P31==1) & ESTU==1996)| /// 1992
((P31==1) & ESTU==1968)| /// 1991
((P49==1) & ESTU==1867)| /// 1990
((P52==1) & ESTU==2001)| /// 1992 attention! answer is different
((P41==1) & ESTU==2044) //

* parado
replace lab_situation =2 if ((P37==2) & ESTU==1196)| /// 1979
((P54==2) & ESTU==1552)| /// 1986
((P58==2) & ESTU==1567)| /// 1986
((P24==2) & ESTU==1595)| /// 1987
((P45==2) & ESTU==1767)| /// 1988
((P50==2) & ESTU==1773)| /// 1988
((P36==2) & ESTU==1860)| /// 1990
((P39==2) & ESTU==1864)| /// 1990
((P42==2) & ESTU==1910)| /// 1990
((P29==2) & ESTU==1962)| /// 1991
((P31==3|P31==4) & ESTU==1996)| /// 1992 aborto attention! answer is different
((P31==2) & ESTU==1968)| /// 1991
((P49==2) & ESTU==1867)| /// 1990
((P52==3|P52==4) & ESTU==2001)| /// 1992 attention! answer is different
((P41==4|P41==5) & ESTU==2044)  // 1992 attention! answer is different


* other: jubilado 
replace lab_situation =3 if (P37==3 & ESTU==1196)| /// 1979
(P54==3 & ESTU==1552)| /// 1986 oct
(P58==3 & ESTU==1567)| /// 1986 dec
(P24==3 & ESTU==1595)| /// 1987
(P45==3 & ESTU==1767)| /// 1988 oct
(P50==3 & ESTU==1773)| /// 1988 nov
(P36==3 & ESTU==1860)| /// 1990 feb
(P39==3 & ESTU==1864)| /// 1990 mar
(P42==3 & ESTU==1910)| /// 1990 dec
(P29==3 & ESTU==1962)| /// 1991 apr
(P31==2 & ESTU==1996)| /// 1992 aborto attention! answer is different
(P31==3 & ESTU==1968)| /// 1991 embarazo y aborto
(P49==3 & ESTU==1867)| /// 1990 desigualdad
(P52==2 & ESTU==2001)| /// 1992 cuestiones attention! answer is different
((P41==2|P41==3) & ESTU==2044) //barometro dic 1992

* other:  estudiante 
replace lab_situation =4 if (P37==4 & ESTU==1196)| /// 1979
(P54==4 & ESTU==1552)| /// 1986
(P58==4 & ESTU==1567)| /// 1986
(P24==4 & ESTU==1595)| /// 1987
(P45==4 & ESTU==1767)| /// 1988
(P50==4 & ESTU==1773)| /// 1988
(P36==4 & ESTU==1860)| /// 1990
(P39==4 & ESTU==1864)| /// 1990
(P42==4 & ESTU==1910)| /// 1990
(P29==4 & ESTU==1962)| /// 1991
(P31==5 & ESTU==1996)| /// 1992 aborto attention! answer is different
(P31==4 & ESTU==1968)| /// 1991
(P49==4 & ESTU==1867)| /// 1990 
(P52==5  & ESTU==2001)| /// 1992 attention! answer is different
(P41==6  & ESTU==2044)

* other:  sus labores 
replace lab_situation =5 if (P37==5 & ESTU==1196)| /// 1979
(P54==5 & ESTU==1552)| /// 1986
(P58==5 & ESTU==1567)| /// 1986
(P24==5 & ESTU==1595)| /// 1987
(P45==5 & ESTU==1767)| /// 1988
(P50==5 & ESTU==1773)| /// 1988
(P36==5 & ESTU==1860)| /// 1990
(P39==5 & ESTU==1864)| /// 1990
(P42==5 & ESTU==1910)| /// 1990
(P29==5 & ESTU==1962)| /// 1991
(P31==6 & ESTU==1996)| /// 1992 aborto attention! answer is different
(P31==5 & ESTU==1968)| /// 1991
(P49==5 & ESTU==1867)| /// 1990 
(P52==6 & ESTU==2001)| /// 1992 attention! answer is different
(P41==7 & ESTU==2044)




* QUESTION ABORTION 1: in favor of abort if mum's threat
gen pro_abort_mumthreat = 1 if ((P3301==1) & ESTU==1552)| ///
((P5101==1) & ESTU==1567)| ///
((P1101==1) & ESTU==1860)| ///
((P1801==1) & ESTU==1968)

replace pro_abort_mumthreat =0 if ((P3301==2) & ESTU==1552)| ///
((P5101==2) & ESTU==1567)| ///
((P1101==2) & ESTU==1860)| ///
((P1801==2) & ESTU==1968)

* QUESTION ABORTION 2: in favor of abort if mum's danger
gen pro_abort_mumdanger = 1 if ((P3302==1) & ESTU==1552)| ///
((P5102==1) & ESTU==1567)| ///
((P1102==1) & ESTU==1860)| ///
((P1802==1) & ESTU==1968)

replace pro_abort_mumdanger =0 if ((P3302==2) & ESTU==1552)| ///
((P5102==2) & ESTU==1567)| ///
((P1102==2) & ESTU==1860)| ///
((P1802==2) & ESTU==1968)

* QUESTION ABORTION 3: in favor of abort if serious illness baby
gen pro_abort_illbaby = 1 if ((P3303==1) & ESTU==1552)| /// 1986
((P5103==1) & ESTU==1567)| /// 1986
((P1103==1) & ESTU==1860)| /// 1990
((P1803==1) & ESTU==1968) //1991

replace pro_abort_illbaby =0 if ((P3303==2) & ESTU==1552)| ///
((P5103==2) & ESTU==1567)| ///
((P1103==2) & ESTU==1860)| ///
((P1803==2) & ESTU==1968)

* QUESTION ABORTION 4: in favor of abort if rape
gen pro_abort_rape = 1 if ((P3304==1) & ESTU==1552)| ///
((P5104==1) & ESTU==1567)| ///
((P1104==1) & ESTU==1860)

replace pro_abort_rape =0 if ((P3304==2) & ESTU==1552)| ///
((P5104==2) & ESTU==1567)| ///
((P1104==2) & ESTU==1860)

* QUESTION ABORTION 5: in favor of abort if mum decides freely
gen pro_abort_decisionmum = 1 if ((P3305==1) & ESTU==1552)| ///
((P5105==1) & ESTU==1567)| ///
((P1105==1) & ESTU==1860)| ///
((P1806==1) & ESTU==1968)| ///
((P16==1|P16==2|P16==3) & ESTU==1382)

replace pro_abort_decisionmum =0 if ((P3305==2) & ESTU==1552)| ///
((P5105==2) & ESTU==1567)| ///
((P1105==2) & ESTU==1860)| ///
((P1806==2) & ESTU==1968)| ///
((P16==4|P16==5|P16==6) & ESTU==1382)

* QUESTION ABORTION 6: in favor of abort if economic difficulties
gen pro_abort_eco = 1 if ((P3306==1) & ESTU==1552)| ///
((P5106==1) & ESTU==1567)| ///
((P1106==1) & ESTU==1860)| ///
((P1301==1) & ESTU==1996)| /// survey abortion
((P1804==1) & ESTU==1968)
replace pro_abort_eco =0 if ((P3306==2) & ESTU==1552)| ///
((P5106==2) & ESTU==1567)| ///
((P1106==2) & ESTU==1860)| ///
((P1301==2) & ESTU==1996)| /// survey abortion
((P1804==2) & ESTU==1968)

*QUESTION PRO ABORT FOR ANY REASON
gen pro_abort = 1 if pro_abort_mumthreat==1| pro_abort_mumdanger==1| pro_abort_illbaby==1| pro_abort_rape==1| pro_abort_decisionmum ==1|pro_abort_eco==1

replace pro_abort = 0 if pro_abort_mumthreat==0|pro_abort_mumdanger==0| pro_abort_illbaby==0| pro_abort_rape==0| pro_abort_decisionmum ==0|pro_abort_eco==0

* QUESTION: 
gen sex_education1= 1 if P1301 ==1 & ESTU==1552
replace sex_education1 = 0 if P1301==2  & ESTU==1552

gen sex_education2= 1 if P1302 ==1 & ESTU==1552
replace sex_education2 = 0 if P1302==2  & ESTU==1552

* QUESTION: 
gen relig_educ_any= 1 if P18 ==3 & ESTU==1864 // 90
replace relig_educ_any = 0 if (P18==1 | P18==2)  & ESTU==1864 //

gen relig_educ_atleast1= 1 if (P18 ==3|P18==2) & ESTU==1864
replace relig_educ_atleast1 = 0 if (P18==1 )  & ESTU==1864

* QUESTIONS ABORTION FROM ABORT SURVEY
gen pro_law_abort = 1 if ((P3==1) & ESTU==1996)
replace pro_law_abort =0 if ((P3==2) & ESTU==1996)

* QUESTIONS ABORTION FROM ABORT SURVEY
gen tooprohib_law_abort = 1 if ((P4==2) & ESTU==1996)
replace tooprohib_law_abort =0 if ((P4==1) & ESTU==1996)

* QUESTIONS ABORTION FROM ABORT SURVEY+ BAROMETROS: con la ley actual han disminuido los abortos clandestinos en Espana? si= mucho, bastante, poco. No=nada
gen reduction_illegabort_sp = 1 if ((P7==1|P7==2|P7==3) & ESTU==1996)| ///
((P3901==1|P3901==2|P3901==3) & ESTU==1552) | /// oct86
((P6==1|P6==2|P6==3) & ESTU==1860) //Feb90 
replace reduction_illegabort_sp =0 if ((P7==4) & ESTU==1996)| ///
((P3901==4) & ESTU==1552)| ///
((P6==4) & ESTU==1860)
* Abroad
gen reduction_illegabort_abr = 1 if ((P8==1|P8==2|P8==3) & ESTU==1996)| ///
((P3902==1|P3902==2|P3902==3) & ESTU==1552)| /// oct86
((P7==1|P7==2|P7==3) & ESTU==1860)
replace reduction_illegabort_abr =0 if ((P8==4) & ESTU==1996)| ///
((P3902==4) & ESTU==1552)| ///
((P7==4) & ESTU==1860)
* Spain or abroad
gen reduction_illegabort = 1 if reduction_illegabort_sp ==1|reduction_illegabort_abr==1
replace reduction_illegabort =0 if reduction_illegabort_sp ==0|reduction_illegabort_abr==0
* QUESTIONS ABORTION FROM ABORT SURVEY+ BAROMETROS: in favor abortion 12weeks by decision of the woman
gen pro_abort_12w = 1 if ((P14==1|P14==2) & ESTU==1996)| ///
((P37==1) & ESTU==1552)  // oct86
replace pro_abort_12w =0 if ((P14==3|P14==4) & ESTU==1996)| ///
((P37==2) & ESTU==1552)
 
* KIDS
gen kids = 1 if ((P18>0 & P18!=. & P18!=99) & ESTU==1996)| /// aborto 1992
((P33<5 & P33!=. & P33!=9) & ESTU==1196)|  /// 79
((P26>0 & P26!=. & P26!=99) & ESTU==1968)|  /// embarazo_aborto_1991
((P2==1 & P2!=. & P2!=99) & ESTU==1867)| ///Desigualdad 90
((P16>0 & P16!=. & P16!=99) & ESTU==1860)| /// Feb 1990
((P19>0 & P19!=. & P19!=99) & ESTU==1910)| /// dec 1990
((P24>0 & P24!=. & P24!=99) & ESTU==1962) /// April 1991

replace kids =0 if ((P18==77) & ESTU==1996)| ///
((P33==5) & ESTU==1196)| /// 79
((P26==77) & ESTU==1968)| ///
((P2==2|P2==9) & ESTU==1867) | ///Desigualdad 90
((P16==77) & ESTU==1860)| /// Feb 1990
((P19==77) & ESTU==1910)| /// Dec 1990
((P24==77) & ESTU==1962) /// April 1991

* Number of KIDS 
gen nkids = P33 if ESTU==1196 & P33!=9 // 1979
replace nkids = 0 if ESTU==1196 & P33==5 // 5= ninguno

replace nkids = P18 if ESTU==1996 & P18!=99 //Aborto 1992
replace nkids = 0 if ESTU==1996 & P18==77 // 77= ninguno

replace nkids = P2A if ESTU==1867 & P2A!=99 // Desigualdad 1990
replace nkids = 0 if ESTU==1867 & P2A==0 // 0= ninguno

replace nkids = P26 if ESTU==1968 & P26!=99 // embarazo_aborto_1991
replace nkids = 0 if ESTU==1968 & P26==77 // 77= ninguno

replace nkids = P16 if ESTU==1860 & P16!=99 // Feb 1990
replace nkids = 0 if ESTU==1860 & P16==77 // 77= ninguno,99 NC

replace nkids = P19 if ESTU==1910 & P19!=99 // Dec 1990
replace nkids = 0 if ESTU==1910 & P19==77 // 77= ninguno,99 NC

replace nkids = P24 if ESTU==1962 & P24!=99 // Dec 1990
replace nkids = 0 if ESTU==1962 & P24==77 // 77= ninguno,99 NC



* Euthanasia
gen pro_euthanasia = 1 if ((P21== 1) & ESTU==1996)
replace pro_euthanasia = 0 if ((P21== 2) & ESTU==1996) 

gen pro_laweuthanasia = 1 if ((P22== 1) & ESTU==1996)
replace pro_laweuthanasia = 0 if ((P22== 2) & ESTU==1996) 
 
* QUESTION: de acuerdo o no con las recomendaciones de la iglesia sobre METODOS FECUNDACION ARTIFICIAL
gen pro_art_fert = 1 if ((P401 ==1) & ESTU==1860)| ///
((P901==1) & ESTU==1968)  // 
replace pro_art_fert =0 if ((P401==2) & ESTU==1860)| ///
((P901==1) & ESTU==1968)

* QUESTION: de acuerdo o no con las recomendaciones de la iglesia sobre ANTICONCEPTIVOS
gen pro_contracep = 1 if ((P402 ==1) & ESTU==1860)| ///
((P902==1) & ESTU==1968)  // 
replace pro_contracep =0 if ((P402==2) & ESTU==1860)| ///
((P902==1) & ESTU==1968)
* QUESTION: de acuerdo o no con las recomendaciones de la iglesia sobre ABORTO
 gen pro_abort_church = 1 if ((P403 ==1) & ESTU==1860)| /// feb 1990 and embarazo y aborto 1991
((P903==1) & ESTU==1968)  // 
replace pro_abort_church =0 if ((P403==2) & ESTU==1860)| ///
((P903==1) & ESTU==1968)

* QUESTION: hasta que punto es importante tener una vida familiar estable?
gen impor_stab_family = 1 if ((P13 <4) & ESTU==1382) //cuestiones valores 1983
replace impor_stab_family =0 if ((P13>=4 & P13 <=6) & ESTU==1382) //

* QUESTION: the father should have the last word in the family
gen father_lastword = 1 if ((P15 <4) & ESTU==1382) //cuestiones valores 1983
replace father_lastword =0 if ((P15>=4 & P15 <=6) & ESTU==1382) //

* QUESTION: la gente ha de ser libre para poder divorciarse
gen divorce_free = 1 if ((P17 <4) & ESTU==1382) // cuestiones valores 1983
replace divorce_free =0 if ((P17>=4 & P17 <=6) & ESTU==1382) 

* QUESTION: extremistas politicos no han de ser contratados como profesores
gen teachers_extrpolit = 1 if ((P20 <4) & ESTU==1382) // cuestiones valores 1983
replace teachers_extrpolit =0 if ((P20>=4 & P20 <=6) & ESTU==1382) 

* QUESTION: los alumnos han de tener voz y voto
gen students_particip = 1 if ((P21 <4) & ESTU==1382) // cuestiones valores 1983
replace students_particip =0 if ((P21>=4 & P21 <=6) & ESTU==1382) 

* QUESTION: el gobierno no se le puede permitir tomar deiciones fundamentales sin el consentimiento del pueblo
gen gov_withoutconsent = 1 if ((P23 <4) & ESTU==1382) // cuestiones valores 1983
replace gov_withoutconsent =0 if ((P23>=4 & P23 <=6) & ESTU==1382) 

* QUESTION:
gen benefit_marr_husb = 1 if ((P4 ==1) & ESTU==1867) // desigualdad familia 1990
replace benefit_marr_husb =0 if ((P4==2 |P4==3|P4==4) & ESTU==1867) 

* QUESTION:
gen benefit_marr_both = 1 if ((P4 ==3) & ESTU==1867) // desigualdad familia 1990
replace benefit_marr_both =0 if ((P4==1 |P4==2|P4==4) & ESTU==1867) 

* QUESTION:
gen ideal_fam_equal = 1 if ((P5 ==1) & ESTU==1867) // desigualdad familia 1990
replace ideal_fam_equal =0 if ((P5!=1 & P5!=8 & P5!=9) & ESTU==1867) 

* QUESTION:
gen ideal_fam_wifehome = 1 if ((P5 ==3) & ESTU==1867) // desigualdad familia 1990
replace ideal_fam_wifehome =0 if ((P5!=3 & P5!=8 & P5!=9) & ESTU==1867) 

* QUESTION:
gen husb_nothouseworks = 1 if ((P6 ==1) & ESTU==1867) // desigualdad familia 1990
replace husb_nothouseworks =0 if ((P6==2 ) & ESTU==1867) 

* QUESTION:
gen husb_lesshouseworks = 1 if ((P6A ==2|P6A ==3) & ESTU==1867) // desigualdad familia 1990
replace husb_lesshouseworks =0 if ((P6A==1) & ESTU==1867) 

* QUESTION:
gen stab_fidelity = 1 if ((P701 ==1|P701 ==2) & ESTU==1867) // desigualdad familia 1990
replace stab_fidelity =0 if ((P701 ==3|P701 ==4) & ESTU==1867) 

* QUESTION:
gen stab_respect = 1 if ((P704 ==1|P704 ==2) & ESTU==1867) // desigualdad familia 1990
replace stab_respect =0 if ((P704 ==3|P704 ==4) & ESTU==1867) 

* QUESTION:
gen stab_sharehousework = 1 if ((P711 ==1|P711 ==2) & ESTU==1867) // desigualdad familia 1990
replace stab_sharehousework =0 if ((P711 ==3|P711 ==4) & ESTU==1867) 

* QUESTION:
gen stab_kids = 1 if ((P712 ==1|P712 ==2) & ESTU==1867) // desigualdad familia 1990
replace stab_kids =0 if ((P712 ==3|P712 ==4) & ESTU==1867) 

* QUESTION:
gen stab_wifework = 1 if ((P714 ==1|P714 ==2) & ESTU==1867) // desigualdad familia 1990
replace stab_wifework =0 if ((P714 ==3|P714 ==4) & ESTU==1867) 

* QUESTION:
gen money_husband = 1 if ((P8 ==1|P8==2) & ESTU==1867) // desigualdad familia 1990
replace money_husband =0 if ((P8 !=1|P8!=2) & ESTU==1867) 

* QUESTION: actividad mas propia de marido o de la mujer?
gen control_natal_woman = 1 if ((P901 ==2) & ESTU==1867) // desigualdad familia 1990
replace control_natal_woman =0 if ((P901 ==1) & ESTU==1867) 

* QUESTION: actividad mas propia de marido o de la mujer?
gen control_natal_both = 1 if ((P901 ==3) & ESTU==1867) // desigualdad familia 1990
replace control_natal_both =0 if ((P901 ==1|P901 ==2) & ESTU==1867) 

* QUESTION: actividad mas propia de marido o de la mujer?
gen school_meet_wife = 1 if ((P908 ==2) & ESTU==1867) // desigualdad familia 1990
replace school_meet_wife =0 if ((P908 ==1|P908==3) & ESTU==1867) 

gen school_meet_both = 1 if ((P908 ==3) & ESTU==1867) // desigualdad familia 1990
replace school_meet_both =0 if ((P908 ==1|P908==2) & ESTU==1867) 

* QUESTION: actividad mas propia de marido o de la mujer?
gen absentwork_wife = 1 if ((P910 ==2) & ESTU==1867) // desigualdad familia 1990
replace absentwork_wife =0 if ((P910 ==1|P910==3) & ESTU==1867) 

gen absentwork_both = 1 if ((P910 ==3) & ESTU==1867) // desigualdad familia 1990
replace absentwork_both =0 if ((P910 ==1|P910==2) & ESTU==1867) 

* QUESTION: solo para casados o conviviendo: quien realiza la actividad?
gen cleanhouse_woman = 1 if ((P1006 ==2) & ESTU==1867) // desigualdad familia 1990
replace cleanhouse_woman =0 if ((P1006 !=2 & P1006!=9 ) & ESTU==1867) 

* QUESTION: las mujeres deben ser madres para sentirse realmente mujeres
gen realwoman_kids = 1 if ((P13 ==1) & ESTU==1867) // desigualdad familia 1990
replace realwoman_kids =0 if ((P13 ==2) & ESTU==1867) 

* QUESTION: los hombres deben ser padres para sentirse realmente hombres
gen realman_kids = 1 if ((P14 ==1) & ESTU==1867) // desigualdad familia 1990
replace realman_kids =0 if ((P14 ==2) & ESTU==1867) 

* QUESTION: los mujeres que trabajan fuera tienen doble trabajo
gen women_workdouble = 1 if ((P15 ==1) & ESTU==1867) // desigualdad familia 1990
replace women_workdouble =0 if ((P15 ==2) & ESTU==1867) 

* QUESTION: las obligaciones domesticas impiden a las mujeres trabajar fuera
gen housework_impede = 1 if ((P16 ==1|P16 ==2) & ESTU==1867) // desigualdad familia 1990
replace housework_impede =0 if ((P16 ==3|P16 ==4) & ESTU==1867) 

* QUESTION: WOMEN do you work?
gen women_work = 1 if ((P17 ==1) & ESTU==1867) // desigualdad familia 1990
replace women_work =0 if ((P17 ==2) & ESTU==1867) 

* QUESTION: WOMEN why dont you work?
gen decision_husb = 1 if ((P17C04 ==1) & ESTU==1867) // desigualdad familia 1990
replace decision_husb =0 if ((P17C04 ==2) & ESTU==1867) 

* QUESTION: WOMEN why dont you work?
gen decision_own = 1 if ((P17C05 ==1) & ESTU==1867) // desigualdad familia 1990
replace decision_own =0 if ((P17C05 ==2) & ESTU==1867) 

* QUESTION: WOMEN why dont you work?
gen toomuch_housework = 1 if ((P17C02 ==1) & ESTU==1867) // desigualdad familia 1990
replace toomuch_housework =0 if ((P17C02 ==2) & ESTU==1867)
 
* QUESTION: WOMEN why dont you work?
gen lack_preparation = 1 if ((P17C01 ==1) & ESTU==1867) // desigualdad familia 1990
replace lack_preparation =0 if ((P17C01 ==2) & ESTU==1867) 

* QUESTION: WOMEN why do you work?
gen everyb_works = 1 if ((P1801 ==1) & ESTU==1867) // desigualdad familia 1990
replace everyb_works =0 if ((P1801 ==2) & ESTU==1867) 

* QUESTION: WOMEN why do you work?
gen extra_money = 1 if ((P1803 ==1) & ESTU==1867) // desigualdad familia 1990
replace extra_money =0 if ((P1803 ==2) & ESTU==1867) 

* QUESTION: WOMEN why do you work?
gen need_econ = 1 if ((P1802 ==1) & ESTU==1867) // desigualdad familia 1990
replace need_econ =0 if ((P1802 ==2) & ESTU==1867) 
 
* QUESTION: WOMEN why do you work?
gen love_job = 1 if ((P1806 ==1) & ESTU==1867) // desigualdad familia 1990
replace love_job =0 if ((P1806 ==2) & ESTU==1867) 
   
* QUESTION: WOMEN why do you work?
gen free_housework = 1 if ((P1804 ==1) & ESTU==1867) // desigualdad familia 1990
replace free_housework =0 if ((P1804 ==2) & ESTU==1867) 
 
* QUESTION: WOMEN why do you work?
gen independent = 1 if ((P1807 ==1) & ESTU==1867) // desigualdad familia 1990
replace independent =0 if ((P1807 ==2) & ESTU==1867) 
 
* QUESTION: WOMEN why do you work?
gen relation_people = 1 if ((P1805 ==1) & ESTU==1867) // desigualdad familia 1990
replace relation_people =0 if ((P1805 ==2) & ESTU==1867) 
 

* QUESTION: How important is...
gen import_marry = 1 if ((P1901 ==1 | P1901==2) & ESTU==1867) // desigualdad familia 1990
replace import_marry =0 if ((P1901 ==3| P1901==4) & ESTU==1867) 
* QUESTION: How important is...
gen import_work = 1 if ((P1904 ==1 | P1904==2) & ESTU==1867) // desigualdad familia 1990
replace import_work =0 if ((P1904 ==3| P1904==4) & ESTU==1867) 
* QUESTION: How important is...
gen import_freesex= 1 if ((P1906 ==1 | P1906==2) & ESTU==1867) // desigualdad familia 1990
replace import_freesex =0 if ((P1906 ==3| P1906==4) & ESTU==1867) 
* QUESTION: How important is...
gen import_mother= 1 if ((P1907 ==1 | P1907==2) & ESTU==1867) // desigualdad familia 1990
replace import_mother =0 if ((P1907 ==3| P1907==4) & ESTU==1867) 

* QUESTION: the presence of women is important in politics
gen women_politics = 1 if ((P20 ==1 |P20==2) & ESTU==1867) // desigualdad familia 1990
replace women_politics =0 if ((P20 ==3 |P20==4) & ESTU==1867) 

* QUESTION: which political party worries about the presence of women in politics
gen women_politics_left = 1 if ((P21 ==2 |P21==4) & ESTU==1867) // desigualdad familia 1990
replace women_politics_left =0 if ((P21 ==1 |P21==3|P21==5|P21==6) & ESTU==1867) 

* QUESTION: No political party worries about the presence of women in politics
gen women_politics_none = 1 if ((P21 ==7) & ESTU==1867) // desigualdad familia 1990
replace women_politics_none =0 if ((P21!=7 & P21!=9) & ESTU==1867) 

* QUESTION: pertenece a un colectivo para conseguir equiparacion de la mujer con el hombre
gen union = 1 if ((P24 ==1|P24 ==2) & ESTU==1867) // desigualdad familia 1990
replace union =0 if ((P24==3) & ESTU==1867) 

* QUESTION: se consideraria victima de malos tratos si...
gen abuse_yellprivate = 1 if ((P3101 ==1) & ESTU==1867) // desigualdad familia 1990
replace abuse_yellprivate =0 if (P3101 ==2 & ESTU==1867) 

* QUESTION: se consideraria victima de malos tratos si...
gen abuse_yellpublic = 1 if ((P3102 ==1) & ESTU==1867) // desigualdad familia 1990
replace abuse_yellpublic =0 if (P3102 ==2 & ESTU==1867) 

* QUESTION: se consideraria victima de malos tratos si...
gen abuse_insult = 1 if ((P3103 ==1) & ESTU==1867) // desigualdad familia 1990
replace abuse_insult =0 if (P3103 ==2 & ESTU==1867) 

* QUESTION: se consideraria victima de malos tratos si...
gen abuse_threat = 1 if ((P3104 ==1) & ESTU==1867) // desigualdad familia 1990
replace abuse_threat =0 if (P3104 ==2 & ESTU==1867) 

* QUESTION: se consideraria victima de malos tratos si...
gen abuse_beatup = 1 if ((P3105 ==1) & ESTU==1867) // desigualdad familia 1990
replace abuse_beatup =0 if (P3105 ==2 & ESTU==1867) 

* QUESTION: Que grupo recibe malos tratos con frecuencia?
gen abuse_women = 1 if ((P3201 ==1|P3201 ==2) & ESTU==1867) // desigualdad familia 1990
replace abuse_women =0 if ((P3201 ==3|P3201 ==4) & ESTU==1867) 

* QUESTION: Que grupo recibe malos tratos con frecuencia?
gen abuse_men = 1 if ((P3202 ==1|P3202 ==2) & ESTU==1867) // desigualdad familia 1990
replace abuse_men =0 if ((P3202 ==3|P3202 ==4) & ESTU==1867) 

* QUESTION: la mujer que recibe malos tratos debe denunciar
gen abuse_report = 1 if ((P37 ==1) & ESTU==1867) // desigualdad familia 1990
replace abuse_report =0 if ((P37 ==2) & ESTU==1867) 

* QUESTION: la mujer que recibe malos tratos debe denunciar solo si...
gen abuse_report_any = 1 if ((P37A ==4) & ESTU==1867) // desigualdad familia 1990
replace abuse_report_any =0 if ((P37A ==1|P37A==2|P37A==3) & ESTU==1867) 

* QUESTION: Importance of...
gen import_family = P701  if ESTU==2001 & (P701!=88 & P701!=99)  // valores 92
gen import_politics = P703  if ESTU==2001 & (P703!=88 & P703!=99)  // 
gen import_religion = P705  if ESTU==2001 & (P705!=88 & P705!=99)  //   
gen import_work2 = P707  if ESTU==2001 & (P707!=88 & P707!=99)  //   
* QUESTION: Important for kids...
gen import_kids_authority = 1 if P801== 7 & ESTU==2001   //
replace import_kids_authority = 0 if (P801!= 7 & P801!= 88 |P801!= 99) & ESTU==2001

gen import_kids_relig = 1 if P802== 13 & ESTU==2001   //
replace import_kids_relig = 0 if (P802!= 13 & P802!= 88 |P802!= 99) & ESTU==2001
 
* QUESTION: characteristics your parents taught you
gen import_parent_authority = 1 if P8A01== 7 & ESTU==2001   //
replace import_parent_authority = 0 if (P8A01!= 7 & P8A01!= 88 |P8A01!= 99) & ESTU==2001

gen import_parent_relig = 1 if P8A01== 13 & ESTU==2001   //
replace import_parent_relig = 0 if (P8A01!= 13 & P8A01!= 88 |P8A01!= 99) & ESTU==2001
 
* QUESTION: comparte mismo punto vista sobre estos valores con tus padres...?
gen shareparent_religion = 1 if P1201== 1 & ESTU==2001   //
replace shareparent_religion = 0 if (P1201== 2) & ESTU==2001

gen shareparent_sex = 1 if P1204== 1 & ESTU==2001   //
replace shareparent_sex = 0 if (P1204== 2) & ESTU==2001

gen shareparent_marriage = 1 if P1206== 1 & ESTU==2001   //
replace shareparent_marriage = 0 if (P1206== 2) & ESTU==2001

gen shareparent_educ= 1 if P1207== 1 & ESTU==2001   //
replace shareparent_educ = 0 if (P1207== 2) & ESTU==2001

gen shareparent_work= 1 if P1205== 1 & ESTU==2001   //
replace shareparent_work = 0 if (P1205== 2) & ESTU==2001
 
* QUESTION: comparte mismo punto vista sobre estos valores con tus hijos...?
gen sharekids_religion = 1 if P12A01== 1 & ESTU==2001   //
replace sharekids_religion = 0 if (P12A01== 2) & ESTU==2001

gen sharekids_sex = 1 if P12A04== 1 & ESTU==2001   //
replace sharekids_sex = 0 if (P12A04== 2) & ESTU==2001

gen sharekids_marriage = 1 if P12A06== 1 & ESTU==2001   //
replace sharekids_marriage = 0 if (P12A06== 2) & ESTU==2001

gen sharekids_educ= 1 if P12A07== 1 & ESTU==2001   //
replace sharekids_educ = 0 if (P12A07== 2) & ESTU==2001

gen sharekids_work= 1 if P12A05== 1 & ESTU==2001   //
replace sharekids_work = 0 if (P12A05== 2) & ESTU==2001
 
* QUESTION: is an severe problem if your son divorces?
gen problem_son_divorces = 1 if P2004== 1 & ESTU==2001   //
replace problem_son_divorces = 0 if (P2004== 2) & ESTU==2001
 
* QUESTION: is an severe problem if your son lives without marrying?
gen problem_son_livetog = 1 if P2002== 1 & ESTU==2001   //
replace problem_son_livetog = 0 if (P2002== 2) & ESTU==2001
 
* QUESTION: is an severe problem if your son had a kid without getting married?
gen problem_son_kid = 1 if P2005== 1 & ESTU==2001   //
replace problem_son_kid = 0 if (P2005== 2) & ESTU==2001
  
* QUESTION: is an severe problem if your DAUGHTER divorces?
gen problem_dau_divorces = 1 if P20A04== 1 & ESTU==2001   //
replace problem_dau_divorces = 0 if (P20A04== 2) & ESTU==2001
 
* QUESTION: is an severe problem if your DAUGHTER lives without marrying?
gen problem_dau_livetog = 1 if P20A02== 1 & ESTU==2001   //
replace problem_dau_livetog = 0 if (P20A02== 2) & ESTU==2001
 
* QUESTION: is an severe problem if your son had a kid without getting married?
gen problem_dau_kid = 1 if P20A05== 1 & ESTU==2001   //
replace problem_dau_kid = 0 if (P20A05== 2) & ESTU==2001
  
* QUESTION: important for couple happiness  
gen happ_sharehousework = 1 if (P2410== 1|P2410== 2) & ESTU==2001   //
replace happ_sharehousework = 0 if (P2410== 3|P2410== 4) & ESTU==2001
  
gen happ_kids = 1 if (P2411== 1|P2411== 2) & ESTU==2001   // 92
replace happ_kids = 0 if (P2411== 3|P2411== 4) & ESTU==2001
    
gen happ_ecoindepend = 1 if (P2413== 1|P2413== 2) & ESTU==2001   //
replace happ_ecoindepend = 0 if (P2413== 3|P2413== 4) & ESTU==2001
    
  
* QUESTION: what would you prefer  
gen prefer_marry_church = 1 if (P26== 1) & ESTU==2001   // valores 1992
replace prefer_marry_church = 0 if (P26!= 1 & P26!=7 & P26!=8 & P26!=9) & ESTU==2001

gen prefer_marry_civil = 1 if (P26== 2) & ESTU==2001   //
replace prefer_marry_civil = 0 if (P26!= 2 & P26!=7 & P26!=8 & P26!=9) & ESTU==2001
    
gen prefer_live_notmarry = 1 if (P26== 5) & ESTU==2001   //
replace prefer_live_notmarry = 0 if (P26!= 5 & P26!=7 & P26!=8 & P26!=9) & ESTU==2001
        
**# Treatment starts in 1945 to people with 5 y.o. (born in 1940....)
gen year_birth=.
label var age "Age at interview"
foreach bar_year of numlist 1979 1983 1986 1987 1988 1990 1991 1992 1996{
replace year_birth = (`bar_year'-age) if year == `bar_year'
*replace years_treat = 10-(1945-year_birth)
} 

drop if age==.

sort  year_birth

keep ESTU-ENTREV year month type - year_birth
drop DISTR SECCION ENTREV //anonym
drop T1 // not informative
drop CCAA AREA TAMUNI MUN
order codprov id  type year month year_birth age
gen id_cis =_n

label var pro_abort_mumthreat "Threat mum"
label var pro_abort_mumdanger "Mum's life danger"
label var pro_abort_illbaby "Illness baby"
label var pro_abort_rape "Rape"
label var pro_abort_decisionmum "Mum's decision"
label var pro_abort_eco "Ec. conditions"
label var catholic "Catholic"
label var catholic2 "Catholic"
label var right "Vote Right"
label var right_ideology "Right ideol"
label var sex_education1 "Sex. educ 1"
label var sex_education2 "Sex. educ 2"
label var relig_educ_any "Relig educ any"
label var relig_educ_atleast1 "Relig educ"
label var pro_abort "Any reason"
label var pro_abort_12w "Within 12 w."
label var pro_art_fert "Pro art. fert"
label var pro_abort_church "Pro abortion-church"
label var pro_law_abort "Pro abortion"
label var tooprohib_law_abort "Law too prohib"
label var reduction_illegabort_sp "Law red illeg abort Sp"
label var reduction_illegabort_abr "Law red illeg abort Ab"
label var reduction_illegabort "Law red illeg abort"
label var pro_contracep "Pro contracept"
label var live_notmarried "Live tog, not married"
label var teachers_extrpolit "Not Extrem polit teaching"
label var students_particip "Students have vote"
label var gov_withoutconsent "Gvt decis without consent" 
label var pro_euthanasia "Pro euthanasia"
label var pro_laweuthanasia "Pro Law euthanasia"
label var impor_stab_family "Import stable fam"
label var father_lastword "Father last word"
label var divorce_free "Free divorce"
label var divorced_sep "Divorced or sep."
label var benefit_marr_husb "Marriage benefits husb."
label var ideal_fam_equal "Both work equally"
label var ideal_fam_wifehome "Husb works,wife home"
label var husb_nothouseworks "Husb not housework"
label var husb_lesshouseworks "Husb less housework"
label var stab_fidelity "Fidelity"
label var stab_respect "Respect"
label var stab_wifework "Wife works"
label var stab_sharehousework "Share housework"
label var money_husband "Money belongs husb"


label var unemployed "Unemployed (1979,86-88,90-92)"
label var pro_abort_illbaby "Pro abortion if baby illness (1986,90,91)"
label var teachers_extrpolit "Not extrem polit should be teaching"
label var husb_nothouseworks " Husband should not do housework (1990)"
label var stab_fidelity  "Fidelity imp. couple stability (1990)"
label var kids "Kids"
label var nkids "Number of kids (1979, 90-92)"
label var stab_kids "Kids imp. couple stability (1992)"
label var decision_husb "{it:Women not working:} husband's decision (1990)"
label var free_housework  "{it:Women working:} to liberate from housework (1990)"
label var union "Belongs to a femminist union or group (1990)"
label var divorced_sep "Divorced or sep"
label var pro_art_fert "Agree with Church about methods artificial fertil. (1990)" 
label var pro_contracep "Agree with Church about contraceptives methods (1990)" 
label var pro_abort_church "Agree with Church about abortion (1990)"
label var import_work  "Working is important for women (1990)" 	
label var control_natal_both "Both members should control natality (1990)"
label var problem_son_livetog "Problem if son lives together, not married (1992)" 
label var problem_dau_livetog "Problem if daughter lives together, not married (1992)"
label var problem_dau_kid "Problem if daughter has kids, not married (1992)"  
label var sharekids_religion "Share point of view about religion with kids (1992)" 
label var happ_kids "Kids imp. couple happiness (1992)"
label var everyb_works "{it:Women working:}  bc everybody should work (1990)"
label var import_marry "Important get married (1990)"
label var women_politics "Presence woman in politics is import. (1990)"
label var live_notmarried "Live together, not married (1990, 91, 92)"  
label var father_lastword "Father should have last word (1990)"
label var happ_sharehousework "Sharing housework import. couple happiness (1992)"
label var pro_abort_church "Agree with Church about abort (1990)"
label var abuse_yellprivate "Yelling in private is considered abuse (1990)" 
label var abuse_yellpublic  "Yelling in public is considered abuse (1990)"  	
label var sharekids_marriage "Share point of view about marriage with kids (1992)" 
label var prefer_marry_civil "Prefer civil marriage (1992)"	
label var prefer_marry_church  "Prefer relig. marriage (1992)"

save "$Data\CIS\_data_cis\barometros.dta", replace
use "$Data\CIS\_data_cis\barometros.dta", clear