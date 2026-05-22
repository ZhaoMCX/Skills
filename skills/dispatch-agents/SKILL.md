---
name: dispatch-agents
description: Use when multiple independent tasks can be delegated to subagents without overlapping write scope, shared unresolved decisions, or blocking the main agent's immediate critical path.
---

# Dispatch Agents

Coordinate safe subagent delegation. This is a general collaboration skill, not tied to any project framework.

## Preconditions

- The task can be split into independent problem domains.
- Each delegated task has a clear owner, write scope, expected output, and verification command.
- Delegated tasks do not modify the same files, schemas, public contracts, or mutable shared state.
- The main agent can keep working on non-overlapping work while subagents run.
- The main agent remains responsible for integration, conflict checks, review, and final verification.

## Dispatch Rules

- Delegate sidecar work, not the immediate critical-path blocker.
- Give each subagent one focused task.
- State the write scope and forbidden areas explicitly.
- State whether the subagent may edit files or must only inspect.
- Tell subagents they are not alone in the codebase and must not revert or overwrite edits made by others.
- Require each subagent to report files changed, commands run, results, assumptions, and remaining risks.
- Close subagents once their result has been integrated or rejected.

## Do Not Dispatch When

- The work is small enough for one agent.
- Requirements, public contracts, data shapes, or ownership are still unsettled.
- Tasks touch the same files or shared mutable state.
- Subagents would need to coordinate with each other to make design decisions.
- The main agent would be blocked waiting for the delegated result before doing anything useful.

## Subagent Prompt Template

```md
You are working in a shared codebase. You are not alone; do not revert or overwrite edits outside your assigned scope.

Task:
- <specific task>

Scope:
- Allowed files / modules:
- Forbidden files / modules:
- May edit files: yes/no

Context:
- Relevant artifact, issue, plan, test, or error:

Verification:
- Run:
- Expected result:

Return:
- Summary
- Files changed
- Commands run and results
- Assumptions
- Remaining risks
```

## Integration

After subagents return:

1. Review summaries and diffs.
2. Check for write-scope conflicts.
3. Integrate or reject changes locally.
4. Run the relevant verification commands.
5. Report final evidence yourself.
