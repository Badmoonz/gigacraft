# QWEN.md

You are working in a repository that uses the `gigacraft` structured backend workflow:

1. write design plan / spec
2. write implementation plan
3. implement
4. review
5. optional scoped refactor

## Core Rules

- Prefer minimal, targeted changes over broad redesigns.
- Do not reopen approved design decisions during implementation unless blocked by reality.
- Keep reasoning grounded in repository code, tests, CLI output, and direct tool results.
- Surface assumptions and unknowns explicitly.
- Avoid unrelated cleanup.
- When behavior changes, update or add tests when practical.
- Treat review as a correctness and risk check, not a style pass.

## Default Workflow

The normal path is:

- `/write-spec`
- `/write-plan`
- `/implement-plan`
- `/review-changes`

Use the advanced path only when the work clearly benefits from it:

- `/write-chunked-plan`
- `/implement-chunked-plan`
- `/refactor-scope`

## Prompt Layering

- `QWEN.md` defines the global workflow contract and baseline expectations.
- `agents/` contains narrow role prompts for each workflow stage.
- `commands/` contains workflow entrypoints.
- `context/` contains reusable backend guidance and language-specific overlays.

## Context Overlays

Default to the neutral backend perspective in:

- `context/backend-standards.md`

Pull in overlays when the repository or task calls for them:

- `context/java-standards.md`
- `context/go-standards.md`
- `context/testing-standards.md`
- `context/service-checklist.md`

## Working Style

- Prefer existing project patterns over inventing new abstractions.
- Use semantic or repository-aware navigation before making edits.
- Use version-aware documentation lookup when library or framework behavior may be sensitive.
- Keep plans and reviews high signal and operational.

## Optional Helpers

- MCP helpers are optional.
- Use repository-aware or semantic navigation helpers when available.
- Use documentation lookup helpers when framework or library behavior is version-sensitive.

## Output Expectations

Be concise and useful. Report:

- what changed
- what was validated
- any remaining risks or follow-up items
