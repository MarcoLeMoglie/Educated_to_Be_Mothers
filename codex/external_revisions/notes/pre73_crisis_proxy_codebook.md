# Codebook: province_pre73_crisis_proxies

Files:
- Dataset: `/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_revisions/generated/province_pre73_crisis_proxies.dta`
- CSV mirror: `/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/codex/external_revisions/generated/province_pre73_crisis_proxies.csv`

Observations: `50` provinces
Variables: `106`

Variable legend:
- suffix `_cap`: provincial capital row from Cuadro VIII
- suffix `_rest`: derived rest-of-province row = whole province minus capital
- no suffix: whole-province row

| Variable | Label | Type | Non-missing |
|---|---|---:|---:|
| `codprov` | Province code | `float32` | `50` |
| `province` | Province name | `str` | `50` |
| `popsharewomen_agegroup1_1970` | Women population share, age group 1, 1970 census geography | `float32` | `50` |
| `popsharewomen_agegroup2_1970` | Women population share, age group 2, 1970 census geography | `float32` | `50` |
| `popsharemen_agegroup1_1970` | Men population share, age group 1, 1970 census geography | `float32` | `50` |
| `popsharemen_agegroup2_1970` | Men population share, age group 2, 1970 census geography | `float32` | `50` |
| `popsharewomen_agegroup1_1960` | Women population share, age group 1, 1960 census geography | `float32` | `47` |
| `popsharewomen_agegroup2_1960` | Women population share, age group 2, 1960 census geography | `float32` | `47` |
| `popsharemen_agegroup1_1960` | Men population share, age group 1, 1960 census geography | `float32` | `47` |
| `popsharemen_agegroup2_1960` | Men population share, age group 2, 1960 census geography | `float32` | `47` |
| `source_page_viii` | PDF source page for Cuadro VIII whole-province row | `float64` | `47` |
| `raw_chunk_viii` | Raw OCR chunk used for Cuadro VIII whole-province row | `str` | `50` |
| `parsed_token_count_viii` | Parsed token count in Cuadro VIII whole-province row | `int64` | `50` |
| `active_total_1950` | Economically active women, 1950 (whole province) | `float64` | `48` |
| `agri_total_1950` | Women in agriculture, 1950 (whole province) | `float64` | `48` |
| `mining_total_1950` | Women in mining, 1950 (whole province) | `float64` | `48` |
| `manufacturing_total_1950` | Women in manufacturing, 1950 (whole province) | `float64` | `48` |
| `construction_total_1950` | Women in construction, 1950 (whole province) | `float64` | `48` |
| `utilities_total_1950` | Women in utilities, 1950 (whole province) | `float64` | `48` |
| `commerce_total_1950` | Women in commerce, 1950 (whole province) | `float64` | `48` |
| `transport_total_1950` | Women in transport, 1950 (whole province) | `float64` | `48` |
| `services_total_1950` | Women in services, 1950 (whole province) | `float64` | `48` |
| `unspecified_total_1950` | Women in unspecified sectors, 1950 (whole province) | `float64` | `48` |
| `sector_sum_viii` | Sum of parsed sector counts in whole-province row | `float64` | `48` |
| `sector_gap_viii` | Sector sum minus active total in whole-province row | `float64` | `48` |
| `sector_gap_share_viii` | Absolute sector gap share in whole-province row | `float64` | `48` |
| `usable_viii` | Whole-province Cuadro VIII row passes audit | `int64` | `50` |
| `source_page_viii_cap` | PDF source page for Cuadro VIII capital row | `float64` | `48` |
| `raw_chunk_viii_cap` | Raw OCR chunk used for Cuadro VIII capital row | `str` | `50` |
| `parsed_token_count_viii_cap` | Parsed token count in Cuadro VIII capital row | `int64` | `50` |
| `active_total_1950_cap` | Economically active women, 1950 (provincial capital) | `float64` | `48` |
| `agri_total_1950_cap` | Women in agriculture, 1950 (provincial capital) | `float64` | `48` |
| `mining_total_1950_cap` | Women in mining, 1950 (provincial capital) | `float64` | `48` |
| `manufacturing_total_1950_cap` | Women in manufacturing, 1950 (provincial capital) | `float64` | `48` |
| `construction_total_1950_cap` | Women in construction, 1950 (provincial capital) | `float64` | `48` |
| `utilities_total_1950_cap` | Women in utilities, 1950 (provincial capital) | `float64` | `48` |
| `commerce_total_1950_cap` | Women in commerce, 1950 (provincial capital) | `float64` | `48` |
| `transport_total_1950_cap` | Women in transport, 1950 (provincial capital) | `float64` | `48` |
| `services_total_1950_cap` | Women in services, 1950 (provincial capital) | `float64` | `48` |
| `unspecified_total_1950_cap` | Women in unspecified sectors, 1950 (provincial capital) | `float64` | `48` |
| `sector_sum_viii_cap` | Sum of parsed sector counts in capital row | `float64` | `48` |
| `sector_gap_viii_cap` | Sector sum minus active total in capital row | `float64` | `48` |
| `sector_gap_share_viii_cap` | Absolute sector gap share in capital row | `float64` | `48` |
| `usable_viii_cap` | Capital Cuadro VIII row passes audit | `int64` | `50` |
| `agri_share_1950` | Agriculture share of active women, 1950 (whole province) | `float64` | `48` |
| `mining_share_1950` | Mining share of active women, 1950 (whole province) | `float64` | `48` |
| `manufacturing_share_1950` | Manufacturing share of active women, 1950 (whole province) | `float64` | `48` |
| `construction_share_1950` | Construction share of active women, 1950 (whole province) | `float64` | `48` |
| `utilities_share_1950` | Utilities share of active women, 1950 (whole province) | `float64` | `48` |
| `commerce_share_1950` | Commerce share of active women, 1950 (whole province) | `float64` | `48` |
| `transport_share_1950` | Transport share of active women, 1950 (whole province) | `float64` | `48` |
| `services_share_1950` | Services share of active women, 1950 (whole province) | `float64` | `48` |
| `unspecified_share_1950` | Unspecified-sector share of active women, 1950 (whole province) | `float64` | `48` |
| `industrial_core_share_1950` | Manufacturing plus construction share, 1950 (whole province) | `float64` | `48` |
| `oil_sensitive_share_1950` | Oil-sensitive sector share, 1950 (whole province) | `float64` | `48` |
| `manuf_trade_share_1950` | Manufacturing plus commerce share, 1950 (whole province) | `float64` | `48` |
| `nonag_share_1950` | Non-agricultural share, 1950 (whole province) | `float64` | `48` |
| `agri_share_1950_cap` | Agriculture share of active women, 1950 (provincial capital) | `float64` | `48` |
| `mining_share_1950_cap` | Mining share of active women, 1950 (provincial capital) | `float64` | `48` |
| `manufacturing_share_1950_cap` | Manufacturing share of active women, 1950 (provincial capital) | `float64` | `48` |
| `construction_share_1950_cap` | Construction share of active women, 1950 (provincial capital) | `float64` | `48` |
| `utilities_share_1950_cap` | Utilities share of active women, 1950 (provincial capital) | `float64` | `48` |
| `commerce_share_1950_cap` | Commerce share of active women, 1950 (provincial capital) | `float64` | `48` |
| `transport_share_1950_cap` | Transport share of active women, 1950 (provincial capital) | `float64` | `48` |
| `services_share_1950_cap` | Services share of active women, 1950 (provincial capital) | `float64` | `48` |
| `unspecified_share_1950_cap` | Unspecified-sector share of active women, 1950 (provincial capital) | `float64` | `48` |
| `industrial_core_share_1950_cap` | Manufacturing plus construction share, 1950 (provincial capital) | `float64` | `48` |
| `oil_sensitive_share_1950_cap` | Oil-sensitive sector share, 1950 (provincial capital) | `float64` | `48` |
| `manuf_trade_share_1950_cap` | Manufacturing plus commerce share, 1950 (provincial capital) | `float64` | `48` |
| `nonag_share_1950_cap` | Non-agricultural share, 1950 (provincial capital) | `float64` | `48` |
| `active_total_1950_rest` | Economically active women, 1950 (rest of province) | `float64` | `48` |
| `agri_total_1950_rest` | Women in agriculture, 1950 (rest of province) | `float64` | `48` |
| `mining_total_1950_rest` | Women in mining, 1950 (rest of province) | `float64` | `48` |
| `manufacturing_total_1950_rest` | Women in manufacturing, 1950 (rest of province) | `float64` | `48` |
| `construction_total_1950_rest` | Women in construction, 1950 (rest of province) | `float64` | `48` |
| `utilities_total_1950_rest` | Women in utilities, 1950 (rest of province) | `float64` | `48` |
| `commerce_total_1950_rest` | Women in commerce, 1950 (rest of province) | `float64` | `48` |
| `transport_total_1950_rest` | Women in transport, 1950 (rest of province) | `float64` | `48` |
| `services_total_1950_rest` | Women in services, 1950 (rest of province) | `float64` | `48` |
| `unspecified_total_1950_rest` | Women in unspecified sectors, 1950 (rest of province) | `float64` | `48` |
| `sector_sum_viii_rest` | Sum of derived sector counts in rest-of-province row | `float64` | `50` |
| `sector_gap_viii_rest` | Derived sector sum minus active total in rest-of-province row | `float64` | `48` |
| `sector_gap_share_viii_rest` | Absolute sector gap share in rest-of-province row | `float64` | `48` |
| `usable_viii_rest_strict` | Rest-of-province row passes strict audit | `float64` | `50` |
| `usable_viii_rest_soft` | Rest-of-province row recovered by soft audit | `float64` | `50` |
| `usable_viii_rest` | Rest-of-province row passes strict or soft audit | `float64` | `50` |
| `agri_share_1950_rest` | Agriculture share of active women, 1950 (rest of province) | `float64` | `48` |
| `mining_share_1950_rest` | Mining share of active women, 1950 (rest of province) | `float64` | `48` |
| `manufacturing_share_1950_rest` | Manufacturing share of active women, 1950 (rest of province) | `float64` | `48` |
| `construction_share_1950_rest` | Construction share of active women, 1950 (rest of province) | `float64` | `48` |
| `utilities_share_1950_rest` | Utilities share of active women, 1950 (rest of province) | `float64` | `48` |
| `commerce_share_1950_rest` | Commerce share of active women, 1950 (rest of province) | `float64` | `48` |
| `transport_share_1950_rest` | Transport share of active women, 1950 (rest of province) | `float64` | `48` |
| `services_share_1950_rest` | Services share of active women, 1950 (rest of province) | `float64` | `48` |
| `unspecified_share_1950_rest` | Unspecified-sector share of active women, 1950 (rest of province) | `float64` | `48` |
| `industrial_core_share_1950_rest` | Manufacturing plus construction share, 1950 (rest of province) | `float64` | `48` |
| `oil_sensitive_share_1950_rest` | Oil-sensitive sector share, 1950 (rest of province) | `float64` | `48` |
| `manuf_trade_share_1950_rest` | Manufacturing plus commerce share, 1950 (rest of province) | `float64` | `48` |
| `nonag_share_1950_rest` | Non-agricultural share, 1950 (rest of province) | `float64` | `48` |
| `female_young_share_1960` | Female young-population share, 1960 census geography | `float32` | `47` |
| `female_young_share_1970` | Female young-population share, 1970 census geography | `float32` | `50` |
| `male_young_share_1960` | Male young-population share, 1960 census geography | `float32` | `47` |
| `male_young_share_1970` | Male young-population share, 1970 census geography | `float32` | `50` |
| `proxy_usable_pre73` | Whole-province proxy usable for pre-1973 analysis | `int64` | `50` |
| `proxy_usable_pre73_cap` | Capital proxy usable for pre-1973 analysis | `int64` | `50` |
| `proxy_usable_pre73_rest` | Rest-of-province proxy usable for pre-1973 analysis | `float64` | `50` |
