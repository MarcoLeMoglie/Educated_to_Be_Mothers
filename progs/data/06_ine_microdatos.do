* * * * * * * * * * * * * * * * * * * * * * * * * 
**# Census 2011 (%)
* * * * * * * * * * * * * * * * * * * * * * * * * 
*

forvalues i = 1/4{
infix CPRO 1-2 CMUN 3-5 IDHUECO 6-15 NORDEN 16-19 FACTOR 20-33 MNAC 34-35 ANAC 36-39 EDAD 40-42 SEXO 43-43 NACI 44-46 CPAISN 47-49 CPRON 50-51 CMUNN 52-54 ANORES 55-58 ANOM 59-62 ANOC 63-66 ANOE 67-70 CLPAIS 71-73 CLPRO 74-75 CLMUNP 76-78 RES_ANTERIOR 79-79 CPAISUNANO 80-82 CPROUNANO 83-84 CMUNANO 85-87 RES_UNANO 88-88 CPAISDANO 89-91 CPRODANO 92-93 CMUNDANO 94-96 RES_DANO 97-97 SEG_VIV 98-98 SEG_PAIS 99-101 SEG_PROV 102-103 SEG_MUN 104-106 SEG_NOCHES 107-109 SEG_DISP 110-110 ECIVIL 111-111 ESCOLAR 112-112 ESREAL 113-114 TESTUD 115-115 TAREA1 116-116 TAREA2 117-117 TAREA3 118-118 TAREA4 119-119 HIJOS 120-120 NHIJOS 121-122 RELA 123-123 JORNADA 124-124 CNO 125-126 CNAE 127-128 SITU 129-129 CSE 130-134 ESCUR1 135-136 ESCUR2 137-138 ESCUR3 139-140 LTRABA 141-141 PAISTRABA 142-144 PROTRABA 145-146 MUNTRABA 147-149 CODTRABA 150-154 NVIAJE 155-155 MDESP1 156-156 MDESP2 157-157 TDESP 158-158 TENEN 159-159 CALE 160-160 ASEO 161-161 BADUCH 162-162 INTERNET 163-163 AGUACOR 164-164 SUT 165-167 NHAB 168-169 PLANTAS 170-171 PLANTAB 172-172 TIPOEDIF 173-173 ANOCONS 174-175 ESTADO 176-176 ASCENSOR 177-177 ACCESIB 178-178 GARAJE 179-179 PLAZAS 180-180 GAS 181-181 TELEF 182-182 ACAL 183-183 RESID 184-184 FAMILIA 185-185 PAD_NORDEN 186-187 MAD_NORDEN 188-189 CON_NORDEN 190-191 OPA_NORDEN 192-193 TIPOPER 194-194 NUCLEO 195-196 NMIEM 197-198 NFAM 199-199 NNUC 200-200 NGENER 201-202 ESTHOG 203-204 TIPOHOG 205-206 NOCU 207-208 NPARAIN 209-210 NPFAM 211-212 NPNUC 213-214 HM5 215-216 H0515 217-218 H1624 219-220 H2534 221-222 H3564 223-224 H6584 225-226 H85M 227-228 HESPHOG 229-230 MESPHOG 231-232 HEXTHOG 233-234 MEXTHOG 235-236 COMBINAC 237-237 EDADPAD 238-239 PAISNACPAD 240-242 NACIPAD 243-243 ECIVPAD 244-244 ESTUPAD 245-245 SITUPAD 246-246 SITPPAD 247-247 EDADMAD 248-249 PAISNACMAD 250-252 NACIMAD 253-253 ECIVMAD 254-254 ESTUMAD 255-255 SITUMAD 256-256 SITPMAD 257-257 EDADCON 258-259 NACCON 260-260 NACICON 261-261 ECIVCON 262-262 ESTUCON 263-263 SITUCON 264-264 SITPCON 265-265 TIPONUC 266-266 TAMNUC 267-268 NHIJO 269-270 NHIJOC 271-272 FAMNUM 273-274 TIPOPARECIV 275-276 TIPOPARSEX 277-278 DIFEDAD 279-280 using "$Data\\INE_microdatos\\censo2011\\Microdatos_personas_bloque`i'\\MicrodatosCP_NV_per_BLOQUE`i'_3VAR.txt", clear

    save "$Data\\INE_microdatos\\censo2011\\por_provincias\\microdatos`i'.dta", replace
}
use "$Data\INE_microdatos\censo2011\por_provincias\microdatos1.dta", clear
forvalues i = 2/4 {    
    append using "$Data\\INE_microdatos\\censo2011\\por_provincias\\microdatos`i'.dta"
}
label var CPRO "Código de provincia"
label var CMUN "Código o tamaño de municipio"
label var IDHUECO "Identificador de hueco"
label var NORDEN "Número final de la persona dentro del hueco"
label var FACTOR "Factor de elevación de la persona"
label var MNAC "Mes de nacimiento"
label var ANAC "Año de nacimiento"
label var EDAD "Edad"
label var SEXO "Sexo"
label var NACI "Código país de nacionalidad"
label var CPAISN "Código país de nacimiento"
label var CPRON "Código provincia de nacimiento"
label var CMUNN "Código o tamaño municipio de nacimiento"
label var ANORES "Año de llegada a la vivienda"
label var ANOM "Año de llegada al municipio"
label var ANOC "Año de llegada a la Comunidad Autónoma"
label var ANOE "Año de llegada a España"
label var CLPAIS "Código país de residencia anterior"
label var CLPRO "Código provincia de residencia anterior"
label var CLMUNP "Código o tamaño municipio de residencia anterior"
label var RES_ANTERIOR "Municipio de residencia actual y Municipio de residencia anterior"
label var CPAISUNANO "Código país de residencia hace 1 año"
label var CPROUNANO "Código provincia de residencia hace 1 año"
label var CMUNANO "Código o tamaño municipio de residencia hace 1 año"
label var RES_UNANO "Municipio de residencia actual y Municipio de residencia hace 1 año"
label var CPAISDANO "Código país de residencia hace 10 años"
label var CPRODANO "Código provincia de residencia hace 10 años"
label var CMUNDANO "Código o tamaño municipio de residencia hace 10 años"
label var RES_DANO "Municipio de residencia actual y Municipio de residencia hace 10 años"
label var SEG_VIV "Pasa más de 14 noches en segundo municipio"
label var SEG_PAIS "Código de país donde pasa más de 14 noches"
label var SEG_PROV "Código de provincia donde pasa más de 14 noches"
label var SEG_MUN "Código o tamaño de municipio donde pasa más de 14 noches"
label var SEG_NOCHES "Número de noches"
label var SEG_DISP "Disponibilidad vivienda en segundo municipio"
label var ECIVIL "Estado civil"
label var ESCOLAR "Acude a un centro escolar"
label var ESREAL "Nivel de estudios completados"
label var TESTUD "Tipo de estudios realizados"
label var TAREA1 "Cuidar a un menor de 15 años"
label var TAREA2 "Cuidar a una persona con problemas de salud"
label var TAREA3 "Tareas benéficas o voluntariado social"
label var TAREA4 "Encargarse de la mayor parte de las tareas domésticas de su hogar"
label var HIJOS "Indicador de si la mujer ha tenido hijos"
label var NHIJOS "Número de hijos de la mujer"
label var RELA "Relación con la actividad"
label var JORNADA "Tipo de jornada de trabajo"
label var CNO "Código de ocupación a 2 dígitos"
label var CNAE "Código de actividad económica a 2 dígitos"
label var SITU "Situación profesional"
label var CSE "Condición socioeconómica"
label var ESCUR1 "Estudios en curso"
label var LTRABA "Lugar de trabajo o estudio"
label var PAISTRABA "País de trabajo o estudio"
label var PROTRABA "Provincia de trabajo o estudio"
label var MUNTRABA "Municipio de trabajo o estudio"
label var CODTRABA "Código postal de trabajo o estudio"
label var NVIAJE "Número de viajes diarios"
label var MDESP1 "Medio de desplazamiento"
label var TDESP "Tiempo de desplazamiento"
label var TENEN "Régimen de tenencia"
label var CALE "Calefacción"
label var ASEO "Cuarto de aseo con inodoro"
label var BADUCH "Baño o ducha"
label var INTERNET "Acceso a Internet"
label var AGUACOR "Sistema de suministro de agua"
label var SUT "Superficie útil"
label var NHAB "Número de habitaciones"
label var PLANTAS "Número de plantas sobre rasante"
label var PLANTAB "Número de plantas bajo rasante"
label var TIPOEDIF "Tipo de edificio"
label var ANOCONS "Año de construcción"
label var ESTADO "Estado del edificio"
label var ASCENSOR "Ascensor en el edificio"
label var ACCESIB "Accesibilidad del edificio"
label var GARAJE "Garaje"
label var PLAZAS "Número de plazas de garaje"
label var GAS "Gas"
label var TELEF "Tendido telefónico"
label var ACAL "Agua caliente central"
label var RESID "Evacuación de aguas residuales"
label var FAMILIA "Número de familia dentro del hogar"
label var PAD_NORDEN "NORDEN del padre"
label var MAD_NORDEN "NORDEN de la madre"
label var CON_NORDEN "NORDEN del cónyuge o pareja"
label var OPA_NORDEN "NORDEN de otro pariente"
label var TIPOPER "Condición dentro del núcleo"
label var NUCLEO "Número de núcleo dentro del hogar"
label var NMIEM "Tamaño del hogar"
label var NFAM "Número de familias en el hogar"
label var NNUC "Número de núcleos en el hogar"
label var NGENER "Número de generaciones en el hogar"
label var ESTHOG "Estructura del hogar"
label var TIPOHOG "Tipo de hogar"
label var NOCU "Número de ocupados del hogar"
label var NPARAIN "Número de parados o inactivos del hogar"
label var NPFAM "Número de personas en familia"
label var NPNUC "Número de personas que pertenecen a algún núcleo"
label var HM5 "Número de personas de 0 a 4 años en el hogar"
label var H0515 "Número de personas de 5 a 15 años en el hogar"
label var H1624 "Número de personas de 16 a 24 años en el hogar"
label var H2534 "Número de personas de 25 a 34 años en el hogar"
label var H3564 "Número de personas de 35 a 64 años en el hogar"
label var H6584 "Número de personas de 65 a 84 años en el hogar"
label var H85M "Número de personas del hogar de 85 años o más en el hogar"
label var HESPHOG "Hombres españoles en el hogar"
label var MESPHOG "Mujeres españolas en el hogar"
label var HEXTHOG "Hombres extranjeros en el hogar"
label var MEXTHOG "Mujeres extranjeras en el hogar"
label var COMBINAC "Combinación de nacionalidades en el hogar"
label var EDADPAD "Edad grupos quinquenales del padre"
label var PAISNACPAD "País de nacimiento del padre"
label var NACIPAD "Nacionalidad del padre"
label var ECIVPAD "Estado civil del padre"
label var ESTUPAD "Nivel de estudios del padre (en grados)"
label var SITUPAD "Relación con la actividad del padre"
label var SITPPAD "Situación profesional del padre"
label var EDADMAD "Edad grupos quinquenales de la madre"
label var PAISNACMAD "País de nacimiento de la madre"
label var NACIMAD "Nacionalidad de la madre"
label var ECIVMAD "Estado civil de la madre"
label var ESTUMAD "Nivel de estudios de la madre (en grados)"
label var SITUMAD "Relación con la actividad de la madre"
label var SITPMAD "Situación profesional de la madre"
label var EDADCON "Edad grupos quinquenales del cónyuge"
label var NACCON "País de nacimiento del cónyuge"
label var NACICON "Nacionalidad del cónyuge"
label var ECIVCON "Estado civil del cónyuge"
label var ESTUCON "Nivel de estudios del cónyuge (en grados)"
label var SITUCON "Relación con la actividad del cónyuge"
label var SITPCON "Situación profesional del cónyuge"
label var TIPONUC "Tipo de núcleo"
label var TAMNUC "Tamaño del núcleo"
label var NHIJO "Número de hijos"
label var NHIJOC "Número de hijos comunes del núcleo"
label var FAMNUM "Indicador de familia numerosa"
label var TIPOPARECIV "Tipo de pareja (de hecho o de derecho)"
label var TIPOPARSEX "Tipo de pareja (mismo sexo, distinto sexo)"
label var DIFEDAD "Diferencia de edad entre hombre y mujer del núcleo"

