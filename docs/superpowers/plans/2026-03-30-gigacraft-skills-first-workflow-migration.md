# Gigacraft Skills-First Workflow Migration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Convert `gigacraft` from a command-first extension to a skills-first workflow while preserving `commands/` as the official manual fallback path.

**Architecture:** The migration adds a new `skills/` layer that becomes the primary workflow policy surface, keeps `agents/` as explicit role definitions for subagent delegation, and reduces `QWEN.md` to a thin bootstrap that points into the skills layer. Existing commands remain supported, but they are rewritten as documented manual fallbacks rather than the primary workflow path.

**Tech Stack:** Qwen extension metadata (`qwen-extension.json`), Markdown prompt assets, Qwen skills, Qwen subagents, repository docs.

---

## Reference Spec

- `docs/superpowers/specs/2026-03-30-gigacraft-skills-first-workflow-design.md`

## Scope

- Add the `skills/` directory and register it in the extension manifest.
- Introduce the first shipped workflow skills:
  - `using-gigacraft`
  - `brainstorming`
  - `writing-plans`
  - `subagent-driven-development`
  - `executing-plans`
  - `requesting-code-review`
  - `verification-before-completion`
- Convert `QWEN.md` into a thin bootstrap/root routing document.
- Keep `commands/` as supported manual fallbacks and update their wording accordingly.
- Update repo docs to explain the new skills-first workflow.
- Add a tracked `AGENTS.example.md` for maintainers while keeping real `AGENTS.md` local-only.
- Refresh the README intro summary so it no longer describes slash commands as the primary surface.

## Non-Goals

- No runtime MCP integrations.
- No Gemini-specific manifest or cross-platform packaging work.
- No deprecation/removal of `commands/` in this migration.
- No wording migration for `write-chunked-plan`, `implement-chunked-plan`, or `refactor-scope` beyond keeping them documented as advanced/manual paths.
- No redesign of the existing `agents/` roles beyond the minimum prompt alignment needed for skills-first usage.
- No release automation or marketplace packaging work.

## File Structure

### Create

- `skills/using-gigacraft/SKILL.md`
  - bootstrap skill that routes work into the right workflow skill
- `skills/brainstorming/SKILL.md`
  - design/spec stage policy
- `skills/writing-plans/SKILL.md`
  - implementation-planning stage policy
- `skills/subagent-driven-development/SKILL.md`
  - default execution stage using explicit subagents
- `skills/executing-plans/SKILL.md`
  - inline execution fallback stage
- `skills/requesting-code-review/SKILL.md`
  - critical review stage
- `skills/verification-before-completion/SKILL.md`
  - final validation gate
- `AGENTS.example.md`
  - tracked maintainer template for a local, untracked `AGENTS.md`

### Modify

- `qwen-extension.json`
  - explicitly register `commands`, `skills`, and `agents`
- `QWEN.md`
  - reduce to thin bootstrap plus shared context references
- `commands/write-spec.md`
  - clarify that it is a manual fallback for the design stage
- `commands/write-plan.md`
  - clarify that it is a manual fallback for the planning stage
- `commands/implement-plan.md`
  - clarify that it is a manual fallback for the execution stage
- `commands/review-changes.md`
  - clarify that it is a manual fallback for the review stage
- `README.md`
  - document skills-first workflow, fallback commands, `skills/` directory, and maintainer `AGENTS.example.md`
  - refresh the top-level repository summary to match the new architecture

### Keep As-Is Unless Needed During Implementation

- `agents/architect.md`
- `agents/planner.md`
- `agents/implementer.md`
- `agents/reviewer.md`
- `agents/refactor.md`
- `agents/orchestrator.md`
- `context/*.md`

The current agent prompts are already narrow enough for a first migration pass. If an implementation step discovers a prompt mismatch, make the smallest prompt edit needed rather than broadening scope.

## Task 1: Register The New Workflow Surface And Thin Bootstrap

**Files:**
- Create: `skills/using-gigacraft/SKILL.md`
- Modify: `qwen-extension.json`
- Modify: `QWEN.md`

- [ ] **Step 1: Prove the manifest and bootstrap do not yet expose a skills-first surface**

Run:

```bash
rg -n '"(skills|agents|commands)"' qwen-extension.json
test -f skills/using-gigacraft/SKILL.md
```

Expected:

- `rg` prints nothing for `skills`, `agents`, or `commands`
- `test -f` exits non-zero because the bootstrap skill does not exist yet

- [ ] **Step 2: Register all extension surfaces explicitly in `qwen-extension.json`**

Replace the file with:

```json
{
  "name": "gigacraft",
  "version": "0.1.0",
  "description": "Structured backend workflow extension for Qwen Code and gigacraft.",
  "contextFileName": "QWEN.md",
  "commands": "commands",
  "skills": "skills",
  "agents": "agents"
}
```

- [ ] **Step 3: Replace `QWEN.md` with a thin bootstrap and shared context entrypoint**

Replace `QWEN.md` with:

```md
# QWEN.md

@./skills/using-gigacraft/SKILL.md
@./context/backend-standards.md

Use language-specific or workflow-specific overlays only when the repository or task clearly calls for them:

- `context/java-standards.md`
- `context/go-standards.md`
- `context/testing-standards.md`
- `context/service-checklist.md`

Keep the default path skills-first. Use slash commands as the manual fallback path when the user explicitly requests them or when automatic stage routing is not sufficient.
```

- [ ] **Step 4: Create the bootstrap workflow skill**

Create `skills/using-gigacraft/SKILL.md` with:

```md
---
name: using-gigacraft
description: Use when starting work in a repository that follows the gigacraft structured backend workflow; route to the right workflow skill before coding and keep slash commands as manual fallback.
---

# Using Gigacraft

## Purpose

`gigacraft` is a skills-first backend workflow for Qwen Code.

Your job at the start of work is to route into the correct workflow stage instead of immediately writing code.

## Rules

- Prefer the skills-first path over slash commands.
- Use `brainstorming` when the user is describing a feature, change, or design problem that is not already specified.
- Use `writing-plans` when there is an approved spec and the next job is implementation planning.
- Use `subagent-driven-development` or `executing-plans` only after an approved implementation plan exists.
- Use `requesting-code-review` before declaring merge readiness.
- Use `verification-before-completion` before claiming work is done or fixed.
- Honor explicit user requests for slash-command stages as manual fallbacks.
- Keep commands available as recovery paths, not the primary workflow.

## Stage Map

1. Brainstorm and approve a design.
2. Turn the approved design into a detailed implementation plan.
3. Execute the plan.
4. Review the changes.
5. Verify before completion.

## Routing Guidance

- If the next stage is obvious from the conversation, move into that skill.
- If the next stage is ambiguous, ask one narrow clarifying question.
- If automatic routing is not enough, tell the user which slash command is the manual fallback.
```

- [ ] **Step 5: Re-run the bootstrap checks and commit**

Run:

```bash
rg -n '"(skills|agents|commands)"' qwen-extension.json
test -f skills/using-gigacraft/SKILL.md
sed -n '1,80p' QWEN.md
```

Expected:

- `qwen-extension.json` shows all three explicit directory registrations
- the bootstrap skill file now exists
- `QWEN.md` is short and points into `skills/`

Commit:

```bash
git add qwen-extension.json QWEN.md skills/using-gigacraft/SKILL.md
git commit -m "feat: add skills-first extension bootstrap"
```

## Task 2: Add The Design And Planning Skills

**Files:**
- Create: `skills/brainstorming/SKILL.md`
- Create: `skills/writing-plans/SKILL.md`

- [ ] **Step 1: Prove the stage-entry skills do not exist**

Run:

```bash
test -f skills/brainstorming/SKILL.md
test -f skills/writing-plans/SKILL.md
```

Expected:

- both commands exit non-zero

- [ ] **Step 2: Create the design-stage skill**

Create `skills/brainstorming/SKILL.md` with:

