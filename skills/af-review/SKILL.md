---
name: af-review
description: Use when reviewing implemented changes against AgentFramework boundaries, ModulePlan ownership, AF Feature Plan obligations, or AF-derived tests.
---

# AF Review

Review implementation against the current `XXXAgentFramework` and AF Feature Plan.

## Review Checklist

- The implementation follows an approved AF Feature Plan, or the change is explicitly scoped as a bugfix or small maintenance task.
- Module ownership matches the Module Impact Map.
- Write Scope was respected.
- ModulePlan dependency rules were not violated.
- Every changed file has a clear AF element responsibility.
- `Rules` stay deterministic and platform-neutral.
- `UseCase` owns orchestration and does not become a service locator.
- `Surface` handles input/output and does not hide business rules.
- `Adapter` isolates external APIs and does not decide business outcomes.
- `Port` exists only when needed for a real boundary, test, or implementation variation.
- `Ability` and `Controller` are used only for interactive, timed, input, scheduling, or state-machine behavior.
- Tests cover the AF elements promised by the plan.
- BDD scenarios from the plan are represented by tests or explicit verification.
- TDD slices were followed: test first, expected RED, minimal GREEN, refactor boundary, verification.
- Verification evidence is present or delegated to `af-verify-completion`.

## Output

Lead with findings ordered by severity. Include file and line references when reviewing code. If no issues are found, say so and name residual risks or unrun verification.
