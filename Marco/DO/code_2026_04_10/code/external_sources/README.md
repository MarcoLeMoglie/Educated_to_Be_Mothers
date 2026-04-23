# External Sources Code

This folder contains the external-source construction and revision checks used with the `code_2026_04_10` replication bundle.

## Folder Structure

- `scripts/`: Python and shell scripts that download, clean, or build external-source datasets.
- `stata_active/`: Stata analyses that are still candidates for the revision design.
- `stata_diagnostics/`: one-off diagnostic or verification Stata scripts, including the balancing-table rebuild.
- `deprecated_capital_rest/`: capital/rest-of-province oil-shock specifications. These are kept for auditability but should not be used for the current design because the OCR is too fragile at that level.
- `cache/`: generated interpreter cache files.

## Current Oil-Shock Decision

The capital/rest-of-province macro specification is deprecated. The current review path keeps the whole-province OCR/proxy workflow for further manual validation. After manual OCR corrections are finalized, rerun the whole-province macro analysis and the micro birthplace analysis before deciding whether to update the paper, report, or final do-files.

Relevant files:

- `scripts/build_pre73_crisis_proxies.py`
- `stata_active/external_revision_02_crisis73_macro_proxies_wholeprovince.do`
- `stata_active/revision_08_birthplace_crisis73.do`

## Notes

No paper or report files are updated from this folder. Outputs should be inspected first, then promoted manually into the paper/report only after the final specification is selected.
