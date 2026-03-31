---
name: executing-plans
description: Use when there is an approved implementation plan or plan pack and execution should stay inline in the current session rather than being delegated task by task.
---

# Executing Plans

## Goal

Execute an approved implementation plan or plan pack inline while preserving narrow scope and incremental validation.

## Process

1. Start only after the written implementation plan or plan pack has been explicitly approved by the user.
2. Read the approved implementation plan first.
3. Derive companion paths from the approved plan path before doing implementation work.
4. If `<plan base>-status.md` exists, read it before choosing the next task and treat it as the source of truth for resume state.
5. If `<plan base>-test-plan.md` exists, read it before choosing validation commands.
6. Before choosing repository-navigation commands, check whether `Serena` or `code-index` is ready in the current environment.
7. If the approved plan or status companion names a current task, resume there. Otherwise start from the first unfinished task in the main plan.
8. Work through the plan in order and keep each implementation batch small and reviewable.
9. Validate after meaningful changes, using the test plan when present.
10. When a milestone or phase is complete and its validation gate passes, create one non-interactive git commit before starting the next milestone.
11. After each completed task or validation attempt, update the status companion immediately before moving on.
12. Hand off to review before declaring completion.

## Rules

- Do not broaden scope beyond the approved plan.
- Reuse existing repository patterns aggressively.
- Treat missing validation as incomplete work.
- Use this skill only when inline execution is preferable to `subagent-driven-development`.
- When a status companion exists, treat it as an active control document rather than a passive note.
- Keep the status companion headings stable. Update `## Current Phase`, `## Milestone Status`, `## Current Task`, `## Next Task`, `## Last Completed Command and Validation`, and `## Blockers`, then append a new entry under `## Execution Log`.
- Record the completed task id, next task id, last command run, last validation result, and any blocker in append-only form under `## Execution Log`. Do not rewrite or collapse earlier log entries.
- If the main plan references a status companion but the file is missing, create `<plan base>-status.md` with the canonical headings from `writing-plans` before starting implementation.
- If a repository-navigation helper is ready, record that decision and use it first for symbol lookup and file discovery before broad text-search fallback.
- If neither `Serena` nor `code-index` is ready, record the fallback decision and use repository-local tools such as `rg`.
- When a milestone or phase is complete and its validation gate passes, create one non-interactive git commit before starting the next milestone.
- If the worktree contains unrelated changes, missing validation, or no meaningful diff for the completed milestone, stop and surface that instead of forcing a commit.
- Stage only the files that belong to the completed milestone and use a commit message tied to the milestone id or title.
- Do not create empty commits.
- If a milestone commit is created, record the commit sha and message in `## Execution Log`.
