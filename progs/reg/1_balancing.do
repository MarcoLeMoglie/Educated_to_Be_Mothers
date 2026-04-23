use "$Output_data/dataset.dta", clear

keep if year==1940
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
**# Regression -- By gender & prov*year FE
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

egen idtype = group(type)
gen popsharewomen_agegroup1=popsharewomen_agegroup1_1940+popsharewomen_agegroup2_1940
*gen popsharewomen_agegroup2=popsharewomen_agegroup2_1940
gen popsharewomen_agegroup2=popsharewomen_agegroup3_1940+popsharewomen_agegroup4_1940+popsharewomen_agegroup5_1940
gen popsharemen_agegroup1=popsharemen_agegroup1_1940+popsharemen_agegroup2_1940
*gen popsharemen_agegroup2=popsharemen_agegroup2_1940
gen popsharemen_agegroup2=popsharemen_agegroup3_1940+popsharemen_agegroup4_1940+popsharemen_agegroup5_1940
gen flag4=(alive_birth/(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940))*1000
gen flag6=(total_wedding/(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940))*1000

forvalues i=1(1)1 {
drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
gen sum`i'=popsharewomen_agegroup`i'
gen sum2`i'=popsharemen_agegroup`i' 
	
gen interaction=sum`i'*teachers_pc
gen interaction2=sum2`i'*teachers_pc

}
label var interaction "Treat (W) X Post 1945"
label var interaction2 "Treat (M) X Post 1945"

*********************************
rename popsharemen_agegroup3_1940 popsharemen_ag3_1940
rename popsharemen_agegroup4_1940 popsharemen_ag4_1940
rename popsharemen_agegroup3_1930 popsharemen_ag3_1930
rename popsharemen_agegroup4_1930 popsharemen_ag4_1930

**# Regression NOT controlling for male population	
foreach var of varlist  relig_com_total1930 professed_total1930 novice_total1930 lay_total1930 share_republicanos1931 share_socialistas1931 share_monarquicos1931 share_comunistas1931 adictos sh_area_front popsharemen_ag3_1940 popsharemen_ag4_1940 popsharemen_ag3_1930 popsharemen_ag4_1930 nat_school_total42 teachersprimary_total42 enrolled_students42  {

reghdfe `var'  interaction interaction2, a(i.idtype i.codprov) cluster(codprov) nocons
est sto est_`var'
}
	
	* Save table
	label var interaction "Rel. communities"
esttab est_relig_com_total1930   using "$Results\table_balancing.tex", replace booktabs f keep(interaction ) label nobaselevels style(tex)  se cells("b (star fmt(%10.3f)) se(par  fmt(%10.3f)) ")  starlevels(* 0.10 ** 0.05 *** 0.01)  mgroups("Balancing" , pattern(1 ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))   nomtitles  collabels(none)  plain noobs posthead("\vspace{.2cm} \hline \vspace{.1cm}""\multicolumn{3}{l}{Panel A: Religion}  \vspace{.1cm}""\hline") 


	label var interaction "Professed"
esttab est_professed_total1930 using "$Results\table_balancing.tex",  append booktabs f  keep(interaction )	  label nobaselevels interaction(" $\times$ ") style(tex)  se cells("b (star fmt(%10.3f)) se(par  fmt(%10.3f))")  starlevels(* 0.10 ** 0.05 *** 0.01) nomtitles collabels(,none) plain noobs 

	label var interaction "Novices"
esttab  est_novice_total1930 using "$Results\table_balancing.tex", append booktabs f keep(interaction )	  label nobaselevels interaction(" $\times$ ") style(tex)  se cells("b (star fmt(%10.3f)) se(par  fmt(%10.3f))")  starlevels(* 0.10 ** 0.05 *** 0.01) nomtitles collabels(,none) plain noobs 

	label var interaction "Lay"	
esttab  est_lay_total1930 using "$Results\table_balancing.tex", append booktabs f keep(interaction )	  label nobaselevels interaction(" $\times$ ") style(tex)  se cells("b (star fmt(%10.3f)) se(par  fmt(%10.3f))")  starlevels(* 0.10 ** 0.05 *** 0.01) nomtitles collabels(,none) plain noobs  
	
	label var interaction "Republican sh."
