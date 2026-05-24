---
name: af-dispatch-agents
description: Use when AgentFramework work has independent AF-scoped tasks that can be delegated to Codex subagents without overlapping write scope, shared unresolved decisions, or blocking the main critical path.
---

# AF Dispatch Agents

Coordinate AgentFramework subagent delegation. This is an AF infrastructure skill, not a generic delegation skill.

## Core Principle

Subagents should know AF vocabulary and constraints, but project-specific AF truth must be supplied in the dispatch prompt. Do not rely on a subagent to infer `XXXAgentFramework`, Module ownership, AF Element type, TDD order, Write Scope, Forbidden Shortcuts, or Verification Gate.

## Preconditions

- The current `XXXAgentFramework`, Directory And Naming Binding, ModuleMap, and relevant AF Feature Plan are known.
- Each delegated task has a concrete `Primary Module`, optional `Related Modules`, concrete `AF Element`, `AF Element Type`, `TDD Slice`, `BDD Scenario`, expected output, and Verification Gate.
- Delegated tasks do not modify the same files, schemas, public contracts, snapshots, migrations, generated artifacts, or mutable shared state.
- Requirements, public contracts, ownership, and write boundaries are already settled.
- The main agent can keep working on non-overlapping work while subagents run.
- The main agent remains responsible for integration, conflict checks, AF review, and final verification.

## AF Role Routing

| Role | Use For | Default Model / Effort |
|---|---|---|
| `requirements_analyst` | Requirement ambiguity, acceptance gaps, hidden constraints | `gpt-5.5 high` |
| `architect` | Module boundaries, interfaces, dependency direction, plan review | `gpt-5.5 xhigh` |
| `code_mapper` | Read-only file, call-chain, config, and data-flow mapping | `gpt-5.4 high` |
| `docs_researcher` | Official docs, local skill docs, API/version facts | `gpt-5.4 high` |
| `git_historian` | Commit history, old implementations, regression source | `gpt-5.4 high` |
| `test_designer` | BDD/AAA scenarios, edge coverage, regression risks | `gpt-5.5 high` |
| `mechanical_worker` | Small, explicit implementation within one clear scope | `gpt-5.4 high` |
| `integration_worker` | Multi-file implementation with fixed contracts | `gpt-5.5 high` |
| `refactor_worker` | Behavior-preserving structure, naming, extraction | `gpt-5.4 high` |
| `migration_worker` | Config, data shape, API, SDK, or schema migration | `gpt-5.5 high` |
| `reproducer` | Minimal reproduction and bug existence checks | `gpt-5.4 high` |
| `debugger` | Root cause for unclear state, race, or cross-layer bugs | `gpt-5.5 xhigh` |
| `test_triager` | Test output analysis and failure classification | `gpt-5.4 high` |
| `performance_profiler` | Hot paths, profiling evidence, performance risks | `gpt-5.5 high` |
| `reviewer` | Correctness, regression, AF boundary, and test gaps | `gpt-5.5 high` |
| `security_auditor` | Permissions, injection, secrets, unsafe external boundaries | `gpt-5.5 xhigh` |
| `verification_runner` | Running commands and reporting exact verification evidence | `gpt-5.4 high` |
| `docs_writer` | User/developer documentation from completed behavior | `gpt-5.4 high` |
| `release_scribe` | Changelog, release notes, migration notes | `gpt-5.4 high` |
| `handoff_writer` | AF continuation summaries for another session or agent | `gpt-5.4 high` |

## Do Not Dispatch When

- The task is small enough for the main agent and delegation adds coordination cost.
- AF ownership, public contracts, data shapes, or Write Scope are unsettled.
- Tasks touch the same files, shared mutable state, generated artifacts, migrations, snapshots, or external contracts.
- Subagents would need to coordinate design decisions with each other.
- The main agent would be blocked waiting for the delegated result before doing useful work.
- The task would let a subagent bypass AF planning, TDD RED/GREEN, AF review, or final verification.

## AF Dispatch Prompt Template

```md
You are working in a shared AgentFramework codebase. You are not alone; do not revert or overwrite edits outside your assigned scope.

Role:
- AF subagent role: <role>

Task:
- <specific task>

AF Context:
- Active framework artifact:
- Directory And Naming Binding:
- ModuleMap / ModulePlan:
- AF Feature Plan:
- Primary Module:
- Related Modules:
- AF Element:
- AF Element Type:
- TDD Slice:
- BDD Scenario:

Scope:
- Allowed files / modules:
- Forbidden files / modules:
- May edit files: yes/no
- Forbidden Shortcuts:
- ModulePlan dependency rules:

Verification Gate:
- Run:
- Expected result:
- Evidence required:

Integration Responsibility:
- Main agent will integrate, review, and verify. Do not make final completion claims.

Return:
- Summary
- AF coordinates used
- Files changed
- Commands run and results
- Evidence
- Assumptions
- Risks
- Recommended next step
```

## Integration

After subagents return:

1. Review summaries and diffs against the assigned AF coordinates.
2. Check for Write Scope, dependency, public contract, and file conflicts.
3. Integrate or reject changes locally.
4. Re-run the relevant Verification Gates.
5. Use `af-review` and `af-verify-completion`; subagent evidence does not replace either gate.
