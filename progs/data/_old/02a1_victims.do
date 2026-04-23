********************************************************************************
* Import Victims and reprisals of Franco. Data from PARES 
********************************************************************************
foreach num of numlist 1 5 {
cd $dir
clear all
import delimited "$Data\purge\PARES\pares`num'.csv"
rename (v1 v2 v4 v5 v6 v7 v8 v9 v11 v13 v14) (id name surname location profession archive fondo serie year type obs)
format %10s id 
format %10s name 
format %10s location
split year, parse("-" "/") generate(year_) limit(4)
drop v3 v10 v12 //pages

keep id location profession archive year_1 year_2 name type
save "$Data\purge\PARES\pares`num'.dta", replace
}

foreach num of numlist 2 3 4 {
cd $dir
clear all
import delimited "$Data\purge\PARES\pares`num'.csv"
rename (v1 v2 v4 v5 v6 v7 v8 v9 v11 v13 v14) (id name surname location profession archive fondo serie year type obs)
format %10s id 
format %10s name 
format %10s location
split year, parse("-" "/") generate(year_) limit(4)
drop v3 v10 v12 //pages
drop if  strpos(id , "a") > 0

keep id location profession archive year_1 year_2 year_3 name type
save "$Data\purge\PARES\pares`num'.dta", replace
}
**********************************
* Append the 5 datasets
**********************************
cd $dir
clear all
use  "$Data\purge\PARES\pares1.dta"
append using  "$Data\purge\PARES\pares2.dta"
append using  "$Data\purge\PARES\pares3.dta"
append using  "$Data\purge\PARES\pares4.dta"
append using  "$Data\purge\PARES\pares5.dta"

format %10s id 
format %15s location
format %15s profession
format %15s archive

*names*
replace name = upper(name)
replace name = subinstr(name, "Á", "A",.) 
replace name = subinstr(name, "", "E",.) 
replace name = subinstr(name, "", "I",.) 
replace name = subinstr(name, "", "O",.) 
replace name = subinstr(name, "", "U",.) 

replace name = subinstr(name, "á", "A",.) 
replace name = subinstr(name, "é", "E",.) 
replace name = subinstr(name, "í", "I",.) 
replace name = subinstr(name, "ó", "O",.) 
replace name = subinstr(name, "ú", "U",.) 

replace name = subinstr(name, "Mª.", "MARIA",.) 
replace name = upper(name)

gen idmaster = _n
format %10s name

generate str name_string = name
replace name = ""
compress name
replace name = name_string
drop name_string
describe name


reclink2 name using "$Data\WGND_WIPO\wgnd_ctry.dta", idmaster(idmaster) idusing(idusing) gen(newvar)
drop Uname idmaster idusing _merge newvar name
replace gender ="" if gender =="?"
gen male = 1 if gender =="M"
replace male = 0 if gender =="F"               

