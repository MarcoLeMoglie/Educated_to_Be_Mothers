/*
********************************************************************************
* Import Victims and reprisals of Franco. Data from PARES 
********************************************************************************
foreach num of numlist 1 5 {
cd $dir
clear all
import delimited "$Data\victims\PARES\pares`num'.csv"
rename (v1 v2 v4 v5 v6 v7 v8 v9 v11 v13 v14) (id name surname location profession archive fondo serie year type obs)
format %10s id 
format %10s name 
format %10s location
split year, parse("-" "/") generate(year_) limit(4)
drop v3 v10 v12 //pages

keep id location profession archive year_1 year_2 name type
save "$Data\victims\PARES\pares`num'.dta", replace
}

foreach num of numlist 2 3 4 {
cd $dir
clear all
import delimited "$Data\victims\PARES\pares`num'.csv"
rename (v1 v2 v4 v5 v6 v7 v8 v9 v11 v13 v14) (id name surname location profession archive fondo serie year type obs)
format %10s id 
format %10s name 
format %10s location
split year, parse("-" "/") generate(year_) limit(4)
drop v3 v10 v12 //pages
drop if  strpos(id , "a") > 0

keep id location profession archive year_1 year_2 year_3 name type
save "$Data\victims\PARES\pares`num'.dta", replace
}
**********************************
* Append the 5 datasets
**********************************
**#
cd $dir
clear all
use  "$Data\victims\PARES\pares1.dta"
append using  "$Data\victims\PARES\pares2.dta"
append using  "$Data\victims\PARES\pares3.dta"
append using  "$Data\victims\PARES\pares4.dta"
append using  "$Data\victims\PARES\pares5.dta"

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
*
*
*
*
*


save "$dir\$Output_data\purge\victims_archive_v1.dta",replace
*/
***********************************
*********************************** tiempo total desde aqui: 6 min
***********************************
**#
use  "$dir\$Output_data\purge\victims_archive_v1.dta", clear
replace year_2=1945 if year_2 ==19451
replace year_2=1945 if year_2 ==19450
replace year_2=1945 if year_2 ==19453
replace year_2=1940 if year_2 ==194
replace year_2=1939 if year_2 ==1439
replace year_2= 1945 if year_2 == 4945
replace year_2= 1956 if year_2 == 19256
replace year_2= 1943 if year_2 == 243
replace year_2= 1944 if year_2 == 944

replace year_2= 1980 if year_2 == 1480
replace year_2= 1943 if year_2 == 19433
*drop if year_2 <1941
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

**#keep only teachers
keep if archive=="Archivo General de la Administración"
* Removes blanks at beginning only
replace municip=ltrim(municip)
drop if municip =="" // 16,183 observations deleted because of unknown municip. 	Note: second time I delete bc of unkown 77,931 observations deleted after removing blanks


drop if  length(municip)==1 //61,764 observations deleted
drop if  length(municip)==2 // (631 observations deleted)
drop if  length(municip)==3 //(183 observations deleted)

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


drop if  length(municip)==1 //61,764 observations deleted
drop if  length(municip)==2 // (631 observations deleted)
drop if  length(municip)==3 //(183 observations deleted)
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
************************************
**# new
************************************
replace municip = lower(municip)
replace municip = subinstr( municip, "Ñ", "ñ", .)
replace province = subinstr( province, "Ñ", "ñ", .)

replace municip = subinstr(municip, "í", "i", .) 

replace municip = lower(municip)
replace municip=trim(municip)
replace municip= "santa maría de dulcis" if municip == "buera" 
replace municip = "grado, el"   if municip =="coscojuela de fantova"
replace municip = "barbastro"  if municip == "cregenzán"
replace municip = "santa maría de dulcis" if municip =="huerta de vero"
replace municip = "Naval" if municip =="mipanas"

replace municip = "azanuy-alins" if municip =="alins del monte"
replace municip = "huesca" if municip=="apies"
replace municip = "caldearenas" if municip=="aquilue"
replace municip = "sietamo" if municip=="arbanies"
replace municip = "ainsa-sobrarbe" if strpos(municip, "arcusa")
replace municip = "biescas" if strpos(municip, "aso de sobremonte")
replace municip = "jaca" if strpos(municip, "atares")
replace municip = "huesca" if strpos(municip, "banaries")
replace municip = "jaca" if strpos(municip, "baraguas")
replace municip = "loporzano" if strpos(municip, "barluenga")
replace municip = "jaca" if strpos(municip, "bernues")
replace municip = "jaca" if strpos(municip, "bescos de garcipollera")
replace municip = "aren" if strpos(municip, "betesa")
replace municip = "canal de berdun" if strpos(municip, "binies")
replace municip = "montanuy" if strpos(municip, "bono")
replace municip = "jaca" if strpos(municip, "botaya")
replace municip = "fiscal" if strpos(municip, "burgase")
replace municip = "grañen" if strpos(municip, "callen")
replace municip = "beranuy" if strpos(municip, "calvera")
replace municip = "jaca" if strpos(municip, "canias")
replace municip = "sabañanigo" if strpos(municip, "cartirana")
replace municip = "montanuy" if strpos(municip, "castanesa")
replace municip = "ainsa-sobrarbe" if strpos(municip, "castejon de sobrarbe")
replace municip = "loporzano" if strpos(municip, "castilsabas")
replace municip = "fueva, la" if strpos(municip, "clamosa")
replace municip = "ainsa-sobrarbe" if strpos(municip, "coscojuela de sobrarbe")
replace municip = "loporzano" if strpos(municip, "coscullano")
replace municip = "huesca" if strpos(municip, "cuarte") & province=="huesca"
 replace municip = "biescas" if strpos(municip, "escuer")
replace municip = "laspaules" if strpos(municip, "espes")
replace municip = "aisa" if strpos(municip, "esposa")
replace municip = "jaca" if strpos(municip, "espuendolas")
replace municip = "sotonera, la" if strpos(municip, "esquedas")
replace municip = "san miguel del cinca" if strpos(municip, "estiche")
replace municip = "viacamp y litera" if strpos(municip, "fet") & province=="huesca"
replace municip = "peralta de calasanz" if strpos(municip, "gabasa")
replace municip = "biescas" if strpos(municip, "gavin")
replace municip = "sabañanigo" if strpos(municip, "gesera")

replace municip = "jaca" if strpos(municip, "guasa") & province=="huesca"
replace municip = "ainsa-sobrarbe" if strpos(municip, "guaso")
replace municip = "graus" if municip== "guel"
replace municip = "jaca" if municip== "hecho"

replace municip = "puente la reina de jaca" if strpos(municip, "javierregay")
replace municip = "caldearenas" if strpos(municip, "javierrelatre")

replace municip = "casbas de huesca" if strpos(municip, "labata")
replace municip = "capella" if strpos(municip, "laguarres")
replace municip = "peralta de alcofea" if strpos(municip, "lagunarrota")
replace municip = "sallent de gallego" if strpos(municip, "lanuza")
replace municip = "sabañanigo" if strpos(municip, "larres")
replace municip = "bailo" if strpos(municip, "larues")
replace municip = "caldearenas" if strpos(municip, "latre")
replace municip = "sotonera, la" if strpos(municip, "lierta")
replace municip = "sietamo" if strpos(municip, "liesa")
replace municip = "torla-ordesa" if strpos(municip, "linas de broto")

replace municip = "tolva" if strpos(municip, "luzas")
replace municip = "canal de berdun" if strpos(municip, "martes")
replace municip = "lalueza" if strpos(municip, "marcen")
replace municip = "fueva, la" if strpos(municip, "mediano") & province =="huesca"
replace municip = "isabena" if strpos(municip, "merli")
replace municip = "benabarre" if strpos(municip, "monesma de benabarre")
 replace municip = "bierge" if strpos(municip, "morrano")
replace municip = "fueva, la" if strpos(municip, "muro de roda")
replace municip = "jaca" if municip== "navasa"
replace municip = "nueno" if strpos(municip, "nocito")
replace municip = "biescas" if strpos(municip, "olivan")
replace municip = "ainsa-sobrarbe" if strpos(municip, "olson") & province =="huesca"
replace municip = "sabañanigo" if strpos(municip, "orna de gallego")
replace municip = "jaca" if strpos(municip, "osia")
replace municip = "broto" if municip== "oto"
replace municip = "sariñena" if strpos(municip, "pallaruelo de monegros")
replace municip = "graus" if strpos(municip, "panillo")
replace municip = "casbas de huesca" if strpos(municip, "panzano")
replace municip = "peralta de calasanz" if municip== "peralta de la sal"
replace municip = "biescas" if strpos(municip, "piedrafita de jaca")
replace municip = "biscarrues" if strpos(municip, "piedramorrera")
replace municip = "benabarre" if strpos(municip, "pilzan")
replace municip = "sotonera, la" if strpos(municip, "plasencia del monte")
replace municip = "sotonera, la" if strpos(municip, "quinzano")
replace municip = "alquezar" if strpos(municip, "radiquero")

replace municip = "peñas de riglos, las" if municip == "rasal"
replace municip = "peñas de riglos, las" if strpos(municip, "riglos")
replace municip = "bierge" if strpos(municip, "rodellar")
replace municip = "nueno" if strpos(municip, "sabayes")
replace municip = "hoz y costean" if strpos(municip, "salinas de hoz")
replace municip = "peñas de riglos, las" if strpos(municip, "salinas de jaca")
replace municip = "loporzano" if strpos(municip, "sasa del abadiado")
replace municip = "monzon" if strpos(municip, "selgua")
replace municip = "caldearenas" if strpos(municip, "serue")
replace municip = "casbas de huesca" if strpos(municip, "sieso de huesca")
replace municip = "boltaña" if strpos(municip, "sieste")
replace municip = "tella-sin" if strpos(municip, "sin y salinas")
replace municip = "aisa" if strpos(municip, "sinues")
replace municip = "loporzano" if strpos(municip, "sipan")
replace municip = "peñas de riglos, las" if strpos(municip, "triste")
replace municip = "valle de hecho" if strpos(municip, "urdues")
replace municip = "huerto" if strpos(municip, "uson")
replace municip = "canal de berdun" if strpos(municip, "villarreal de la canal")

replace municip = "sotonera, la" if municip== "anies"
replace municip = "caldearenas" if strpos(municip, "anzanigo")
 replace municip = "bailo" if strpos(municip, "arbues") & province =="huesca"
replace municip = "loporzano" if strpos(municip, "bandalies")
replace municip = "arguis" if strpos(municip, "bentue de rasal")
replace municip = "angües" if municip == "bespen"
replace municip = "sotonera, la" if municip == "bolea"
replace municip = "peralta de calasanz" if municip == "calasanz"
replace municip = "sabiñanigo" if municip == "sabañanigo" & province =="huesca"
replace municip = "hoz y costean" if municip == "costean"
replace municip = "peñas de riglos, las" if municip == "ena"
replace municip = "alcala del obispo" if municip == "fañanas"
replace municip = "ainsa-sobrarbe" if municip == "gerbe y griebal"
replace municip = "isabena" if municip == "roda de isabena"
replace municip = "sabiñanigo" if municip == "sardas"
replace municip = "ainsa-sobrarbe" if municip == "sarsa de surta"
 replace municip = "broto" if municip == "sarvise"
replace municip = "tella-sin" if municip == "tella"
replace municip = "jaca" if municip == "araguas del solano"
replace municip = "nueno" if municip == "arascues"
replace municip = "biescas" if municip == "barbenuta"
replace municip = "blecua y torres" if municip == "blecua"
replace municip = "estopiñan del castillo" if municip == "caserras del castillo"
 replace municip = "estopiñan del castillo" if municip == "estopiñan"
replace municip = "hoz y costean" if municip == "hoz de barbastro"
replace municip = "monflorite-lascasas" if municip == "lascasas"
replace municip = "sariñena" if municip == "lastanosa"
replace municip = "lupiñen-ortilla" if municip == "lupiñen"
replace municip = "puente de montañana" if municip == "montañana"
replace municip = "lupiñen-ortilla" if municip == "ortilla"
replace municip = "lascellas-ponzano" if municip == "ponzano"
replace municip = "benabarre" if municip == "purroy de la solana"
replace municip = "puente la reina de jaca" if municip == "santa engracia"
replace municip = "loporzano" if municip == "santa eulalia la mayor"
replace municip = "ainsa-sobrarbe" if municip == "santa maria de buil"
replace municip = "sopeira" if municip == "santorens"
replace municip = "torla-ordesa" if municip == "torla"
replace municip = "graus" if municip == "torres del obispo"
replace municip = "monflorite-lascasas" if municip == "monflorite"


replace municip = "etxalar" if municip == "echalar"
replace municip = "lakuntza" if municip == "lacunza"
replace municip = "ezcabarte" if municip == "arre"
replace municip = "cendea de olza/oltza zendea" if municip == "olza"
replace municip = "igantzi" if municip == "yanci"
replace municip = "valle de ollo/ollaran" if municip == "ollo"
replace municip = "bera" if municip == "vera de bidasoa"
replace municip = "valle de egüés/eguesibar" if municip == "egües"
replace municip = "valle de yerri/deierri" if municip == "yerri"
replace municip = "iza" if municip == "gulina"
replace municip = "beintza-labaien" if municip == "labayen"
replace municip = "esparza de salazar/espartza zaraitzu" if municip == "esparza"
replace municip = "noáin (valle de elorz)/noain (elortzibar)" if municip == "elorz"
replace municip = "bakaiku" if municip == "bacaicoa"
replace municip = "leoz/leotz" if municip == "leoz"

replace municip = "abarzuza/abartzuza" if municip == "abarzuza"
replace municip = "abaurregaina/abaurrea alta" if municip == "abaurrea alta"
replace municip = "aibar/oibar" if municip == "aibar"
replace municip = "allin/allin" if municip == "allin"
replace municip = "altsasu/alsasua" if municip == "alsasua"
replace municip = "ancin/antzin" if municip == "ancin"
replace municip = "ansoain/antsoain" if municip == "ansoain"
replace municip = "aoiz/agoitz" if municip == "aoiz"
replace municip = "araitz" if municip == "araiz"
replace municip = "harana/valle de arana"  if municip == "san vicente de arana"
replace municip = "aranarache/aranaratxe" if municip == "aranarache"
replace municip = "arantza" if municip == "aranaz"
replace municip = "arakil" if municip == "araquil"
replace municip = "arce/artzi" if municip == "arce"
replace municip = "aribe" if municip == "arive"
replace municip = "zabalza/zabaltza" if municip == "arraiza"
replace municip = "lizoain-arriasgoiti" if municip == "arriasgoiti"
replace municip = "atez/atetz" if municip == "atez"
replace municip = "ayegui/aiegi" if municip == "ayegui"
replace municip = "burgui/burgi" if municip == "burgui"
replace municip = "cirauqui/zirauki" if municip == "cirauqui"
replace municip = "ciriza/ziritza" if municip == "ciriza"
replace municip = "etxauri" if municip == "echaurri"
replace municip = "eneriz/eneritz" if municip == "eneriz"
replace municip = "estella-lizarra" if municip == "estella"
replace municip = "ezkurra" if municip == "ezcurra"
replace municip = "gallipienzo/galipentzu" if municip == "gallipienzo"
replace municip = "gallues/galoze" if municip == "gallues"
replace municip = "garaioa" if municip == "garayoa"
replace municip = "guesalaz/gesalatz" if municip == "guesalaz"
replace municip = "güesa/gorza" if municip == "güesa"
replace municip = "huarte/uharte" if municip == "huarte"
replace municip = "imotz" if municip == "imoz"
replace municip = "izalzu/itzaltzu" if municip == "izalzu"
replace municip = "lantz" if municip == "lanz"
replace municip = "leache/leatxe" if municip == "leache"
replace municip = "leitza" if municip == "leiza"
replace municip = "lesaka" if municip == "lesaca"
replace municip = "lizoain-arriasgoiti" if municip == "lizoain"
replace municip = "longuida/longida" if municip == "longuida"
replace municip = "miranda de arga" if municip == "miranda"
replace municip = "navascues/nabaskoze" if municip == "navascues"
replace municip = "ochagavia/otsagabia" if municip == "ochagavia"
replace municip = "olite/erriberri" if municip == "olite"
replace municip = "oloriz/oloritz" if municip == "oloriz"
replace municip = "oronz/orontze" if municip == "oronz"
replace municip = "pamplona/iruña" if municip == "pamplona"
replace municip = "peralta/azkoien" if municip == "peralta"
replace municip = "roncal/erronkari" if municip == "roncal"
replace municip = "orreaga/roncesvalles" if municip == "roncesvalles"
replace municip = "sarries/sartze" if municip == "sarries"
replace municip = "sunbilla" if municip == "sumbilla"
replace municip = "tiebas-muruarte de reta" if municip == "tiebas"
replace municip = "ujue/uxue" if municip == "ujue"
replace municip = "ultzama" if municip == "ulzama"
replace municip = "unzue/untzue" if municip == "unzue"
replace municip = "urdazubi/urdax" if municip == "urdax"
replace municip = "urzainqui/urzainki" if municip == "urzainqui"
replace municip = "luzaide/valcarlos" if municip == "valcarlos"
replace municip = "villamayor de monjardin" if municip == "villamayor"
replace municip = "villava/atarrabia" if municip == "villava"
replace municip = "zabalza/zabaltza" if municip == "zabalza"

