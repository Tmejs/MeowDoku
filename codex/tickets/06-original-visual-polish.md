# Ticket 06 — Original visual polish and mobile QA

## Objective

Replace placeholders with an original, coherent cat-game identity and verify the full MVP on mobile targets.

## Target repository

`https://github.com/Tmejs/MeowDoku`

## Scope

Create original cat art, app icon, palette, typography, restrained motion, and completion treatment. Review the game on representative small and large Android/iOS screens. Correct visual or interaction defects found during that review. Keep the initial release English-first and offline. Do not copy the reference game's cat graphics, advertising, brand marks, or monetization elements.

## Acceptance criteria

- All player-facing art and branding are original or properly licensed and their sources are recorded.
- The board and controls are legible at all four sizes on small and large portrait screens.
- Reduced motion and non-color cues still work after visual polish.
- The full 100-puzzle audit, Flutter local gate, and device smoke checks pass; unavailable device checks are recorded plainly.
- README describes only behavior verified in the completed app.

## Checks

- `cd mobile && ./tool/verify.sh`
- `python3 tools/audit_puzzle_pack.py mobile/assets/puzzles/mvp-v1.json`
- `git diff --check`

## Dependencies

Ticket 05.
