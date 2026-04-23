version 17.0
clear all
set more off

* ============================================================================
* Master replication runner
* ----------------------------------------------------------------------------
* This is the entry-point file for the package. It does three things in order:
*
* 1. sets paths;
* 2. builds the minimal labeled final datasets stored in analysis_data/;
* 3. reruns the integrated paper-order script that rebuilds the tables and
*    figures currently used by AA_paper_new.tex from the package inputs.
*
* Users who only need the final analysis datasets can stop after step 2 by
* running the prep-data script directly.
* ============================================================================

do "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/Marco/DO/code_2026_04_10/code/00_globals.do"
do "$rep_prep/01_build_final_analysis_data.do"
do "$rep_root/code/Main_analysis_paper_order.do"
