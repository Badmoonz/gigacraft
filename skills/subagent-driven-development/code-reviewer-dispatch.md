# Code Reviewer Dispatch Template

Use this template when dispatching the `code-reviewer` subagent for review of exactly one completed implementation task from an approved plan.

This file is a prompt template, not the artifact to review.
Before dispatching, copy the template text into the subagent request and replace every placeholder with concrete values.
Never send this template's own path or unresolved placeholders to the subagent.

## Template

```text
Review one completed implementation task against the approved plan.

Implementation task id: T-PLACEHOLDER
Milestone: M-PLACEHOLDER
Files to review:
- /absolute/path/to/file-one
- /absolute/path/to/file-two
Approved task outcome:
- <one concrete expected outcome>
Validation already run:
- <exact command or focused validation step>
Repository-navigation helper readiness:
- <Serena ready | code-index ready | fallback to rg>
Status companion path:
- /absolute/path/to/status.md
Review focus:
- correctness against the approved task
- missing tests or weak validation
- scope drift and risky deviations

Return this format:
- Summary verdict
- Blocker findings
- Major findings
- Minor findings
- Missing tests or validation
- Merge readiness notes
```

Checklist before send:

- Replace placeholders with the actual task id, milestone, files, expected outcome, validation, helper readiness, and status path.
- Keep the review scoped to one completed task.
- Do not send the template path itself to the subagent.