* 
replace municip ="harana/valle de arana" if municip == "alda"
replace municip ="arraia-maeztu" if municip == "apellaniz"
replace municip ="bernedo" if municip == "arlucea"
replace municip ="oyon-oion" if municip == "barriobusto"
replace municip ="lantarón" if municip == "berguenda"
replace municip ="harana/valle de arana" if municip == "contrasta"
replace municip ="arraia-maeztu" if municip == "corres"
replace municip ="vitoria" if municip == "foronda"
replace municip ="iruraiz-gauna" if municip == "gauna"
replace municip ="oyon-oion" if municip == "labraza"
replace municip ="arraia-maeztu" if municip == "laminoria"
replace municip ="iruraiz-gauna" if municip == "iruraiz"
replace municip ="amurrio" if municip == "lezama"
replace municip ="bernedo" if municip == "marquinez"
replace municip ="vitoria" if municip == "mendoza"
replace municip ="arraia-maeztu" if municip == "arraya"
replace municip ="iruña oka/iruña de oca" if municip == "nanclares de la oca"
replace municip ="okondo" if municip == "oquendo"
 replace municip ="campezo/kanpezu" if municip == "oteo"

replace municip ="lagran" if municip == "pipaon"
replace municip ="bernedo" if municip == "quintana"
replace municip ="erriberagoitia/ribera alta" if municip == "ribera alta"
replace municip ="erriberabeitia" if municip == "ribera baja"
replace municip ="iruña oka/iruña de oca" if municip == "iruna"
replace municip ="lantarón" if municip == "salcedo" 
replace municip ="labastida/bastida" if municip == "salinillas de buradon"
replace municip ="bernedo" if municip == "san roman de campezo"
replace municip ="campezo/kanpezu" if municip == "santa cruz de campezo"
replace municip ="legutio" if municip == "villarreal"
replace municip ="zuia" if municip == "zuya"
replace municip ="labastida/bastida" if municip == "labastida"

replace municip ="amurrio" if municip == "arrastaria"
replace municip ="laudio/llodio" if municip == "llodio"
replace municip ="oyon-oion" if municip == "oyon"
replace municip ="agurain/salvatierra" if municip == "salvatierra"
replace municip ="valdegovia/gaubea" if municip == "valderejo"

replace municip ="atxondo" if municip== "apatamonasterio"
replace municip ="munitibar-arbatzegi gerrikaitz" if municip == "arbacegui y guerricaiz"
replace municip ="bakio" if municip == "baquio"
replace municip ="karrantza harana/valle de carranza" if municip == "carranza"
replace municip ="artea" if municip == "castillo y elejabeitia"
replace municip ="ziortza-bolibar" if municip == "cenarruza"
replace municip ="amorebieta-etxano" if municip == "echano"
replace municip ="muxika" if municip == "gorocica"

replace municip ="markina-xemein" if municip == "jemein"
replace municip ="markina-xemein" if municip == "marquina"
replace municip ="aulesti" if municip == "murelaga"
replace municip ="otxandio" if municip == "ochandiano"
replace municip ="sukarrieta" if municip == "pedernales"
replace municip ="lezama" if municip == "santa maria de lezama"
replace municip ="areatza" if municip == "villaro"
replace municip ="arrankudiaga" if municip == "zollo"
replace municip ="amorebieta-etxano" if municip == "amorebieta"
replace municip ="gautegiz arteaga" if municip == "arteaga"

replace municip ="arrankudiaga" if municip == "arrancudiaga"
replace municip ="atxondo" if municip == "arrazola"
replace municip ="elantxobe" if municip == "elanchove"
replace municip ="muxika" if municip == "ibarruri"
replace municip ="ugao-miraballes" if municip == "miravalles"

replace municip ="igorre" if municip == "yurre"
replace municip ="aia" if municip == "aya"
replace municip ="zestoa" if municip == "cestona"
replace municip ="deba" if municip == "deva"
replace municip ="ezkio-itsaso" if municip == "ezquioga"
replace municip ="bidania-goiatz" if municip == "goyaz"
replace municip ="ezkio-itsaso" if municip == "ichaso"
replace municip ="lazkao" if municip == "lazcano"
replace municip ="mutriku" if municip == "motrico"
replace municip ="oiartzun" if municip == "oyarzun"

replace municip ="soraluze-placencia de las armas" if municip == "placencia"
replace municip ="errezil" if municip == "regil"
replace municip ="leintz-gatzaga" if municip == "salinas de leniz"
replace municip ="bidania-goiatz" if municip == "vidania"
replace municip ="ordizia" if municip == "villafranca de oria"

*
replace municip = "noguera de albarracin" if municip =="noguera"
replace municip = "teruel" if municip =="caude"
replace municip = "teruel" if municip =="villalba baja"
replace municip = "teruel" if municip =="valdecebro"
replace municip = "teruel" if municip =="tortajada"
replace municip = "teruel" if municip =="aldehuela"
replace municip = "villarluengo" if municip =="montoro de mezquita"
replace municip = "calamocha" if municip =="valverde"
replace municip = "calamocha" if municip =="navarrete del rio"
replace municip = "calamocha" if municip =="luco de jiloca"
replace municip = "calamocha" if municip =="nueros"
replace municip = "calamocha" if municip =="collados"
replace municip = "corbalan" if municip =="escriche"
replace municip = "sigües" if municip =="esco"
replace municip = "sigües" if municip =="tiermas"
replace municip = "pancrudo" if municip =="cervera del rincon"
replace municip = "pancrudo" if municip =="cuevas de portalrubio"
replace municip = "pancrudo" if municip =="portalrubio"
replace municip = "castellote" if municip =="ladruñan"
replace municip = "rillo" if municip =="son del puerto"
replace municip = "biota" if municip =="malpica de arba"
replace municip = "tarazona" if municip =="cunchillos"
replace municip = "mores" if municip =="purroy"
replace municip = "escucha" if municip =="valdeconejos"
replace municip = "perales del alfambra" if municip =="villalba alta"
replace municip = "cosa" if municip =="corbaton"
replace municip = "aliaga" if municip =="campos"
replace municip = "fuentes de ebro" if municip =="roden"
replace municip = "salvatierra de esca" if municip =="lorbes"
replace municip = "huesa del comun" if municip =="rudilla"
replace municip = "castellote" if municip =="dos torres de mercader"
replace municip = "linares de mora" if municip =="castelvispal"
replace municip = "calamocha" if municip =="cuencabuena"
replace municip = "calatayud" if municip =="embid de la ribera"
replace municip = "vivel" if municip =="armillas"
replace municip = "caminreal" if municip =="villalba de los morales"
replace municip = "loscos" if municip =="piedrahita"
replace municip = "sestrica" if municip =="viver de la sierra"
replace municip = "teruel" if municip =="campillo"
replace municip = "loscos" if municip =="mezquita de loscos"
replace municip = "calamocha" if municip =="cutanda"
replace municip = "torrecilla del rebollar" if municip =="godos"
replace municip = "hinojosa de jarque" if municip =="cobatillas"
replace municip = "biel" if municip =="fuencalderas"
replace municip = "calamocha" if municip =="olalla"
replace municip = "torrijo del campo" if municip =="torrijo"
replace municip = "calamocha" if municip =="lechago"
replace municip = "ejea de los caballeros" if municip =="farasdues"
replace municip = "vivel del rio martin" if municip =="vivel"
* Huesca
replace municip = "jaca" if municip =="acin"
replace municip = "loporzano" if municip =="aguas"
replace municip = "graus" if municip =="aguinaliu"
replace municip = "ainsa-sobrarbe" if municip =="ainsa"
replace municip = "fiscal" if municip =="albella y janovas"

replace municip = "monesma y cajigar" if municip =="cajigar"
replace municip = "azanuy-alins" if strpos(municip, "azanuy")
replace municip = "viacamp y litera" if strpos(municip, "fet")
replace municip = "jaca" if strpos(municip, "guasa")
replace municip = "ainsa-sobrarbe" if strpos(municip, "guaso")
replace municip = "ainsa-sobrarbe" if strpos(municip, "olson")
replace municip = "aren" if municip =="cornudella de baliera"
replace municip = "yebra de basa" if municip =="cortillas"
replace municip = "graus" if municip =="güel"
replace municip = "sabiñanigo" if municip =="jabarrella"
replace municip = "casbas" if municip =="junzano"
replace municip = "lascellas-ponzano" if municip =="lascellas"
replace municip = "laspaules" if municip =="neril"
replace municip = "san miguel del cinca" if municip =="pomar"
replace municip = "huesca" if municip =="tabernas de isuela"
replace municip = "fueva, la" if municip =="toledo de lanata"
replace municip = "blecua y torres" if municip =="torres de montes"
replace municip = "sallent de gallego" if municip =="tramacastilla de tena"
replace municip = "graus" if municip =="erdao"
replace municip = "osso de cinca" if municip =="osso"
replace municip = "jaca" if municip =="ara"
replace municip = "casbas de huesca" if municip =="casbas"

*catalunya
replace municip = "vielha e mijaran" if municip =="betlan"
replace municip = "gavet de la conca" if municip =="sant cerni"
replace municip = "calonge i sant antoni" if municip =="calonge"
replace municip = "conca de dalt" if municip =="serradell"
replace municip = "tora" if municip =="llanera"
replace municip = "alas i cerc" if municip =="alas"
replace municip = "bellver de cerdanya" if municip =="ellar"
replace municip = "pont de bar, el" if municip =="aristot"
replace municip = "ribera d'urgellet" if municip =="tost"
replace municip = "tremp" if municip =="gurp"
replace municip = "conca de dalt" if municip =="aramunt"
replace municip = "camprodon" if municip =="baget"
replace municip = "castell de mur" if municip =="guardia de tremp"
replace municip = "torrefeta i florejacs" if municip =="florejacs"
replace municip = "castell de mur" if municip =="mur"
replace municip = "corca" if municip =="casavells"
replace municip = "naut aran" if municip =="gessa"
replace municip = "pla de santa maria, el" if municip =="pla de cabra"
replace municip = "berga" if municip =="valldan"
replace municip = "bellver de cerdanya" if municip =="talltendre"
replace municip = "montblanc" if municip =="rojals"
replace municip = "gavet de la conca" if municip =="sant miquel de la vall"
replace municip = "figaro-montmany" if municip =="montmany"
replace municip = "valls de valira, les" if municip =="ars"
replace municip = "baronia de rialb, la" if municip =="pallerols"
replace municip = "vilanant" if municip =="tarabaus"
replace municip = "isona i conca della" if municip =="orcau"
replace municip = "llado" if municip =="lledo"
replace municip = "tarrega" if municip =="talladell"
replace municip = "guingueta d'Àneu, la" if municip =="jou"
replace municip = "isona i conca della" if municip =="isona"
replace municip = "naut aran" if municip =="arties"
replace municip = "sort" if municip =="enviny"
replace municip = "ribera d'urgellet" if municip =="pla de sant tirs"
replace municip = "tarrega" if municip =="claravalls"
replace municip = "alt aneu" if municip =="isil"
replace municip = "seu d'urgell, la" if municip =="castellciutat"
replace municip = "pont de suert, el" if municip =="castellas"
replace municip = "pont de suert, el" if municip =="pont de suert"
replace municip = "vall de boi, la" if municip =="barruera"
replace municip = "naut aran" if municip =="tredos"
replace municip = "isona i conca della" if municip =="conques"
replace municip = "vandellos i l'hospitalet de l'infant" if municip =="vandellos"
replace municip = "rialp" if municip =="surp"
replace municip = "camarasa" if municip =="fontllonga"
replace municip = "coll de nargo" if municip =="montanisell"
replace municip = "sarroca de bellera" if municip =="benes"
replace municip = "valls de valira, les" if municip =="anserall"
replace municip = "valls d'aguilar, les" if municip =="noves de segre"
replace municip = "alt aneu" if municip =="sorpe"
replace municip = "pont de suert, el" if municip =="llesp"
replace municip = "sant ramon" if municip =="manresana"
replace municip = "peralada" if municip =="vilanova de la muga"
replace municip = "pont de suert, el" if municip =="malpas"
replace municip = "tremp" if municip =="sapeira"
replace municip = "sarral" if municip =="montbrio de la marca"

replace municip = "sant joan les fonts" if municip =="beguda"
replace municip = "olot" if municip =="batet"
replace municip = "navas" if municip =="castelladral"
replace municip = "conca de dalt" if municip =="claverol"
replace municip = "tremp" if municip =="palau de noguera"
replace municip = "camprodon" if municip =="freixanet"


replace municip = "pont de suert, el" if municip =="viu de llevata"
replace municip = "montella i martinet" if municip =="montella"

