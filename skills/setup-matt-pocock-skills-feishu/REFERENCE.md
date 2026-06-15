# Feishu Companion Reference

This companion records a reusable Feishu/Lark branch for `setup-matt-pocock-skills`. It does not replace the original skill and must not copy or modify it.

## Why This Is a Companion

`setup-matt-pocock-skills` defines the minimal local contract expected by Matt Pocock-style engineering skills: an agent entry file plus `docs/agents/` guidance. Feishu/Lark changes where the tracker and domain knowledge live, but not that local contract. Therefore the Feishu pattern should extend the setup conversation rather than fork the original skill.

## Decision Principles

- Keep local files minimal and machine-readable.
- Keep project knowledge in Feishu Wiki, where humans maintain it.
- Keep structured work state in Feishu Base, where agents can query and update it.
- Avoid duplicate facts across local Markdown and Feishu documents.
- Do not write secrets to the repo. Feishu resource tokens and table IDs are identifiers, not app secrets, but still keep them scoped to setup files.
- Prefer user identity for Feishu resources unless the user explicitly requests bot ownership.

## Resource Model

Recommended Feishu resources for one project:

| Resource | Purpose |
| --- | --- |
| Wiki space | Project knowledge home |
| `Issue Tracker / Backlog` Base | Issues, PRDs, backlog, triage state, agent work queue |
| `Issues` table | Main work item table |
| `CONTEXT` docx | Domain language, roles, workflows, constraints |
| `ADR` docx | Architecture decision record index |

The Base should be mounted under the Wiki space. Agents should locate the Base from the project Wiki space, not by global Base-name search.

Dashboards and Workflows are not default resources for this companion. Use them only when the user explicitly wants Base analytics, reminders, or automation. If Base creation leaves an empty default Dashboard or a disabled Workflow with no steps, delete it during setup; if the platform does not allow deletion, leave it disabled and document the limitation.

## Minimal Local Files

The local repo should still contain only the original setup files unless the user requests more:

- `AGENTS.md` or `CLAUDE.md`
- `docs/agents/issue-tracker.md`
- `docs/agents/triage-labels.md`
- `docs/agents/domain.md`

`issue-tracker.md` records the Wiki space, mounted Base, table names, table IDs, and write conventions.

`triage-labels.md` maps the five canonical triage roles to tracker values. The recommended Feishu value is the same English string:

- `needs-triage`
- `needs-info`
- `ready-for-agent`
- `ready-for-human`
- `wontfix`

`domain.md` records the Feishu `CONTEXT` and `ADR` links/tokens and tells agents when to read each one.

## Base Schema

Recommended first table: `Issues`.

Recommended field order puts workflow-critical properties first:

| 字段 | 类型 | 字段说明 |
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

Use the same order for the default grid view where possible. Feishu may expose `Blocks` only as the bidirectional reverse field of `Depends On`; still document its role even if it is not returned by normal field-list commands.

Recommended views:

| 视图 | 筛选 |
| --- | --- |
| `Grid` | No filter; all records. |
| `Open Issues` | `Item Kind=Issue` and `Resolution=unresolved`. |
| `Ready for Agent` | `Item Kind=Issue`, `Resolution=unresolved`, and `Status=ready-for-agent`. |
| `Ready for Human` | `Item Kind=Issue`, `Resolution=unresolved`, and `Status=ready-for-human`. |
| `Needs Info` | `Item Kind=Issue`, `Resolution=unresolved`, and `Status=needs-info`. |
| `Closed Issues` | `Item Kind=Issue` and `Resolution` intersects `done`, `wontfix`, `duplicate`, or `superseded`. |

## Status and Resolution

Matt Pocock-style triage labels do not encode issue completion. GitHub and GitLab provide open/closed state separately, so the Feishu Base should do the same:

- `Status` answers whether the issue needs triage, needs information, is ready for an agent, is ready for a human, or is wontfix as a triage role.
- `Resolution=unresolved` means the issue is still open.
- `Resolution=done`, `wontfix`, `duplicate`, or `superseded` means the issue is closed.
- New issue records should default to `Resolution=unresolved`.

