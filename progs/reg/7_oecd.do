import excel "$Data\TFR_Europe\OECD.xlsx", sheet("Table") cellrange(B09:AL32) first clear
rename CombinedmeasureFertilityrate country
drop C AL
 
local year = 1990
foreach v of varlist D-AK {
    rename `v' TFR`year'
    local year = `year' + 1
}

reshape long TFR, i(country) j(year)


set scheme s2color

twoway ///
    (line TFR year if country=="Austria",          lwidth(medthin)) ///
    (line TFR year if country=="Belgium",          lwidth(medthin)) ///
    (line TFR year if country=="Czechia",          lwidth(medthin)) ///
    (line TFR year if country=="Denmark",          lwidth(medthin)) ///
    (line TFR year if country=="Estonia",          lwidth(medthin)) ///
    (line TFR year if country=="Finland",          lwidth(medthin)) ///
    (line TFR year if country=="France",           lwidth(medthin)) ///
    (line TFR year if country=="Germany",          lwidth(medthin)) ///
    (line TFR year if country=="Hungary",          lwidth(medthin)) ///
    (line TFR year if country=="Iceland",          lwidth(medthin)) ///
    (line TFR year if country=="Ireland",          lwidth(medthin)) ///
    (line TFR year if country=="Italy",            lwidth(medthin)) ///
    (line TFR year if country=="Latvia",           lwidth(medthin)) ///
    (line TFR year if country=="Lithuania",        lwidth(medthin)) ///
    (line TFR year if country=="Luxembourg",       lwidth(medthin)) ///
    (line TFR year if country=="Netherlands",      lwidth(medthin)) ///
    (line TFR year if country=="Poland",           lwidth(medthin)) ///
    (line TFR year if country=="Slovak Republic",  lwidth(medthin)) ///
    (line TFR year if country=="Slovenia",         lwidth(medthin)) ///
    (line TFR year if country=="Spain",            lwidth(thick) lcolor(black)) ///
    (line TFR year if country=="Sweden",           lwidth(medthin)) ///
    (line TFR year if country=="Switzerland",      lwidth(medthin)) ///
    (line TFR year if country=="United Kingdom",   lwidth(medthin)) ///
    , ///
    legend( ///
        position(6) ring(1) cols(8) size(tiny) region(lstyle(none) margin(small)) ///
		keygap(0.7) symysize(0.1) symxsize(6) ///
        label(1  "Austria") ///
        label(2  "Belgium") ///
        label(3  "Czechia") ///
        label(4  "Denmark") ///
        label(5  "Estonia") ///
        label(6  "Finland") ///
        label(7  "France") ///
        label(8  "Germany") ///
        label(9  "Hungary") ///
        label(10 "Iceland") ///
        label(11 "Ireland") ///
        label(12 "Italy") ///
        label(13 "Latvia") ///
        label(14 "Lithuania") ///
        label(15 "Luxembourg") ///
        label(16 "Netherlands") ///
        label(17 "Poland") ///
        label(18 "Slovak Republic") ///
        label(19 "Slovenia") ///
        label(20 "Spain") ///
        label(21 "Sweden") ///
        label(22 "Switzerland") ///
        label(23 "United Kingdom") ///
    ) ///
    graphregion(color(white)  margin(b)) ///
    xlabel(1990(5)2020, angle(0) labsize(vsmall)) ///
    ylabel(1(.5)2.5, angle(0) labsize(vsmall)) ///
    xscale(range(1990 2020)) ///
    ytitle("Total Fertility Rate", size(vsmall)) ///
    xtitle("Year", size(vsmall)) 
graph export $Results\graph_oecd.png,replace
