# Gigacraft Skills-First Workflow Design

- Status: Ready for user review
- Date: 2026-03-30
- Target: `gigacraft` extension workflow architecture
- Reference model: `obra/superpowers`

## 1. Problem Statement

`gigacraft` currently centers its staged workflow around explicit slash commands such as `/write-spec`, `/write-plan`, `/implement-plan`, and `/review-changes`.

That works as a deterministic manual flow, but it has two limitations:

- the normal path depends on the user explicitly invoking each next stage
- the workflow logic lives primarily in commands and root instructions instead of a reusable skills layer

The goal is to move `gigacraft` toward a **skills-first workflow** that can naturally continue from one approved stage to the next while still retaining commands as an official manual fallback path.

The design must also preserve explicit role-based delegation through subagents so that different workflow stages can still be carried out by different specialized workers such as `architect`, `planner`, `implementer`, and `reviewer`.

## 2. Current-State Observations

- The current repository is a lightweight Qwen extension with:
  - `QWEN.md`
  - `agents/`
  - `commands/`
  - `context/`
  - `plans/`
- The current `QWEN.md` defines the core staged workflow contract directly.
- The current workflow is command-first:
  - `/write-spec`
  - `/write-plan`
  - `/implement-plan`
  - `/review-changes`
- The current repository already has useful stage roles in `agents/`, but those roles are invoked conceptually by commands rather than through a skills-driven routing layer.
- `obra/superpowers` now treats skills as the primary workflow surface:
  - its root `GEMINI.md` is a thin bootstrap
  - its real workflow logic lives in `skills/`
  - its legacy commands are already marked as deprecated in favor of skills
- Qwen extensions can ship `commands`, `skills`, and `agents` together, which means `gigacraft` does not need to choose only one of those surfaces.
- Qwen subagents can be explicitly delegated by role, which preserves the ability to run different worker personas for different workflow stages.

## 3. Goals

- Make the normal `gigacraft` workflow **skills-first** instead of command-first.
- Preserve commands as an **official fallback layer** for manual control and recovery.
- Keep stage roles explicit through extension-provided subagents:
  - `architect`
  - `planner`
  - `implementer`
  - `reviewer`
  - `refactor`
- Reduce the amount of workflow policy stored directly in `QWEN.md`.
- Keep the extension understandable and lightweight rather than recreating all of `superpowers`.
- Support clear stage boundaries with approval gates between design, planning, implementation, and review.
- Distinguish shipped extension behavior from local maintainer-only instructions for working on the `gigacraft` repo itself.

## 4. Non-Goals

- Do not attempt full parity with `obra/superpowers`.
- Do not remove commands immediately.
- Do not build a hard deterministic skill chaining engine that assumes Qwen exposes explicit "call next skill" semantics.
- Do not move reusable backend standards out of `context/`.
- Do not ship maintainer-only `AGENTS.md` instructions as part of the extension payload.
- Do not redesign the extension into a larger plugin framework or add MCP servers for this migration.

## 5. Constraints And Assumptions

- The extension must remain a native Qwen extension using `qwen-extension.json`.
- The design must work with Qwen's extension model, where:
  - skills are available as model-invoked guidance
  - commands remain user-invoked entrypoints
  - agents remain explicit subagent role definitions
- The design should not rely on undocumented assumptions that one skill can deterministically and programmatically invoke another skill by name as a formal workflow primitive.
- Explicit subagent delegation by role is available and should be used for stage-specific execution where helpful.
- The repository should stay lightweight and markdown-first.
- The migration should preserve a usable workflow at every intermediate step.
- Existing command users should not lose a working path while the skills-first flow matures.

## 6. Design Options

### Option A: Keep commands as the primary workflow and add a few helper skills

Keep `QWEN.md`, `commands/`, and `agents/` mostly as they are. Add a small number of skills only for optional enhancement.

Pros:

- Minimal migration effort
- Lowest short-term change risk
- Preserves today's deterministic behavior

Cons:

- Does not solve the main problem of manual stage-to-stage progression
- Keeps workflow policy fragmented between commands and root instructions
- Leaves `gigacraft` structurally farther from the `superpowers` model the project is inspired by

### Option B: Skills-first workflow with commands as the official fallback

Move workflow policy into `skills/`, keep role execution in `agents/`, keep `commands/` as explicit manual fallback entrypoints, and reduce `QWEN.md` to a thin bootstrap/routing layer.

Pros:

