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
7. Freeze one architecture and dependency path for execution. Resolve `A or B` choices into a single selected option, or surface them as blocking questions before finalizing the plan.
8. Break the work into atomic, resumable tasks in strict execution order. Prefer one independently verifiable behavior unit per task: one endpoint, one middleware, one storage method, one migration, one config surface, or one integration check.
9. Group tasks into milestones. For each milestone define a goal, definition of done, validation gate, rollback boundary, stop/replan rule, and commit checkpoint.
10. Validate task dependencies before finalizing the plan. No task may depend on an artifact, contract, provider abstraction, or helper that is only created later in the sequence.
11. Cross-check the file inventory. Every file, directory, command entry point, or test artifact referenced anywhere in the plan pack must appear in the touched-files inventory or in an explicit external-prerequisites section.
12. Separate behavioral validation from compile/lint/build checks. For externally visible behavior, include happy-path and key negative-case checks instead of treating build success as proof.
13. If repository-navigation helper readiness is already known during planning, record that advisory note explicitly in the plan pack and tell execution to re-check it on activation.
14. Prefer delta-from-spec planning: do not restate architecture, requirements, or examples already covered well in the design.
15. Save the plan to `docs/gigacraft/plans/YYYY-MM-DD-<topic>.md` unless local context calls for a neighboring file. Save companion files beside it when the plan is non-trivial.
16. Run the self-review checklist from `Self-Review`.
17. Ask the user to review the written plan pack before any implementation starts.
18. After explicit user approval, if the approved plan artifact set still has an uncommitted diff, create one non-interactive git commit that stages only the main plan and any companion plan-pack files before offering execution.
19. If the approved plan artifact set is already committed with no uncommitted diff, say so explicitly before offering execution.
20. Only after explicit user approval and the boundary commit status is clear, offer the next execution choice:
   - `subagent-driven-development`
   - `executing-plans`

## Default Output Shape

Use this shape unless the task clearly needs less.

Main plan:

1. Summary
2. Reference to approved spec or design plan
3. Frozen implementation decisions
4. Spec gaps, open questions, and allowed normalizations
5. Scope and non-goals
6. Touched files and responsibilities
7. Explicit design deviations, if any
8. Milestones with definitions of done and commit checkpoints
9. Ordered atomic tasks
10. Validation strategy and milestone gates
11. Rollback boundaries and compatibility notes
12. Known pitfalls and unknowns

Status companion for non-trivial plans:

Use the exact section headings below for the status companion so execution skills can resume deterministically:

## Current Milestone

## Milestone Status

## Current Task

## Next Task

## Stop/Replan Triggers

## Decisions and Assumptions

## Last Completed Command and Validation

## Blockers

## Execution Log

Each appended execution-log entry should start with an actual local timestamp formatted as `YYYY-MM-DD HH:MM TZ`, for example `2026-04-01 14:37 MSK`.
Generate the timestamp from the current environment, for example with `date '+%Y-%m-%d %H:%M %Z'`, instead of inventing it from memory.
Do not use ISO-8601 UTC forms such as `2026-04-01T00:00:00Z`, do not use placeholder fragments such as `XX`, and do not default to `00:00` unless that is the real local time.

Test plan companion for non-trivial plans:

