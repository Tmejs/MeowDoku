# Ticket 02 — Puzzle core and 100-board pack

## Objective

Ship a deterministic, verified asset pack containing 25 solvable puzzles per difficulty and a pure Dart rules engine.

## Target repository

`https://github.com/Tmejs/MeowDoku`

## Scope

Implement immutable puzzle models, pack loading, invariant checks, a solution counter capped at two, a deduction trace, a development-only seeded region generator, pack audit tooling, and the bundled JSON pack. Follow `schemas/puzzle-pack-v1.schema.json` and `docs/app-schema.md`. The generator may use Python or Dart but must be reproducible from committed seed/configuration. No Flutter UI changes beyond asset registration.

## Acceptance criteria

- Exactly 100 stable puzzle IDs ship, 25 in each difficulty and sizes 5, 6, 8, 10 respectively.
- Every region is connected; every target placement obeys row, column, region, and no-touch rules; independent solution count is exactly one.
- A deduction trace solves every shipped puzzle without guessing and supplies a reason for every hint step.
- Rotated/reflected/region-renamed duplicate boards are rejected by the pack audit.
- Generator inputs and output hash are recorded so the pack can be reproduced.
- Tests include invalid dimensions, disconnected regions, zero/multiple solutions, and corrupted pack data.

## Checks

- `cd mobile && ./tool/verify.sh`
- `python3 tools/audit_puzzle_pack.py mobile/assets/puzzles/mvp-v1.json`
- `git diff --check`

## Dependencies

Ticket 01.
