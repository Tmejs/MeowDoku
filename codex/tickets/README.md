# MeowDoku implementation tickets

These Markdown tickets are the approved MVP's implementation backlog. They are **not** active SoftwareFactory jobs. At intake, SoftwareFactory must freeze a ticket into its `task.md`, record the then-current synchronized `main` SHA, and choose the run mode. Do not put a guessed baseline SHA into a ticket.

| Order | Ticket | Target repository | Deliverable |
| ---: | --- | --- | --- |
| 0 | [Factory target support](00-factory-target-support.md) | SoftwareFactory | Workflow can run a job against MeowDoku |
| 1 | [Flutter foundation](01-flutter-foundation.md) | MeowDoku | Runnable app shell and verification gate |
| 2 | [Puzzle core and pack](02-puzzle-core-and-pack.md) | MeowDoku | Pure solver, generator, verified 100-board asset |
| 3 | [Session and persistence](03-session-and-persistence.md) | MeowDoku | Edits, undo, completion, durable progress |
| 4 | [Playable screens](04-playable-screens.md) | MeowDoku | Difficulty choice and puzzle play flow |
| 5 | [Hints and accessibility](05-hints-and-accessibility.md) | MeowDoku | Explained hints and accessible controls |
| 6 | [Original visual polish](06-original-visual-polish.md) | MeowDoku | Original cat identity and final mobile QA |

Tickets 1–6 are sequential checkpoints so each starts from synchronized `main`. Ticket 0 changes the separate SoftwareFactory repository and must complete before using that workflow for tickets 1–6. If ticket 0 is delayed, the app tickets remain executable manually under this repository's Git and review rules, but must not be mislabeled as SoftwareFactory runs.

The [implementation plan](../../docs/superpowers/plans/2026-10-17-meowdoku-mvp.md) maps the tickets to tests and files. The [design](../../docs/superpowers/specs/2026-10-17-meowdoku-mvp-design.md) and [schema](../../docs/app-schema.md) are the product contract. A later change to MVP scope updates these documents and the affected unstarted tickets before factory intake.
