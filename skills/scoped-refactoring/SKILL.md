---
name: scoped-refactoring
description: Use when performing an approved structural refactor or migration that should remain tightly scoped and behavior-preserving by default.
---

# Scoped Refactoring

## Goal

Perform an approved structural refactor or migration with tight scope control and explicit validation.

## Process

1. Read the approved refactor scope first.
2. Keep the transformation mechanical and repeatable where possible.
3. Preserve behavior unless the task explicitly changes behavior.
4. Validate build, test, and lint impact after the transformation.
5. Call out any manual follow-up that remains.

## Rules

- Do not mix feature work with refactoring.
- Prefer small, reviewable transformations over broad cleanup.
- Stay within the approved scope unless the user explicitly reopens it.
- Use the `refactor` agent when a focused transformation pass is useful.
- If the user explicitly asks for `/refactor-scope`, honor that as a manual fallback.