save "$Data\INE_microdatos\censo2011\por_provincias\censo2011_provincias.dta", replace

****************************************
**# Clean dataset before merge
****************************************
use "$Output_data/dataset_PROVINCElevel.dta", clear
keep province codprov codauto pop_19* popshare_agegroup1_* pop_agegroup1_* pop_male_*  pop_19* pop_19* popmen_* popwomen_* pop_female_* popmen_agegroup1_* popwomen_agegroup1_* distance total_area sh_area_front logdistance sch_pop_male1933 - sancionados 
duplicates drop
save "$Output_data/dataset_PROVINCElevel_tmp.dta", replace


****************************************
**# Merge 
****************************************
use "$Data\INE_microdatos\censo2011\por_provincias\censo2011_provincias.dta", clear
rename CPRON codprov  

merge m:1 codprov using "$Output_data/dataset_PROVINCElevel_tmp.dta"
drop _merge

erase "$Output_data/dataset_PROVINCElevel_tmp.dta" 
save "$Output_data/dataset_microdata2011.dta", replace
use "$Output_data/dataset_microdata2011.dta", clear



* * * * * * * * * * * * * * * * * * * * * * * * * 
**# Census 2001 (5%)
* * * * * * * * * * * * * * * * * * * * * * * * * 
forvalues i = 1/50 {
    local num: display %02.0f `i'  // Format the number with two digits (01, 02, ..., 50)
    
    infix CPRO 1-2 CMUN 3-5 NSS 6-10 HUECO 11-15 NORDF 16-19 MNAC 20-21 ANAC 22-25 EDAD 26-28 SEXO 29-29 NACI 30-32 CPRON 33-34 CMUNN 35-37 ECIVIL 38-38 PARENPP 39-40 ESREAL 41-42 TESTUD 43-44 AÑOE 45-48 AÑOC 49-52 AÑOM 53-56 CLPRO 57-58 CLMUNP 59-61 RES10 62-62 CMUN10 63-65 CPROV10 66-67 CONLEN 68-68 SITU1 69-70 SITU2 71-72 SITU3 73-74 SITU 75-76 LUGTE 77-77 CLMUNI 78-80 CLPROV 81-82 NVIAJE 83-83 MDESP1 84-85 MDESP2 86-87 TDESP 88-88 ESCUR1 89-90 ESCUR2 91-92 ESCUR3 93-94 COCUP 95-96 SITP 97-97 COACTI 98-99 CSE 100-101 TTRAB 102-103 USO1F 104-104 CVIVIF 105-105 CCOLF 106-107 AÑORES 108-111 TENEN 112-112 RUIDEX 113-113 CONTA 114-114 LIMP 115-115 COM 116-116 VERDE 117-117 DELIN 118-118 SERVI 119-119 REF 120-120 CALE 121-121 COMBUS 122-122 ALTURA 123-124 NHAB 125-126 SUT 127-129 SVIV 130-130 LOCSV 131-131 CMUNSV 132-134 CPROSV 135-136 DIAÑO 137-139 VEHIC 140-140 PLANTAS 141-142 PLANTAB 143-143 TIPOED 144-144 CONST 145-145 AÑO 146-149 ESTADO 150-150 PROP 151-151 ACCESIB 152-152 AGUA 153-153 RESID 154-154 PORTE 155-155 GARAJE 156-156 PLAZAS 157-159 GAS 160-160 TELEF 161-161 ACAL 162-162 FAM 163-164 PAD 165-166 MAD 167-168 CON 169-170 CNUCF 171-171 TIHI 172-172 FCONANC 173-173 FCONADU 174-174 CONPARHIJ 175-175 HOM 176-177 MUJ 178-179 PP 180-181 NUCF 182-183 NMIEM 184-187 NFAM 188-189 NNUCH 190-191 NGENER 192-192 EDADGR 193-195 EDADGA 196-198 ESTHOG 199-200 ESTHOG91 201-202 TIPOHOG 203-204 NOCU 205-207 NPARA 208-210 NPFAM 211-212 NNUCF1 213-214 NNUCF2 215-216 NNUCF3 217-218 NNUCF4 219-220 NTOTHIJ 221-222 HM15 223-225 MM15 226-228 H15 229-231 M15 232-234 H1524 235-237 M1524 238-240 H2534 241-243 M2534 244-246 H3564 247-249 M3564 250-252 H6584 253-255 M6584 256-258 H85 259-261 M85 262-264 EXTOS 265-267 EXTAS 268-270 ESLES 271-273 ESLAS 274-276 SEXOPP 277-277 ANACPP 278-281 EDADPP 282-284 ECIVILPP 285-285 NACIPP 286-288 CPRONPP 289-290 CMUNNPP 291-293 ESREALPP 294-295 TESTUDPP 296-297 CONLENPP 298-298 SITUPP 299-300 COCUPP 301-302 SITPP 303-303 COACTIPP 304-305 CSEPP 306-307 ANACPAD 308-311 EDADPAD 312-314 ECIVILPAD 315-315 NACIPAD 316-318 CPRONPAD 319-320 CMUNNPAD 321-323 ESREALPAD 324-325 TESTUDPAD 326-327 CONLENPAD 328-328 SITUPAD 329-330 COCUPPAD 331-332 SITPPAD 333-333 COACTIPAD 334-335 CSEPAD 336-337 ANACMAD 338-341 EDADMAD 342-344 ECIVILMAD 345-345 NACIMAD 346-348 CPRONMAD 349-350 CMUNNMAD 351-353 ESREALMAD 354-355 TESTUDMAD 356-357 CONLENMAD 358-358 SITUMAD 359-360 COCUPMAD 361-362 SITPMAD 363-363 COACTIMAD 364-365 CSEMAD 366-367 SEXOCON 368-368 ANACCON 369-372 EDADCON 373-375 ECIVILCON 376-376 NACICON 377-379 CPRONCON 380-381 CMUNNCON 382-384 ESREALCON 385-386 TESTUDCON 387-388 CONLENCON 389-389 SITUCON 390-391 COCUPCON 392-393 SITPCON 394-394 COACTICON 395-396 CSECON 397-398 TNUCF 399-399 TAMNUCF 400-401 NHIJO 402-403 NHIJNUC04 404-405 NHIJNUC59 406-407 NHIJNUC1014 408-409 NHIJNUC15 410-411 NHIJNUC1519 412-413 NHIJNUC2024 414-415 NHIJNUC2529 416-417 NHIJNUC30 418-419 FAMNUM 420-420 OCNUC 421-422 PANUC 423-424 TIPOPARECIV 425-425 TIPOPARSEX 426-426 COMBNACIN 427-427 using "$Data\\INE_microdatos\\censo2001\\por_provincias\\p`num'ph_cen01\\P`num'FASEMUES.txt", clear
    save "$Data\\INE_microdatos\\censo2001\\por_provincias\\p`num'ph_cen01\\P`num'FASEMUES.dta", replace
}



