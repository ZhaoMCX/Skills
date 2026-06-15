# Feishu Companion Examples

These examples are placeholders. Replace bracketed values with real identifiers returned by Feishu/Lark commands.

## `AGENTS.md` Block

```md
## Agent skills

### Issue tracker

This repo uses the Feishu Wiki-mounted Base as the source of truth for issues, PRDs, backlog, and agent work. See `docs/agents/issue-tracker.md`.

### Triage labels

Triage status uses the five canonical English values in the Base `Status` field. See `docs/agents/triage-labels.md`.

### Domain docs

This repo is single-context; Feishu `CONTEXT` is the domain source of truth and Feishu `ADR` is the decision index. See `docs/agents/domain.md`.
```

## `docs/agents/issue-tracker.md`

```md
# Issue Tracker

Issues, PRDs, backlog items, triage state, and agent work logs live in the Feishu Base mounted under the project Wiki space.

## Feishu Resources

- Wiki space: `[PROJECT_NAME]`
- Wiki space ID: `[SPACE_ID]`
- Base node URL: `[WIKI_NODE_URL]`
- Base name: `Issue Tracker / Backlog`
- Base URL: `[BASE_URL]`
- Base token: `[BASE_TOKEN]`
- Base Wiki node token: `[BASE_NODE_TOKEN]`
- Main table: `Issues`
- Main table ID: `[ISSUES_TABLE_ID]`
- Views: `Grid`, `Open Issues`, `Ready for Agent`, `Ready for Human`, `Needs Info`, `Closed Issues`

## Rules

- Locate the Base from the project Wiki space.
- Publishing to the issue tracker means creating or updating an `Issues` record.
- Applying a triage label means setting `Issues.Status`.
- Closing an issue means setting `Issues.Resolution`, not changing `Issues.Status`.
- Setting prerequisites means writing `Issues.Depends On`.
- `Issues.Blocks` is the automatic reverse relationship; do not write it by hand.
- `Issues.Parent` records the source or parent issue; it is not a prerequisite.
- `Issues.Type` stores only `AFK` or `HITL`.
- Start agent work only when `Status=ready-for-agent`, `Resolution=unresolved`, and all `Depends On` issues are `Resolution=done`.
- Give Base fields Chinese descriptions that explain each field's role.
- Put important fields first in views: `Title`, `Status`, `Resolution`, `Type`, `Parent`, `Depends On`, then priority, owner, module, `What to build`, `User Stories Covered`, acceptance, context, notes, links, and timestamps.
- Keep `Grid` as the all-record view, and add filtered agent entry views for open issues, ready-for-agent work, ready-for-human work, needs-info work, and closed issues.
- Do not keep empty default Dashboards or disabled empty Workflows unless the user explicitly wants Base analytics or automation.
- Feishu Tasks may be used for reminders, but Base records are the source of truth.

## Views

| 视图 | 筛选 |
| --- | --- |
| `Grid` | No filter; all records. |
| `Open Issues` | `Item Kind=Issue` and `Resolution=unresolved`. |
| `Ready for Agent` | `Item Kind=Issue`, `Resolution=unresolved`, and `Status=ready-for-agent`. |
| `Ready for Human` | `Item Kind=Issue`, `Resolution=unresolved`, and `Status=ready-for-human`. |
| `Needs Info` | `Item Kind=Issue`, `Resolution=unresolved`, and `Status=needs-info`. |
| `Closed Issues` | `Item Kind=Issue` and `Resolution` is one of `done`, `wontfix`, `duplicate`, or `superseded`. |

## Issues Fields

| 字段 | 类型 | 作用 |
| --- | --- | --- |
| `Title` | text | 标题。用于概括 issue、PRD、backlog item 或 agent work item，是列表中最主要的识别信息。 |
| `Status` | select | 分诊状态。只表示 issue 当前需要谁处理或是否可被 agent 接手，不表示完成或关闭。 |
| `Resolution` | select | 解决状态。`unresolved` 表示打开；`done`、`wontfix`、`duplicate`、`superseded` 表示已关闭及关闭原因。 |
| `Type` | select | 执行模式。只使用 `AFK` 或 `HITL`；`AFK` 表示 agent 可独立处理，`HITL` 表示需要人工确认、评审、外部联调或决策。 |
| `Parent` | link | 父级或来源 issue。表示结构归属或拆解来源，不等同于前置依赖，也不参与启动判断。 |
| `Depends On` | link | 前置依赖。记录当前 issue 开始前必须先完成的 issue；agent 只维护此字段，`Blocks` 为自动反向关系。 |
| `Blocks` | reverse link | 阻塞项。`Depends On` 的自动反向关系，用于查看当前 issue 解锁或阻塞的后续 issue，不手工写入。 |
| `Priority` | select | 优先级。用于排序和判断处理紧急程度，`P0` 最高、`P3` 最低。 |
| `Owner` | user | 负责人。记录当前 issue 的直接负责人、评审人或需要跟进的人。 |
| `Module` | text | 模块。记录 issue 所属的产品域、业务模块或代码模块，便于筛选和聚合。 |
| `What to build` | text | 构建内容。对应 `$to-issues` 模板的 `What to build`，描述端到端行为和交付内容。 |
| `User Stories Covered` | text | 覆盖用户故事。记录 PRD 用户故事编号或范围，例如 `3-12`，用于追踪 issue 与 PRD 的对应关系。 |
| `Description` | text | 描述。保留背景摘要、问题陈述、PRD 摘要和补充上下文。 |
| `Acceptance Criteria` | text | 验收标准。记录完成条件、可验证结果和交付边界。 |
| `Agent Notes` | text | Agent 记录。只放执行记录、迁移说明、异常和交接；不承载 `AFK/HITL`、用户故事编号或模板正文。 |
| `Related Branch/PR` | text | 关联分支或 PR。记录分支、PR、提交、构建或外部工作链接。 |
| `Created At` | created_at | 创建时间。系统自动记录 issue 创建时间，只读。 |
| `Updated At` | updated_at | 更新时间。系统自动记录 issue 最近更新时间，只读。 |
```

