*-----------------------------------------------------------------------------------------------------------------------------------------*
*-----------------------------------------------------------------------------------------------------------------------------------------*
*																																		  *	
*									MASTER FILE FOR PURGE PAPER 	
*																																															  *	
*-----------------------------------------------------------------------------------------------------------------------------------------*
*-----------------------------------------------------------------------------------------------------------------------------------------*
							
clear all
set maxvar 10000
							
											*** CHANGE/ENTER FOLDER HERE ***
											*------------------------------*

global dir "C:\Users\laxge\Dropbox\GEMA\RESEARCH\" // portatil

cd $dir

*global dir "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/"

											*** DECLARATION GLOBAL ***
											*------------------------*
											


global Do 				"PURGE\progs"
global Output_data 		"PURGE\output_data"
global Data 			"PURGE\original_data"
global Results 			"PURGE\results"

0


global Do 				"${dir}/PURGE/progs"
global Output_data 		"${dir}/PURGE/output_data"
global Data 			"${dir}/PURGE/original_data"
global Results 			"${dir}/PURGE/results"

