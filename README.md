# gigacraft

`gigacraft` is a lightweight native Qwen extension for structured backend work. It turns the draft in `qwen_superpowers_agent_draft.md` into an installable prompt pack with:

- a staged workflow for spec, plan, implementation, review, and optional refactor
- focused subagents for each workflow stage
- thin slash-command entrypoints
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

Use the normal path for most backend work:

1. `/write-spec`
2. `/write-plan`
3. `/implement-plan`
4. `/review-changes`

This keeps design, planning, implementation, and review clearly separated.

## Advanced Workflow

Use the advanced path only when the work spans multiple logical chunks or needs tighter orchestration:

1. `/write-chunked-plan`
2. `/implement-chunked-plan`
3. `/review-changes`
4. `/refactor-scope` if a scoped structural follow-up is explicitly approved

## Repository Layout

```text
.
├── qwen-extension.json
├── QWEN.md
├── agents/
├── commands/
├── context/
├── plans/
└── docs/
```

### Key directories

- `agents/`: focused role prompts for architect, planner, implementer, reviewer, refactor, and orchestrator
- `commands/`: slash-command entrypoints that launch the workflow stages
- `context/`: reusable neutral backend rules plus Java, Go, testing, and service overlays
- `plans/`: example durable artifacts produced by the workflow
- `docs/superpowers/`: design and implementation planning documents for this repo itself

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