foreach num of numlist 1 2 3   {
replace  year_`num' = subinstr( year_`num', "!", "1", .) 
replace  year_`num' = subinstr( year_`num', ",", "", .) 
replace  year_`num' = subinstr( year_`num', "ç", "", .) 
replace  year_`num' = subinstr( year_`num', "sin fec", "", .) 
replace  year_`num' = subinstr( year_`num', "a", "", .)
replace  year_`num' = subinstr( year_`num', "e", "", .)
replace  year_`num' = subinstr( year_`num', "C", "", .)
replace  year_`num' = subinstr( year_`num', "J", "", .)
replace  year_`num' = subinstr( year_`num', "S", "", .)
replace  year_`num' = subinstr( year_`num', ".", "", .)
replace  year_`num' = subinstr( year_`num', "F", "", .)
replace  year_`num' = subinstr( year_`num', "o", "", .)
replace  year_`num' = subinstr( year_`num', "n", "", .)
replace  year_`num' = subinstr( year_`num', "s", "", .)
replace  year_`num' = subinstr( year_`num', "c", "", .)
replace  year_`num' = subinstr( year_`num', ":", "", .)
replace  year_`num' = subinstr( year_`num', "L", "", .)
replace  year_`num' = subinstr( year_`num', "lm", "", .)
replace  year_`num' = subinstr( year_`num', "ár", "", .)
replace  year_`num' = subinstr( year_`num', "'", "", .)
replace  year_`num' = subinstr( year_`num', "f", "", .)
replace  year_`num' = subinstr( year_`num', "h", "", .)
replace  year_`num' = subinstr( year_`num', "Epñ)", "", .)
replace  year_`num' = subinstr( year_`num', "Hu", "", .)
replace  year_`num' = subinstr( year_`num', "Tdr)", "", .)

replace  year_`num' = subinstr( year_`num', "ritóbl)", "", .)
replace  year_`num' = subinstr( year_`num', "é;AlluéRluy", "", .)
replace year_`num' = subinstr(year_`num', `"""',  "", .) // remove quotes
replace  year_`num' = subinstr( year_`num', "AUA_GENERA1504 j 2 Expdit 5", "", .)
replace  year_`num' = subinstr( year_`num', "AUA_GENERA1505 j 1 Expdit 1", "", .)
replace  year_`num' = subinstr( year_`num', "AUA_GENERA1511 j 2 Expdit 3", "", .)
replace  year_`num' = stritrim( year_`num') // with all consecutive, internal blanks collapsed to one blank
replace year_`num'= strtrim(year_`num') // leading and trailing blanks removed.
replace year_`num' = stritrim(year_`num') // with all consecutive, internal blanks collapsed to one blank
}

destring year_*, replace
replace year_1 =year_3 if year_3 !=.
replace year_2 =. if year_3 !=.
drop year_3
replace year_2=. if year_1==year_2
foreach num of numlist   34  36 37 38 39 40 41 42 43 44 45 46 47 {
replace year_1 =1900+`num' if year_1==`num'
}
replace year_1=1938 if year_1==19389
replace year_1=1956 if year_1==19561
replace year_1=1938 if year_1==19389
replace year_1=1960 if year_1==19604
replace year_1=1986 if year_1==19861

drop if location =="" //490,312 observations deleted because of unknown location

replace location =upper(location)
format %30s location
format %15s type

replace  location = stritrim( location) // with all consecutive, internal blanks collapsed to one blank
replace location= strtrim(location) // leading and trailing blanks removed.
replace location = stritrim(location) // with all consecutive, internal blanks collapsed to one blank
replace location = subinstr(location, "ñ", "Ñ", .) //EÑE

replace location = subinstr(location, "Á", "A", .) //supress the accents
replace location = subinstr(location, "É", "E", .) //supress the accents
replace location = subinstr(location, "à", "A", .) //supress the accents
replace location = subinstr(location, "á", "A", .) //supress the accents
replace location = subinstr(location, "é", "E", .) //supress the accents
replace location = subinstr(location, "è", "E", .) //supress the accents
replace location = subinstr(location, "í", "I", .) //supress the accents
replace location = subinstr(location, "ó", "O", .) //supress the accents
replace location = subinstr(location, "ú", "U", .) //supress the accents
replace location = subinstr(location, "Í", "I", .) //supress the accents
replace location = subinstr(location, "Ó", "O", .) //supress the accents
replace location = subinstr(location, "ó", "O", .) //supress the accents
replace location = subinstr(location, "Ú", "U", .) //supress the accents
replace location = subinstr(location, ".", "", .) //supress the ortographical points
replace location = subinstr(location, ",", "", .) //supress the ortographical points (comma)

replace location = subinstr(location, "CASTELLON/CASTELLO", "CASTELLON", .) 
replace location = subinstr(location, "VALENCIA/VALENCIA", "VALENCIA", .) 
replace location = subinstr(location, "ALICANTE/ALACANT", "ALICANTE", .) 
replace location = subinstr( location, "(ESPAÑA)", "", .)
replace location = subinstr(location, "VIZCAYA", "BIZKAIA", .) 
replace location = subinstr(location, "VIZCAIA", "BIZKAIA", .) 

