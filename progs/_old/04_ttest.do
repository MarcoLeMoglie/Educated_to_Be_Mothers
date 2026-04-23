use "$Output_data/dataset.dta", clear
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

local x share_republicanos1931 share_socialistas1931 share_monarquicos1931 share_comunistas1931 share_otros1931 share_no_consta1931 sch_pop_male1933 sch_pop_female1933 stud_enroll_male1933 stud_enroll_female1933 avg_attend_male1933 avg_attend_female1933 relig_com_male1930 professed_male1930 novice_male1930 lay_brother1930 relig_com_female1930 professed_female1930 novice_female1930 lay_sister1930 sh_area_front 

 
bysort m_atea_apopw: eststo: estpost sum `x'  


eststo: estpost ttest `x' , by(m_atea_apopw) unequal 

esttab est* using  $Results\summary\summary_ttest1.tex, replace  ///
        booktabs  fragment label  ///
		cells("mean(pattern(1 1 0) fmt(2)) sd(pattern(1 1  0) par)  b(star pattern(0 0  1) fmt(2)) p(pattern(0 0 1) par fmt(3))") /// //p-value
		mtitle("Group 1"  "Group 2" "Mean-Diff") nolines ///
		collabels(, none)  eqlabels(, none) nonum  plain onecell ///
		stats ( N , fmt(%9.0fc) label ("N") ) 
		est clear
	8
* * * * * * * * * * * * * * * * * * * * * * 
**# ttest 2: sh. teach above median, share women pop below:m_atea_bpopw
* * * * * * * * * * * * * * * * * * * * * * 
gen m_atea_bpopw = 1 if m_tea ==1 & m_popw ==0 & pop_w!=. & teachers_pc!=.
replace m_atea_bpopw =0 if missing(m_atea_bpopw) & pop_w!=. & teachers_pc!=.

local x flag4 flag6 sh_area_front wedding_singles wedding_widow wedding_widower wedding_widows
	 		
bysort m_atea_bpopw: eststo: estpost sum `x' 

eststo: estpost ttest `x' , by(m_atea_bpopw) unequal
esttab est* using  $Results\summary\summary_ttest2.tex, replace  ///
        booktabs  fragment label  ///
		cells("mean(pattern(1 1 0) fmt(2)) sd(pattern(1 1 0) par)  b(star pattern(0 0  1) fmt(2)) p(pattern(0 0 1) par fmt(3))") /// //p-value
		mtitle("Group 1"  "Group 2" "Mean-Diff") nolines ///
		collabels(, none)  eqlabels(, none) nonum  plain onecell ///
		stats ( N , fmt(%9.0fc) label ("N") ) 
		est clear
* * * * * * * * * * * * * * * * * * * * * * 
**# ttest 3: share teachers below median, share women pop above
* * * * * * * * * * * * * * * * * * * * * * 
gen m_btea_apopw = 1 if m_tea ==0 & m_popw ==1 & pop_w!=. & teachers_pc!=.
replace m_btea_apopw =0 if missing(m_btea_apopw) & pop_w!=. & teachers_pc!=.

local x flag4 flag6 sh_area_front wedding_singles wedding_widow wedding_widower wedding_widows
	 		
bysort m_btea_apopw: eststo: estpost sum `x' 

eststo: estpost ttest `x' , by(m_btea_apopw) unequal
esttab est* using  $Results\summary\summary_ttest3.tex, replace  ///
        booktabs  fragment label  ///
		cells("mean(pattern(1 1 0) fmt(2)) sd(pattern(1 1 0) par)  b(star pattern(0 0  1) fmt(2)) p(pattern(0 0 1) par fmt(3))") /// //p-value
		mtitle("Group 1"  "Group 2" "Mean-Diff") nolines ///
		collabels(, none)  eqlabels(, none) nonum  plain onecell ///
		stats ( N , fmt(%9.0fc) label ("N") ) 
		est clear		
		
* * * * * * * * * * * * * * * * * * * * * * 
**# ttest 4=-1: Both shares below median: m_btea_bpopw
* * * * * * * * * * * * * * * * * * * * * * 
gen m_btea_bpopw = 1 if m_tea ==0 & m_popw ==0 & pop_w!=. & teachers_pc!=.
replace m_btea_bpopw =0 if m_tea ==1 & m_popw ==1 & pop_w!=. & teachers_pc!=.

local x flag4 flag6 sh_area_front 
	 		
bysort m_btea_bpopw: eststo: estpost sum `x' 

eststo: estpost ttest `x' , by(m_btea_bpopw) unequal
esttab est* using  $Results\summary\summary_ttest4.tex, replace  ///
        booktabs  fragment label  ///
		cells("mean(pattern(1 1 0) fmt(2)) sd(pattern(1 1  0) par)  b(star pattern(0 0  1) fmt(2)) p(pattern(0 0 1) par fmt(3))") /// //p-value
		mtitle("Group 1"  "Group 2" "Mean-Diff") nolines ///
		collabels(, none)  eqlabels(, none) nonum  plain onecell ///
		stats ( N , fmt(%9.0fc) label ("N") ) 
		est clear		