use "$Data\INE_microdatos\censo2001\por_provincias\p01ph_cen01\P01FASEMUES.dta", clear
forvalues i = 2/50 {
    local num: display %02.0f `i'  // Format the number with two digits (01, 02, ..., 50)
    
    append using "$Data\\INE_microdatos\\censo2001\\por_provincias\\p`num'ph_cen01\\P`num'FASEMUES.dta"
}
label var CMUN "Código o tamaño de municipio"
label var NSS "Número Secuencial de Sección"
label var HUECO "Número de hueco"
label var NORDF "Número final de la persona dentro del hueco"
label var MNAC "Mes de nacimiento "
label var ANAC "Año de nacimiento "
label var EDAD "Edad"
label var SEXO "Sexo"
label var NACI "Código país de nacionalidad"
label var CPRON "Código provincia de nacimiento"
label var CMUNN "Código o tamaño municipio (o país) de nacimiento"
label var ECIVIL "Estado civil"
label var PARENPP "Relación de parentesco con la persona de referencia normalizada"
label var ESREAL "Nivel de estudios"
label var TESTUD "Tipo de estudios realizados"
label var AÑOE "Año de llegada a España"
label var AÑOC "Año de llegada a la Comunidad Autónoma"
label var AÑOM "Año de llegada al municipio"
label var CLPRO "Código provincia anterior de residencia"
label var CLMUNP "Código o tamaño municipio (o país) anterior de residencia"
label var RES10 "Residencia hace 10 años"
label var CMUN10 "Código o tamaño municipio (o país) hace 10 años"
label var CPROV10 "Código provincia hace 10 años"
label var CONLEN "Conocimiento de la lengua propia "
label var SITU1 "Situación la semana pasada (respuesta primera)"
label var SITU2 "Situación la semana pasada (segunda)"
label var SITU3 "Situación la semana pasada (tercera)"
label var SITU "Situación preferente"
label var LUGTE "Lugar de trabajo o estudio"
label var CLMUNI "Código o tamaño municipio (o país) de trabajo o estudio"
label var CLPROV "Código provincia de trabajo o estudio"
label var NVIAJE "Nº de viajes diarios"
label var MDESP1 "Medio de desplazamiento"
label var MDESP2 "nan"
label var TDESP "Tiempo de desplazamiento"
label var ESCUR1 "Estudios en curso"
label var ESCUR2 "nan"
label var ESCUR3 "nan"
label var COCUP "Código de ocupación"
label var SITP "Situación profesional"
label var COACTI "Código de actividad"
label var CSE "Condición socioeconómica"
label var TTRAB "Tiempo usual de trabajo"
label var USO1F "Vivienda, alojamiento o colectivo"
label var CVIVIF "Clase de vivienda "
label var CCOLF "Clase de colectivo "
label var AÑORES "Año llegada a la vivienda"
label var TENEN "Régimen de tenencia"
label var RUIDEX "Ruidos exteriores"
label var CONTA "Contaminación"
label var LIMP "Poca limpieza en las calles"
label var COM "Malas comunicaciones"
label var VERDE "Pocas zonas verdes"
label var DELIN "Delincuencia en la zona"
label var SERVI "Falta de servicios"
label var REF "Refrigeración"
label var CALE "Calefacción "
label var COMBUS "Combustible para calefacción"
label var ALTURA "Altura (en nº de plantas) en la que está la vivienda"
label var NHAB "Nº de habitaciones"
label var SUT "Superficie útil"
label var SVIV "Disponibilidad segunda vivienda"
label var LOCSV "Localización segunda vivienda"
label var CMUNSV "Código o tamaño municipio (o país) 2ª vivienda"
label var CPROSV "Código provincia 2ª vivienda"
label var DIAÑO "Nº de dias al año de uso de la 2ª vivienda"
label var VEHIC "Disp. vehiculos a motor (no motos)"
label var PLANTAS "Número de plantas sobre rasante"
label var PLANTAB "Número de plantas bajo rasante"
label var TIPOED "Tipo de edificio"
label var CONST "Año de construcción "
label var AÑO "Año exacto"
label var ESTADO "Estado del edificio"
label var PROP "Clase de propietario"
label var ACCESIB "Accesibilidad del edificio"
label var AGUA "Agua corriente"
label var RESID "Evacuación de aguas residuales"
label var PORTE "Portería"
label var GARAJE "Garaje"
label var PLAZAS "Número de plazas de garaje"
label var GAS "Gas"
label var TELEF "Tendido telefónico"
label var ACAL "Agua caliente central"
label var FAM "Número de familia dentro del hogar"
label var PAD "NORDF del padre"
label var MAD "NORDF de la madre"
label var CON "NORDF del cónyuge o pareja"
label var CNUCF "Condición dentro del núcleo"
label var TIHI "Tipo de hijo"
label var FCONANC "Forma de convivencia en personas de 65 años ó más"
label var FCONADU "Forma de convivencia en personas de 16 a 64 años "
label var CONPARHIJ "Convivencia con pareja e hijos"
label var HOM "NORDF del hombre del núcleo"
label var MUJ "NORDF de la mujer del núcleo"
label var PP "NORDF de la persona de referencia"
label var NUCF "Número de núcleo dentro del hogar"
label var NMIEM "Tamaño del hogar (o número de residentes en colectivos)"
label var NFAM "Número de familias en el hogar"
label var NNUCH "Número de núcleos en el hogar"
label var NGENER "Número de generaciones en el hogar"
label var EDADGR "Edad mínima de la generación más reciente"
label var EDADGA "Edad máxima de la generación más antigua"
label var ESTHOG "Estructura del hogar (definición nueva)"
label var ESTHOG91 "Estructura del hogar (definición de 1991)"
label var TIPOHOG "Tipo de hogar"
label var NOCU "Número de ocupados del hogar"
label var NPARA "Número de parados del hogar"
label var NPFAM "Número de personas en familia"
label var NNUCF1 "Número de personas en núcleo tipo 1"
label var NNUCF2 "Número de personas en núcleo tipo 2"
label var NNUCF3 "Número de personas en núcleo tipo 3"
label var NNUCF4 "Número de personas en núcleo tipo 4"
label var NTOTHIJ "Número total de hijos(para cada persona del hogar) en el  hogar"
label var HM15 "Hombres menores de 15"
label var MM15 "Mujeres menores de 15"
label var H15 "Hombres de 15 años"
label var M15 "Mujeres de 15 años"
label var H1524 "Hombres de 15 a 24 años"
label var M1524 "Mujeres de 15 a 24 años"
label var H2534 "Hombres de 25 a 34 años"
label var M2534 "Mujeres de 25 a 34 años"
label var H3564 "Hombres de 35 a 64 años"
label var M3564 "Mujeres de 35 a 64 años"
label var H6584 "Hombres de 65 a 84 años"
label var M6584 "Mujeres de 65 a 84 años"
label var H85 "Hombres de 85 ó más"
label var M85 "Mujeres de 85 o más"
label var EXTOS "Extranjeros"
label var EXTAS "Extranjeras"
label var ESLES "Españoles"
label var ESLAS "Españolas"
label var SEXOPP "Sexo"
label var ANACPP "Año de nacimiento"
label var EDADPP "Edad"
label var ECIVILPP "Estado civil"
label var NACIPP "País de nacionalidad"
label var CPRONPP "Código provincia de nacimiento"
label var CMUNNPP "Código o tamaño municipio (o país) de nacimiento"
label var ESREALPP "Nivel de estudios"
label var TESTUDPP "Tipo de estudios realizados"
label var CONLENPP "Conocimiento de la lengua propia"
label var SITUPP "Situación preferente"
label var COCUPP "Código de ocupación"
label var SITPP "Situación profesional"
label var COACTIPP "Código de actividad"
label var CSEPP "Condición socioeconómica"
label var ANACPAD "Año de nacimiento "
label var EDADPAD "Edad "
label var ECIVILPAD "Estado civil "
label var NACIPAD "País de nacionalidad"
label var CPRONPAD "Código provincia de nacimiento "
label var CMUNNPAD "Código o tamaño municipio (o país) de nacimiento "
label var ESREALPAD "Nivel de estudios "
label var TESTUDPAD "Tipo de estudios realizados"
label var CONLENPAD "Conocimiento de la lengua propia "
label var SITUPAD "Situación preferente "
label var COCUPPAD "Código de ocupación "
label var SITPPAD "Situación profesional"
label var COACTIPAD "Código de actividad "
label var CSEPAD "Condición socioeconómica "
label var ANACMAD "Año de nacimiento "
label var EDADMAD "Edad "
label var ECIVILMAD "Estado civil "
label var NACIMAD "País de nacionalidad"
label var CPRONMAD "Código provincia de nacimiento "
label var CMUNNMAD "Código o tamaño municipio (o país) de nacimiento "
label var ESREALMAD "Nivel de estudios "
label var TESTUDMAD "Tipo de estudios realizados"
label var CONLENMAD "Conocimiento de la lengua propia "
label var SITUMAD "Situación preferente "
label var COCUPMAD "Código de ocupación "
label var SITPMAD "Situación profesional "
label var COACTIMAD "Código de actividad "
label var CSEMAD "Condición socioeconómica "
label var SEXOCON "Sexo"
label var ANACCON "Año de nacimiento"
label var EDADCON "Edad"
label var ECIVILCON "Estado civil"
label var NACICON "País de nacionalidad"
label var CPRONCON "Código provincia de nacimiento"
label var CMUNNCON "Código o tamaño municipio (o país) de nacimiento"
label var ESREALCON "Nivel de estudios"
label var TESTUDCON "Tipo de estudios realizados"
label var CONLENCON "Conocimiento de la lengua propia"
label var SITUCON "Situación preferente"
label var COCUPCON "Código de ocupación"
label var SITPCON "Situación profesional"
label var COACTICON "Código de actividad"
label var CSECON "Condición socioeconómica"
label var TNUCF "Tipo de núcleo"
label var TAMNUCF "Tamaño del núcleo"
label var NHIJO "Número de hijos"
label var NHIJNUC04 "Número de hijos entre 0 y 4 años"
label var NHIJNUC59 "Número de hijos entre 5 y 9 años"
label var NHIJNUC1014 "Número de hijos entre 10 y 14 años"
label var NHIJNUC15 "Número de hijos de 15 años"
label var NHIJNUC1519 "Número de hijos entre 15 y 19 años"
label var NHIJNUC2024 "Número de hijos entre 20 y 24 años"
label var NHIJNUC2529 "Número de hijos entre 25 y 29 años"
label var NHIJNUC30 "Número de hijos de 30 y más años"
label var FAMNUM "Indicador de familia numerosa"
label var OCNUC "Número de ocupados en el núcleo"
label var PANUC "Número de parados en el núcleo"
label var TIPOPARECIV "Tipo de pareja(de hecho o de derecho)"
label var TIPOPARSEX "Tipo de pareja(mismo sexo, distinto sexo) "
label var COMBNACIN "Combinación de nacionalidades en el núcleo"


