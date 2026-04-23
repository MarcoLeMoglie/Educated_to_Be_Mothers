*******************************
* Población calculada, por capitales, en 1º de julio de cada año.-1951 a 1960
* Anuario 1952
**# Population: total province
*******************************
import excel "$Data\population\poblacion_prov_1950_60.xlsx", sheet("Sheet1") firstrow clear

rename (B-K) (pop_1951 pop_1952 pop_1953 pop_1954 pop_1955 pop_1956 pop_1957 pop_1958 pop_1959 pop_1960)

replace province = lower(province)
replace province = strtrim(province)
replace province = subinstr(province, "á", "a",.) 
replace province = subinstr(province, "é", "e",.) 
replace province = subinstr(province, "í", "i",.) 
replace province = subinstr(province, "ó", "o",.) 
replace province = subinstr(province, "ú", "u",.) 
**# Province code #
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
replace codprov =35 if province == "laspalmas" 
replace codprov =38 if province == "santa cruz de tenerife" 
replace province = "cantabria"  if province == "santander" 
replace codprov =39 if province == "cantabria" 
replace codprov =5 if province == "avila"
replace codprov =9 if province == "burgos" 
replace codprov =24 if province == "leon" 
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
replace codprov =17 if province == "gerona" 
replace codprov =25 if province == "lerida" 
replace codprov =43 if province == "tarragona"
replace codprov =3 if province == "alicante" 
replace codprov =12 if province == "castellon" 
replace codprov =46 if province == "valencia" 
replace codprov =6 if province == "badajoz" 
replace codprov =10 if province == "caceres" 
replace codprov =15 if province == "coruña a"
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
replace province = "larioja"  if province == "logroño" 
replace codprov =26 if province == "larioja"

gen type = "full province"
gen municip = "full province"
save "$Data\population\poblacion_prov_1950_60.dta", replace
*******************************
**# Population: capital province
*******************************
import excel "$Data\population\poblacion_cap_1950_60.xlsx", sheet("Sheet1") firstrow clear

rename (B-K) (pop_1951 pop_1952 pop_1953 pop_1954 pop_1955 pop_1956 pop_1957 pop_1958 pop_1959 pop_1960)

rename CAPITAL province
replace province = lower(province)
replace province = strtrim(province)
replace province = subinstr(province, "á", "a",.) 
replace province = subinstr(province, "é", "e",.) 
replace province = subinstr(province, "í", "i",.) 
replace province = subinstr(province, "ó", "o",.) 
replace province = subinstr(province, "ú", "u",.) 

gen municip = province
order province municip
**# Province code #
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
replace codprov =35 if province == "las palmas" 
replace codprov =38 if province == "santa cruz de tenerife" 
replace province = "cantabria"  if province == "santander" 
replace codprov =39 if province == "cantabria" 
replace codprov =5 if province == "avila"
replace codprov =9 if province == "burgos" 
replace codprov =24 if province == "leon" 
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
replace codprov =17 if province == "gerona" 
replace codprov =25 if province == "lerida" 
replace codprov =43 if province == "tarragona"
replace codprov =3 if province == "alicante" 
replace codprov =12 if province == "castellon" 
replace codprov =46 if province == "valencia" 
replace codprov =6 if province == "badajoz" 
replace codprov =10 if province == "caceres" 
replace codprov =15 if province == "coruña a"
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
replace province = "larioja"  if province == "logroño" 
replace codprov =26 if province == "larioja"

gen type = "capital"

save "$Data\population\poblacion_cap_1950_60.dta", replace
*******************************
**# Population: municipalities
*******************************
import excel "$Data\population\poblacion_municipios_1950.xlsx", sheet("Sheet1") firstrow clear

replace municip = lower(municip)

replace municip = subinstr(municip, ",", "",.) 

replace municip = subinstr(municip, "( la )", "la",.) 
replace municip = subinstr(municip, "( el )", "el",.) 
replace municip = subinstr(municip, "-", "",.) 
replace municip = strtrim(municip)

