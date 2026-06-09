---
name: matt-pocock-agent-workflow
description: Suggests optional Matt Pocock-style engineering skills for repository work without forcing a workflow. Use when a task may benefit from setup-matt-pocock-skills, grill-with-docs, to-prd, to-issues, triage, diagnose, tdd, improve-codebase-architecture, or zoom-out, especially for PRDs, issues, triage, implementation planning, business/domain rules, debugging, testing, architecture improvement, or unfamiliar code. The skill should recommend relevant downstream skills and ask the user whether to use them unless the user explicitly invoked a downstream skill.
---

# Matt Pocock Agent Workflow

Use this skill as a lightweight suggestion layer, not as a process owner. It helps notice when a Matt Pocock-style skill might be useful, explains why, and asks the user whether to use it.

Do not treat this skill as permission to force `zoom-out`, `tdd`, `triage`, issue updates, or any other downstream workflow. The user stays in control.

## Quick Start

1. Identify one or two skills that may fit the current task.
2. Briefly tell the user why those skills may help.
3. Ask whether to use them before loading downstream skills.
4. Continue without the downstream skill if the user declines, ignores the suggestion, or asks for direct work.

If the user directly names a downstream skill, use that skill directly and skip the confirmation step.

## Suggestion Map

- Suggest `zoom-out` when the codebase, API surface, architecture, or cross-module behavior is unfamiliar.
- Suggest `grill-with-docs` when business rules, domain terms, lifecycle states, ownership, boundaries, or acceptance criteria need sharpening.
- Suggest `tdd` when the task affects public behavior, high-risk logic, integration behavior, or the user asks for complete testing or red-green-refactor.
- Suggest `diagnose` when the user reports broken behavior, a regression, an exception, flaky tests, failed verification, or performance trouble.
- Suggest `improve-codebase-architecture` when the user asks about coupling, module boundaries, testability, maintainability, or agent-navigable design.
- Suggest `to-prd` when the user wants a product or feature specification.
- Suggest `to-issues` when the user wants a plan or PRD split into implementation tickets.
- Suggest `triage` when creating, classifying, readiness-checking, or handing off issues.
- Suggest `setup-matt-pocock-skills` when the repository's issue tracker, triage labels, or domain-doc layout are missing or unclear.

## How To Ask

Keep the prompt short and specific:

```text
这个任务可能适合用 `$diagnose`，因为你描述的是失败/回归类问题。要我按诊断流程来走，还是直接先看代码？
```

When several skills may apply, offer a compact route instead of a long menu:

```text
这里可以用 `$zoom-out -> $grill-with-docs`：先看现有边界，再把业务规则问清楚。要按这个走吗？
```

Avoid asking for permission when the user already made the choice:

```text
用户说“用 `$tdd` 做这个”时，直接加载并应用 `$tdd`。
```

## Repository Setup

If setup appears relevant, suggest checking for:

- `## Agent skills` in `AGENTS.md` or equivalent agent instructions.
- `docs/agents/issue-tracker.md`.
- `docs/agents/triage-labels.md`.
- `docs/agents/domain.md` or another documented domain-doc layout.

Do not block ordinary work merely because setup is absent. Only recommend `setup-matt-pocock-skills` when issue, PRD, triage, domain-doc, or agent handoff work would benefit from durable repository conventions.

## Issue Work

For issue implementation, suggest but do not require this order:

1. Read the issue and repository agent configuration.
2. Check whether the issue is actionable.
3. Use `triage` if readiness or label state is unclear.
4. Use `tdd` or `diagnose` if the implementation risk warrants it.
5. Update the issue tracker if the repository convention expects progress notes, verification results, or residual risk notes.

Do not invent issue statuses or completion rules. If the user chooses issue workflow support, follow the repository's existing issue tracker docs.

## Communication

Use suggestion language:

- "这个任务可能适合..."
- "我建议可选用..."
- "要我按这个技能走吗？"
- "也可以不用，我可以直接继续。"

Avoid mandatory language:

- "必须使用..."
- "不要继续，除非..."
- "Hard trigger..."
- "This route is required..."

The goal is to make useful skills discoverable while preserving the user's control over the workflow.
