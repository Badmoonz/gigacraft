---
name: brainstorming
description: Use before implementation when the user is exploring a feature, change, migration, or design decision that is not already fully specified.
---

# Brainstorming

## Goal

Turn a rough request into an approved design before implementation planning starts.

## Process

1. Inspect the relevant repository context first.
2. Ask clarifying questions one at a time.
3. Present two or three viable design options when trade-offs matter.
4. Recommend one option and explain why it fits the current repository.
5. Present the design in reviewable sections and get user approval.
6. Save the approved design to `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md`.
7. Stop after the design is approved and written; the next workflow stage is `writing-plans`.

## Rules

- Do not write production code.
- Do not skip user approval for the design.
- Distinguish observed facts from assumptions.
- Use the `architect` subagent when a separate focused spec-writing pass will help.
- If the user explicitly asks for `/write-spec`, honor that as a manual fallback.
