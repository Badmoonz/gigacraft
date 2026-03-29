# Gigacraft Smoke Go Harness Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a dedicated git-based smoke-test repository at `/Users/kozlov/Workspace/gigacraft-smoke-go` that can run isolated end-to-end `gigacraft` scenarios against a tiny Go CLI through separate worktrees.

**Architecture:** The harness lives in its own persistent repository with a nearly empty `main`, a fixture branch `fixture/todo-v1`, tracked `scenarios/` and `scripts/`, and all concrete runs executed in external worktrees with evidence captured outside git. `qwen` is run in `yolo` mode with `gigacraft` enabled, and the harness validates outcomes, stage routing, agent usage evidence, and verification integrity through collected artifacts and a machine-readable `report.json`.

**Tech Stack:** Git, Bash, `qwen` CLI, Go, `python3` for JSON/report generation, external env loading from `/Users/kozlov/Workspace/gigacraft/.env`.

---

## Reference Spec

- `docs/superpowers/specs/2026-03-30-gigacraft-smoke-go-harness-design.md`

## Scope

- Create `/Users/kozlov/Workspace/gigacraft-smoke-go` as a persistent git repository.
- Keep `main` harness-only with tracked `README.md`, `.gitignore`, `AGENTS.md`, `scripts/`, and `scenarios/`.
- Implement harness scripts:
  - `create-worktree.sh`
  - `run-scenario.sh`
  - `collect-evidence.sh`
  - `assert-run.sh`
- Add two tracked scenarios:
  - `bootstrap-from-empty`
  - `add-feature`
- Create fixture branch `fixture/todo-v1` with a minimal working Go `todo-list-cli`.
- Make the harness produce `report.json` with the exact v1 contract from the spec.
- Validate at least one full bootstrap run and one full add-feature run.

## Non-Goals

- No integration into the `gigacraft` extension repository itself beyond this plan document.
- No storage of runtime logs or secrets in git.
- No extra scenarios beyond the two canonical v1 scenarios.
- No mandatory `refactor` or `orchestrator` coverage in the first harness version.
- No attempt to perfectly reconstruct internal model reasoning beyond observable runtime evidence.

## File Structure

### Create On `/Users/kozlov/Workspace/gigacraft-smoke-go` `main`

- `/Users/kozlov/Workspace/gigacraft-smoke-go/README.md`
- `/Users/kozlov/Workspace/gigacraft-smoke-go/.gitignore`
- `/Users/kozlov/Workspace/gigacraft-smoke-go/AGENTS.md`
- `/Users/kozlov/Workspace/gigacraft-smoke-go/scripts/create-worktree.sh`
- `/Users/kozlov/Workspace/gigacraft-smoke-go/scripts/run-scenario.sh`
- `/Users/kozlov/Workspace/gigacraft-smoke-go/scripts/collect-evidence.sh`
- `/Users/kozlov/Workspace/gigacraft-smoke-go/scripts/assert-run.sh`
- `/Users/kozlov/Workspace/gigacraft-smoke-go/scenarios/bootstrap-from-empty/prompt.md`
- `/Users/kozlov/Workspace/gigacraft-smoke-go/scenarios/bootstrap-from-empty/expected-outcomes.md`
- `/Users/kozlov/Workspace/gigacraft-smoke-go/scenarios/bootstrap-from-empty/assertions.sh`
- `/Users/kozlov/Workspace/gigacraft-smoke-go/scenarios/add-feature/prompt.md`
- `/Users/kozlov/Workspace/gigacraft-smoke-go/scenarios/add-feature/expected-outcomes.md`
- `/Users/kozlov/Workspace/gigacraft-smoke-go/scenarios/add-feature/assertions.sh`

### Create On `fixture/todo-v1`

- `/Users/kozlov/Workspace/gigacraft-smoke-go/go.mod`
- `/Users/kozlov/Workspace/gigacraft-smoke-go/main.go`
- `/Users/kozlov/Workspace/gigacraft-smoke-go/internal/todo/store.go`
- `/Users/kozlov/Workspace/gigacraft-smoke-go/internal/todo/store_test.go`

## Task 1: Initialize The Smoke Repository On `main`

**Files:**
- Create: `/Users/kozlov/Workspace/gigacraft-smoke-go/README.md`
- Create: `/Users/kozlov/Workspace/gigacraft-smoke-go/.gitignore`
- Create: `/Users/kozlov/Workspace/gigacraft-smoke-go/AGENTS.md`
- Create: `/Users/kozlov/Workspace/gigacraft-smoke-go/scripts/.gitkeep`
- Create: `/Users/kozlov/Workspace/gigacraft-smoke-go/scenarios/bootstrap-from-empty/.gitkeep`
- Create: `/Users/kozlov/Workspace/gigacraft-smoke-go/scenarios/add-feature/.gitkeep`

