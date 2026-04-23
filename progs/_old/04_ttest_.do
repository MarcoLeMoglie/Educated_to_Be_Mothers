use "$Output_data/dataset.dta", clear
keep if year == 1940
drop teachers_pc
gen teachers_pc=teachers/pop_1930*10000
drop if popsharewomen_agegroup1_1940==. | popsharemen_agegroup1_1940==. | popsharewomen_agegroup2_1940==. | popsharemen_agegroup2_1940==.


drop if year>=1945
* Dummy for teachers
sum teachers_pc, detail
gen m_tea=teachers_pc>r(p50) & teachers_pc!=.
* Dummy for women pop share
gen pop_w=popsharewomen_agegroup1_1940+popsharewomen_agegroup2_1940
sum pop_w, detail
gen m_popw=pop_w>r(p50) & pop_w!=.
* Dummy for male pop share
gen pop_m=popsharemen_agegroup1_1940+popsharemen_agegroup2_1940
sum pop_m, detail
gen m_popm=pop_m>r(p50) & pop_m!=.

* Dependent variables
gen flag4=(alive_birth/(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940))*1000
gen flag6=(total_wedding/(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940))*1000


label var flag4 "Alive births per 1,000 inh."
label var flag6 "Weddings per 1,000 inh."


* * * * * * * * * * * * * * * * * * * * * * 
**# ttest 1: Both shares above median: m_atea_apopw
* Group 1: Below median  Group 2: Above median
* * * * * * * * * * * * * * * * * * * * * * 
gen m_atea_apopw = 1 if m_tea ==1 & m_popw ==1 & pop_w!=. & teachers_pc!=.
replace m_atea_apopw =0 if m_tea ==0 & m_popw ==0 & pop_w!=. & teachers_pc!=.
label var m_atea_apopw "Above median"



foreach var of varlist sch_pop_female1933 stud_enroll_female1933 avg_attend_female1933 sch_pop_total1933 stud_enroll_total1933 avg_attend_total1933 relig_com_female1930 professed_female1930 novice_female1930 lay_sister1930 relig_com_total1930 professed_total1930 novice_total1930 lay_total1930 share_republicanos1931- share_comunistas1931 sh_area_front  popsharemen_agegroup3_1940 popsharemen_agegroup4_1940 popsharemen_agegroup3_1930 popsharemen_agegroup4_1930{
reg `var' m_atea_apopw , cluster(id)  
outreg2 using "$Results\summary\summary_ttest1.tex", label stats(coef se ) keep(m_atea_apopw) nocons dec(3)  
*sum `var' 
}


* * * * * * * * * * * * * * * * * * * * * * 
**# ttest 2: sh. teach above median, share women pop below:m_atea_bpopw
* * * * * * * * * * * * * * * * * * * * * * 
gen m_atea_bpopw = 1 if m_tea ==1 & m_popw ==0 & pop_w!=. & teachers_pc!=.
replace m_atea_bpopw =0 if missing(m_atea_bpopw) & pop_w!=. & teachers_pc!=.
label var m_atea_bpopw "Teach above,wom pop bel"

foreach var of varlist  sch_pop_female1933 stud_enroll_female1933 avg_attend_female1933 sch_pop_total1933 stud_enroll_total1933 avg_attend_total1933 relig_com_female1930 professed_female1930 novice_female1930 lay_sister1930 relig_com_total1930 professed_total1930 novice_total1930 lay_total1930 share_republicanos1931- share_comunistas1931 sh_area_front pop_male_1950 popsharemen_agegroup3_1940 popsharemen_agegroup4_1940 popsharemen_agegroup3_1930 popsharemen_agegroup4_1930{
reg `var' m_atea_bpopw   , cluster(id)
outreg2 using $Results\summary\summary_ttest2.tex, stats(coef se) keep(m_atea_bpopw) nocons dec(3) label
sum `var' 
}

* * * * * * * * * * * * * * * * * * * * * * 
**# ttest 3: share teachers below median, share women pop above
* * * * * * * * * * * * * * * * * * * * * * 
gen m_btea_apopw = 1 if m_tea ==0 & m_popw ==1 & pop_w!=. & teachers_pc!=.
replace m_btea_apopw =0 if missing(m_btea_apopw) & pop_w!=. & teachers_pc!=.
label var m_btea_apopw "Teach bel,wom pop above"
foreach var of varlist  sch_pop_female1933 stud_enroll_female1933 avg_attend_female1933 sch_pop_total1933 stud_enroll_total1933 avg_attend_total1933 relig_com_female1930 professed_female1930 novice_female1930 lay_sister1930 relig_com_total1930 professed_total1930 novice_total1930 lay_total1930 share_republicanos1931- share_comunistas1931 sh_area_front pop_male_1950 popsharemen_agegroup3_1940 popsharemen_agegroup4_1940 popsharemen_agegroup3_1930 popsharemen_agegroup4_1930{
reg `var' m_btea_apopw   , cluster(id)
outreg2 using $Results\summary\summary_ttest3.tex, label stats(coef se) keep(m_btea_apopw) nocons dec(3) 
sum `var' 
}
	
		
* * * * * * * * * * * * * * * * * * * * * * 
**# ttest 4: Both shares below median: m_btea_bpopw NOT NECESSARY
* * * * * * * * * * * * * * * * * * * * * * 
gen m_btea_bpopw = 1 if m_tea ==0 & m_popw ==0 & pop_w!=. & teachers_pc!=.
replace m_btea_bpopw =0 if m_tea ==1 & m_popw ==1 & pop_w!=. & teachers_pc!=.
label var m_btea_bpopw "Below median"
 	
foreach var of varlist sch_pop_female1933 stud_enroll_female1933 avg_attend_female1933 sch_pop_total1933 stud_enroll_total1933 avg_attend_total1933 relig_com_female1930 professed_female1930 novice_female1930 lay_sister1930 relig_com_total1930 professed_total1930 novice_total1930 lay_total1930 share_republicanos1931- share_comunistas1931 sh_area_front pop_male_1950 popsharemen_agegroup3_1940 popsharemen_agegroup4_1940 popsharemen_agegroup3_1930 popsharemen_agegroup4_1930{
reg `var' m_btea_bpopw   , cluster(id)
outreg2 using $Results\summary\summary_ttest4.tex, label stats(coef se ) keep(m_btea_bpopw) nocons dec(3) 
sum `var' 
}