```md
---
name: brainstorming
description: Use before implementation when the user is exploring a feature, change, migration, or design decision that is not already fully specified.
---

# Brainstorming

## Goal

Turn a rough request into an approved design before implementation planning starts.

## Process

1. Inspect the relevant repository context first.
2. Ask clarifying questions one at a time.
3. Present two or three viable design options when trade-offs matter.
4. Recommend one option and explain why it fits the current repository.
5. Present the design in reviewable sections and get user approval.
6. Save the approved design to `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md`.
7. Stop after the design is approved and written; the next workflow stage is `writing-plans`.

## Rules

- Do not write production code.
- Do not skip user approval for the design.
- Distinguish observed facts from assumptions.
- Use the `architect` subagent when a separate focused spec-writing pass will help.
- If the user explicitly asks for `/write-spec`, honor that as a manual fallback.
```

- [ ] **Step 3: Create the planning-stage skill**

Create `skills/writing-plans/SKILL.md` with:

```md
---
name: writing-plans
description: Use when there is an approved design and the next job is to produce a concrete implementation plan before touching code.
---

# Writing Plans

## Goal

Turn an approved design into a concrete implementation plan with exact files, validation, and execution order.

## Process

1. Read the approved design first.
2. Inspect only the files, prompts, docs, and configs that will change.
3. Break the work into small, verifiable tasks.
4. Keep the plan aligned with current repository patterns.
5. Save the plan to `docs/superpowers/plans/YYYY-MM-DD-<topic>.md`.
6. Offer the next execution choice:
   - `subagent-driven-development`
   - `executing-plans`

## Rules

- Do not write production code.
- Prefer minimal-diff plans over idealized redesigns.
- Every task must be actionable without reinterpretation.
- Surface assumptions and remaining unknowns explicitly.
- Use the `planner` subagent when a focused planning pass is useful.
- If the user explicitly asks for `/write-plan`, honor that as a manual fallback.
```

- [ ] **Step 4: Verify the new stage skills are discoverable**

Run:

```bash
find skills -maxdepth 2 -name SKILL.md | sort
rg -n '^name: (brainstorming|writing-plans)$' skills/brainstorming/SKILL.md skills/writing-plans/SKILL.md
```

Expected:

- the `skills/` tree now includes both new directories
- `rg` prints both exact skill names

- [ ] **Step 5: Commit the design/planning skill layer**

Commit:

```bash
git add skills/brainstorming/SKILL.md skills/writing-plans/SKILL.md
git commit -m "feat: add design and planning skills"
```

## Task 3: Add The Execution Skills

**Files:**
- Create: `skills/subagent-driven-development/SKILL.md`
- Create: `skills/executing-plans/SKILL.md`

- [ ] **Step 1: Prove the execution skills do not exist**

Run:

```bash
test -f skills/subagent-driven-development/SKILL.md
test -f skills/executing-plans/SKILL.md
```

Expected:

- both commands exit non-zero

- [ ] **Step 2: Create the default execution skill**

Create `skills/subagent-driven-development/SKILL.md` with:

```md
---
name: subagent-driven-development
description: Use when executing an approved implementation plan in the current session through explicit, stage-aware subagent delegation.
---

# Subagent-Driven Development

## Goal

Execute an approved implementation plan task by task using focused subagents and explicit review checkpoints.

## Process

1. Read the approved implementation plan.
2. Execute one task at a time.
3. Delegate task implementation to the `implementer` subagent.
4. Route completed work to the `reviewer` subagent before marking the task done.
5. Continue until the full plan is complete.

## Rules

- Do not start without an approved plan.
- Do not batch unrelated tasks together.
- Keep subagent scope narrow and bounded to the current task.
- Re-run targeted validation after meaningful changes.
- Escalate when the plan is blocked by reality instead of silently redesigning it.
```

- [ ] **Step 3: Create the inline execution fallback skill**

Create `skills/executing-plans/SKILL.md` with:

```md
---
name: executing-plans
description: Use when there is an approved implementation plan and execution should stay inline in the current session rather than being delegated task by task.
---

# Executing Plans

## Goal

Execute an approved implementation plan inline while preserving narrow scope and incremental validation.

## Process

1. Read the approved implementation plan.
2. Work through the plan in order.
3. Keep each implementation batch small and reviewable.
4. Validate after meaningful changes.
5. Hand off to review before declaring completion.

## Rules

- Do not broaden scope beyond the approved plan.
- Reuse existing repository patterns aggressively.
- Treat missing validation as incomplete work.
- Use this skill only when inline execution is preferable to `subagent-driven-development`.
```

