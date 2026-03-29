# Gigacraft Smoke Go Harness Design

- Status: Ready for user review
- Date: 2026-03-30
- Target: dedicated smoke-test repository for end-to-end validation of the `gigacraft` extension
- Planned repository path: `/Users/kozlov/Workspace/gigacraft-smoke-go`

## 1. Problem Statement

`gigacraft` now has a skills-first workflow, but the current smoke tests are still too close to the extension repository itself.

That creates two problems:

- the extension is being validated inside a repository that already contains `skills/`, `commands/`, `agents/`, and `docs/superpowers`, which can distort routing behavior
- the current ad hoc test runs do not provide a stable, repeatable harness for full-cycle end-to-end validation

The goal is to design a dedicated, persistent git-based smoke-test repository that can validate `gigacraft` in a more realistic environment through isolated worktree runs.

The harness should support full-cycle validation of:

- design/spec flow
- implementation planning flow
- execution flow
- review flow
- verification-before-completion flow

It should also verify that the appropriate `gigacraft` skills and stage-specific agents are used in the expected places when observable runtime evidence exists.

## 2. Current-State Observations

- Recent smoke tests were run from ad hoc disposable clones outside the main `gigacraft` checkout.
- Those runs already proved that:
  - `qwen` can discover the new `gigacraft` skills
  - stage routing reacts sensibly to prompt wording
  - live runs work once environment variables are loaded from `.env`
- However, those tests still depend on manual setup and one-off shell commands rather than a durable harness.
- There is currently no dedicated repository for scenario definitions, worktree creation, run capture, or assertions.
- The user wants a persistent repository with:
  - a nearly empty `main`
  - git-based history
  - scenario execution through separate worktrees
- The user wants the harness to test a simple Go project, such as `todo-list-cli`, because a small backend-ish codebase is a better proxy for real user repos than the extension repo itself.
- The user wants two canonical scenario types:
  - bootstrap a new project from an almost empty repository
  - evolve an existing Go CLI by adding a feature
- The user also wants the harness to validate not just outcomes, but whether `gigacraft` used the correct stage skills and agents in the appropriate places.
- The current `qwen` CLI provides useful observability primitives:
  - `--output-format json|stream-json`
  - `-d/--debug`
  - debug logs under `~/.qwen/debug/...`

## 3. Goals

- Create a dedicated repository at `/Users/kozlov/Workspace/gigacraft-smoke-go`.
- Keep `main` intentionally almost empty and stable.
- Run all smoke tests in separate worktrees rather than in the primary checkout.
- Support a full end-to-end cycle rather than stage-only spot checks.
- Capture durable scenario definitions in versioned files.
- Capture runtime artifacts outside git for each run.
- Validate not only file/test outcomes but also stage routing and agent usage evidence.
- Keep the harness reusable and repeatable rather than a one-off script collection.
- Make it easy for future runs to remember how to operate the harness through a tracked `AGENTS.md`.

## 4. Non-Goals

- Do not turn the smoke repository into a production application.
- Do not keep run outputs or secrets in git.
- Do not require perfect oracle-level determinism for every single model utterance.
- Do not make `refactor` or `orchestrator` mandatory for the first canonical scenarios.
- Do not require the harness to validate every possible `gigacraft` workflow branch in v1.
- Do not store the real `.env` or copied credentials inside the smoke repository.

## 5. Constraints And Assumptions

- The smoke repository should be separate from the `gigacraft` extension repository.
- The base path should be `/Users/kozlov/Workspace/gigacraft-smoke-go`.
- The canonical runtime secrets source remains `/Users/kozlov/Workspace/gigacraft/.env`.
- The harness must use separate worktrees for individual runs.
- `main` should remain nearly empty:
  - tracked harness artifacts only
  - no application implementation on `main`
- The user wants a persistent git repository rather than a fully disposable repo recreated every time.
- The first project under test should be a small Go CLI because Go provides fast `build` and `test` checks with a small dependency surface.
- The harness should treat observable evidence as the source of truth when checking stage routing and agent usage.
- If the current `qwen` runtime does not expose stable strong evidence for a given agent invocation, the harness should degrade gracefully instead of pretending certainty.