replace  location = stritrim( location) // with all consecutive, internal blanks collapsed to one blank
replace location= strtrim(location) // leading and trailing blanks removed.
replace location = stritrim(location) // with all consecutive, internal blanks collapsed to one blank


gen province =""
save "$dir\$Output_data\purge\victims_archive.dta",replace
***********************************
***********************************
***********************************
clear all
use  "$dir\$Output_data\purge\victims_archive.dta"

replace location = subinstr(location, "CIUDAD REAL", "CIUDADREAL", .) //change the name, so that the province name can be change from LOCATION to PROVINCE. We redo this later on
replace location = subinstr(location, "SANTA CRUZ DE TENERIFE", "SCTENERIFE", .) //change the name
replace location = subinstr(location, "A CORUÑA", "ACORUÑA", .) //change the name
replace location = subinstr(location, "CORUÑA (A)", "ACORUÑA", .) //change the name

*if location contains the name of a province, then write it in the new variable PROVINCE
foreach x in ARGENTINA CUBA URSS FRANCIA FRANCE ALAVA ALBACETE ALICANTE ALMERIA ASTURIAS AVILA BADAJOZ  BALEARS BARCELONA BIZKAIA  BURGOS CACERES CADIZ CANTABRIA CASTELLON CIUDADREAL  ACORUÑA CORDOBA CUENCA GERONA GIRONA GRANADA GUADALAJARA GUIPUZCOA HUELVA HUESCA BALEARES JAEN ACORUÑA RIOJA PALMAS LEON LLEIDA LERIDA LUGO MADRID MALAGA MURCIA NAVARRA OURENSE PALENCIA PONTEVEDRA SALAMANCA SEGOVIA SEVILLA SORIA TARRAGONA TENERIFE TERUEL TOLEDO VALENCIA VALLADOLID VIZCAYA ZAMORA ZARAGOZA{
replace province ="`x'"  if strpos(location, "`x'")
*if the above was fine, then delete the name of the province from the variable location
replace location = subinstr(location, "`x'", "", .) 
}
rename  location municip



drop if municip =="" // 15,992 observations deleted because of unknown municip. 	Note: second time I delete bc of unkown
drop if  length(municip)==1
drop if  length(municip)==2
drop if  length(municip)==3

replace municip = subinstr(municip, "¿", "", .) //supress the ortographical points 
replace municip = subinstr(municip, "?", "", .) //supress the ortographical points 
replace municip = subinstr(municip, "-", "", .) //supress the ortographical points 
replace municip = subinstr(municip, ";", "", .) //supress the ortographical points 
replace municip = subinstr(municip, "(", "", .) //supress the ortographical points (parenthesis)
replace municip = subinstr(municip, ")", "", .) //supress the ortographical points (parenthesis)
replace municip = subinstr(municip, "ESPAÑA", "", .) //supress españa
replace municip = subinstr(municip, "ILLES", "", .) //supress illes
replace municip = subinstr(municip, "XATIVA", "JATIVA", .) //change the name
replace municip = subinstr(municip, "JIJONA/XIXONA", "JIJONA", .) //change the name
replace municip = subinstr(municip, "JAVEA/XABIA", "JAVEA", .) //change the name
replace municip = subinstr(municip, "MONOVAR/MONòVER", "MONOVAR", .) //change the name
replace municip = subinstr(municip, "TORREMANZANAS/TORRE DE LES MAçANES LA", "TORREMANZANAS", .) //change the name
replace municip = subinstr(municip, "SAN VICENTE DEL RASPEIG/SANT VICENT DEL RASPEIG", "SAN VICENTE DEL RASPEIG", .) //change the name


replace  municip = stritrim( municip) // with all consecutive, internal blanks collapsed to one blank
replace municip= strtrim(municip) // leading and trailing blanks removed.
replace municip = stritrim(municip) // with all consecutive, internal blanks collapsed to one blank