esttab  est_share_republicanos1931 using "$Results\table_balancing.tex", append booktabs f keep(interaction )	  label nobaselevels interaction(" $\times$ ") style(tex)  se cells("b (star fmt(%10.3f)) se(par  fmt(%10.3f))")  starlevels(* 0.10 ** 0.05 *** 0.01) nomtitles collabels(,none) plain noobs posthead("\vspace{.2cm} \hline \vspace{.1cm}""\multicolumn{3}{l}{Panel B: Electoral variables} \vspace{.1cm}""\hline") 

	label var interaction "Socialist sh."	
esttab  est_share_socialistas1931 using "$Results\table_balancing.tex", append booktabs f keep(interaction )	  label nobaselevels interaction(" $\times$ ") style(tex)  se cells("b (star fmt(%10.3f)) se(par  fmt(%10.3f))")  starlevels(* 0.10 ** 0.05 *** 0.01) nomtitles collabels(,none) plain noobs

	label var interaction "Monarchic sh."	
esttab  est_share_monarquicos1931 using "$Results\table_balancing.tex", append booktabs f keep(interaction )	  label nobaselevels interaction(" $\times$ ") style(tex)  se cells("b (star fmt(%10.3f)) se(par  fmt(%10.3f))")  starlevels(* 0.10 ** 0.05 *** 0.01) nomtitles collabels(,none) plain noobs 

	label var interaction "Communists sh."	
esttab  est_share_comunistas1931 using "$Results\table_balancing.tex", append booktabs f keep(interaction )	  label nobaselevels interaction(" $\times$ ") style(tex)  se cells("b (star fmt(%10.3f)) se(par  fmt(%10.3f))")  starlevels(* 0.10 ** 0.05 *** 0.01) nomtitles collabels(,none) plain noobs 

	label var interaction "Addicted to regime (1947)"	
esttab  est_adictos using "$Results\table_balancing.tex", append booktabs f keep(interaction )	  label nobaselevels interaction(" $\times$ ") style(tex)  se cells("b (star fmt(%10.3f)) se(par  fmt(%10.3f))")  starlevels(* 0.10 ** 0.05 *** 0.01) nomtitles collabels(,none) plain noobs 

	label var interaction "National schools (1942)"	
esttab  est_nat_school_total42 using "$Results\table_balancing.tex", append booktabs f keep(interaction )	  label nobaselevels interaction(" $\times$ ") style(tex)  se cells("b (star fmt(%10.3f)) se(par  fmt(%10.3f))")  starlevels(* 0.10 ** 0.05 *** 0.01) nomtitles collabels(,none) plain noobs posthead("\vspace{.2cm} \hline \vspace{.1cm}""\multicolumn{3}{l}{Panel B: Primary education}  \vspace{.1cm}""\hline") 

	label var interaction "Primary Teachers (1942)"	
esttab  est_teachersprimary_total42 using "$Results\table_balancing.tex", append booktabs f keep(interaction )	  label nobaselevels interaction(" $\times$ ") style(tex)  se cells("b (star fmt(%10.3f)) se(par  fmt(%10.3f))")  starlevels(* 0.10 ** 0.05 *** 0.01) nomtitles collabels(,none) plain noobs 

	label var interaction "Enrolled students (1942)"	
esttab  est_enrolled_students42 using "$Results\table_balancing.tex", append booktabs f keep(interaction )	  label nobaselevels interaction(" $\times$ ") style(tex)  se cells("b (star fmt(%10.3f)) se(par  fmt(%10.3f))")  starlevels(* 0.10 ** 0.05 *** 0.01) nomtitles collabels(,none) plain noobs  

	label var interaction "Area sh. in National front"	
esttab  est_sh_area_front using "$Results\table_balancing.tex", append booktabs f keep(interaction )	  label nobaselevels interaction(" $\times$ ") style(tex)  se cells("b (star fmt(%10.3f)) se(par  fmt(%10.3f))")  starlevels(* 0.10 ** 0.05 *** 0.01) nomtitles collabels(,none) plain noobs  posthead("\vspace{.2cm} \hline \vspace{.1cm}""\multicolumn{3}{l}{Panel C: Other variables}  \vspace{.1cm}""\hline")  	

	label var interaction "Male pop sh. age group 3 (1940)"	
