import excel "$Data\TFR_Europe\UN\undesa_pd_2019_world_fertility_dataset.xlsx", sheet("FERTILITY INDICATORS") cellrange(A8:F79781)   clear

keep if D =="TFR"
drop B C D
gen year = int(E)+1
drop E
rename F TFR

gen keep_eu = 0
foreach c in Albania Austria Belarus Belgium ///
    "Bosnia and Herzegovina" Bulgaria Croatia Cyprus Czechia Denmark Estonia ///
    Finland France Georgia Germany Greece Hungary Iceland Ireland Italy Latvia ///
    Lithuania Luxembourg Malta Montenegro Netherlands Norway Poland Portugal ///
    "Republic of Moldova" Romania "Russian Federation" Serbia Slovakia ///
    Slovenia Spain Sweden Switzerland "TFYR Macedonia" Ukraine ///
    "United Kingdom" {

    replace keep_eu = 1 if A == "`c'"
}
keep if keep_eu
drop keep_eu
rename A country
keep if year <=2018



twoway ///
    (line TFR year if country=="Albania",                  lwidth(medthin)) ///
    (line TFR year if country=="Austria",                  lwidth(medthin)) ///
    (line TFR year if country=="Belarus",                  lwidth(medthin)) ///
    (line TFR year if country=="Belgium",                  lwidth(medthin)) ///
    (line TFR year if country=="Bosnia and Herzegovina",   lwidth(medthin)) ///
    (line TFR year if country=="Bulgaria",                 lwidth(medthin)) ///
    (line TFR year if country=="Croatia",                  lwidth(medthin)) ///
    (line TFR year if country=="Cyprus",                   lwidth(medthin)) ///
    (line TFR year if country=="Czechia",                  lwidth(medthin)) ///
    (line TFR year if country=="Denmark",                  lwidth(medthin)) ///
    (line TFR year if country=="Estonia",                  lwidth(medthin)) ///
    (line TFR year if country=="Finland",                  lwidth(medthin)) ///
    (line TFR year if country=="France",                   lwidth(medthin)) ///
    (line TFR year if country=="Georgia",                  lwidth(medthin)) ///
    (line TFR year if country=="Germany",                  lwidth(medthin)) ///
    (line TFR year if country=="Greece",                   lwidth(medthin)) ///
    (line TFR year if country=="Hungary",                  lwidth(medthin)) ///
    (line TFR year if country=="Iceland",                  lwidth(medthin)) ///
    (line TFR year if country=="Ireland",                  lwidth(medthin)) ///
    (line TFR year if country=="Italy",                    lwidth(medthin)) ///
    (line TFR year if country=="Latvia",                   lwidth(medthin)) ///
    (line TFR year if country=="Lithuania",                lwidth(medthin)) ///
    (line TFR year if country=="Luxembourg",               lwidth(medthin)) ///
    (line TFR year if country=="Malta",                    lwidth(medthin)) ///
    (line TFR year if country=="Montenegro",               lwidth(medthin)) ///
    (line TFR year if country=="Netherlands",              lwidth(medthin)) ///
    (line TFR year if country=="Norway",                   lwidth(medthin)) ///
    (line TFR year if country=="Poland",                   lwidth(medthin)) ///
    (line TFR year if country=="Portugal",                 lwidth(medthin)) ///
    (line TFR year if country=="Republic of Moldova",      lwidth(medthin)) ///
    (line TFR year if country=="Romania",                  lwidth(medthin)) ///
    (line TFR year if country=="Russian Federation",       lwidth(medthin)) ///
    (line TFR year if country=="Serbia",                   lwidth(medthin)) ///
    (line TFR year if country=="Slovakia",                 lwidth(medthin)) ///
    (line TFR year if country=="Slovenia",                 lwidth(medthin)) ///
    (line TFR year if country=="Spain",                    lwidth(thick) lcolor(black)) ///
    (line TFR year if country=="Sweden",                   lwidth(medthin)) ///
    (line TFR year if country=="Switzerland",              lwidth(medthin)) ///
    (line TFR year if country=="TFYR Macedonia",           lwidth(medthin)) ///
    (line TFR year if country=="Ukraine",                  lwidth(medthin)) ///
    (line TFR year if country=="United Kingdom",           lwidth(medthin)) ///
    , ///
    legend( ///
        position(6) ring(1) cols(8) size(tiny) ///
        region(lstyle(none) margin(small)) ///
        keygap(0.7) symysize(0.1) symxsize(6) ///
        label(1  "Albania") ///
        label(2  "Austria") ///
        label(3  "Belarus") ///
        label(4  "Belgium") ///
        label(5  "Bosnia & Herz.") ///
        label(6  "Bulgaria") ///
        label(7  "Croatia") ///
        label(8  "Cyprus") ///
        label(9  "Czechia") ///
        label(10 "Denmark") ///
        label(11 "Estonia") ///
        label(12 "Finland") ///
        label(13 "France") ///
        label(14 "Georgia") ///
        label(15 "Germany") ///
        label(16 "Greece") ///
        label(17 "Hungary") ///
        label(18 "Iceland") ///
        label(19 "Ireland") ///
        label(20 "Italy") ///
        label(21 "Latvia") ///
        label(22 "Lithuania") ///
        label(23 "Luxembourg") ///
        label(24 "Malta") ///
        label(25 "Montenegro") ///
        label(26 "Netherlands") ///
        label(27 "Norway") ///
        label(28 "Poland") ///
        label(29 "Portugal") ///
        label(30 "Moldova") ///
        label(31 "Romania") ///
        label(32 "Russia") ///
        label(33 "Serbia") ///
        label(34 "Slovakia") ///
        label(35 "Slovenia") ///
        label(36 "Spain") ///
        label(37 "Sweden") ///
        label(38 "Switzerland") ///
        label(39 "TFYR Macedonia") ///
        label(40 "Ukraine") ///
        label(41 "United Kingdom") ///
    ) ///
    graphregion(color(white) margin(b)) ///
    xlabel(1951(10)2011 2018, angle(0) labsize(vsmall)) ///
    ylabel(1(.5)7, angle(0) labsize(vsmall)) ///
    xscale(range(1951 2018) noextend) ///
    ytitle("Total Fertility Rate", size(vsmall)) ///
    xtitle("Year", size(vsmall))
	graph export $Results\graph_UN.png,replace
