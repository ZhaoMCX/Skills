# AF 元素变动

Every AF Feature Plan must make changed or relied-on AF responsibilities concrete. Represent them by concrete AF Element name and owning Module. Omit irrelevant element types by default; add a short omission note only when absence would invite ownership, boundary, or verification ambiguity.

## Required Shape

```md
## AF 元素变动

### 模块：<模块名>

#### <AF 类型>

| AF 元素 | 状态 | 职责变更 | 关联 BDD | 验证 Gate |
|---|---|---|---|---|
```

Only create AF type tables that have concrete elements. Do not create empty type tables. Do not add routine N/A rows.

If omission needs to be explicit, write a short note under the relevant module, for example:

```md
未涉及：Adapter。原因：本功能不新增外部实现，现有 Port fake 足以覆盖测试。
```

## Cross-Module UseCase

Cross-module UseCases get a dedicated section:

```md
## 跨模块 UseCase

| UseCase | 参与模块 | 协作机制 | 状态 | 职责变更 | 关联 BDD | 验证 Gate |
|---|---|---|---|---|---|---|
```

Only true cross-module UseCases belong here. Other AF elements such as Event, Boundary, Port, Adapter, Ability, Controller, Data, State, Rules, Surface, and single-module UseCase remain under the Module that owns them.

## Status Values

- `New`
- `Change`
- `Existing`

## Mapping Rules

- Changed or relied-on AF responsibilities must appear as concrete named AF Elements under a Module/type section or in `跨模块 UseCase`.
- Irrelevant AF element types are omitted by default.
- Add an omission note only when absence of a type would invite guessing, for example when readers may expect an `Adapter`, `Port`, `Event`, `Rule`, `Ability`, or `Controller`.
- `AF 元素` must name a concrete class, artifact, route, scene, prefab, endpoint, or stable product name. Do not use file paths.
- Do not use abstract type labels such as `Rules`, `UseCase`, `Surface`, `Boundary`, `Port`, or `Adapter` as `AF 元素` values.
- Infer the AF type from the current `XXXAgentFramework` Directory And Naming Binding and naming suffix.
- If a name cannot reveal its AF type from Binding, rename or specify the concrete AF Element in the plan before execution. Do not leave naming ambiguity to the implementation step.
- Each row must be exactly one concrete AF Element within one owning Module, except rows in `跨模块 UseCase`.
- Do not combine rows such as `Boundary / Port / Adapter`, `Data / State`, or `Ability / Controller`.
- If one implementation change affects multiple AF elements, describe the same change separately on each affected element row with that element's responsibility and verification Gate.
- Surface must be listed when a route, page, component, scene, prefab, API endpoint, CLI command, editor entry, visible feedback, or user/system entry point changes or is relied on.
- Surface rows must name the concrete entry or presentation artifact, such as `CartPage`, `BirdGameScene`, `SubmitOrderEndpoint`, or `EditorToolbar`.
- `Rules` must not call platform, browser, engine, SDK, storage, network, database, or UI APIs.
- `Surface` is entry/presentation, not a place to hide business decisions.
- `UseCase` owns cross-module or reusable business flow.
- `Boundary` declares what must be isolated.
- `Port` is optional and exists for tests, multiple implementations, or stable external contracts.
- `Adapter` is the concrete external implementation.
- `Ability` is for interactive, temporal, engine-timed, gesture, physics, animation, editor, or action behavior.
- `Controller` schedules or arbitrates Ability, input, turn, state-machine, editor, or timing behavior.