replace municip = "saus, camallera i llampaies" if municip =="saus"
replace municip = "far d'emporda, el" if municip =="alfar"
replace municip = "vall de boi, la" if municip =="durro"
replace municip = "pont de bar, el" if municip =="toloriu"
replace municip = "vielha e mijaran" if municip =="viella"
replace municip = "ribera d'urgellet" if municip =="arfa"
replace municip = "peralada" if municip =="perelada"
replace municip = "valls de valira, les" if municip =="bescaran"
replace municip = "hostalets de pierola, els" if municip =="pierola"
replace municip = "pinell de solsones" if municip =="pinell"
replace municip = "forallac" if municip =="peratallada"
replace municip = "montferrer i castellbo" if municip =="arabell"
replace municip = "sant marti de riucorb" if municip =="sant marti de malda"
replace municip = "guingueta d'aneu, la" if municip =="guingueta d'Àneu, la"
replace municip = "cruilles, monells i sant sadurni de l'heura" if municip =="monells"
replace municip = "cornudella de montsant" if municip =="ciurana"
replace municip = "llosses, les" if municip =="palmerola"
replace municip = "valls de valira, les" if municip =="civis"
replace municip = "conca de dalt" if municip =="ortoneda"
replace municip = "tremp" if municip =="espluga de serra"
replace municip = "fontanals de cerdanya" if municip =="caixans"
replace municip = "montagut i oix" if municip =="oix"
replace municip = "vallbona de les monges" if municip =="rocallaura"
replace municip = "tarrega" if municip =="figuerosa"
replace municip = "baix pallars" if municip =="peramea"
replace municip = "gavet de la conca" if municip =="sant salvador de tolo"
replace municip = "guingueta d'aneu, la" if municip =="unarre"
replace municip = "sort" if municip =="altron"
replace municip = "vall de cardos" if municip =="ribera de cardos"
replace municip = "ripoll" if municip =="ripollet"
replace municip = "lles de cerdanya" if municip =="lles"
replace municip = "puigcerda" if municip =="vilallovent"
replace municip = "ripoll" if municip =="parroquia de ripoll"
replace municip = "sant julia de vilatorta" if municip =="vilalleons"
replace municip = "les llosses" if municip =="viladonja"
replace municip = "llosses, les" if municip =="les llosses"
replace municip = "mutxamel" if municip =="muchamiel"
replace municip = "xalo" if municip =="jalon"
replace municip = "salinas" if municip =="salians de anana"
replace municip = "valdegovia/gaubea" if municip =="valdegovia"
replace municip = "banyeres de mariola" if municip =="baneres"
replace municip = "sella" if municip =="setla y mirarrosa"
replace municip = "mirueña de los infanzones" if municip =="miruena"
replace municip = "bigues i riells" if municip =="bigas"
replace municip = "bruc, el" if municip =="broca"
replace municip = "gaia" if municip =="gaya"
replace municip = "moia" if municip =="moya"
replace municip = "rupit i pruit" if municip =="pruit"
replace municip = "teia" if municip =="teya"
replace municip = "arlanzon" if municip =="galarde"
replace municip = "burgos" if municip =="gamonal de riopico"
replace municip = "padroluengo" if municip =="garganchon"
replace municip = "sotresgudo" if municip =="guadilla de villamar"
replace municip = "pedrosa de duero" if municip =="guzman"
replace municip = "oña" if municip =="hermosilla"
replace municip = "castrojeriz" if municip =="hinestrosa"
replace municip = "huerta del rey" if municip =="hinojar del rey"
replace municip = "merindad de rio ubierna" if municip =="hontomin"
replace municip = "parte, la" if municip =="hormaza"
replace municip = "medina de pomar" if municip =="junta de la cerca"
replace municip = "medina de pomar" if municip =="junta de oteo"
replace municip = "valle de losa" if municip =="junta de san martin de losa"
replace municip = "poza de la sal" if municip =="lences"
replace municip = "pedrosa de rio urbel" if municip =="lodoso"
replace municip = "valle de santibañez" if municip =="mansilla de burgos"
replace municip = "alfoz de quintanadueñas" if municip =="marmellar de abajo"
replace municip = "merindad de rio ubierna" if municip =="masa"
replace municip = "estepar" if municip =="mazuelo de muño"
replace municip = "estepar" if municip =="medinilla de la dehesa"
replace municip = "valle de santibañez" if municip =="nuez de abajo, la"
replace municip = "sasamon" if municip =="olmillos de sasamon"
replace municip = "villadiego" if municip =="olmos de la picaza"
replace municip = "miranda de ebro" if municip =="oron"
replace municip = "isar" if municip =="palacios de benaver"
replace municip = "alfoz de quintanadueñas" if municip =="paramo del arroyo"
replace municip = "valle de sedano" if municip =="pesquera de ebro"
replace municip = "huerta del rey" if municip =="peñalba de castro"
replace municip = "arratzua-ubarrundia" if municip =="gamboa"
replace municip = "vitoria" if municip =="huetos, los"
replace municip = "añana" if municip =="salinas"
replace municip = "aigües" if municip =="aguas de busot"
replace municip = "castell de guadalest" if municip =="guadalest"
replace municip = "setla-mirarrosa y miraflor" if municip =="miraflor"
replace municip = "daya nueva" if municip =="puebla de rocamora"
replace municip = "alicante" if municip =="villafranqueza"
replace municip = "berja" if municip =="beninar"
replace municip = "alcolea" if municip =="darrical"
replace municip = "tres villas, las" if municip =="doña maria ocaña"
replace municip = "tres villas, las" if municip =="escullar"|municip =="escúllar"
replace municip = "flores de avila" if municip =="ajo, el"
replace municip = "avila" if municip =="alamedilla del berrocal, la"
replace municip = "avila" if municip =="aldea del rey nino"
replace municip = "santa maria del cubillo" if municip =="aldeavieja"
replace municip = "santiago del tormes" if municip =="aliseda de tormes, la"
replace municip = "torre, la" if municip =="blacha"
replace municip = "diego del carpio" if municip =="carpio medianero"
replace municip = "san cristobal de trabancos" if municip =="cebolla de trabancos"
replace municip = "horcajada, la" if municip =="encinares"
replace municip = "santa maria del tietar" if municip =="escarabajosa"
replace municip = "san juan del olmo" if municip =="grajos"
replace municip = "san juan de gredos" if municip =="herguijuela, la"
replace municip = "santiago del tormes" if municip =="lastra del cano, la"
replace municip = "padiernos" if municip =="munochas"
replace municip = "herrera del duque" if municip =="peloche"
replace municip = "serchs" if municip =="baells, la"
replace municip = "bruc, el" if municip =="bruch"
replace municip = "pacs del penedes" if municip =="pachs"
replace municip = "pontons" if municip =="pontons ,"
replace municip = "pont de vilomara i Rocafort" if municip =="rocafort y vilumara"
replace municip = "cercs" if municip =="serchs"
replace municip = "san julian de vilatorta" if municip =="vilatorta"
replace municip = "villadiego" if municip =="acedillo"
replace municip = "medina de pomar" if municip =="aforados de moneo"
replace municip = "arlanzon" if municip =="ages"
replace municip = "aranda de duero" if municip =="aguilera, la"
replace municip = "sotresgudo" if municip =="amaya"
replace municip = "villadiego" if municip =="arenillas de villadiego"
replace municip = "alfoz de quintanadueñas" if municip =="arroyal"
replace municip = "valle de santibañez" if municip =="avellanosa del paramo"
replace municip = "miranda de ebro" if municip =="ayuelas"
replace municip = "oña" if municip =="barcina de los montes"
replace municip = "oña" if municip =="bentretea"
replace municip = "oña" if municip =="cornudilla"
replace municip = "oña" if municip =="terminon"
replace municip = "sotresgudo" if municip =="barrio de san felices"
replace municip = "villadiego" if municip =="barrios de villadiego"
replace municip = "pedrosa de duero" if municip =="boada de roa"
replace municip = "briviesca" if municip =="cameno"
replace municip = "salas de los infantes" if municip =="castrovido"
replace municip = "cañizar de argaño" if municip =="cañizar de los ajos"
replace municip = "valle de santibañez" if municip =="celadas, las"
replace municip = "merindad de rio ubierna" if municip =="celadilla sotobrin"
replace municip = "merindad de rio ubierna" if municip =="cernegula"
replace municip = "sasamon" if municip =="citores del paramo"
replace municip = "villadiego" if municip =="coculina"
replace municip = "ibeas de juarros" if municip =="cueva de juarros"
replace municip = "sotresgudo" if municip =="cuevas de amaya"
replace municip = "valle de sedano" if municip =="escalada"
replace municip = "belorado" if municip =="eterna"
replace municip = "valle de sedano" if municip =="gredilla de sedano"
replace municip = "merindad de rio ubierna" if municip =="molina de ubierna, la"
replace municip = "merindad de rio ubierna" if municip =="sotopalacios"
replace municip = "merindad de rio ubierna" if municip =="quintanarruz"
replace municip = "merindad de rio ubierna" if municip =="sotopalacios"
replace municip = "merindad de rio ubierna" if municip =="ubierna"
replace municip = "gredilla de sedano" if municip =="moradillo de sedano"
replace municip = "hormazas" if municip =="parte, la"
replace municip = "basconcillos del tozo" if municip =="piedra, la"
replace municip = "belorado" if municip =="puras de villafranca"
replace municip = "gredilla de sedano" if municip =="quintanaloma"
replace municip = "pedrosa de duero" if municip =="quintanamanvirgo"
replace municip = "huerta del rey" if municip =="quintanarraya"
replace municip = "valle de santibañez" if municip =="rebolledas, las"
replace municip = "villalbilla de burgos" if municip =="renuncio"
replace municip = "valle de las navas" if municip =="riocerezo"
replace municip = "valle de las navas" if municip =="rioseras"
replace municip = "valle de las navas" if municip =="robredo temiño"
replace municip = "valle de las navas" if municip =="tobes y rahedo"
replace municip = "valle de santibañez" if municip =="ros"
replace municip = "sotresgudo" if municip =="salazar de amaya"
replace municip = "ibeas de juarros" if municip =="salgüero de juarros"
replace municip = "pedrosa del rio urbel" if municip =="san pedro samuel"
replace municip = "villadiego" if municip =="sandoval de la reina"
replace municip = "valle de santibañez" if municip =="santibañez zarzaguda"
replace municip = "valle de sedano" if municip =="sedano"
replace municip = "barrios de bureba, los" if municip =="solduengo"
replace municip = "sotresgudo" if municip =="sotovellanos"
replace municip = "villadiego" if municip =="tapia"
replace municip = "quintanilla-tordueles" if municip =="tordueles"
replace municip = "valle de santibañez" if municip =="tremellos, los"
replace municip = "villasur de herreros" if municip =="urrez"
replace municip = "villadiego" if municip =="valcarceres, los"
replace municip = "valle de sedano" if municip =="valdelateja"
replace municip = "barrios de bureba, los" if municip =="vesgas, las"
replace municip = "burgos" if municip =="villafria de burgos"
replace municip = "villadiego" if municip =="villahizan de treviño"
replace municip = "villadiego" if municip =="villanueva de odra"
replace municip = "sasamon" if municip =="villasidro"
replace municip = "isar" if municip =="villorejo"
replace municip = "villasur de herreros" if municip =="villorobe"
replace municip = "estepar" if municip =="vilviestre de muño"
replace municip = "sasamon" if municip =="yudego y villandiego"
replace municip = "arlanzon" if municip =="zalduendo"
replace municip = "valle de santibañez" if municip =="zumel"
replace municip = "cañaveral" if municip =="arco"
replace municip = "alcantara" if municip =="estorninos"
replace municip = "cañaveral" if municip =="grimaldo"
replace municip = "peraleda de la mata" if municip =="torviscoso"
replace municip = "villamiel" if municip =="trevejo"
replace municip = "atzeneta del maestrat" if municip =="adzaneta"
replace municip = "ain" if municip =="ahin"
replace municip = "puebla de benifasar" if municip =="ballestar"
replace municip = "betxi" if municip =="bechi"
replace municip = "rossell" if municip =="bel"
replace municip = "puebla de benifasar" if municip =="bojar"
replace municip = "montanejos" if municip =="campos de arenoso"
replace municip = "chert/xert" if municip =="chert"
replace municip = "morella" if municip =="chiva de morella"
replace municip = "puebla de benifasar" if municip =="corachar"
replace municip = "puebla de benifasar" if municip =="fredes"
replace province = "valencia" if municip =="gatova"
replace municip = "morella" if municip =="ortells"
replace municip = "valle del dubra" if municip =="bujan"
replace municip = "santiago de compostela" if municip =="enfesta"
replace municip = "laxe" if municip =="lage"
replace municip = "noia" if municip =="noya"
replace municip = "oza dos rios" if municip =="oza de los rios"
replace municip = "ferrol" if municip =="serantes"
replace municip = "porto do son" if municip =="son"
replace municip = "begur" if municip =="bagur"
replace municip = "san esteban de bas" if municip =="bas"
replace municip = "albaña" if municip =="bassagoda"
replace municip = "banyoles" if municip =="bañolas"
replace municip = "brunyola" if municip =="bruñola"
replace municip = "boadella d'emporda" if municip =="buadella"
replace municip = "queralbs" if municip =="caralps"
replace municip = "santa coloma de farnes" if municip =="cladells"
replace municip = "corça" if municip =="corsa"
replace municip = "cruilles, monells i sant sadurni de l'heura" if municip =="cruilles"
replace municip = "maia del montcal" if municip =="dosquers"
replace municip = "vall de bas" if municip =="juanetas"
replace municip = "juia" if municip =="juya"
replace municip = "llosses, les" if municip =="llosas, las"
replace municip = "san julian de ramis" if municip =="medina"
replace municip = "vall de bas" if municip =="piña, la"
replace municip = "gerona" if municip =="san daniel"
replace municip = "cruilles, monells i sant sadurni de l'heura" if municip =="san sadurni"
replace municip = "sellera de ter, la" if municip =="sellera, la"
replace municip = "fontanals de cerdanya" if municip =="urtg"
replace municip = "forallac" if municip =="vulpellach"
replace municip = "lecrin" if municip =="acequias"
replace municip = "orjiva" if municip =="alcazar y fregenite"
replace municip = "valle del zalabi" if municip =="alcudia de guadix"
replace municip = "vegas del genil" if municip =="ambroz"
replace municip = "vegas del genil" if municip =="belicena"
replace municip = "lecrin" if municip =="beznar"
replace municip = "atarfe" if municip =="caparacena"
replace municip = "valle del zalabi" if municip =="charches"
replace municip = "ugijar" if municip =="cherin"
replace municip = "lecrin" if municip =="chite y talara"
replace municip = "villamena" if municip =="conchar"
replace municip = "villamena" if municip =="cozvijar"
replace municip = "valle del zalabi" if municip =="esfiliana"
replace municip = "taha" if municip =="ferreirola"
replace municip = "pinar" if municip =="izbor"
replace municip = "ugijar" if municip =="jorairatar"
replace municip = "morelabor" if municip =="laborcillas"
replace municip = "nevada" if municip =="laroles"
replace municip = "nevada" if municip =="mairena"
replace municip = "valor" if municip =="mecinaalfahar"
replace municip = "alpujarra de la sierra" if municip =="mecinabombaron"
replace municip = "taha, la" if municip =="mecinafondales"
replace municip = "valle, el" if municip =="melegis"
replace municip = "lecrin" if municip =="mondujar"
replace municip = "lecrin" if municip =="murchas"
replace municip = "cadiar" if municip =="narila"
replace municip = "valor" if municip =="nechite"
replace municip = "nevada" if municip =="picena"
replace municip = "pinar, el" if municip =="pinos del valle"
replace municip = "taha, la" if municip =="pitres"
replace municip = "pulianas" if municip =="puleanillas"
replace municip = "vegas del genil" if municip =="purchil"
replace municip = "valle, el" if municip =="restabal"
replace municip = "valle, el" if municip =="saleres"
replace municip = "montillana" if municip =="trujillos"
replace municip = "alhama de granada" if municip =="ventas de zafarraya"
replace municip = "cadiar" if municip =="yator"
replace municip = "alpujarra de la sierra" if municip =="yegen"
replace municip = "sigüenza" if municip =="alboreca"
replace municip = "toba, la" if municip =="alcorlo"
replace municip = "sigüenza" if municip =="alcuneza"
replace municip = "condemios de arriba" if municip =="aldeanueva de atienza"
replace municip = "cogolludo" if municip =="aleas"
replace municip = "tamajon" if municip =="almiruete"
replace municip = "valdepeñas de la sierra" if municip =="alpedrete de la sierra"
replace municip = "atienza" if municip =="alpedroches"
replace municip = "tartanedo" if municip =="amayas"
replace municip = "estables" if municip =="anchuela del campo"
replace municip = "molina" if municip =="anchuela del pedregal"
replace municip = "corduente" if municip =="aragoncillo"
replace municip = "brihuega" if municip =="archilla"
replace municip = "sigüenza" if municip =="atance, el"
replace municip = "trillo" if municip =="azañon"
replace municip = "maranchon" if municip =="balbacil"
replace municip = "brihuega" if municip =="balconete"
replace municip = "cogolludo" if municip =="beleña de sorbe"
replace municip = "cardoso de la sierra, el" if municip =="bocigano"
replace municip = "sigüenza" if municip =="bujarrabal"
replace municip = "secarro" if municip =="cabezadas, las"
replace municip = "corduente" if municip =="canales de molina"
replace municip = "sacecorbo" if municip =="canales del ducado"
replace municip = "sigüenza" if municip =="carabias"
replace municip = "espinosa de henares" if municip =="carrascosa de henares"
replace municip = "cifuentes" if municip =="carrascosa de tajo"
replace municip = "jadraque" if municip =="castilblanco de henares"
replace municip = "brihuega" if municip =="castilmimbre"
replace municip = "sigüenza" if municip =="cercadillo"
replace municip = "pareja" if municip =="cereceda"
replace municip = "humanes" if municip =="cerezo de mohernando"
replace municip = "maranchon" if municip =="clares"
replace municip = "maranchon" if municip =="codes"
replace municip = "alcolea del pinar" if municip =="cortes de tajuña"
replace municip = "molina" if municip =="cubillejo de la sierra"
replace municip = "molina" if municip =="cubillejo del sitio"
replace municip = "torete" if municip =="cuevas labradas"
replace municip = "torremocha del campo" if municip =="fuensaviñan, la"
replace municip = "brihuega" if municip =="fuentes de la alcarria"
replace municip = "cifuentes" if municip =="gargoles de abajo"
replace municip = "cifuentes" if municip =="gargoles de arriba"
replace municip = "cifuentes" if municip =="gualda"
replace municip = "sigüenza" if municip =="guijosa"
replace municip = "tartanedo" if municip =="hinojosa"
replace municip = "brihuega" if municip =="hontanares"
replace municip = "pareja" if municip =="hontanillas"
replace municip = "sigüenza" if municip =="horna"
replace municip = "zaorejas" if municip =="huertapelayo"
replace municip = "cifuentes" if municip =="huetos"
replace municip = "sigüenza" if municip =="imon"
replace municip = "guadalajara" if municip =="iriepal"
replace municip = "arbancon" if municip =="jocar"
replace municip = "tartanedo" if municip =="labros"
replace municip = "torremocha del campo" if municip =="laranueva"
replace municip = "torete" if municip =="lebrancon"
replace municip = "atienza" if municip =="madrigal"
replace municip = "casar de talamanca, el" if municip =="mesones"
replace municip = "sigüenza" if municip =="moratilla de henares"
replace municip = "trillo" if municip =="morillejo"
replace municip = "alustante" if municip =="motos"
replace municip = "tamajon" if municip =="muriel"
replace municip = "torremocha del campo" if municip =="navalpotro"
replace municip = "brihuega" if municip =="olmeda del extremo"
replace municip = "sigüenza" if municip =="olmedillas"
replace municip = "cifuentes" if municip =="oter"
replace municip = "hita" if municip =="padilla de hita"
replace municip = "anguita" if municip =="padilla del ducado"
replace municip = "brihuega" if municip =="pajares"
replace municip = "tamajon" if municip =="palancares"
replace municip = "sigüenza" if municip =="palazuelos"
replace municip = "sigüenza" if municip =="pelegrina"
replace municip = "cardoso de la sierra, el" if municip =="peñalba de la sierra"
replace municip = "sacedon" if municip =="poyos"
replace municip = "sigüenza" if municip =="pozancos"
replace municip = "trillo" if municip =="puerta, la"
replace municip = "torija" if municip =="rebollosa de hita"
replace municip = "torremocha del campo" if municip =="renales"
replace municip = "riba de saelices" if municip =="ribarredonda"
replace municip = "riotovi del valle de sigüenza" if municip =="riosalido"
replace municip = "brihuega" if municip =="romancos"
replace municip = "cifuentes" if municip =="ruguilla"
replace municip = "anguita" if municip =="santa maria del espino"
replace municip = "semillas" if municip =="secarro"
replace municip = "cifuentes" if municip =="sotoca de tajo"
replace municip = "guadalajara" if municip =="taracena"
replace municip = "corduente" if municip =="terraza"
replace municip = "brihuega" if municip =="tomellosa"
replace municip = "corduente" if municip =="torete"
replace municip = "riotovi del valle de sigüenza" if municip =="torre de valdealmendras"
replace municip = "cogolludo" if municip =="torrebeleña"
replace municip = "escamilla" if municip =="torronteras"
replace municip = "alcolea del pinar" if municip =="tortonda"
replace municip = "maranchon" if municip =="turmiel"
replace municip = "guadalajara" if municip =="usanos"
replace municip = "vereda, la" if municip =="vado, el"
replace municip = "cifuentes" if municip =="val de san garcia"
replace municip = "espinosa de henares" if municip =="valdeancheta"
replace municip = "budia" if municip =="valdelagua"
replace municip = "guadalajara" if municip =="valdenoches"
replace municip = "brihuega" if municip =="valdesaz"
replace municip = "ledanca" if municip =="valfermoso de las monjas"
replace municip = "cogolludo" if municip =="veguillas"
replace municip = "trillo" if municip =="viana de mondejar"
replace municip = "cantalojas" if municip =="villacadima"
replace municip = "riotovi del valle de sigüenza" if municip =="villacorza"
replace municip = "peralveche" if municip =="villaescusa de palositos"
replace municip = "zaorejas" if municip =="villar de cobeta"
replace municip = "rata" if municip =="villarejo de medina"
replace municip = "alcolea del pinar" if municip =="villaverde del ducado"
replace municip = "brihuega" if municip =="villaviciosa de tajuña"
replace municip = "brihuega" if municip =="yela"
replace municip = "zizurkil" if municip =="cizurquil"
replace municip = "rrretxu" if municip =="villarreal de urrechu"
replace municip = "banaguas" if municip =="abay"
replace municip = "navasa" if municip =="abena"
replace municip = "sabiñanigo" if municip =="acumuer"
replace municip = "ainsa-sobrarbe" if municip =="ainsasobrarbe"
replace municip = "abiego" if municip =="alberuela de la liena"
replace municip = "canal de berdun" if municip =="berdun"
replace municip = "broto" if municip =="bergua basaran"
replace municip = "valle de hecho" if municip =="embun"
replace municip = "escarrilla" if municip =="escarrilla ,"
replace municip = "sallent de gallego" if municip =="escarrilla"
replace municip = "fueva, la" if municip =="morillo de monclus"
replace municip = "graus" if municip =="puebla de fantova, la"
replace municip = "isabena" if municip =="puebla de roda, la"
replace municip = "alcala del obispo" if municip =="pueyo de fañanas"
replace municip = "panticosa" if municip =="pueyo de jaca, el"
replace municip = "arguisal" if municip =="senegüe y sorripas"
replace municip = "isabena" if municip =="serraduy"
replace municip = "tormillo" if regexm(municip, "tormillo")
replace municip = "peralta de alcofea" if municip =="tormillo"
replace municip = "angües" if municip =="velillas"
replace municip = "bedmar y garciez" if municip =="garciez"
replace municip = "lahiguera" if municip =="higuera de arjona"
replace municip = "huelma" if municip =="solera"
replace municip = "villatorres" if municip =="torrequebradilla"
replace municip = "torre del bierzo" if municip =="albares de la ribera"
replace municip = "leon" if municip =="armunia"
replace municip = "ponferrada" if municip =="barrios de salas, los"
replace municip = "riello" if municip =="campo de la lomba"
replace municip = "almanza" if municip =="canalejas"
replace municip = "villaornate y castro" if municip =="castrofuerte"
replace municip = "cubillos del sil" if municip =="fresnedo" //
replace municip = "sahagun" if municip =="galleguillos de campos"
replace municip = "sahagun" if municip =="joara"
replace municip = "villafranca del bierzo" if municip =="paradaseca"
replace municip = "boca de huergano" if municip =="pedrosa del rey" //
replace municip = "santa colomba de somoza" if municip =="rabanal del camino"
replace municip = "valderrueda" if municip =="renedo de valdetuejar"
replace municip = "villamanin" if municip =="rodiezmo"
replace municip = "cea" if municip =="saelices del rio"
replace municip = "cremenes" if municip =="salamon"
replace municip = "priaranza del bierzo" if municip =="san esteban de valdueza"
replace municip = "valdelugueros" if municip =="valdeteja"
replace municip = "vega de espinareda" if municip =="valle de finolledo"
replace municip = "almanza" if municip =="vega de almanza, la"
replace municip = "boñar" if municip =="vegamian"
replace municip = "riello" if municip =="vegarienza"
replace province = "huesca" if municip =="ainsa-sobrarbe"
*replace codprov = 22 if municip =="ainsa-sobrarbe"
replace municip = "figols y aliña" if municip =="aliña"
replace municip = "plans d'el sio" if municip =="araño"
replace municip = "viella-mitg-aran" if municip =="arros y vila"
replace municip = "sentiu de sio, la" if municip =="asentiu"
replace municip = "artesa de segre" if municip =="aña"
replace municip = "naut aran" if municip =="bagerque"
replace municip = "baix pallars" if municip =="bahent"
replace municip = "baronia de rialb, la" if municip =="baronia de rialp"
replace municip = "agramunt" if municip =="doncell"
replace municip = "figols de temp" if municip =="eroles"
replace municip = "guingueta, la" if municip =="escalo"
replace municip = "viella-mitg-aran" if municip =="escuñau"
replace municip = "conca d'alla" if municip =="figuerola de orcaut"
replace municip = "vansa-fornols, la" if municip =="fornols"
replace municip = "san guim de freixanet" if municip =="freixanet y altadill"
replace municip = "gabarra" if municip =="gabarra ,"
replace municip = "coll de nargo" if municip =="gabarra"
replace municip = "viella-mitg-aran" if municip =="gausach"
replace municip = "baix pallars" if municip =="gerri"
replace municip = "valls d'aguilar" if municip =="guardia de ares, la"
replace municip = "tora" if municip =="llanera del arroyo"
replace municip = "sort" if municip =="llesuy"
replace municip = "baix pallars" if municip =="moncortes"
replace municip = "torre de capdella" if municip =="monros"
replace municip = "lles" if municip =="musa y aransa"
replace municip = "oluges, les" if municip =="olujas"
replace municip = "plans d'el sio" if municip =="pallargas"
replace municip = "ribera de urgellet" if municip =="parroquia de orto"
replace municip = "coma i la pedra, la" if municip =="pedra y coma"
replace municip = "cervera" if municip =="preñanosa"
replace municip = "rocafort de vallbona" if municip =="rocafort de vallbona ,"
replace municip = "sant marti de rio corb" if municip =="rocafort de vallbona"
replace municip = "naut aran" if municip =="alto aran"
replace municip = "isona i conca della" if municip =="conca d'alla"
replace municip = "guingueta d'aneu, la" if municip =="guingueta, la"
replace municip = "avellanes-santaliña" if municip =="santa liña"
replace municip = "seu d'urgell, la" if municip =="seo de urgel"
replace municip = "alas-serch" if municip =="serch"
replace municip = "alto aneu" if municip =="son del pino"
replace municip = "tremp" if municip =="suterraña"
replace municip = "sunyer" if municip =="suñe"
replace municip = "valls d'aguilar" if municip =="tahus"
replace municip = "pons" if municip =="tosal"
replace municip = "artesa de segre" if municip =="tudela del segre"
replace municip = "josa-tuixent" if municip =="tuxent"
replace municip = "valbona de las monjas" if municip =="valbona de las moujas"
replace municip = "alto aneu" if municip =="valencia de areo"
replace municip = "valls d'aguilar, les" if municip =="valls d'aguilar"
replace province = "huesca" if municip =="viacamp y litera"
replace municip = "vielha e mijaran" if municip =="viella-mitg-aran"
replace municip = "montella-martinet" if municip =="vilech y estana"
replace municip = "bergasa" if municip =="carbonera"
replace municip = "santa engracia del jubera" if municip =="jubera"
replace municip = "ajamil" if municip =="larriba"
replace municip = "soto en cameros" if municip =="luezas"
replace municip = "montalbo en cameros" if municip =="montalbo en cameros"
replace municip = "san roman de cameros" if municip =="montalbo en cameros"
replace municip = "enciso" if municip =="poyales"
replace municip = "munilla" if municip =="santa, la"
replace municip = "soto en cameros" if municip =="trevijano"
replace municip = "arnedo" if municip =="turruncun"
replace municip = "lagunilla de jubera" if municip =="zenzano"
replace municip = "baralla" if municip =="neira de jusa"
replace municip = "pedrafita do cebreiro" if municip =="piedrafita"
replace municip = "pobra de brollon, a" if municip =="puebla del brollon"
replace municip = "vicedo" if municip =="riobarba"
replace municip = "rabade" if municip =="san vicente de rabade"
replace municip = "triacastela" if municip =="trasparga"
replace municip = "valadouro" if municip =="valle de oro"
replace municip = "puente nuevo-villaodrid" if municip =="villaodrid"
replace municip = "madrid" if municip =="aravaca"
replace municip = "a pontenova" if municip =="puente nuevo-villaodrid"
replace municip = "madrid" if municip =="canillas"
replace municip = "madrid" if municip =="canillejas"
replace municip = "madrid" if municip =="carabanchel alto"
replace municip = "madrid" if municip =="carabanchel bajo"
replace municip = "madrid" if municip =="chamartin de la rosa"
replace municip = "madrid" if municip =="fuencarral"
replace municip = "madrid" if municip =="hortaleza"
replace municip = "puentes viejas" if municip =="manjiron"
replace municip = "lozoyuela-navas-sieteiglesias" if municip =="navas de buitrago, las"
replace municip = "oteruelo" if municip =="oteruelo del valle"
replace municip = "madrid" if municip =="pardo, el"
replace municip = "puentes viejas" if municip =="paredes de buitrago"
replace municip = "piñuecar-gandullas" if municip =="pinuecar"
replace municip = "rivas-vaciamadrid" if municip =="ribas de jarama"
replace municip = "madrid" if municip =="vallecas"
replace municip = "madrid" if municip =="vicalvaro"
replace municip = "malaga" if municip =="olias"
replace municip = "campillos" if municip =="peñarrubia"
replace municip = "ezcaroz" if municip =="escaroz"
replace municip = "goñi" if municip =="goni"
replace municip = "uharte-arakil" if municip =="huarte - araquil"
replace municip = "baztan" if municip =="maya del baztan"
replace municip = "sada" if municip =="saba"
replace municip = "leoz" if municip =="sansoain"
replace municip = "urrotz" if municip =="urroz de santesteban"
replace municip = "hiriberri/villanueva de aezkoa" if municip =="villanueva"
replace municip = "celanova" if municip =="acebedo del rio"
replace municip = "ourense" if municip =="canedo"
replace municip = "irixo, o" if municip =="irijo"
replace municip = "valdes" if municip =="luarca"
replace municip = "valle de retortillo" if municip =="abastas"
replace municip = "san cebrian de campos" if municip =="amayuelas de abajo"
replace municip = "cervera de pisuerga" if municip =="arbejal"
replace municip = "buenavista de valdavia" if municip =="arenillas de san pelayo"
replace municip = "valle de retortillo" if municip =="añoza"
replace municip = "loma de ucieza" if municip =="bahillo"
replace municip = "aguilar de campoo" if municip =="barrio de san pedro"
replace municip = "cervatos de la cueza" if municip =="calzadilla de la cueza"
replace municip = "velilla del rio carrion" if municip =="camporredondo de alba"
replace municip = "cervera de pisuerga" if municip =="celada de roblecedo"
replace municip = "matamorisca" if municip =="cenera de zalima"
replace municip = "aguilar de campoo" if municip =="cozuelos de ojeda"
replace municip = "villaherreros" if municip =="fuente - andrino"
replace municip = "loma de ucieza" if municip =="itero seco"
replace municip = "ourense" if municip =="orense"
replace municip = "lozoyuela-navas-sieteiglesias" if municip =="lozoyuela"
replace municip = "lozoyuela-navas-sieteiglesias" if municip =="sieteiglesias"
replace municip = "rascafria" if municip =="oteruelo"
replace municip = "leoz/leotz" if municip =="sansoain"
replace municip = "alar del rey" if municip =="becerril del carpio"
replace municip = "loma de ucieza" if municip =="gozon de ucieza"
replace municip = "cervera de pisuerga" if municip =="ligüerzana"
replace municip = "pernia, la" if municip =="lores"
replace municip = "aguilar de campoo" if municip =="matamorisca"
replace municip = "saldaña" if municip =="membrillar"
replace municip = "aguilar de campoo" if municip =="nestar"
replace municip = "valcovero" if municip =="otero de guardo"
replace municip = "astudillo" if municip =="palacios del alcor"
replace municip = "villada" if municip =="pozuelos del rey"
replace municip = "redondo areños" if municip =="redondo"
replace municip = "cervera de pisuerga" if municip =="resoba"
replace municip = "pernia, la" if municip =="san salvador de cantamuda"
replace municip = "lagartos" if municip =="terradillos de templarios"
replace municip = "carrion de los condes" if municip =="torre de los molinos"
replace municip = "baltanas" if municip =="valdecañas de cerrato"
replace municip = "valsadornin" if municip =="vañes"
replace municip = "saldaña" if municip =="vega de doña olimpa"
replace municip = "san cebrian de muda" if municip =="vergaño"
replace municip = "herrera de pisuerga" if municip =="villabermudo"
replace municip = "osorno la mayor" if municip =="villadiezma"
replace municip = "saldaña" if municip =="villafruel"
replace municip = "monzon de campos" if municip =="villajimena"
replace municip = "valle de retortillo" if municip =="villalumbroso"
replace municip = "miñanes" if municip =="villamorco"
replace municip = "valle de retortillo" if municip =="villatoquite"
replace municip = "villada" if municip =="villelga"
replace municip = "villa de cruces" if municip =="carbia"
replace municip = "pontevedra" if municip =="geve"
replace municip = "vigo" if municip =="lavadores"
replace municip = "neves, as" if municip =="nieves"
replace municip = "oia" if municip =="oya"
replace municip = "poio" if municip =="poyo"
replace municip = "pontevedra" if municip =="puente - sampayo"
replace municip = "san miguel del robledo" if municip =="arroyomuerto"
replace municip = "villar de la Yegua" if municip =="barquilla"
replace municip = "puente del congosto" if municip =="bercimuelle"
replace municip = "fuente de san esteban, la" if municip =="boadilla"
replace municip = "villariño" if municip =="cabeza de framontanos"
replace municip = "guijuelo" if municip =="cabezuela de salvatierra"
replace municip = "guijuelo" if municip =="campillo de salvatierra"
replace municip = "villaseco de los reyes" if municip =="campo de ledesma, el"
replace municip = "mata de armuña, la" if municip =="carbajosa de armuña"
replace municip = "castellanos de villiquera" if municip =="mata de armuña, la"
replace municip = "puebla de azaba" if municip =="castillejo de azaba"

