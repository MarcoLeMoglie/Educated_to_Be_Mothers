# Pre-1973 Provincial Proxies Source

Main role:

- audited historical provincial structure before the 1973 crisis
- macro proxy heterogeneity table, with separate `capital` and `rest province` assignments
- birthplace-assigned pre-1973 proxy tests in the census microdata

Derived source path:

- `/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_revisions/generated/province_pre73_crisis_proxies.dta`

Build script:

- `/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/JOLE_comments/data/scripts/build_pre73_crisis_proxies.py`

Supporting notes:

- `/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_revisions/notes/pre73_crisis_proxy_notes.md`

Notes:

- this is an infrastructure dataset rather than a final result on its own
- it keeps the whole-province proxy values and also stores `_cap` and `_rest` counterparts built from the same 1950 source table
- the macro panel now uses the `_cap` values for `municipality` units and the `_rest` values for `rest province` units
- the micro birthplace analysis continues to use the whole-province value
- it is kept because it makes both the macro and micro 1973 robustness exercises more credible
