use  "$Output_data/dataset.dta", clear
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

*br if teachers==.
*
histogram teachers_pc, discrete width(10) kdens xtitle("") 

histogram teachers, discrete width(20) kdens xtitle("") 
graph export $Results\histogram_teachers.png, replace

histogram teachers_male, discrete width(20) kdens
graph export $Results\histogram_teachers_male.png, replace

