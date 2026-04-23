use "$Output_data/dataset.dta", clear




** ____________________________________________________ FERTILITY

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
**# Qualitative evidence -- By gender
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
***** 1. Fertility
preserve

drop if popsharewomen_agegroup1_1940==. | popsharemen_agegroup1_1940==. | popsharewomen_agegroup2_1940==. | popsharemen_agegroup2_1940==.
gen flag4=(alive_birth/(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940))*1000

 
sum teachers_pc, detail
gen m_tea=teachers_pc>r(p50) & teachers_pc!=.
gen pop_w=popsharewomen_agegroup1_1940+popsharewomen_agegroup2_1940
sum pop_w, detail
gen m_popw=pop_w>r(p50) & pop_w!=.
gen pop_m=popsharemen_agegroup1_1940+popsharemen_agegroup2_1940
sum pop_m, detail
gen m_popm=pop_m>r(p50) & pop_m!=.

collapse flag4, by(year m_popw m_tea)

twoway (line flag4 year if m_popw==0 & m_tea==0) (line flag4 year if m_popw==1 & m_tea==0) (line flag4 year if m_popw==0 & m_tea==1) (line flag4 year if m_popw==1 & m_tea==1), graphregion(color(white)) legend(order(1 "No teachers/small group" 2 "No teachers/big group" 3 "Teachers/small group" 4 "Teachers/big group")  forces symx(vsmall) size(vsmall)) ytitle("Alive births per 1,000 inh.", s(small)) xtitle("") title("", s(small) c(black)) ylab(, labs(vsmall)) xlab(1930(5)1985, labs(vsmall))
graph export $Results\graphs_qualitative\desc_1940_female_fertility.pdf,replace
restore


***** 2. Weddings
preserve
 
drop if popsharewomen_agegroup1_1940==. | popsharemen_agegroup1_1940==. | popsharewomen_agegroup2_1940==. | popsharemen_agegroup2_1940==.
gen flag6=(total_wedding/(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940))*1000

*drop if year<1941
sum teachers_pc, detail
gen m_tea=teachers_pc>r(p50) & teachers_pc!=.
gen pop_w=popsharewomen_agegroup1_1940+popsharewomen_agegroup2_1940
sum pop_w, detail
gen m_popw=pop_w>r(p50) & pop_w!=.
gen pop_m=popsharemen_agegroup1_1940+popsharemen_agegroup2_1940
sum pop_m, detail
gen m_popm=pop_m>r(p50) & pop_m!=.

collapse flag6, by(year m_popw m_tea)

twoway (line flag6 year if m_popw==0 & m_tea==0) (line flag6 year if m_popw==1 & m_tea==0) (line flag6 year if m_popw==0 & m_tea==1) (line flag6 year if m_popw==1 & m_tea==1), graphregion(color(white)) legend(order(1 "No teachers/small group" 2 "No teachers/big group" 3 "Teachers/small group" 4 "Teachers/big group")  forces symx(vsmall) size(vsmall)) ytitle("Weddings per 1,000 inh.", s(small)) xtitle("") title("", s(small) c(black)) ylab(, labs(vsmall)) xlab(1930(5)1985, labs(vsmall))
graph export $Results\graphs_qualitative\desc_1940_female_weddings.pdf,replace
restore