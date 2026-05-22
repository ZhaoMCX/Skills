# Gray Area Gate

No unresolved gray area should enter the final AF Feature Plan unless the user explicitly accepts it as an assumption.
Before outputting `<proposed_plan>`, visibly perform a Gray Area Sweep. The sweep must list every discovered gray area that could affect implementation, tests, AF ownership, acceptance, scope, write boundaries, or verification.

## Must Resolve

Resolve gray areas that affect:

- User goal or success criteria.
- In-scope and out-of-scope behavior.
- Normal, failure, empty, invalid, permission, timing, lifecycle, or no-side-effect paths.
- Primary Module or cross-module collaboration.
- Concrete AF Element names or AF type inferred from Binding.
- Whether behavior belongs in Rule, UseCase, Surface, Ability, Controller, Port, or Adapter.
- Public contracts, data shape, state transition, event emission, or Result shape.
- Test obligation, TDD slice order, expected RED, minimal GREEN, or verification Gate.
- ModulePlan dependencies or forbidden write scope.

## Discover Before Asking

Before asking the user, inspect any relevant:

- `XXXAgentFramework`
- Directory And Naming Binding
- ModulePlan
- docs and durable decisions
- related code, routes, scenes, prefabs, API endpoints, tests, configs, and manifests

Ask only when inspection cannot decide a product or design preference.

## Ask

When asking:

- Ask one blocking question at a time.
- Explain why it affects implementation, tests, AF ownership, acceptance, or scope.
- Provide a recommended answer.
- Record the answer in `Decisions / Gray Areas Resolved`.
- Stop before final plan output until the answer is received or the user explicitly accepts a stated assumption.

## Required Output Shape

Record the sweep in the final plan as:

```md
## 已决策项与灰区处理
| 灰区 / 问题 | 来源 | 影响范围 | 决策 / 处理方式 | 理由 |
|---|---|---|---|---|
```

Use `无阻塞灰区` only after inspecting the framework, ModulePlan, relevant docs, code, tests, configs, routes/scenes/pages, and terminology enough to justify that result.

## May Remain As Assumption

Only leave an item unresolved when the user explicitly accepts an assumption. Record it in the plan with its risk and verification consequence.

## Stop Conditions

Do not proceed to final planning while any unresolved gray area would force the implementer to choose Module ownership, AF Element responsibility, test behavior, TDD order, write scope, or verification.
Do not output `<proposed_plan>` when a blocking user question is still open.
