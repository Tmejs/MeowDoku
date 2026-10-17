# Ticket 03 — Session and persistence

## Objective

Make puzzle edits, undo, completion, and progress durable without network access.

## Target repository

`https://github.com/Tmejs/MeowDoku`

## Scope

Implement the pure session reducer and Drift tables from `docs/app-schema.md`, repository methods, and a Riverpod controller. Keep one resumable unfinished puzzle per difficulty; Home Continue chooses the most recently updated. Wrong cat attempts produce transient feedback but never persist an incorrect cat. X marks remain free notes. Completion requires all solution cats, not all X marks.

## Acceptance criteria

- Mark X, place cat, clear, and Undo have deterministic reducer tests, including repeated taps and undo after a wrong attempt.
- Wrong placement leaves stored board unchanged and returns a transient `Missed!` event.
- Successful edits autosave; relaunch restores the exact active board for each difficulty.
- Solved history survives replay, difficulty switching, and corrupt/obsolete session recovery.
- No network call is needed for any session operation.

## Checks

- `cd mobile && ./tool/verify.sh`
- `git diff --check`

## Dependencies

Ticket 02.
