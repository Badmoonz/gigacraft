# gigacraft

`gigacraft` is a lightweight native Qwen extension for structured backend work. It turns the draft in `qwen_superpowers_agent_draft.md` into an installable prompt pack with:

- a skills-first workflow for spec, plan, implementation, review, and verification
- focused subagents for each workflow stage
- supported manual fallback commands when explicit stage control is preferable
- neutral backend standards with Java and Go overlays

## Why This Repo Exists

This extension is intended for a personal `gigacraft` fork of Qwen Code. The goal is to keep the workflow disciplined without adding runtime services or MCP complexity in v1.

## Install

### Link from a local checkout

```bash
qwen extensions link /Users/kozlov/Workspace/gigacraft
```

### Install from a git repository

```bash
qwen extensions install <git-url>
```

### Inspect installed extensions

```bash
qwen extensions list
```

## Optional Helpers

You can use optional MCP helpers if you want stronger repository navigation or docs lookup:

- Serena or `code-index-mcp` for repository navigation
- Context7 for version-sensitive framework or library docs lookup

These are optional helpers, not prerequisites for using `gigacraft`.

## Default Workflow

Use the skills-first path for most backend work:

1. `using-gigacraft` routes to the right workflow stage
2. `brainstorming`
3. `writing-plans`
4. `subagent-driven-development` or `executing-plans`
5. `requesting-code-review`
6. `verification-before-completion`

This keeps design, planning, implementation, review, and verification clearly separated while making skills the default workflow surface.

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
- `plans/`: example durable artifacts produced by the workflow
- `docs/superpowers/`: design and implementation planning documents for this repo itself

## Maintainer Notes

If you are developing `gigacraft` itself, copy `AGENTS.example.md` to a local `AGENTS.md` and add `AGENTS.md` to `.git/info/exclude`. Keep maintainer-only guidance there; keep shipped extension behavior in the tracked prompt assets.

## Neutral Backend Default

The extension defaults to a neutral backend posture. Java- and Go-specific guidance is available as overlays instead of being hardcoded into the root prompt. That keeps the extension broadly useful across mixed backend codebases.

## Scope Of V1

- native Qwen extension
- markdown-first assets only
- no MCP servers
- no Gemini-specific manifest yet

## Future Ideas

- Gemini compatibility layer
- optional MCP integrations
- stronger Java-heavy or Go-heavy profile variants
- release automation once the prompt surface stabilizes
