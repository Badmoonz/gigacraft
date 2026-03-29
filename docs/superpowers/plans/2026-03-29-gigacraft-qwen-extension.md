# Gigacraft Qwen Extension Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a lightweight, native Qwen extension repo named `gigacraft` from the approved design and the existing draft.

**Architecture:** The repo stays markdown-first and extension-native: `qwen-extension.json` declares the package, `QWEN.md` provides the global workflow contract, `agents/` carries focused role prompts, `commands/` provides slash-command entrypoints, and `context/` holds reusable backend guidance. Validation relies on local manifest checks plus `qwen extensions link` and `qwen extensions list`.

**Tech Stack:** Qwen Code extension manifest, Markdown command files, Markdown subagent files with YAML frontmatter, local CLI validation

---

## Assumptions

- License defaults to MIT for v1 unless the user later wants a different license.
- The repository remains extension-only in v1, with no MCP server or build pipeline.
- The advanced `orchestrator` and `refactor` flows are included but documented as optional.
- Validation may leave the extension linked locally after the run, which is acceptable for the intended `gigacraft` use case.

## Planned File Structure

### Root files

- Create: `qwen-extension.json`
  - Native Qwen extension manifest with `name`, `version`, `description`, and `contextFileName`.
- Create: `QWEN.md`
  - Global workflow contract and routing guidance for the extension.
- Create: `README.md`
  - Installation, linking, usage, layout, and future roadmap notes.
- Create: `LICENSE`
  - Repository license text.

### Agent files

- Create: `agents/architect.md`
- Create: `agents/planner.md`
- Create: `agents/implementer.md`
- Create: `agents/reviewer.md`
- Create: `agents/refactor.md`
- Create: `agents/orchestrator.md`
  - Each file is a Qwen subagent markdown file with YAML frontmatter and a focused system prompt.

### Command files

- Create: `commands/write-spec.md`
- Create: `commands/write-plan.md`
- Create: `commands/write-chunked-plan.md`
- Create: `commands/implement-plan.md`
- Create: `commands/implement-chunked-plan.md`
- Create: `commands/review-changes.md`
- Create: `commands/refactor-scope.md`
  - Each file is a Qwen slash command markdown file with optional description frontmatter and a prompt body.

### Shared context files

- Create: `context/backend-standards.md`
- Create: `context/java-standards.md`
- Create: `context/go-standards.md`
- Create: `context/testing-standards.md`
- Create: `context/service-checklist.md`
  - Shared overlays referenced by prompts and docs.

### Example artifact

- Create: `plans/0001-example-feature-plan.md`
  - Example user-facing plan artifact showing the intended workflow output shape.

## Validation Sequence

1. Structural validation
- `test -f qwen-extension.json`
- `test -f QWEN.md`
- `test -d agents`
- `test -d commands`
- `test -d context`

2. Manifest validation
- `python -m json.tool qwen-extension.json >/dev/null`

3. Extension validation
- `qwen extensions link /Users/kozlov/Workspace/gigacraft`
- `qwen extensions list`

4. Smoke inspection
- Confirm `gigacode` appears in linked extensions.
- Confirm command and agent markdown files are present on disk after linking.

## Task 1: Create The Native Qwen Extension Entry Surface

**Files:**
- Create: `qwen-extension.json`
- Create: `QWEN.md`
- Create: `README.md`
- Create: `LICENSE`

- [ ] **Step 1: Write the manifest**

```json
{
  "name": "gigacode",
  "version": "0.1.0",
  "description": "Structured backend workflow extension for Qwen Code and gigacode.",
  "contextFileName": "QWEN.md"
}
```

- [ ] **Step 2: Run manifest validation**

Run: `python -m json.tool qwen-extension.json >/dev/null`
Expected: command exits successfully with no output

- [ ] **Step 3: Write the global Qwen context file**

Include:
- staged workflow contract
- minimal-change and test-updating rules
- tool preference notes
- neutral backend default
- references to `context/` overlays rather than duplicating all policy inline

- [ ] **Step 4: Write the README**

Include:
- what `gigacode` is
- why it exists
- repo layout
- `qwen extensions link /Users/kozlov/Workspace/gigacraft`
- `qwen extensions install <git-url>`
- core workflow examples
- note that refactor and chunked execution are optional advanced modes

- [ ] **Step 5: Add the license file**

Use MIT text unless the user later requests a different license.

## Task 2: Add Shared Neutral Backend Context Overlays

**Files:**
- Create: `context/backend-standards.md`
- Create: `context/java-standards.md`
- Create: `context/go-standards.md`
- Create: `context/testing-standards.md`
- Create: `context/service-checklist.md`

- [ ] **Step 1: Write `context/backend-standards.md`**

Include:
- backward-compatible defaults
- minimal diffs
- explicitness over cleverness
- operational safety expectations
- small-first validation guidance

- [ ] **Step 2: Write language overlays**

Write:
- `context/java-standards.md`
- `context/go-standards.md`

Keep them specific enough to be useful, but clearly optional overlays rather than the repo default.

- [ ] **Step 3: Write cross-cutting testing guidance**