- Validation assumptions, prerequisites, and exact commands
- Server run command and required env
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
- For `...-status.md`, use the exact heading names from `Default Output Shape`. Do not rename them or replace them with synonyms.
- In `## Execution Log`, append entries only. Each entry should start with an actual local timestamp formatted as `YYYY-MM-DD HH:MM TZ`, then record the completed task id, next task id, last command run, last validation result, any blocker, and any commit sha or message created at a milestone checkpoint.
- In `## Current Task` and `## Next Task`, prefer exact task ids from the main plan so execution skills can resume without guesswork.
- Before transitioning from `writing-plans` to execution, commit the approved plan artifact set if it still has an uncommitted diff.
- Stage only the approved main plan and any companion plan-pack files for this boundary commit, and use a commit message tied to the shared plan base name.
- If the worktree contains unrelated changes or there is no meaningful diff for the approved plan artifact set, stop and surface that instead of forcing a boundary commit.
- Every task must be actionable without reinterpretation.
- Each task should name the exact file or artifact, the intended outcome, any prerequisite dependency, and a direct verification method.
- Every prerequisite named by a task must be satisfied by an earlier task, milestone, or explicit external prerequisite.
- For every behavior-changing task, require an explicit test-first cycle: RED test, verify RED, GREEN code, verify GREEN, then refactor when needed.
- Do not leave the executor to invent the RED/GREEN sequence on the fly.
- Each milestone must state its definition of done, validation gate, rollback boundary, stop/replan rule, and commit checkpoint.
- At milestone boundaries, say whether execution should create a git commit before moving on and what that commit should capture.
- If repository-navigation helper readiness is already known during planning, record it as advisory context only. Do not assume it will still be available later; execution must re-check on activation.
- Do not silently change product behavior under the label of `normalization`.
- Do not leave competing architectures, dependency choices, or package layouts in the final plan. Freeze one path or stop for user input.
- If the design and repository evidence disagree on file placement, ownership, or architecture boundaries, call out the conflict explicitly instead of picking one silently.
- If the final plan intentionally deviates from the approved design, record that in an explicit `Design deviations` section with rationale.
- Every artifact referenced later in the plan pack must appear in the touched-files inventory or in an explicit external-prerequisites section.
- Compile, lint, and build checks are partial signals, not behavioral proof.
- For API, auth, persistence, contract, or user-visible behavior, include behavioral validation beyond compile or build success.
- Manual, browser-driven, or external-provider checks cannot be the only validation gate for a milestone intended for autonomous execution.
- Every validation step must be runnable as written, with any prerequisites and expected result stated explicitly.
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
- Behavior-changing tasks that mention tests only generically instead of naming the RED and GREEN checks
- Bundling multiple independently verifiable changes into one step
- Silent product-contract changes hidden inside `normalization`
- Locking in file placement or module boundaries without reconciling them with the approved design and repo evidence
- Referencing files, commands, or entry points later in the plan that never appeared in the touched-files inventory
- Using `or`, `either`, or fallback library choices inside the final implementation plan instead of freezing one path
- Dependency order that asks the executor to build consumers before their providers, contracts, or helpers exist
- Compile-only validation for auth, API, persistence, migrations, or ownership-sensitive behavior
- Manual OAuth/browser testing as the only milestone gate for an autonomous plan
- Coverage claims without a runnable command that actually measures coverage
- Saying tests happen `later` while earlier tasks already rely on those tests for real confidence
- Multi-step plans with no current milestone, milestone status, or resume protocol

## Self-Review

After writing the plan, review it once yourself before handing it off:

1. Spec coverage: can you point from each major requirement or constraint in the design to a task, milestone gate, or test-plan check?
2. Decision freeze: make sure architecture choices, library choices, and package layout are frozen to one execution path. Replace `or` branches with one selected option or escalate to the user.
3. Contract discipline: make sure `normalization` did not silently change business behavior, API semantics, or validation rules from the approved design.
4. Inventory completeness: verify that every referenced file, command entry point, test file, and helper artifact appears in touched files or explicit external prerequisites.
5. Dependency order: verify every task precondition points to something that already exists earlier in the plan.
6. Placeholder and vagueness scan: remove `TODO`, `TBD`, implied decisions, and vague verbs that hide real work.
7. Naming consistency: make sure types, flags, enums, endpoints, and file names are consistent across the whole plan pack.
8. Atomicity and resumability: confirm a fresh agent can identify the current milestone, next task, stop rule, and direct verification path without rereading chat history.
9. Validation realism: confirm that every milestone gate is runnable and deterministic enough for the intended execution mode.
10. Test realism: confirm that externally visible behavior has behavioral checks, not just compile or build checks.
11. Rollback sanity: confirm rollback notes are tied to milestone boundaries or state changes, not a hand-wavy global reset.
12. Compactness check: cut repeated spec material, duplicated validation sections, and any boilerplate that does not change execution clarity.

## Execution Handoff

After saving the plan pack and finishing self-review, ask the user to review it before implementation:

> "Implementation plan written to `<plan path>`."
> "If used, companion files are at `<status path>` and `<test plan path>`."
> "Please review them and tell me if you want any changes before we start executing."

Wait for the user's response. If they request changes, update the plan and re-run self-review. After explicit approval, create the boundary commit for the approved plan artifact set if it is still uncommitted. Only then should you offer the next execution choice:

- `subagent-driven-development` for task-by-task delegated execution with review checkpoints
- `executing-plans` for inline execution in the current session with bounded batches