esttab  est_popsharemen_ag3_1940 using "$Results\table_balancing.tex", append booktabs f keep(interaction )	  label nobaselevels interaction(" $\times$ ") style(tex)  se cells("b (star fmt(%10.3f)) se(par  fmt(%10.3f))")  starlevels(* 0.10 ** 0.05 *** 0.01) nomtitles collabels(,none) plain noobs 

	label var interaction "Male pop sh. age group 4 (1940)"	
esttab  est_popsharemen_ag4_1940 using "$Results\table_balancing.tex", append booktabs f keep(interaction )	  label nobaselevels interaction(" $\times$ ") style(tex)  se cells("b (star fmt(%10.3f)) se(par  fmt(%10.3f))")  starlevels(* 0.10 ** 0.05 *** 0.01) nomtitles collabels(,none) plain noobs 
//      collabels(none) 
/*
	label var interaction "Library volumes (1942)"	
esttab  est_library_vol42 using "$Results\table_balancing.tex", append booktabs f keep(interaction )	  label nobaselevels interaction(" $\times$ ") style(tex)  se cells("b (star fmt(%10.3f)) se(par  fmt(%10.3f))")  starlevels(* 0.10 ** 0.05 *** 0.01) nomtitles collabels(,none) plain noobs 

	label var interaction "Cost of living index (1943)"	
esttab  est_cost_liv_index43 using "$Results\table_balancing.tex", append booktabs f keep(interaction )	  label nobaselevels interaction(" $\times$ ") style(tex)  se cells("b (star fmt(%10.3f)) se(par  fmt(%10.3f))")  starlevels(* 0.10 ** 0.05 *** 0.01) nomtitles collabels(,none) plain noobs 

	label var interaction "Morbidity (1943)"	
esttab  est_morbidity_q1_43using "$Results\table_balancing.tex", append booktabs f keep(interaction )	  label nobaselevels interaction(" $\times$ ") style(tex)  se cells("b (star fmt(%10.3f)) se(par  fmt(%10.3f))")  starlevels(* 0.10 ** 0.05 *** 0.01) nomtitles collabels(,none) plain noobs  
*/
	stop
		
**# Regression controlling for male population	
 foreach var of varlist  relig_com_female1930  professed_female1930 novice_female1930 lay_sister1930 relig_com_total1930 professed_total1930 novice_total1930 lay_total1930 share_republicanos1931 share_socialistas1931 share_monarquicos1931 share_comunistas1931 sh_area_front {
	
reghdfe `var'  interaction interaction2, a(i.idtype i.codprov) cluster(codprov) nocons
est sto est_`var'
	mat fstat = e(N_clust)	
	estadd ysumm
}
estfe est_relig_com_female1930  est_professed_female1930 est_novice_female1930 est_lay_sister1930 est_relig_com_total1930 est_professed_total1930 est_novice_total1930 est_lay_total1930 est_share_republicanos1931 est_share_socialistas1931 est_share_monarquicos1931 est_share_comunistas1931 est_sh_area_front, labels(idtype "Mun. FE" codprov "Prov. FE")
	
	* Save table  
	esttab est_relig_com_female1930  est_professed_female1930 est_novice_female1930 est_lay_sister1930 est_relig_com_total1930 est_professed_total1930 est_novice_total1930 est_lay_total1930 est_share_republicanos1931 est_share_socialistas1931 est_share_monarquicos1931 est_share_comunistas1931 est_sh_area_front  using "$Results\table_balancing_male.tex",  stats(N N_clust ymean , fmt(%9.0fc %8.0f %8.2f %8.1f) label("Observations" "N. Clusters" "Mean of Dep. Variable" )) keep(interaction interaction2)	replace  label nobaselevels interaction(" $\times$ ") style(tex)  se cells(b (star fmt(%10.3f)) se(par fmt(%10.3f)))  starlevels(* 0.10 ** 0.05 *** 0.01) indicate(`r(indicate_fe)' )  mgroups("Female Religious communities (1930)" "Total Religious communities (1930)" "Electoral outcomes (1931)" "War Front", pattern(1 0 0 0 1 0 0 0 1 0 0 0 1 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))   mtitle("Relig comm." "Professed" "Novices" "Lay sister" "Relig. comm." "Professed" "Novices" "Lay sister" "Republican sh."  "Socialist sh." "Monarchic sh." "Communists sh." "Share Area Front"  )  collabels(none) 
	
	
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
**# BALANCING WITH ONLY POP TREATMENT
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
use "$Output_data/dataset.dta", clear

keep if year==1940
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
**# Regression -- By gender & prov*year FE
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

egen idtype = group(type)
gen popsharewomen_agegroup1=popsharewomen_agegroup1_1940+popsharewomen_agegroup2_1940
*gen popsharewomen_agegroup2=popsharewomen_agegroup2_1940
gen popsharewomen_agegroup2=popsharewomen_agegroup3_1940+popsharewomen_agegroup4_1940+popsharewomen_agegroup5_1940
gen popsharemen_agegroup1=popsharemen_agegroup1_1940+popsharemen_agegroup2_1940
*gen popsharemen_agegroup2=popsharemen_agegroup2_1940
gen popsharemen_agegroup2=popsharemen_agegroup3_1940+popsharemen_agegroup4_1940+popsharemen_agegroup5_1940
gen flag4=(alive_birth/(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940))*1000
gen flag6=(total_wedding/(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940))*1000

forvalues i=1(1)1 {
drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
gen sum`i'=popsharewomen_agegroup`i'
gen sum2`i'=popsharemen_agegroup`i' 
	
gen interaction=sum`i'
gen interaction2=sum2`i'

}
label var interaction "Treat (W) X Post 1945"
label var interaction2 "Treat (M) X Post 1945"

