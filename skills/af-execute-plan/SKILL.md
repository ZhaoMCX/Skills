---
name: af-execute-plan
description: Use when implementing an approved AF Feature Plan with TDD slices and AgentFramework ownership constraints.
---

# AF Execute Plan

Execute an approved AF Feature Plan without redesigning it.

## Preconditions

- The plan is approved, either as a saved plan file or as complete current plan text that the user approved in the conversation.
- The relevant `XXXAgentFramework` and ModulePlan are available.
- `TDD 执行切片`, `写入范围`, `禁止捷径`, and `验证 Gate` are clear.
- `子代理委派策略` is present, even if the decision is `不委派`.

## Subagent Delegation

Before implementation, read the plan's `子代理委派策略`.

- If the decision is `不委派` / `No delegation`, do not dispatch subagents for implementation work unless a new independent sidecar task appears and the main agent can state why it satisfies `dispatch-agents`.
- If the decision is `委派` / `Delegate`, dispatch the listed safe tasks before implementation using the general `dispatch-agents` skill. Skipping dispatch is allowed only when the subagent tool is unavailable or the listed task is discovered to violate dispatch safety; record the blocker before continuing.
- Dispatch only tasks whose AF Module / Elements, allowed write scope, forbidden scope, expected output, and verification Gate are explicit.
- Do not dispatch tasks with unresolved requirements, public contracts, data shapes, ownership, or shared write scope.
- Do not let subagents modify the same files, schemas, public contracts, generated artifacts, migrations, snapshots, or mutable shared state.
- The main agent must review subagent results, check write-scope conflicts, integrate or reject changes, run verification, and report final evidence.
- Subagent verification never replaces main-agent AF review or `af-verify-completion`.
- Do not silently perform delegated work in the main agent when the plan says `Delegate`; either launch the subagent task or record the concrete blocker that prevents launch.

## Execution Rules

For each TDD slice:

1. Write or update the planned test first.
2. Run the targeted verification and confirm the expected RED failure.
3. Implement the minimal GREEN behavior.
4. Run the targeted verification and confirm GREEN.
5. Refactor only within the slice boundary.
6. Re-run verification after refactor.

When a TDD slice is delegated, the subagent must own the full RED/GREEN/refactor loop for its assigned non-overlapping scope, and the main agent must re-run the relevant verification after integration.

## Constraints

- Do not skip RED. Production code before the planned failing test violates this workflow.
- If a planned test passes immediately, fix the test or reassess the slice before writing implementation.
- If RED fails for the wrong reason, fix the test setup until it fails for the expected reason.
- Do not add unplanned features.
- Do not move responsibilities across AF elements without updating the plan or asking.
- Do not violate ModulePlan dependencies.
- Do not use subagents to bypass AF ownership, TDD RED/GREEN, Write Scope, or Forbidden Shortcuts.
- Keep `Rules` free of platform, SDK, engine, browser, storage, network, database, and UI APIs.
- Keep business decisions out of `Surface` and `Adapter`.
- Surface/UI changes require key-path tests or explicit verification evidence when automation is not practical.

## Completion

After all slices are green, review any subagent outputs and diffs for scope conflicts, then use `af-review` for AF boundary review and `af-verify-completion` for final evidence.