replace municip = "sarral" if municip =="montbrio de la marca"
replace municip = "aldea del obispo" if municip =="castillejo de dos casas"
replace municip = "mozarbez" if municip =="cilleros el hondo"
replace municip = "aldeavilla de la ribera" if municip =="corporario"
replace municip = "villaseco de los reyes" if municip =="gejo de los reyes, el"
replace municip = "ciperez" if municip =="grandes"
replace municip = "castellanos de villiquera" if municip =="mata de armuña, la"
replace municip = "fuente de san esteban, la" if municip =="muñoz"
replace municip = "frades de la sierra" if municip =="navarredonda de salvatierra"
replace municip = "guijuelo" if municip =="palacios de salvatierra"
replace municip = "castellanos de viliquera" if municip =="mata de armuña, la"
replace municip = "mozarbez" if municip =="mozarvez"
replace municip = "bejar" if municip =="palomares"
replace municip = "ledesma" if municip =="pelilla"
replace municip = "pereña de la ribera" if municip =="perena"
replace municip = "villar de argañan" if municip =="sexmiro"
replace municip = "salamanca" if municip =="tejares"
replace municip = "arapilles" if municip =="torres, las"
replace municip = "campoo de enmedio" if municip =="enmedio"
replace municip = "riaza" if municip =="aldeanueva del monte"
replace municip = "cantalejo" if municip =="aldeonsancho"
replace municip = "santa maria la real de nieva" if municip =="aragoneses"
replace municip = "cuellar" if municip =="arroyo de cuellar"
replace municip = "santa maria la real de nieva" if municip =="balisa"
replace municip = "riaza" if municip =="becerril"
replace municip = "santiuste de san juan bautista" if municip =="bernuy de coca"
replace municip = "cuellar" if municip =="campo de cuellar"
replace municip = "armuña" if municip =="carbonero de ahusin"
replace municip = "pradena" if municip =="castroserna de arriba"
replace municip = "cuellar" if municip =="chatun"
replace municip = "coca" if municip =="ciruelos de coca"
replace municip = "sangarcia" if municip =="cobos de segovia"
replace municip = "turegano" if municip =="cuesta, la"
replace municip = "cuellar" if municip =="dehesa"
replace municip = "sepulveda" if municip =="duraton"
replace municip = "ayllon" if municip =="estebanvela"
replace municip = "sangarcia" if municip =="etreros"
replace municip = "segovia" if municip =="fuentemilanos"
replace municip = "ayllon" if municip =="grado del pico"
replace municip = "espirdo" if municip =="higuera, la"
replace municip = "sepulveda" if municip =="hinojosas del cerro"
replace municip = "segovia" if municip =="hontoria"
replace municip = "santa maria la real de nieva" if municip =="hoyuelos"
replace municip = "santa maria la real de nieva" if municip =="jemenuño"
replace municip = "santa maria la real de nieva" if municip =="laguna - rodrigo"
replace municip = "montejo de la vega de la serrez" if municip =="linares del arroyo"
replace municip = "torreiglesias" if municip =="losana de piron"
replace municip = "cuellar" if municip =="lovingos"
replace municip = "riaza" if municip =="madriguera"
replace municip = "segovia" if municip =="madrona"
replace municip = "santa maria la real de nieva" if municip =="miguel ibañez"
replace municip = "codorniz" if municip =="montuenga"
replace municip = "riaza" if municip =="muyo, el"
replace municip = "samoal" if municip =="narros de cuellar"
replace municip = "riaza" if municip =="negredo, el"
replace municip = "santa maria la real de nieva" if municip =="ochando"
replace municip = "otones" if municip =="otones de benjumea"
replace municip = "fresno de cantespino" if municip =="pajares de fresno"
replace municip = "santa maria la real de nieva" if municip =="paradinas"
replace municip = "sepulveda" if municip =="perorrubio"
replace municip = "santa maria la real de nieva" if municip =="pinilla - ambroz"
replace municip = "segovia" if municip =="revenga"
replace municip = "fresno de cantespino" if municip =="riahuelas"
replace municip = "torre val de san pedro" if municip =="salceda, la"
replace municip = "ayllon" if municip =="saldaña de ayllon"
replace municip = "ayllon" if municip =="santibañez de ayllon"
replace municip = "madriguera" if municip =="serracin"
replace municip = "santo tome del puerto" if municip =="siguero"
replace municip = "santo tome del puerto" if municip =="sigueruelo"
replace municip = "santa maria la real de nieva" if municip =="tabladillo"
replace municip = "boceguillas" if municip =="turrubuelo"
replace municip = "cantalejo" if municip =="valdesimonte"
replace municip = "campo de san pedro" if municip =="valdevarnes"
replace municip = "ayllon" if municip =="valvieja"
replace municip = "olombrada" if municip =="vegafria"
replace municip = "riaza" if municip =="villacorta"
replace municip = "santa maria la real de nieva" if municip =="villoslada"
replace municip = "segovia" if municip =="zamarramala"
replace municip = "berlanga de duero" if municip =="abanco"
replace municip = "gomara" if municip =="abion"
replace municip = "san pedro manrique" if municip =="acrijos"
replace municip = "almaluez" if municip =="aguaviva de la vega"
replace municip = "arcos de jalon" if municip =="aguilar de montuenga"
replace municip = "berlanga de duero" if municip =="alalo"
replace municip = "deza" if municip =="alameda, la"
replace municip = "alcubilla de avellaneda" if municip =="alcoba de la torre"
replace municip = "langa de duero" if municip =="alcozar"
replace municip = "burgo de osma-ciudad de osma" if municip =="alcubilla del marques"
replace municip = "agreda" if municip =="aldehuela de agreda"
replace municip = "sotillo del rincon" if municip =="aldehuela del rincon"
replace municip = "miño de medinaceli" if municip =="ambrona"
replace municip = "berlanga de duero" if municip =="andaluz"
replace municip = "poveda, la" if municip =="arguijo"
replace municip = "san pedro manrique" if municip =="armejun"
replace municip = "san esteban de gormaz" if municip =="atauta"
replace municip = "valdemaluque" if municip =="aylagas"
replace municip = "poveda, la" if municip =="barriomartin"
replace municip = "medinaceli" if municip =="beltejar"
replace municip = "san esteban de gormaz" if municip =="aldea de san esteban"
replace municip = "medinaceli" if municip =="benamira"
replace municip = "burgo de osma-ciudad de osma" if municip =="berzosa"
replace municip = "medinaceli" if municip =="blocona"
replace municip = "langa de duero" if municip =="bocigas de perales"
replace municip = "bayubas de arriba" if municip =="boos"
replace municip = "caltojar" if municip =="bordecorex"
replace municip = "villar del rio" if municip =="bretun"
replace municip = "berlanga de duero" if  strpos(municip, "brias")== 1 
replace municip = "san pedro manrique" if municip =="buimanco"
replace municip = "burgo de osma-ciudad de osma" if municip =="burgo de osma, el"
replace municip = "berlanga de duero" if municip =="cabreriza"
replace municip = "arancon" if municip =="calderuela"
replace municip = "golmayo" if municip =="camparañon"
replace municip = "garray" if municip =="canredondo de la sierra"
replace municip = "golmayo" if municip =="carbonera de frentes"
replace municip = "almenar de soria" if municip =="cardejon"
replace municip = "montejo de tiermes" if municip =="carrascosa de arriba"
replace municip = "almenar de soria" if municip =="castejon del campo"
replace municip = "tejado" if municip =="castil de tierra"
replace municip = "arcos de jalon" if municip =="chaorna"
replace municip = "garray" if municip =="chavaler"
replace municip = "almaluez" if municip =="chercoles"
replace municip = "almazan" if municip =="cobertelada"
replace municip = "oncala" if municip =="collado, el"
replace municip = "miño de medinaceli" if municip =="conquezuela"
replace municip = "arancon" if municip =="cortos"
replace municip = "almarza" if municip =="cubo de la sierra"
replace municip = "golmayo" if municip =="cuenca, la"
replace municip = "montejo de tiermes" if municip =="cuevas de ayllon"
replace municip = "quintana redonda" if municip =="cuevas de soria, las"
replace municip = "villar del rio" if municip =="diustes"
replace municip = "garray" if municip =="dombellas"
replace municip = "almenar de soria" if municip =="esteras de lubia"
replace municip = "medinaceli" if municip =="esteras de medina"
replace municip = "berlanga de duero" if municip =="alalo"
replace municip = "golmayo" if municip =="fraguas, las"
replace municip = "almarza" if municip =="gallinero"
replace municip = "cidones" if municip =="herreros"
replace municip = "royo, el" if municip =="hinojosa de la sierra"
replace municip = "adradas" if municip =="hontalbilla de almazan"
replace municip = "montejo de tiermes" if municip =="hoz de abajo"
replace municip = "montejo de tiermes" if municip =="hoz de arriba"
replace municip = "villar de rio" if municip =="huerteles"
replace municip = "san esteban de gormaz" if municip =="ines"
replace municip = "cubo de la solana" if municip =="ituero"
replace municip = "almenar de soria" if municip =="jaray"
replace municip = "baraona" if municip =="jodra de cardos"
replace municip = "arcos de jalon" if municip =="judes"
replace municip = "burgo de osma-ciudad de osma" if municip =="lodares de osma"
replace municip = "retortillo de soria" if municip =="losana"
replace municip = "berlanga de duero" if municip =="lumias"
replace municip = "retortillo de soria" if municip =="madruedano"
replace municip = "fraguas, las" if municip =="mallona, la"
replace municip = "alpanseque" if municip =="marazovel"
replace municip = "san esteban de gormaz" if municip =="matanza de soria"
replace municip = "san pedro manrique" if municip =="matasejun"
replace municip = "almazul" if municip =="mazateron"
replace municip = "cubilla de las peñas" if municip =="mezquetillas"
replace municip = "deza" if municip =="miñana"
replace municip = "miño de medinaceli" if municip =="miño de medina"
replace municip = "retortillo de soria" if municip =="modamio"
replace municip = "montejo de liceras" if municip =="montejo de liceras"
replace municip = "berlanga de duero" if municip =="morales"
replace municip = "san esteban de gormaz" if municip =="morcuera"
replace municip = "vinuesa" if municip =="muedra, la"
replace municip = "olvega" if municip =="muro de agreda"
replace municip = "golmayo" if municip =="nafria la llana"
replace municip = "rabanos, los" if municip =="navalcaballo"
replace municip = "golmayo" if municip =="nodalo"
replace municip = "recuerda" if municip =="nograles"
replace municip = "tejado" if municip =="nomparedes"
replace municip = "montejo de tiermes" if municip =="noviales"
replace municip = "arevalo de la sierra" if regexm(municip, "ventosa de la sierra")
replace municip = "cidones" if municip =="ocenilla"
replace municip = "san esteban de gormaz" if municip =="olmillos"
replace municip = "olmeda, la" if municip =="osma"
replace municip = "soria" if municip =="oteruelos"
replace municip = "ciruela" if municip =="paones"
replace municip = "soria" if municip =="pedrajas"
replace municip = "recuerda" if municip =="perera, la"
replace municip = "almenar de soria" if municip =="peroniel del campo"
replace municip = "san esteban de gormaz" if municip =="peñalba de san esteban"
replace municip = "quiñoneria" if municip =="peñalcazar"
replace municip = "barahona" if municip =="pinilla del olmo"
replace municip = "san esteban de gormaz" if municip =="piquera de san esteban"
replace municip = "magaña" if municip =="pobar"
replace municip = "fuentelsaz de soria" if municip =="portelrubio"
replace municip = "almaluez" if municip =="puebla de eca"
replace municip = "san esteban de gormaz" if municip =="quintanas rubias de abajo"
replace municip = "san esteban de gormaz" if municip =="quintanas rubias de arriba"
replace municip = "san esteban de gormaz" if municip =="quintanilla de tres barrios"
replace municip = "alcubilla de las peñas" if municip =="radona"
replace municip = "velamazan" if municip =="rebollo de duero"
replace municip = "san esteban de gormaz" if municip =="rejas de san esteban"
replace municip = "quintana redonda" if municip =="revilla de calatañazor, la"
replace municip = "barahona" if municip =="romanillos de medinaceli"
replace municip = "arcos de jalon" if municip =="sagides"
replace municip = "medinaceli" if municip =="salinas de medinaceli"
replace province ="la rioja" if municip =="santa engracia del jubera"
replace municip = "torrubia de soria" if municip =="sauquillo de alcazar"
replace municip = "tejado" if municip =="sauquillo de bonices"
replace municip = "retortillo de soria" if municip =="sauquillo de paredes"
replace municip = "arcos de jalon" if municip =="somaen"
replace municip = "san esteban de gormaz" if municip =="soto de san esteban"
replace municip = "san pedro manrique" if municip =="tanine"
replace municip = "retortillo de soria" if municip =="tarancueña"
replace municip = "rabanos, los" if municip =="tardajos de duero"
replace municip = "garray" if municip =="tardesillas"
replace municip = "almarza" if municip =="tera"
replace municip = "burgo de osma-ciudad de osma" if municip =="torralba del burgo"
replace municip = "arevalo de la sierra" if municip =="torrearevalo"
replace municip = "san esteban de gormaz" if municip =="torremocha de ayllon"
replace municip = "retortillo de soria" if municip =="torrevicente"
replace municip = "arcos de jalon" if municip =="utrilla"
replace municip = "retortillo de soria" if municip =="valvenedizo"
replace municip = "san pedro manrique" if municip =="vea"
replace municip = "yanguas" if municip =="vega y leria, la"
replace municip = "arcos de jalon" if municip =="velilla de medinaceli"
replace municip = "san esteban de gormaz" if municip =="velilla de san esteban"
replace municip = "san pedro manrique" if municip =="ventosa de san pedro"
replace municip = "burgo de osma-ciudad de osma" if municip =="vilde"
replace municip = "golmayo" if municip =="villabuena"
replace municip = "san esteban de gormaz" if municip =="villalvaro"
replace municip = "villar del rio" if municip =="villar de maya"
replace municip = "villar del rio" if municip =="villar del rio fr"
replace municip = "san pedro manrique" if municip =="villarijo"
replace municip = "cidones" if municip =="villaverde del monte"
replace municip = "langa de duero" if municip =="zayas de torre"
replace municip = "banyeres de mariola" if municip =="bañeras"
replace municip = "siurana" if municip =="ciurana de tarragona"
*replace codprov = 17 if municip =="siurana"
replace municip = "duesaigües" if municip =="dosaiguas"
replace municip = "paüls" if municip =="pauls"
replace municip = "santa perpetua de gaia" if municip =="santa perpetua"
replace municip = "sarral" if municip =="sarreal"
replace municip = "tarragona" if municip =="tamarit"
replace municip = "vinyols i els arcs" if municip =="viñols y archs"
replace municip = "teruel" if municip =="castralvo"
replace municip = "aliaga" if municip =="cirugeda"
replace municip = "loscos" if municip =="colladico, el"
replace municip = "formiche alto" if municip =="formiche bajo"
replace municip = "castellote" if municip =="luco de bordon"
replace municip = "poyo del cid, el" if municip =="poyo, el"
replace municip = "martin del rio" if municip =="rambla de martin, la"
replace municip = "santolea" if municip =="santoles"
replace municip = "calamocha" if municip =="villarejo, el"
replace municip = "numancia de la sagra" if municip =="azaña"
replace municip = "santo domingo-caudilla" if municip =="caudilla" //
replace municip = "enova, l'" if municip =="enova"
replace municip = "font d'en carros" if municip =="fuente - encarroz"
replace municip = "llutxent" if municip =="luchente"
replace municip = "llocnou d'En fenollet" if municip =="lugar nuevo de fenollet"
replace municip = "llocnou de sant jeroni" if municip =="lugar nuevo de san jeronimo"
replace municip = "puçol" if regexm(municip, "puzol")
replace municip = "villardefrades" if municip =="almaraz de la mota"
*replace codprov = 24 if municip =="boca de huergano"
*replace codprov = 22 if municip =="jaca"
replace municip = "tiedra" if municip =="pobladura de sotiedra"
replace municip = "valladolid" if municip =="puente - duero"
replace municip = "medina del campo" if municip =="rodilana"
replace municip = "guadalajara" if municip =="tamajon"
replace province = "guadalajara" if municip =="guadalajara"
**replace codprov = 19 if province == "guadalajara"
replace municip = "santervas de campos" if municip =="villacreces"
replace municip = "villabragima" if municip =="villaesper"
replace municip = "matapozuelos" if municip =="villalba de adaja"
replace municip = "santervas de campos" if municip =="zorita de la loma"
replace municip = "valle de achondo" if municip =="axpe"
replace municip = "guetxo" if municip =="guecho"
replace municip = "gernika-lumo" if municip =="guernica y luno"
replace municip = "leioa" if municip =="lejona"
replace municip = "bilbao" if municip =="lujua"
replace municip = "muxika" if municip =="mugica"
replace municip = "muskiz" if municip =="musques"
replace municip = "valle de trapaga-trapagaran" if municip =="san salvador del valle"
replace municip = "bermillo de sayago" if municip =="abelon"
replace municip = "fariza" if municip =="badilla"
replace municip = "santibañez de vidriales" if municip =="bercianos de vidriales"
replace municip = "mahide" if municip =="boya"
replace municip = "zamora" if municip =="carrascal"
replace municip = "rabanales" if municip =="ceadea" //
replace municip = "villalcampo" if municip =="cerezal de aliste"
replace municip = "villar del buey" if municip =="cibanal"
replace municip = "villardeciervos" if municip =="cional"
replace municip = "manzanal de arriba" if municip =="codesal"
replace municip = "quiruelas de vidriales" if municip =="colinas de trasmonte"
replace municip = "granucillo" if municip =="cunquilla de vidriales"
replace municip = "muelas de los caballeros" if municip =="donado"
replace municip = "almeida de sayago" if municip =="escuadro"
replace municip = "bermillo de sayago" if municip =="fadon"
replace municip = "figueruela de arriba" if municip =="figueruela de abajo"
replace municip = "peñausende" if municip =="figueruela de sayago"
replace municip = "san cebrian de castro" if municip =="fontanillas de castro"
replace municip = "fornillos de fermoselle" if municip =="formariz"
replace municip = "villar del buey" if municip =="fornillos de fermoselle"
replace municip = "corrales" if municip =="fuente el carnero"
replace municip = "bermillo de sayago" if municip =="ganame"

