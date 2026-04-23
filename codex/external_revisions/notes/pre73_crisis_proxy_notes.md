# Pre-1973 Crisis Proxies

Source base:
- INE 1950 Censo, Cuadro VIII (economic activity by establishment / broad sector)
- Internal 1960 and 1970 province-level census geography already used in the project

Usable provinces under the province-total audit rule: `48` / `50`
Usable provinces for capital rows: `48` / `50`
Usable provinces for derived rest-of-province rows: `47` / `50`
Strict derived rest-of-province rows: `47` / `50`
Soft-derived rest-of-province recoveries: `0` / `50`

Audit rule:
- `usable_viii = 1` if the parsed row has 10 sector fields and the sum of sector counts is within 10% of total active population
- `usable_viii_cap = 1` applies the same rule to the capital row
- `usable_viii_rest_strict = 1` if both total and capital rows are usable, the implied rest-of-province counts are non-negative, and the derived sector sum is within 10% of the implied total active population
- `usable_viii_rest_soft = 1` only for edge cases with exactly one negative derived sector cell, that negative cell no smaller than `-25`, and derived gap share at or below `0.001`
- `usable_viii_rest = 1` if either the strict or the soft rule is satisfied
- provinces with OCR omissions stay in the file with `usable_viii = 0` or `usable_viii_cap = 0`

Main proxy variables:
- `industrial_core_share_1950`
- `oil_sensitive_share_1950`
- `manuf_trade_share_1950`
- `nonag_share_1950`
- capital-specific counterparts use the `_cap` suffix
- rest-of-province counterparts use the `_rest` suffix

Additional documentation:
- Codebook: `/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_revisions/notes/pre73_crisis_proxy_codebook.md`

Saved dataset: `/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_revisions/generated/province_pre73_crisis_proxies.dta`
