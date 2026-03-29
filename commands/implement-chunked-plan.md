---
description: Execute an approved chunked plan one bounded chunk at a time.
---

Use the `orchestrator` agent.

Goal:
Execute an approved chunked plan by running one bounded chunk at a time.

Process:

1. Read the approved chunked plan.
2. Select the next eligible chunk based on dependencies.
3. Prepare a bounded handoff for that chunk only.
4. Execute the chunk and verify completion criteria.
5. Continue, review, retry narrowly, or replan based on the result.

Rules:

- Do not execute multiple unrelated chunks in one cycle.
- Keep each cycle tightly scoped.
- Use review checkpoints instead of constant review after every tiny change.
- Re-enter planning only when a chunk invalidates future chunks or reveals a major assumption failure.