replace municip = "santibañez de vidriales" if regexm(municip, "granucillo")
replace municip = "manzanal de los infantes" if municip =="lanseros"
replace municip = "pereruela" if municip =="malillos"
replace municip = "fresno de sayago" if municip =="mogatar"
replace municip = "manzanal de los infantes" if municip =="otero de centenos"
replace municip = "palacios de sanabria" if municip =="otero de sanabria"
replace municip = "villafafila" if municip =="otero de sariegos"
replace municip = "corrales" if municip =="peleas de arriba"
replace municip = "bermillo de sayago" if municip =="piñuel"
replace municip = "morales del vino" if municip =="pontejos"
replace municip = "muelas del pan" if municip =="ricobayo"
replace municip = "manganeses de la lampreana" if municip =="riego del camino"
replace municip = "san justo" if municip =="san ciprian"
replace municip = "perdigon, el" if municip =="san marcial"
replace municip = "santibañez de tera" if municip =="sitrama de tera"
replace municip = "pereruela" if municip =="sobradillo de palomares"
replace municip = "pereruela" if municip =="sogo"
replace municip = "toro" if municip =="tagarabuena"
replace municip = "peñausende" if municip =="tamame"
replace municip = "perdigon, el" if municip =="tardobispo"
replace municip = "cobreros" if municip =="terroso"
replace municip = "bermillo de sayago" if municip =="torrefrades"
replace municip = "pereruela" if municip =="tuda, la"
replace municip = "villar del buey" if municip =="fornillos de fermoselle"
replace municip = "pereruela" if municip =="sogo"
replace municip = "santibañez de vidriales" if municip =="tardemezar"
replace municip = "puebla de sanabria" if municip =="ungilde"
replace municip = "cernadilla" if municip =="valdemerilla"
replace municip = "mombuey" if municip =="valparaiso"
replace municip = "frasno, el" if municip =="inoges"
replace municip = "pintanos, los" if municip =="undues - pintano" //
replace municip = "sestrica" if regexm(municip, "sestrica")
replace province = "alava" if municip =="añana"
replace municip = "poblets, els" if municip =="setla-mirarrosa y miraflor"
replace municip = "torre, la" if municip =="balcarda"
replace municip = "avila" if municip =="bernuy-salinero"
replace municip = "santa maria del cubillo" if municip =="blascocles"
replace municip = "diego del carpio" if municip =="diego alvaro"
replace municip = "arenas de san pedro" if municip =="parra de arenas, la"
replace municip = "vic" if municip =="senforas"
replace municip = "isar" if municip =="cañizar de argaño"
replace municip = "merindad de rio ubierna" if municip =="celadilla - sotobrin"
replace province = "soria" if municip =="cidones"
replace municip = "valle de sedano" if municip =="gredilla de sedano"
replace municip = "hormazas, las" if municip =="hormazas"
replace municip = "pedrosa de rio urbel" if municip =="pedrosa de rio - urbel"
replace municip = "pedrosa de rio urbel" if municip =="pedrosa del rio urbel"
replace municip = "valle de las navas" if municip =="robredo - temiño"
replace municip = "valle de santibañez" if municip =="santibañez - zarzaguda"
replace municip = "pedrosa de duero" if municip =="valcavado de roa"
**replace codprov = 46 if municip =="gatova"
**replace codprov = 1 if municip =="legutio"
replace municip = "rossell" if municip =="rosell"
replace municip = "villanueva de los infantes" if municip =="infantes"
replace municip = "ferrol" if municip =="ferrol, el"
replace municip = "ponteceso" if municip =="puente - ceso"
replace municip = "santiago de compostela" if municip =="santiago"
replace municip = "corca" if municip =="corça"
replace municip = "valor" if municip =="mecina-alfahar"
replace municip = "alpujarra de la sierra" if municip =="mecina-bombaron"
replace municip = "taha, la" if municip =="mecina-fondales"
replace municip = "morelabor" if municip =="moreda"
replace municip = "sigüenza" if regexm(municip, "del valle de sigüenza")
replace municip = "pintanos, los" if municip =="pintano"
replace municip = "pereruela" if municip =="sogo"
replace municip = "santibañez de vidriales" if municip =="rosinos de vidriales"
replace municip = "villar del buey" if municip =="fornillos de fermoselle"
replace municip = "almeida de sayago" if municip =="almeida"
replace municip = "atxondo" if municip =="valle de achondo"
replace municip = "cardoso de la sierra, el" if municip =="colmenar de la sierra"
replace municip = "tartanedo" if municip =="concha"
replace municip = "sacedon" if municip =="corcoles"
replace municip = "ledanca" if regexm(municip, "ledanca")
replace municip = "riba de saelices" if municip =="riba de saclices"
replace municip = "sigüenza" if municip =="riba de santiuste"
replace municip = "torremocha del campo" if municip =="torresaviñan, la"
replace municip = "campillo de ranas" if municip =="vereda, la"
replace municip = "jaca" if municip =="abena"
replace municip = "sabiñanigo" if municip =="arguisal"
replace municip = "jaca" if municip =="banaguas"
replace municip = "broto" if municip =="bergua - basaran"
replace municip = "graus" if municip =="juscu"
replace municip = "loarre" if municip =="sai samarcuello"
replace municip = "sabiñanigo" if municip =="secorun"
replace municip = "bedmar y garciez" if municip =="bedmar"
replace municip = "ruesta" if municip =="rucsta"
replace municip = "urries" if municip =="ruesta"
replace municip = "medina del campo" if municip =="gomeziarro"
replace municip = "pucol" if municip =="puçol"
replace municip = "puig de santa maria, el" if municip =="puig"
replace municip = "alas i cerc" if municip =="alas-serch"
replace municip = "oza-cesuras" if municip =="oza dos rios"
replace municip = "orgiva" if municip =="orjiva"
replace municip = "villa de otura" if municip =="otura"
replace municip = "pinar, el" if municip =="pinar"
replace municip = "taha, la" if municip =="taha"
replace municip = "anguita" if municip =="aguilar de anguita"
replace municip = "arbancon" if municip =="arbaucon"
replace municip = "leoz" if municip =="sansoain"
replace municip = "ucar" if municip =="Úcar"
replace municip = "carballeda de avia" if regexm(municip, "carballeda")
replace municip = "san xoan de rio" if municip =="rio"
**replace codprov = 31  if municip =="miranda de arga"
replace municip = "osorno la mayor" if municip =="osorno"
replace municip = "cervera de pisuerga" if municip =="perazancas"
replace municip = "toral de los vados" if regexm(municip, "villadecanes")
replace municip = "alt aneu" if municip =="alto aneu"
replace municip = "granyena de segarra" if municip =="grañena"
replace municip = "montella i martinet" if municip =="montella-martinet"
replace municip = "peramola" if municip =="trago"
replace municip = "cervera de pisuerga" if municip =="rabanal de las llantas"
replace municip = "pernia, la" if municip =="redondo areños"
replace municip = "valde-ucieza" if municip =="robladillo de ucieza"
replace municip = "cervera de pisuerga" if municip =="san martin de los herreros"
replace municip = "velilla del rio carrion" if municip =="valcovero"
replace municip = "cervera de pisuerga" if municip =="valsadornin"
replace municip = "arapiles" if municip =="arapilles"
replace municip = "selaya" if municip =="campillos"
replace municip = "rincon de la victoria" if municip =="benagalbon"
**replace codprov = 39 if municip =="selaya"
replace municip = "aguilar de campoo" if municip =="valdegama"
replace municip = "amusco" if municip =="valdespina"
replace municip = "riaza" if municip =="madriguera"
replace municip = "montejo de la vega de la serrezuela" if municip =="montejo de la vega de la serrez"
replace municip = "torreiglesias" if municip =="otones"
replace municip = "carabias" if municip =="pradales"
replace municip = "samboal" if municip =="samoal"
replace municip = "almazul" if municip =="aimazul"

