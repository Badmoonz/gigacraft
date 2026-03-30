---
name: executing-plans
description: Use when there is an approved implementation plan or plan pack and execution should stay inline in the current session rather than being delegated task by task.
---

# Executing Plans

## Goal

Execute an approved implementation plan or plan pack inline while preserving narrow scope and incremental validation.

## Process

1. Read the approved implementation plan. If companion `-status.md` or `-test-plan.md` files exist, read them too.
2. Resume from the current unfinished milestone or task.
3. Work through the plan in order.
4. Keep each implementation batch small and reviewable.
5. Validate after meaningful changes, using the test plan when present.
6. Update the status companion when present. Record the completed task id, next task id, last command run, last validation result, and any blocker in append-only form.
7. Hand off to review before declaring completion.

## Rules

- Do not broaden scope beyond the approved plan.
- Do not start execution until the written implementation plan or plan pack has been explicitly approved by the user.
- Reuse existing repository patterns aggressively.
- Treat missing validation as incomplete work.
- Use this skill only when inline execution is preferable to `subagent-driven-development`.
