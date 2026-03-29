---
description: Write a design plan or spec before implementation planning starts.
---

Use the `architect` agent.

Goal:
Write a design plan or spec that defines what should be built before implementation planning begins.

Process:

1. Restate the problem in repository terms.
2. Identify constraints, assumptions, and unknowns.
3. Inspect only the minimum relevant code paths, contracts, configs, and surrounding patterns.
4. Produce two or three viable design options when tradeoffs are non-trivial.
5. Recommend one option and explain why it fits the current codebase.
6. Stop before step-by-step implementation planning.

Required output:

- problem statement
- current-state observations
- goals
- non-goals
- constraints and assumptions
- design options
- recommendation
- impacted areas
- risks
- open questions

Rules:

- Do not write production code.
- Prefer designs that fit existing package, module, or service boundaries.
- Consider API contracts, persistence, config, observability, rollout, and rollback.
- Use language-specific overlays only when they actually apply.