*********************************
rename popsharemen_agegroup3_1940 popsharemen_ag3_1940
rename popsharemen_agegroup4_1940 popsharemen_ag4_1940
rename popsharemen_agegroup3_1930 popsharemen_ag3_1930
rename popsharemen_agegroup4_1930 popsharemen_ag4_1930

**# Regression NOT controlling for male population	
foreach var of varlist  relig_com_total1930 professed_total1930 novice_total1930 lay_total1930 share_republicanos1931 share_socialistas1931 share_monarquicos1931 share_comunistas1931 adictos sh_area_front popsharemen_ag3_1940 popsharemen_ag4_1940 popsharemen_ag3_1930 popsharemen_ag4_1930 nat_school_total42 teachersprimary_total42 enrolled_students42  {

reghdfe `var'  interaction , a(i.idtype i.codprov) cluster(codprov) nocons
est sto est_`var'
}
	
	* Save table
	label var interaction "Rel. communities"
esttab est_relig_com_total1930   using "$Results\balancing\onlypop\table_balancing.tex", replace booktabs f keep(interaction ) label nobaselevels style(tex)  se cells("b (star fmt(%10.3f)) se(par  fmt(%10.3f)) ")  starlevels(* 0.10 ** 0.05 *** 0.01)  mgroups("Balancing" , pattern(1 ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))   nomtitles  collabels(none)  plain noobs posthead("\vspace{.2cm} \hline \vspace{.1cm}""\multicolumn{3}{l}{Panel A: Religion}  \vspace{.1cm}""\hline") 


	label var interaction "Professed"
esttab est_professed_total1930 using "$Results\balancing\onlypop\table_balancing.tex",  append booktabs f  keep(interaction )	  label nobaselevels interaction(" $\times$ ") style(tex)  se cells("b (star fmt(%10.3f)) se(par  fmt(%10.3f))")  starlevels(* 0.10 ** 0.05 *** 0.01) nomtitles collabels(,none) plain noobs 

	label var interaction "Novices"
esttab  est_novice_total1930 using "$Results\balancing\onlypop\table_balancing.tex", append booktabs f keep(interaction )	  label nobaselevels interaction(" $\times$ ") style(tex)  se cells("b (star fmt(%10.3f)) se(par  fmt(%10.3f))")  starlevels(* 0.10 ** 0.05 *** 0.01) nomtitles collabels(,none) plain noobs 

	label var interaction "Lay"	
esttab  est_lay_total1930 using "$Results\balancing\onlypop\table_balancing.tex", append booktabs f keep(interaction )	  label nobaselevels interaction(" $\times$ ") style(tex)  se cells("b (star fmt(%10.3f)) se(par  fmt(%10.3f))")  starlevels(* 0.10 ** 0.05 *** 0.01) nomtitles collabels(,none) plain noobs  
	
	label var interaction "Republican sh."
esttab  est_share_republicanos1931 using "$Results\balancing\onlypop\table_balancing.tex", append booktabs f keep(interaction )	  label nobaselevels interaction(" $\times$ ") style(tex)  se cells("b (star fmt(%10.3f)) se(par  fmt(%10.3f))")  starlevels(* 0.10 ** 0.05 *** 0.01) nomtitles collabels(,none) plain noobs posthead("\vspace{.2cm} \hline \vspace{.1cm}""\multicolumn{3}{l}{Panel B: Electoral variables} \vspace{.1cm}""\hline") 

	label var interaction "Socialist sh."	
