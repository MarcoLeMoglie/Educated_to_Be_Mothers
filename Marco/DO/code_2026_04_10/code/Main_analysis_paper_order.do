version 17.0
clear all
set more off

/*
===============================================================================
MAIN ANALYSIS IN PAPER ORDER
-------------------------------------------------------------------------------
This is the package's preferred single-file replication script.

This file is organized in the same order as the current manuscript:
1. main-text tables and figures;
2. appendix tables and figures.

The purpose is twofold:
- make the code readable in the same order as the paper;
- keep the empirical logic easy to audit object by object.

The original and revision source files are still preserved under:
- code/original/
- code/revisions/

This paper-order file reuses the logic, but rearranges it into a cleaner and
more explicit structure that follows the current manuscript.
===============================================================================
*/

*do "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/Marco/DO/code_2026_04_10/code/00_globals.do"

capture log close
log using "$rep_logs/Main_analysis_paper_order.log", replace text

* Cold-start logic:
* if the package already contains the final labeled analysis files, use them
* directly; rebuild only if they are missing.
capture confirm file "$rep_data/final_cis_analysis.dta"
local has_cis = (_rc == 0)
capture confirm file "$rep_data/final_census_analysis.dta"
local has_census = (_rc == 0)
capture confirm file "$rep_data/final_macro_panel_analysis.dta"
local has_macro = (_rc == 0)

if !`has_cis' | !`has_census' | !`has_macro' {
    do "$rep_prep/01_build_final_analysis_data.do"
}

capture mkdir "$rep_main"
capture mkdir "$rep_appendix"

* Reghdfe compatibility switch. Keep historical version 5 for exact
* replication of the current draft. If you prefer the latest installed
* reghdfe behavior for exploratory reruns, set the local below to empty.
local reghdfe_compat "version(5)"

* ----------------------------------------------------------------------------
* Helper program: CIS final analysis sample
* ----------------------------------------------------------------------------
* This helper standardizes the exact repeated-cross-section sample used in the
* paper's survey-based analyses. Every time we call it, we reopen the final
* package dataset so that later commands never depend on whatever variables or
* temporary edits were left behind by the previous section.
*
* Restrictions:
* - women only, because the main CIS fertility analysis is female-specific;
* - birth cohorts up to 1950, which is the estimation window used in the paper.
capture program drop load_cis_final
program define load_cis_final
    use "$rep_data/final_cis_analysis.dta", clear
    keep if female == 1
    keep if year_birth <= 1950
end

* ----------------------------------------------------------------------------
* Helper program: Census final analysis sample
* ----------------------------------------------------------------------------
* This helper does the same for the pooled 1991/2011 census microdata. The
* paper keeps only women and the 1920-1950 birth window, so every appendix
* census table begins from the same harmonized subset.
capture program drop load_census_final
program define load_census_final
    use "$rep_data/final_census_analysis.dta", clear
    keep if sexo == 6
    keep if inrange(anac, 1920, 1950)
end

* ----------------------------------------------------------------------------
* Helper program: Macro final analysis sample
* ----------------------------------------------------------------------------
* This helper reconstructs the derived variables that are repeatedly used by
* the aggregate design:
* - female and male treatment intensity in 1940;
* - the post-1945 treatment interactions;
* - the age-composition controls used in the preferred specification.
*
* Rebuilding these variables inside one helper keeps the later macro sections
* readable and ensures that each macro table starts from the same baseline.
capture program drop load_macro_final
program define load_macro_final
    use "$rep_data/final_macro_panel_analysis.dta", clear
    capture confirm variable alive
    if _rc != 0 {
        gen alive = alive_birth
    }

    * Main treatment intensity in the macro design:
    * the share of girls and boys aged 0-14 in 1940.
    gen popsharewomen_agegroup1 = ///
        (popsharewomen_agegroup1_1940 + popsharewomen_agegroup2_1940) * 100
    gen popsharemen_agegroup1 = ///
        (popsharemen_agegroup1_1940 + popsharemen_agegroup2_1940) * 100

    gen sum1 = popsharewomen_agegroup1
    gen sum2 = popsharemen_agegroup1
    gen interaction  = post * sum1
    gen interaction2 = post * sum2

    label var alive "Births"
    label var interaction  "Treat (W) X Post 1945"
    label var interaction2 "Treat (M) X Post 1945"

    * Preferred composition controls: separate flexible controls for ages 15-24,
    * 25-34, and 35-44 by decade.
    gen flag4_3 = .
    gen flag4_4 = .
    gen flag4_5 = .

    replace flag4_3 = ln(popwomen_agegroup3_1930) if year >= 1930 & year < 1940
    replace flag4_3 = ln(popwomen_agegroup3_1940) if year >= 1940 & year < 1950
    replace flag4_3 = ln(popwomen_agegroup3_1950) if year >= 1950 & year < 1960
    replace flag4_3 = ln(popwomen_agegroup3_1960) if year >= 1960 & year < 1970
    replace flag4_3 = ln(popwomen_agegroup3_1970) if year >= 1970 & year < .

    replace flag4_4 = ln(popwomen_agegroup4_1930) if year >= 1930 & year < 1940
    replace flag4_4 = ln(popwomen_agegroup4_1940) if year >= 1940 & year < 1950
    replace flag4_4 = ln(popwomen_agegroup4_1950) if year >= 1950 & year < 1960
    replace flag4_4 = ln(popwomen_agegroup4_1960) if year >= 1960 & year < 1970
    replace flag4_4 = ln(popwomen_agegroup4_1970) if year >= 1970 & year < .

    replace flag4_5 = ln(popwomen_agegroup5_1930) if year >= 1930 & year < 1940
    replace flag4_5 = ln(popwomen_agegroup5_1940) if year >= 1940 & year < 1950
    replace flag4_5 = ln(popwomen_agegroup5_1950) if year >= 1950 & year < 1960
    replace flag4_5 = ln(popwomen_agegroup5_1960) if year >= 1960 & year < 1970
    replace flag4_5 = ln(popwomen_agegroup5_1970) if year >= 1970 & year < .
end

