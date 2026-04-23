version 17
clear all
set more off

local root_dir   "/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_data"
local raw_dir    "`root_dir'/raw"
local out_dir    "`root_dir'/processed"

cap mkdir "`out_dir'"

local csv_files : dir "`raw_dir'" files "ine_*.csv_bd"

tempfile inventory_tmp
tempname inventory_handle

postfile `inventory_handle' ///
    str32 source_family ///
    str16 table_code ///
    str244 title ///
    long rows ///
    int columns ///
    str244 raw_file ///
    str244 clean_csv ///
    str244 clean_dta ///
    using "`inventory_tmp'", replace

foreach csv_file of local csv_files {
    di as txt "Cleaning `csv_file'..."

    local stem = subinstr("`csv_file'", ".csv_bd", "", .)
    local code = subinstr("`stem'", "ine_", "", .)
    local out_csv "`out_dir'/`stem'_clean.csv"
    local out_dta "`out_dir'/`stem'_clean.dta"
    local raw_rel "raw/`csv_file'"
    local clean_csv_rel "processed/`stem'_clean.csv"
    local clean_dta_rel "processed/`stem'_clean.dta"
    local px_file "`raw_dir'/`stem'.px"
    local title ""

    capture noisily import delimited "`raw_dir'/`csv_file'", ///
        delimiter(tab) ///
        varnames(1) ///
        encoding(utf8) ///
        stringcols(_all) ///
        clear

    if _rc {
        import delimited "`raw_dir'/`csv_file'", ///
            delimiter(tab) ///
            varnames(1) ///
            encoding(iso-8859-1) ///
            stringcols(_all) ///
            clear
    }

    rename *, lower

    foreach v of varlist _all {
        local cleaned = lower(strtoname("`v'"))
        if "`cleaned'" == "" {
            continue
        }
        if "`cleaned'" != "`v'" {
            capture rename `v' `cleaned'
        }
    }

    foreach v of varlist _all {
        capture confirm string variable `v'
        if !_rc {
            replace `v' = strtrim(itrim(`v'))

            tempvar candidate
            gen double `candidate' = real(subinstr(subinstr(subinstr(subinstr(`v', ".", "", .), ",", ".", .), "%", "", .), "..", "", .))
            quietly count if !missing(`candidate')

            if r(N) / _N >= 0.75 {
                drop `v'
                rename `candidate' `v'
            }
            else {
                drop `candidate'
            }
        }
    }

    local row_count = _N
    local col_count = c(k)

    save "`out_dta'", replace
    export delimited using "`out_csv'", replace

    capture confirm file "`px_file'"
    if !_rc {
        file open px_handle using "`px_file'", read text
        file read px_handle line
        while r(eof)==0 {
            if strpos(`"`line'"', "TITLE=") {
                local title = subinstr(`"`line'"', `"""', "", .)
                local title = subinstr(`"`title'"', "TITLE=", "", .)
                local title = subinstr(`"`title'"', ";", "", .)
                continue, break
            }
            file read px_handle line
        }
        file close px_handle
    }

    post `inventory_handle' ///
        ("ine_censo_1981") ///
        ("`code'") ///
        (`"`title'"') ///
        (`row_count') ///
        (`col_count') ///
        ("`raw_rel'") ///
        ("`clean_csv_rel'") ///
        ("`clean_dta_rel'")
}

postclose `inventory_handle'

use "`inventory_tmp'", clear
sort source_family table_code
save "`out_dir'/external_sources_inventory_stata.dta", replace
export delimited using "`out_dir'/external_sources_inventory_stata.csv", replace