esttab  est_share_socialistas1931 using "$Results\balancing\onlypop\table_balancing.tex", append booktabs f keep(interaction )	  label nobaselevels interaction(" $\times$ ") style(tex)  se cells("b (star fmt(%10.3f)) se(par  fmt(%10.3f))")  starlevels(* 0.10 ** 0.05 *** 0.01) nomtitles collabels(,none) plain noobs

	label var interaction "Monarchic sh."	
esttab  est_share_monarquicos1931 using "$Results\balancing\onlypop\table_balancing.tex", append booktabs f keep(interaction )	  label nobaselevels interaction(" $\times$ ") style(tex)  se cells("b (star fmt(%10.3f)) se(par  fmt(%10.3f))")  starlevels(* 0.10 ** 0.05 *** 0.01) nomtitles collabels(,none) plain noobs 

	label var interaction "Communists sh."	
esttab  est_share_comunistas1931 using "$Results\balancing\onlypop\table_balancing.tex", append booktabs f keep(interaction )	  label nobaselevels interaction(" $\times$ ") style(tex)  se cells("b (star fmt(%10.3f)) se(par  fmt(%10.3f))")  starlevels(* 0.10 ** 0.05 *** 0.01) nomtitles collabels(,none) plain noobs 

	label var interaction "Addicted to regime (1947)"	
esttab  est_adictos using "$Results\balancing\onlypop\table_balancing.tex", append booktabs f keep(interaction )	  label nobaselevels interaction(" $\times$ ") style(tex)  se cells("b (star fmt(%10.3f)) se(par  fmt(%10.3f))")  starlevels(* 0.10 ** 0.05 *** 0.01) nomtitles collabels(,none) plain noobs 

	label var interaction "National schools (1942)"	
esttab  est_nat_school_total42 using "$Results\balancing\onlypop\table_balancing.tex", append booktabs f keep(interaction )	  label nobaselevels interaction(" $\times$ ") style(tex)  se cells("b (star fmt(%10.3f)) se(par  fmt(%10.3f))")  starlevels(* 0.10 ** 0.05 *** 0.01) nomtitles collabels(,none) plain noobs posthead("\vspace{.2cm} \hline \vspace{.1cm}""\multicolumn{3}{l}{Panel B: Primary education}  \vspace{.1cm}""\hline") 

	label var interaction "Primary Teachers (1942)"	
esttab  est_teachersprimary_total42 using "$Results\balancing\onlypop\table_balancing.tex", append booktabs f keep(interaction )	  label nobaselevels interaction(" $\times$ ") style(tex)  se cells("b (star fmt(%10.3f)) se(par  fmt(%10.3f))")  starlevels(* 0.10 ** 0.05 *** 0.01) nomtitles collabels(,none) plain noobs 

	label var interaction "Enrolled students (1942)"	
esttab  est_enrolled_students42 using "$Results\balancing\onlypop\table_balancing.tex", append booktabs f keep(interaction )	  label nobaselevels interaction(" $\times$ ") style(tex)  se cells("b (star fmt(%10.3f)) se(par  fmt(%10.3f))")  starlevels(* 0.10 ** 0.05 *** 0.01) nomtitles collabels(,none) plain noobs  

	label var interaction "Area sh. in National front"	
esttab  est_sh_area_front using "$Results\balancing\onlypop\table_balancing.tex", append booktabs f keep(interaction )	  label nobaselevels interaction(" $\times$ ") style(tex)  se cells("b (star fmt(%10.3f)) se(par  fmt(%10.3f))")  starlevels(* 0.10 ** 0.05 *** 0.01) nomtitles collabels(,none) plain noobs  posthead("\vspace{.2cm} \hline \vspace{.1cm}""\multicolumn{3}{l}{Panel C: Other variables}  \vspace{.1cm}""\hline")  	

	label var interaction "Male pop sh. age group 3 (1940)"	