- [ ] **Step 4: Verify the execution layer is present**

Run:

```bash
rg -n '^name: (subagent-driven-development|executing-plans)$' \
  skills/subagent-driven-development/SKILL.md \
  skills/executing-plans/SKILL.md
```

Expected:

- `rg` prints both exact execution skill names

- [ ] **Step 5: Commit the execution skills**

Commit:

```bash
git add skills/subagent-driven-development/SKILL.md skills/executing-plans/SKILL.md
git commit -m "feat: add execution skills"
```

## Task 4: Add Review And Verification Skills And Align Manual Fallback Commands

**Files:**
- Create: `skills/requesting-code-review/SKILL.md`
- Create: `skills/verification-before-completion/SKILL.md`
- Modify: `commands/write-spec.md`
- Modify: `commands/write-plan.md`
- Modify: `commands/implement-plan.md`
- Modify: `commands/review-changes.md`

- [ ] **Step 1: Prove the review/verification skills do not exist and command descriptions are still command-first**

Run:

```bash
test -f skills/requesting-code-review/SKILL.md
test -f skills/verification-before-completion/SKILL.md
sed -n '1,40p' commands/write-spec.md
```

Expected:

- both `test -f` commands exit non-zero
- `commands/write-spec.md` still describes the command as the primary stage entrypoint

- [ ] **Step 2: Create the review and verification skills**

Create `skills/requesting-code-review/SKILL.md` with:

```md
---
name: requesting-code-review
description: Use after implementation to review correctness, regressions, scope adherence, and missing validation before merge or completion.
---

# Requesting Code Review

## Goal

Review current changes critically against correctness, plan adherence, compatibility, and validation.

## Rules

- Prefer concrete findings over style comments.
- Focus on regressions, missing tests, compatibility, and over-scoped work.
- Use the `reviewer` subagent for a focused review pass when useful.
- Do not declare merge readiness if blocker findings remain.
```
and create `skills/verification-before-completion/SKILL.md` with:

```md
---
name: verification-before-completion
description: Use before claiming work is complete or fixed; require evidence from real validation instead of assertion.
---

# Verification Before Completion

## Goal

Prevent premature completion claims by checking that the required validation actually ran and succeeded.

## Rules

- Do not say work is complete without quoting the validation that was run.
- Prefer the narrowest useful validation first, then expand only if risk justifies it.
- If validation could not run, say so explicitly and explain the remaining risk.
- Treat missing verification as incomplete work.
```

- [ ] **Step 3: Rewrite the fallback commands so they stay supported but are clearly no longer the primary path**

Replace the four command files with these forms:

`commands/write-spec.md`

```md
---
description: Manual fallback: write a design plan or spec before implementation planning starts.
---

Use the `architect` agent.

Goal:
Write a design plan or spec that defines what should be built before implementation planning begins when the user explicitly chooses the command path or when skills-first routing is unavailable.

Process:

1. Restate the problem in repository terms.
2. Identify constraints, assumptions, and unknowns.
3. Inspect only the minimum relevant code paths, contracts, configs, and surrounding patterns.
4. Produce two or three viable design options when tradeoffs are non-trivial.
5. Recommend one option and explain why it fits the current codebase.
6. Stop before step-by-step implementation planning.

Required output:

- problem statement
- current-state observations
- goals
- non-goals
- constraints and assumptions
- design options
- recommendation
- impacted areas
- risks
- open questions

Rules:

- Do not write production code.
- Prefer designs that fit existing package, module, or service boundaries.
- Consider API contracts, persistence, config, observability, rollout, and rollback.
- Use language-specific overlays only when they actually apply.
```

`commands/write-plan.md`

```md
---
description: Manual fallback: convert an approved design into a concrete implementation plan.
---

Use the `planner` agent.

Goal:
Produce a concrete, executable implementation plan from an approved design plan or spec when the user explicitly chooses the command path or when skills-first routing is unavailable.

Process:

1. Read the approved design first.
2. Inspect the specific files, packages, symbols, tests, and configs likely to change.
3. Convert the design into small, verifiable steps.
4. Minimize scope and keep the plan aligned with existing repository patterns.
5. Call out any unknowns that must be resolved during implementation.

Required output:

- summary
- reference to approved design
- scope
- non-goals
- affected files and packages
- step-by-step tasks
- test changes
- migration or compatibility notes
- validation sequence
- risks and unknowns

Rules:

- Do not write full production code unless needed for discovery.
- Prefer plans another agent can execute without reinterpretation.
- Prefer minimal-diff changes over idealized redesigns.
```

