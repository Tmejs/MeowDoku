# Ticket 01 — Flutter foundation

## Objective

Create an Android/iOS Flutter application shell for the approved offline game and a repeatable local verification gate.

## Target repository

`https://github.com/Tmejs/MeowDoku`

## Scope

Create `mobile/` with Flutter's generated platform projects, an app root, empty Home/Difficulty/Puzzle/Settings routes, centralized UI strings, a theme placeholder, and `mobile/tool/verify.sh`. Use Dart with Riverpod and Drift as selected in the design, but do not implement gameplay or persistence behavior in this ticket. Update root README with only verified run commands. Do not add network, ads, or accounts.

## Acceptance criteria

- Flutter creates Android and iOS project targets; widget tests launch the app root at a Home placeholder. Device/simulator launch is verified in Ticket 06.
- Routing can open Difficulty, Puzzle, and Settings placeholders without crashes.
- UI strings are centralized for future localization.
- `mobile/tool/verify.sh` runs formatting, `flutter analyze`, and `flutter test` and exits nonzero on any failure.
- A smoke widget test verifies the app root and route navigation.

## Checks

- `cd mobile && ./tool/verify.sh`
- `git diff --check`

## Dependencies

None. Start from synchronized `main` on a fresh checkpoint branch.
