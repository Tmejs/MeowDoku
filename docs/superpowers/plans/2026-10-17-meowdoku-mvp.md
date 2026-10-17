# MeowDoku MVP Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking. Each ticket is a separate checkpoint and, after Ticket 00, may be frozen into a SoftwareFactory job.

**Goal:** Deliver an original offline Flutter cat logic game with four difficulty choices and 100 static, uniquely solvable puzzles.

**Architecture:** A versioned JSON puzzle pack is bundled as an asset. Pure Dart owns rules and session transitions; Riverpod coordinates UI state and Drift persists progress. A development-only generator and independent audit create the pack before release.

**Tech Stack:** Flutter, Dart, Riverpod, Drift, Python 3 standard library for pack tooling, Git.

**Spec:** `docs/superpowers/specs/2026-10-17-meowdoku-mvp-design.md`; data and screen contract: `docs/app-schema.md`; work packets: `codex/tickets/`.

## Global Constraints

- Android and iOS, portrait-first; offline play.
- Four difficulty pools of 25 puzzles each, with target sizes 5×5, 6×6, 8×8, and 10×10.
- Every shipped puzzle has one rule-compliant solution, connected regions, and an explanatory deduction trace.
- Wrong cat placement shows brief red feedback and `Missed!`, with no life loss; X notes are never penalized.
- Preserve one unfinished session per difficulty, durable completion history, and the most recent Continue target.
- Use original art and branding; no score, hearts, currency, ads, accounts, backend, leaderboard, or runtime puzzle generation in the MVP.
- Each implementation ticket starts from synchronized `main` on a new checkpoint branch and receives independent review before push.
- SoftwareFactory v1 cannot target this repository unchanged; Ticket 00 is a prerequisite for factory execution.

## Review Focus

1. A pack with multiple solutions must be rejected, even if its stored target solution is valid (Ticket 02).
2. A region split into disconnected islands must be rejected despite having one cat (Ticket 02).
3. A wrong cat attempt must not alter saved marks or Undo history (Ticket 03).
4. Switching difficulty must preserve the previous unfinished session and Continue must select the latest updated one (Tickets 03–04).
5. A hint after arbitrary X notes must prove its deduction from puzzle rules and correct cats, not from the player's potentially mistaken notes (Ticket 05).

## File map

| Area | Responsibility |
| --- | --- |
| `mobile/lib/src/puzzle/core/` | immutable puzzle model, validation, exact solver, logical deductions |
| `mobile/lib/src/puzzle/session/` | pure board actions and transient feedback |
| `mobile/lib/src/puzzle/data/` | pack loader and Drift progress repository |
| `mobile/lib/src/puzzle/application/` | Riverpod controller and session selection |
| `mobile/lib/src/puzzle/presentation/` | Home, Difficulty, Puzzle, Completion, Settings widgets |
| `mobile/assets/puzzles/mvp-v1.json` | immutable 100-board pack |
| `tools/` | seeded generation and independent pack audit |
| `mobile/tool/verify.sh` | local Flutter gate |
| `codex/checkpoints/` | checkpoint verification and review evidence |

Each file under these areas should have one clear responsibility. The ticket implementer chooses final filenames and records any intentional deviation in that checkpoint's plan/spec.

## Task 00: Factory target support

**Ticket:** `codex/tickets/00-factory-target-support.md`
**Target:** separate SoftwareFactory repository.

- [ ] Write tests there for a MeowDoku target packet, preserved SoftwareFactory target behavior, incorrect baseline/target combinations, and safe artifact paths; run them and observe failure.
- [ ] Generalize intake, resume, validation, and durable job-location documentation to make those tests pass.
- [ ] Run that repository's full unit gate and a disposable MeowDoku-target dry run; record review evidence and deliver its checkpoint under that repository's Git rules.

This task changes no MeowDoku product files. The human's current request authorizes preparing the ticket, not starting the separate repository change in this planning phase.

## Task 01: Flutter foundation

**Ticket:** `codex/tickets/01-flutter-foundation.md`
**Produces:** runnable `mobile/` shell, routes including Settings placeholder, centralized strings, `mobile/tool/verify.sh`.