save "$Data\INE_microdatos\censo2001\por_provincias\censo2001_provincias.dta", replace



****************************************
**# Clean dataset before merge
****************************************
use "$Output_data/dataset_PROVINCElevel.dta", clear
keep province codprov codauto pop_19* popshare_agegroup1_* pop_agegroup1_* pop_male_*  pop_19* pop_19* popmen_* popwomen_* pop_female_* popmen_agegroup1_* popwomen_agegroup1_* distance total_area sh_area_front logdistance sch_pop_male1933 - sancionados 
duplicates drop
save "$Output_data/dataset_PROVINCElevel_tmp.dta", replace


****************************************
**# Merge 
****************************************
use "$Data\INE_microdatos\censo2001\por_provincias\censo2001_provincias.dta", clear
rename CPRON codprov //CPRO == prov de residencia, CPRON= prov nacimiento

merge m:1 codprov using "$Output_data/dataset_PROVINCElevel_tmp.dta"
drop _merge

erase "$Output_data/dataset_PROVINCElevel_tmp.dta" 
save "$Output_data/dataset_microdata2001.dta", replace



* * * * * * * * * * * * * * * * * * * * * * * * * 
**# Census 1991 (10%)
* * * * * * * * * * * * * * * * * * * * * * * * * 
forvalues i = 1/50 {
    local num: display %02.0f `i'  // Format the number with two digits (01, 02, ..., 50)
    
    infix TIPO 1 PROV 2-3 MUN 4-6 DC 7 SEXO 8 MES 9-10 FECHA 11-13 NACION 14 PAISN 15-17 ANNOEX 18-19 ECIV 20 NACINB 21 MUNACIN 22-24 PRONACIN 25-26 RESI90B 27 MUN90 28-30 PROV90 31-32 RESI86B 33 MUN86 34-36 PROV86 37-38 RESI81B 39 MUN81 40-42 PROV81 43-44 ANNO 45-46 PROCEB 47 MUN10 48-50 PROV10 51-52 ESCUR 53-54 ESREAL 55-56 HIJOS 57 BODA 58-59 RELACT1 60-61 RELACT2 62-63 RELACT3 64-65 PROF 66-67 SITU 68 ACT 69-70 EDAD 71-73 TAMU 74-75 COM 76-77 COMN 78-79 COM90 80-81 COM86 82-83 COM81 84-85 COM10 86-87 ACTD 88 DMAT 89-90 CSE 91-92 FE 93-99 using "$Data\\INE_microdatos\\censo1991\\por_provincias\\p`num'mper_cen91\\P`num'MPER.txt", clear
    save "$Data\\INE_microdatos\\censo1991\\por_provincias\\p`num'mper_cen91\\P`num'MPER.dta", replace
}



