# Ticket 00 — Enable SoftwareFactory for MeowDoku

## Objective

Allow the existing SoftwareFactory workflow to create and resume a job whose target is `https://github.com/Tmejs/MeowDoku`, while preserving its frozen packet, ownership, review, and delivery gates.

## Target repository

`https://github.com/Tmejs/SoftwareFactory`

## Scope

Generalize the factory's repository target validation and worktree selection. For a MeowDoku job, store job records under `factory/jobs/<id>/` in the MeowDoku checkpoint worktree. The SoftwareFactory workflow code remains sourced from its pinned `workflow_commit`; the target repository owns the job branch, `main`, `origin`, checks, and completion tag. Keep v1 jobs targeting SoftwareFactory valid. No MeowDoku product code is in scope.

## Context

SoftwareFactory v1's `factory/job-format.md` requires its own repository URL as target, and `.agents/skills/software-factory/SKILL.md` runs repo-local jobs. Those constraints prevent direct use with MeowDoku today. See `docs/app-schema.md` in MeowDoku for the intended handoff.

## Acceptance criteria

- A frozen task packet can name MeowDoku as target and records its exact synchronized `main` baseline SHA.
- Intake and resume operate in a MeowDoku checkpoint worktree without treating SoftwareFactory's own `main` as the product baseline.
- Existing SoftwareFactory-target jobs remain valid and resumable.
- Job validation rejects inconsistent target, branch, baseline, or artifact paths.
- A dry run of one disposable MeowDoku-target packet reaches a validated intake/spec state without changing product code.
- The target repository is explicit for fetch, checkpoint branch push, `--no-ff` merge, full gate, `main` push, and `factory/<job-id>` tag creation/verification. A dry-run test confirms none of these operations select SoftwareFactory refs for a MeowDoku job.
- The user-facing skill documents how to invoke a MeowDoku ticket, find the skill from that repository, and locate its records.

## Checks

- `python3 -m unittest discover -s tests -v`
- `python3 tools/validate_job.py <disposable-job-directory>`
- `git diff --check`

## Dependencies

None. This is a separate repository checkpoint. It is not authorized by merely reading this ticket; start it through a deliberate SoftwareFactory job or direct task in that repository.