replace  province = stritrim( province) // with all consecutive, internal blanks collapsed to one blank
replace province= strtrim(province) // leading and trailing blanks removed.
replace province = stritrim(province) // with all consecutive, internal blanks collapsed to one blank

/*
split location, parse("," "(") generate(municip) limit(2)
drop location
rename municip1 municip
rename municip2 province2
*/
format %25s municip
format %15s province
***********************************
replace province ="ALICANTE" if strpos(province , "ALICANT") > 0
replace province ="VALENCIA" if strpos(province , "VALENCIA") > 0
replace province ="CASTELLON"  if strpos(province , "CASTELLON") > 0
replace province ="LA RIOJA" if strpos(province , "RIOJA") > 0
replace province ="ILLES BALEARS"  if strpos(province , "BALEARS") > 0
replace province ="A CORUÑA"  if strpos(province , "ACORUÑA") > 0
replace province ="LAS PALMAS"  if strpos(province , "PALMAS") > 0
replace province ="LLEIDA"  if strpos(province , "LERIDA") > 0
replace province ="GIRONA"  if strpos(province , "GERONA") > 0
replace province ="CIUDAD REAL"  if strpos(province , "CIUDADREAL") > 0
replace province ="VIZCAYA"  if strpos(province , "BIZKAIA") > 0
replace province ="SANTA CRUZ DE TENERIFE"  if strpos(province , "SCTENERIFE") > 0


replace municip ="ELCHE" if strpos(municip , "ELCHE") > 0
replace municip ="ADAMUZ" if strpos(municip , "ADAMUZ") > 0
replace municip ="ADRADA(LA)" if strpos(municip , "ADRADA") > 0
replace municip ="ALBATERA" if strpos(municip , "ALBATERA") > 0
replace municip ="ALBOLOTE" if strpos(municip , "ALBOLOTE") > 0 //CHECK
replace municip ="ALDEANUEVA DE CAMINO" if strpos(municip , "ALDEANUEVA DEL CAMINO") > 0
replace municip ="ALEGRIA" if strpos(municip , "ALEGRIA-DULANT") > 0
replace municip ="ALHAMA DE MURCIA" if strpos(municip , "ALHAMA MURCIA") > 0
replace municip ="ALMADEN DE LA PLATA" if strpos(municip , "ALMADEN PLATA") > 0
replace municip ="ALMENDRO EL" if strpos(municip , "ALMENDRO, EL") > 0
replace municip ="AMIEVA (SAMES)" if strpos(municip , "AMIEVA") > 0
replace municip ="ALRO ARAN (SALARDU)" if strpos(municip , "ALTO ARAN") > 0
replace municip ="AMIEVA" if strpos(municip , "AMIEVA") > 0
replace municip ="ARCE(NAGORE)" if strpos(municip , "ARCE") > 0
replace municip ="ARCOS DE LA FRONTERA" if strpos(municip , "ARCOS DE LA FRONTERA") > 0
replace municip ="ARDISA" if strpos(municip , "ARDISA") > 0
replace municip ="ARENAS DE REY" if strpos(municip , "ARENAS DEL REY") > 0
replace municip ="ARGES" if strpos(municip , "ARGES") > 0
replace municip ="ARQUILLOS" if strpos(municip , "ARQUILLOS") > 0
replace municip ="ARRAZUA-UBARRUNDIA(DURAN" if strpos(municip , "ARRAZUA-UBA") > 0
replace municip ="ARROYOMOLINOS DE MONTANCH" if strpos(municip , "ARROYOMOLINOS DE MONTACH") > 0
replace municip ="AYAMONTE" if strpos(municip , "AYAMONTE") > 0
replace municip ="AZUTAN" if strpos(municip , "AZUTAN") > 0
replace municip ="BARACALDO" if strpos(municip , "BARAKALDO") > 0
replace municip ="BARRIOS LOS" if strpos(municip , "BARRIOS, LOS") > 0
replace municip ="BAENA" if strpos(municip , "BAENA") > 0
replace municip ="BARONIADERIALP" if strpos(municip , "BARONIARIALB") > 0
replace municip ="BARRIOSDELUNALOS" if strpos(municip , "BARRIOS DE LUNA") > 0
replace municip ="BANOSDELAENCINA" if strpos(municip , "BAÑOSDELAENCINA") > 0
replace municip ="BEASAIN" if strpos(municip , "BEASAIN") > 0
replace municip ="CASTELLET Y GORNAL" if strpos(municip , "CASTELLET I LA GORNAL") > 0
replace municip ="CASTILBLANCO DE LOS ARROY" if municip == "CASTILBLANCO DE LOS ARROYOS"
replace municip ="CATLLAR" if strpos(municip , "CATLLAR, EL") > 0
replace municip ="CAZALEGAS" if strpos(municip , "CAZALEGAS-SAN") > 0
replace municip ="CAZORLA" if strpos(municip , "CAZORLA, IRUELA") > 0
replace municip ="CERNADILLA" if strpos(municip , "CERNADILLA- MANZANAL") > 0
replace municip ="CERRO DE ANDEVALO EL" if strpos(municip , "CERRO DE ANDEVALO, EL, CORTEGANA") > 0
replace municip ="CERRO DE ANDEVALO EL" if strpos(municip , "CERRO DE ANDEVALO, EL") > 0