## 6. Design Options

### Option A: Keep using ad hoc disposable clones

Use temporary clones and shell commands directly from `gigacraft` as needed.

Pros:

- minimal upfront work
- no additional repository to maintain

Cons:

- poor repeatability
- no durable scenario catalog
- no standard place for scripts, assertions, or operating guidance
- hard to compare runs over time

### Option B: Put tracked test fixtures inside `gigacraft`

Store the smoke project and its scenarios inside the extension repository itself.

Pros:

- fewer repositories to manage
- all artifacts live close to the extension

Cons:

- mixes extension assets with harness assets
- risks distorting the runtime environment under test
- makes the main repository noisier

### Option C: Create a dedicated smoke-test repository with worktree-based runs

Create a separate persistent repository that stores scenario definitions and harness scripts, while each actual run happens in an isolated worktree with out-of-git run artifacts.

Pros:

- best isolation from the extension repo
- repeatable and versioned scenario definitions
- clear separation between tracked harness logic and untracked run artifacts
- flexible enough for both greenfield and incremental scenarios

Cons:

- introduces a second repository to maintain
- requires a small amount of harness plumbing up front

## 7. Recommended Design

Choose **Option C: dedicated smoke-test repository with worktree-based runs**.

### 7.1 Repository topology

Create a persistent repository at:

- `/Users/kozlov/Workspace/gigacraft-smoke-go`

Repository model:

- `main` is intentionally almost empty and stable
- tracked files on `main` hold harness logic, scenario definitions, and operator guidance
- real scenario executions happen in separate worktrees

Recommended tracked contents on `main`:

- `README.md`
- `.gitignore`
- `AGENTS.md`
- `scripts/`
- `scenarios/`

`main` should not contain the toy Go application itself.

### 7.2 Branch model

Use a small branch model:

- `main`
  - harness root only
  - no application implementation
- `fixture/todo-v1`
  - minimal working Go CLI baseline for the incremental scenario

The fixture branch exists only to serve as a stable starting point for “add feature” runs. It is not a general-purpose development branch.

### 7.3 Worktree model

Every scenario run gets its own dedicated worktree.

Recommended worktree root:

- `~/.config/superpowers/worktrees/gigacraft-smoke-go/`

Example branch names:

- `run/bootstrap/2026-03-30T20-15-00`
- `run/add-feature/2026-03-30T20-32-00`

Source branch mapping:

- bootstrap scenario -> start from `main`
- add-feature scenario -> start from `fixture/todo-v1`

### 7.4 Tracked scenario definitions

Store canonical scenario definitions inside the repository:

```text
gigacraft-smoke-go/
├── AGENTS.md
├── README.md
├── .gitignore
├── scripts/
│   ├── create-worktree.sh
│   ├── run-scenario.sh
│   ├── collect-evidence.sh
│   └── assert-run.sh
└── scenarios/
    ├── bootstrap-from-empty/
    │   ├── prompt.md
    │   ├── expected-outcomes.md
    │   └── assertions.sh
    └── add-feature/
        ├── prompt.md
        ├── expected-outcomes.md
        └── assertions.sh
```

Responsibility split:

- `AGENTS.md`
  - operational runbook for future agent sessions
- `README.md`
  - human-facing explanation of the harness
- `scripts/`
  - executable truth for setup, execution, and assertions
- `scenarios/`
  - versioned scenario content and expectations

### 7.5 Canonical scenarios

#### Scenario A: Bootstrap from Empty

Starting point:

- worktree from `main`
- no Go application yet
- the created `todo-list-cli` lives at the root of the worktree, not in a nested subdirectory

Task:

- ask `qwen` to create a minimal `todo-list-cli` through the full `gigacraft` workflow

Expected outcome:

- `go.mod`
- `main.go`
- at least one test file
- minimal CLI behavior such as `add` and `list`
- evidence of design, planning, implementation, review, and verification stages
- exact v1 CLI surface for the created project:
  - `todo-list-cli add "<text>"`
  - `todo-list-cli list`

#### Scenario B: Add Feature to Existing Todo CLI

Starting point:

- worktree from `fixture/todo-v1`
- minimal working CLI already exists