/*
replace municip = subinstr(municip, "á", "a",.) 
replace municip = subinstr(municip, "é", "e",.) 
replace municip = subinstr(municip, "í", "i",.) 
replace municip = subinstr(municip, "ó", "o",.) 
replace municip = subinstr(municip, "ú", "u",.) 
*/
replace province = lower(province)
replace province = strtrim(province)
replace province = subinstr(province, "á", "a",.) 
replace province = subinstr(province, "é", "e",.) 
replace province = subinstr(province, "í", "i",.) 
replace province = subinstr(province, "ó", "o",.) 
replace province = subinstr(province, "ú", "u",.) 
**# Province code #1
gen codprov =4 if province == "almeria" 
replace codprov =11 if province == "cadiz" 
replace codprov =14 if province == "cordoba"  
replace codprov =18 if province == "granada"  
replace codprov =21 if province == "huelva" 
replace codprov =23 if province == "jaen" 
replace codprov =29 if province == "malaga" 
replace codprov =41 if province == "sevilla" 
replace codprov =50 if province == "zaragoza"
replace codprov =7 if province == "baleares" 
replace province = "las palmas"  if province == "palmas ( las )" 
replace codprov =35 if province == "las palmas" 
replace codprov =38 if province == "santa cruz de tenerife" 
replace province = "cantabria"  if province == "santander" 
replace codprov =39 if province == "cantabria" 
replace codprov =9 if province == "burgos" 
replace codprov =24 if province == "leon" 
replace codprov =37 if province == "salamanca" 
replace codprov =47 if province == "valladolid"
replace codprov =49 if province == "zamora" 
replace codprov =2 if province == "albacete"
replace codprov =13 if province == "ciudad real" 
replace codprov =45 if province == "toledo"
replace codprov =8 if province == "barcelona" 
replace codprov =17 if province == "gerona" 
replace codprov =43 if province == "tarragona"
replace codprov =3 if province == "alicante" 
replace codprov =12 if province == "castellon" 
replace codprov =46 if province == "valencia" 
replace codprov =6 if province == "badajoz" 
replace codprov =10 if province == "caceres" 
replace province = "coruña a"  if province == "coruña ( la )" 
replace codprov =15 if province == "coruña a"
replace codprov =27 if province == "lugo"
replace province = "ourense"  if province == "orense" 
replace codprov =32 if province == "ourense"
replace codprov =36 if province == "pontevedra" 
replace codprov =28 if province == "madrid"
replace codprov =30 if province == "murcia"
replace codprov =31 if province == "navarra" 
replace codprov =48 if province == "vizcaya"
replace codprov =20 if province == "guipuzcoa"
replace province = "larioja"  if province == "logroño" 
replace codprov =26 if province == "larioja"

replace municip = "valdés" if municip =="luarca"


rename pop_hecho pop_1950_hecho 
rename pop_derecho pop_1950_derecho
gen type = "municipality"
save "$Data\population\poblacion_municipios_1950.dta", replace


*******************************
**# Append previous population datasets
*******************************
use "$Data\population\poblacion_prov_1950_60.dta", clear
append using "$Data\population\poblacion_cap_1950_60.dta"
*append using "$Data\population\poblacion_municipios_1950.dta"
order province codprov municip //pop_1950_*

replace municip = "lleida" if municip =="lerida"
replace province = "lleida" if province =="lerida"


replace type = "municipality" if municip=="gerona" //bcse there is no data for gerona municipality


