# MeowDoku

MeowDoku is an offline mobile logic puzzle project for Android and iOS. The Flutter foundation currently has Home, Difficulty, Puzzle, and Settings placeholders. Puzzle rules, levels, and saved progress are scheduled for later tickets; this is not yet a playable game.

The [MVP design](docs/superpowers/specs/2026-10-17-meowdoku-mvp-design.md), [app schema](docs/app-schema.md), and [ticket index](codex/tickets/README.md) define the planned game and implementation order.

To run the verified local mobile gate, resolve Flutter packages once with `cd mobile && flutter pub get`, then run `./tool/verify.sh` from `mobile/`. The gate checks Dart formatting, Flutter analysis, and widget tests. If Flutter is not on `PATH`, set `FLUTTER_BIN` to the installed `flutter` executable before running the script.