Task:

- ask `qwen` to evolve the CLI with one canonical bounded feature for v1:
  - mark a todo item complete

Expected outcome:

- bounded code changes on top of the fixture
- updated tests
- build/test still passing
- evidence of planning, implementation, review, and verification stages
- a stable v1 feature contract:
  - the command path is `todo-list-cli complete <id>`
  - `todo-list-cli list` reflects completion status for completed items
  - tests cover the new completion behavior

These two scenarios cover:

- greenfield work
- incremental change on existing code

That combination is enough for v1 without exploding the harness surface.

### 7.6 Run artifacts and evidence storage

Run artifacts should be stored **outside git**.

Recommended path:

- `~/.config/superpowers/runs/gigacraft-smoke-go/<run-id>/`

Example contents:

```text
~/.config/superpowers/runs/gigacraft-smoke-go/<run-id>/
├── qwen.stdout.txt
├── qwen.stream.jsonl
├── qwen.debug.txt
├── git-status.txt
├── git-log.txt
├── build.txt
├── test.txt
└── report.json
```

This keeps tracked scenario definitions clean while preserving enough evidence to audit a specific run later.

#### `report.json` v1 contract

Every run must produce exactly one machine-readable summary file named:

- `report.json`

Required top-level keys:

- `scenario_name`
- `run_id`
- `source_branch`
- `worktree_path`
- `artifacts_dir`
- `runtime_pass`
- `outcome_pass`
- `stage_routing_pass`
- `agent_usage_pass`
- `verification_pass`
- `overall_pass`
- `warnings`
- `evidence`

`warnings` format in v1:

- JSON array of strings

Required `evidence` keys:

- `qwen_stdout`
- `qwen_stream_jsonl`
- `qwen_debug`
- `git_status`
- `git_log`
- `build_output`
- `test_output`

Status values:

- for `runtime_pass`, `outcome_pass`, `verification_pass`, and `overall_pass`:
  - `pass` or `fail`
- for `stage_routing_pass` and `agent_usage_pass`:
  - `pass`, `warn`, or `fail`

### 7.7 `AGENTS.md` policy

Unlike the shipped `gigacraft` extension repository, this smoke repository should use a **tracked `AGENTS.md`**.

Its purpose is to help future agent sessions remember:

- where to create worktrees
- where to store run outputs
- how to load env from `/Users/kozlov/Workspace/gigacraft/.env`
- which scripts are the canonical entrypoints
- what counts as a passing run
- how to interpret routing and agent-evidence checks

The smoke repo is an internal harness repository, not a shipped extension, so tracked `AGENTS.md` is appropriate here.

### 7.8 Evidence model

Treat run validation as a multi-layer check rather than a single yes/no text assertion.

#### Outcome evidence

- expected files exist
- git diff/commits match the scenario
- `go build ./...` passes when applicable
- `go test ./...` passes

#### Stage-routing evidence

Look for evidence that the workflow moved through the expected `gigacraft` stages:

- `brainstorming`
- `writing-plans`
- `subagent-driven-development` or `executing-plans`
- `requesting-code-review`
- `verification-before-completion`

Sources:

- `qwen` stdout
- `stream-json`
- generated design/plan artifacts
- explicit stage selection text when present

Stage-routing status policy:

- `pass`
  - strong or medium evidence shows the expected stage sequence
- `warn`
  - observability is weak or partial, but there is no contradictory evidence and the scenario outcome remains consistent with the expected workflow
- `fail`
  - expected stage is skipped, contradicted, or replaced by an incompatible stage

#### Agent-usage evidence

The harness should attempt to validate the expected mapping:

- design stage -> `architect`
- planning stage -> `planner`
- implementation stage -> `implementer`
- review stage -> `reviewer`

Evidence strength levels:

- strong
  - direct runtime evidence of agent/tool invocation in `stream-json` or debug logs
- medium
  - explicit text output tying the stage to the correct agent role
- weak
  - only indirect inference from generated artifacts

Pass policy:

- prefer `strong` or `strong + medium`
- if runtime observability proves too weak, downgrade agent usage to warning instead of forcing false certainty

