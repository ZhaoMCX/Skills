---
name: using-agent-framework
description: Use when starting or coordinating AgentFramework-based work, choosing an AF skill, discussing AgentFramework concepts, or ensuring project work follows the current XXXAgentFramework.
---

# Using AgentFramework

Use this as the AgentFramework entrypoint and router. It does not create frameworks, plan features, execute code, debug, review, verify, or update documents itself.

## Design Philosophy

- Agent friendliness first: AF exists to make work easier for agents to understand, plan, execute, review, and verify.
- KISS first: use the smallest structure that makes ownership, boundaries, tests, and verification obvious.
- Agent-friendly means weak-model executable: the plan must not require the implementer to infer Module, AF Element, tests, TDD order, or verification.
- KISS does not mean under-specifying: remove ceremony, not information needed to avoid guessing.
- AF aims for the least ambiguous plan, not the shortest plan.
- Add AF elements, documents, boundaries, Ports, Adapters, or workflow steps only when they reduce real ambiguity or future rework.
- Prefer concrete names, concrete scenarios, concrete tests, and concrete verification over broad abstractions or code-level planning.
- The goal is efficient project development: less guessing, fewer misplaced responsibilities, and clearer completion evidence.

## Core Rules

- For project development work, if a `XXXAgentFramework` exists or the user asks for AgentFramework/AF, use AF skills before planning, implementing, debugging, reviewing, or verifying.
- Do not force AF onto non-development tasks such as image generation, spreadsheets, documents, general web research, pure Q&A, or non-development collaboration unless the user explicitly asks.
- Find and read the current project `XXXAgentFramework` before AF-based work.
- If no project framework exists, create one with `af-create-framework` for long-lived projects, complex features, multi-module work, or explicit AF requests. For one-off small tasks, AF may be skipped unless the user asks for it.
- If the project framework is stale or missing durable knowledge discovered during work, use `af-update-framework`.
- For feature work, use `af-plan-feature` before implementation.
- `af-plan-feature` has built-in requirement grilling, domain consistency grilling, option framing, and plan self-review. AF planning does not depend on external planning, grilling, or documentation skills.
- In Codex Plan Mode, only plan: explore, clarify, and produce `<proposed_plan>`. Do not save plans, edit project files, or execute implementation.
- After a plan is approved and Plan Mode is off, use `af-save-plan` before implementation when the user wants the plan persisted.
- Execute approved AF plans with `af-execute-plan`.
- Domain or tool skills may be used for specialized capabilities, but they must respect the active `XXXAgentFramework`, AF Feature Plan, Write Scope, Forbidden Shortcuts, and verification Gates.
- When AF work needs subagents, use `af-dispatch-agents` and scope tasks by Primary Module, Related Modules, AF Element, TDD Slice, BDD Scenario, Write Scope, Forbidden Shortcuts, and Verification Gates.
- Debug defects with `af-debug`.
- Review completed changes with `af-review`.
- Verify completion with `af-verify-completion` before claiming work is complete.
- When AF work must continue in another session or by another agent, use `af-handoff` and include the active `XXXAgentFramework`, AF Feature Plan, Module context, concrete AF Element progress, TDD/review/verification state, and suggested next AF skill.

## Router

| Situation | Use |
| --- | --- |
| Explain AF concepts or choose a workflow | `using-agent-framework` |
| Create `UnityAgentFramework`, `WebAppAgentFramework`, or another profile | `af-create-framework` |
| Update an existing `XXXAgentFramework`, `ModulePlan`, Binding, glossary, or verification rules | `af-update-framework` |
| Discuss a feature and produce an AF Feature Plan | `af-plan-feature` |
| Persist an approved AF Feature Plan | `af-save-plan` |
| Implement an approved AF Feature Plan | `af-execute-plan` |
| Delegate independent AF work to subagents | `af-dispatch-agents` |
| Reproduce and fix a bug | `af-debug` |
| Review code against AF boundaries and plan obligations | `af-review` |
| Run final verification and report evidence | `af-verify-completion` |
| Hand work to a future session or another agent | `af-handoff` |

## AF Invariants

- `Module` is the primary coordinate for ownership, write scope, dependencies, and verification.
- `Primary Module` is normally unique. Cross-module work must name the collaboration mechanism: `UseCase`, `Event`, `Port`, `Result`, or `Surface composition`.
- Every AF Feature Plan accounts for all AF element types: `Module`, `Data`, `State`, `Rules`, `Surface`, `UseCase`, `Event`, `Boundary`, `Port`, `Adapter`, `Ability`, and `Controller`.
- Changed or relied-on AF Elements are concrete names marked `New`, `Change`, or `Existing`. Irrelevant element types are omitted by default; add a short omission note only when absence would invite ownership, boundary, or verification ambiguity.
- Changed or relied-on entry points and presentation artifacts are listed as concrete `Surface` elements; `Surface` must not own business decisions.
- BDD is mandatory for formal feature work. Each feature plan has at least one Acceptance Scenario using `Given / When / Then`; complex features cover normal, failure, and no-side-effect paths.
- TDD is mandatory for planned implementation. Rules, UseCases, and bugfixes must be test-first and must show expected RED before GREEN. Surface/UI work must have key-path tests or explicit verification evidence.
- Plans are responsibility and verification contracts, not code-level construction drawings.
- Feature planning must challenge requirements, terminology, existing docs, code behavior, ModulePlan dependencies, and AF ownership before producing a plan.
- Feature plans must satisfy the Minimum Effective Plan: Module, concrete AF Elements, BDD behavior, test obligation, TDD RED/GREEN path, and verification Gate.
- Feature plans must pass the Gray Area Gate: requirements, ownership, tests, write scope, and verification cannot contain unresolved decisions unless explicitly accepted as assumptions.
- Implementation must be followed by `af-review` and `af-verify-completion`; review and verification do not replace each other.
- Bugfixes, regressions, failing tests, flaky behavior, and unexpected state must use `af-debug`: no reproduction, no fix; no regression evidence, no claim of fixed.
- Subagents used for AF work are AF-scoped workers. They must receive concrete AF coordinates in the dispatch prompt, and their results never replace main-agent integration, AF review, or final verification.
- AF handoffs reference durable AF artifacts instead of duplicating them and include the next suggested AF skill.

## Anti-Patterns

- Using AF as a decorative document after implementation.
- Starting implementation before AF ownership, tests, and verification are clear.
- Letting `Rules` call platform, browser, engine, SDK, storage, network, or database APIs.
- Hiding business behavior in `Surface`.
- Letting `Adapter` decide business outcomes.
- Creating `Port` or pattern-heavy abstractions without a real boundary, test, or multiple-implementation need.
- Dispatching subagents before Module ownership, write scope, or public contracts are settled.
- Treating a handoff summary as a replacement for AF Feature Plans, ADRs, tests, or verification evidence.