## Dependencies

Use a bidirectional link field for issue dependencies:

- `Depends On` is the only dependency field agents write.
- `Blocks` is the automatic reverse relationship for seeing what the current issue unlocks.
- Keep `Parent` and `Depends On` separate; `Parent` records structure or source and does not control startability.
- An issue is startable only when `Status=ready-for-agent`, `Resolution=unresolved`, and every `Depends On` issue has `Resolution=done`.
- If a dependency closes as `wontfix`, `duplicate`, or `superseded`, re-evaluate whether the dependent issue is still valid before starting.

## Feishu Creation Workflow

When the user asks to create real resources:

1. Use the relevant Lark skills before calling CLI commands:
   - `lark-shared`
   - `lark-wiki`
   - `lark-base`
   - `lark-doc`
2. Create or locate the project Wiki space.
3. Create or locate the Base and `Issues` table.
4. Move or mount the Base into the Wiki space.
5. Remove empty default Dashboards and disabled empty Workflows unless the user has explicitly asked for analytics or automation.
6. Create the recommended issue views.
7. Create `CONTEXT` and `ADR` docx nodes in the Wiki space.
8. Write lightweight skeletons only; do not invent business facts or architecture decisions.
9. Write returned Wiki/Base/doc/table identifiers into the minimal local files.
10. Verify with read/list commands.

## Troubleshooting And Recovery

Use these recovery paths when operating Feishu resources from Windows or through `lark-cli`.

| Symptom | Recovery |
| --- | --- |
| `missing required scope(s)` | Use `lark-shared` split-flow with `auth login --scope "<scope>" --no-wait --json`; display the verification URL and QR code, then run `auth login --device-code <device_code>` after the user confirms. |
| Need to list/delete Base blocks | Request `base:block:read` for listing and `base:block:delete` for deletion. These are separate from table/view scopes. |
| Inline `--json` fails in PowerShell | Write the JSON to a relative `@file.json` payload and pass `--json @file.json`. Use this for view creation, filters, batch updates, and query DSL. |
| OAuth verification URL contains `&` and `.cmd` splits it | Treat the URL as opaque in user-facing output. For QR generation, prefer the documented `lark-shared` flow; if Windows `.cmd` parsing fails, call the PowerShell shim with `ExecutionPolicy Bypass` while preserving the original URL string. |
| `OpenAPIDeleteDashboard limited` | Confirm the dashboard has no blocks, then delete the dashboard through `+base-block-delete` instead of `+dashboard-delete`. |
| `OpenAPIUpdateViewFilter limited` | Retry `+view-set-filter` serially for that view, then verify the actual stored filter with `+view-get-filter`. |
| Query has `has_more=true` | Continue paging or switch to Base query/filter tooling; do not use the returned page as a full-table result. |

Recommended lightweight Base cleanup order:

1. Read dashboard list, dashboard block list, workflow list, and workflow definitions.
2. Delete only empty dashboards and disabled workflows with `steps=[]`.
3. Use `+dashboard-delete` first for dashboards; fall back to `+base-block-delete` when the dashboard API is limited.
4. Use `+base-block-list` to confirm exact block IDs before deleting workflows.
5. Verify `+base-block-list` contains only the `Issues` table and both `+dashboard-list` and `+workflow-list` return `total=0`.

Recommended view verification:

1. Use `+view-list` to confirm `Grid` plus the standard issue views exist.
2. Use `+view-get-filter` for each standard view; do not trust creation responses alone.
3. When the view will be used as an agent queue, optionally sample with `+record-list --view-id <view>` and confirm the result set matches the intended `Status` and `Resolution`.

## Verification

Check all of the following:

- Local file count stayed minimal unless the user requested more.
- Wiki space contains the mounted Base, `CONTEXT`, and `ADR`.
- Base has the `Issues` table and canonical `Status` options.
- Base does not contain empty default Dashboards or enabled unused Workflows.
- Base has the recommended issue views and each view has the expected filter.
- Local files contain resource locations and rules, not long project history.
- No app secret, access token, or tenant token was written.