use "$Data\INE_microdatos\censo1991\por_provincias\p01mper_cen91\P01MPER.dta", clear
forvalues i = 2/50 {
    local num: display %02.0f `i'  // Format the number with two digits (01, 02, ..., 50)
    
    append using "$Data\\INE_microdatos\\censo1991\\por_provincias\\p`num'mper_cen91\\P`num'MPER.dta"
}
label var TIPO "Tipo de registro"
label var PROV "Provincia"
label var MUN "Municipio"
label var DC "Dígito Control"
label var SEXO "Sexo"
label var MES "Mes de nacimiento"
label var FECHA "Año de nacimiento"
label var NACION "Nacionalidad"
label var PAISN "País de nacionalidad"
label var ANNOEX "Año última llegada a España (extranjeros y apátridas)"
label var ECIV "Estado civil"
label var NACINB "Lugar de nacimiento"
label var MUNACIN "Municipio o país de nacimiento"
label var PRONACIN "Provincia de nacimiento"
label var RESI90B "Lugar de residencia a 1-3-90"
label var MUN90 "Municipio o país residencia a 1-3-90"
label var PROV90 "Provincia residencia a 1-3-90"
label var RESI86B "Lugar de residencia a 1-4-86"
label var MUN86 "Municipio o país residencia a 1-4-86"
label var PROV86 "Provincia residencia a 1-4-86"
label var RESI81B "Lugar de residencia a 1-3-81"
label var MUN81 "Municipio o país residencia a 1-3-81"
label var PROV81 "Provincia residencia a 1-3-81"
label var ANNO "Año llegada al municipio de residencia"
label var PROCEB "Lugar de procedencia"
label var MUN10 "Municipio o país de procedencia"
label var PROV10 "Provincia de procedencia"
label var ESCUR "Estudios en curso"
label var ESREAL "Estudios realizados"
label var HIJOS "Número de hijos"
label var BODA "Año de la boda"
label var RELACT1 "Relación con la actividad 1"
label var RELACT2 "Relación con la actividad 2"
label var RELACT3 "Relación con la actividad 3"
label var PROF "Profesión"
label var SITU "Situación profesional"
label var ACT "Rama de actividad económica"
label var EDAD "Edad"
label var TAMU "Tamaño del municipio de residencia"
label var COM "Comarca municipio de residencia"
label var COMN "Comarca municipio de nacimiento"
label var COM90 "Comarca municipio residencia a 1-3-90"
label var COM86 "Comarca municipio residencia a 1-4-86"
label var COM81 "Comarca municipio residencia a 1-3-81"
label var COM10 "Comarca municipio de procedencia"
label var ACTD "Rama de actividad económica, reducida"
label var DMAT "Duración de matrimonio"
label var CSE "Condición socioeconómica"
label var FE "Factor elevación"

