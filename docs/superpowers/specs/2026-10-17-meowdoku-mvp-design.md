# MeowDoku MVP design

**Date:** 2026-10-17
**Status:** Approved direction; implementation details below are Codex's proposed defaults
**Working name:** MeowDoku; release name and art are original and can change.

## Purpose

Build a pleasant, offline mobile logic game inspired by the screenshot discussed with the user. The first release should make deduction and puzzle quality the main attraction. A player chooses a difficulty, solves a board, and can return to unfinished progress. It is not a copy of the reference game's artwork, branding, score, currency, ads, or lives.

## MVP boundaries

- Android and iOS, portrait-first, Flutter and Dart.
- Four difficulty choices, provisionally **Easy, Medium, Hard, Expert**.
- A bundled, fixed pool of **100 puzzles**, 25 per difficulty, generated and verified before release. New puzzle generation on the device or a server is reserved for a later version.
- No account, network dependency, backend, advertising, leaderboard, timer pressure, score, lives, currency, or paid hint system.
- Local autosave of the active puzzle in each difficulty, cell marks, solved puzzle IDs, and the last chosen difficulty. Switching difficulty preserves every unfinished board. Solved puzzles may be replayed; replay does not erase completion history.
- Original colors, cat illustration, typography, app icon, and sound. The current repository name is a working title, not an instruction to reproduce the reference game's assets.

## Puzzle rules and board data

An N×N board contains N colored regions and exactly N hidden cats. A solution has exactly one cat in every row, every column, and every region. No two cats touch, including at corners. Rows and columns already prevent horizontal or vertical touching; cats in adjacent rows must therefore have columns separated by at least two.

Each puzzle stores a stable ID, difficulty, size N, N×N region ID grid, and solution column for each row. The enclosing pack has a `schemaVersion` for the JSON format and an immutable `packId` for its content revision. Region IDs are semantic data and are mapped to the current visual palette by the app. Every region is orthogonally connected, nonempty, and contains its solution cat. Puzzle validation checks these invariants and counts all rule-compliant solutions; only exactly-one-solution boards ship.

Initial size targets are 5×5, 6×6, 8×8, and 10×10 for Easy through Expert. These are authoring targets, not the sole difficulty measure. If playtesting shows a puzzle is misplaced, move it to another pool or reject it.

## Play flow

The home screen shows the four difficulties, solved counts, and a Continue action for the most recently played unfinished puzzle. Choosing a difficulty resumes its unfinished puzzle if one exists; otherwise it opens its next unsolved puzzle in a stable, authored order. Completing it records completion and offers the next puzzle in that difficulty. Finishing all 25 allows replay; it does not silently repeat a solved board as new.

The board remains square and fits the available width. The player can mark a cell with X, place a cat, or clear it. Default touch behavior is one tap for X and double tap for cat, following the reference interaction. Visible Mark, Cat, and Clear actions provide an alternative to double tap for accessibility and discoverability. Undo reverses the last board edit. Cats already placed rule out candidate cells visually, but automatic X marks must remain distinguishable from the player's marks and must not overwrite them.

Placing a cat on a cell outside the puzzle's unique solution does not commit the cat. That cell flashes red briefly and a small, nonmodal "Missed!" message appears. There is no life loss or game-over state. X marks are notes and are never penalized. A correct cat stays placed. Completion occurs when all N solution cats are placed; X marks are optional.

One Hint action is always available. It reveals a valid next logical deduction with a short explanation tied to a row, column, region, or no-touching rule. It highlights the relevant cells rather than placing a cat automatically. Hints do not consume currency. The deduction engine treats player X marks as notes, not premises: an incorrect note cannot turn a guess into a supposedly forced move. If a hint refers to cells already marked by the player, it still explains the deduction and can identify a conflicting note without changing the board.

## Puzzle creation and quality gate

The generation tool is development-only. It uses a recorded random seed and version so packs can be reproduced. For each size:

1. Draw a solution as a randomized permutation of columns, one per row, rejecting adjacent-row columns whose difference is one.
2. Seed one region at each solution cat. Grow regions through orthogonal neighboring cells until every cell belongs to exactly one region. Vary frontier choices and region-size targets to avoid uniform blobs and tiny isolated slivers.
3. Count solutions with a separate backtracking solver using row order, unused-column and unused-region bitsets, and the adjacent-row spacing rule. Stop at two solutions. Reject zero or multiple solutions.
4. Run a human-style deduction solver. It records a sequence of eliminations and forced placements using single-candidate rows, columns, and regions, no-touch exclusions, and row/region candidate interactions. Reject boards that cannot be completed with the supported techniques; the hint system can replay a valid next step.
5. Rate boards using deduction depth, number of candidates eliminated per step, and technique variety. Playtest samples in each band. Reject poor color contrast, awkward regions, and near-duplicates under rotation, reflection, and region-label renaming.

The pack build fails unless there are exactly 25 valid, unique, solvable boards per difficulty, no duplicate canonical boards, and each hint trace reaches the unique solution. The bundled pack is immutable after release; a future pack uses a new `packId`. Any changed board also gets a new puzzle ID, so existing saves never silently attach to different content.

## Technical structure

- **Pure Dart puzzle core:** puzzle model, validation, solution counting, candidate calculation, deduction traces, and game-state reducer. No Flutter dependencies in the core.
- **Flutter UI:** home, difficulty selection, puzzle screen, feedback, hint overlay, completion, and settings for region labels and reduced motion.
- **Riverpod:** exposes the current puzzle session and coordinates autosave.
- **Drift:** stores local progress and preferences. Bundled puzzle definitions are assets, not database rows.
- **Offline tooling:** a deterministic generator and pack verifier run during development. The game never requires a network call to solve or load a level.

The puzzle solution is bundled locally to validate placements; it is not a security boundary. A later online leaderboard would require separate server-side verification and is outside this MVP.

## Experience and accessibility

The game's appearance should feel friendly and calm with original cat art. Regions must remain distinguishable by more than hue: subtle borders and optional region labels or patterns should support color-blind players. Cells and controls need accessible labels and sufficiently large touch targets at supported device sizes. Feedback must not rely solely on the red flash; the "Missed!" message has an accessible announcement. Reduced-motion settings suppress flashes and nonessential animation.

The initial release is English-first. UI text should be centralized so Polish localization can be added without changing puzzle logic.

## Verification and release criteria

- Pure puzzle tests cover valid and invalid boards, uniqueness, connectivity, deduction trace correctness, and difficulty pack invariants.
- Session tests cover marking, placing, clearing, undo, wrong-cat feedback, completion, save and restore.
- Flutter widget tests cover difficulty selection, core board interaction, hint display, and small-screen layout.
- The local gate runs formatting, static analysis, all tests, the 100-puzzle pack audit, and `git diff --check`.
- Independent review finds no Critical or Important issues before pushing. The checkpoint branch is pushed and merged to `main` using the user's Git workflow.

## Later versions

Generate a fresh validated puzzle as a player starts, add daily puzzles, analytics-informed difficulty tuning, additional localization, and optional online features only after the static offline game is enjoyable and reliable.