esttab  est_popsharemen_ag3_1940 using "$Results\balancing\onlypop\table_balancing.tex", append booktabs f keep(interaction )	  label nobaselevels interaction(" $\times$ ") style(tex)  se cells("b (star fmt(%10.3f)) se(par  fmt(%10.3f))")  starlevels(* 0.10 ** 0.05 *** 0.01) nomtitles collabels(,none) plain noobs 

	label var interaction "Male pop sh. age group 4 (1940)"	
esttab  est_popsharemen_ag4_1940 using "$Results\balancing\onlypop\table_balancing.tex", append booktabs f keep(interaction )	  label nobaselevels interaction(" $\times$ ") style(tex)  se cells("b (star fmt(%10.3f)) se(par  fmt(%10.3f))")  starlevels(* 0.10 ** 0.05 *** 0.01) nomtitles collabels(,none) plain noobs 
//      collabels(none) 
/*
	label var interaction "Library volumes (1942)"	
esttab  est_library_vol42 using "$Results\balancing\onlypop\table_balancing.tex", append booktabs f keep(interaction )	  label nobaselevels interaction(" $\times$ ") style(tex)  se cells("b (star fmt(%10.3f)) se(par  fmt(%10.3f))")  starlevels(* 0.10 ** 0.05 *** 0.01) nomtitles collabels(,none) plain noobs 

	label var interaction "Cost of living index (1943)"	
esttab  est_cost_liv_index43 using "$Results\balancing\onlypop\table_balancing.tex", append booktabs f keep(interaction )	  label nobaselevels interaction(" $\times$ ") style(tex)  se cells("b (star fmt(%10.3f)) se(par  fmt(%10.3f))")  starlevels(* 0.10 ** 0.05 *** 0.01) nomtitles collabels(,none) plain noobs 

	label var interaction "Morbidity (1943)"	
esttab  est_morbidity_q1_43using "$Results\balancing\onlypop\table_balancing.tex", append booktabs f keep(interaction )	  label nobaselevels interaction(" $\times$ ") style(tex)  se cells("b (star fmt(%10.3f)) se(par  fmt(%10.3f))")  starlevels(* 0.10 ** 0.05 *** 0.01) nomtitles collabels(,none) plain noobs  
*/
	stop
		
**# Regression controlling for male population	
 foreach var of varlist  relig_com_female1930  professed_female1930 novice_female1930 lay_sister1930 relig_com_total1930 professed_total1930 novice_total1930 lay_total1930 share_republicanos1931 share_socialistas1931 share_monarquicos1931 share_comunistas1931 sh_area_front {
	
reghdfe `var'  interaction interaction2, a(i.idtype i.codprov) cluster(codprov) nocons
est sto est_`var'
	mat fstat = e(N_clust)	
	estadd ysumm
}
estfe est_relig_com_female1930  est_professed_female1930 est_novice_female1930 est_lay_sister1930 est_relig_com_total1930 est_professed_total1930 est_novice_total1930 est_lay_total1930 est_share_republicanos1931 est_share_socialistas1931 est_share_monarquicos1931 est_share_comunistas1931 est_sh_area_front, labels(idtype "Mun. FE" codprov "Prov. FE")
	
	* Save table  
	esttab est_relig_com_female1930  est_professed_female1930 est_novice_female1930 est_lay_sister1930 est_relig_com_total1930 est_professed_total1930 est_novice_total1930 est_lay_total1930 est_share_republicanos1931 est_share_socialistas1931 est_share_monarquicos1931 est_share_comunistas1931 est_sh_area_front  using "$Results\balancing\onlypop\table_balancing_male.tex",  stats(N N_clust ymean , fmt(%9.0fc %8.0f %8.2f %8.1f) label("Observations" "N. Clusters" "Mean of Dep. Variable" )) keep(interaction interaction2)	replace  label nobaselevels interaction(" $\times$ ") style(tex)  se cells(b (star fmt(%10.3f)) se(par fmt(%10.3f)))  starlevels(* 0.10 ** 0.05 *** 0.01) indicate(`r(indicate_fe)' )  mgroups("Female Religious communities (1930)" "Total Religious communities (1930)" "Electoral outcomes (1931)" "War Front", pattern(1 0 0 0 1 0 0 0 1 0 0 0 1 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))   mtitle("Relig comm." "Professed" "Novices" "Lay sister" "Relig. comm." "Professed" "Novices" "Lay sister" "Republican sh."  "Socialist sh." "Monarchic sh." "Communists sh." "Share Area Front"  )  collabels(none) 
	
		