save "$Data\INE_microdatos\censo1991\por_provincias\censo1991_provincias.dta", replace

use "$Data\INE_microdatos\censo1991\por_provincias\censo1991_provincias.dta", clear


use "$Data\INE_microdatos\censo2011\por_provincias\censo2011_provincias.dta", clear

****************************************
**# Clean dataset before merge
****************************************
use "$Output_data/dataset_PROVINCElevel.dta", clear
keep province codprov codauto pop_19* popshare_agegroup1_* pop_agegroup1_* pop_male_*  pop_19* pop_19* popmen_* popwomen_* pop_female_* popmen_agegroup1_* popwomen_agegroup1_* distance total_area sh_area_front logdistance sch_pop_male1933 - sancionados 
duplicates drop
save "$Output_data/dataset_PROVINCElevel_tmp.dta", replace


****************************************
**# Merge 
****************************************
use "$Data\INE_microdatos\censo1991\por_provincias\censo1991_provincias.dta", clear
rename PRONACIN codprov //PRONACIN = prov nacimiento, PROV=prov residencia

merge m:1 codprov using "$Output_data/dataset_PROVINCElevel_tmp.dta"
drop _merge
*drop if codprov==.
erase "$Output_data/dataset_PROVINCElevel_tmp.dta" 
save "$Output_data/dataset_microdata1991.dta", replace




