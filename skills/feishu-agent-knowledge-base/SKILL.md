---
name: feishu-agent-knowledge-base
description: Defines Feishu/Lark as an agent-friendly structured knowledge base and sets source-of-truth boundaries with local Markdown. Use when deciding where PRDs, business chains, tickets, defects, acceptance evidence, UI design systems, ADRs, or engineering docs should live, or before creating Feishu-backed workflow skills.
---

# Feishu Agent Knowledge Base

## Purpose

Feishu is the default source of truth for agent-executable business and project facts. Its first purpose is agent readability, execution, lookup, and writeback; team collaboration is the second purpose.

Local Markdown is the source of truth for engineering facts that must version with code.

## Project Profile

Feishu skills operate against the target project's fact source, not whichever user or profile happens to be active. Before any official Feishu read/write workflow, discover the target project's Feishu profile declaration from its `AGENTS.md`, `CONTEXT.md`, other project docs, or the user's explicit instruction.

- Official Feishu operations require a project-declared `lark-cli` profile.
- Pass the declared profile explicitly, for example `lark-cli.cmd --profile <profile-name> ...`.
- Default identity is user: prefer `--as user` unless the project declares bot-only behavior or the operation is app-owned.
- If no project profile is declared, do not create or update official PRDs, Base records, tasks, evidence, or UI design system facts. Draft locally, perform read-only checks, or ask the user to declare the profile.
- Recommended profile names are `personal`, `company-<short-name>`, and `client-<short-name>`.
- Recommended target-project declaration: `This project uses Feishu profile <profile-name> for official PRDs, business chains, UI design facts, tickets, and acceptance evidence. Default identity: user.`

## Source Of Truth

Use Feishu for structured, agent-facing facts:

- PRD and requirement facts.
- Business chains, business rules, frontend/backend/end-to-end steps.
- Tickets, defects, blockers, acceptance status, test batches, evidence issues.
- UI design system rules, structured UI assets, HTML visual examples, screenshot evidence.
- Meeting notes and business decisions before they become engineering facts.

Use local Markdown for versioned engineering facts:

- Final ADRs.
- `CONTEXT.md`, `CONTEXT-MAP.md`, `AGENTS.md`, and `README.md`.
- Build, deployment, module, API boundary, and repository operation docs.
- Code-coupled implementation notes that must diff, review, and rollback with code.

Do not mirror full Feishu PRDs, business chains, tickets, or design systems into local Markdown. Local docs may keep Feishu links, stable IDs, and engineering conclusions derived from Feishu facts.

## Required Invariants

- Official Feishu facts must be structured, numbered, statused, and linkable.
- Use stable IDs for PRDs, chains, rules, steps, tickets, batches, defects, evidence, design tokens, components, and page examples.
- Before creating or bulk-updating official Feishu records, present a structured draft and get confirmation.
- If Feishu is unavailable, do not mark PRD, chain, ticket, design system, or acceptance work as officially complete. You may draft, analyze, or diagnose locally, then backfill Feishu after it is available.
- Never copy tokens, secrets, private connection strings, passwords, or live credentials into Feishu or local docs.
- When Feishu facts produce stable engineering decisions, update the relevant local Markdown, such as ADR, context, README, module docs, or build/deploy docs.

## Tooling Boundary

This skill defines principles only. It does not replace Feishu operation skills.

Use the relevant `lark-*` skills for actual operations:

- `lark-doc` for Feishu documents and wiki documents.
- `lark-base` for structured Base tables and records.
- `lark-task` for Feishu task objects if a workflow explicitly uses them.
- `lark-drive` for files, attachments, and permissions.
- Other `lark-*` skills for mail, calendar, messages, approvals, or meetings.

Domain skills such as `feishu-business-chain` and `feishu-ui-design-system` must follow these rules and then define their own concrete models.