- [ ] **Step 1: Create the repository and verify the path is unused**

Run:

```bash
test ! -e /Users/kozlov/Workspace/gigacraft-smoke-go
mkdir -p /Users/kozlov/Workspace/gigacraft-smoke-go
cd /Users/kozlov/Workspace/gigacraft-smoke-go
git init -b main
git status --short --branch
```

Expected:

- the path did not already exist
- `git init` succeeds
- status shows `## main`

- [ ] **Step 2: Add the tracked repository basics**

Create `/Users/kozlov/Workspace/gigacraft-smoke-go/.gitignore`:

```gitignore
.DS_Store
.idea/
.vscode/
*.swp
*.tmp
```

Create `/Users/kozlov/Workspace/gigacraft-smoke-go/README.md`:

```md
# gigacraft-smoke-go

Persistent smoke-test harness for validating the `gigacraft` Qwen extension against a small Go repository.

## Branches

- `main`: harness-only root
- `fixture/todo-v1`: baseline Go CLI used for incremental scenario runs

## Scenarios

- `bootstrap-from-empty`
- `add-feature`

## Worktrees

Scenario runs must not execute in the main checkout.

Worktrees belong under:

- `~/.config/superpowers/worktrees/gigacraft-smoke-go/`

Run artifacts belong under:

- `~/.config/superpowers/runs/gigacraft-smoke-go/`
```

Create `/Users/kozlov/Workspace/gigacraft-smoke-go/AGENTS.md`:

```md
# AGENTS.md

## Purpose

This repository is a persistent smoke-test harness for validating the `gigacraft` extension on a disposable Go project.

## Repository Model

- `main` is intentionally almost empty.
- Scenario definitions live in `scenarios/`.
- Harness scripts live in `scripts/`.
- The evolutionary fixture lives on branch `fixture/todo-v1`.
- Do not develop product code directly on `main`.

## Worktree Rules

- Never run scenarios in the main checkout.
- Always create a dedicated worktree per run.
- Store worktrees under `~/.config/superpowers/worktrees/gigacraft-smoke-go/`.

## Environment Rules

- Load runtime secrets from `/Users/kozlov/Workspace/gigacraft/.env`.
- Do not copy secrets into this repository.
- Do not commit `.env` files or run artifacts.

## Scenario Entry Points

- Bootstrap scenario: `scenarios/bootstrap-from-empty/`
- Add-feature scenario: `scenarios/add-feature/`

## How To Run

- Create a worktree from the correct source branch.
- Run `scripts/run-scenario.sh <scenario-name>`.
- Save logs, stream-json output, debug logs, and validation reports outside git.

## Success Criteria

A scenario passes only if all of the following are true:

- `qwen` completes without fatal runtime error
- expected stage routing is observed
- expected files and commits are created
- Go build/test checks pass
- run assertions pass
- runtime evidence shows `gigacraft` skills/agents were used at the expected stages
```

- [ ] **Step 3: Create the tracked directory skeleton**

Run:

```bash
mkdir -p /Users/kozlov/Workspace/gigacraft-smoke-go/scripts
mkdir -p /Users/kozlov/Workspace/gigacraft-smoke-go/scenarios/bootstrap-from-empty
mkdir -p /Users/kozlov/Workspace/gigacraft-smoke-go/scenarios/add-feature
touch /Users/kozlov/Workspace/gigacraft-smoke-go/scripts/.gitkeep
touch /Users/kozlov/Workspace/gigacraft-smoke-go/scenarios/bootstrap-from-empty/.gitkeep
touch /Users/kozlov/Workspace/gigacraft-smoke-go/scenarios/add-feature/.gitkeep
find /Users/kozlov/Workspace/gigacraft-smoke-go -maxdepth 3 -type f | sort
```

Expected:

- the repository contains only harness root files and placeholder files

- [ ] **Step 4: Commit the initialized harness root**

Run:

```bash
cd /Users/kozlov/Workspace/gigacraft-smoke-go
git add README.md .gitignore AGENTS.md scripts/.gitkeep scenarios/bootstrap-from-empty/.gitkeep scenarios/add-feature/.gitkeep
git commit -m "chore: initialize smoke harness repo"
```

Expected:

- first commit on `main` succeeds

## Task 2: Implement The Core Harness Scripts On `main`

**Files:**
- Create: `/Users/kozlov/Workspace/gigacraft-smoke-go/scripts/create-worktree.sh`
- Create: `/Users/kozlov/Workspace/gigacraft-smoke-go/scripts/run-scenario.sh`
- Create: `/Users/kozlov/Workspace/gigacraft-smoke-go/scripts/collect-evidence.sh`
- Create: `/Users/kozlov/Workspace/gigacraft-smoke-go/scripts/assert-run.sh`

- [ ] **Step 1: Create the worktree helper**