- Directly addresses both desired outcomes:
  - more automatic stage progression
  - better composability and maintainability
- Preserves manual control through commands
- Keeps subagent roles explicit and reusable
- Aligns naturally with how `obra/superpowers` is now structured

Cons:

- Requires careful redistribution of responsibilities across `QWEN.md`, `skills/`, `agents/`, and `commands/`
- Behavioral validation becomes more important because the normal path relies more on skill routing

### Option C: One large workflow orchestrator skill

Create a single dominant orchestration skill that owns nearly the whole workflow, while other skills stay minimal.

Pros:

- One obvious place to look for workflow logic
- Stronger central coordination

Cons:

- High risk of growing into a monolith
- Recreates the same maintainability problem currently carried by a large root workflow contract
- Makes stage boundaries less explicit

## 7. Recommended Design

Choose **Option B: Skills-first workflow with commands as the official fallback**.

### 7.1 Responsibility split

#### `QWEN.md`

`QWEN.md` should become a **thin bootstrap layer**.

Its job is:

- establish the default expectation that relevant skills should be used first
- describe high-level workflow intent
- point the model toward the skills layer instead of reimplementing the full workflow inline

Its job is not:

- carrying the full details of brainstorming, planning, implementation, review, and verification
- duplicating detailed stage rules already owned by skills

#### `skills/`

`skills/` becomes the **primary workflow policy layer**.

Recommended initial skills:

- `using-gigacraft`
  - thin bootstrap workflow skill
  - decides which stage skill should apply based on user intent and current state
- `brainstorming`
  - design/spec creation before implementation
- `writing-plans`
  - converts an approved design into an implementation plan
- `subagent-driven-development`
  - default plan execution path when tasks are suitable for staged delegation
- `executing-plans`
  - inline execution fallback when subagent-driven execution is not desirable
- `requesting-code-review` or `reviewing`
  - correctness and regression-focused review stage
- `verification-before-completion`
  - prevents premature completion claims without real validation

Each skill owns the rules for:

- when it applies
- which artifacts it expects as input
- which output artifact or approval gate it must produce
- what the next expected workflow state is

#### `agents/`

`agents/` stays the **role execution layer**.

Recommended roles:

- `architect`
- `planner`
- `implementer`
- `reviewer`
- `refactor`
- optional `orchestrator` only if orchestration logic cannot stay comfortably in skills

Each role should remain narrow and explicit. Skills decide **when** to use a role. Agents define **how that specialized role behaves** once delegated work.

#### `commands/`

`commands/` remains the **official manual fallback layer**.

Commands continue to provide explicit entrypoints such as:

- `/write-spec`
- `/write-plan`
- `/implement-plan`
- `/review-changes`

These commands are not the primary workflow surface anymore. They are:

- a manual override for users who want explicit control
- a recovery path when skill routing does not naturally continue the workflow
- a compatibility layer during migration

Unlike `obra/superpowers`, `gigacraft` does not need to deprecate these commands immediately. They should remain documented and supported while the skills-first behavior settles.

#### `context/`

`context/` continues to hold neutral backend and language-specific overlays. This content should not be migrated into skills because it is reusable background guidance rather than workflow-stage policy.

### 7.2 Stage transitions

The design should treat stage transitions as a **behavioral contract**, not as a hard-coded skill chaining engine.

Recommended pattern:

1. `using-gigacraft` or another relevant stage skill recognizes the current user intent.
2. The appropriate stage skill runs and enforces its own approval gates.
3. When the stage completes, the skill produces a clear artifact and next-state expectation:
   - approved spec
   - implementation plan
   - completed implementation
   - review result
4. The model naturally continues into the next appropriate skill when the context strongly indicates it.
5. If that does not happen, the official fallback path is the corresponding command.

This avoids assuming undocumented platform guarantees while still producing a skills-first user experience.

### 7.3 Explicit subagent delegation

The skills-first design should still explicitly use subagent roles for different stages.

Examples:

- `brainstorming` may explicitly delegate spec drafting or refinement work to `architect`
- `writing-plans` may explicitly delegate plan construction to `planner`
- `subagent-driven-development` delegates implementation steps to `implementer`
- review stages delegate to `reviewer`
- approved structural follow-ups can be delegated to `refactor`

This preserves one of the strongest parts of the current design: stage work is still carried out by specialized roles instead of one undifferentiated agent.

### 7.4 Local maintainer `AGENTS.md`

