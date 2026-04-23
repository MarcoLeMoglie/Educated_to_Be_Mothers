version 17.0
clear all
set more off

capture log close
do "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/Marco/DO/code_2026_04_10/code/00_globals.do"
log using "$rep_logs/rebuild_balancing_table_only.log", replace text

use "$rep_data/final_macro_panel_analysis.dta", clear

gen popsharewomen_agegroup1 = ///
    (popsharewomen_agegroup1_1940 + popsharewomen_agegroup2_1940) * 100
gen popsharemen_agegroup1 = ///
    (popsharemen_agegroup1_1940 + popsharemen_agegroup2_1940) * 100
gen sum1 = popsharewomen_agegroup1
gen sum2 = popsharemen_agegroup1
gen interaction = post * sum1
gen interaction2 = post * sum2

preserve
egen idtype = group(type)
gen teachers_pc=(teachers/pop_1930)*10000
keep if year==1940

local i=1
drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
drop sum* interact*
gen sum`i'=popsharewomen_agegroup`i'
gen sum2`i'=popsharemen_agegroup`i'

gen interaction=sum`i'
gen interaction2=sum2`i'

egen total1940=rowtotal(pop_agegroup3_1940 pop_agegroup4_1940 pop_agegroup5_1940)
gen popsharewomen2_agegroup3_1940=pop_agegroup3_1940/total1940
gen popsharewomen2_agegroup4_1940=pop_agegroup4_1940/total1940
gen popsharewomen2_agegroup5_1940=pop_agegroup5_1940/total1940

rename popsharewomen2_agegroup3_1940 popsharewomen_ag3_1940
rename popsharewomen2_agegroup4_1940 popsharewomen_ag4_1940
rename popsharewomen2_agegroup5_1940 popsharewomen_ag5_1940

gen pop=popsharewomen_ag3_1940 + popsharewomen_ag4_1940 + popsharewomen_ag5_1940

file open myfile using "$rep_main/table_balancing.tex", write replace
file write myfile "\begin{tabular}{l c c }\hline\hline  \\[-0.3cm] & (1) & (2)  \\ [0.1cm] & {Coefficient} & {SD}  \\ [0.1cm] \hline \\ " _n

local varlist =  "teachers_pc relig_com_total1930 professed_total1930 novice_total1930 lay_total1930 share_republicanos1931 share_socialistas1931 share_monarquicos1931 share_comunistas1931 adictos nat_school_total42 teachersprimary_total42 enrolled_students42  sh_area_front popsharewomen_ag3_1940 popsharewomen_ag4_1940 popsharewomen_ag5_1940 popwomen_agegroup3_1940 popwomen_agegroup4_1940 popwomen_agegroup5_1940 deaths_male_cwar deaths_female_cwar"
foreach var in `varlist'{
if "`var'"== "teachers_pc"{
            local name = "Purged teachers"
        }
        else if "`var'"== "relig_com_total1930"{
            local name = "Religious communities (1930)"
        }
        else if "`var'"== "professed_total1930"{
            local name = "Professed (pc, 1930)"
        }
        else if "`var'"== "novice_total1930"{
            local name = "Novices (pc,1930)"
        }
        else if "`var'"== "lay_total1930"{
            local name = "Lay (pc, 1930)"
        }
        else if "`var'"== "share_republicanos1931"{
            local name = "Republicans (\%, local 1931)"
        }
        else if "`var'"== "share_socialistas1931"{
            local name = "Socialists (\%, local 1931)"
        }
        else if "`var'"== "share_monarquicos1931"{
            local name = "Monarchic (\%, local 1931)"
        }
        else if "`var'"== "share_comunistas1931"{
            local name = "Communists (\%, local 1931)"
        }
        else if "`var'"== "adictos"{
            local name = "Pro regime (\%, 1947)"
        }
        else if "`var'"== "sh_area_front"{
            local name = "Area in the war front (\%)"
        }
        else if "`var'"== "nat_school_total42"{
            local name = "National schools (1000s,1942)"
        }
        else if "`var'"== "teachersprimary_total42"{
            local name = "Primary teachers (1000s,1942)"
        }
        else if "`var'"== "enrolled_students42"{
            local name = "Enrolled students (1000s,1942)"
        }
        else if "`var'"== "popsharewomen_ag3_1940"{
            local name = "Women aged 15-24 (\%, 1940) "
        }
        else if "`var'"== "popsharewomen_ag4_1940"{
            local name = "Women aged 25-34 (\%, 1940) "
        }
        else if "`var'"== "popsharewomen_ag5_1940"{
            local name = "Women aged 35-44 (\%, 1940) "
        }
        else if "`var'"== "popwomen_agegroup3_1940"{
            local name = "Women aged 15-24 (1940) "
        }
        else if "`var'"== "popwomen_agegroup4_1940"{
            local name = "Women aged 25-34 (1940) "
        }
        else if "`var'"== "popwomen_agegroup5_1940"{
            local name = "Women aged 35-44 (1940) "
        }
        else if "`var'"== "deaths_male_cwar"{
            local name = "Male deaths (1000s, 1936-39)"
        }
        else if "`var'"== "deaths_female_cwar"{
            local name = "Female deaths (1000s, 1936-39)"
        }
        else {
            local name = "ERROR"
        }

if "`var'"== "popwomen_agegroup3_1940" | "`var'"== "popwomen_agegroup4_1940" | "`var'"== "popwomen_agegroup5_1940"{
        reghdfe `var'  interaction interaction2, a(i.idtype i.codprov)  nocons
        local diff3 = _b[interaction]
        local sd3=_se[interaction]
        local pval3 = ttail(47,abs(_b[interaction]/_se[interaction]))*2
        if `pval3'>0.1  {
            local cc = string(`diff3',"%8.0f")
        }
        else if `pval3'>0.05 {
            local cc = string(`diff3',"%8.0f") + "$^\star$"
        }
        else if `pval3'>0.01 {
            local cc = string(`diff3',"%8.0f") + "$^\star$" + "$^\star$"
        }
        else {
            local cc = string(`diff3',"%8.0f") + "$^\star$" + "$^\star$" + "$^\star$"
        }
        local dd = string(`sd3',"%8.0f")
        file write myfile ("`name'") "&" _tab  %8.2f ("`cc'")  "&"_tab  %8.2f ("`dd'") _tab "\\" _n
}
        else {
        reghdfe `var'  interaction interaction2, a(i.idtype i.codprov)  nocons
        local diff3 = _b[interaction]
        local sd3=_se[interaction]
        local pval3 = ttail(47,abs(_b[interaction]/_se[interaction]))*2
        if `pval3'>0.1  {
            local cc = string(`diff3',"%8.3f")
        }
        else if `pval3'>0.05 {
            local cc = string(`diff3',"%8.3f") + "$^\star$"
        }
        else if `pval3'>0.01 {
            local cc = string(`diff3',"%8.3f") + "$^\star$" + "$^\star$"
        }
        else {
            local cc = string(`diff3',"%8.3f") + "$^\star$" + "$^\star$" + "$^\star$"
        }
        local dd = string(`sd3',"%8.3f")
        file write myfile ("`name'") "&" _tab  %8.2f ("`cc'")  "&"_tab  %8.2f ("`dd'") _tab "\\" _n
        }
}
file write myfile "\hline\hline \end{tabular}"
file close myfile
restore

log close
