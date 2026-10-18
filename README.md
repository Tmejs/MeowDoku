# MeowDoku

MeowDoku is an offline mobile logic puzzle project for Android and iOS. The Flutter foundation has Home, Difficulty, Puzzle, and Settings placeholders. A bundled 100-board puzzle pack, pure Dart rules, solution counting, validation, and deduction traces are implemented. The screens do not yet play the game; sessions and saved progress are scheduled for later tickets.

The [MVP design](docs/superpowers/specs/2026-10-17-meowdoku-mvp-design.md), [app schema](docs/app-schema.md), and [ticket index](codex/tickets/README.md) define the planned game and implementation order.

To run the verified local mobile gate, resolve Flutter packages once with `cd mobile && flutter pub get`, then run `./tool/verify.sh` from `mobile/`. The gate checks Dart formatting, Flutter analysis and tests, Python pack tests, and the 100-board audit. If Flutter is not on `PATH`, set `FLUTTER_BIN` to the installed `flutter` executable before running the script.
