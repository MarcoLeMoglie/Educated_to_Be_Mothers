version 17.0
clear all
set more off

* ============================================================================
* Replication package globals
* ----------------------------------------------------------------------------
* This file centralizes every path used by the package. The goal is to keep the
* original analysis code untouched while making the replication workflow easy
* to follow from one place.
*
* Naming convention used in this package:
* - prep data code  = scripts that build the minimal labeled analysis datasets
*                     needed for the current paper
* - external source = scripts that document how external reviewer-response
*                     inputs were downloaded and cleaned upstream
* - package results = tables/figures reproduced in the same order as the
*                     manuscript
* ============================================================================


clear all 
* set path (no need to un-star anything, needs "confirmdir" to be installed)
foreach i in "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE"  ///
			 "C:\Users\laxge\Dropbox\GEMA\RESEARCH\PURGE" ///
			 "" {
	
			 global purge_root "`i'"
			 confirmdir "$purge_root"
			 if `r(confirmdir)'==0 continue, break
}

* set path (no need to un-star anything, needs "confirmdir" to be installed)
foreach i in "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/Applicazioni/Overleaf/Educated to Be Mothers-slides"  ///
			 "C:\Users\laxge\Dropbox\Apps\Overleaf\Educated to Be Mothers-slides" ///
			 "" {
	
			 global overleaf_root "`i'"
			 confirmdir "$overleaf_root"
			 if `r(confirmdir)'==0 continue, break
}


global rep_root   "$purge_root/Marco/DO/code_2026_04_10"

* ---- Raw and intermediate project data already used by the paper ------------
global raw_cis        "$purge_root/original_data/CIS/_data_cis"
global raw_census     "$purge_root/original_data/INE_microdatos"
global raw_macro      "$purge_root/output_data"
global raw_results    "$purge_root/Marco/Results"
global raw_jole       "$purge_root/JOLE_comments"
global raw_tables     "$raw_jole/tables"
global raw_extrev     "$purge_root/codex/external_revisions"
global raw_extdata    "$purge_root/codex/external_data"
global raw_generated  "$purge_root/codex/generated"

* ---- Package folders ---------------------------------------------------------
global rep_code       "$rep_root/code"
global rep_python     "$rep_root/code/python"
global rep_prep       "$rep_root/code/prep_data"
global rep_data       "$rep_root/analysis_data"
global rep_figinputs  "$rep_root/figure_inputs"
global rep_results    "$rep_root/results"
global rep_main       "$rep_root/results"
global rep_appendix   "$rep_root/results/appendix"
global rep_tables     "$rep_root/results/JOLE_comments/tables"
global rep_mapdir     "$rep_root/results/descriptive_maps"
global rep_rootfiles  "$rep_root/results/rootfiles"
global rep_logs       "$rep_root/logs"

capture mkdir "$rep_root"
capture mkdir "$rep_code"
capture mkdir "$rep_python"
capture mkdir "$rep_prep"
capture mkdir "$rep_data"
capture mkdir "$rep_figinputs"
capture mkdir "$rep_logs"
capture mkdir "$rep_results"
capture mkdir "$rep_appendix"
capture mkdir "$rep_root/results/JOLE_comments"
capture mkdir "$rep_tables"
capture mkdir "$rep_mapdir"
capture mkdir "$rep_rootfiles"

/*
ssc install ftools, replace
ssc install reghdfe, replace
ssc install boottest, replace
ssc install require, replace
