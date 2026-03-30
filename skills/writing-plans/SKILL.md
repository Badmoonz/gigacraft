---
name: writing-plans
description: Use when there is an approved design and the next job is to produce a compact, execution-ready implementation plan before touching code.
---

# Writing Plans

## Goal

Turn an approved design into a compact, execution-ready implementation plan that another agent can follow with minimal reinterpretation.

The plan is not a second spec. It should capture the execution delta: touched files, order, validation, assumptions, compatibility notes, and handoff.

## Planning Workflow

1. Read the approved design first.
2. Run a scope check. If the design still covers multiple independent subsystems, split it into separate plans before continuing.
3. Inspect only the files, prompts, docs, and configs that are likely to change.
4. Map touched files and artifacts before writing tasks. Note what each one is responsible for and keep the decomposition aligned with existing repository boundaries.
5. Identify contradictions, ambiguous terms, and unresolved assumptions in the design before writing tasks. Normalize names and terms instead of propagating inconsistency into the plan.
6. Break the work into small, verifiable tasks in strict execution order. Prefer tasks that are independently reviewable; avoid 2-5 minute micro-step churn.
7. Prefer delta-from-spec planning: do not restate architecture, requirements, or examples already covered well in the design.
8. Save the plan to `docs/gigacraft/plans/YYYY-MM-DD-<topic>.md` unless local context calls for a neighboring file.
9. Run the self-review checklist from `Self-Review`.
10. Ask the user to review the written plan before any implementation starts.
11. Only after explicit user approval, offer the next execution choice:
   - `subagent-driven-development`
   - `executing-plans`

## Default Output Shape

Use this shape unless the task clearly needs less:

1. Summary
2. Reference to approved spec or design plan
3. Spec gaps and normalizations
4. Scope and non-goals
5. Touched files and responsibilities
6. Ordered tasks
7. Acceptance checks
8. Known pitfalls and unknowns

Optional sections:

- Migration and compatibility notes, only if existing users, data, configs, or external contracts are affected
- Rollback notes, only if the task changes persistent behavior or deployment state

## Rules

- Do not write production code.
- Do not include full file skeletons or long code blocks.
- Use short command snippets only for validation or naming an exact setup step.
- Prefer minimal-diff plans over idealized redesigns.
- Inspect only the repo context needed to make file-accurate steps.
- Exact file or artifact paths always.
- Use `docs/gigacraft/plans/` as the default plan location. Do not improvise alternate default paths such as `docs/plans/`.
- Every task must be actionable without reinterpretation.
- Each task should name the exact file or artifact, the intended outcome, any prerequisite dependency, and a direct verification method.
- Surface assumptions, term normalization, and remaining unknowns explicitly.
- Omit irrelevant sections instead of filling them with boilerplate.
- If the project is small or greenfield, keep the plan short and linear.
- Use the `planner` subagent when a focused planning pass is useful.
- If the user explicitly asks for `/write-plan`, honor that as a manual fallback.
- Do not invoke implementation skills or start coding until the user has reviewed and approved the written implementation plan.

## Smells To Avoid

- Repeating the entire spec structure instead of planning the execution delta
- Turning plan steps into pseudocode or implementation prose
- Adding low-value sections because the template asks for them
- Inventing details instead of surfacing uncertainty
- Mixing multiple status names, enum values, or terms from the spec without normalizing them
- Vague tasks such as `add validation`, `handle edge cases`, or `write tests` without saying what is being verified
- Bundling multiple independently verifiable changes into one step

## Self-Review

After writing the plan, review it once yourself before handing it off:

1. Spec coverage: can you point from each major requirement or constraint in the design to a task or acceptance check?
2. Placeholder and vagueness scan: remove `TODO`, `TBD`, implied decisions, and vague verbs that hide real work.
3. Naming consistency: make sure types, flags, enums, endpoints, and file names are consistent across the whole plan.
4. Execution sanity: confirm the ordering, dependencies, and verification steps are enough for another agent to execute safely.
5. Compactness check: cut repeated spec material, duplicated validation sections, and any boilerplate that does not change execution clarity.

## Execution Handoff

After saving the plan and finishing self-review, ask the user to review it before implementation:

> "Implementation plan written to `<path>`. Please review it and tell me if you want any changes before we start executing it."

Wait for the user's response. If they request changes, update the plan and re-run self-review. Only after explicit approval should you offer the next execution choice:

- `subagent-driven-development` for task-by-task delegated execution with review checkpoints
- `executing-plans` for inline execution in the current session with bounded batches