Create `/Users/kozlov/Workspace/gigacraft-smoke-go/scripts/create-worktree.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

SCENARIO="${1:?scenario name required}"
RUN_ID="${2:-$(date -u +%Y-%m-%dT%H-%M-%SZ)}"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORKTREE_BASE="${WORKTREE_BASE:-$HOME/.config/superpowers/worktrees/gigacraft-smoke-go}"

case "$SCENARIO" in
  bootstrap-from-empty)
    SOURCE_BRANCH="main"
    BRANCH_NAME="run/bootstrap/${RUN_ID}"
    ;;
  add-feature)
    SOURCE_BRANCH="fixture/todo-v1"
    BRANCH_NAME="run/add-feature/${RUN_ID}"
    ;;
  *)
    echo "Unknown scenario: $SCENARIO" >&2
    exit 1
    ;;
esac

WORKTREE_PATH="${WORKTREE_BASE}/${BRANCH_NAME}"
mkdir -p "$(dirname "$WORKTREE_PATH")"
git -C "$REPO_ROOT" worktree add "$WORKTREE_PATH" -b "$BRANCH_NAME" "$SOURCE_BRANCH" >/dev/null

printf 'WORKTREE_PATH=%s\n' "$WORKTREE_PATH"
printf 'SOURCE_BRANCH=%s\n' "$SOURCE_BRANCH"
printf 'BRANCH_NAME=%s\n' "$BRANCH_NAME"
printf 'RUN_ID=%s\n' "$RUN_ID"
```

- [ ] **Step 2: Create the evidence collector**

Create `/Users/kozlov/Workspace/gigacraft-smoke-go/scripts/collect-evidence.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

SCENARIO="${1:?scenario required}"
RUN_ID="${2:?run id required}"
WORKTREE_PATH="${3:?worktree path required}"
ARTIFACTS_DIR="${4:?artifacts dir required}"
QWEN_EXIT_CODE="${5:?qwen exit code required}"
DEBUG_SNAPSHOT="${6:?debug snapshot path required}"

mkdir -p "$ARTIFACTS_DIR"
printf '%s\n' "$QWEN_EXIT_CODE" > "${ARTIFACTS_DIR}/qwen.exit.txt"

if [[ -f "$DEBUG_SNAPSHOT" ]]; then
  cp "$DEBUG_SNAPSHOT" "${ARTIFACTS_DIR}/qwen.debug.txt"
else
  : > "${ARTIFACTS_DIR}/qwen.debug.txt"
fi

git -C "$WORKTREE_PATH" status --short --branch > "${ARTIFACTS_DIR}/git-status.txt"
git -C "$WORKTREE_PATH" log --oneline --decorate -20 > "${ARTIFACTS_DIR}/git-log.txt"

if [[ -f "${WORKTREE_PATH}/go.mod" ]]; then
  (
    cd "$WORKTREE_PATH"
    go build ./...
  ) > "${ARTIFACTS_DIR}/build.txt" 2>&1 || true
  (
    cd "$WORKTREE_PATH"
    go test ./...
  ) > "${ARTIFACTS_DIR}/test.txt" 2>&1 || true
else
  printf 'go.mod not found\n' > "${ARTIFACTS_DIR}/build.txt"
  printf 'go.mod not found\n' > "${ARTIFACTS_DIR}/test.txt"
fi

python3 - "${ARTIFACTS_DIR}/qwen.stream.jsonl" "${ARTIFACTS_DIR}/qwen.stdout.txt" <<'PY'
import json
import sys
from pathlib import Path

src = Path(sys.argv[1])
dst = Path(sys.argv[2])
chunks = []

def walk(value):
    if isinstance(value, dict):
        for key, val in value.items():
            if key in {"text", "content", "message"} and isinstance(val, str):
                chunks.append(val)
            else:
                walk(val)
    elif isinstance(value, list):
        for item in value:
            walk(item)

if src.exists():
    for raw in src.read_text().splitlines():
        raw = raw.strip()
        if not raw:
            continue
        try:
            obj = json.loads(raw)
        except json.JSONDecodeError:
            continue
        walk(obj)

clean = []
for item in chunks:
    item = item.strip()
    if item and (not clean or clean[-1] != item):
        clean.append(item)

dst.write_text("\n\n".join(clean) + ("\n" if clean else ""))
PY
```

- [ ] **Step 3: Create the assertion/report script**