`commands/implement-plan.md`

```md
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
```

`commands/review-changes.md`

```md
---
description: Manual fallback: critically review current changes against the approved design and implementation plan.
---

Use the `reviewer` agent.

Goal:
Assess whether the current changes correctly implement the approved plan and are safe to merge when the user explicitly chooses the command path or when skills-first routing is unavailable.

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
```

- [ ] **Step 4: Verify both the new skills and the fallback wording**

Run:

```bash
rg -n '^name: (requesting-code-review|verification-before-completion)$' \
  skills/requesting-code-review/SKILL.md \
  skills/verification-before-completion/SKILL.md
rg -n '^description: Manual fallback:' commands/write-spec.md commands/write-plan.md commands/implement-plan.md commands/review-changes.md
```

Expected:

- `rg` prints both new skill names
- every command file now starts with `description: Manual fallback:`

- [ ] **Step 5: Commit the review and fallback alignment**

Commit:

```bash
git add \
  skills/requesting-code-review/SKILL.md \
  skills/verification-before-completion/SKILL.md \
  commands/write-spec.md \
  commands/write-plan.md \
  commands/implement-plan.md \
  commands/review-changes.md
git commit -m "feat: add review skills and align fallback commands"
```

## Task 5: Update Repository Docs And Add The Maintainer Overlay Template

**Files:**
- Create: `AGENTS.example.md`
- Modify: `README.md`

- [ ] **Step 1: Prove the repo docs still describe a command-first workflow and that no tracked maintainer template exists**

Run:

```bash
test -f AGENTS.example.md
rg -n 'slash-command|/write-spec|/write-plan|/implement-plan|/review-changes' README.md
rg -n 'skills/' README.md
```

Expected:

- `test -f` exits non-zero
- `README.md` still emphasizes slash commands
- `skills/` is not yet part of the documented layout

- [ ] **Step 2: Create the tracked maintainer template**

Create `AGENTS.example.md` with:

```md
# AGENTS.example.md

This file is a template for a local, untracked `AGENTS.md` used when developing the `gigacraft` extension itself.

## Local-Only Rule

- Keep the real `AGENTS.md` out of git.
- Add `AGENTS.md` to `.git/info/exclude` in your local clone before using it.

## What Belongs Here

- Maintainer notes for evolving `gigacraft`
- Local workflow preferences for working on the extension repo
- Comparison notes against `obra/superpowers`
- Reminders that `skills/` is the primary workflow layer and `commands/` is the manual fallback layer

## What Does Not Belong Here

- User-facing runtime behavior that should ship in the extension
- Rules that belong in `QWEN.md`, `skills/`, `agents/`, `commands/`, or `context/`
```

- [ ] **Step 3: Rewrite `README.md` around the skills-first workflow**

Replace the workflow and layout sections in `README.md` with content of this shape:

```md
`gigacraft` is a lightweight native Qwen extension for structured backend work. It provides:

- a skills-first workflow for spec, plan, implementation, review, and verification
- focused subagents for each workflow stage
- supported manual fallback commands when explicit stage control is preferable
- neutral backend standards with Java and Go overlays

## Default Workflow

Use the skills-first path for most backend work:

1. `using-gigacraft` routes to the right workflow stage
2. `brainstorming`
3. `writing-plans`
4. `subagent-driven-development` or `executing-plans`
5. `requesting-code-review`
6. `verification-before-completion`

## Manual Fallback Commands

Slash commands remain supported when you want explicit control or when automatic stage routing is not enough:

1. `/write-spec`
2. `/write-plan`
3. `/implement-plan`
4. `/review-changes`

Advanced/manual commands remain available for the chunked and scoped-refactor paths:

- `/write-chunked-plan`
- `/implement-chunked-plan`
- `/refactor-scope`

## Repository Layout

```text
.
├── qwen-extension.json
├── QWEN.md
├── agents/
├── commands/
├── skills/
├── context/
├── plans/
└── docs/
```

### Key directories

- `skills/`: primary workflow policy for design, planning, execution, review, and verification
- `agents/`: focused subagent role prompts for architect, planner, implementer, reviewer, refactor, and orchestrator
- `commands/`: supported manual fallback entrypoints for stage-by-stage control
- `context/`: reusable neutral backend rules plus Java, Go, testing, and service overlays

## Maintainer Notes

If you are developing `gigacraft` itself, copy `AGENTS.example.md` to a local `AGENTS.md` and add `AGENTS.md` to `.git/info/exclude`. Keep maintainer-only guidance there; keep shipped extension behavior in the tracked prompt assets.
```

