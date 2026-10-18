# Checkpoint 4 — session and offline persistence

**Branch:** `codex/checkpoint-4-session-persistence`

**Base:** `34977c910ec99b3f8e3a3a119a28195713893013` (`main`, `origin/main`, and remote `main` matched after fetch)

**Implementation commits:** `922c5be`, `a883cb0`

## Scope

- Immutable player session and deterministic X, cat, clear, and Undo reducer. Wrong cat attempts return a transient `Missed!` event without changing marks or Undo. All correct cats finish a puzzle without X requirements.
- Drift SQLite tables for active sessions, completed puzzles, and preferences; generated typed schema. The repository autosaves accepted edits and retains one unfinished session per difficulty. Continue selects the newest saved activity.
- Riverpod controller serializes rapid edits and exposes open, resume, replay, and action operations. Widget wiring remains in Ticket 04.
- A shared 1,000-frame Undo limit bounds storage and keeps every accepted saved state restorable.

## Verification

- Reducer, persistence, and controller tests were observed failing before implementation. A regression for excessive Undo depth failed before the review fix, then passed.
- Focused reducer, SQLite file reopen, and Riverpod tests passed. SQLite tests cover exact marks and Undo across relaunch, difficulty switching, newest Continue, wrong-attempt no-write, solved replay history, corrupt/obsolete save recovery, and preferences.
- Final `cd mobile && FLUTTER_BIN=/Users/matrzad/develop/flutter-3.47.3/flutter/bin/flutter ./tool/verify.sh`: exit 0; format 0 changes, analyzer no issues, 24 Flutter tests passed, 8 Python tests passed, and 100-board pack audit passed with SHA-256 `99bc2dc65d803476f1ad5bd5a8f7390b8edc83aba190d045b34f014b1064b1b5`.
- `git diff --check` passed after the review fix. The merged-main gate remains to be run during delivery.

## Independent review

- Initial reviewer found an Important data-loss path: the reducer allowed more than 10,000 Undo frames but restore rejected them. Fixed in `a883cb0` using one shared 1,000-frame limit, with a failing-first regression test.
- Re-review found no remaining Critical or Important issues; reviewer confirmed `git diff --check` clean.