Write `context/testing-standards.md` with:
- unit vs integration guidance
- regression-test expectation
- behavior-oriented test philosophy

- [ ] **Step 4: Write merge-readiness checklist**

Write `context/service-checklist.md` with:
- API compatibility
- config/defaults
- migrations
- observability
- auth/security
- retry/idempotency
- timeout/cancellation
- rollout/rollback notes

- [ ] **Step 5: Verify files exist**

Run: `find context -maxdepth 1 -type f | sort`
Expected: five markdown files listed

## Task 3: Add Focused Subagent Prompts

**Files:**
- Create: `agents/architect.md`
- Create: `agents/planner.md`
- Create: `agents/implementer.md`
- Create: `agents/reviewer.md`
- Create: `agents/refactor.md`
- Create: `agents/orchestrator.md`

- [ ] **Step 1: Create frontmatter-based subagent files**

Each file must start with YAML frontmatter:

```md
---
name: architect
description: Use for writing a design plan/spec that defines what should be built before implementation planning starts.
---
```

Then include only that agent's system prompt body.

- [ ] **Step 2: Write the primary workflow agents**

Write:
- `agents/architect.md`
- `agents/planner.md`
- `agents/implementer.md`
- `agents/reviewer.md`

These should reflect the approved default path:
`spec -> plan -> implement -> review`

- [ ] **Step 3: Write the optional advanced agents**

Write:
- `agents/refactor.md`
- `agents/orchestrator.md`

These should be clearly scoped to advanced, non-default workflows.

- [ ] **Step 4: Keep prompts layered, not duplicated**

Ensure:
- `QWEN.md` holds global rules
- agent files hold role-specific behavior
- language-specific rules stay mostly in `context/`

- [ ] **Step 5: Smoke-check the agent directory**

Run: `find agents -maxdepth 1 -type f | sort`
Expected: six markdown files listed

## Task 4: Add Slash Command Entry Points

**Files:**
- Create: `commands/write-spec.md`
- Create: `commands/write-plan.md`
- Create: `commands/write-chunked-plan.md`
- Create: `commands/implement-plan.md`
- Create: `commands/implement-chunked-plan.md`
- Create: `commands/review-changes.md`
- Create: `commands/refactor-scope.md`

- [ ] **Step 1: Use Qwen markdown command format**

Each command file should use optional frontmatter only for description, for example:

```md
---
description: Write a design plan/spec before implementation planning starts.
---

Use the architect agent.
```

- [ ] **Step 2: Write the default-path commands**

Write:
- `commands/write-spec.md`
- `commands/write-plan.md`
- `commands/implement-plan.md`
- `commands/review-changes.md`

These should map directly to the default workflow and emphasize narrow scope.

- [ ] **Step 3: Write the advanced-path commands**

Write:
- `commands/write-chunked-plan.md`
- `commands/implement-chunked-plan.md`
- `commands/refactor-scope.md`

These should remain available without crowding the default README examples.

- [ ] **Step 4: Keep command bodies thin**

Ensure command bodies:
- name the agent to use
- define the goal
- give process notes
- avoid restating all global policy

- [ ] **Step 5: Smoke-check the command directory**

Run: `find commands -maxdepth 1 -type f | sort`
Expected: seven markdown files listed

## Task 5: Add Example Plan And User Docs

**Files:**
- Create: `plans/0001-example-feature-plan.md`
- Modify: `README.md`

- [ ] **Step 1: Create the example plan artifact**

Write `plans/0001-example-feature-plan.md` to show:
- problem summary
- scope
- tasks
- validation
- rollout notes

Keep it illustrative rather than tied to a real codebase.

- [ ] **Step 2: Finish README usage examples**

Add:
- example workflow from `/write-spec` to `/review-changes`
- optional chunked-flow example
- note about using neutral backend defaults with Java/Go overlays

- [ ] **Step 3: Run repository structure check**

Run:

```bash
find . -maxdepth 2 -type f | sort
```

Expected:
- root manifest and docs
- all agent files
- all command files
- all context files
- example plan

## Task 6: Validate As A Real Qwen Extension

**Files:**
- Modify if needed: `qwen-extension.json`
- Modify if needed: `QWEN.md`
- Modify if needed: any invalid agent or command markdown file

- [ ] **Step 1: Link the extension locally**

Run: `qwen extensions link /Users/kozlov/Workspace/gigacraft`
Expected: successful install/link message for `gigacode`

- [ ] **Step 2: Confirm it is visible to Qwen**

Run: `qwen extensions list`
Expected: output includes `gigacode`

- [ ] **Step 3: Fix any manifest or format issues**

If link or list exposes parse failures:
- correct manifest fields
- correct agent YAML frontmatter
- correct command markdown format

- [ ] **Step 4: Re-run validation**

Run:

```bash
python -m json.tool qwen-extension.json >/dev/null
qwen extensions list
```

Expected:
- manifest still parses
- `gigacode` still appears in the extension list

- [ ] **Step 5: Document remaining assumptions**

Note in the final report:
- license assumption
- no MCP support in v1
- Gemini support deferred