Create `/Users/kozlov/Workspace/gigacraft-smoke-go/scripts/assert-run.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

SCENARIO="${1:?scenario required}"
RUN_ID="${2:?run id required}"
SOURCE_BRANCH="${3:?source branch required}"
WORKTREE_PATH="${4:?worktree path required}"
ARTIFACTS_DIR="${5:?artifacts dir required}"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "${REPO_ROOT}/scenarios/${SCENARIO}/assertions.sh"

QWEN_EXIT_CODE="$(cat "${ARTIFACTS_DIR}/qwen.exit.txt")"
RUNTIME_PASS="pass"
OUTCOME_PASS="pass"
STAGE_ROUTING_PASS="pass"
AGENT_USAGE_PASS="pass"
VERIFICATION_PASS="pass"
OVERALL_PASS="pass"
WARNINGS=()

if [[ "$QWEN_EXIT_CODE" != "0" ]]; then
  RUNTIME_PASS="fail"
fi

if ! assert_scenario_outcome "$WORKTREE_PATH"; then
  OUTCOME_PASS="fail"
fi

if ! grep -q '^ok' "${ARTIFACTS_DIR}/test.txt"; then
  VERIFICATION_PASS="fail"
fi

for stage in "${EXPECTED_STAGES[@]}"; do
  if ! rg -qi --fixed-strings "$stage" \
    "${ARTIFACTS_DIR}/qwen.stdout.txt" \
    "${ARTIFACTS_DIR}/qwen.stream.jsonl" \
    "${ARTIFACTS_DIR}/qwen.debug.txt"; then
    STAGE_ROUTING_PASS="warn"
    WARNINGS+=("Missing strong stage evidence for ${stage}")
  fi
done

for role in "${EXPECTED_AGENTS[@]}"; do
  if ! rg -qi --fixed-strings "$role" \
    "${ARTIFACTS_DIR}/qwen.stdout.txt" \
    "${ARTIFACTS_DIR}/qwen.stream.jsonl" \
    "${ARTIFACTS_DIR}/qwen.debug.txt"; then
    AGENT_USAGE_PASS="warn"
    WARNINGS+=("Missing strong agent evidence for ${role}")
  fi
done

if [[ "$STAGE_ROUTING_PASS" == "warn" ]] && [[ "$OUTCOME_PASS" == "fail" ]]; then
  STAGE_ROUTING_PASS="fail"
fi

if [[ "$RUNTIME_PASS" == "fail" || "$OUTCOME_PASS" == "fail" || "$VERIFICATION_PASS" == "fail" || "$STAGE_ROUTING_PASS" == "fail" || "$AGENT_USAGE_PASS" == "fail" ]]; then
  OVERALL_PASS="fail"
fi

python3 - "${ARTIFACTS_DIR}/report.json" <<'PY'
import json
import os
import sys

report_path = sys.argv[1]
warnings = os.environ.get("WARNINGS_JSON", "[]")
data = {
    "scenario_name": os.environ["SCENARIO"],
    "run_id": os.environ["RUN_ID"],
    "source_branch": os.environ["SOURCE_BRANCH"],
    "worktree_path": os.environ["WORKTREE_PATH"],
    "artifacts_dir": os.environ["ARTIFACTS_DIR"],
    "runtime_pass": os.environ["RUNTIME_PASS"],
    "outcome_pass": os.environ["OUTCOME_PASS"],
    "stage_routing_pass": os.environ["STAGE_ROUTING_PASS"],
    "agent_usage_pass": os.environ["AGENT_USAGE_PASS"],
    "verification_pass": os.environ["VERIFICATION_PASS"],
    "overall_pass": os.environ["OVERALL_PASS"],
    "warnings": json.loads(warnings),
    "evidence": {
        "qwen_stdout": os.path.join(os.environ["ARTIFACTS_DIR"], "qwen.stdout.txt"),
        "qwen_stream_jsonl": os.path.join(os.environ["ARTIFACTS_DIR"], "qwen.stream.jsonl"),
        "qwen_debug": os.path.join(os.environ["ARTIFACTS_DIR"], "qwen.debug.txt"),
        "git_status": os.path.join(os.environ["ARTIFACTS_DIR"], "git-status.txt"),
        "git_log": os.path.join(os.environ["ARTIFACTS_DIR"], "git-log.txt"),
        "build_output": os.path.join(os.environ["ARTIFACTS_DIR"], "build.txt"),
        "test_output": os.path.join(os.environ["ARTIFACTS_DIR"], "test.txt"),
    },
}
with open(report_path, "w", encoding="utf-8") as fh:
    json.dump(data, fh, indent=2)
    fh.write("\n")
PY

if [[ "$OVERALL_PASS" == "fail" ]]; then
  exit 1
fi
```

- [ ] **Step 4: Create the scenario runner**

