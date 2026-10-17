# Ticket 04 — Playable screens

## Objective

Deliver the complete offline flow from difficulty selection through solving and continuing puzzles.

## Target repository

`https://github.com/Tmejs/MeowDoku`

## Scope

Implement Home, Difficulty, Puzzle, and Completion screens using the existing core and session controller. Keep Settings reachable as a placeholder for Ticket 05. Draw a square, responsive board with region styling, player Xs, cats, and distinguishable automatic exclusions. Provide one-tap X, double-tap cat, explicit Mark/Cat/Clear controls, Undo, red wrong-cell indication, and nonmodal `Missed!` text. Do not add score, hearts, ads, or leaderboards.

## Acceptance criteria

- Home shows solved counts and Continue for the most recent unfinished puzzle.
- Difficulty resumes its unfinished board or opens its next unsolved puzzle in authored order.
- The player can solve a puzzle using touch controls; completion records progress and offers next/replay.
- Wrong placement briefly shows red plus `Missed!` and does not block input or consume progress.
- Board remains usable in small portrait layouts without clipped cells or controls.
- Widget tests cover navigation, marks, cat placement, wrong feedback, completion, and restore.

## Checks

- `cd mobile && ./tool/verify.sh`
- `git diff --check`

## Dependencies

Ticket 03.