**# Compute the value "rest of province" for each single variable by substracting the value of each capital of province and the municipalities (if any) to the total value of the province
foreach v of varlist pop_1951 -pop_1960 {
    replace `v' = -`v' if type == "full province" & `v' !=.
	egen `v'_restprov = total(`v'), by(codprov)
	replace `v' = -`v'_restprov if type == "full province" & `v' !=.
	drop `v'_restprov
}

replace municip = province if type =="full province"
replace type = "rest province" if type =="full province"

replace type = "municipality" if province==municip & type =="capital"
replace type = "municipality" if municip == "orense" 
*rename pop_1950_hecho pop_hecho_1950
*rename pop_1950_derecho pop_derecho_1950
gen id_wide =_n


reshape long pop_   , i(id_wide) j(year)
gen id_using = _n
sort codprov type year
replace municip = "ourense" if municip =="orense" & type=="municipality"
replace municip = "vitoria-gasteiz" if municip =="alava" & type=="municipality"
replace municip = "donostia/san sebastian" if municip =="guipuzcoa" & type=="municipality"
replace municip = "pamplona/iruña" if municip =="navarra" & type=="municipality"

replace municip = "rest province" if type =="rest province"


replace municip = subinstr(municip, "à", "a", .) //supress the accents
replace municip = subinstr(municip, "á", "a", .) //supress the accents
replace municip = subinstr(municip, "é", "e", .) //supress the accents
replace municip = subinstr(municip, "è", "e", .) //supress the accents
replace municip = subinstr(municip, "í", "i", .) //supress the accents
replace municip = subinstr(municip, "ó", "o", .) //supress the accents
replace municip = subinstr(municip, "ú", "u", .) //supress the accents
replace municip = subinstr(municip, "ó", "o", .) //supress the accents

replace municip = "alicante/alacant" if municip =="alicante"
replace municip = "sagunto/sagunt" if municip =="sagunto"
replace municip = "girona" if municip =="gerona"
replace municip = "santiago de compostela" if municip =="santiago"
replace municip = "barakaldo" if municip =="baracaldo"
replace municip = "cangas del narcea" if municip =="cangas de narcea"
replace municip = "castello de la plana" if municip =="castellon"
replace municip = "vila-real" if municip =="villarreal"
replace municip = "bilbao" if municip =="vizcaya"
replace municip = "alcoy/alcoi" if municip =="alcoy"
replace municip = "elche/elx" if municip =="elche"
replace municip = "palma" if municip =="baleares"
replace municip = "alzira" if municip =="alcira"
replace municip = "puerto de santa maria, el" if municip =="puerto de santa maria el"
replace municip = "san cristobal de la laguna" if municip =="laguna la"


replace municip = "terrassa" if municip =="tarrasa"
replace municip = "jerez de la frontera" if municip =="jerez de la rontera"
replace municip = "linea de la concepcion, la" if municip =="linea la"
replace municip = "palmas de gran canaria, las" if municip =="las palmas"


replace municip = "peñarroya-pueblonuevo" if municip =="peñarroya  pueblonuevo"

replace municip = "coruña, a" if municip =="coruña a"
replace municip = "ferrol" if municip =="ferrol del caudillo el"
replace municip = "ortigueira" if municip =="ortigueira"
replace municip = "ubeda" if municip =="Übeda"
replace type = "municipality" if municip =="logroño"
replace type = "municipality" if municip =="oviedo"
replace type = "municipality" if municip =="santander"

replace municip = "hospitalet de llobregat, l'" if municip =="hospitalet"

replace codprov =33 if province == "asturias" 
replace province = "las palmas" if province== "laspalmas"
replace province = "a coruña" if province== "coruña a"
drop if year ==1951|year==1952|year==1953
save "$Data\population\poblacion_1950s.dta", replace
use "$Data\population\poblacion_1950s.dta", clear

* * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * *
**# PROVINCE LEVEL DATASET
* * * * * * * * * * * * * * * * * * * * *
* * * * * * * * * * * * * * * * * * * * *
*******************************
* Población calculada, por capitales, en 1º de julio de cada año.-1951 a 1960
* Anuario 1952
**# Population: total province
*******************************
import excel "$Data\population\poblacion_prov_1950_60.xlsx", sheet("Sheet1") firstrow clear

rename (B-K) (pop_1951 pop_1952 pop_1953 pop_1954 pop_1955 pop_1956 pop_1957 pop_1958 pop_1959 pop_1960)

replace province = lower(province)
replace province = strtrim(province)
replace province = subinstr(province, "á", "a",.) 
replace province = subinstr(province, "é", "e",.) 
replace province = subinstr(province, "í", "i",.) 
replace province = subinstr(province, "ó", "o",.) 
replace province = subinstr(province, "ú", "u",.) 
**# Province code #
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
replace codprov =35 if province == "laspalmas" 
replace codprov =38 if province == "santa cruz de tenerife" 
replace province = "cantabria"  if province == "santander" 
replace codprov =39 if province == "cantabria" 
replace codprov =5 if province == "avila"
replace codprov =9 if province == "burgos" 
replace codprov =24 if province == "leon" 
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
replace codprov =17 if province == "gerona" 
replace codprov =25 if province == "lerida" 
replace codprov =43 if province == "tarragona"
replace codprov =3 if province == "alicante" 
replace codprov =12 if province == "castellon" 
replace codprov =46 if province == "valencia" 
replace codprov =6 if province == "badajoz" 
replace codprov =10 if province == "caceres" 
replace codprov =15 if province == "coruña a"
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
replace province = "larioja"  if province == "logroño" 
replace codprov =26 if province == "larioja"

 
order province codprov   //pop_1950_*
 
replace province = "lleida" if province =="lerida"

gen id_wide =_n


reshape long pop_   , i(id_wide) j(year)
gen id_using = _n
sort codprov year
 
replace codprov =33 if province == "asturias" 
replace province = "las palmas" if province== "laspalmas"
replace province = "a coruña" if province== "coruña a"
drop if year ==1951|year==1952|year==1953
save "$Data\population\poblacion_1950s_PROVINCElevel.dta", replace
use "$Data\population\poblacion_1950s_PROVINCElevel.dta", clear