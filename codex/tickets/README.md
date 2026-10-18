# MeowDoku implementation tickets

These Markdown tickets are the approved MVP's implementation backlog. Execute each ticket as a focused checkpoint from synchronized `main`, following [AGENTS.md](../../AGENTS.md). They are planning records, not active branches.

| Order | Ticket | Status | Deliverable |
| ---: | --- | --- | --- |
| 1 | [Flutter foundation](01-flutter-foundation.md) | Complete, checkpoint 2 | Runnable app shell and verification gate |
| 2 | [Puzzle core and pack](02-puzzle-core-and-pack.md) | Complete, checkpoint 3 | Pure solver, generator, verified 100-board asset |
| 3 | [Session and persistence](03-session-and-persistence.md) | Complete, checkpoint 4 | Edits, undo, completion, durable progress |
| 4 | [Playable screens](04-playable-screens.md) | Planned | Difficulty choice and puzzle play flow |
| 5 | [Hints and accessibility](05-hints-and-accessibility.md) | Planned | Explained hints and accessible controls |
| 6 | [Original visual polish](06-original-visual-polish.md) | Planned | Original cat identity and final mobile QA |

Tickets 1–6 are sequential checkpoints so each starts from synchronized `main`. No separate workflow project is a prerequisite.

The [implementation plan](../../docs/superpowers/plans/2026-10-17-meowdoku-mvp.md) maps the tickets to tests and files. The [design](../../docs/superpowers/specs/2026-10-17-meowdoku-mvp-design.md) and [schema](../../docs/app-schema.md) are the product contract. A later change to MVP scope updates these documents and the affected unstarted tickets before work begins on them.