Create `/Users/kozlov/Workspace/gigacraft-smoke-go/scripts/run-scenario.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

SCENARIO="${1:?scenario name required}"
RUN_ID="${2:-$(date -u +%Y-%m-%dT%H-%M-%SZ)}"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${GIGACRAFT_ENV_FILE:-/Users/kozlov/Workspace/gigacraft/.env}"
RUNS_BASE="${RUNS_BASE:-$HOME/.config/superpowers/runs/gigacraft-smoke-go}"
DEBUG_DIR="${HOME}/.qwen/debug"
ARTIFACTS_DIR="${RUNS_BASE}/${RUN_ID}"
PROMPT_FILE="${REPO_ROOT}/scenarios/${SCENARIO}/prompt.md"

mkdir -p "$ARTIFACTS_DIR"

BEFORE_DEBUG="$(mktemp)"
AFTER_DEBUG="$(mktemp)"
ls -1 "$DEBUG_DIR" 2>/dev/null | sort > "$BEFORE_DEBUG" || true

eval "$("${REPO_ROOT}/scripts/create-worktree.sh" "$SCENARIO" "$RUN_ID")"

PROMPT="$(cat "$PROMPT_FILE")"

set +e
(
  cd "$WORKTREE_PATH"
  set -a
  source "$ENV_FILE" >/dev/null 2>&1
  set +a
  qwen -y -d --extensions gigacraft --output-format stream-json "$PROMPT"
) > "${ARTIFACTS_DIR}/qwen.stream.jsonl" 2> "${ARTIFACTS_DIR}/qwen.stderr.txt"
QWEN_EXIT_CODE="$?"
set -e

ls -1 "$DEBUG_DIR" 2>/dev/null | sort > "$AFTER_DEBUG" || true
NEW_DEBUG_FILE="$(comm -13 "$BEFORE_DEBUG" "$AFTER_DEBUG" | tail -n1 || true)"
if [[ -n "$NEW_DEBUG_FILE" ]]; then
  DEBUG_SNAPSHOT="${DEBUG_DIR}/${NEW_DEBUG_FILE}"
else
  DEBUG_SNAPSHOT="/dev/null"
fi

"${REPO_ROOT}/scripts/collect-evidence.sh" "$SCENARIO" "$RUN_ID" "$WORKTREE_PATH" "$ARTIFACTS_DIR" "$QWEN_EXIT_CODE" "$DEBUG_SNAPSHOT"

export SCENARIO RUN_ID SOURCE_BRANCH WORKTREE_PATH ARTIFACTS_DIR
export RUNTIME_PASS="pass"
export OUTCOME_PASS="pass"
export STAGE_ROUTING_PASS="pass"
export AGENT_USAGE_PASS="pass"
export VERIFICATION_PASS="pass"
export OVERALL_PASS="pass"
export WARNINGS_JSON="[]"

"${REPO_ROOT}/scripts/assert-run.sh" "$SCENARIO" "$RUN_ID" "$SOURCE_BRANCH" "$WORKTREE_PATH" "$ARTIFACTS_DIR"
printf '%s\n' "${ARTIFACTS_DIR}/report.json"
```

- [ ] **Step 5: Make scripts executable, lint shell syntax, and commit**

Run:

```bash
cd /Users/kozlov/Workspace/gigacraft-smoke-go
chmod +x scripts/*.sh
bash -n scripts/*.sh
git add scripts
git commit -m "feat: add smoke harness scripts"
```

Expected:

- shell syntax check passes
- commit succeeds on `main`

## Task 3: Add The Bootstrap Scenario Definitions On `main`

**Files:**
- Create: `/Users/kozlov/Workspace/gigacraft-smoke-go/scenarios/bootstrap-from-empty/prompt.md`
- Create: `/Users/kozlov/Workspace/gigacraft-smoke-go/scenarios/bootstrap-from-empty/expected-outcomes.md`
- Create: `/Users/kozlov/Workspace/gigacraft-smoke-go/scenarios/bootstrap-from-empty/assertions.sh`

- [ ] **Step 1: Write the full-cycle prompt**

Create `/Users/kozlov/Workspace/gigacraft-smoke-go/scenarios/bootstrap-from-empty/prompt.md`:

```md
Use the `gigacraft` workflow end to end in this repository.

You already have approval to continue through intermediate design and planning gates without asking for additional confirmation, as long as you stay within this prompt.

Build a minimal Go CLI in the repository root named `todo-list-cli`.

Requirements:

- keep the project at the repository root, not in a nested subdirectory
- implement `todo-list-cli add "<text>"`
- implement `todo-list-cli list`
- add tests
- use the full workflow: design/spec, implementation plan, implementation, review, verification
- prefer `subagent-driven-development` for execution when possible
- commit meaningful checkpoints when appropriate
```

- [ ] **Step 2: Write the human-readable expected outcomes**

Create `/Users/kozlov/Workspace/gigacraft-smoke-go/scenarios/bootstrap-from-empty/expected-outcomes.md`:

```md
# Expected Outcomes

- `go.mod` exists at repository root
- `main.go` exists at repository root
- at least one `*_test.go` file exists
- CLI supports:
  - `todo-list-cli add "<text>"`
  - `todo-list-cli list`
- `docs/superpowers/specs/` contains at least one spec artifact
- `docs/superpowers/plans/` contains at least one implementation plan artifact
- `go build ./...` succeeds
- `go test ./...` succeeds
```