- [ ] **Step 4: Verify docs now describe the intended architecture**

Run:

```bash
test -f AGENTS.example.md
rg -n 'skills-first|Manual Fallback Commands|skills/' README.md
```

Expected:

- the tracked maintainer template exists
- `README.md` now documents the skills-first path, the fallback commands, and the `skills/` directory

- [ ] **Step 5: Commit the documentation layer**

Commit:

```bash
git add AGENTS.example.md README.md
git commit -m "docs: document skills-first workflow"
```

## Test Changes

- No application runtime tests are added because this repository is a prompt/extension package, not an executable service.
- Validation is structural and behavioral:
  - manifest registration checks
  - file existence checks
  - prompt-content assertions with `rg`
  - extension smoke checks through the Qwen CLI

## Migration And Compatibility Notes

- `using-gigacraft` ships in the first migration wave. This resolves the bootstrap question from the spec and keeps `QWEN.md` thin from the start.
- `AGENTS.example.md` is tracked in git, but `AGENTS.md` remains local-only. This resolves the maintainer-overlay question without shipping a live maintainer file.
- `commands/` remain supported. They are rewritten as manual fallbacks rather than deprecated immediately.
- `write-chunked-plan`, `implement-chunked-plan`, and `refactor-scope` stay documented as advanced/manual commands in this migration and do not need the same wording rewrite as the four core stage commands.
- Existing `agents/` prompts remain the role surface for subagent delegation, so the migration changes workflow routing more than role definitions.

## Validation Sequence

1. Verify manifest and bootstrap registration:

```bash
cat qwen-extension.json
find skills -maxdepth 2 -name SKILL.md | sort
sed -n '1,80p' QWEN.md
```

Expected:

- manifest includes `commands`, `skills`, and `agents`
- all seven skill files exist
- `QWEN.md` is short and points into `skills/`

2. Verify fallback command wording:

```bash
rg -n '^description: Manual fallback:' commands/*.md
```

Expected:

- the stage commands are clearly marked as manual fallbacks

3. Verify docs alignment:

```bash
rg -n 'skills-first|Manual Fallback Commands|AGENTS.example.md' README.md AGENTS.example.md
```

Expected:

- repo docs now describe the skills-first architecture and local maintainer pattern

4. Re-link the extension and confirm it is still installable:

```bash
qwen extensions link /Users/kozlov/Workspace/gigacraft
qwen extensions list | rg gigacraft
```

Expected:

- linking succeeds without manifest errors
- the installed extensions list includes `gigacraft`

5. Manual smoke test in a fresh `qwen` session:

Run:

```text
/skills
```

Expected:

- the skill list includes:
  - `using-gigacraft`
  - `brainstorming`
  - `writing-plans`
  - `subagent-driven-development`
  - `executing-plans`
  - `requesting-code-review`
  - `verification-before-completion`

Then ask:

```text
Help me plan a backend change for this repo.
```

Expected:

- the session follows the skills-first path instead of requiring an immediate `/write-spec`

## Risks And Unknowns

- Qwen's automatic skill routing is behavioral rather than a hard deterministic chaining engine, so prompt wording may need one iteration after smoke testing.
- If `QWEN.md` remains too verbose after implementation, it will dilute the point of the migration; keep it aggressively thin.
- If the new skills become too detailed too quickly, the repo can recreate a monolithic workflow surface under `skills/` instead of in `QWEN.md`.
- If manual fallback commands are not kept aligned in follow-up work, the repo will drift into two inconsistent workflow surfaces.
