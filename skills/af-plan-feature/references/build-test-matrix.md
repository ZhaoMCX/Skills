# Build Test Obligations

Derive tests from AF elements, not from a generic test pyramid. Do not output a separate global `AF-derived Test Matrix`; record test obligations inside TDD slice fields.

## Required TDD Fields

Each TDD row must include:

- `行为或风险`: the behavior, invariant, failure mode, or regression risk being verified.
- `测试类型`: the kind of test or manual evidence.
- `验证 Gate`: the Gate name defined in `验证 Gate`.

## Guidance

- Data / Schema: validation, serialization, migration, static config compatibility.
- State Transition: legal and illegal lifecycle movement.
- Rules: pure logic, invariants, calculations, permissions, eligibility.
- UseCase: orchestration, state mutation, Result shape, Port calls.
- Event Flow: emitted facts and downstream observation, not command flow.
- Boundary: declared external or cross-layer capability isolation.
- Port: business-side contract behavior, fake implementation, and caller expectations.
- Adapter: concrete SDK/API/storage/network/engine translation.
- Ability: can execute, cannot execute, resource cost, cooldown, timing, target, emitted Result/Event.
- Controller: input mapping, scheduling, priority, cancellation, pause/resume, repeated input, state-machine transitions.
- Surface: route/page/component, scene/prefab/UI, API/CLI/editor entry, visible result, navigation, loading/empty/error state.
- Regression: old bug reproduction and compatibility risks.

## Rules

- Each TDD row maps concrete AF Element names to one behavior, risk, or scenario that needs verification.
- `AF 元素` values must use the same concrete names used in `AF 元素变动` or `跨模块 UseCase`; do not use abstract type labels such as `Rules`, `UseCase`, or `Surface`.
- Reference BDD scenario IDs such as `BDD-1`; use `N/A` only when the plan is explicitly non-BDD research or documentation.
- Omit irrelevant elements; do not add empty placeholder test rows just to fill coverage.
- Define the full command once in `验证 Gate`; rows should reference the Gate name.
