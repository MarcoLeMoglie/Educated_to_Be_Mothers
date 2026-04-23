capture {
clear
set processors 1
cd "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/Marco/Results/"
sysdir set PERSONAL "/Users/marcolemoglie_1_2/Library/Application Support/Stata/ado/personal/"
sysdir set PLUS "/Users/marcolemoglie_1_2/Library/Application Support/Stata/ado/plus/"
global S_ADO = `"`"/Users/marcolemoglie/Desktop/Letizia/panelwhiz3/base"';BASE;SITE;.;PERSONAL;PLUS;OLDPLACE"'
mata: mata mlib index
mata: mata set matalibs "lmatabase;lmatamcmc;lmatabma;lmatacollect;lmatatab;lmatamixlog;lmatami;lmatasem;lmatagsem;lmatasp;lmatapss;lmatalasso;lmatapostest;lmatapath;lmatameta;lmataopt;lmatasvy;lmatanumlib;lmataado;lmataerm;lmatafc;lreghdfe;livreg2;lftools;lsynth_mata_subr;lasdoc;lboottest;lnearstat;lmoremata14;lparallel;lgtools;lxsmle;lcmp;lcolrspace;lmoremata10;lskew;lmoremata;l_cfrmt;lhonestdid;lmoremata11;lghk2;lspmat;l__pllmy15pvqqv9_mlib"
set seed 65110
noi di "{hline 80}"
noi di "Parallel computing with Stata"
noi di "{hline 80}"
noi di `"cmd/dofile   : "honestwork""'
noi di "pll_id       : my15pvqqv9"
noi di "pll_instance : 4/4"
noi di "tmpdir       : `c(tmpdir)'"
noi di "date-time    : `c(current_time)' `c(current_date)'"
noi di "seed         : `c(seed)'"
noi di "{hline 80}"
local pll_instance 4
local pll_id my15pvqqv9
global pll_instance 4
global pll_id my15pvqqv9
set maxvar 5000
set matsize 400
mata: for(i=1;i<=4;i++) PLL_QUIET = st_tempname()
}
local result = _rc
if (c(rc)) {
cd "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/Marco/Results/"
mata: parallel_write_diagnosis(strofreal(c("rc")),"/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/Marco/Results/__pllmy15pvqqv9_finito0004","while setting memory")
clear
exit
}

* Checking for break *
mata: parallel_break()

* Loading Globals *
capture {
cap run "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/Marco/Results/__pllmy15pvqqv9_glob.do"
}
if (c(rc)) {
  cd "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/Marco/Results/"
  mata: parallel_write_diagnosis(strofreal(c("rc")),"/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/Marco/Results/__pllmy15pvqqv9_finito0004","while loading globals")
  clear
  exit
}

* Checking for break *
mata: parallel_break()
capture {
  noisily {
    use "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/Marco/Results/__pllmy15pvqqv9_dataset" if _my15pvqqv9cut == 4
    drop _my15pvqqv9cut

* Checking for break *
mata: parallel_break()
    honestwork 
  }
}
if (c(rc)) {
  cd "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/Marco/Results/"
  mata: parallel_write_diagnosis(strofreal(c("rc")),"/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/Marco/Results/__pllmy15pvqqv9_finito0004","while running the command/dofile")
  clear
  exit
}
mata: parallel_write_diagnosis(strofreal(c("rc")),"/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/Marco/Results/__pllmy15pvqqv9_finito0004","while executing the command")
save "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/Marco/Results/__pllmy15pvqqv9_dta0004", replace
cd "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/Marco/Results/"