#### Preferred execution path for canonical runs

For v1 canonical scenario runs, the harness should prefer:

- `subagent-driven-development`

Reason:

- it gives the clearest expected path for observing explicit role usage across `implementer` and `reviewer`
- it aligns better with the user's requirement to validate agent usage at the right workflow points

Fallback:

- if the runtime environment or approval mode makes subagent execution impractical for a given automated run, the harness may use `executing-plans`, but that run should be marked as reduced-observability for agent checks

#### Debug-log parsing scope for v1

Keep v1 observability intentionally narrow.

Parse only:

- `qwen` stdout
- `stream-json` output when enabled
- the captured debug-log snapshot for the specific run

Look only for stable signals such as:

- loaded skill names
- explicit stage references
- direct tool or agent invocation markers when present

Do not attempt v1 parsing of:

- low-level token streams
- speculative intermediate reasoning
- fragile free-form heuristics that depend on wording alone

#### Verification integrity

The run is not complete merely because files changed.

The harness must confirm that:

- verification commands were actually run
- their outputs were captured
- any final completion claim is supported by fresh verification evidence

### 7.9 Pass/fail model

Each scenario should produce a structured result with at least:

- `runtime_pass`
- `outcome_pass`
- `stage_routing_pass`
- `agent_usage_pass`
- `verification_pass`
- `overall_pass`

If agent evidence is too weak to prove a required role invocation, the harness may mark:

- `agent_usage_pass = warn`

but should still fail the run if stage routing, outcome, or verification integrity do not hold.

#### Acceptance matrix for evidence thresholds

- `runtime_pass`
  - pass: `qwen` exits successfully without fatal runtime/tooling failure
  - fail: auth/tool/runtime failure aborts the run
- `outcome_pass`
  - pass: expected files exist and required `go build`/`go test` checks pass
  - fail: expected artifacts are missing or Go validation fails
- `stage_routing_pass`
  - pass: strong or medium evidence shows the expected stage sequence
  - warn: observability is partial, but there is no contradiction and the remaining evidence is workflow-consistent
  - fail: expected stage is skipped, contradicted, or replaced by an incompatible stage
- `agent_usage_pass`
  - pass: strong evidence, or strong + medium evidence, for the expected role mapping
  - warn: only medium evidence is available but there is no contradiction
  - fail: contradictory evidence or missing required role evidence in a run that was expected to expose it
- `verification_pass`
  - pass: real verification commands ran and their outputs were captured
  - fail: completion is claimed without fresh verification evidence
- `overall_pass`
  - pass: `runtime_pass`, `outcome_pass`, and `verification_pass` pass, and both `stage_routing_pass` and `agent_usage_pass` are either pass or warn
  - fail: any of those required gates fail

## 8. Impacted Areas

### New repository to create

- `/Users/kozlov/Workspace/gigacraft-smoke-go`

### Tracked assets expected in that repository

- `README.md`
- `.gitignore`
- `AGENTS.md`
- `scripts/*`
- `scenarios/*`

### Local runtime paths expected outside git

- `/Users/kozlov/Workspace/gigacraft/.env`
- `~/.config/superpowers/worktrees/gigacraft-smoke-go/`
- `~/.config/superpowers/runs/gigacraft-smoke-go/`

### Current repository documentation

- this design spec in the `gigacraft` repository

## 9. Risks

- Agent-usage observability may be weaker than desired in current `qwen` runtime outputs.
- If scenario prompts are too loose, the harness may measure model creativity instead of workflow correctness.
- If scenario prompts are too strict, the harness may become brittle and overfit to current wording.
- If `main` accidentally accumulates fixture code, the empty-bootstrap scenario will lose its value.
- If run artifacts are not clearly isolated from tracked files, the smoke repository will become noisy and harder to maintain.
- If fixture branch changes are not tightly controlled, the add-feature scenario will stop being stable over time.

## 10. Open Questions

There are no blocking open questions for the design itself.

Implementation-planning details still to resolve:

- the exact layout of helper scripts inside `scripts/`
- whether `warnings` in `report.json` should be flat strings or structured objects
- whether the harness should emit one human-readable markdown summary in addition to `report.json`
