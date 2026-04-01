# Example Feature Plan

## Summary

Add structured request audit logging to a backend service without changing public API behavior.

## Reference

Approved design: `docs/superpowers/specs/2026-04-01-request-audit-logging-design.md`

## Frozen Implementation Decisions

| Decision | Selection |
|----------|-----------|
| Audit emission boundary | service layer, after successful request completion |
| Failure-path audit behavior | emit explicit failure event before returning error |
| Validation style | targeted RED/GREEN unit tests first, then one smoke check |

## Scope and Non-Goals

**In Scope:**
- Emit one audit event for successful request handling
- Emit one audit event for handled failure paths
- Document config defaults and rollout notes

**Non-Goals:**
- No new storage backend
- No UI changes
- No broader logging refactor

## Touched Files and Responsibilities

| File | Responsibility |
|------|----------------|
| `internal/service/request_handler.go` | Emit audit event after request handling |
| `internal/service/request_handler_test.go` | RED/GREEN unit coverage for success and failure paths |
| `docs/configuration.md` | Document config defaults |
| `docs/rollout.md` | Rollout and rollback notes |

## Milestones

### Milestone 1: Success-Path Audit Emission

**Goal:** emit a structured audit event when request handling succeeds.

**Definition of Done:**
- success-path unit test proves audit emission
- service emits exactly one success audit event with stable fields

**Validation Gate:**
```bash
go test ./internal/service -run 'TestHandleRequest_EmitsAuditEventOnSuccess$'
```

**Rollback Boundary:** revert service-layer audit emission without touching docs.

**Stop/Replan Rule:** stop if the service layer cannot access the audit sink without introducing a cross-package dependency that violates the approved design.

**Commit Checkpoint:** `feat: add success-path request audit logging`

### Milestone 2: Failure Path and Documentation

**Goal:** cover handled failure behavior and document rollout implications.

**Definition of Done:**
- failure-path unit test proves audit emission on handled errors
- config defaults and rollout notes are documented

**Validation Gate:**
```bash
go test ./internal/service -run 'TestHandleRequest_EmitsAuditEventOnHandledFailure$'
rg -n 'audit logging|audit sink|rollback' docs/configuration.md docs/rollout.md
```

**Rollback Boundary:** revert failure audit emission and docs together if rollout assumptions change.

**Stop/Replan Rule:** stop if failure handling paths are inconsistent enough that the design needs separate audit semantics per error class.

**Commit Checkpoint:** `feat: add failure-path audit logging and docs`

## Ordered Atomic Tasks

### Task 1.1: Emit success-path audit event

**Files:** `internal/service/request_handler.go`, `internal/service/request_handler_test.go`

**Outcome:** successful request handling emits one structured audit event with the required fields.

**Prerequisite:** `None`

**RED:** `go test ./internal/service -run 'TestHandleRequest_EmitsAuditEventOnSuccess$'` fails because no audit event is emitted on success.

**GREEN:** add the narrowest service-layer emission path needed to publish one success audit event after a successful handler return.

**Verification:** `go test ./internal/service -run 'TestHandleRequest_EmitsAuditEventOnSuccess$'`

### Task 2.1: Emit handled-failure audit event

**Files:** `internal/service/request_handler.go`, `internal/service/request_handler_test.go`

**Outcome:** handled failures emit one structured failure audit event before the error is returned.

**Prerequisite:** `Task 1.1`

**RED:** `go test ./internal/service -run 'TestHandleRequest_EmitsAuditEventOnHandledFailure$'` fails because handled errors do not emit an audit event.

**GREEN:** extend the same service-layer emission flow to publish one failure audit event for handled error paths without changing public response behavior.

**Verification:** `go test ./internal/service -run 'TestHandleRequest_EmitsAuditEventOnHandledFailure$'`

### Task 2.2: Document config defaults and rollout notes

**Files:** `docs/configuration.md`, `docs/rollout.md`

**Outcome:** operators can see the default audit-logging behavior and the rollback steps in one place.

**Prerequisite:** `Task 2.1`

**RED:** `N/A - no behavior change`; this task updates delivery documentation rather than runtime logic.

**GREEN:** add the minimum documentation describing default audit logging behavior, rollout assumptions, and rollback steps.

**Verification:** `rg -n 'audit logging|audit sink|rollback' docs/configuration.md docs/rollout.md`

## Validation Strategy

- Run the named RED check before each behavior-changing task.
- Re-run the task-level verification command after each GREEN change.
- Run `go test ./internal/service` before closing Milestone 2.
- Confirm docs mention both default behavior and rollback path before marking the plan complete.

## Rollback Notes

- Reverting Milestone 1 removes success-path audit emission only.
- Reverting Milestone 2 removes failure-path emission and the associated rollout/docs notes.
