use "$Data\CIS\_data_cis\barometros.dta", clear
egen id_type = group(type)
drop if year_birth<1910
tab ESTU

g age_c = floor(age/10)
replace kids=0 if nkids==0 & kids==.

gen flag= age_together-age_partner_together

*keep if female==1
keep if year_birth<=1970
keep if year_birth>=1920

* ------------------------------------------
* Define output path
* ------------------------------------------
local outfile "$Results/summary_panels.tex"

* ------------------------------------------
* Start LaTeX table
* ------------------------------------------
file open handle using "`outfile'", write replace
file write handle "\begin{table}[htbp]\centering" _n
file write handle "\caption{Summary Statistics}" _n
file write handle "\begin{tabular}{l*{5}{D{.}{.}{-1}}}" _n
file write handle "\toprule" _n
file write handle "& \multicolumn{1}{c}{Mean} & \multicolumn{1}{c}{Std. Dev.} & \multicolumn{1}{c}{Min} & \multicolumn{1}{c}{Max} & \multicolumn{1}{c}{N} \\" _n
file write handle "\midrule" _n
file close handle

* -------------------------
* Panel A: CIS Data
* -------------------------
file open handle using "`outfile'", write append
file write handle "\multicolumn{6}{l}{\textbf{Panel A: CIS Data}} \\" _n
file close handle
label var nkids "N. kids"
estpost summarize kids nkids if female==1 & year_birth>=1920 & year_birth<=1950, detail
esttab using "`outfile'", append ///
    booktabs f label style(tex) ///
cells("mean(fmt(3)) sd(fmt(3)) min(fmt(2)) max(fmt(2)) count(fmt(0))") ///
    collabels(none) ///
    nomtitles noobs plain

	
label var ideal_fam_equal "Gender roles: Equal"	
label var husb_lesshouseworks "Husband less housework"
label var stab_sharehousework "Couple's stability: Shared housework"
label var stab_kids "Couple's stability: Kids"
label var realwoman_kids  "Real woman has kids"       
label var women_work "Woman works"
label var stab_wifework "Couple's stability: Wife works"
label var pro_abort_church "Agree with Church: Abortion"
label var pro_art_fert "Agree with Church: Artificial procreation"
label var pro_contracep "Agree with Church: Contraception"



		
estpost summarize ideal_fam_equal husb_lesshouseworks stab_sharehousework stab_kids realwoman_kids women_work stab_wifework  pro_abort_church pro_art_fert pro_contracep if female==1 , detail
esttab using "`outfile'", append ///
    booktabs f label style(tex) ///
cells("mean(fmt(3)) sd(fmt(3)) min(fmt(2)) max(fmt(2)) count(fmt(0))") ///
    collabels(none) ///
    nomtitles noobs plain		
	
* -------------------------
* Panel B: Census Microdata (INE)
* -------------------------

use "$Data\INE_microdatos\censo2011\por_provincias\censo2011_provincias.dta", clear
rename *, lower

keep if anac<=1970
keep if anac>=1920

gen kids=nhijo>0 & nhijo!=.
replace kids=. if nhijo==.

gen kids2=hijos==1
replace kids2=. if hijos==.

replace nhijos=0 if kids2==0

append using "$Output_data\dataset_microdata1991_cleanedMarco.dta"

label var kids2 "Kids"
label var nhijos "N. kids"

file open handle using "`outfile'", write append
file write handle "\addlinespace" _n
file write handle "\multicolumn{6}{l}{\textbf{Panel B: Census Microdata}} \\" _n
file close handle


 estpost summarize kids2 nhijos  if sexo==6 & anac>=1920 & anac<=1950, detail
esttab using "`outfile'", append ///
    booktabs f label style(tex) ///
cells("mean(fmt(3)) sd(fmt(3)) min(fmt(2)) max(fmt(2)) count(fmt(0))") ///
    collabels(none) ///
    nomtitles noobs plain

 
* -------------------------
* Panel C: Macro level data  
* -------------------------
file open handle using "`outfile'", write append
file write handle "\addlinespace" _n
file write handle "\multicolumn{6}{l}{\textbf{Panel C: Macro level data}} \\" _n
file close handle


