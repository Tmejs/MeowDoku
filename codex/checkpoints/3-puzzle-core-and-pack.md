# Checkpoint 3 — puzzle core and 100-board pack

**Branch:** `codex/checkpoint-3-puzzle-core`

**Base:** `8b3a886ee13d7a6727ccfa828a11b36fb24b0d9a` (`main` and `origin/main` matched after fetch)

**Implementation commits:** `987a2f3`, `6a004e3`

## Scope

- Pure Dart immutable puzzle definition, exact capped solution counter, validator, candidate-propagation deductions, and bundled pack loader.
- Python seeded generator, independent pack audit, tests, and 100-board JSON asset: 25 each at 5×5, 6×6, 8×8, and 10×10.
- No UI gameplay or persistence in this checkpoint.

## Generation record

- Generator version 1; Python 3.9.6; seed `20261017`.
- Configuration: singleton region counts 3/2/2/4; connected boundary optimization for 8×8 and 10×10; minimum candidate-interaction steps 0/1/1/2.
- Attempts: Easy 28, Medium 158, Hard 83, Expert 351.
- Asset SHA-256: `99bc2dc65d803476f1ad5bd5a8f7390b8edc83aba190d045b34f014b1064b1b5`.
- Independently regenerated with `--output /private/tmp/meowdoku-mvp-v1-repro.json`; `cmp` against the committed asset returned exit 0 and `shasum -a 256` matched the hash above. The second run reported the same seed, version, and attempt counts.

## Verification

- Focused Flutter tests: observed expected red state before core implementation; later 8 puzzle tests passed.
- Final `cd mobile && FLUTTER_BIN=/Users/matrzad/develop/flutter-3.47.3/flutter/bin/flutter ./tool/verify.sh`: exit 0; format 0 changes, Flutter analyze no issues, 10 Flutter tests passed, 8 Python tests passed, pack audit passed.
- Audit checks 100 stable IDs, 25 per pool, dimensions, connected regions, valid stored cats, exactly one solution, complete deduction traces, difficulty thresholds, and duplicate grids under rotations, reflections, and region relabeling.
- Representative boards for each difficulty and trace technique counts inspected with `dart run tool/inspect_pack.dart`. The interaction-step totals were Easy 0, Medium 31, Hard 37, Expert 55. Human playtesting is still required to calibrate difficulty.
- `git diff --cached --check` passed before both implementation and review-fix commits; `git diff --check 8b3a886 HEAD` passed on the final implementation branch. The merged-main gate is required during delivery.

## Independent review

- Initial review found that exhaustive solution search made the original deduction trace trivially complete. Fixed in `6a004e3` with rule-only candidate support elimination and regenerated pack.
- Final independent review of `6a004e3` versus `main` found no Critical or Important issues. The reviewer reran the pack audit, eight Python tests, and `git diff --check`, all passing.
- Minor follow-up for Ticket 05: interaction hints should identify the specific witness unit/cells behind a candidate elimination, rather than only name the forced row, column, or region.
