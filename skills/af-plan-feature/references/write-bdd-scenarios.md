# Write BDD Scenarios

BDD describes requirements in user, business, or system-visible language.

BDD is mandatory for formal feature work. Do not produce a final AF Feature Plan without at least one Acceptance Scenario.

## Required Output Shape

Write BDD before Module Impact Map and AF element mapping. Partition scenarios by owning Module, with cross-module scenarios in their own section.

```md
## BDD 验收场景

### 模块：<模块名>

| 场景 ID | 场景 | Given | When | Then | 覆盖模块 | 验证 Gate |
|---|---|---|---|---|---|---|

### 跨模块场景

| 场景 ID | 场景 | Given | When | Then | 覆盖模块 | 验证 Gate |
|---|---|---|---|---|---|---|
```

Use scenario IDs such as `BDD-1`, `BDD-2`, and `BDD-X1`.

## Scenario Semantics

```gherkin
Scenario: <observable behavior>
  Given <initial state, permission, data, route, scene, or module fact>
  And <important precondition>
  When <user action or system event>
  Then <business result>
  And <state change or no unintended mutation>
  And <visible result or returned result>
```

## Rules

- Every formal feature has at least one scenario.
- Complex features cover normal path, failure path, and no-side-effect guarantee.
- Cover normal path, important failure path, and important no-side-effect guarantee.
- Use project domain terms from the current `XXXAgentFramework`.
- Do not make every scenario an end-to-end UI test.
- Each scenario must map to concrete AF Elements later in `AF 元素变动` or `跨模块 UseCase`.
- Use `跨模块场景` only when the behavior crosses Modules or verifies a cross-module UseCase.
