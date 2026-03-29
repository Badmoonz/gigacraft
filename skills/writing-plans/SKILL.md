---
name: writing-plans
description: Use when there is an approved design and the next job is to produce a concrete implementation plan before touching code.
---

# Writing Plans

## Goal

Turn an approved design into a concrete implementation plan with exact files, validation, and execution order.

## Process

1. Read the approved design first.
2. Inspect only the files, prompts, docs, and configs that will change.
3. Break the work into small, verifiable tasks.
4. Keep the plan aligned with current repository patterns.
5. Save the plan to `docs/superpowers/plans/YYYY-MM-DD-<topic>.md`.
6. Offer the next execution choice:
   - `subagent-driven-development`
   - `executing-plans`

## Rules

- Do not write production code.
- Prefer minimal-diff plans over idealized redesigns.
- Every task must be actionable without reinterpretation.
- Surface assumptions and remaining unknowns explicitly.
- Use the `planner` subagent when a focused planning pass is useful.
- If the user explicitly asks for `/write-plan`, honor that as a manual fallback.