* * * * * * * * * * * * * * * * * * * * * * * * * 
**# Census 1991 (2%) Nacional
* * * * * * * * * * * * * * * * * * * * * * * * *
infix TIPO 1 PROV 2-3 MUN 4-6 DC 7 SEXO 8 MES 9-10 FECHA 11-13 NACION 14 PAISN 15-17 ANNOEX 18-19 ECIV 20 NACINB 21 MUNACIN 22-24 PRONACIN 25-26 RESI90B 27 MUN90 28-30 PROV90 31-32 RESI86B 33 MUN86 34-36 PROV86 37-38 RESI81B 39 MUN81 40-42 PROV81 43-44 ANNO 45-46 PROCEB 47 MUN10 48-50 PROV10 51-52 ESCUR 53-54 ESREAL 55-56 HIJOS 57 BODA 58-59 RELACT1 60-61 RELACT2 62-63 RELACT3 64-65 PROF 66-67 SITU 68 ACT 69-70 EDAD 71-73 TAMU 74-75 COM 76-77 COMN 78-79 COM90 80-81 COM86 82-83 COM81 84-85 COM10 86-87 ACTD 88 DMAT 89-90 CSE 91-92 FE 93-99 using "$Data\INE_microdatos\censo1991\nacional\cen91_per_2\MUES02.PERSONAS.txt", clear
    save "$Output_data\dataset_microdata1991_2pc.dta", replace
	
	
	
	
	
	
	
	
	
	
	
use "$Output_data/dataset_microdata1991.dta", clear
use "$Output_data/dataset_microdata2001.dta", clear
use "$Output_data/dataset_microdata2011.dta", clear