# Gigacraft Qwen Extension Design

- Status: Approved for planning
- Date: 2026-03-29
- Target: Native Qwen extension for a personal `gigacraft` fork
- Source draft: `qwen_superpowers_agent_draft.md`

## 1. Problem Statement

Turn the draft in `qwen_superpowers_agent_draft.md` into a lightweight, installable repository that works as a native Qwen extension for `gigacraft`.

The extension should provide a structured backend-oriented workflow with explicit stages for design, implementation planning, implementation, review, and optional scoped refactoring, without bundling MCP servers or other runtime services in v1.

## 2. Current-State Observations

- The repository currently contains only the draft file and no extension scaffold.
- The draft already defines the core workflow, agent roles, command entrypoints, and shared context documents.
- `qwen` supports native extensions via `qwen-extension.json`.
- `qwen` can also consume Gemini extensions through conversion, but native Qwen packaging is the cleaner target for `gigacraft`.
- The user wants a lightweight extension repo with no MCP servers.
- The user wants a neutral backend profile rather than Java-only or Go-only defaults.

## 3. Goals

- Create a native Qwen extension repository for `gigacraft`.
- Preserve the draft's staged workflow:
  - spec/design
  - implementation plan
  - implement
  - review
  - optional refactor
- Keep prompts layered and reusable:
  - small `QWEN.md`
  - focused agent files
  - thin command files
  - shared backend context overlays
- Default to a neutral backend stance while retaining Java and Go guidance as overlays.
- Keep the install and usage flow simple for local linking and future git-based installation.

## 4. Non-Goals

- No MCP servers in v1.
- No build pipeline or code generation system for the extension itself.
- No Gemini-native manifest or dual-platform packaging in v1.
- No attempt to cover frontend, mobile, or non-backend workflows.
- No attempt to make chunked orchestration the default workflow for every task.

## 5. Constraints And Assumptions

- The extension must be native to Qwen, using `qwen-extension.json`.
- The repo should remain lightweight and markdown-first.
- The user primarily wants this for a personal `gigacraft` fork, so local ergonomics matter more than marketplace completeness.
- The design should stay close to the draft instead of introducing a larger framework or extra abstractions.
- The extension should be installable through `qwen extensions link <repo-path>`.
- Versioning can start at `0.1.0`.

## 6. Design Options

### Option A: Qwen-native extension repo

Create a native Qwen extension repository with `qwen-extension.json`, `QWEN.md`, markdown-based agents, commands, shared context docs, and example plans.

Pros:
- Cleanest fit for `gigacraft`
- Smallest runtime surface
- No compatibility warning or conversion layer
- Easiest to reason about and validate

Cons:
- Gemini support is deferred to a future phase

### Option B: Qwen-native repo with Gemini placeholders

Create the Qwen-native extension, but also include reserved files or docs for future Gemini support.

Pros:
- Slightly easier future cross-platform expansion

Cons:
- Adds noise to v1
- Solves a future problem before it is needed

### Option C: Prompt pack only

Ship the repository as a markdown prompt pack without an extension manifest.

Pros:
- Simplest possible repository

Cons:
- Worse install and usage experience
- Does not meet the goal of being a real extension for `gigacode`

## 7. Recommended Design

Choose **Option A: Qwen-native extension repo**.

### Repository shape

```text
.
├── qwen-extension.json
├── QWEN.md
├── README.md
├── LICENSE
├── agents/
│   ├── architect.md
│   ├── planner.md
│   ├── implementer.md
│   ├── reviewer.md
│   ├── refactor.md
│   └── orchestrator.md
├── commands/
│   ├── write-spec.md
│   ├── write-plan.md
│   ├── write-chunked-plan.md
│   ├── implement-plan.md
│   ├── implement-chunked-plan.md
│   ├── review-changes.md
│   └── refactor-scope.md
├── context/
│   ├── backend-standards.md
│   ├── java-standards.md
│   ├── go-standards.md
│   ├── testing-standards.md
│   └── service-checklist.md
└── plans/
    └── 0001-example-feature-plan.md
```

### Workflow contract

Default workflow:

1. `write-spec` -> `architect`
2. `write-plan` -> `planner`
3. `implement-plan` -> `implementer`
4. `review-changes` -> `reviewer`

Advanced workflow:

- `write-chunked-plan` -> `planner`
- `implement-chunked-plan` -> `orchestrator`
- `refactor-scope` -> `refactor`

### Prompt layering

- `QWEN.md` defines the global extension contract, tool preferences, and workflow expectations.
- `agents/` contains narrow, role-specific prompts.
- `commands/` provides stable workflow entrypoints with minimal duplication.
- `context/` carries reusable backend standards and language-specific overlays.

### Neutral backend default

The base extension remains neutral across backend stacks. Java- and Go-specific guidance stays in dedicated context overlays so the extension remains reusable in mixed backend environments.

### Validation and release shape

V1 success means:

- the repository is a valid Qwen extension
- `qwen extensions link <repo-path>` works
- the extension appears in `qwen extensions list`
- the extension assets are understandable and usable without referring back to the draft

## 8. Impacted Areas

- Root extension metadata and top-level context:
  - `qwen-extension.json`
  - `QWEN.md`
  - `README.md`
  - `LICENSE`
- Agent role prompts:
  - `agents/*.md`
- Command entrypoints:
  - `commands/*.md`
- Shared context references:
  - `context/*.md`
- Example durable planning artifact:
  - `plans/0001-example-feature-plan.md`

## 9. Risks

- Prompt duplication across agents and commands could make future maintenance noisy.
- An overlong `QWEN.md` would blur responsibilities that should stay in agent files.
- If the advanced chunked flow is too prominent, users may adopt unnecessary complexity for small tasks.
- Without careful README guidance, the extension may be installable but not intuitively usable.
- The extension may need small iterations once exercised against real `gigacode` workflows.

## 10. Open Questions

There are no blocking open questions for v1.

Future follow-ups, intentionally deferred:

- add Gemini-native support
- add optional MCP integrations
- add stronger profile presets for Java-heavy or Go-heavy repos
- add release automation once the prompt surface stabilizes
