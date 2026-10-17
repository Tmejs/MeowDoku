# Ticket 05 — Hints and accessibility

## Objective

Make every shipped puzzle explainable and the game playable without relying on color or double taps.

## Target repository

`https://github.com/Tmejs/MeowDoku`

## Scope

Wire the deduction trace to a Hint action that highlights a justified next step and explains it in concise language without editing the board. Finish Settings with region-label and reduced-motion choices. Add semantic labels, explicit placement controls, region labels/patterns, reduced-motion behavior, and accessible mistake announcement. Centralize copy for later translation.

## Acceptance criteria

- Hint always returns a valid deduction for any unsolved shipped puzzle state reachable by correct moves and arbitrary X notes, or clearly reports completion. X notes are ignored as proof premises; a conflicting note can be identified without silently changing it.
- Hint does not place a cat, mark an X, consume currency, or change saved progress.
- All controls have accessible labels and an alternative to double tap.
- Region identity and wrong placement remain understandable without color or animation.
- Widget and core tests cover hint behavior after arbitrary notes, semantics, and reduced motion.

## Checks

- `cd mobile && ./tool/verify.sh`
- `python3 tools/audit_puzzle_pack.py mobile/assets/puzzles/mvp-v1.json`
- `git diff --check`

## Dependencies

Ticket 04.
