---
name: subagent-driven-development
description: Use when executing an approved implementation plan or plan pack in the current session through explicit, stage-aware subagent delegation.
---

# Subagent-Driven Development

## Goal

Execute an approved implementation plan or plan pack task by task using focused subagents and explicit review checkpoints.

## Process

1. Start only after the written implementation plan or plan pack has been explicitly approved by the user.
2. Read the approved implementation plan first.
3. Derive companion paths from the approved plan path before dispatching any subagent.
4. If `<plan base>-status.md` exists, read it before choosing the next task and treat it as the source of truth for resume state.
5. If `<plan base>-test-plan.md` exists, read it before choosing validation commands.
6. Start from the current unfinished milestone or task. If a status companion exists, treat it as the current execution state.
7. Execute one task at a time.
8. Delegate task implementation to the `implementer` subagent.
9. Route completed work to the `code-reviewer` subagent before marking the task done.
10. When a milestone or phase is complete, reviewed, and validated, create one non-interactive git commit before dispatching work for the next milestone.
11. After each completed task, review pass, or validation attempt, update the status companion immediately before dispatching the next task.
12. Continue until the full plan is complete.

## Rules

- Do not batch unrelated tasks together.
- Keep subagent scope narrow and bounded to the current task.
- Re-run targeted validation after meaningful changes.
- Use the test-plan companion when present to choose milestone and behavior checks, not just compile checks.
- Escalate when the plan is blocked by reality instead of silently redesigning it.
- When a status companion exists, treat it as an active control document rather than a passive note.
- Keep the status companion headings stable. Update `## Current Phase`, `## Milestone Status`, `## Current Task`, `## Next Task`, `## Last Completed Command and Validation`, and `## Blockers`, then append a new entry under `## Execution Log`.
- Record the completed task id, next task id, last command run, last validation result, and any blocker in append-only form under `## Execution Log`. Do not rewrite or collapse earlier log entries.
- If the main plan references a status companion but the file is missing, create `<plan base>-status.md` with the canonical headings from `writing-plans` before dispatching the first implementation task.
- When a milestone or phase is complete, reviewed, and validated, create one non-interactive git commit before dispatching work for the next milestone.
- If the worktree contains unrelated changes, missing validation, or no meaningful diff for the completed milestone, stop and surface that instead of forcing a commit.
- Stage only the files that belong to the completed milestone and use a commit message tied to the milestone id or title.
- Do not create empty commits.
- If a milestone commit is created, record the commit sha and message in `## Execution Log`.
