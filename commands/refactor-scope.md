---
description: Perform an approved structural refactor or migration without mixing in feature work.
---

Use the `refactor` agent.

Goal:
Perform an approved structural refactor or migration with tight scope control.

Process:

1. Read the approved refactor scope first.
2. Keep the transformation mechanical where possible.
3. Preserve behavior unless the task explicitly changes behavior.
4. Validate build, test, and lint impact after the change.

Rules:

- Do not mix feature work with refactoring.
- Prefer repeatable transformations.
- Call out any remaining manual follow-up clearly.