The repository should support a **local maintainer-only `AGENTS.md`** that helps when developing `gigacraft` itself, without shipping that file as part of the extension.

Recommended policy:

- `AGENTS.md` is allowed locally at the repository root for maintainer guidance
- it should be excluded from version control through `.git/info/exclude` or an equivalent local-only ignore mechanism
- the repo may optionally ship `AGENTS.example.md` or a short README note describing the pattern

This file should contain maintainer-only guidance such as:

- how to evolve the extension safely
- how to compare behavior against `obra/superpowers`
- how to treat `commands` as fallback rather than the primary path
- local development conventions for working on the extension repo itself

It should not contain shipped runtime behavior that end users are expected to receive through the extension.

### 7.5 Migration strategy

Use a three-phase migration.

#### Phase 1: Add skills without breaking commands

- Add a new `skills/` directory and register it in `qwen-extension.json`
- Introduce the initial workflow skills
- Keep commands functioning as they do today

#### Phase 2: Move workflow policy out of `QWEN.md`

- Reduce `QWEN.md` to a thin bootstrap/routing document
- Move detailed workflow rules into skills
- Keep `agents/` role prompts focused and narrow

#### Phase 3: Simplify command responsibility

- Keep commands documented and supported as the official fallback layer
- Align command behavior with the skills-defined workflow
- Optionally make some commands thinner over time, but do not force deprecation until the skills-first path proves reliable

## 8. Error Handling And Validation

### 8.1 Fallback behavior

- If a skill does not activate naturally, the user can explicitly invoke the corresponding command.
- If a stage skill detects missing prerequisites, it should direct the workflow back to the correct prior stage instead of guessing.
- If a subagent reports missing context or cannot complete the task, the controller should either provide better context, use a more appropriate role, or require explicit human confirmation before continuing.
- If commands and skills diverge in behavior, skills are the source of truth and commands must be realigned.

### 8.2 Validation levels

#### Static structure validation

- `qwen-extension.json` explicitly registers `commands`, `skills`, and `agents`
- `QWEN.md` is short and does not duplicate detailed stage logic
- each intended workflow stage has a corresponding skill or a deliberate reason it remains command-only

#### Behavioral validation

- a normal feature request starts the design-oriented workflow without requiring `/write-spec`
- after design approval, planning becomes the natural next stage
- stage-specific work can be explicitly delegated to the correct role:
  - `architect`
  - `planner`
  - `implementer`
  - `reviewer`

#### Fallback validation

- `/write-spec`, `/write-plan`, `/implement-plan`, and `/review-changes` continue to work
- a user can still complete the workflow even when auto skill-routing is imperfect
- the extension remains usable in both skills-first and command-fallback modes

## 9. Impacted Areas

- Root extension contract:
  - `qwen-extension.json`
  - `QWEN.md`
- New primary workflow layer:
  - `skills/`
- Existing role definitions:
  - `agents/`
- Existing manual fallback layer:
  - `commands/`
- Shared guidance overlays:
  - `context/`
- Maintainer-only local workflow guidance:
  - local `AGENTS.md` at repo root, excluded from git
  - optional tracked `AGENTS.example.md`
- Documentation updates:
  - `README.md`
  - future migration notes or examples under `docs/`

## 10. Risks

- If `QWEN.md` remains too large, the repo will keep duplicating workflow policy even after adding skills.
- If skills are too broad, the design may replace one monolith with another.
- If commands are neglected during migration, the fallback path will drift and become unreliable.
- If stage boundaries are unclear, the model may skip approval gates or continue too aggressively.
- If subagent prompts are too generic, explicit role delegation will lose value.
- If local maintainer guidance leaks into shipped files, the extension will mix authoring concerns with user-facing runtime behavior.

## 11. Success Criteria

The migration is successful when:

- the normal workflow no longer depends on users manually invoking each next command
- stage-specific work can still be delegated explicitly to specialized subagent roles
- commands remain a documented, supported fallback path
- `QWEN.md` becomes a thin bootstrap rather than the main workflow implementation
- local repo-maintainer instructions can live in an untracked `AGENTS.md` without being shipped as extension behavior

## 12. Open Questions

There are no blocking open questions for the design itself.

Follow-up decisions for implementation planning:

- which initial skill set should land first in v1 of the migration
- whether to introduce a `using-gigacraft` bootstrap skill immediately or keep bootstrap behavior directly in `QWEN.md` for one intermediate step
- whether to add a tracked `AGENTS.example.md` or keep maintainer setup fully local