- [ ] **Step 3: Write the scenario assertions**

Create `/Users/kozlov/Workspace/gigacraft-smoke-go/scenarios/bootstrap-from-empty/assertions.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

EXPECTED_STAGES=(
  brainstorming
  writing-plans
  subagent-driven-development
  requesting-code-review
  verification-before-completion
)

EXPECTED_AGENTS=(
  architect
  planner
  implementer
  reviewer
)

assert_scenario_outcome() {
  local worktree="$1"

  test -f "${worktree}/go.mod"
  test -f "${worktree}/main.go"
  find "${worktree}" -name '*_test.go' | grep -q .
  test -d "${worktree}/docs/superpowers/specs"
  test -d "${worktree}/docs/superpowers/plans"
  rg -q 'add' "${worktree}/main.go" "${worktree}/internal"
  rg -q 'list' "${worktree}/main.go" "${worktree}/internal"
}
```

- [ ] **Step 4: Validate and commit the bootstrap scenario**

Run:

```bash
cd /Users/kozlov/Workspace/gigacraft-smoke-go
chmod +x scenarios/bootstrap-from-empty/assertions.sh
bash -n scenarios/bootstrap-from-empty/assertions.sh
git add scenarios/bootstrap-from-empty
git commit -m "feat: add bootstrap smoke scenario"
```

Expected:

- syntax check passes
- commit succeeds on `main`

## Task 4: Create The `fixture/todo-v1` Branch With A Minimal Go CLI

**Files on `fixture/todo-v1`:**
- Create: `/Users/kozlov/Workspace/gigacraft-smoke-go/go.mod`
- Create: `/Users/kozlov/Workspace/gigacraft-smoke-go/main.go`
- Create: `/Users/kozlov/Workspace/gigacraft-smoke-go/internal/todo/store.go`
- Create: `/Users/kozlov/Workspace/gigacraft-smoke-go/internal/todo/store_test.go`

- [ ] **Step 1: Create the fixture branch from `main`**

Run:

```bash
cd /Users/kozlov/Workspace/gigacraft-smoke-go
git checkout -b fixture/todo-v1
git status --short --branch
```

Expected:

- branch switches to `fixture/todo-v1`

- [ ] **Step 2: Add the minimal Go module and CLI**

Create `/Users/kozlov/Workspace/gigacraft-smoke-go/go.mod`:

```go
module todo-list-cli

go 1.22
```

Create `/Users/kozlov/Workspace/gigacraft-smoke-go/main.go`:

```go
package main

import (
	"fmt"
	"os"

	"todo-list-cli/internal/todo"
)

func main() {
	store := todo.NewStore("todos.json")

	if len(os.Args) < 2 {
		fmt.Println("usage: todo-list-cli <add|list>")
		os.Exit(1)
	}

	switch os.Args[1] {
	case "add":
		if len(os.Args) < 3 {
			fmt.Println("usage: todo-list-cli add <text>")
			os.Exit(1)
		}
		id, err := store.Add(os.Args[2])
		if err != nil {
			fmt.Println(err)
			os.Exit(1)
		}
		fmt.Printf("added %d\n", id)
	case "list":
		items, err := store.List()
		if err != nil {
			fmt.Println(err)
			os.Exit(1)
		}
		for _, item := range items {
			fmt.Printf("%d %s\n", item.ID, item.Text)
		}
	default:
		fmt.Printf("unknown command: %s\n", os.Args[1])
		os.Exit(1)
	}
}
```

- [ ] **Step 3: Add the store implementation and tests**

Create `/Users/kozlov/Workspace/gigacraft-smoke-go/internal/todo/store.go`:

```go
package todo

import (
	"encoding/json"
	"os"
)

type Item struct {
	ID        int    `json:"id"`
	Text      string `json:"text"`
	Completed bool   `json:"completed"`
}

type Store struct {
	path string
}

func NewStore(path string) *Store {
	return &Store{path: path}
}

func (s *Store) List() ([]Item, error) {
	data, err := os.ReadFile(s.path)
	if err != nil {
		if os.IsNotExist(err) {
			return []Item{}, nil
		}
		return nil, err
	}

	var items []Item
	if len(data) == 0 {
		return []Item{}, nil
	}
	if err := json.Unmarshal(data, &items); err != nil {
		return nil, err
	}
	return items, nil
}

func (s *Store) Add(text string) (int, error) {
	items, err := s.List()
	if err != nil {
		return 0, err
	}
	id := len(items) + 1
	items = append(items, Item{ID: id, Text: text})
	if err := s.write(items); err != nil {
		return 0, err
	}
	return id, nil
}

func (s *Store) write(items []Item) error {
	data, err := json.MarshalIndent(items, "", "  ")
	if err != nil {
		return err
	}
	return os.WriteFile(s.path, data, 0o644)
}
```