replace municip ="ALGAR" if strpos(municip , "ALGAR/JEREZ") > 0
replace municip ="ALMENDRA" if strpos(municip , "ALMENDRA Y CIBANAL") > 0
replace municip ="ALTO ARAN(SALARDU)" if strpos(municip , "ALRO ARAN") > 0
*AMER Y SELLERA SON DOS MUNICIPIOS DIFERENTES
replace municip ="AMIEVA (SAMES)" if strpos(municip , "AMIEVA") > 0
replace municip ="ANINON" if strpos(municip , "ANIÑON") > 0
replace municip ="ARANDA DEL MONCAYO" if strpos(municip , "ARANDA DE MONCAYO") > 0
*replace municip ="NAVARRES" if strpos(municip , "ARCE(NAGORE") > 0 //IT IS A MISTAKE! CHECK
replace municip ="ARRANCUDIAGA" if strpos(municip , "ARRANKUDIAGA") > 0
replace municip ="ARRAZUA-UBARRUNDIA (DURAN" if strpos(municip , "ARRAZUA-UBARRUNDIA") > 0
replace municip ="ARROYOMOLINOS DE MONTANCH" if strpos(municip , "ARROYOMOLINOS MONTAN") > 0
replace municip ="ARTEIJO" if strpos(municip , "ARTEIXO") > 0
*ARZUA LALIN Y GOLADA SON TRES MUNICIPI
replace municip ="AYALA(RESPALDIZA)" if strpos(municip , "AYALA") > 0
replace municip ="BAYONA" if strpos(municip , "BAIONA") > 0
*BARONIA RIALP Y TIURANA SON DOS MUNICIPIOS
* SON DOS? replace municip ="BARRIOS LOS" if strpos(municip , "BARRIOS LOS ALGECIRAS") > 0
*BARRIOS CASTELLAR SAN ROQUE TRES
replace municip ="BARRIOS DE LUNA LOS" if strpos(municip , "BARRIOSDELUNALOS") > 0
replace municip ="BANOS DE LA ENCINA" if strpos(municip , "BAÑOS DE LA ENCINA") > 0
replace municip ="BANOS" if strpos(municip , "BAÑOS DE MONTEM") > 0
*replace municip ="BENAHAVIS" if strpos(municip , "BENAHAVIS MARBE") > 0 //CHECK IT IS ONLY ONE
*BERGE Y ALCORISA SON DOS
replace municip ="BOLLO EL" if strpos(municip , "BOLO O") > 0
replace municip ="BONAR" if strpos(municip , "BOÑAR") > 0
replace province ="CUENCA" if municip=="BUENDIA"
replace municip ="BURGO DE EBRO (EL)" if strpos(municip , "BURGO DE EBRO") > 0
replace municip ="CABANAS DEL CASTILLO" if strpos(municip , "CABAÑAS DEL CASTILLO") > 0
replace municip ="CABRILLANAES" if strpos(municip , "CABRILLANES") > 0
replace municip ="CALANAS" if strpos(municip , "CALAÑAS") > 0
replace municip ="CALZADA DE OROPESA" if strpos(municip , "CALZADA DE OROPESA LA") > 0
replace municip ="CAMARASA-FONTLLONGA" if strpos(municip , "CAMARASA") > 0
replace municip ="CAMPO DE PENARANDA" if strpos(municip , "CAMPO DE PEÑARANDA") > 0
replace municip ="CARBALLEDO(BARRELA)" if strpos(municip , "CARBALLEDO PONTON") > 0
replace municip ="CARDENA" if strpos(municip , "CARDEÑA") > 0
replace municip ="CAROLINA-LA" if strpos(municip , "CAROLINA") > 0
*CARRASCOSA DE LA SIERRA NO ES DE CUENCA, SORIA?
replace municip ="CARPIO DE TAJO (EL)" if strpos(municip , "CARPIO DE TAJO") > 0
replace municip ="CASARES DE HURDES" if strpos(municip , "CASARES DE LAS HURDES") > 0
replace municip ="´CASAS DE DON ANTONIO" if strpos(municip , "CASAS DE DANTONIO") > 0
replace municip ="CASTRONUNO" if strpos(municip , "CASTRONUÑO") > 0
replace municip ="CATLLAR" if strpos(municip , "CATLLAR") > 0
replace municip ="CANAMERO" if strpos(municip , "CAÑAMERO") > 0
replace municip ="CANAVERAL" if strpos(municip , "CAÑAVERAL") > 0
replace municip ="CIGOITIA(GOPEGUI)" if strpos(municip , "CIGOITIA") > 0
replace municip ="COLOMES" if strpos(municip , "COLOMERS") > 0
replace municip ="CUMBRE (LA)" if strpos(municip , "CUMBRE LA") > 0
* 0 replace municip ="ESTADILLA" if strpos(municip , "ESCARILLA") > 0
replace municip ="FAYOS (LOS)" if strpos(municip , "FAYOS LOS") > 0
replace municip ="FINANA" if strpos(municip , "FIÑANA") > 0
replace municip ="FUENTE-OVEJUNA" if strpos(municip , "FUENTE OBEJUNA") > 0
replace municip ="CASTRO DE FUENTIDUE@A" if strpos(municip , "FUENTIDUEÑA") > 0
replace municip ="GALDACANO" if strpos(municip , "GALDAKAO") > 0
replace municip ="GOZON (LUANCO)" if strpos(municip , "GOZON") > 0
*check, there must be two grareplace municip ="GRANADILLA DE ABONA" if strpos(municip , "GRANADILLA") > 0
replace municip ="GUDINA LA" if strpos(municip , "GUDIÑA A") > 0
replace municip ="GUENES" if strpos(municip , "GUEÑES") > 0
replace municip ="GUIAMETS" if strpos(municip , "GUIAMETS ELS") > 0
replace municip ="GURIEZO (DUENTE EL)" if strpos(municip , "GURIEZO") > 0
replace municip ="HERRERIAS (BIELBA)" if strpos(municip , "HERRERIAS") > 0
replace municip ="HOYO DE PINARES" if strpos(municip , "HOYO DE PINARES") > 0
replace municip ="INCIO" if strpos(municip , "INCIO O") > 0
replace municip ="TOBA LA" if strpos(municip , "LA TOBA") > 0
replace municip ="LEGAZPIA" if strpos(municip , "LEGAZPI") > 0
replace municip ="LESACA" if strpos(municip , "LESAKA") > 0
replace municip ="LLES" if strpos(municip , "LLESP") > 0
replace municip ="LOGRONO" if municip == "LOGROÑO"
replace municip ="CORRALES DE BUELNA (LOS)" if strpos(municip , "LOS CORRALES DE BUELNA") > 0
replace municip ="MADRONERA" if strpos(municip , "MADROÑERA") > 0
replace municip ="MENACA" if strpos(municip , "MEÑAKA") > 0
replace municip ="MINAS DE RIO TINTO" if strpos(municip , "MINAS DE RIOTINTO") > 0
replace municip ="MORCIN (CASTANDIELLO" if strpos(municip , "MORCIN") > 0
replace municip ="MUINOS" if municip == "MUIÑOS"
replace municip ="SANTOMERA" if strpos(municip , "SANTOMERA") > 0
replace municip ="MUNOPEDRO" if strpos(municip , "MUÑOPEDRO") > 0
replace municip ="NAVALPERAL PINARES" if strpos(municip , "NAVALPERAL DE PINARES") > 0
replace municip ="NAVALUCILLOS (LOS)" if strpos(municip , "NAVALUCILLOS LOS") > 0

