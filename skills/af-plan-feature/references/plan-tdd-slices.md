# Plan TDD Slices

TDD describes execution order. Plan all slices, then execute one vertical slice at a time.

TDD is mandatory for planned implementation. Do not produce a final AF Feature Plan without executable TDD slices unless the plan is explicitly for research or non-code documentation.

## Required Output Shape

Partition TDD by Module, with cross-module slices in their own section.

```md
## TDD 执行切片

### 模块：<模块名>

| 切片 | AF 元素 | BDD 场景 | 行为或风险 | 测试类型 | 先写测试 | 预期 RED | 最小 GREEN | 重构边界 | 验证 Gate |
|---|---|---|---|---|---|---|---|---|---|

### 跨模块切片

| 切片 | AF 元素 | BDD 场景 | 行为或风险 | 测试类型 | 先写测试 | 预期 RED | 最小 GREEN | 重构边界 | 验证 Gate |
|---|---|---|---|---|---|---|---|---|---|
```

## Rules

- Each slice starts with one test or one small group of tightly related tests.
- Each slice names concrete AF Element name or names and the BDD scenario it advances.
- `AF 元素` values must use concrete names from `AF 元素变动` or `跨模块 UseCase`, not abstract type labels such as `Rules`, `UseCase`, or `Surface`.
- `行为或风险` states the behavior, invariant, failure mode, or regression risk being verified.
- `测试类型` states the kind of test or manual evidence.
- `先写测试` names the specific test, spec, scenario, or manual verification note to create first.
- `预期 RED` states how the test should fail before implementation.
- `最小 GREEN` states behavior, not a code listing.
- `重构边界` states where cleanup may happen after GREEN.
- `验证 Gate` references a Gate defined in `验证 Gate`.
- Do not write all tests first and then all implementation.
- Do not write production code before the planned RED.
- Rules, UseCases, and bugfix-related slices must be test-first.
- Surface/UI slices must include key-path tests or explicit verification evidence when automated testing is not practical.
- Use `跨模块切片` only when the slice verifies cross-module behavior or a cross-module UseCase.