Create `/Users/kozlov/Workspace/gigacraft-smoke-go/internal/todo/store_test.go`:

```go
package todo

import (
	"path/filepath"
	"testing"
)

func TestAddAndList(t *testing.T) {
	store := NewStore(filepath.Join(t.TempDir(), "todos.json"))

	id, err := store.Add("first task")
	if err != nil {
		t.Fatalf("Add() error = %v", err)
	}
	if id != 1 {
		t.Fatalf("Add() id = %d, want 1", id)
	}

	items, err := store.List()
	if err != nil {
		t.Fatalf("List() error = %v", err)
	}
	if len(items) != 1 {
		t.Fatalf("List() len = %d, want 1", len(items))
	}
	if items[0].Text != "first task" {
		t.Fatalf("List()[0].Text = %q, want %q", items[0].Text, "first task")
	}
	if items[0].Completed {
		t.Fatalf("List()[0].Completed = true, want false")
	}
}
```

- [ ] **Step 4: Validate the fixture and commit it**

Run:

```bash
cd /Users/kozlov/Workspace/gigacraft-smoke-go
go build ./...
go test ./...
git add go.mod main.go internal/todo/store.go internal/todo/store_test.go
git commit -m "feat: add todo cli fixture"
git checkout main
```

Expected:

- `go build` passes
- `go test` passes
- fixture commit succeeds
- working branch returns to `main`

## Task 5: Add The Incremental Scenario And Final Harness Validation On `main`

**Files:**
- Create: `/Users/kozlov/Workspace/gigacraft-smoke-go/scenarios/add-feature/prompt.md`
- Create: `/Users/kozlov/Workspace/gigacraft-smoke-go/scenarios/add-feature/expected-outcomes.md`
- Create: `/Users/kozlov/Workspace/gigacraft-smoke-go/scenarios/add-feature/assertions.sh`
- Modify: `/Users/kozlov/Workspace/gigacraft-smoke-go/scripts/assert-run.sh`

- [ ] **Step 1: Add the add-feature scenario files**

Create `/Users/kozlov/Workspace/gigacraft-smoke-go/scenarios/add-feature/prompt.md`:

```md
Use the `gigacraft` workflow end to end in this repository.

You already have approval to continue through intermediate design and planning gates without asking for additional confirmation, as long as you stay within this prompt.

The repository already contains a minimal Go CLI named `todo-list-cli`.

Extend it with one bounded feature:

- implement `todo-list-cli complete <id>`
- update `todo-list-cli list` so completed items show their completion state
- add or update tests
- use the full workflow: design/spec, implementation plan, implementation, review, verification
- prefer `subagent-driven-development` for execution when possible
- commit meaningful checkpoints when appropriate
```

Create `/Users/kozlov/Workspace/gigacraft-smoke-go/scenarios/add-feature/expected-outcomes.md`:

```md
# Expected Outcomes

- fixture files remain present
- code includes a `complete` command path
- listing output reflects completion status
- tests cover completion behavior
- `docs/superpowers/specs/` contains at least one spec artifact
- `docs/superpowers/plans/` contains at least one implementation plan artifact
- `go build ./...` succeeds
- `go test ./...` succeeds
```

Create `/Users/kozlov/Workspace/gigacraft-smoke-go/scenarios/add-feature/assertions.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

EXPECTED_STAGES=(
  brainstorming
  writing-plans
  subagent-driven-development
  requesting-code-review
  verification-before-completion
)

EXPECTED_AGENTS=(
  architect
  planner
  implementer
  reviewer
)

assert_scenario_outcome() {
  local worktree="$1"

  test -f "${worktree}/go.mod"
  test -f "${worktree}/main.go"
  test -f "${worktree}/internal/todo/store.go"
  test -f "${worktree}/internal/todo/store_test.go"
  test -d "${worktree}/docs/superpowers/specs"
  test -d "${worktree}/docs/superpowers/plans"
  rg -q 'complete' "${worktree}/main.go" "${worktree}/internal/todo/store.go" "${worktree}/internal/todo/store_test.go"
  rg -q 'Completed' "${worktree}/main.go" "${worktree}/internal/todo/store.go" "${worktree}/internal/todo/store_test.go"
}
```

- [ ] **Step 2: Tighten `assert-run.sh` so warnings serialize correctly and stage warnings degrade gracefully**

Update `/Users/kozlov/Workspace/gigacraft-smoke-go/scripts/assert-run.sh` by inserting this line just before the `python3` block:

```bash
export WARNINGS_JSON="$(printf '%s\n' "${WARNINGS[@]}" | python3 -c 'import json, sys; print(json.dumps([line.strip() for line in sys.stdin if line.strip()]))')"
```

