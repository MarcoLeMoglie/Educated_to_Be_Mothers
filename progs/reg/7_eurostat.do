import excel "$Data\TFR_Europe\Eurostat\Fertility_statistics_YB2025_SE_03_25.xlsx", sheet("Table 1") cellrange(A11:L47) clear

drop A B
rename C country
 
local year = 1960
foreach v of varlist D-G {
    rename `v' TFR`year'
    local year = `year' + 10
}
replace country = subinstr(country, "(¹)", "", .)


rename H TFR2003
rename I TFR2013
rename J TFR2021
rename K TFR2022
rename L TFR2023
tostring TFR2022,replace
reshape long TFR, i(country) j(year)

replace TFR ="" if TFR ==":"
destring TFR, replace
replace TFR = 2.78 if year ==1960 & country =="Spain"
replace TFR = 2.83 if year ==1970 & country =="Spain"
//Source: UN data(see statista folder)

twoway ///
    (line TFR year if country=="Albania",          lwidth(medthin)) ///
    (line TFR year if country=="Austria",          lwidth(medthin)) ///
    (line TFR year if country=="Belgium",          lwidth(medthin)) ///
    (line TFR year if country=="Bulgaria",         lwidth(medthin)) ///
    (line TFR year if country=="Croatia",          lwidth(medthin)) ///
    (line TFR year if country=="Cyprus",           lwidth(medthin)) ///
    (line TFR year if country=="Czechia",          lwidth(medthin)) ///
    (line TFR year if country=="Denmark",          lwidth(medthin)) ///
    (line TFR year if country=="Estonia",          lwidth(medthin)) ///
    (line TFR year if country=="Finland",          lwidth(medthin)) ///
    (line TFR year if country=="France",           lwidth(medthin)) ///
    (line TFR year if country=="Georgia",          lwidth(medthin)) ///
    (line TFR year if country=="Germany",          lwidth(medthin)) ///
    (line TFR year if country=="Greece",           lwidth(medthin)) ///
    (line TFR year if country=="Hungary",          lwidth(medthin)) ///
    (line TFR year if country=="Iceland",          lwidth(medthin)) ///
    (line TFR year if country=="Ireland",          lwidth(medthin)) ///
    (line TFR year if country=="Italy",            lwidth(medthin)) ///
    (line TFR year if country=="Latvia",           lwidth(medthin)) ///
    (line TFR year if country=="Liechtenstein",    lwidth(medthin)) ///
    (line TFR year if country=="Lithuania",        lwidth(medthin)) ///
    (line TFR year if country=="Luxembourg",       lwidth(medthin)) ///
    (line TFR year if country=="Malta",            lwidth(medthin)) ///
    (line TFR year if country=="Moldova",          lwidth(medthin)) ///
    (line TFR year if country=="Montenegro",       lwidth(medthin)) ///
    (line TFR year if country=="Netherlands",      lwidth(medthin)) ///
    (line TFR year if country=="North Macedonia",  lwidth(medthin)) ///
    (line TFR year if country=="Norway",           lwidth(medthin)) ///
    (line TFR year if country=="Poland",           lwidth(medthin)) ///
    (line TFR year if country=="Portugal",         lwidth(medthin)) ///
    (line TFR year if country=="Romania",          lwidth(medthin)) ///
    (line TFR year if country=="Serbia",           lwidth(medthin)) ///
    (line TFR year if country=="Slovakia",         lwidth(medthin)) ///
    (line TFR year if country=="Slovenia",         lwidth(medthin)) ///
    (line TFR year if country=="Spain",            lwidth(thick) lcolor(black)) ///
    (line TFR year if country=="Sweden",           lwidth(medthin)) ///
    (line TFR year if country=="Switzerland",      lwidth(medthin)) ///
    , ///
    legend( ///
        position(6) ring(1) cols(8) size(tiny) ///
        region(lstyle(none) margin(vsmall)) ///
        keygap(0.7) symysize(0.1) symxsize(6) ///
        label(1  "Albania") ///
        label(2  "Austria") ///
        label(3  "Belgium") ///
        label(4  "Bulgaria") ///
        label(5  "Croatia") ///
        label(6  "Cyprus") ///
        label(7  "Czechia") ///
        label(8  "Denmark") ///
        label(9  "Estonia") ///
        label(10 "Finland") ///
        label(11 "France") ///
        label(12 "Georgia") ///
        label(13 "Germany") ///
        label(14 "Greece") ///
        label(15 "Hungary") ///
        label(16 "Iceland") ///
        label(17 "Ireland") ///
        label(18 "Italy") ///
        label(19 "Latvia") ///
        label(20 "Liechtenstein") ///
        label(21 "Lithuania") ///
        label(22 "Luxembourg") ///
        label(23 "Malta") ///
        label(24 "Moldova") ///
        label(25 "Montenegro") ///
        label(26 "Netherlands") ///
        label(27 "North Macedonia") ///
        label(28 "Norway") ///
        label(29 "Poland") ///
        label(30 "Portugal") ///
        label(31 "Romania") ///
        label(32 "Serbia") ///
        label(33 "Slovakia") ///
        label(34 "Slovenia") ///
        label(35 "Spain") ///
        label(36 "Sweden") ///
        label(37 "Switzerland") ///
    ) ///
    graphregion(color(white) margin(b)) ///
    xlabel(1960(10)2020, angle(0) labsize(vsmall)) ///
    ylabel(1(.5)4, angle(0) labsize(vsmall)) ///
    xscale(range(1960 2020)) ///
    ytitle("Total Fertility Rate", size(vsmall)) ///
    xtitle("Year", size(vsmall))

graph export $Results\graph_eurostat.png,replace
