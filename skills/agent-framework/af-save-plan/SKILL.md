---
name: af-save-plan
description: Use when an approved AF Feature Plan should be saved to the project after Codex Plan Mode has ended.
---

# AF Save Plan

Persist an approved AF Feature Plan when the user wants a durable plan, the work spans sessions, or the change needs audit/review history. Do not run this skill inside Codex Plan Mode. Saving is not required before every execution; `af-execute-plan` may execute an approved current plan text.

## Default Location

Save plans to:

```text
docs/agent-framework/plans/YYYY-MM-DD-<feature-slug>-af-feature-plan.md
```

If the current `XXXAgentFramework` Binding defines a different plan path, use the Binding path.

## Status Rules

Allowed statuses:

```text
Draft -> Approved -> InProgress -> Implemented -> Verified -> Superseded
```

When saving an approved plan, set:

```text
Status: Approved
```

## Requirements

- Save the exact approved AF Feature Plan, adjusting only date, slug, status, and file path.
- Preserve BDD scenarios, Module Impact Map, AF 元素变动, 跨模块 UseCase, TDD 执行切片, Write Scope, Forbidden Shortcuts, and 验证 Gate.
- Do not implement the plan while saving it.
- If replacing an older plan, mark the old plan `Superseded` and link the replacement.
