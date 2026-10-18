# MeowDoku repository instructions

Read [the MVP design](docs/superpowers/specs/2026-10-17-meowdoku-mvp-design.md), [app schema](docs/app-schema.md), and [ticket index](codex/tickets/README.md) before implementation. The repository currently contains planning records; implementation begins with Ticket 01 on its own checkpoint branch.

Treat `main` as stable. Before each checkpoint, require a clean `main`, fetch and inspect `origin`, and confirm local `main` equals `origin/main`. Create a fresh `codex/checkpoint-<number>-<short-name>` branch from synchronized `main`. Use an isolated worktree when parallel work or subagents are involved. Preserve completed branches and never force-push, reset shared history, delete branches, or merge over unexpected changes without user approval.

Keep commits small. Run the checks declared by the active ticket, the complete applicable local gate, and `git diff --check`. Obtain independent review before push; fix and re-review all Critical or Important findings. Record evidence under `codex/checkpoints/`. Push and verify the checkpoint branch SHA, merge with `--no-ff`, rerun the gate, push `main`, and verify local, tracking, and remote main SHAs match.

The first implementation ticket creates the Flutter verification script. Until then, documentation checks are JSON parsing, link/path review, and `git diff --check`.