replace municip ="NAVAS DEL MARQUES" if strpos(municip , "NAVAS DEL MARQUES LAS") > 0
replace municip ="NUNOMORAL" if strpos(municip , "NUÑOMORAL") > 0
replace municip ="ORTIGOSA" if strpos(municip , "ORTIGOSA DE CAMEROS") > 0
replace municip ="ORENSE" if strpos(municip , "OURENSE") > 0
replace municip ="ONA" if municip == "OÑA"
replace municip ="PALMA DE EBRO LA" if strpos(municip , "PALMA D'EBRE LA") > 0
replace municip ="PALMAS DE GRAN CANARIAS" if strpos(municip , "PALMAS DE GRAN CANARIA") > 0
replace municip ="PARADA DEL SIL" if strpos(municip , "PARADA DE SIL") > 0
replace municip ="PENAFLOR" if strpos(municip , "PEÑAFLOR") > 0
replace municip ="PENALBA" if strpos(municip , "PEÑALBA") > 0
replace municip ="PENAS DE RIGLOS-LAS" if strpos(municip , "PEÑAS DE RIGLOS LAS") > 0
replace municip ="PINAR" if municip == "PINAR EL"
replace municip ="PINOS GENIL" if strpos(municip , "PINOS GENIEL") > 0
replace municip ="PLENCIA" if strpos(municip , "PLENTZIA") > 0
replace municip ="PUEBLA DE BENIFASAR" if strpos(municip , "POBLA DE BENIFASSA LA") > 0
replace municip ="PORT-BOU" if strpos(municip , "PORTBOU") > 0
replace municip ="PUEBLA DE MONTALBAN" if strpos(municip , "PUEBLA DE MONTALBAN LA") > 0
replace municip ="PUEBLA DE TRIVES" if strpos(municip , "PUEBLA TRIEVES") > 0
replace municip ="PUERTO DEL ROSARIO" if strpos(municip , "PUERTO ROSARIO") > 0
replace municip ="QUIROS (BARZANA)" if strpos(municip , "QUIROS") > 0
replace municip ="RAMIRANES" if strpos(municip , "RAMIRAS") > 0
replace municip ="RIUDECANAS" if strpos(municip , "RIUDECANYAS") > 0
replace municip ="ROMANGORDO" if strpos(municip , "ROMAGORDO") > 0
replace municip ="SABINANIGO" if strpos(municip , "SABIÑANIGO") > 0
replace municip ="SAN MARTIN DE VALDEIGLESI" if strpos(municip , "SAN MARTIN DE VALDEIGLESIAS") > 0
replace municip ="SANTA MARIA DEL VAL" if strpos(municip , "SANTA MARIA DEL VALLE") > 0
replace municip ="SANTIBANEZ EL ALTO" if strpos(municip , "SANTIBAÑEZ EL ALTO") > 0
replace municip ="SANTA CRUZ TENERIFE" if strpos(municip , "STA CRUZ DE TENERIFE") > 0
replace municip ="SANTIAGO DEL TEIDE" if strpos(municip , "TEIDE") > 0
replace municip ="VILLA DE TEROR" if strpos(municip , "TEROR") > 0
replace municip ="TIEMBLO(EL)" if strpos(municip , "TIEMBLO EL") > 0
replace municip ="TORDOYA" if strpos(municip , "TORDOIA") > 0
replace municip ="TUDANCA (SANTOTIS)" if strpos(municip , "TUDANCA") > 0
replace municip ="URROZ" if strpos(municip , "URROTZ") > 0
replace municip ="SANTA URSULA" if strpos(municip , "URSULA") > 0
replace municip ="VALDOVINO" if strpos(municip , "VALDOVIÑO") > 0
replace municip ="VILLANOVA DE SAU" if strpos(municip , "VILANOVA DE SAU") > 0
replace municip ="VILELLA BAJA" if strpos(municip , "VILELLA BAIXA") > 0
replace municip ="VILLAMARTIN DE VALDEORRAS" if strpos(municip , "VILLAMARTIN") > 0
replace municip ="VILLAR DE PLASENCIA" if strpos(municip , "VILLAR PLASENCIA") > 0
replace municip ="VINUELA" if strpos(municip , "VIÑUELA") > 0
replace municip ="ZALDIVAR" if strpos(municip , "ZALDIBAR") > 0
replace municip ="GUINZO DE LIMIA" if strpos(municip , "XINZO DE LIMIA") > 0
replace municip ="ZORITA DE CANES" if strpos(municip , "ZORITA DE LOS") > 0
replace municip ="CASAS DE DON ANTONIO" if strpos(municip , "CASAS DE DON ANTONIO") > 0

