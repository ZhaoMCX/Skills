---
name: setup-matt-pocock-skills-feishu
description: Extends setup-matt-pocock-skills with a Feishu/Lark implementation pattern for issue tracking and domain docs. Use when running or discussing setup-matt-pocock-skills and the repo should use Feishu/Lark Wiki, Base, CONTEXT, or ADR instead of GitHub/GitLab/local markdown.
---

# Setup Matt Pocock Skills: Feishu Companion

## Quick Start

Use this skill only as a companion to `setup-matt-pocock-skills`.

1. Read and follow `setup-matt-pocock-skills` first.
2. When the user chooses Feishu/Lark for issue tracking or domain docs, apply this companion pattern.
3. Keep the same minimal local output:
   - `AGENTS.md` or `CLAUDE.md`
   - `docs/agents/issue-tracker.md`
   - `docs/agents/triage-labels.md`
   - `docs/agents/domain.md`

## Core Pattern

- Feishu Wiki space is the project knowledge home.
- A Feishu Base named like `Issue Tracker / Backlog` is mounted under that Wiki space.
- Base records are the source of truth for issues, PRDs, backlog items, triage state, and agent work logs.
- Base `Status` stores only the five canonical triage roles.
- Base `Resolution` stores issue open/closed state and close reason; new issues default to `unresolved`.
- Base `Type` stores the `$to-issues` execution mode only: `AFK` or `HITL`.
- Base `Parent` stores structural source or parent issue; it is not a prerequisite.
- Base `Depends On` stores issue prerequisites; `Blocks` is the automatic reverse relationship.
- Base `What to build`, `User Stories Covered`, and `Acceptance Criteria` store `$to-issues` template content.
- Base `Agent Notes` stores execution notes, migration notes, exceptions, and handoff context only.
- Base fields should have Chinese descriptions that explain each field's role; put workflow-critical fields first in views.
- Feishu Base defaults to a lightweight issue tracker: do not keep empty default Dashboards or disabled empty Workflows.
- Create standard agent entry views for open work, ready-for-agent work, human handoff, needs-info, and closed issues.
- Feishu `CONTEXT` and `ADR` documents live in the Wiki space.
- The repo does not keep full `CONTEXT.md` or `docs/adr/` copies unless the user explicitly wants local docs.
- Local `docs/agents/*.md` files store only agent-readable rules, links, tokens, field names, and read/write conventions.

## To-Issues Semantics

- Do not use `Type` for `feature`, `research`, `prd`, or similar work categories.
- Use `Type=AFK` when an agent can implement and verify the slice independently.
- Use `Type=HITL` when the slice needs human confirmation, review, external integration, or a decision.
- Use `Parent` to point to the PRD, epic, or source issue that produced the slice.
- Use `User Stories Covered` for PRD story IDs or ranges, such as `3-12`.
- Keep `Description` for background summary and extra context; keep `What to build` for the end-to-end slice.
- Do not put `AFK/HITL`, story IDs, or template body content into `Agent Notes`.

## Closure Semantics

- Do not add `done` or `closed` to `Status`; keep `Status` compatible with the original triage roles.
- Treat `Resolution=unresolved` as open.
- Treat `Resolution=done`, `wontfix`, `duplicate`, or `superseded` as closed.
- For local markdown compatibility, keep `Status:` for triage and add `Resolution: unresolved` near the top; when closed, optionally add `Closed At: YYYY-MM-DD`.

## Dependency Semantics

- Use `Depends On` for issues that must be done before the current issue can start.
- Use a bidirectional Base link so `Blocks` shows reverse dependencies automatically.
- Agents write only `Depends On`; never hand-maintain `Blocks`.
- Keep `Parent` and `Depends On` separate; parent hierarchy does not control startability.
- An issue can start only when `Status=ready-for-agent`, `Resolution=unresolved`, and all `Depends On` issues have `Resolution=done`.

## Field Layout

- Give every Base field a Chinese description that states what the field is for and how agents should use it.
- Put important workflow fields first in table views: `Title`, `Status`, `Resolution`, `Type`, `Parent`, `Depends On`, then priority, owner, module, `What to build`, `User Stories Covered`, acceptance, context, notes, links, and system timestamps.
- Keep `Blocks` documented as the reverse dependency field even when Feishu exposes it only through the bidirectional link configuration.
- Keep the default `Grid` view as the all-record view.
- Add standard grid views: `Open Issues`, `Ready for Agent`, `Ready for Human`, `Needs Info`, and `Closed Issues`.
- Standard issue views must filter `Item Kind=Issue`; open views require `Resolution=unresolved`; closed views include `Resolution=done/wontfix/duplicate/superseded`.

## Operational Guardrails

- On Windows PowerShell, put complex Base JSON in `@file.json` payload files instead of inline `--json` strings.
- If user identity is missing a Feishu scope, follow `lark-shared` split-flow: run `auth login --scope "..." --no-wait --json`, show the original verification URL and QR code, then run `auth login --device-code <device_code>` after the user confirms authorization.
- Base block listing and deletion require separate scopes such as `base:block:read` and `base:block:delete`.
- If `+dashboard-delete` returns `OpenAPIDeleteDashboard limited`, retry deletion through `+base-block-delete` after confirming the dashboard is empty.
- Before deleting Base Dashboard or Workflow defaults, verify Dashboard blocks are empty and Workflow is disabled with `steps=[]`.
- Create views first, then set filters with `+view-set-filter`; if Feishu returns `OpenAPIUpdateViewFilter limited`, retry serially and verify with `+view-get-filter`.
- For full-table conclusions, read all pages or confirm `has_more=false`; do not infer global state from a default page.

## Setup Flow

1. Confirm Feishu/Lark is the chosen tracker or domain-doc host.
2. Decide whether to create real Feishu resources or only write local rules.
3. If creating resources, use user identity by default and the relevant `lark-*` skills.
4. Create or locate one Wiki space, one mounted Base, one `Issues` table, one `CONTEXT` document, and one `ADR` index document.
5. Delete empty default Dashboards and disabled empty Workflows unless the user explicitly wants Base analytics or automation.
6. Create the standard issue views listed in Field Layout.
7. Write the minimal local setup files using the returned Feishu identifiers.
8. Verify that the local files do not contain app secrets, access tokens, or project-irrelevant history.

## References

- See [REFERENCE.md](REFERENCE.md) for decisions, resource conventions, and verification rules.
- See [EXAMPLES.md](EXAMPLES.md) for generic local-file snippets.
