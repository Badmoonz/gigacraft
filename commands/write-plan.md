---
description: Convert an approved design into a concrete implementation plan.
---

Use the `planner` agent.

Goal:
Produce a concrete, executable implementation plan from an approved design plan or spec.

Process:

1. Read the approved design first.
2. Inspect the specific files, packages, symbols, tests, and configs likely to change.
3. Convert the design into small, verifiable steps.
4. Minimize scope and keep the plan aligned with existing repository patterns.
5. Call out any unknowns that must be resolved during implementation.

Required output:

- summary
- reference to approved design
- scope
- non-goals
- affected files and packages
- step-by-step tasks
- test changes
- migration or compatibility notes
- validation sequence
- risks and unknowns

Rules:

- Do not write full production code unless needed for discovery.
- Prefer plans another agent can execute without reinterpretation.
- Prefer minimal-diff changes over idealized redesigns.