***********************************
***********************************
***********************************
drop if municip =="" // 3 time
drop if  length(municip)==1
drop if  length(municip)==2
drop if  length(municip)==3

gen victim1 = 1
sort municip archive
* important variables
by municip archive: egen victim_archive = sum(victim1) 
by municip : egen victim_mun = sum(victim1) 

sort municip male
by municip male: egen victim_male = sum(victim1) 


duplicates drop municip archive, force
*438.604------42.349
*363.232------41.116
*362.168------39.902
*360.518------39.854
drop victim1
gen idvictim1=_n
rename municip municipality
gen str municip = municipality //this is necessary bc the variable is defined as strL (long string), and then the merge is not possible
drop municipality
save "$dir\$Output_data\purge\victims_archive.dta",replace
use  "$dir\$Output_data\purge\victims_archive.dta", clear
***********************************
* Create dataset with number of victims per municipality
***********************************
clear all
use  "$dir\$Output_data\purge\victims_archive.dta"
drop idvictim1
drop victim_archive archive profession type id gender 
format %15s municip 
drop if municip =="1951"
keep if male == 1
duplicates drop municip province, force
*27.980
gen idvictim=_n
rename municip municipality
gen str municip = municipality //this is necessary bc the variable is defined as strL (long string), and then the merge is not possible
drop municipality year*
save "$dir\$Output_data\purge\victims_archive.dta",replace


***********************************
* Create dataset with number of MALE victims per municipality
* Note: if victim_mun doesnt coincide with the same of victim_archive is because in the original data, there could be some victims for which we dont have the source or the archive information.
***********************************
clear all
use  "$dir\$Output_data\purge\victims_archive.dta"
drop idvictim1
drop victim_archive archive profession type id gender victim_archive year*
drop if municip =="1951"
keep if male == 1
drop victim_mun male

duplicates drop municip province, force

gen idvictim2=_n
rename municip municipality
gen str municip = municipality //this is necessary bc the variable is defined as strL (long string), and then the merge is not possible
drop municipality
save "$dir\$Output_data\purge\victims_mun_gender.dta",replace