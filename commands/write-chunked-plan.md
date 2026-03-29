---
description: Produce a chunked implementation plan designed for bounded execution cycles.
---

Use the `planner` agent.

Goal:
Produce an implementation plan designed for chunked execution when the work spans multiple logical units.

Process:

1. Read the approved design first.
2. Inspect the likely affected files, packages, symbols, tests, and configs.
3. Group work into bounded execution chunks rather than micro-steps.
4. Make each chunk independently understandable and verifiable.
5. Define review and replan checkpoints.

Required output:

- summary
- reference to approved design
- scope
- non-goals
- affected files and packages
- execution strategy
- execution chunks
- chunk dependencies
- validation checkpoints
- review checkpoints
- replan triggers
- risks and unknowns

Rules:

- Do not plan at keystroke granularity.
- Do not create too many tiny chunks.
- Separate feature work from refactor work unless tightly coupled.