replace municip = "berlanga de duero" if regexm(municip, "alalo")
replace municip = "cubo de la solana" if municip =="almarail"
replace municip = "baraona" if municip =="barahona"
replace municip = "vic" if municip =="vich"
replace municip = "cihuela" if municip =="ciruela"
replace municip = "cubilla" if municip =="cubilla de las peñas"
replace municip = "montejo de tiermes" if municip =="montejo de liceras"
replace municip = "poveda de soria, la" if municip =="poveda, la"
replace municip = "quiñoneria" if municip =="quiñoneria, la"
**replace codprov = 26 if municip =="santa engracia del jubera"
replace municip = "villar del rio" if regexm(municip, "villar del rio")
replace municip = "san pedro manrique" if municip =="villarijo"
replace municip = "vilaplana" if municip =="musara, la"
replace province = "guadalajara" if municip =="corduente"
**replace codprov = 19 if municip =="corduente"
replace municip = "pancrudo" if municip =="panerudo"
replace municip = "lagunilla del jubera" if municip =="lagunilla de jubera"
replace municip = "san roman de cameros" if municip =="santa maria en cameros"
replace municip = "fresno de cantespino" if municip =="cascajares"
replace municip = "arratzua-ubarrundia" if regexm(municip, "ubarrundia")
replace municip = "ibeas de juarros" if municip =="santa cruz de juarros"
replace municip = "velilla del rio carrion" if municip =="alba de los cardaños"
replace municip = "almarza" if municip =="san andres de soria"
replace municip = "castellbo" if municip =="villa y valle de castellbo"
replace municip = "vendrell" if municip =="san vicente de calders"
replace municip = "vall d'en bas, la" if municip =="san privat de bas"
replace municip = "almanza" if municip =="castromudarra"
replace municip = "poza de la sal" if municip =="castil de lences"
replace municip = "agreda" if municip =="fuentes de agreda"
replace municip = "pontenova, a" if municip =="villamea"
replace municip = "naut aran" if municip =="salardu"
replace municip = "villaquejida" if municip =="villafer"
replace municip = "sepulveda" if municip =="villaseca"
replace municip = "buenavista de valdavia" if municip =="renedo de valdavia"
replace municip = "salas de los infantes" if municip =="hoyuelos de la sierra"
replace municip = "arlanzon" if municip =="santovenia de oca"
replace municip = "villabrazaro" if municip =="san roman del valle"
replace municip = "alfoz de quintanadueñas" if municip =="villarmero"
replace municip = "isona i conca della" if municip =="sant roma de abella"
replace municip = "alfoz de quintanadueñas" if municip =="quintanadueñas"
replace municip = "pontils" if municip =="santa perpetua de gaia"
replace municip = "ribera d'ondara" if municip =="sant pere dels arquells"
replace municip = "villaornate y castro" if municip =="villaornate"
replace municip = "castrojeriz" if municip =="villasilos"
replace municip = "langa de duero" if municip =="valdanzo"
replace municip = "montblanc" if municip =="montblanch"
replace municip = "alfaraz de sayago" if municip =="viñuela de sayago"
replace municip = "merindad de rio ubierna" if municip =="villanueva de rio - ubierna"
replace municip = "medinaceli" if municip =="fuencaliente de medina"
replace municip = "melgar de fernamental" if municip =="san llorente de la vega"
replace municip = "sant marti de riucorb" if municip =="sant marti de rio corb"
replace municip = "alar del rey" if municip =="san quirce de riopisuerga"
replace municip = "montejo de tiermes" if municip =="valderroman"
replace municip = "burgo de osma-ciudad de osma" if municip =="valdenarros"
replace municip = "benitachell/poble nou de benitatxell, el" if municip =="benitachell"
replace municip = "torre de cabdella, la" if municip =="pobleta de bellvehi"
replace municip = "villadiego" if municip =="villanueva de puerta"
replace municip = "aldea del obispo" if municip =="aldea de trujillo"
replace municip = "santo domingo-caudilla" if municip =="val de santo domingo"
replace municip = "barco de valdeorras, o" if municip =="barco, el"
replace municip = "papiol, el" if municip =="paptol"
replace municip = "velilla del rio carrion" if municip =="velilla de guardo"
replace municip = "cervera de pisuerga" if municip =="quintanaluengos"
replace municip = "jaca" if municip =="abena"
replace municip = "astorga" if municip =="castrillo de los polvazares"
replace municip = "salce" if municip =="argusino" //
replace province = "segovia" if municip =="turegano"
**replace codprov = 40 if municip =="turegano"
replace municip = "flaca" if municip =="flassa"
replace province = "ourense" if municip =="carballeda de avia"
**replace codprov = 32 if municip =="carballeda de avia"
replace municip = "real sitio de san ildefonso" if municip =="san ildefonso o la granja"
replace municip = "castellote" if municip =="santolea"
replace municip = "pontenova, a" if municip =="a pontenova"
replace municip = "atzubia, l'" if municip =="adsubia"
replace municip = "burgo de osma-ciudad de osma" if municip =="olmeda, la"
replace municip = "linyola" if municip =="liñola"
replace municip = "benabarre" if municip =="caladranes"
replace municip = "villadiego" if municip =="viliusto"
replace municip = "san pedro manrique" if municip =="sarnago"
replace municip = "calamocha" if municip =="poyo del cid, el"
replace municip = "arcos de jalon" if municip =="montuenga de soria"
replace municip = "santiago de tormes" if municip =="horcajo de la ribera"
replace municip = "pereruela" if municip =="sogo"
replace municip = "bejis" if municip =="begis"
replace municip = "utrillas" if municip =="parras de martin, las"
replace municip = "begues" if municip =="begas"
replace municip = "ayllon" if municip =="santa maria de riaza"
replace municip = "cavia" if municip =="cabia"
replace municip = "estepar" if municip =="villagutierrez"
replace municip = "alfaraz de sayago" if municip =="alfaraz"
replace province = "lleida" if municip =="llado"
**replace codprov = 17 if municip =="llado"
replace province = "burgos" if municip =="melgar de fernamental"
**replace codprov = 9 if municip =="melgar de fernamental"
replace municip = "peñacerrada-urizaharra" if municip =="penacerrada"
replace municip = "anguita" if municip =="auguita"
replace municip = "urduña/orduña" if municip =="orduña"
replace municip = "venta de baños" if municip =="baños de cerrato"
replace municip = "gomara" if municip =="ledesma de soria"
replace municip = "josa i tuixen" if municip =="josa del cadi"
replace municip = "sanxenxo" if municip =="sangenjo"
replace municip = "chañe" if municip =="chane"
replace province = "palencia" if municip =="alar del rey"
**replace codprov = 34 if municip =="alar del rey"
replace municip = "cerdanyola del valles" if municip =="sardanyola"
replace municip = "villamañan" if municip =="villace"
replace municip = "villar del rio" if municip =="villar de rio"
replace municip = "santiago-pontones" if municip =="pontones"
**replace codprov = 42 if municip =="cidones"
replace municip = "josa i tuixen" if municip =="josa-tuixent"
replace municip = "gandia" if municip =="benipeixcar"
**replace codprov = 22 if municip =="viacamp y litera"
replace municip = "iruecha" if municip =="iruccha"
replace municip = "arcos de jalon" if municip =="iruecha"
replace municip = "alcolea del pinar" if municip =="garbajosa"
replace municip = "valls de valira, les" if municip =="arcabell"
replace municip = "borges blanques, les" if municip =="borjas blancas"
replace municip = "vallbona de les monges" if municip =="valbona de las monjas"
replace municip = "villarcayo de merindad de castilla la vieja" if municip =="villarcayo"
replace municip = "hondarribia" if municip =="fuenterrabia"
replace municip = "arratzu" if municip =="arrazua de vizcaya"
replace municip = "campo de san pedro" if municip =="fuentemizarra"
replace municip = "muxia" if municip =="mugia"
replace municip = "cornella del terri" if municip =="san andres del terri"
replace municip = "ribera d'ondara" if municip =="sant antoli y vilanova"
replace municip = "ribera d'urgellet" if municip =="ribera de urgellet"
replace municip = "arcos de jalon" if municip =="layna"
replace municip = "san sebastian" if municip =="alza"
replace municip = "fuente de san esteban, la" if municip =="santa olalla de yeltes"
replace municip = "figols i alinya" if municip =="figols de orgaña"
replace municip = "tremp" if municip =="figols de temp"
replace municip = "xeraco" if municip =="jaraco"
replace municip = "oza-cesuras" if municip =="cesuras"
replace municip = "figols i alinya" if municip =="figols y aliña"
replace province = "tarragona" if municip =="cornudella de montsant"
**replace codprov = 43 if municip =="cornudella de montsant"
replace municip = "san pedro manrique" if municip =="villarijo"
replace municip = "santiago-pontones" if municip =="santiago de la espada"
replace municip = "merindad de rio ubierna" if municip =="gredilla la polera"
replace municip = "valde-ucieza" if municip =="miñanes"
replace municip = "aguilar de campoo" if municip =="valoria de aguilar"
replace municip = "baeza" if municip =="yedra"
replace municip = "villarluengo" if municip =="villaluengo"
replace municip = "bellver de cerdanya" if municip =="bellver"
replace municip = "torrefeta i florejacs" if municip =="florejachs"
replace municip = "cornella del terri" if municip =="cornella de terri"
replace municip = "herrera de pisuerga" if municip =="ventosa de pisuerga"
replace municip = "gerona" if municip =="palau - sacosta"
replace municip = "les" if municip =="lles"
replace municip = "sada" if municip =="sada de sangüesa"
replace municip = "lerma" if municip =="revilla - cabriada"
replace municip = "vall de cardos" if municip =="estahon"
replace municip = "montagut i oix" if municip =="montagut"
replace municip = "loma de ucieza" if municip =="villota del duque"
replace municip = "coca" if municip =="villagonzalo de coca"
replace municip = "sepulveda" if municip =="villar de sobrepeña"
replace municip = "alpicat" if municip =="villanueva de alpicat"
replace municip = "premia de dalt" if municip =="san pedro de premia"
replace municip = "castell-platja d'aro" if municip =="castillo de aro"
replace municip = "sepulveda" if municip =="castrillo de sepulveda"
replace municip = "cervera de pisuerga" if municip =="herreruela de castilleria"
replace municip = "vall d'en bas, la" if municip =="san esteban de bas"
replace municip = "aldeadavila de la ribera" if municip =="aldeavilla de la ribera"
replace municip = "sena de luna" if municip =="lancara de luna"
replace municip = "vilassar de dalt" if municip =="san gines de vilasar"
replace municip = "soto del real" if municip =="chozas de la sierra"
replace municip = "alfoz de quintanadueñas" if municip =="marmellar de arriba"
replace municip = "zarza de granadilla" if municip =="granadilla"
replace municip = "villarino de los aires" if municip =="villariño"
replace municip = "montferrer i castellbo" if municip =="castellbo"
replace municip = "rueda de la sierra" if municip =="cillas"
replace municip = "bermillo de sayago" if municip =="villamor de cadozos"
replace municip = "rupit i pruit" if municip =="san juan de fabregas"
replace municip = "vielha e mijaran" if municip =="vilach"
replace municip = "sant joanet" if municip =="san juan de enova"
replace municip = "oncala" if municip =="san andres de san pedro"
replace municip = "nava de la asuncion" if municip =="moraleja de coca"
replace municip = "belorado" if municip =="quintanaloranco"
replace municip = "villarino de los aires" if municip =="villarino"
replace municip = "marganell" if municip =="santa cecilia de montserrat"
replace municip = "santibañez de vidriales" if municip =="pozuelo de vidriales"
replace municip = "avila" if municip =="narrillos de san leonardo"
replace municip = "san miguel del cinca" if municip =="santa lecina"
replace municip = "san pedro manrique" if municip =="fuentebella"
replace municip = "belmonte de gracian" if municip =="belmonte de calatayud"
replace municip = "piles, las" if municip =="pilas, las"
replace municip = "medina de rioseco" if municip =="palacios de campos"
replace municip = "tarragona" if municip =="irlas, las"
replace municip = "torremocha del campo" if municip =="torrecuadrada de los valles"
replace municip = "santiago del tormes" if municip =="santiago de tormes"
replace municip = "vall d'en bas, la" if municip =="vall de bas"
replace municip = "revilla del campo" if municip =="quintanalara"
replace municip = "bellmunt del priorat" if municip =="bellmunt de ciurana"
replace municip = "vilassar de mar" if municip =="villasar"
replace municip = "asparrena" if municip =="araya"
replace municip = "villarroya" if regexm(municip, "villarroya")
replace municip = "carabias" if regexm(municip, "ciruelos de pradales")
replace municip = "mojonera, la" if regexm(municip, "mojonerafelix")
replace municip = "granja de moreruela" if regexm(municip, "moreruela")
replace municip = "xinzo de limia" if regexm(municip, "chaus de limia")
replace municip = "motilla del palancar" if regexm(municip, "motilla")
replace municip = "aizarnazabal" if regexm(municip, "aizarna")
replace municip = "san millan/donemiliaga" if regexm(municip, "ordoñana")
replace municip = "sayalonga" if regexm(municip, "corumbela sayalonga")
replace municip = "zoma, la" if regexm(municip, "la zoma")
replace municip = "villatorres" if regexm(municip, "villargordo")
replace municip = "faura" if regexm(municip, "faura de los valles")
replace municip = "santander" if regexm(municip, "peñacastillo")
replace municip = "cabezon de liebana" if regexm(municip, "cambarco")
replace municip = "manzanares de rioja" if regexm(municip, "manzanares de la")
replace municip = "fuentearmegil" if municip =="fuencaliente del burgo"
replace municip = "zaragoza" if municip =="san juan de mozarifar"
replace municip = "palmaces de jadraque" if municip =="palmares de jadraque"
replace municip = "zaragoza" if municip =="san juan de mizarifar"
replace municip = "nava, la" if municip =="la nava"
replace municip = "teruel" if municip =="san blas"
replace municip = "maya, la" if municip =="la maya"
replace municip = "torrelles de llobregat" if municip =="torrellas de llobregat"
replace municip = "Villatuelda " if regexm(municip, "villaruel")
replace municip = "valle de valdelucio" if regexm(municip, "solanas de valdelucio")
replace municip = "samos" if regexm(municip, "louzara")
replace municip = "valle del zalabi" if regexm(municip, "valle del zalabi")
replace municip = "polinya de xuquer" if regexm(municip, "poliña del jucar")
replace municip = "aranda de duero" if regexm(municip, "aranda del duero")
replace municip = "jarandilla de la vera" if regexm(municip, "jaramilla")
replace municip = "polinya de xuquer" if regexm(municip, "poliñar de jucar")
replace municip = "mondariz" if regexm(municip, "riofrio mondariz")
replace municip = "ampudia" if regexm(municip, "ampudia")
replace municip = "santa maria del cubillo" if regexm(municip, "blascoele")
replace municip = "algamitas" if regexm(municip, "algamita")
replace municip = "bell-lloc d'urgell" if regexm(municip, "belloch")
replace municip = "bellvei" if regexm(municip, "bellivi")
replace municip = "aller" if regexm(municip, "casomera aller")
replace municip = "carbajosa de la sagrada" if regexm(municip, "cabajosa")
replace municip = "herradon de pinares" if regexm(municip, "herradon del pinar")
replace municip = "herradon de pinares" if regexm(municip, "herradon de pinar")
replace municip = "san cebrian de campos" if municip =="cebrian de campos"
replace municip = "enciso" if municip =="navalsaz la"
replace municip = "enciso" if municip =="navalsaz"
replace municip = "gavet de la conca" if municip =="sant serni gavet de la conca"
replace municip = "revilla del campo" if municip =="revilla de campos"
replace municip = "garrovillas de alconetar" if municip =="barrovillas"
replace municip = "valle de valdelucio" if municip =="fuencaliente de lucio"
replace municip = "caparroso" if municip =="baparroso"
replace municip = "torrecaballeros" if municip =="torre de cacalleros"
replace municip = "nava de sotrobal" if municip =="nava de sotobral"
replace municip = "breto" if municip =="breto de la rivera"
replace municip = "bascuñana" if municip =="san pedro del monte"
replace municip = "navaescurial" if municip =="navaescorial"
replace municip = "aldeanueva de la vera" if municip =="aldeanueva"
replace municip = "cuenca" if municip =="valdecabras"
replace municip = "porzuna" if municip =="trincheto"
replace municip = "fonfria" if municip =="arcillera"
replace municip = "laguna de cameros" if municip =="cameros la"
replace municip = "zafra de zancara" if municip =="zafra de jarama"
replace municip = "ametlla del valles, l'" if municip =="la atmella del valles"
replace municip = "llanos de tormes, los" if municip =="hermosillo"
replace municip = "valdemoro-sierra" if municip =="valdemoro de la sierra"
replace municip = "cuenca" if municip =="colliguilla"
replace municip = "renieblas" if municip =="ventosilla de san juan"
replace municip = "campos del paraiso" if municip =="valparaiso de abajo"
replace municip = "santa engracia del jubera" if municip =="san martin la"
replace municip = "mirueña de los infanzones" if regexm(municip, "mirueño")
replace municip = "valle de las navas" if regexm(municip, "valle de las navas")
replace municip = "zaorejas" if regexm(municip, "huerta pelayo")
replace municip = "mahide" if regexm(municip, "torres de aliste")
replace municip = "cerezo de arriba" if regexm(municip, "cerezo de arriba")
replace municip = "socovos" if regexm(municip, "socovos")
replace municip = "genoves, el" if regexm(municip, "genoves")
replace municip = "jaraiz de la vera" if regexm(municip, "jaraiz de la vera")
replace municip = "santa maria la real de nieva" if regexm(municip, "laguna rodrigo")
replace municip = "torre d'en domenec, la" if regexm(municip, "torre endomenench")
replace municip = "merindad de valdeporres" if regexm(municip, "valdeporres")
replace municip = "ajamil de cameros" if regexm(municip, "torremuña")
replace municip = "aguas candidas" if regexm(municip, "aguas candidas")
replace municip = "villanueva del rebollar" if regexm(municip, "villanueva de rebollar")
replace municip = "valdemoro-sierra" if regexm(municip, "valdemoro de la sierra")
replace municip = "palmaces de jadraque" if regexm(municip, "palmares de jadraque")
replace municip = "vigo" if regexm(municip, "bouzas")
replace municip = "arroyomolinos" if regexm(municip, "arroyomolino de montanchez")
replace municip = "villar del rio" if municip =="valduerteles"
replace municip = "granollers" if municip =="granollers de la plana"
replace municip = "villas de la ventosa" if municip =="villarejo del espartal"
replace municip = "morata de tajuña" if municip =="morales del tajuña"
replace municip = "valencia" if municip =="zafranar"
replace municip = "fiñana" if municip =="finana"
replace municip = "ulzama" if municip =="elzaburu"
replace municip = "ulzama" if municip =="eltzaburu "
replace municip = "orxeta" if municip =="orcheta"
replace municip = "veiga, a" if municip =="borrax"
replace municip = "colmenar de oreja" if municip =="comenar de oreja"
replace municip = "valdehuncar" if municip =="huncar"
replace municip = "carpio de azaba" if municip =="carpio de araba"
replace municip = "borrenes" if regexm(municip, "borrenes")
replace municip = "bisaurri" if regexm(municip, "bisaurri")
replace municip = "palencia" if municip =="paredes de monte"
replace municip = "vall d'uixo, la" if municip =="vall de uxo"
replace municip = "almarza" if municip =="espejo de tera"
replace municip = "amorebieta-etxano" if municip =="amorabieta"
replace municip = "navahermosa" if municip =="navahermoso"
replace municip = "san justo" if municip =="rabano de sanabria"

