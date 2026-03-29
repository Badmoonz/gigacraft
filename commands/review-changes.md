---
description: Critically review current changes against the approved design and implementation plan.
---

Use the `reviewer` agent.

Goal:
Assess whether the current changes correctly implement the approved plan and are safe to merge.

Process:

1. Compare current changes against the approved design and plan.
2. Review code, tests, configs, and operational implications.
3. Focus on correctness, regressions, compatibility, and missing validation.
4. Produce only high-signal findings.

Required output:

- summary verdict
- blocker findings
- major findings
- minor findings
- missing tests or validation
- merge readiness notes

Rules:

- Prefer concrete, actionable findings over style feedback.
- Treat missing tests for changed behavior as a real issue.
- Check whether the change is over-scoped.
