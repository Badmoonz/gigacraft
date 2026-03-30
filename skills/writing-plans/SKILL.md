---
name: writing-plans
description: Use when there is an approved design and the next job is to produce a compact, resumable, execution-ready implementation plan pack before touching code.
---

# Writing Plans

## Goal

Turn an approved design into a compact, execution-ready implementation plan pack that another agent can follow and resume with minimal reinterpretation.

The plan is not a second spec. It should capture the execution delta plus control scaffolding: touched files, milestones, order, validation, rollback boundaries, and handoff.

For non-trivial or autonomous execution, the plan pack should usually include companion files beside the main plan:

- `docs/gigacraft/plans/YYYY-MM-DD-<topic>-status.md`
- `docs/gigacraft/plans/YYYY-MM-DD-<topic>-test-plan.md`

## Planning Workflow

1. Read the approved design first.
2. Run a scope check. If the design still covers multiple independent subsystems, split it into separate plans before continuing.
3. Inspect only the files, prompts, docs, and configs that are likely to change.
4. Map touched files and artifacts before writing tasks. Note what each one is responsible for and keep the decomposition aligned with existing repository boundaries.
5. Identify contradictions, ambiguous terms, and unresolved assumptions in the design before writing tasks. Only normalize naming or clerical inconsistencies. If a change would affect API, business rules, auth behavior, or other product-visible behavior, surface it as a spec gap or open question instead of silently deciding it.
6. Choose the artifact set. For any plan that spans multiple milestones, touches API/auth/persistence/background work, or is intended for autonomous execution, write a plan pack:
   - main plan: `docs/gigacraft/plans/YYYY-MM-DD-<topic>.md`
   - status companion: `docs/gigacraft/plans/YYYY-MM-DD-<topic>-status.md`
   - test plan companion: `docs/gigacraft/plans/YYYY-MM-DD-<topic>-test-plan.md`
7. Break the work into atomic, resumable tasks in strict execution order. Prefer one independently verifiable behavior unit per task: one endpoint, one middleware, one storage method, one migration, one config surface, or one integration check.
8. Group tasks into milestones. For each milestone define a goal, definition of done, validation gate, rollback boundary, and stop/replan rule.
9. Separate behavioral validation from compile/lint/build checks. For externally visible behavior, include happy-path and key negative-case checks instead of treating build success as proof.
10. Prefer delta-from-spec planning: do not restate architecture, requirements, or examples already covered well in the design.
11. Save the plan to `docs/gigacraft/plans/YYYY-MM-DD-<topic>.md` unless local context calls for a neighboring file. Save companion files beside it when the plan is non-trivial.
12. Run the self-review checklist from `Self-Review`.
13. Ask the user to review the written plan pack before any implementation starts.
14. Only after explicit user approval, offer the next execution choice:
   - `subagent-driven-development`
   - `executing-plans`

## Default Output Shape

Use this shape unless the task clearly needs less.

Main plan:

1. Summary
2. Reference to approved spec or design plan
3. Spec gaps and allowed normalizations
4. Scope and non-goals
5. Touched files and responsibilities
6. Milestones with definitions of done
7. Ordered atomic tasks
8. Validation strategy and milestone gates
9. Rollback boundaries and compatibility notes
10. Known pitfalls and unknowns

Status companion for non-trivial plans:

- Current phase
- Milestone status table
- Current task
- Next task
- Stop/replan triggers
- Decisions and assumptions
- Last completed validation
- Blockers

Test plan companion for non-trivial plans:

- Validation assumptions and exact commands
- Step-level checks
- Milestone gates
- End-to-end happy-path checks
- Key negative cases
- Manual or environment-dependent checks

Optional sections:

- Migration notes, only if existing users, data, configs, or external contracts are affected
- Rollback notes, only if the task changes persistent behavior or deployment state

## Rules