* ----------------------------------------------------------------------------
* Helper program: write baseline census table in the exact two-column layout
* used by the paper.
* ----------------------------------------------------------------------------
* The census baseline appears both in the main text and in the appendix. To
* avoid accidental divergence between the two locations, we write the table
* once and then copy the same LaTeX fragment into the appendix filename used by
* the manuscript.
capture program drop write_census_baseline_table
program define write_census_baseline_table
    load_census_final

    * Column 1: extensive-margin fertility ("has any children").
    quietly reghdfe kids2 treat_2 treat_3 [aw=weight2], ///
        a(cmun##i.age_c##year) cluster(year#anac) `reghdfe_compat'
    quietly sum kids2 if e(sample) [aw=weight2], meanonly
    local mean_kids = string(r(mean), "%9.2f")
    outreg2 using "$rep_main/table_census_kids.tex", replace tex(frag) label ///
        keep(treat_2 treat_3) nocons ctitle("Kids") ///
        addtext(Year FE, YES, Residence FE, YES, Age class FE, YES, Mean of depvar, `mean_kids') nonotes

    * Column 2: completed fertility measured as the number of children.
    quietly reghdfe nhijos treat_2 treat_3 [aw=weight2], ///
        a(cmun##i.age_c##year) cluster(year#anac) `reghdfe_compat'
    quietly sum nhijos if e(sample) [aw=weight2], meanonly
    local mean_nhijos = string(r(mean), "%9.2f")
    outreg2 using "$rep_main/table_census_kids.tex", append tex(frag) label ///
        keep(treat_2 treat_3) nocons ctitle("N. kids") ///
        addtext(Year FE, YES, Residence FE, YES, Age class FE, YES, Mean of depvar, `mean_nhijos') nonotes


end

* ----------------------------------------------------------------------------
* Helper program: write summary-statistics rows in LaTeX format.
* ----------------------------------------------------------------------------
* This helper computes mean, standard deviation, minimum, maximum, and sample
* size for one variable and writes a single table row to an already-open file
* handle. It is used for Table A1 so that the summary table is generated from
* scratch from the final package datasets instead of copied from a static tex
* fragment.
capture program drop write_sumstat_row
program define write_sumstat_row
    syntax varname, HANDLE(name) LABEL(string)

    quietly count if !missing(`varlist')
    local n = r(N)

    quietly summarize `varlist' if !missing(`varlist')
    local mean : display %9.3f r(mean)
    local sd   : display %9.3f r(sd)
    local min  : display %9.2f r(min)
    local max  : display %9.2f r(max)
    local nfmt : display %15.0fc `n'

    file write `handle' "`label' & `mean'& `sd'& `min'& `max'& `nfmt'\\\\" _n
end

* ----------------------------------------------------------------------------
* Helper program: generate Table A1 from the package datasets.
* ----------------------------------------------------------------------------
capture program drop write_summary_table_A1
program define write_summary_table_A1
    file open sumtab using "$rep_main/summary_panels.tex", write replace
    file write sumtab "\begin{table}[htbp]\centering" _n
    file write sumtab "\caption{Summary Statistics}" _n
    file write sumtab "\begin{tabular}{l*{5}{D{.}{.}{-1}}}" _n
    file write sumtab "\toprule" _n
    file write sumtab "& \multicolumn{1}{c}{Mean} & \multicolumn{1}{c}{Std. Dev.} & \multicolumn{1}{c}{Min} & \multicolumn{1}{c}{Max} & \multicolumn{1}{c}{N} \\\\" _n
    file write sumtab "\midrule" _n

    * Panel A: CIS data, using the same female cohort window as the survey analysis.
    file write sumtab "\multicolumn{6}{l}{\textbf{Panel A: CIS Data}} \\\\" _n
    load_cis_final
    write_sumstat_row kids, handle(sumtab) label("Kids")
    write_sumstat_row nkids, handle(sumtab) label("N. kids")
    write_sumstat_row ideal_fam_equal, handle(sumtab) label("Gender roles: Equal")
    write_sumstat_row husb_lesshouseworks, handle(sumtab) label("Husband less housework")
    write_sumstat_row stab_sharehousework, handle(sumtab) label("Couple's stability: Shared housework")
    write_sumstat_row stab_kids, handle(sumtab) label("Couple's stability: Kids")
    write_sumstat_row realwoman_kids, handle(sumtab) label("Real woman has kids")
    write_sumstat_row women_work, handle(sumtab) label("Woman works")
    write_sumstat_row stab_wifework, handle(sumtab) label("Couple's stability: Wife works")
    write_sumstat_row pro_abort_church, handle(sumtab) label("Agree with Church: Abortion")
    write_sumstat_row pro_art_fert, handle(sumtab) label("Agree with Church: Artificial procreation")
    write_sumstat_row pro_contracep, handle(sumtab) label("Agree with Church: Contraception")

    file write sumtab "\addlinespace" _n

    * Panel B: census microdata in the same sample used by the census regressions.
    file write sumtab "\multicolumn{6}{l}{\textbf{Panel B: Census Microdata}} \\\\" _n
    load_census_final
    write_sumstat_row kids2, handle(sumtab) label("Kids")
    write_sumstat_row nhijos, handle(sumtab) label("N. kids")

    file write sumtab "\addlinespace" _n

    * Panel C: macro panel data.
    file write sumtab "\multicolumn{6}{l}{\textbf{Panel C: Macro level data}} \\\\" _n
    load_macro_final
    write_sumstat_row alive, handle(sumtab) label("Births")

    file write sumtab "\bottomrule" _n
    file write sumtab "\end{tabular}" _n
    file write sumtab "\end{table}" _n
    file close sumtab
end

* ============================================================================
* PART I. MAIN TEXT
* ============================================================================
* Figure 1 in the paper ("Cover and excerpt from Leedme, ninas. Segunda parte")
* is a static manuscript illustration and is therefore not generated here.

* ----------------------------------------------------------------------------
* MAIN TABLE 1. Baseline CIS fertility estimates
* Paper object: table_baseline
* ----------------------------------------------------------------------------
load_cis_final


* Panel 1: extensive-margin fertility ("Kids").
label var kids "Kids"
quietly sum kids if treat == 0, meanonly
local p_kids = round(r(mean), .01)

quietly reghdfe kids treat_2 treat_3, a(i.year) cluster(year#i.year_birth) `reghdfe_compat'
outreg2 using "$rep_main/table_cis_kids.tex", replace tex(frag) label nonotes ///
    addtext(Year FE, YES, Mun. FE, NO, Age class FE, NO, Year X Age group X Residence FE, NO, Mean of depvar, `p_kids') ///
    keep(treat_2 treat_3) nocons

quietly reghdfe kids treat_2 treat_3, a(i.year i.id) cluster(year#i.year_birth) `reghdfe_compat'
outreg2 using "$rep_main/table_cis_kids.tex", append tex(frag) label nonotes ///
    addtext(Year FE, YES, Mun. FE, YES, Age class FE, NO, Year X Age group X Residence FE, NO, Mean of depvar, `p_kids') ///
    keep(treat_2 treat_3) nocons

quietly reghdfe kids treat_2 treat_3, a(i.year i.id age_c) cluster(year#i.year_birth) `reghdfe_compat'
outreg2 using "$rep_main/table_cis_kids.tex", append tex(frag) label nonotes ///
    addtext(Year FE, YES, Mun. FE, YES, Age class FE, YES, Year X Age group X Residence FE, NO, Mean of depvar, `p_kids') ///
    keep(treat_2 treat_3) nocons

quietly reghdfe kids treat_2 treat_3, a(i.year##i.id##age_c) cluster(year#i.year_birth) `reghdfe_compat'
outreg2 using "$rep_main/table_cis_kids.tex", append tex(frag) label nonotes ///
    addtext(Year FE, YES, Mun. FE, YES, Age class FE, YES, Year X Age group X Residence FE, YES, Mean of depvar, `p_kids') ///
    keep(treat_2 treat_3) nocons

* Panel 2: completed fertility count ("N. kids").
label var nkids "N. kids"
quietly sum nkids if treat == 0, meanonly
local p_nkids = round(r(mean), .01)

quietly reghdfe nkids treat_2 treat_3, a(i.year) cluster(year#i.year_birth) `reghdfe_compat'
outreg2 using "$rep_main/table_cis_kids.tex", append tex(frag) label nonotes ///
    addtext(Year FE, YES, Mun. FE, NO, Age class FE, NO, Year X Age group X Residence FE, NO, Mean of depvar, `p_nkids') ///
    keep(treat_2 treat_3) nocons

quietly reghdfe nkids treat_2 treat_3, a(i.year i.id) cluster(year#i.year_birth) `reghdfe_compat'
outreg2 using "$rep_main/table_cis_kids.tex", append tex(frag) label nonotes ///
    addtext(Year FE, YES, Mun. FE, YES, Age class FE, NO, Year X Age group X Residence FE, NO, Mean of depvar, `p_nkids') ///
    keep(treat_2 treat_3) nocons

quietly reghdfe nkids treat_2 treat_3, a(i.year i.id age_c) cluster(year#i.year_birth) `reghdfe_compat'
outreg2 using "$rep_main/table_cis_kids.tex", append tex(frag) label nonotes ///
    addtext(Year FE, YES, Mun. FE, YES, Age class FE, YES, Year X Age group X Residence FE, NO, Mean of depvar, `p_nkids') ///
    keep(treat_2 treat_3) nocons

quietly reghdfe nkids treat_2 treat_3, a(i.year##i.id##age_c) cluster(year#i.year_birth) `reghdfe_compat'
outreg2 using "$rep_main/table_cis_kids.tex", append tex(frag) label nonotes ///
    addtext(Year FE, YES, Mun. FE, YES, Age class FE, YES, Year X Age group X Residence FE, YES, Mean of depvar, `p_nkids') ///
    keep(treat_2 treat_3) nocons

* ----------------------------------------------------------------------------
* MAIN FIGURE 2. CIS event study for completed fertility
* Paper object: baseline_event_study
* ----------------------------------------------------------------------------
load_cis_final

* The event-study figure replaces broad treated-cohort bins with individual
* cohort dummies. Cohort 1929/1930 is omitted as the normalization point, so
* the plotted coefficients show how completed fertility evolves relative to the
* last fully untreated cohorts under the preferred CIS fixed effects.
quietly tab year_birth, gen(year_birth_)

forvalues i = 1/51 {
    local lab = 1919 + `i'
    capture label var year_birth_`i' "`lab'"
}
quietly reghdfe nkids year_birth_1-year_birth_9 o.year_birth_10 year_birth_11-year_birth_31, ///
    a(i.year#age_c#id) cluster(year#i.year_birth) `reghdfe_compat'
coefplot, keep(year_birth_*) vertical base omitted ///
    yline(0, lc(red) lp(dash)) xline(10, lcolor(blue) lpattern(dash)) ///
    xline(20, lcolor(green) lpattern(dash)) ms(m) ///
    ylabel(, angle(horizontal) labsize(tiny)) legend(off) ///
    graphregion(color(white)) msize(vsmall) levels(99 95 90) ///
    ytitle("Number of kids", size(vsmall)) scheme(s2mono) xtick(1(2)31) ///
    xlabel(, angle(45) labsize(tiny))
graph export "$rep_main/nkids_female.pdf", replace

* ----------------------------------------------------------------------------
* MAIN FIGURE 3. Beliefs figure
* Paper object: cis
* ----------------------------------------------------------------------------
load_cis_final

* For each attitudes variable we estimate two simple cohort comparisons:
* - partially treated cohorts versus untreated;
* - fully treated cohorts versus untreated.
*
* We use `preserve/restore` because `coefplot` is easiest to manage when the
* same temporary regressor name ("outcome") is reused across panels.
foreach var in ideal_fam_equal husb_lesshouseworks stab_sharehousework ///
               stab_kids realwoman_kids import_work2 stab_wifework ///
               pro_abort_church pro_art_fert pro_contracep {
    preserve
    rename treat_2 outcome
    eststo est_`var': reghdfe `var' outcome treat_3 if year_birth <= 1950, ///
        a(i.id) vce(r)
    restore

    preserve
    rename treat_3 outcome
    eststo est_`var'_3: reghdfe `var' treat_2 outcome if year_birth <= 1950, ///
        a(i.id) vce(r)
    restore
}

coefplot  (est_ideal_fam_equal, aseq(ideal_fam_equal) ///
    \ est_husb_lesshouseworks, aseq(husb_lesshouseworks) ///
    \ est_stab_sharehousework, aseq(stab_sharehousework) ///
    \ est_stab_kids, aseq(stab_kids) ///
    \ est_realwoman_kids, aseq(realwoman_kids) ///
    \ est_import_work2, aseq(import_work2) ///
    \ est_stab_wifework, aseq(stab_wifework) ///
    \ est_pro_abort_church, aseq(pro_abort_church) ///
    \ est_pro_art_fert, aseq(pro_art_fert) ///
    \ est_pro_contracep, aseq(pro_contracep)), ///
    by(, graphregion(color(white))) subtitle(, bc(white)) bylabel(Partially treated (1930/38)) ///
    || (est_ideal_fam_equal_3, aseq(ideal_fam_equal) ///
    \ est_husb_lesshouseworks_3, aseq(husb_lesshouseworks) ///
    \ est_stab_sharehousework_3, aseq(stab_sharehousework) ///
    \ est_stab_kids_3, aseq(stab_kids) ///
    \ est_realwoman_kids_3, aseq(realwoman_kids) ///
    \ est_import_work2_3, aseq(import_work2) ///
    \ est_stab_wifework_3, aseq(stab_wifework) ///
    \ est_pro_abort_church_3, aseq(pro_abort_church) ///
    \ est_pro_art_fert_3, aseq(pro_art_fert) ///
    \ est_pro_contracep_3, aseq(pro_contracep)), ///
    by(, graphregion(color(white))) bylabel(Fully treated (1939/50)) ///
    || , ///
    group(ideal_fam_equal husb_lesshouseworks stab_sharehousework = "{bf:Roles in the family}" ///
          stab_kids realwoman_kids = "{bf:Motherhood}" ///
          import_work2 stab_wifework = "{bf:Working}" ///
          pro_abort_church pro_art_fert pro_contracep = "{bf:Church}", ///
          labgap(0) labs(small)) ///
    xline(0, lp(dash)) pstyle(p10) pstyle(p23) aseq swapnames ci(95 90) ///
    msize(.5) keep(outcome) ///
    ylabel(1 "Gender roles: Equal" ///
           2 "Husband less housework" ///
           3 "Couple's stability: Shared housework" ///
           5 "Couple's stability: Kids" ///
           6 "Real woman has kids" ///
           8 "Importance of working for women" ///
           9 "Couple's stability: Wife works" ///
           11 "Agree with Church: Abortion" ///
           12 "Agree with Church: Artificial procreation" ///
           13 "Agree with Church: Contraception", labsize(vsmall)) ///
    yscale(noline reverse) xlabel(, labsize(vsmall))
graph export "$rep_main/cis.pdf", replace

* ----------------------------------------------------------------------------
* MAIN TABLE 2. Macro baseline DiD
* Paper object: table_macro
* ----------------------------------------------------------------------------
load_macro_final
quietly sum alive if year < 1945 & year > 1939, meanonly
local mean_depvar = r(mean)

* The macro table follows the paper's four baseline columns:
* 1. female treatment only, no province-year FE;
* 2. female treatment only, preferred province-year FE;
* 3. female + male treatment controls, no province-year FE;
* 4. female + male treatment controls, preferred province-year FE.
*
* "interaction" is Treat (W) X Post 1945. "interaction2" is the male analogue.
quietly reghdfe alive interaction 1.post##c.sum1 flag4_3 flag4_4 flag4_5, ///
    a(i.id i.year) cluster(id)
outreg2 using "$rep_main/table_reg_female_trends.tex", replace tex(frag) label nonotes ///
    addtext(Unit FE, YES, Year FE, YES, Prov. X Year FE, NO) ///
    ctitle("Births") keep(interaction) nocons addstat(Mean of depvar, `mean_depvar')

quietly reghdfe alive interaction 1.post##c.sum1 flag4_3 flag4_4 flag4_5, ///
    a(i.id i.year#i.codprov) cluster(id)
outreg2 using "$rep_main/table_reg_female_trends.tex", append tex(frag) label nonotes ///
    addtext(Unit FE, YES, Year FE, YES, Prov. X Year FE, YES) ///
    ctitle("Births") keep(interaction) nocons addstat(Mean of depvar, `mean_depvar')

quietly reghdfe alive interaction interaction2 1.post##c.sum1 1.post##c.sum2 ///
    flag4_3 flag4_4 flag4_5, a(i.id i.year) cluster(id)
outreg2 using "$rep_main/table_reg_female_trends.tex", append tex(frag) label nonotes ///
    addtext(Unit FE, YES, Year FE, YES, Prov. X Year FE, NO) ///
    ctitle("Births") keep(interaction interaction2) nocons addstat(Mean of depvar, `mean_depvar')

quietly reghdfe alive interaction interaction2 1.post##c.sum1 1.post##c.sum2 ///
    flag4_3 flag4_4 flag4_5, a(i.id i.year#i.codprov) cluster(id)
outreg2 using "$rep_main/table_reg_female_trends.tex", append tex(frag) label nonotes ///
    addtext(Unit FE, YES, Year FE, YES, Prov. X Year FE, YES) ///
    ctitle("Births") keep(interaction interaction2) nocons addstat(Mean of depvar, `mean_depvar')

* ----------------------------------------------------------------------------
* MAIN FIGURE 4. Macro event study
* Paper object: event_macro
* ----------------------------------------------------------------------------
load_macro_final

* This figure estimates a dynamic version of the aggregate design by allowing
* the female and male treatment shares to interact with each year separately.
* The omitted year is 1945, so the plotted female series traces deviations
* relative to the reform turning point.

	
quietly reghdfe alive b1945.year##c.sum1 b1945.year##c.sum2 flag4_3 flag4_4 flag4_5, ///
    a(i.id i.year#i.codprov) cluster(id)
coefplot, keep(*.year#c.sum1) vertical base omitted ///
    yline(0, lc(black) lp(dash)) xline(16, lcolor(blue) lpattern(dash)) ///
    xline(25, lcolor(red%25)) xline(35, lcolor(red%50)) xline(45, lcolor(red%75)) ///
    ms(m) ylabel(, angle(horizontal) labsize(tiny)) legend(off) ///
    graphregion(color(white)) msize(vsmall) levels(99 95 90) ///
    ytitle("Alive births", size(vsmall)) scheme(s2mono) ///
    xlabel(, angle(45) labsize(tiny)) ///
coeflabels( ///
1930.year#c.sum1= "1930" ///  
1931.year#c.sum1= "1931" ///
1932.year#c.sum1= "1932" ///
1933.year#c.sum1= "1933" ///
1934.year#c.sum1= "1934" ///
1935.year#c.sum1= "1935" ///
1936.year#c.sum1= "1936" ///
1937.year#c.sum1= "1937" ///
1938.year#c.sum1= "1938" ///
1939.year#c.sum1= "1939" ///
1940.year#c.sum1= "1940" ///
1941.year#c.sum1= "1941" ///
1942.year#c.sum1= "1942" ///
1943.year#c.sum1= "1943" ///
1944.year#c.sum1= "1944" ///
1945.year#c.sum1= "1945" ///
1946.year#c.sum1= "1946" ///
1947.year#c.sum1= "1947" ///
1948.year#c.sum1= "1948" ///
1949.year#c.sum1= "1949" ///
1950.year#c.sum1= "1950" ///
1951.year#c.sum1= "1951" ///
1952.year#c.sum1= "1952" ///
1953.year#c.sum1= "1953" ///
1954.year#c.sum1= "1954" ///
1955.year#c.sum1= "1955" ///
1956.year#c.sum1= "1956" ///
1957.year#c.sum1= "1957" ///
1958.year#c.sum1= "1958" ///
1959.year#c.sum1= "1959" ///
1960.year#c.sum1= "1960" ///
1961.year#c.sum1= "1961" ///
1962.year#c.sum1= "1962" ///
1963.year#c.sum1= "1963" ///
1964.year#c.sum1= "1964" ///
1965.year#c.sum1= "1965" ///
1966.year#c.sum1= "1966" ///
1967.year#c.sum1= "1967" ///
1968.year#c.sum1= "1968" ///
1969.year#c.sum1= "1969" ///
1970.year#c.sum1= "1970" ///
1971.year#c.sum1= "1971" ///
1972.year#c.sum1= "1972" ///
1973.year#c.sum1= "1973" ///
1974.year#c.sum1= "1974" ///
1975.year#c.sum1= "1975" ///
1976.year#c.sum1= "1976" ///
1977.year#c.sum1= "1977" ///
1978.year#c.sum1= "1978" ///
1979.year#c.sum1= "1979" ///
1980.year#c.sum1= "1980" ///
1981.year#c.sum1= "1981" ///
1982.year#c.sum1= "1982" ///
1983.year#c.sum1= "1983" ///
1984.year#c.sum1= "1984" ///
1985.year#c.sum1= "1985" ///
) 
graph export "$rep_main/event_1940_cont_alive_birth1.pdf", replace

* ============================================================================
* PART II. APPENDIX
* ============================================================================

* ----------------------------------------------------------------------------
* TABLE A1. Summary statistics
* ----------------------------------------------------------------------------
* Table A1 is generated from scratch from the final package datasets so that
* the replication file does not rely on a pre-written LaTeX fragment.
write_summary_table_A1

* ----------------------------------------------------------------------------
* TABLE A2. Questions from CIS
* ----------------------------------------------------------------------------
* This longtable is a static questionnaire inventory written directly in the
* manuscript. It is not generated by the replication code because it is
* documentation of survey questions rather than an empirical output.

* ----------------------------------------------------------------------------
* TABLE B3. CIS cluster robustness
* ----------------------------------------------------------------------------
load_cis_final

* This table keeps the preferred CIS specification fixed and changes only the
* variance estimator:
* - cohort clustering;
* - two-way clustering by survey year and residence.
foreach var in kids nkids {
    quietly sum `var' if treat == 0, meanonly
    local p = round(r(mean), .01)
    if "`var'" == "kids" {
        label var `var' "Kids"
        local mode replace
    }
    else {
        label var `var' "N. kids"
        local mode append
    }

    quietly reghdfe `var' treat_2 treat_3 if year_birth <= 1950, ///
        a(i.year##i.id##age_c) cluster(year_birth) `reghdfe_compat'
    outreg2 using "$rep_main/table_cis_kids_cluster.tex", `mode' tex(frag) label nonotes ///
        addtext(Year FE, YES, Mun. FE, YES, Age class FE, YES, ///
                Year X Age group X Residence FE, YES, Clusters, Cohort, Mean of depvar, `p') ///
        keep(treat_2 treat_3) nocons

    quietly reghdfe `var' treat_2 treat_3 if year_birth <= 1950, ///
        a(i.year##i.id##age_c) vce(cluster year id) `reghdfe_compat'
    outreg2 using "$rep_main/table_cis_kids_cluster.tex", append tex(frag) label nonotes ///
        addtext(Year FE, YES, Mun. FE, YES, Age class FE, YES, ///
                Year X Age group X Residence FE, YES, Clusters, Two-way, Mean of depvar, `p') ///
        keep(treat_2 treat_3) nocons
}

* ----------------------------------------------------------------------------
* TABLE B4. Census baseline table
* ----------------------------------------------------------------------------
write_census_baseline_table

* ----------------------------------------------------------------------------
* TABLE B5. Law 56 horse-race
* ----------------------------------------------------------------------------
load_cis_final

* The horse-race table asks whether the cohort pattern attributed to the 1945
* school reform is simply picking up later differential exposure to the legal
* environment created by Law 56/1961. Column 1 is the baseline; column 2 adds
* the cohort-specific share of ages 20-35 lived after 1961.
quietly sum nkids if treat == 0, meanonly
local p_nkids = round(r(mean), .01)

quietly reghdfe nkids treat_2 treat_3, ///
    a(i.year##i.id##age_c) cluster(year#i.year_birth) `reghdfe_compat'
outreg2 using "$rep_tables/table_selected_law56_nkids.tex", replace tex(frag) label ///
    keep(treat_2 treat_3) nocons ctitle("N. kids") ///
    addtext(Specification, Baseline, Survey-year FE, YES, Residence FE, YES, Age-class FE, YES, ///
            Survey-year X Residence X Age-class FE, YES, Law 56 exposure control, NO, Mean of depvar, `p_nkids') nonotes

quietly reghdfe nkids treat_2 treat_3 law56_share_20_35, ///
    a(i.year##i.id##age_c) cluster(year#i.year_birth) `reghdfe_compat'
outreg2 using "$rep_tables/table_selected_law56_nkids.tex", append tex(frag) label ///
    keep(treat_2 treat_3 law56_share_20_35) nocons ctitle("N. kids") ///
    addtext(Specification, Baseline + Law 56 exposure, Survey-year FE, YES, Residence FE, YES, Age-class FE, YES, ///
            Survey-year X Residence X Age-class FE, YES, Law 56 exposure control, YES, Mean of depvar, `p_nkids') nonotes

* ----------------------------------------------------------------------------
* TABLE B6. Birthplace / movers-stayers
* ----------------------------------------------------------------------------
load_census_final

* This table addresses a micro assignment concern: perhaps current residence is
* an imperfect proxy for the relevant place of exposure. The four columns show:
* - the baseline census specification;
* - the same with birthplace FE added;
* - the same restricted to movers;
* - the same restricted to stayers.
quietly sum nhijos if treat == 0, meanonly
local p_nhijos = r(mean)
quietly reghdfe nhijos treat_2 treat_3 [aw=weight2], ///
    a(cmun##i.age_c##year) cluster(year#anac) `reghdfe_compat'
outreg2 using "$rep_tables/table_selected_birthplace_nhijos.tex", replace tex(frag) label ///
    keep(treat_2 treat_3) nocons ctitle("N. kids") ///
    addtext(Specification, Baseline, Census. X Mun. X Age-class FE, YES, ///
            Mun. X Year X Age-class X Birth Prov. FE, NO) addstat(Mean of depvar, `p_nhijos') adec(2)  nonotes

quietly reghdfe nhijos treat_2 treat_3 [aw=weight2], ///
    a(cmun##i.age_c##year##i.codprov_born) cluster(year#anac) `reghdfe_compat'
outreg2 using "$rep_tables/table_selected_birthplace_nhijos.tex", append tex(frag) label ///
    keep(treat_2 treat_3) nocons ctitle("N. kids") ///
    addtext(Specification, Birthplace FE, Census. X Mun. X Age-class FE, NO, ///
            Mun. X Year X Age-class X Birth Prov. FE, YES) addstat(Mean of depvar, `p_nhijos') adec(2)  nonotes

quietly reghdfe nhijos treat_2 treat_3 if mover_birthprov == 1 [aw=weight2], ///
    a(cmun##i.age_c##year##i.codprov_born) cluster(year#anac) `reghdfe_compat'
outreg2 using "$rep_tables/table_selected_birthplace_nhijos.tex", append tex(frag) label ///
    keep(treat_2 treat_3) nocons ctitle("N. kids") ///
    addtext(Specification, Movers, Census. X Mun. X Age-class FE, NO, ///
            Mun. X Year X Age-class X Birth Prov. FE, YES) addstat(Mean of depvar, `p_nhijos') adec(2)  nonotes

quietly reghdfe nhijos treat_2 treat_3 if stayer_birthprov == 1 [aw=weight2], ///
    a(cmun##i.age_c##year##i.codprov_born) cluster(year#anac) `reghdfe_compat'
outreg2 using "$rep_tables/table_selected_birthplace_nhijos.tex", append tex(frag) label ///
    keep(treat_2 treat_3) nocons ctitle("N. kids") ///
    addtext(Specification, Stayers, Census. X Mun. X Age-class FE, NO, ///
            Mun. X Year X Age-class X Birth Prov. FE, YES) addstat(Mean of depvar, `p_nhijos') adec(2) nonotes

* ----------------------------------------------------------------------------
* TABLE B7. Birthplace Civil War control
* ----------------------------------------------------------------------------
load_census_final

* Here we ask whether the micro fertility pattern is really proxying Civil War
* exposure of women's birth provinces. The added regressors interact the two
* treated-cohort bins with the birthplace war-front measure.
gen front_treat2 = sh_area_front * treat_2 if sh_area_front < .
gen front_treat3 = sh_area_front * treat_3 if sh_area_front < .
label var front_treat2 "1930/1938 X War exposure"
label var front_treat3 "1939/1950 X War exposure"

quietly reghdfe nhijos treat_2 treat_3 [aw=weight2], ///
    a(cmun##i.age_c##year##i.codprov_born) cluster(year#anac) `reghdfe_compat'
quietly sum nhijos if e(sample) [aw=weight2], meanonly
local mean_nhijos_war = r(mean)
outreg2 using "$rep_tables/table_selected_birthplace_war.tex", replace tex(frag) label ///
    keep(treat_2 treat_3) nocons ctitle("N. kids") ///
    addtext(Specification, Baseline with birthplace FE, ///
            Census. X Mun. X Age-class FE, NO, ///
            Mun. X Year X Age-class X Birth Prov. FE, YES, Birthplace war interactions, NO) ///
    addstat(Mean of depvar, `mean_nhijos_war') adec(2) nonotes

quietly reghdfe nhijos treat_2 treat_3 front_treat2 front_treat3 [aw=weight2], ///
    a(cmun##i.age_c##year##i.codprov_born) cluster(year#anac) `reghdfe_compat'
quietly sum nhijos if e(sample) [aw=weight2], meanonly
local mean_nhijos_war2 = r(mean)
outreg2 using "$rep_tables/table_selected_birthplace_war.tex", append tex(frag) label ///
    keep(treat_2 treat_3 front_treat2 front_treat3) nocons ctitle("N. kids") ///
    addtext(Specification, Birthplace FE + war, ///
            Census. X Mun. X Age-class FE, NO, ///
            Mun. X Year X Age-class X Birth Prov. FE, YES, Birthplace war interactions, YES) ///
    addstat(Mean of depvar, `mean_nhijos_war2') adec(2) nonotes

* ----------------------------------------------------------------------------
* TABLE B8. Birthplace oil-exposure controls
* ----------------------------------------------------------------------------
load_census_final

* This is the micro counterpart to the oil-shock discussion in the macro
* section. We standardize four pre-1973 birthplace proxies and interact them
* with the two treated-cohort bins to test whether the census fertility result
* is just proxying origin provinces with systematically different productive
* structures.
egen z_indcore = std(industrial_core_share_1950) if proxy_usable_pre73 == 1
egen z_oilsens = std(oil_sensitive_share_1950) if proxy_usable_pre73 == 1
egen z_manuftr = std(manuf_trade_share_1950) if proxy_usable_pre73 == 1
egen z_nonag   = std(nonag_share_1950) if proxy_usable_pre73 == 1

gen indcore_t2 = z_indcore * treat_2 if z_indcore < .
gen indcore_t3 = z_indcore * treat_3 if z_indcore < .
gen oilsens_t2 = z_oilsens * treat_2 if z_oilsens < .
gen oilsens_t3 = z_oilsens * treat_3 if z_oilsens < .
gen manuftr_t2 = z_manuftr * treat_2 if z_manuftr < .
gen manuftr_t3 = z_manuftr * treat_3 if z_manuftr < .
gen nonag_t2 = z_nonag * treat_2 if z_nonag < .
gen nonag_t3 = z_nonag * treat_3 if z_nonag < .

quietly reghdfe nhijos treat_2 treat_3 if proxy_usable_pre73 == 1 [aw=weight2], ///
    a(cmun##i.age_c##year) cluster(year#anac) `reghdfe_compat'
quietly sum nhijos if e(sample) [aw=weight2], meanonly
local mean_nhijos_proxy = r(mean)
outreg2 using "$rep_tables/table_selected_birthplace_pre73_proxies.tex", replace tex(frag) label ///
    keep(treat_2 treat_3) nocons ctitle("N. kids") ///
    addtext(Specification, Baseline restricted , Mun. X Year X Age-class X Birth Prov. FE, NO) ///
    addstat(Mean of depvar, `mean_nhijos_proxy') adec(2) nonotes

quietly reghdfe nhijos treat_2 treat_3 if proxy_usable_pre73 == 1 [aw=weight2], ///
    a(cmun##i.age_c##year##i.codprov_born) cluster(year#anac) `reghdfe_compat'
quietly sum nhijos if e(sample) [aw=weight2], meanonly
local mean_nhijos_proxy2 = r(mean)
  
outreg2 using "$rep_tables/table_selected_birthplace_pre73_proxies.tex", append tex(frag) label ///
    keep(treat_2 treat_3) nocons ctitle("N. kids") ///
    addtext(Specification, + Birthplace FE, Mun. X Year X Age-class X Birth Prov. FE, YES) ///
    addstat(Mean of depvar, `mean_nhijos_proxy2') adec(2) nonotes

foreach proxy in indcore oilsens manuftr nonag {
    * Each iteration adds one proxy at a time so that the appendix table shows
    * whether the result is sensitive to the definition of pre-1973 structure.
    local pair = cond("`proxy'"=="indcore","indcore_t2 indcore_t3", ///
        cond("`proxy'"=="oilsens","oilsens_t2 oilsens_t3", ///
        cond("`proxy'"=="manuftr","manuftr_t2 manuftr_t3","nonag_t2 nonag_t3")))
    if "`proxy'" == "indcore" {
        label var indcore_t2 "1930/1938 X Industrial core"
        label var indcore_t3 "1939/1950 X Industrial core"
        local title "Industrial core"
    }
    if "`proxy'" == "oilsens" {
        label var oilsens_t2 "1930/1938 X Oil-sensitive"
        label var oilsens_t3 "1939/1950 X Oil-sensitive"
        local title "Oil-sensitive"
    }
    if "`proxy'" == "manuftr" {
        label var manuftr_t2 "1930/1938 X Manuf./trade"
        label var manuftr_t3 "1939/1950 X Manuf./trade"
        local title "Manuf./trade"
    }
    if "`proxy'" == "nonag" {
        label var nonag_t2 "1930/1938 X Non-agric."
        label var nonag_t3 "1939/1950 X Non-agric."
        local title "Non-agric."
    }

    quietly reghdfe nhijos treat_2 treat_3 `pair' if proxy_usable_pre73 == 1 [aw=weight2], ///
        a(cmun##i.age_c##year##i.codprov_born) cluster(year#anac) `reghdfe_compat'
    quietly sum nhijos if e(sample) [aw=weight2], meanonly
    local mean_nhijos_proxyhet = r(mean)
    outreg2 using "$rep_tables/table_selected_birthplace_pre73_proxies.tex", append tex(frag) label ///
        keep(treat_2 treat_3 `pair') nocons ctitle("N. kids") ///
        addtext(Specification, `title', Mun. X Year X Age-class X Birth Prov. FE, YES) ///
        addstat(Mean of depvar, `mean_nhijos_proxyhet') adec(2) nonotes
}

quietly reghdfe nhijos treat_2 treat_3 ///
    indcore_t2 indcore_t3 oilsens_t2 oilsens_t3 manuftr_t2 manuftr_t3 nonag_t2 nonag_t3 ///
    if proxy_usable_pre73 == 1 [aw=weight2], ///
    a(cmun##i.age_c##year##i.codprov_born) cluster(year#anac) `reghdfe_compat'
quietly sum nhijos if e(sample) [aw=weight2], meanonly
local mean_nhijos_all = r(mean)
outreg2 using "$rep_tables/table_selected_birthplace_pre73_proxies.tex", append tex(frag) label ///
    keep(treat_2 treat_3 indcore_t2 indcore_t3 oilsens_t2 oilsens_t3 manuftr_t2 manuftr_t3 nonag_t2 nonag_t3) nocons ///
    ctitle("N. kids") addtext(Specification, All, Mun. X Year X Age-class X Birth Prov. FE, YES) ///
    addstat(Mean of depvar, `mean_nhijos_all') adec(2) nonotes

* ----------------------------------------------------------------------------
* TABLE B9. CIS mechanisms
* ----------------------------------------------------------------------------
load_cis_final

* These are the survey-side mechanisms outcomes discussed in the paper:
* labor-force attachment, education, and ideology. The fixed-effects structure
* is held constant across columns so that the appendix table isolates outcome
* differences rather than specification changes.
foreach var in lab2_1 lab2_2 lab2_5 edu right {
    quietly sum `var' if treat == 0, meanonly
    local p = round(r(mean), .01)

    if "`var'" == "lab2_1" label var `var' "Employed"
    if "`var'" == "lab2_2" label var `var' "Unemployed"
    if "`var'" == "lab2_5" label var `var' "Housewife"
    if "`var'" == "edu"    label var `var' "Educated"
    if "`var'" == "right"  label var `var' "Right-wing"

    quietly reghdfe `var' treat_2 treat_3 if year < 1990, ///
        a(i.year#age_c#id) cluster(year#i.year_birth) `reghdfe_compat'
    if "`var'" == "lab2_1" {
        outreg2 using "$rep_main/table_cis_emp.tex", replace tex(frag) label nonotes ///
            addtext(Year FE, YES, Residence FE, YES, Age class FE, YES, Mean of depvar, `p') ///
            keep(treat_2 treat_3) nocons
    }
    else {
        outreg2 using "$rep_main/table_cis_emp.tex", append tex(frag) label nonotes ///
            addtext(Year FE, YES, Residence FE, YES, Age class FE, YES, Mean of depvar, `p') ///
            keep(treat_2 treat_3) nocons
    }
}

* ----------------------------------------------------------------------------
* TABLE B10. Law 56 descriptive mechanism evidence
* ----------------------------------------------------------------------------
* This is not a regression table. Instead, we assemble the descriptive 1981
* census quantities used in the discussion of the employment channel:
* - the fertility gap between active and inactive women;
* - the aggregate scale of female activity and employment in 1981.
use "$rep_data/final_law56_window_cells_1981.dta", clear
keep if zone == "Total Nacional"
keep if age_group == "De 25 a 29 años"
keep if inlist(marriage_period, "1961_1965", "1966_1970", "1971_1975")

quietly sum active_minus_inactive if marriage_period == "1961_1965", meanonly
local gap_6165_2529 : display %4.2f r(mean)
quietly sum active_minus_inactive if marriage_period == "1966_1970", meanonly
local gap_6670_2529 : display %4.2f r(mean)
quietly sum active_minus_inactive if marriage_period == "1971_1975", meanonly
local gap_7175_2529 : display %4.2f r(mean)

use "$rep_data/final_female_activity_structure_1981.dta", clear
quietly sum active_share_total if ambito_territorial == "Total Nacional", meanonly
local active_total_nat : display %4.2f 100*r(mean)
quietly sum occupied_share_total if ambito_territorial == "Total Nacional", meanonly
local occupied_total_nat : display %4.2f 100*r(mean)
quietly sum inactive_share_total if ambito_territorial == "Total Nacional", meanonly
local inactive_total_nat : display %4.2f 100*r(mean)
quietly sum active_share_total if ambito_territorial == "Zona urbana", meanonly
local active_urban : display %4.2f 100*r(mean)
quietly sum active_share_total if ambito_territorial == "Zona rural", meanonly
local active_rural : display %4.2f 100*r(mean)
quietly sum occupied_share_total if ambito_territorial == "Zona urbana", meanonly
local occupied_urban : display %4.2f 100*r(mean)

use "$rep_data/final_sex_activity_gap_1981.dta", clear
keep if ambito_territorial == "Total Nacional"
quietly sum totalMujeres, meanonly
local female_activity_rate : display %4.2f r(mean)
quietly sum totalVarones, meanonly
local male_activity_rate : display %4.2f r(mean)
quietly sum female_male_activity_ratio, meanonly
local female_male_activity_ratio : display %4.3f r(mean)

file open mech using "$rep_tables/table_selected_law56_mechanism.tex", write replace
file write mech "\begin{tabular}{lc} \hline" _n
file write mech " & Value \\\\" _n
file write mech "\hline" _n
file write mech "\multicolumn{2}{l}{\textit{Panel A. Average children: active minus inactive women}} \\\\" _n
file write mech "Married in 1961--1965, age 25--29 & `gap_6165_2529' \\\\" _n
file write mech "Married in 1966--1970, age 25--29 & `gap_6670_2529' \\\\" _n
file write mech "Married in 1971--1975, age 25--29 & `gap_7175_2529' \\\\" _n
file write mech "\multicolumn{2}{l}{\textit{Panel B. Scale of female labor-force attachment in 1981}} \\\\" _n
file write mech "Female activity rate (national, \%) & `female_activity_rate' \\\\" _n
file write mech "Female employment share (national, \%) & `occupied_total_nat' \\\\" _n
file write mech "Female inactivity share (national, \%) & `inactive_total_nat' \\\\" _n
file write mech "Female activity rate (urban, \%) & `active_urban' \\\\" _n
file write mech "Female activity rate (rural, \%) & `active_rural' \\\\" _n
file write mech "Male activity rate (national, \%) & `male_activity_rate' \\\\" _n
file write mech "Female-to-male activity ratio & `female_male_activity_ratio' \\\\" _n
file write mech "Female employment share (urban, \%) & `occupied_urban' \\\\" _n
file write mech "\hline" _n
file write mech "\end{tabular}" _n
file close mech

* ----------------------------------------------------------------------------
* TABLE B11. Balancing tests
* ----------------------------------------------------------------------------
load_macro_final

***************************************
**# Balancing
***************************************
preserve
egen idtype = group(type)
*drop teachers_pc
gen teachers_pc=(teachers/pop_1930)*10000
keep if year==1940

*gen popsharewomen_agegroup1=(popsharewomen_agegroup1_1940+popsharewomen_agegroup2_1940)*100
*gen popsharemen_agegroup1=(popsharemen_agegroup1_1940+popsharemen_agegroup2_1940)*100


local i=1
	
drop if popsharewomen_agegroup`i'==. | popsharemen_agegroup`i'==.
drop sum* interact*
gen sum`i'=popsharewomen_agegroup`i'
gen sum2`i'=popsharemen_agegroup`i' 

gen interaction=sum`i'
gen interaction2=sum2`i'

egen total1940=rowtotal( pop_agegroup3_1940 pop_agegroup4_1940 pop_agegroup5_1940)
gen popsharewomen2_agegroup3_1940=pop_agegroup3_1940/total1940
gen popsharewomen2_agegroup4_1940=pop_agegroup4_1940/total1940
gen popsharewomen2_agegroup5_1940=pop_agegroup5_1940/total1940


rename popsharewomen2_agegroup3_1940 popsharewomen_ag3_1940
rename popsharewomen2_agegroup4_1940 popsharewomen_ag4_1940
rename popsharewomen2_agegroup5_1940 popsharewomen_ag5_1940

gen pop=popsharewomen_ag3_1940 + popsharewomen_ag4_1940 + popsharewomen_ag5_1940 


file open myfile using $rep_main/table_balancing.tex, write replace
file write myfile "\begin{tabular}{l c c }\hline\hline  \\[-0.3cm] & (1) & (2)  \\ [0.1cm] & {Coefficient} & {SD}  \\ [0.1cm] \hline \\ " _n

local varlist =  "teachers_pc relig_com_total1930 professed_total1930 novice_total1930 lay_total1930 share_republicanos1931 share_socialistas1931 share_monarquicos1931 share_comunistas1931 adictos nat_school_total42 teachersprimary_total42 enrolled_students42  sh_area_front popsharewomen_ag3_1940 popsharewomen_ag4_1940 popsharewomen_ag5_1940 popwomen_agegroup3_1940 popwomen_agegroup4_1940 popwomen_agegroup5_1940 deaths_male_cwar deaths_female_cwar"   
foreach var in `varlist'{
if "`var'"== "teachers_pc"{
			local name = "Purged teachers"
			
		}

		else if "`var'"== "relig_com_total1930"{
			local name = "Religious communities (1930)"
			
		}
		else if "`var'"== "professed_total1930"{
			local name = "Professed (pc, 1930)"
			
		}
		else if "`var'"== "novice_total1930"{
			local name = "Novices (pc,1930)"
			
		}
		else if "`var'"== "lay_total1930"{
			local name = "Lay (pc, 1930)"
			
		}
		else if "`var'"== "share_republicanos1931"{
			local name = "Republicans (\%, local 1931)"
			
		}
		else if "`var'"== "share_socialistas1931"{
			local name = "Socialists (\%, local 1931)"
			
		}
		else if "`var'"== "share_monarquicos1931"{
			local name = "Monarchic (\%, local 1931)"
			
		}
		else if "`var'"== "share_comunistas1931"{
			local name = "Communists (\%, local 1931)"
			
		}
		else if "`var'"== "adictos"{
			local name = "Pro regime (\%, 1947)"
			
		}
		else if "`var'"== "sh_area_front"{
			local name = "Area in the war front (\%)"
			
		}
		else if "`var'"== "nat_school_total42"{
			local name = "National schools (1000s,1942)"
			
		}
		else if "`var'"== "teachersprimary_total42"{
			local name = "Primary teachers (1000s,1942)"
			
		}
		else if "`var'"== "enrolled_students42"{
			local name = "Enrolled students (1000s,1942)"
			
		}
		
		else if "`var'"== "popsharewomen_ag3_1940"{
			local name = "Women aged 15-24 (\%, 1940) "
			
		}
		else if "`var'"== "popsharewomen_ag4_1940"{
			local name = "Women aged 25-34 (\%, 1940) "
			
		}
		else if "`var'"== "popsharewomen_ag5_1940"{
			local name = "Women aged 35-44 (\%, 1940) "
			
		}
		
		else if "`var'"== "popwomen_agegroup3_1940"{
			local name = "Women aged 15-24 (1940) "
			
		}
		else if "`var'"== "popwomen_agegroup4_1940"{
			local name = "Women aged 25-34 (1940) "
			
		}
		else if "`var'"== "popwomen_agegroup5_1940"{
			local name = "Women aged 35-44 (1940) "
			
		}
	    else if "`var'"== "deaths_male_cwar"{
			local name = "Male deaths (1000s, 1936-39)"
			
		}
	    else if "`var'"== "deaths_female_cwar"{
			local name = "Female deaths (1000s, 1936-39)"
			
		}		
		else {
			local name = "ERROR"
		}
		
if "`var'"== "popwomen_agegroup3_1940" | "`var'"== "popwomen_agegroup4_1940" | "`var'"== "popwomen_agegroup5_1940"{
		
		reghdfe `var'  interaction interaction2, a(i.idtype i.codprov)  nocons
		ta idtype if e(sample)
		local diff3 = _b[interaction]
		local sd3=_se[interaction]
		local pval3 = ttail(47,abs(_b[interaction]/_se[interaction]))*2
		di `pval3'
		
		if `pval3'>0.1  {
			local cc = string(`diff3',"%8.0f") 
		} 
		else if `pval3'>0.05 { 
			local cc = string(`diff3',"%8.0f") + "$^\star$"
		}
		else if `pval3'>0.01 { 
			local cc = string(`diff3',"%8.0f") + "$^\star$" + "$^\star$"
		}
		else {
			local cc = string(`diff3',"%8.0f") + "$^\star$" + "$^\star$" + "$^\star$"
		}
		
		local dd = string(`sd3',"%8.0f") 
		
		
		file write myfile ("`name'") "&" _tab  %8.2f ("`cc'")  "&"_tab  %8.2f ("`dd'") _tab "\\" _n
}
		else {
		reghdfe `var'  interaction interaction2, a(i.idtype i.codprov)  nocons
		ta idtype if e(sample)
		local diff3 = _b[interaction]
		local sd3=_se[interaction]
		local pval3 = ttail(47,abs(_b[interaction]/_se[interaction]))*2
		di `pval3'
		
		if `pval3'>0.1  {
			local cc = string(`diff3',"%8.3f") 
		} 
		else if `pval3'>0.05 { 
			local cc = string(`diff3',"%8.3f") + "$^\star$"
		}
		else if `pval3'>0.01 { 
			local cc = string(`diff3',"%8.3f") + "$^\star$" + "$^\star$"
		}
		else {
			local cc = string(`diff3',"%8.3f") + "$^\star$" + "$^\star$" + "$^\star$"
		}
		
		local dd = string(`sd3',"%8.3f") 
		
		
		file write myfile ("`name'") "&" _tab  %8.2f ("`cc'")  "&"_tab  %8.2f ("`dd'") _tab "\\" _n	
		}
}
file write myfile "\hline\hline \end{tabular}"
file close myfile
restore


* ----------------------------------------------------------------------------
* FIGURE B1. Exposure map
* ----------------------------------------------------------------------------
* The package keeps the exact QGIS-rendered map used in the manuscript, so the
* reproduced appendix figure is visually identical to the published draft.
copy "$rep_figinputs/exposure_map/popw_newlegend.png" ///
    "$rep_mapdir/popw_newlegend.png", replace
confirm file "$rep_mapdir/popw_newlegend.png"

* ----------------------------------------------------------------------------
* TABLE B12. Macro robustness table
* ----------------------------------------------------------------------------
load_macro_final
quietly sum alive if year < 1945 & year > 1939, meanonly
local mean_depvar = r(mean)

* Each pair of columns in this table corresponds to one alternative aggregate
* check:
* - Socialist vote share trends;
* - a discretized treatment intensity;
* - a placebo based on older female cohorts;
* - marriages instead of births.
*
* The export order matches the current appendix order in the paper.

* Socialists trend controls: allow postwar fertility to vary with prewar
* socialist strength so that the main coefficient is not just capturing a
* political-trends story.
quietly reghdfe alive interaction interaction2 1.post##c.sum1 1.post##c.sum2 flag4_3 flag4_4 flag4_5, ///
    a(i.id i.year#c.share_socialistas1931) cluster(id)
outreg2 using "$rep_main/table_reg_female_rob.tex", replace tex(frag) label nonotes ///
    addtext(Test, Socialists, Fertile pop., YES, Unit FE, YES, Year FE, YES, Prov. X Year FE, YES) ///
    ctitle("Births") keep(interaction) nocons addstat(Mean of depvar, `mean_depvar')

quietly reghdfe alive interaction interaction2 1.post##c.sum1 1.post##c.sum2 flag4_3 flag4_4 flag4_5, ///
    a(i.id i.year#i.codprov i.year#c.share_socialistas1931) cluster(id)
outreg2 using "$rep_main/table_reg_female_rob.tex", append tex(frag) label nonotes ///
    addtext(Test, Socialists, Fertile pop., YES, Unit FE, YES, Year FE, YES, Prov. X Year FE, YES) ///
    ctitle("Births") keep(interaction interaction2) nocons addstat(Mean of depvar, `mean_depvar')

* Discrete treatment: replace continuous exposure with above-median bins to
* show that the result is not driven mechanically by linearity.
preserve
xtile median_popw1 = sum1, n(2)
gen tertile_popw1 = median_popw1 == 2
xtile median_popm1 = sum2, n(2)
gen tertile_popm1 = median_popm1 == 2
replace sum1 = tertile_popw1
replace sum2 = tertile_popm1
replace interaction = post * sum1
replace interaction2 = post * sum2
quietly reghdfe alive interaction 1.post##c.sum1 flag4_3 flag4_4 flag4_5, ///
    a(i.id i.year#i.codprov) cluster(id)
outreg2 using "$rep_main/table_reg_female_rob.tex", append tex(frag) label nonotes ///
    addtext(Test, Discrete, Fertile pop., YES, Unit FE, YES, Year FE, YES, Prov. X Year FE, YES) ///
    ctitle("Births") keep(interaction) nocons addstat(Mean of depvar, `mean_depvar')

quietly reghdfe alive interaction interaction2 1.post##c.sum1 1.post##c.sum2 flag4_3 flag4_4 flag4_5, ///
    a(i.id i.year#i.codprov) cluster(id)
outreg2 using "$rep_main/table_reg_female_rob.tex", append tex(frag) label nonotes ///
    addtext(Test, Discrete, Fertile pop., YES, Unit FE, YES, Year FE, YES, Prov. X Year FE, YES) ///
    ctitle("Births") keep(interaction interaction2) nocons addstat(Mean of depvar, `mean_depvar')
restore

* Placebo using women aged 15-24 in 1940: shift the treatment definition to an
* older female group that should not map into reform exposure the same way.
preserve
gen placebo_w = popsharewomen_agegroup3_1940 * 100
gen placebo_m = popsharewomen_agegroup3_1940 * 100
replace sum1 = placebo_w
replace sum2 = placebo_m
replace interaction = post * sum1
replace interaction2 = post * sum2
quietly reghdfe alive interaction 1.post##c.sum1 flag4_3 flag4_4 flag4_5, ///
    a(i.id i.year#i.codprov) cluster(id)
outreg2 using "$rep_main/table_reg_female_rob.tex", append tex(frag) label nonotes ///
    addtext(Test, Placebo, Fertile pop., YES, Unit FE, YES, Year FE, YES, Prov. X Year FE, YES) ///
    ctitle("Births") keep(interaction) nocons addstat(Mean of depvar, `mean_depvar')

quietly reghdfe alive interaction interaction2 1.post##c.sum1 1.post##c.sum2 flag4_3 flag4_4 flag4_5, ///
    a(i.id i.year#i.codprov) cluster(id)
outreg2 using "$rep_main/table_reg_female_rob.tex", append tex(frag) label nonotes ///
    addtext(Test, Placebo, Fertile pop., YES, Unit FE, YES, Year FE, YES, Prov. X Year FE, YES) ///
    ctitle("Births") keep(interaction interaction2) nocons addstat(Mean of depvar, `mean_depvar')
restore

* Weddings outcome: test whether the aggregate result is simply a marriage-rate
* story rather than a fertility story.
quietly sum total_wedding if year < 1945 & year > 1939, meanonly
local mean_weddings = r(mean)
quietly reghdfe total_wedding interaction 1.post##c.sum1 flag4_3 flag4_4 flag4_5, ///
    a(i.id i.year#i.codprov) cluster(id)
outreg2 using "$rep_main/table_reg_female_rob.tex", append tex(frag) label nonotes ///
    addtext(Test, Weddings, Fertile pop., YES, Unit FE, YES, Year FE, YES, Prov. X Year FE, YES) ///
    ctitle("Births") keep(interaction) nocons addstat(Mean of depvar, `mean_weddings')

quietly reghdfe total_wedding interaction interaction2 1.post##c.sum1 1.post##c.sum2 flag4_3 flag4_4 flag4_5, ///
    a(i.id i.year#i.codprov) cluster(id)
outreg2 using "$rep_main/table_reg_female_rob.tex", append tex(frag) label nonotes ///
    addtext(Test, Weddings, Fertile pop., YES, Unit FE, YES, Year FE, YES, Prov. X Year FE, YES) ///
    ctitle("Births") keep(interaction interaction2) nocons addstat(Mean of depvar, `mean_weddings')

* ----------------------------------------------------------------------------
* TABLE B13. External migration
* ----------------------------------------------------------------------------
use "$rep_data/final_external_migration_1981.dta", clear

* The dependent variable is the female staying share between 1970 and 1981 at
* the province-of-origin level. The key regressors are the within-province
* exposure gaps between the capital component and the rest of the province.
quietly reg stay_share treat_gap_f treat_gap_m muni_share_1940 ln_origin_total, vce(robust)
outreg2 using "$rep_tables/table_selected_external_migration_regs.tex", replace tex(frag) label ///
    keep(treat_gap_f treat_gap_m muni_share_1940 ln_origin_total) nocons ///
    ctitle("Female staying share, 1970--1981") nonotes

* ----------------------------------------------------------------------------
* TABLE B14. Post-1973 oil heterogeneity
* ----------------------------------------------------------------------------
load_macro_final

* This table studies three margins at once:
* - the baseline treatment effect before 1973;
* - the common shift after 1973;
* - whether that post-1973 shift is systematically different in provinces with
*   greater ex ante exposure to historically oil-sensitive structures.
*
* We therefore build, one proxy at a time:
* - Treat X Post 1945 X Proxy;
* - Treat X Post-1973;
* - Treat X Post-1973 X Proxy.
capture confirm variable post73
if _rc != 0 {
    gen post73 = year >= 1973 if year < .
}
egen z_indcore = std(industrial_core_share_1950) if proxy_usable_pre73 == 1
egen z_oilsens = std(oil_sensitive_share_1950)   if proxy_usable_pre73 == 1
egen z_manuftr = std(manuf_trade_share_1950)     if proxy_usable_pre73 == 1
egen z_nonag   = std(nonag_share_1950)           if proxy_usable_pre73 == 1
gen post73_f = sum1 * post73
gen post73_m = sum2 * post73

local proxies industrial_core_share_1950 oil_sensitive_share_1950 manuf_trade_share_1950 nonag_share_1950
capture erase "$rep_tables/table_selected_macro_1973_proxies.tex"
foreach proxy of local proxies {
    * The loop writes one appendix column per proxy. Each column is estimated on
    * the restricted province sample for which that historical proxy exists.
    if "`proxy'" == "industrial_core_share_1950" local title "Industrial core"
    if "`proxy'" == "oil_sensitive_share_1950"   local title "Oil-sensitive"
    if "`proxy'" == "manuf_trade_share_1950"     local title "Manuf./trade"
    if "`proxy'" == "nonag_share_1950"           local title "Non-agric."
    if "`proxy'" == "industrial_core_share_1950" local zvar z_indcore
    if "`proxy'" == "oil_sensitive_share_1950"   local zvar z_oilsens
    if "`proxy'" == "manuf_trade_share_1950"     local zvar z_manuftr
    if "`proxy'" == "nonag_share_1950"           local zvar z_nonag

    * proxy_f / proxy_m capture heterogeneity in the baseline post-1945 effect.
    * proxy73_f / proxy73_m capture whether the effect changes differentially
    * after 1973 in more exposed provinces.
    gen proxy_f   = interaction  * `zvar'
    gen proxy_m   = interaction2 * `zvar'
    gen proxy73_f = interaction  * post73 * `zvar'
    gen proxy73_m = interaction2 * post73 * `zvar'
    label var proxy_f   "Treat (W) X Post 1945 X Proxy"
    label var proxy_m   "Treat (M) X Post 1945 X Proxy"
    label var proxy73_f "Treat (W) X Post-1973 X Proxy"
    label var proxy73_m "Treat (M) X Post-1973 X Proxy"
    label var post73_f "Treat (W) X Post 1973"
    label var post73_m "Treat (M) X Post 1973"
    quietly reghdfe alive interaction interaction2 post73_f post73_m proxy_f proxy_m proxy73_f proxy73_m ///
        1.post##c.sum1 1.post##c.sum2 flag4_3 flag4_4 flag4_5 ///
        if proxy_usable_pre73 == 1, a(i.id i.year#i.codprov) cluster(id)
    quietly sum alive if e(sample), meanonly
    local mean_alive = r(mean)

    if "`proxy'" == "industrial_core_share_1950" {
        outreg2 using "$rep_tables/table_selected_macro_1973_proxies.tex", replace tex(frag) label ///
            keep(interaction interaction2 post73_f post73_m proxy_f proxy_m proxy73_f proxy73_m) nocons ///
            ctitle("Births") addtext(Specification, "`title'", Unit FE, YES, Province-Year FE, YES, ///
            Fertile-age controls, YES, Treat X Post-1973, YES, Treat X Post 1945 X Proxy, YES, ///
            Treat X Post-1973 X Proxy, YES) addstat(Mean of depvar, `mean_alive') nonotes
    }
    else {
        outreg2 using "$rep_tables/table_selected_macro_1973_proxies.tex", append tex(frag) label ///
            keep(interaction interaction2 post73_f post73_m proxy_f proxy_m proxy73_f proxy73_m) nocons ///
            ctitle("Births") addtext(Specification, "`title'", Unit FE, YES, Province-Year FE, YES, ///
            Fertile-age controls, YES, Treat X Post-1973, YES, Treat X Post 1945 X Proxy, YES, ///
            Treat X Post-1973 X Proxy, YES) addstat(Mean of depvar, `mean_alive') nonotes
    }
    * Drop temporary regressors before moving to the next proxy so that each
    * loop iteration starts from the same underlying macro dataset.
    drop proxy_f proxy_m proxy73_f proxy73_m
}

* ----------------------------------------------------------------------------
* FIGURE B2. National TFR series
* ----------------------------------------------------------------------------
* The current package rebuilds the long-run national TFR image from the historical
* source table stored in the package.
* The source series combines Statista for the nineteenth and early twentieth
* century decades, INE for 1930 and 1940, and the United Nations Population
* Division for 1950 onward. The exported figure labels the axes as Year and
* National TFR and leaves source attribution to the LaTeX note.
shell python3 "$rep_python/build_appendix_figures.py" tfr ///
    --data "$rep_data/final_spain_tfr_series.dta" ///
    --out "$rep_rootfiles/TFR.jpg"
confirm file "$rep_rootfiles/TFR.jpg"

log close