- [ ] Write a widget test that starts the app and opens Difficulty, Puzzle, and Settings placeholders; run it and observe failure.
- [ ] Scaffold Flutter Android/iOS project; add the minimal app root, routes, Riverpod/Drift dependencies, and strings to satisfy the test.
- [ ] Create the gate script and run `cd mobile && ./tool/verify.sh`; record its exit code and output.
- [ ] Update README with verified commands, review, commit, and deliver this checkpoint.

## Task 02: Puzzle core and pack

**Ticket:** `codex/tickets/02-puzzle-core-and-pack.md`
**Produces:** pure puzzle APIs, deterministic generator, independent audit, 100-board pack.

- [ ] Write failing pure tests for rules, dimension mismatch, disconnected regions, zero/multiple solutions, deduction trace replay, and canonical duplicate detection.
- [ ] Implement model, capped backtracking solver, invariant validator, and logical deductions; run focused tests then full Flutter gate.
- [ ] Implement seeded generation and independent audit, then generate 25 accepted boards in each difficulty. Store seed/configuration and pack hash.
- [ ] Run `python3 tools/audit_puzzle_pack.py mobile/assets/puzzles/mvp-v1.json` and full gate; inspect representative boards visually and record acceptance yield and review findings.
- [ ] Commit the pack and tooling separately from later review fixes; deliver the checkpoint.

## Task 03: Session and persistence

**Ticket:** `codex/tickets/03-session-and-persistence.md`
**Consumes:** Ticket 02 puzzle model and pack IDs.
**Produces:** pure session reducer, Drift local store, Riverpod controller.

- [ ] Write failing reducer tests for X/cat/clear/Undo, wrong placement unchanged, and completion without X marks.
- [ ] Implement the reducer and transient feedback; run focused and full tests.
- [ ] Write failing persistence tests for resume per difficulty, newest Continue target, replay history, and corrupt/obsolete session recovery.
- [ ] Implement Drift tables, repository, and controller; run `cd mobile && ./tool/verify.sh`, review, and deliver.

## Task 04: Playable screens

**Ticket:** `codex/tickets/04-playable-screens.md`
**Consumes:** Ticket 03 controller.
**Produces:** complete Home → Difficulty → Puzzle → Completion flow.

- [ ] Write failing widget tests for choosing/resuming difficulty, single X tap, double cat tap, explicit controls, Undo, wrong feedback, and completion.
- [ ] Implement the four screens, responsive board, player/automatic mark distinction, and transient feedback until tests pass.
- [ ] Run the full gate plus manual small-screen portrait inspection; record screenshots or observations, review, and deliver.

## Task 05: Hints and accessibility

**Ticket:** `codex/tickets/05-hints-and-accessibility.md`
**Consumes:** Ticket 02 deduction trace and Ticket 04 UI.
**Produces:** hint explanations, Settings choices, and non-color, non-double-tap access.

- [ ] Write failing tests that request hints after correct cats and arbitrary X notes, and assert no board mutation or false forced-cat claim.
- [ ] Implement hint selection, explanation, and highlight from supported deductions; audit every shipped puzzle's trace.
- [ ] Write failing widget tests for semantic labels, explicit cat placement, reduced motion, and mistake announcement; implement them.
- [ ] Run the full gate and pack audit, independent UI/code review, and deliver.

## Task 06: Original visual polish and mobile QA

**Ticket:** `codex/tickets/06-original-visual-polish.md`
**Consumes:** playable, accessible MVP.
**Produces:** original identity and verified release candidate.

- [ ] Inventory placeholder art and create original assets with recorded sources; keep the existing interaction tests as regression checks.
- [ ] Apply palette, cat art, icon, typography, and restrained motion; inspect 5×5 through 10×10 layouts on representative small and large portrait devices.
- [ ] Fix observed visual/accessibility defects and add a focused regression test for each behavioral defect.
- [ ] Run full Flutter gate, pack audit, `git diff --check`, device smoke checks where available, and independent review. Update README only with verified behavior and deliver.

## Execution boundary

This planning checkpoint ends after repository bootstrap, schema, tickets, and plan are reviewed and synchronized. Product code begins in Ticket 01 during a later implementation phase. Ticket 00 must be completed in SoftwareFactory before using that workflow on this repository.