replace municip = "castropol" if regexm(municip, "castropol")
replace municip = "amorebieta-etxano" if regexm(municip, "amorebieta")
replace municip = "atapuerca" if regexm(municip, "atapuerca")
replace municip = "albanchez de magina" if regexm(municip, "magina")
replace municip = "huetor de santillan" if regexm(municip, "huetorsantillan")
replace municip = "huetor de santillan" if regexm(municip, "huetor santillan")
***** MEJORAS 6/10 11.34 V.3
replace municip = "monteagudo de las vicarias" if regexm(municip, "valtueña")
replace municip = "riocabado" if regexm(municip, "rio cavado")
replace municip = "allariz" if regexm(municip, "san mamede allariz")
replace municip = "santervas de la vega" if regexm(municip, "villarrobejo")
replace municip = "barruelo de santullan" if regexm(municip, "villabellaco")
replace municip = "soto y amio" if regexm(municip, "garaño")
replace municip = "arroyomolinos" if regexm(municip, "arroyo molino de montanchez")
replace municip = "arroyomolinos" if regexm(municip, "arroyomolinos de montanchez")

replace municip = "villalon de campos" if regexm(municip, "villalor")

replace municip = "aldealengua de pedraza" if municip =="aldealuenga de pedraza"
replace municip = "carmenes" if municip =="valverdin"
replace municip = "allariz" if municip =="san mamedallariz"
replace municip = "villaverde de guareña" if municip =="villaverde la guareña"
replace municip = "merindad de valdivielso" if municip =="condado de valdivieso"
replace municip = "merindad de valdivielso" if municip =="condado de valdivielso"
replace municip = "soto y amio" if municip =="garaño soto y amio"
replace municip = "villarcayo de merindad de castilla la vieja" if municip =="villarias"
replace municip = "villalgordo del jucar" if municip =="villalgordo"
replace municip = "castellon" if municip =="castrellon"
replace municip = "mombeltran" if municip =="villa de molbeltran"
replace municip = "mombeltran" if municip =="villa de mombeltran"
replace municip = "boal" if municip =="rozadas"
replace municip = "villablino" if municip =="llamas de la laciana"
replace municip = "taboada" if municip =="bouzoa"
replace municip = "molina de aragon" if municip =="novella"
replace municip = "sigüenza" if municip =="carabias sigüenza"
replace municip = "hermandad de campoo de suso" if municip =="argueso"
replace municip = "garrafe de torio" if municip =="pedrun de torio"
replace municip = "guardia, la" if municip =="a guarda"
replace municip = "nalec" if municip =="nalech"
replace municip = "jijona/xixona" if municip =="jijona"
replace municip = "vilallonga de ter" if municip =="vilallonga de ter gironda"
replace province = "gerona" if municip =="vilallonga de ter gironda"
replace municip = "vilajuiga" if municip =="vilajuega"
replace municip = "abadiño" if municip =="abadiano"
replace municip = "magaz de cepeda" if municip =="porqueros"
replace municip = "requena" if municip =="villar de olmos"
replace municip = "riba-roja de turia" if municip =="ribaroja"
replace municip = "valle de mena" if municip =="orrantia"
replace municip = "abadiano" if municip =="abandiano"
replace municip = "santiago de compostela" if municip =="carballal"
replace municip = "tortosa" if municip =="regues"
replace municip = "viana del bollo" if municip =="covelomelon"
replace municip = "viana del bollo" if municip =="covelo"
replace municip = "carballiño, o" if municip =="loureiro"
**
replace municip = "borriana/burriana" if municip =="burriana"
replace municip = "xativa" if municip =="jativa"
replace municip = "arce/artzi" if municip =="arce(nagore)"
replace province ="navarra"  if municip =="arce/artzi"
replace municip = "albocasser" if municip =="albocacer"
replace municip = "donostia/san sebastian" if municip =="san sebastian"
replace municip = "burjassot" if municip =="burjasot"
replace municip = "torrent" if municip =="torrente"
replace municip = "almassora" if municip =="almazora"
replace municip = "tavernes de la valldigna" if municip =="tabernes de valldigna"
replace municip = "elche/elx" if municip =="elche"
replace municip = "mao-mahon" if municip =="mahon"
replace municip = "sant feliu de guixols" if municip =="san feliu de guixols"
replace province = "la rioja" if municip =="sant feliu de guixols"
replace province = "gerona" if municip =="sant feliu de guixols"
replace municip = "vilanova i la geltru" if municip =="villanueva y geltru"
**
replace municip = "montserrat" if municip =="monserrat"
replace municip = "terrassa" if municip =="tarrasa"
replace municip = "quart de poblet" if municip =="cuart de poblet"
replace municip = "grado, el" if municip =="el grado"
replace municip = "mogente/moixent" if municip =="mogente"
replace municip = "pobla de vallbona, la" if municip =="puebla de vallbona"
replace municip = "garriga, la" if municip =="la garriga"
replace municip = "pobla de benifassa, la" if municip =="puebla de benifasar"
replace municip = "bellreguard" if municip =="bellreguart"
replace municip = "vitoria-gasteiz" if municip =="vitoria"
replace municip = "alcasser" if municip =="alcacer"
replace municip = "fontanars dels alforins" if municip =="fontanares"
replace municip = "figueres" if municip =="figueras"
replace municip = "coves de vinroma, les" if municip =="cuevas de vinroma"
replace municip = "sant sadurni d'anoia" if municip =="san sadurni de noya"
replace municip = "sant celoni" if municip =="san celoni"
replace municip = "benifaio" if municip =="benifayo"
replace municip = "caldes de montbui" if municip =="caldas de montbuy"
replace municip = "solana, la" if municip =="la solana"
replace province = "madrid" if municip =="solana, la"
replace municip = "jana, la" if municip =="la jana"
replace municip = "sant quirze de besora" if municip =="san quirico de besora"
replace municip = "alboraia/alboraya" if municip =="alboraya"
replace municip = "sueras/suera" if municip =="sueras"
replace municip = "real" if municip =="real de montroy"
replace municip = "caldes de malavella" if municip =="caldas de malavella"
replace municip = "almussafes" if municip =="almusafes"
replace municip = "chinchilla de monte-aragon" if municip =="chinchilla"
replace municip = "santa coloma de farners" if municip =="santa coloma de farnes"
replace municip = "sant joan despi" if municip =="san juan despi"
replace municip = "fresneda, la" if municip =="la fresneda"
replace municip = "robla, la" if municip =="la robla"
replace municip = "alcantera de xuquer" if municip =="alcantara de jucar"
replace municip = "sagunto/sagunt" if municip =="sagunto"
replace municip = "aielo de malferit" if municip =="ayelo de malferit"
replace municip = "aldaia" if municip =="aldaya"
replace municip = "rossello" if municip =="rosello"
replace municip = "albalat dels tarongers" if municip =="albalat de taronchers"
replace municip = "langreo" if municip =="sama de langreo"
replace municip = "useras/useres, les" if municip =="useras"
replace municip = "vidreres" if municip =="vidreras"
replace municip = "alcampell" if municip =="alcampel"
replace municip = "olvan" if municip =="olban"
replace municip = "naquera/naquera" if municip =="naquera"
replace municip = "monovar/monover" if municip =="monovar"
replace municip = "peñalba" if municip =="penalba"
replace municip = "serratella, la" if municip =="sarratella"
replace municip = "sant joan de les abadesses" if municip =="san juan de las abadesal"
replace municip = "avinyo" if municip =="aviño"
replace municip = "maials" if municip =="mayals"
replace municip = "santpedor" if municip =="sampedor"
replace municip = "villavieja del lozoya" if municip =="villavieja"
replace municip = "escala, l'" if municip =="la escala"
replace municip = "adrada, la" if municip =="adrada(la)"
replace municip = "adrada, la" if municip =="la adrada"
replace municip = "olmos, los" if municip =="los olmos"
replace municip = "fondo de les neus, el/hondon de las nieves" if municip =="hondon de las nieves"
replace municip = "centelles" if municip =="centellas"
replace municip = "avinyonet del penedes" if municip =="avinyonet"
replace municip = "palau-solita i plegamans" if municip =="palau de plegamans"
replace municip = "aielo de rugat" if municip =="ayelo de rugat"
replace municip = "ribesalbes" if municip =="ribesalves"
replace municip = "pinos, el/pinoso" if municip =="pinoso"
replace municip = "vilamartin de valdeorras" if municip =="villamartin de valdeorras"
replace municip = "getxo" if municip =="guetxo"
replace municip = "fuente obejuna" if municip =="fuente-ovejuna"
replace municip = "fuente obejuna" if municip =="fuente ovejuna"
replace municip = "alamo, el" if municip =="el alamo"
replace municip = "peniscola/peñiscola" if municip =="peñiscola"
replace municip = "novele/novetle" if municip =="novele"
replace municip = "riba-roja de turia" if municip =="ribarroja"
replace municip = "salzadella, la" if municip =="salsadella"
replace municip = "vilamarxant" if municip =="villamarchante"
replace municip = "corbera" if municip =="corbera de alcira"
replace municip = "almacelles" if municip =="almacellas"
replace municip = "llucena/lucena del cid" if municip =="lucena del cid"
replace municip = "boñar" if municip =="bonar"
replace municip = "jonquera, la" if municip =="la junquera"
replace municip = "piloña" if municip =="infiesto"
replace municip = "isona i conca della" if municip =="figuerola de orcau"
replace municip = "huercal-overa" if regexm(municip, "huercal overa")

