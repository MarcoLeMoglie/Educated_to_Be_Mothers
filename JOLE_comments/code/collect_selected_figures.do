version 17.0
clear all
set more off

global root "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE"
global paper_root "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/Applicazioni/Overleaf/Educated to Be Mothers-slides"
global figures "$paper_root/JOLE_comments/figures"

capture mkdir "$figures"

copy "$root/Marco/Results/nkids_female.pdf" "$figures/nkids_female.pdf", replace
copy "$root/Marco/Results/nkids_male.pdf" "$figures/nkids_male.pdf", replace
copy "$root/Marco/Results/cis.pdf" "$figures/cis.pdf", replace
copy "$root/Marco/Results/cis_event.pdf" "$figures/cis_event.pdf", replace
copy "$root/Marco/Results/nhijos_census.pdf" "$figures/nhijos_census.pdf", replace
copy "$root/Marco/Results/desc_1940_female_fertility.pdf" "$figures/desc_1940_female_fertility.pdf", replace
copy "$root/Marco/Results/women.pdf" "$figures/women.pdf", replace
copy "$root/Marco/Results/event_1940_cont_alive_birth1.pdf" "$figures/event_1940_cont_alive_birth1.pdf", replace
copy "$root/Marco/Results/event_1940_discrete_alive_birth1.pdf" "$figures/event_1940_discrete_alive_birth1.pdf", replace
copy "$root/Marco/Results/event_1940_alive_birth2.pdf" "$figures/event_1940_alive_birth2.pdf", replace
copy "$root/results/event_1940_cont_alive_birth1_deaths.pdf" "$figures/event_1940_cont_alive_birth1_deaths.pdf", replace
copy "$root/Marco/Results/event_1940_wedding_total_wedding1.pdf" "$figures/event_1940_wedding_total_wedding1.pdf", replace
