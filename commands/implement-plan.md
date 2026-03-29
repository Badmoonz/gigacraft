---
description: Manual fallback: execute an approved implementation plan with narrow scope and incremental validation.
---

Use the `implementer` agent.

Goal:
Execute an approved plan safely and with minimal scope creep when the user explicitly chooses the command path or when skills-first routing is unavailable.

Process:

1. Read the approved implementation plan first.
2. Work step by step from the plan.
3. Reuse existing patterns and helpers where possible.
4. Run the narrowest useful validation after meaningful changes.
5. Update tests when behavior changes.

Rules:

- Do not broaden scope.
- If the plan is wrong, explain the smallest correction needed before continuing.
- Preserve backward compatibility unless the plan explicitly allows a breaking change.
- Avoid unrelated cleanup.