***** FIN MEJORAS 6/10 11.34
* ñ
replace municip = lower(municip)
replace municip = "vielha e mijaran" if municip =="viella-mitg-aran"
replace municip=trim(municip)
replace municip=strrtrim(municip)
replace municip=stritrim(municip)
************************************
**# end of new part
************************************
gen victim1 = 1
sort municip archive
* important variables
by municip archive: egen victim_archive = sum(victim1) 
by municip : egen victim_mun = sum(victim1) 

sort municip male
by municip male: egen victim_male = sum(victim1) if male == 1
bysort municip (victim_male): replace victim_male = victim_male[1] if missing(victim_male) //fill for the entire group


sort municip archive male
by municip archive male: egen victim_archive_male = sum(victim1) if male == 1
bysort municip archive (victim_archive_male): replace victim_archive_male = victim_archive_male[1] if missing(victim_archive_male)
save "$dir\$Output_data\purge\victims_archive_temp.dta",replace
use "$dir\$Output_data\purge\victims_archive_temp.dta", clear

duplicates drop municip archive, force

*438.604------42.349
*363.232------41.116
*362.168------39.902
*360.518------39.854
*361.000------38.715 (9 oct 2023)
*361.000------38.642 (17 jan 2024)
drop victim1 male year*

rename municip municipality
gen str municip = municipality //this is necessary bc the variable is defined as strL (long string), and then the merge is not possible
drop municipality gender


save "$dir\$Output_data\purge\victims_archive_v2.dta",replace

*****************************************************************************
**# Retrieve province (codprov) when possible (when municipality name is unique)
*****************************************************************************
use "$dir\$Output_data\purge\victims_archive_v2.dta", clear
gen idvic_prov = _n


*matchit idvic_prov municip using "$Data\INE_codes\INE_municip.dta", idusing(id_ine) txtusing(municip) override

reclink2 municip using "$Data\INE_codes\INE_municip.dta", idmaster(idvic_prov) idusing(id_ine) gen(match) minscore(0.9602)
sort match
* matched = 17714 (exact = 14614), unmatched = 20928. 17/jan/2024
replace municip = Umunicip if _merge==3
drop idvic_prov match CODAUTO CMUN DC _merge id_ine Umunicip

*

replace province = lower(province)
replace codprov =4 if province =="almeria" & codprov ==.
replace codprov=11 if province =="cadiz" & codprov ==.
replace codprov=14 if province =="cordoba" & codprov ==.
replace codprov=18 if province=="granada" & codprov ==.
replace codprov=21 if province =="huelva" & codprov ==.
replace codprov=23 if province =="jaen" & codprov ==.
replace codprov=29 if province =="malaga" & codprov ==.
replace codprov=41 if province =="sevilla" & codprov ==.
replace codprov=22 if province =="huesca" & codprov ==.
replace codprov=44 if province =="teruel" & codprov ==.
replace codprov=50 if province =="zaragoza" & codprov ==.
replace codprov=33 if province =="asturias" & codprov ==. 
replace codprov=39 if province =="cantabria" & codprov ==.
replace codprov=5 if province =="avila" & codprov ==.
replace codprov=9 if province =="burgos" & codprov ==.
replace codprov=24 if province =="leon" & codprov ==.
replace codprov=34 if province =="palencia" & codprov ==.
replace codprov=37 if province =="salamanca" & codprov ==.
replace codprov=40 if province =="segovia" & codprov ==.
replace codprov=42 if province =="soria" & codprov ==.
replace codprov=47 if province =="valladolid" & codprov ==.
replace codprov=49 if province =="zamora" & codprov ==.
replace codprov=2 if province =="albacete" & codprov ==.
replace codprov=13 if province =="ciudad real" & codprov ==.
replace codprov=16 if province =="cuenca" & codprov ==.
replace codprov=19 if province =="guadalajara" & codprov ==.
replace codprov=45 if province =="toledo" & codprov ==.
replace codprov=8 if province =="barcelona" & codprov ==.
replace codprov=17 if province =="gerona" & codprov ==.
replace codprov=25 if province =="lleida" & codprov ==.
replace codprov=43 if province =="tarragona" & codprov ==.
replace codprov=3 if province =="alicante" & codprov ==.
replace codprov= 12 if province =="castellon" & codprov ==.
replace codprov=46 if province =="valencia" & codprov ==.
replace codprov=6 if province =="badajoz" & codprov ==.
replace codprov=10 if province =="caceres" & codprov ==.
replace codprov=15 if province =="coruna" & codprov ==.
replace codprov=27 if province =="lugo" & codprov ==.
replace codprov=32 if province =="ourense" & codprov ==.
replace codprov=36 if province =="pontevedra" & codprov ==.
replace codprov=28 if province =="madrid" & codprov ==.
replace codprov=30 if province =="murcia" & codprov ==.
replace codprov=31 if province =="navarra" & codprov ==.
replace codprov=1 if province =="alava" & codprov ==.
replace codprov=48 if province =="vizcaya" & codprov ==.
replace codprov=20 if province =="guipuzcoa" & codprov ==.
replace codprov=26 if province =="la rioja" & codprov ==.
gen idvictim1=_n
order archive municip victim_archive victim_mun victim_male
sort municip
drop type id profession
save "$dir\$Output_data\purge\victims_archive.dta",replace 
use  "$dir\$Output_data\purge\victims_archive.dta", clear
***********************************
**# Create dataset with number of victims per municipality
***********************************
use  "$dir\$Output_data\purge\victims_archive.dta", clear
drop idvictim1 
drop victim_archive archive 
format %15s municip 
drop if municip =="1951"
*keep if male == 1 // 
duplicates drop municip province, force
*27.980
gen idvictim=_n
rename municip municipality
gen str municip = municipality //this is necessary bc the variable is defined as strL (long string), and then the merge is not possible
drop municipality
save "$dir\$Output_data\purge\victims_mun.dta",replace
use "$dir\$Output_data\purge\victims_mun.dta", clear

