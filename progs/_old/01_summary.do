*****************
* 1 Summary Statistics by group 
*****************
**# PANEL A 
use "$Output_data/dataset.dta", clear
gen post=year>1945
gen duce=sh_area_front>50 & sh_area_front!=.
drop teachers_pc
gen teachers_pc=teachers/pop_1930*10000

gen popsharewomen_agegroup1=popsharewomen_agegroup1_1940+popsharewomen_agegroup2_1940
*gen popsharewomen_agegroup2=popsharewomen_agegroup2_1940
gen popsharewomen_agegroup2=popsharewomen_agegroup3_1940+popsharewomen_agegroup4_1940+popsharewomen_agegroup5_1940
gen popsharemen_agegroup1=popsharemen_agegroup1_1940+popsharemen_agegroup2_1940
*gen popsharemen_agegroup2=popsharemen_agegroup2_1940
gen popsharemen_agegroup2=popsharemen_agegroup3_1940+popsharemen_agegroup4_1940+popsharemen_agegroup5_1940
gen flag4=(alive_birth/(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940))*1000
gen flag6=(total_wedding/(popwomen_agegroup3_1940 +popwomen_agegroup4_1940 +popwomen_agegroup5_1940))*1000

gen sum1=popsharewomen_agegroup1
gen sum21=popsharemen_agegroup1

gen interaction=post*sum1*teachers_pc
gen interaction2=post*sum21*teachers_pc

label var flag4 "Alive births per 1,000 inh."
label var flag6 "Weddings per 1,000 inh."
label var duce "Distance to the National front"
label var sum1 "Female pop. share aged 0-14"
label var sum2 "Male pop. share aged 0-14"
label var interaction "Treat (W) X Post 1945"
label var interaction2 "Treat (M) X Post 1945"
** number of observations in the baseline regression --> i.year#i.codauto
reghdfe flag4  interaction interaction2 1.post##c.sum1##c.teachers_pc 1.post##c.sum21##c.teachers_pc, a(i.id i.year ) cluster(id) 
count if e(sample)==1


* Baseline sample
estpost tabstat flag4 flag6 duce sum1 sum2  if e(sample)==1,  c(stat) stat(mean sd min max n)
 	 		
esttab using $Results\summary\summary_panela.tex, replace ////
 cells("mean(fmt(%6.2fc)) sd(fmt(%6.2fc)) min max count(fmt(%6.0fc))") nonumber ///
  nomtitle nonote noobs label booktabs ///
  collabels("Mean" "SD" "Min" "Max" "N")
  
  9
* out of sample
estpost tabstat sh_alive_birth   sh_area_front logdistance  if teachers_missing==1,  c(stat) stat(mean sd min max n)
 	 		
esttab using $Results\summary\summary_panelb.tex, replace ////
 cells("mean(fmt(%6.2fc)) sd(fmt(%6.2fc)) min max count(fmt(%6.0fc))") nonumber ///
  nomtitle nonote noobs label booktabs ///
  collabels("Mean" "SD" "Min" "Max" "N")	
  
  
  
		8
* * * * * * * * * * * * 		
* By groups
* * * * * * * * * * * * 
**# PANEL A 
use "$Output_data/dataset.dta", clear
** number of observations in the baseline regression --> i.year#i.codauto
reghdfe sh_alive_birth  1.post##c.popshare_agegroup1_1930##c.teachers_pc if sh_area_front!=., a(i.id i.year#i.codauto i.year#c.logdistance) cluster(id) 
count if e(sample)==1

* N. clusters:
sum id if sh_alive_birth !=. & teachers_pc !=. & logdistance!=.  &  post  !=.
count if sh_alive_birth !=. & teachers_pc !=. & logdistance!=. &  interaction2  !=. &  post  !=.

 
* Complete sample
local x sh_alive_birth sh_area_front logdistance
	 		
bysort teachers_missing: eststo: estpost sum `x' if e(sample)==1 // eststo: estpost sum `x' // For total. Dont forget to add mtitle
eststo: estpost ttest `x' , by(teachers_missing) unequal
esttab est* using  $Results\summary\summary_groups.tex, replace  ///
        booktabs  fragment label  ///
		cells("mean(pattern(1 1 0) fmt(2)) sd(pattern(1 1  0) par)  b(star pattern(0 0  1) fmt(2)) p(pattern(0 0 0 1) par fmt(3))") /// //p-value
		mtitle("No Teachers data"  "Teachers data" "Mean-Diff") nolines ///
		collabels(, none)  eqlabels(, none) nonum  plain onecell ///
		stats ( N , fmt(%9.0fc) label ("N") ) 
		est clear
		
