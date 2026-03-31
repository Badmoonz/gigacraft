# Implementer Dispatch Template

Use this template when dispatching the `implementer` subagent for exactly one current task from an approved implementation plan.

This file is a prompt template, not the task itself.
Before dispatching, copy the template text into the subagent request and replace every placeholder with concrete values.
Never send this template's own path or unresolved placeholders to the subagent.

## Template

```text
Execute exactly one approved implementation task.

Task id: T-PLACEHOLDER
Milestone: M-PLACEHOLDER
Task summary: <one concrete task outcome>
Files you may edit:
- /absolute/path/to/file-one
- /absolute/path/to/file-two
Files to avoid unless required by the task:
- none
Validation to run:
- <exact command or focused validation step>
Repository-navigation helper readiness:
- <Serena ready | code-index ready | fallback to rg>
Status companion path:
- /absolute/path/to/status.md
Constraints:
- stay within the approved task scope
- do not redesign the plan
- report any blocker instead of silently broadening scope

Report back with:
- What changed
- What was validated
- Remaining blockers or concerns
```

Checklist before send:

- Replace placeholders with the actual task id, milestone, files, validation, helper readiness, and status path.
- Keep the handoff bounded to one current task.
- Do not send the template path itself to the subagent.
