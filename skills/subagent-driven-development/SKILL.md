---
name: subagent-driven-development
description: Use when executing an approved implementation plan or plan pack in the current session through explicit, stage-aware subagent delegation.
---

# Subagent-Driven Development

## Goal

Execute an approved implementation plan or plan pack task by task using focused subagents and explicit review checkpoints.

## Process

1. Read the approved implementation plan. If companion `-status.md` or `-test-plan.md` files exist, read them too.
2. Start from the current unfinished milestone or task. If a status companion exists, treat it as the current execution state.
3. Execute one task at a time.
4. Delegate task implementation to the `implementer` subagent.
5. Route completed work to the `code-reviewer` subagent before marking the task done.
6. Update the status companion when present so a fresh run can resume cleanly.
7. Continue until the full plan is complete.

## Rules

- Do not start without a written implementation plan or plan pack that the user has explicitly approved.
- Do not batch unrelated tasks together.
- Keep subagent scope narrow and bounded to the current task.
- Re-run targeted validation after meaningful changes.
- Use the test-plan companion when present to choose milestone and behavior checks, not just compile checks.
- Escalate when the plan is blocked by reality instead of silently redesigning it.
