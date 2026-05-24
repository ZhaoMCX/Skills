# Subagent Delegation Strategy

Every AF Feature Plan must decide whether subagents can help safely. This is planning only; do not dispatch subagents from Plan Mode.
Identify viable delegation candidates, then choose `Delegate` only when delegation materially reduces risk, ambiguity, verification burden, or wall-clock time without adding coordination overhead.

## Rules

- Use `af-dispatch-agents` during execution when delegation is chosen.
- Do not choose `No delegation` merely because the main agent can do the work. If a task is independent, non-overlapping, verified, not on the immediate critical path, and materially useful to delegate, choose `Delegate`.
- Delegate only independent sidecar work, not unresolved architecture, public contracts, data shapes, or immediate critical-path blockers.
- Each delegated task must have an AF subagent role, Primary Module, Related Modules when relevant, AF Element, AF Element Type, TDD Slice, BDD Scenario, allowed files/modules, forbidden files/modules, expected output, and Verification Gate.
- Delegated tasks must not modify the same files, schemas, contracts, snapshots, migrations, generated artifacts, or mutable shared state.
- The main agent remains responsible for integration, conflict checks, AF review, and final verification.
- If the work is small, tightly coupled, has unresolved ownership, shares write scope, blocks the main critical path, lacks a verification Gate, subagent capability is unavailable, or delegation overhead exceeds the benefit, choose `No delegation` and state the reason.

## Required Plan Section

```md
## 子代理委派策略

| 决策 | 理由 |
|---|---|
| 委派 / 不委派 | |

| AF 子代理角色 | 子代理任务 | Primary Module | Related Modules | AF Element | AF Element Type | TDD Slice | BDD Scenario | 允许写入范围 | 禁止范围 | 验证 Gate | Escalation Trigger | 集成责任 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
```

Use `N/A` for the task table when the decision is `No delegation`.
When the decision is `Delegate`, include every safe independent task that should be launched during execution. When the decision is `No delegation`, the reason must name the blocker or cost/benefit reason, not a vague preference.

## Good Delegation Candidates

- Independent test expansion for one Module after interfaces are fixed.
- Read-only investigation of unrelated candidate files or docs.
- Surface visual verification when implementation files are not shared.
- Adapter contract tests when Port shape is already decided.

## Do Not Delegate

- Feature planning decisions.
- TDD slice that owns the same files the main agent must edit now.
- Tasks requiring subagents to coordinate design decisions with each other.
- Changes that cross the same public contract, schema, migration, snapshot, or generated artifact.
