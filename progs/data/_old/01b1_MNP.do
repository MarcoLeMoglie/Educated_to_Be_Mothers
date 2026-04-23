use "$Data\MNP\NF\dta\MNP_1930_1953_clean.dta", clear //Noemi Facchetti


rename province_name province
replace geo_name = province if missing(geo_name)
rename administrative_unit type
*gen id_using=_n

replace province = lower(province)
replace province = subinstr(province, "í", "i",.) 
replace province = subinstr(province, "ó", "o",.) 
replace province = subinstr(province, "á", "a",.) 
replace province = subinstr(province, "é", "e",.) 
replace province = subinstr(province, "ú", "u",.) 

replace geo_name = lower(geo_name)
replace geo_name = subinstr(geo_name, "í", "i",.) 
replace geo_name = subinstr(geo_name, "ó", "o",.) 
replace geo_name = subinstr(geo_name, "á", "a",.) 
replace geo_name = subinstr(geo_name, "Á", "a",.) 
replace geo_name = subinstr(geo_name, "é", "e",.) 
replace geo_name = subinstr(geo_name, "ú", "u",.) 


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
replace province = "larioja"  if province == "logroño" 
replace codprov =26 if province == "larioja"

replace type = "municipality" if province==geo_name & type =="capital"
replace type = "rest province" if type =="rest of province"
replace geo_name = type if type =="rest province"

replace geo_name = "coruña, a" if geo_name =="coruña (la)"

replace geo_name = "puerto de santa maria, el" if geo_name =="puerto de santa maria"
replace geo_name = "castello de la plana" if geo_name =="castellon de la p."
replace geo_name = "peñarroya-pueblonuevo" if geo_name =="penaroya pueblonuevo"
replace type = "municipality" if type =="capital"
replace geo_name = "ferrol" if geo_name =="ferrol del caudillo"

*replace type = "municipality" if geo_name =="logroño"
replace geo_name = "ourense" if geo_name =="orense"
*replace type = "municipality"  if geo_name =="ourense"
replace geo_name = "alicante/alacant" if geo_name =="alicante"
replace geo_name = "sagunto/sagunt" if geo_name =="sagunto"
replace geo_name = "girona" if geo_name =="gerona"
replace geo_name = "santiago de compostela" if geo_name =="santiago"
replace geo_name = "pamplona/iruña" if geo_name =="navarra"
replace geo_name = "barakaldo" if geo_name =="baracaldo"
replace geo_name = "vitoria-gasteiz" if geo_name =="alava"
replace geo_name = "cangas del narcea" if geo_name =="cangas de narcea"
replace geo_name = "lleida" if geo_name =="lerida"
replace geo_name = "palmas de gran canaria, las" if geo_name =="palmas (las)"
replace geo_name = "santa cruz de tenerife" if geo_name =="sta. c. tenerife"
replace geo_name = "linea de la concepcion, la" if geo_name =="linea (la)"
replace geo_name = "puerto de santa maria, el" if geo_name =="puerto de santa maria (el)"
replace geo_name = "puente genil" if geo_name =="puente-genil"
replace geo_name = "ubeda" if geo_name =="Úbeda"
replace geo_name = "cangas del narcea" if geo_name =="cangas da narcea"
replace geo_name = "san cristobal de la laguna" if geo_name =="laguna (la)"
replace geo_name = "ecija" if geo_name =="Écija"
replace geo_name = "coruña, a" if geo_name =="coruña, a"
replace geo_name = "ortigueira" if geo_name =="ortigueira"
replace geo_name = "velez malaga" if geo_name =="velez-malaga"
replace geo_name = "ferrol" if geo_name =="ferrol (el)"
replace geo_name = "la estrada" if geo_name =="estrada (la)"
replace geo_name = "la orotava" if geo_name =="orotava (la)"
replace geo_name = "" if geo_name ==""
replace geo_name = "" if geo_name ==""
replace geo_name = "" if geo_name ==""
replace geo_name = "" if geo_name ==""
replace geo_name = "" if geo_name ==""
replace geo_name = "" if geo_name ==""
replace geo_name = "" if geo_name ==""


replace geo_name = "linea de la concepcion, la" if geo_name =="la linea"
replace geo_name = "vila-real" if geo_name =="villarreal"
replace geo_name = "bilbao" if geo_name =="vizcaya"
replace geo_name = "alcoy/alcoi" if geo_name =="alcoy"
replace geo_name = "donostia/san sebastian" if geo_name =="guipuzcoa"
replace geo_name = "san cristobal de la laguna" if geo_name =="la laguna"

replace geo_name = "elche/elx" if geo_name =="elche"
replace geo_name = "valdepeñas" if geo_name =="valdepenas"
replace geo_name = "palma" if geo_name =="baleares"
replace geo_name = "alzira" if geo_name =="alcira"
replace geo_name = "hospitalet de llobregat, l'" if geo_name =="hospitalet"
replace geo_name = "alcala de guadaira" if geo_name =="alcala de quadaira"

replace geo_name = "terrassa" if geo_name =="tarrasa"

drop if type =="province"

replace death_dur = 0 if death_dur<0 //mistake with zaragoza
save "$Data\MNP\NF\dta\MNP_1930_1953_clean_v2.dta", replace
0
use "$Data\MNP\NF\dta\MNP_1930_1953_clean_v2.dta", clear
egen idgeo_name = group(geo_name type province)
sort geo_name type

order idgeo
sort idgeo year
9
egen wanted = total(inrange(year, 1930, 1953)), by(idgeo_name)
tab wanted
keep type province geo_name codprov 
duplicates drop