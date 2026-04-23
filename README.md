# Educated to Be Mothers

Research workspace for the paper and revision package around Franco's 1945 primary-school reform, fertility, beliefs, and related robustness exercises for Spain.

## What Is Here

- `Marco/`: main replication package, Stata code, analysis data, and revision code used for the current paper workflow.
- `JOLE_comments/`: reviewer-response material, selected revision analyses, appendix tables, and notes for the JOLE revision.
- `Paper/` and `slides/`: paper drafts, presentation material, and supporting visual assets.
- `codex/`: external-source builds, generated revision datasets, OCR notes, and Codex-side outputs.
- `results/`, `comments/`, `SUBMISSIONS/`: legacy outputs, notes, and submission bundles.

Large raw and generated data are intentionally excluded from GitHub versioning through `.gitignore`.

## Current Revision Focus

- Micro evidence from CIS and census data.
- Macro locality-year fertility analysis.
- Robustness blocks on Law 56/1961, birthplace vs residence, Civil War exposure, migration, and pre-1973 productive structure / oil-shock heterogeneity.

## Tooling In This Repo

- `code-review-graph` is configured in [.mcp.json](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/.mcp.json) and [.opencode.json](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/.opencode.json) for graph-first code exploration and review.
- `Caveman` by Julius Brussee is vendored under [plugins/caveman](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/plugins/caveman) with local marketplace metadata in [.agents/plugins/marketplace.json](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/.agents/plugins/marketplace.json).
- Repo-local Codex hook activation is enabled in [.codex/config.toml](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/.codex/config.toml) and [.codex/hooks.json](/Users/marcolemoglie_1_2/Library/CloudStorage/Dropbox/PURGE/.codex/hooks.json).

## Typical Workflow

1. Build or refresh analysis data from `Marco/DO/code_2026_04_10/code/prep_data/`.
2. Run the paper-order or selected-revision Stata scripts.
3. Inspect tables and figures in `results/` and `JOLE_comments/`.
4. Promote final tables/text to the Overleaf paper only after results are validated.

## Git Notes

- Remote: `origin = https://github.com/MarcoLeMoglie/Educated_to_Be_Mothers.git`
- Default branch: `main`
