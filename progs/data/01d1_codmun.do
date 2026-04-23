import excel "$Data\INE_codes\codmun.xlsx", sheet("dic19") cellrange(A2:E8133) firstrow clear

rename NOMBRE municip
rename CPRO codprov
rename CMUN codmun

destring codprov, replace
destring codmun, replace
drop DC CODAUTO
replace municip = lower(municip)
replace municip = strtrim(municip)
replace municip = subinstr(municip, "á", "a",.) 
replace municip = subinstr(municip, "é", "e",.) 
replace municip = subinstr(municip, "í", "i",.) 
replace municip = subinstr(municip, "ó", "o",.) 
replace municip = subinstr(municip, "ú", "u",.)

replace municip = subinstr(municip, "Á", "a",.) 
replace municip = subinstr(municip, "É", "e",.) 
gen id_using =_n
save "$Data\codmun_lower.dta", replace