This replaces the placeholder `WARNINGS_JSON="[]"` usage with a real serialized array while keeping `stage_routing_pass=warn` from automatically failing `overall_pass`.

- [ ] **Step 3: Validate scenario files and commit the main-branch harness**

Run:

```bash
cd /Users/kozlov/Workspace/gigacraft-smoke-go
chmod +x scenarios/add-feature/assertions.sh
bash -n scenarios/add-feature/assertions.sh scripts/assert-run.sh
git add scenarios/add-feature scripts/assert-run.sh
git commit -m "feat: add incremental smoke scenario"
```

Expected:

- syntax checks pass
- commit succeeds on `main`

- [ ] **Step 4: Run the bootstrap scenario end to end and inspect the report**

Run:

```bash
cd /Users/kozlov/Workspace/gigacraft-smoke-go
BOOTSTRAP_REPORT="$(scripts/run-scenario.sh bootstrap-from-empty)"
python3 - "$BOOTSTRAP_REPORT" <<'PY'
import json, sys
report = json.load(open(sys.argv[1]))
assert report["overall_pass"] == "pass", report
PY
```

Expected:

- the script creates an external worktree
- `report.json` is written under `~/.config/superpowers/runs/gigacraft-smoke-go/<run-id>/`
- `overall_pass` is `pass`

- [ ] **Step 5: Run the add-feature scenario end to end and inspect the report**

Run:

```bash
cd /Users/kozlov/Workspace/gigacraft-smoke-go
ADD_FEATURE_REPORT="$(scripts/run-scenario.sh add-feature)"
python3 - "$ADD_FEATURE_REPORT" <<'PY'
import json, sys
report = json.load(open(sys.argv[1]))
assert report["overall_pass"] == "pass", report
PY
```

Expected:

- the script creates a worktree from `fixture/todo-v1`
- the run produces a valid report
- `overall_pass` is `pass`

## Test Changes

- Harness shell validation:
  - `bash -n scripts/*.sh`
  - `bash -n scenarios/*/assertions.sh`
- Fixture Go validation:
  - `go build ./...`
  - `go test ./...`
- End-to-end harness validation:
  - `scripts/run-scenario.sh bootstrap-from-empty`
  - `scripts/run-scenario.sh add-feature`
- Report validation:
  - `python3` checks that `report.json` has `overall_pass == "pass"`

## Migration And Compatibility Notes

- The smoke repository loads runtime auth from `/Users/kozlov/Workspace/gigacraft/.env` but never stores secrets locally.
- All scenario runs happen in worktrees under `~/.config/superpowers/worktrees/gigacraft-smoke-go/`.
- All run outputs stay outside git under `~/.config/superpowers/runs/gigacraft-smoke-go/`.
- `subagent-driven-development` is the preferred execution path for canonical runs, but the harness tolerates `executing-plans` as reduced-observability fallback when runtime evidence is weaker.
- `warnings` in `report.json` are a flat JSON array of strings in v1.
- The bootstrap scenario creates `todo-list-cli` at the worktree root; no nested project directory is allowed.

## Validation Sequence

1. Validate harness shell scripts:

```bash
cd /Users/kozlov/Workspace/gigacraft-smoke-go
bash -n scripts/*.sh
```

Expected:

- no shell syntax errors

2. Validate fixture branch:

```bash
cd /Users/kozlov/Workspace/gigacraft-smoke-go
git checkout fixture/todo-v1
go build ./...
go test ./...
git checkout main
```

Expected:

- fixture compiles and tests pass

3. Validate scenario assertions:

```bash
cd /Users/kozlov/Workspace/gigacraft-smoke-go
bash -n scenarios/bootstrap-from-empty/assertions.sh
bash -n scenarios/add-feature/assertions.sh
```

Expected:

- both assertion scripts parse cleanly

4. Run the bootstrap scenario:

```bash
cd /Users/kozlov/Workspace/gigacraft-smoke-go
scripts/run-scenario.sh bootstrap-from-empty
```

Expected:

- produces a report path on stdout
- writes all required evidence files
- final report indicates pass

5. Run the add-feature scenario:

```bash
cd /Users/kozlov/Workspace/gigacraft-smoke-go
scripts/run-scenario.sh add-feature
```

Expected:

- produces a report path on stdout
- writes all required evidence files
- final report indicates pass

## Risks And Unknowns

- `stream-json` parsing may need one adjustment once real payloads are inspected, even though the v1 parser is intentionally conservative.
- Debug-log naming under `~/.qwen/debug` may require a small tweak if concurrent `qwen` runs happen on the same machine.
- End-to-end runs may expose that some `gigacraft` approval-gate prompts need scenario wording adjustments for noninteractive execution.
- If `qwen` emits only weak agent evidence on some runs, `agent_usage_pass` may degrade to `warn`, which is acceptable in v1 but should still be monitored.
