* * * * * * * * * * * * 
**# Deaths during civil war period (defunciones) source: MNP, INE 1936-1939
* * * * * * * * * * * * 
import excel "$Data\MNP\defunciones\deaths.xlsx", sheet("Sheet1") firstrow clear
******  			    *******
**# Province code #
******  			    *******
gen codprov =4 if province == "almeria" 
replace codprov =11 if province == "cadiz" 
replace codprov =14 if province == "cordoba"  
replace codprov =18 if province == "granada"  
replace codprov =21 if province == "huelva" 
replace codprov =23 if province == "jaen" 
replace codprov =29 if province == "malaga" 
replace codprov =41 if province == "sevilla" 
replace codprov =22 if province == "huesca" 
replace codprov =44 if province == "teruel" 
replace codprov =50 if province == "zaragoza"
replace province = "asturias"  if province == "oviedo" 
replace codprov =33 if province == "asturias" 
replace codprov =7 if province == "baleares" 
replace province = "laspalmas"  if province == "palmas" 
replace province = "laspalmas"  if province == "palmas (las)" 
replace province = "laspalmas"  if province == "las palmas" 
replace codprov =35 if province == "laspalmas" 
replace province = "santa cruz de tenerife" if province == "tenerife" 
replace province = "santa cruz de tenerife" if province == "sta. c. tenerife" 
replace codprov =38 if province == "santa cruz de tenerife" 
replace province = "cantabria"  if province == "santander" 
replace codprov =39 if province == "cantabria" 
replace codprov =5 if province == "avila"
replace codprov =9 if province == "burgos" 
replace codprov =24 if province == "leon" 
replace codprov =25 if province == "lleida" 
replace codprov =34 if province == "palencia" 
replace codprov =37 if province == "salamanca" 
replace codprov =40 if province == "segovia" 
replace codprov =42 if province == "soria" 
replace codprov =47 if province == "valladolid"
replace codprov =49 if province == "zamora" 
replace codprov =2 if province == "albacete"
replace codprov =13 if province == "ciudad real" 
replace codprov =16 if province == "cuenca" 
replace codprov =19 if province == "guadalajara"
replace codprov =45 if province == "toledo"
replace codprov =8 if province == "barcelona" 
replace province = "gerona"  if province == "gerona" 
replace codprov =17 if province == "gerona" 
replace codprov =25 if province == "lerida" 
replace codprov =43 if province == "tarragona"
replace codprov =3 if province == "alicante" 
replace codprov =12 if province == "castellon" 
replace codprov =12 if province == "castellon de la p." 
replace codprov =46 if province == "valencia" 
replace codprov =6 if province == "badajoz" 
replace codprov =10 if province == "caceres" 
replace province = "a coruña"  if province == "coruna" 
replace province = "a coruña"  if province == "coruña" 
replace province = "a coruña"  if province == "coruña (la)" 
replace codprov =15 if province == "a coruña"
replace codprov =27 if province == "lugo"
replace province = "ourense"  if province == "orense" 
replace codprov =32 if province == "ourense"
replace codprov =36 if province == "pontevedra" 
replace codprov =28 if province == "madrid"
replace codprov =30 if province == "murcia"
replace codprov =31 if province == "navarra" 
replace codprov =1 if province == "alava" 
replace codprov =48 if province == "vizcaya"
replace codprov =20 if province == "guipuzcoa"
replace province = "larioja"  if province == "logrono" 
replace codprov =26 if province == "larioja"

forvalues year = 1936/1939 {
    egen deaths_total_`year' = rowtotal(deaths_male_`year' deaths_female_`year')
}

egen deaths_male_cwar = rowtotal(deaths_male_1936 deaths_male_1937 deaths_male_1938 deaths_male_1939)
egen deaths_female_cwar = rowtotal(deaths_female_1936 deaths_female_1937 deaths_female_1938 deaths_female_1939)
order codprov type province
* Compute the value "rest of province" for each single variable by substracting the value of each capital of province to the total value of the province
replace type="full province" if type =="total province"
foreach v of varlist deaths_male_1936 -deaths_female_cwar {
    replace `v' = -`v' if type == "full province"
	egen `v'_restprov = total(`v'), by(codprov )
	replace `v' = -`v'_restprov if type == "full province"
	drop `v'_restprov
}

replace type = "rest province" if type =="full province"
replace type = "municipality" if type =="capital"

save "$Data\MNP\defunciones\deaths_clean.dta", replace
