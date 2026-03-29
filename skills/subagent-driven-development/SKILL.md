---
name: subagent-driven-development
description: Use when executing an approved implementation plan in the current session through explicit, stage-aware subagent delegation.
---

# Subagent-Driven Development

## Goal

Execute an approved implementation plan task by task using focused subagents and explicit review checkpoints.

## Process

1. Read the approved implementation plan.
2. Execute one task at a time.
3. Delegate task implementation to the `implementer` subagent.
4. Route completed work to the `reviewer` subagent before marking the task done.
5. Continue until the full plan is complete.

## Rules

- Do not start without an approved plan.
- Do not batch unrelated tasks together.
- Keep subagent scope narrow and bounded to the current task.
- Re-run targeted validation after meaningful changes.
- Escalate when the plan is blocked by reality instead of silently redesigning it.