use "$Output_data\dataset.dta", clear
label var alive "Births"
gen popsharewomen_agegroup1=(popsharewomen_agegroup1_1940+popsharewomen_agegroup2_1940)*100
gen popsharemen_agegroup1=(popsharemen_agegroup1_1940+popsharemen_agegroup2_1940)*100

drop if popsharewomen_agegroup1==. | popsharemen_agegroup1==.
gen flag4=.
gen flag4_3=.
gen flag4_4=.
gen flag4_5=.

replace flag4= ln(popwomen_agegroup3_1930 +popwomen_agegroup4_1930 +popwomen_agegroup5_1930) if year>=1930 & year<1940
replace flag4= ln(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940) if year>=1940 & year<1950
replace flag4= ln(popwomen_agegroup3_1950 +popwomen_agegroup4_1950 +popwomen_agegroup5_1950) if year>=1950 & year<1960
replace flag4= ln(popwomen_agegroup3_1960 +popwomen_agegroup4_1960 +popwomen_agegroup5_1960) if year>=1960 & year<1970
replace flag4= ln(popwomen_agegroup3_1970 +popwomen_agegroup4_1970 +popwomen_agegroup5_1970) if year>=1970 & year<1980


replace flag4_3= ln(popwomen_agegroup3_1930) if year>=1930 & year<1940
replace flag4_3= ln(popwomen_agegroup3_1940) if year>=1940 & year<1950
replace flag4_3= ln(popwomen_agegroup3_1950) if year>=1950 & year<1960
replace flag4_3= ln(popwomen_agegroup3_1960) if year>=1960 & year<1970
replace flag4_3= ln(popwomen_agegroup3_1970) if year>=1970 & year<1980

replace flag4_4= ln(popwomen_agegroup4_1930) if year>=1930 & year<1940
replace flag4_4= ln(popwomen_agegroup4_1940) if year>=1940 & year<1950
replace flag4_4= ln(popwomen_agegroup4_1950) if year>=1950 & year<1960
replace flag4_4= ln(popwomen_agegroup4_1960) if year>=1960 & year<1970
replace flag4_4= ln(popwomen_agegroup4_1970) if year>=1970 & year<1980

replace flag4_5= ln(popwomen_agegroup5_1930) if year>=1930 & year<1940
replace flag4_5= ln(popwomen_agegroup5_1940) if year>=1940 & year<1950
replace flag4_5= ln(popwomen_agegroup5_1950) if year>=1950 & year<1960
replace flag4_5= ln(popwomen_agegroup5_1960) if year>=1960 & year<1970
replace flag4_5= ln(popwomen_agegroup5_1970) if year>=1970 & year<1980

* Set up variable of interest
local x alive
local i = 1

* Construct regression sample
gen reg_sample = 1
replace reg_sample = . if missing(`x')                               // Dep var missing
replace reg_sample = . if missing(popsharewomen_agegroup`i')         // sum1
replace reg_sample = . if missing(popsharemen_agegroup`i')           // sum2
replace reg_sample = . if missing(post)                              // interaction
replace reg_sample = . if missing(flag4_3) | missing(flag4_4) | missing(flag4_5)

* If any additional variables used in interaction terms, add them similarly

* Now create your summary table ONLY on this sample
sum `x' if reg_sample == 1
sum popsharewomen_agegroup`i' if reg_sample == 1
sum popsharemen_agegroup`i' if reg_sample == 1
tab year if reg_sample == 1


keep if reg_sample == 1

estpost summarize alive , detail
esttab using "`outfile'", append ///
    booktabs f label style(tex) ///
cells("mean(fmt(3)) sd(fmt(3)) min(fmt(2)) max(fmt(2)) count(fmt(0))") ///
    collabels(none) ///
    nomtitles noobs plain

* -------------------------
* Close LaTeX table
* -------------------------
file open handle using "`outfile'", write append
file write handle "\bottomrule" _n
file write handle "\end{tabular}" _n
file write handle "\end{table}" _n
file close handle
