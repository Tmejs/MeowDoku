# App schema for the MVP

This document fixes the product boundaries and data contracts for implementation tickets. It does not imply the app has been implemented.

## Screens and routes

| Screen | Input | Output |
| --- | --- | --- |
| Home | saved progress summary | Continue, Choose difficulty, Settings |
| Difficulty | four pools with solved counts | resume that pool or open its next unsolved puzzle |
| Puzzle | puzzle definition and saved session | edits, hint, undo, completion |
| Completion | solved puzzle ID | replay or next unsolved puzzle in the pool |
| Settings | local preferences | region labels/patterns and reduced-motion override |

No login, shop, leaderboard, network fetch, or on-device generation route exists in the MVP.

## Data boundaries

```text
Bundled puzzle pack (read-only JSON)
        │
        ▼
Pure Dart puzzle core ── deductions / validation / reducer
        │
        ▼
Riverpod session controller ── Flutter screens
        │
        ▼
Drift local store (progress and preferences only)
```

### Puzzle definition

The bundled pack conforms to [`puzzle-pack-v1.schema.json`](../schemas/puzzle-pack-v1.schema.json). A puzzle has a stable ID, one of four difficulty IDs, size, square region grid, and one solution column per row. Color values are presentation mappings and do not occur in puzzle data. `schemaVersion` versions the JSON format; `packId` is the immutable content revision (for example `mvp-v1`) and changes whenever a released pack's content changes. A dedicated validator must enforce cross-field invariants that JSON Schema cannot express: grid dimensions equal `size`, region IDs are `0..size-1` and match the puzzle difficulty/ID, all regions are orthogonally connected, the solution obeys every rule, exactly one solution exists, and 25 puzzles exist per difficulty.

### Local progress

The proposed Drift schema uses three tables:

| Table | Key fields | Purpose |
| --- | --- | --- |
| `puzzle_sessions` | `puzzle_id` primary key, `pack_id`, `cell_marks_json`, `undo_json`, `updated_at` | preserve unfinished marks for each puzzle; only the active puzzle in a difficulty needs a live row |
| `completed_puzzles` | `puzzle_id` primary key, `completed_at` | keep durable solved history independently of replay |
| `preferences` | single row, `last_difficulty`, `region_labels_enabled`, `reduced_motion_override` | restore app choices |

Cell marks are an N×N array of `empty`, `x`, or `cat`. Automatic exclusion graphics and red mistake flashes are derived UI state and are never persisted. Each persisted mark array is validated against its puzzle ID, size, and exact `packId` when loaded; a corrupt or obsolete session is ignored without losing completed history. `puzzle_id` remains stable across pack updates; changing a board under an existing ID is forbidden, so a changed board requires a new ID. The saved session with the latest `updated_at` powers Home's Continue action. Difficulty selection resumes that difficulty's latest unfinished session, if present.

### Pure core interfaces

- `PuzzleDefinition`: immutable board and solution data.
- `PuzzleValidator`: checks board shape, connectivity, rules, and uniqueness.
- `PuzzleSolver`: counts solutions up to two, and produces a logical deduction trace.
- `PuzzleSession`: immutable player marks and undo history.
- `applyAction(session, action)`: returns a new session plus transient feedback; persistence follows accepted edits.
- `nextHint(puzzle, session)`: returns one justified deduction and highlighted cells without editing marks.

The implementation may refine Dart names and field types, but tickets must keep these boundaries. Puzzle validation and generation are development tools; the app does not generate new boards at runtime.

## Difficulty and pack policy

| ID | Display name | Target size | Count |
| --- | --- | --- | ---: |
| `easy` | Easy | 5×5 | 25 |
| `medium` | Medium | 6×6 | 25 |
| `hard` | Hard | 8×8 | 25 |
| `expert` | Expert | 10×10 | 25 |

Difficulty is reviewed from the logical deduction trace and playtesting, not inferred solely from size. The first pack is immutable after release. A later pack has a new `packId`; unchanged boards retain their IDs, while changed or added boards receive new IDs so old progress never points to different content.

## SoftwareFactory handoff

The existing SoftwareFactory v1 workflow is repo-local and its job validator currently fixes its target repository to `Tmejs/SoftwareFactory`. It cannot execute a MeowDoku ticket unchanged. The ticket plan therefore includes a prerequisite to make that workflow usable for this target repository. Until then, these tickets are planning records, not active factory jobs. Do not create `factory/jobs/` state files or claim a factory run from this repo by merely reading the tickets.