- Do not write production code.
- Do not include full file skeletons or long code blocks.
- Use short command snippets only for validation or naming an exact setup step.
- Prefer minimal-diff plans over idealized redesigns.
- Inspect only the repo context needed to make file-accurate steps.
- Exact file or artifact paths always.
- Use `docs/gigacraft/plans/` as the default plan location. Do not improvise alternate default paths such as `docs/plans/`.
- Use the same base name for companion files when they exist: `...-status.md` and `...-test-plan.md`.
- Every task must be actionable without reinterpretation.
- Each task should name the exact file or artifact, the intended outcome, any prerequisite dependency, and a direct verification method.
- Each milestone must state its definition of done, validation gate, rollback boundary, and stop/replan rule.
- Do not silently change product behavior under the label of `normalization`.
- If the design and repository evidence disagree on file placement, ownership, or architecture boundaries, call out the conflict explicitly instead of picking one silently.
- Compile, lint, and build checks are partial signals, not behavioral proof.
- For API, auth, persistence, contract, or user-visible behavior, include behavioral validation beyond compile or build success.
- Tests are not a postscript. If behavior changes depend on tests for confidence, plan those tests alongside the relevant implementation tasks even if final end-to-end checks happen later.
- Surface assumptions, term normalization, and remaining unknowns explicitly.
- Omit irrelevant sections instead of filling them with boilerplate.
- If the project is small or greenfield, keep the plan short and linear, but not underspecified.
- Use the `planner` subagent when a focused planning pass is useful.
- If the user explicitly asks for `/write-plan`, honor that as a manual fallback.
- Do not invoke implementation skills or start coding until the user has reviewed and approved the written implementation plan pack.

## Smells To Avoid

- Repeating the entire spec structure instead of planning the execution delta
- Turning plan steps into pseudocode or implementation prose
- Adding low-value sections because the template asks for them
- Inventing details instead of surfacing uncertainty
- Mixing multiple status names, enum values, or terms from the spec without normalizing them
- Vague tasks such as `add validation`, `handle edge cases`, or `write tests` without saying what is being verified
- Bundling multiple independently verifiable changes into one step
- Silent product-contract changes hidden inside `normalization`
- Locking in file placement or module boundaries without reconciling them with the approved design and repo evidence
- Compile-only validation for auth, API, persistence, migrations, or ownership-sensitive behavior
- Saying tests happen `later` while earlier tasks already rely on those tests for real confidence
- Multi-step plans with no current phase, milestone status, or resume protocol

## Self-Review

After writing the plan, review it once yourself before handing it off:

1. Spec coverage: can you point from each major requirement or constraint in the design to a task, milestone gate, or test-plan check?
2. Contract discipline: make sure `normalization` did not silently change business behavior, API semantics, or validation rules from the approved design.
3. Placeholder and vagueness scan: remove `TODO`, `TBD`, implied decisions, and vague verbs that hide real work.
4. Naming consistency: make sure types, flags, enums, endpoints, and file names are consistent across the whole plan pack.
5. Atomicity and resumability: confirm a fresh agent can identify the current milestone, next task, stop rule, and direct verification path without rereading chat history.
6. Test realism: confirm that externally visible behavior has behavioral checks, not just compile or build checks.
7. Rollback sanity: confirm rollback notes are tied to milestone boundaries or state changes, not a hand-wavy global reset.
8. Compactness check: cut repeated spec material, duplicated validation sections, and any boilerplate that does not change execution clarity.

## Execution Handoff

After saving the plan pack and finishing self-review, ask the user to review it before implementation:

> "Implementation plan written to `<plan path>`."
> "If used, companion files are at `<status path>` and `<test plan path>`."
> "Please review them and tell me if you want any changes before we start executing."

Wait for the user's response. If they request changes, update the plan and re-run self-review. Only after explicit approval should you offer the next execution choice:

- `subagent-driven-development` for task-by-task delegated execution with review checkpoints
- `executing-plans` for inline execution in the current session with bounded batches