## `docs/agents/domain.md`

```md
# Domain Docs

This repo is single-context. Project context and architecture decisions live in Feishu Wiki; local files only store agent-readable pointers.

## Feishu Sources

- Wiki space: `[PROJECT_NAME]`
- Wiki space ID: `[SPACE_ID]`
- `CONTEXT`: `[CONTEXT_WIKI_URL]`
- `CONTEXT` doc token: `[CONTEXT_DOC_TOKEN]`
- `ADR`: `[ADR_WIKI_URL]`
- `ADR` doc token: `[ADR_DOC_TOKEN]`

## Reading Rules

- Read this file first to locate project knowledge.
- Read Feishu `CONTEXT` for domain language, roles, workflows, boundaries, and constraints.
- Read Feishu `ADR` for architecture decisions and long-term technical constraints.
- Do not create full local `CONTEXT.md` or `docs/adr/` copies unless the user explicitly asks for local docs.
```

## View Payload Files

Use payload files for Windows PowerShell instead of inline JSON:

```json
[
  { "name": "Open Issues", "type": "grid" },
  { "name": "Ready for Agent", "type": "grid" },
  { "name": "Ready for Human", "type": "grid" },
  { "name": "Needs Info", "type": "grid" },
  { "name": "Closed Issues", "type": "grid" }
]
```

```bash
lark-cli base +view-create \
  --base-token <base_token> \
  --table-id <issues_table_id> \
  --json @views.json \
  --as user
```

Standard filter payloads:

```json
{
  "logic": "and",
  "conditions": [
    ["Item Kind", "==", ["Issue"]],
    ["Resolution", "==", ["unresolved"]]
  ]
}
```

```json
{
  "logic": "and",
  "conditions": [
    ["Item Kind", "==", ["Issue"]],
    ["Resolution", "==", ["unresolved"]],
    ["Status", "==", ["ready-for-agent"]]
  ]
}
```

```json
{
  "logic": "and",
  "conditions": [
    ["Item Kind", "==", ["Issue"]],
    ["Resolution", "==", ["unresolved"]],
    ["Status", "==", ["ready-for-human"]]
  ]
}
```

```json
{
  "logic": "and",
  "conditions": [
    ["Item Kind", "==", ["Issue"]],
    ["Resolution", "==", ["unresolved"]],
    ["Status", "==", ["needs-info"]]
  ]
}
```

```json
{
  "logic": "and",
  "conditions": [
    ["Item Kind", "==", ["Issue"]],
    ["Resolution", "intersects", ["done", "wontfix", "duplicate", "superseded"]]
  ]
}
```

## Split-Flow Authorization Template

When a missing scope blocks setup, request the narrow scope and stop for user authorization:

```bash
lark-cli auth login --scope "base:block:read,base:block:delete" --no-wait --json
lark-cli auth qrcode "<verification_url>" --output auth.png
```

Send the original verification URL and QR code to the user. After the user replies that authorization is complete, the agent must run:

```bash
lark-cli auth login --device-code <device_code>
```

## Empty Dashboard And Workflow Cleanup

Read before deleting:

```bash
lark-cli base +dashboard-block-list --base-token <base_token> --dashboard-id <dashboard_id> --as user
lark-cli base +workflow-get --base-token <base_token> --workflow-id <workflow_id> --as user
```

Delete only when the dashboard has no blocks or the workflow is disabled with no steps:

```bash
lark-cli base +dashboard-delete --base-token <base_token> --dashboard-id <dashboard_id> --as user --yes
lark-cli base +base-block-delete --base-token <base_token> --block-id <dashboard_or_workflow_block_id> --as user --yes
```
