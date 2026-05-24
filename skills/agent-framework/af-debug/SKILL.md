---
name: af-debug
description: Use when investigating, reproducing, or fixing a bug, regression, flaky behavior, failing test, broken route, broken game behavior, or unexpected state in an AgentFramework project.
---

# AF Debug

Debug through reproduction, AF ownership, root cause, regression test, fix, and verification.

## Workflow

1. Reproduce the problem with the smallest reliable command, route, scene, input, or test.
2. Identify the affected Module and AF element: `Rules`, `UseCase`, `Surface`, `State`, `Boundary`, `Adapter`, `Ability`, `Controller`, or `Event`.
3. Trace root cause before changing code.
4. Report a `Debug Findings` checkpoint before fixing: reproduction, affected Module, AF Element, root cause evidence, proposed regression test, minimal fix boundary, verification command, and any decision risk.
5. Stop for user approval when the checkpoint reveals a decision risk. Continue without stopping only when the reproduction is stable, root cause is single, ownership is clear, fix scope is small, regression evidence is clear, and no public behavior or contract decision is needed.
6. Write or update a regression test that fails for the observed bug.
7. Implement the minimal fix in the owning AF element.
8. Run the regression test and relevant verification commands.
9. Use `af-review` to check the fix against AF boundaries and root cause.
10. Use `af-verify-completion` before claiming the bug is fixed.
11. If the bug reveals missing framework guidance, use `af-update-framework`.

## AF Subagent Sidecars

Use `af-dispatch-agents` when parallel sidecar work can reduce wall-clock time without weakening reproduction or ownership discipline.

- Use `reproducer` for minimal reproduction attempts when the main agent can continue mapping ownership.
- Use `test_triager` for long or noisy test output classification.
- Use `code_mapper` for read-only trace mapping across files or modules.
- Use `debugger` for root-cause hypotheses after reproduction evidence exists.

Every sidecar prompt must include the suspected Module, AF Element, reproduction command or symptom, allowed read/write scope, forbidden scope, and Verification Gate. Sidecar findings do not replace the `Debug Findings` checkpoint.

## Debug Findings Checkpoint

Before changing production code, report:

| Field | Required Content |
|---|---|
| Reproduction | Smallest reliable command, route, scene, input, or test. |
| Affected Ownership | Module and concrete AF Element that owns the behavior. |
| Root Cause Evidence | Specific code path, state transition, dependency, or data shape that explains the failure. |
| Regression Test | Test or manual reproduction that should fail before the fix. |
| Minimal Fix Boundary | Files, Module, and AF Element allowed to change. |
| Verification | Command or manual evidence needed after the fix. |
| Decision Risk | `None` or the concrete user decision needed before fixing. |

Use concise prose instead of the table only when the same required content remains explicit.

## Stop For Approval When

- Root cause is not unique or the evidence is inconclusive.
- The fix would broaden scope beyond the reproduced bug.
- The fix crosses Modules or moves responsibility between AF elements.
- The fix changes public contract, data shape, persistence, migration, API behavior, or user-visible semantics beyond the bug.
- Regression testing strategy has a meaningful tradeoff or cannot be automated.
- The proposed fix risks breaking existing documented behavior.

## Rules

- Do not guess-fix without reproduction.
- Do not change production code until the bug has a reproduction path or failing regression test.
- Do not change production code until the `Debug Findings` checkpoint has been reported.
- Do not wait for approval when `Decision Risk` is `None`; continue with the regression test and minimal fix.
- Do not fix only the visible `Surface` symptom when the cause is in `Rules`, `UseCase`, `State`, or an `Adapter`.
- Do not broaden scope beyond the reproduced bug unless the user approves.
- Do not claim fixed without regression evidence.
- If a regression test cannot be automated, record the exact manual reproduction and verification evidence before claiming fixed.
