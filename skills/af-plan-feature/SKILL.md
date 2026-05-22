---
name: af-plan-feature
description: Use when discussing, scoping, or planning a feature, behavior change, user flow, route, game ability, controller behavior, domain rule, or UI/API surface before implementation.
---

# AF Plan Feature

Produce an AF Feature Plan: a Module-first responsibility and verification contract. This skill is designed for Codex Plan Mode.

## Plan Mode Rule

In Codex Plan Mode, only explore, clarify, and output `<proposed_plan>`. Do not write files, save plans, edit code, run formatters, or execute implementation.
Before finalizing a plan, perform and visibly discuss a Gray Area Sweep. If any blocking gray area cannot be resolved by inspection, ask exactly one blocking question and do not output `<proposed_plan>` yet. Do not infer silence as approval.
Final Plan Mode output must visibly list one complete AF Feature Plan inside `<proposed_plan>...</proposed_plan>` using `references/feature-plan-template.md`. Do not replace the plan with a summary, intent statement, partial checklist, or "ready to implement" note.

## Workflow

1. Read the current `XXXAgentFramework`, Directory And Naming Binding, ModulePlan, and relevant project docs.
2. Run the built-in clarification entrypoint using `references/clarify-requirements.md`.
3. Run Requirement Grilling using `references/requirement-grilling.md`.
4. Run Domain Consistency Grilling using `references/domain-consistency-grilling.md`.
5. Build and visibly discuss a Gray Area Sweep using `references/gray-area-gate.md`; ask one blocking question and stop if any blocking gray area remains unresolved.
6. Apply the Gray Area Gate using `references/gray-area-gate.md`.
7. Apply the Minimum Effective Plan rules using `references/minimum-effective-plan.md`.
8. Frame options using `references/option-framing.md` when a real tradeoff affects architecture, AF ownership, public contracts, tests, or user-visible behavior.
9. Write behavior-first BDD scenarios using `references/write-bdd-scenarios.md`.
10. Build the Module Impact Map using `references/module-impact-map.md`.
11. Complete all AF elements by Module and AF type using `references/complete-af-mapping.md`.
12. Derive test obligations into the TDD slice fields using `references/build-test-matrix.md`.
13. Plan module-partitioned TDD slices using `references/plan-tdd-slices.md`.
14. Decide subagent delegation using `references/subagent-delegation-strategy.md`; identify viable delegation candidates, then choose `Delegate` when delegation materially reduces risk, ambiguity, verification burden, or wall-clock time without adding coordination overhead.
15. Produce and visibly list the final plan with `references/feature-plan-template.md`.
16. Self-review the plan using `references/plan-self-review.md` before outputting `<proposed_plan>`.

## Required Plan Properties

- `Primary Module` is explicit and normally unique.
- Cross-module work names the collaboration mechanism: `UseCase`, `Event`, `Port`, `Result`, or `Surface composition`.
- Every AF element type is accounted for: `Module`, `Data`, `State`, `Rules`, `Surface`, `UseCase`, `Event`, `Boundary`, `Port`, `Adapter`, `Ability`, `Controller`.
- Concrete AF Element rows are marked `New`, `Change`, or `Existing`; irrelevant types are omitted by default unless omission would invite ownership or verification ambiguity.
- AF element changes are represented under `AF 元素变动`, grouped first by Module and then by relevant AF type. The `AF Element` value must be a concrete class name, artifact name, route, scene, prefab, endpoint, or stable product name, not a file path and not an abstract type label such as `Rules`, `UseCase`, or `Surface`.
- AF type is inferred from the current framework Directory And Naming Binding and naming suffix. If a name cannot reveal its AF type, fix the name in the plan before execution.
- Each row is one concrete AF element in one affected Module. Do not merge elements such as `Boundary / Port / Adapter` into one change row.
- Surface is mandatory when a route, page, component, scene, prefab, API endpoint, CLI command, editor entry, visible feedback, or user/system entry point changes or is relied on. List the concrete Surface name; do not use Surface for business decisions.
- Do not create empty AF type tables or routine N/A rows. Add a short omission note only when the absence of a type such as `*Rule`, `*Adapter`, or `*Ability` would otherwise create ambiguity.
- Tests are derived from AF elements and recorded in TDD slice fields: `行为或风险`, `测试类型`, and `验证 Gate`.
- BDD is mandatory. Each formal feature has at least one `Given / When / Then` Acceptance Scenario; complex features cover normal, failure, and no-side-effect paths.
- TDD is mandatory. Each planned implementation slice names the test first, expected RED, minimal GREEN, refactor boundary, and verification Gate.
- Subagent delegation decision is mandatory. The plan must identify viable delegation candidates or state that none exist. Choose `Delegate` when delegation materially improves execution or verification and satisfies dispatch safety. Choose `No delegation` when work is small, tightly coupled, critical-path, coordination-heavy, unresolved, shared-scope, unverifiable, unsupported by available subagent capability, or when delegation overhead would exceed its benefit.
- Delegation must follow the general `dispatch-agents` constraints: independent tasks, non-overlapping write scope, no unresolved shared decisions, clear verification, and main-agent integration responsibility.
- Requirement Grilling is mandatory before planning. Ask one blocking question at a time when exploration cannot answer it, and include a recommended answer.
- Domain Consistency Grilling is mandatory before planning. Resolve conflicts between the request, framework, docs, code, tests, terminology, and ModulePlan before finalizing.
- Gray Area Sweep is mandatory before the final plan. The final plan must show every discovered gray area that could affect implementation, tests, AF ownership, acceptance, scope, write boundaries, or verification, with its source, impact, resolution, and reason.
- Gray Area Gate is mandatory. Do not finalize a plan while requirements, ownership, tests, write scope, or verification contain unresolved decisions unless the user explicitly accepts them as assumptions.
- Minimum Effective Plan is mandatory. Even tiny plans must include Module, concrete AF Element, BDD behavior or acceptance, test obligation, TDD RED/GREEN path, and verification Gate.
- KISS does not mean under-specifying. Shorten ceremony, not the information a weaker model needs to execute without guessing.
- Important tradeoffs use Option Framing with 2-3 meaningful options and a recommended default.
- Plan Self-Review is mandatory before output. Do not present plans with placeholders, abstract AF Elements, unresolved gray areas, missing tests, or non-executable TDD slices.
- The final response must include the complete plan body, not merely a promise that a plan exists.
- Use tables where comparison, ownership, status, verification, or evidence must be scanned. Use prose where intent or tradeoffs read better as text.
- The plan does not include large implementation code blocks.
- Public contracts, data shapes, test names, and verification Gates may be specified when they prevent ambiguity.
- This skill is self-contained. Do not require, call, or depend on external planning, grilling, documentation, or superpower skills.
- During Plan Mode, do not write `CONTEXT.md`, ADRs, feature plans, framework docs, or project files. Record durable follow-up needs in `Required Documentation Updates`.

## When Not To Use

- Use `af-debug` for defects where reproduction and root cause are the primary task.
- Use `af-review` for already implemented changes.
- Use `af-execute-plan` only after an AF Feature Plan is approved.
