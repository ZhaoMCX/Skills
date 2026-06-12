---
name: feishu-business-chain
description: Manages Feishu-backed PRDs, business chains, business rules, frontend/backend/end-to-end steps, vertical-slice tickets, defects, test batches, and evidence. Use when creating or reading PRDs, turning PRDs into business chains or tickets, developing from business chains, running frontend/backend business-chain tests, or writing acceptance evidence in Feishu.
---

# Feishu Business Chain

## Ground Rules

First follow `feishu-agent-knowledge-base`: Feishu is the official structured business fact source, local Markdown is for versioned engineering facts, official writes require confirmation, and Feishu unavailability blocks official completion.

Before official Feishu reads or writes, confirm the target project's declared `lark-cli` profile from project docs or explicit user instruction. Use `--profile <profile-name>` explicitly and default to `--as user` unless the project declares bot-only behavior or the target records are app-owned. If no profile is declared, draft or inspect only; do not create or update official PRDs, chains, tickets, defects, batches, or evidence.

Use `lark-doc`, `lark-base`, `lark-task`, and `lark-drive` for actual Feishu operations.

## Model

Use Feishu Doc + Base:

- Doc: human-readable PRD narrative, background, goals, scope, and discussion.
- Base: agent-executable PRD facts, business chains, rules, steps, tickets, defects, batches, status events, and evidence.

Required official objects must have stable IDs:

- PRD.
- Business chain.
- Business rule.
- Frontend step.
- Backend step.
- End-to-end step.
- Ticket.
- Test batch.
- Status event.
- Evidence issue.

Defects are a ticket subtype. Business rules are structured records associated with one or more business chains and steps.

## Required Views

Maintain these logical views even if the actual Feishu Base uses different table names:

- PRD facts: goal, audience, scope, non-goals, acceptance intent, linked chains.
- Business chains: business path, current status, owner, linked PRD, linked rules.
- Business rules: condition, rule statement, expected result, linked chains and steps.
- Frontend steps: page, user state, action, visual/interaction expectation, evidence.
- Backend steps: API, auth context, request contract, assertion, database/state evidence.
- End-to-end steps: cross-surface flow, environment, expected business outcome.
- Tickets: vertical business-chain slice, affected surfaces, repo/module, verification, status.
- Test batches: scope, environment, commands, result, linked steps and evidence.
- Evidence issues: missing proof, failed proof, visual issue, blocker, retest status.

## Workflows

### PRD To Business Chain

1. Read the PRD Doc and structured PRD facts.
2. Extract candidate business chains, rules, frontend steps, backend steps, end-to-end steps, and vertical-slice tickets.
3. Present a structured draft before writing, including the declared profile, identity, target Doc/Base, and records to create or update.
4. After confirmation, write official records and re-read them to verify stable IDs and links.

### Development From Business Chain

1. Read the business chain, rules, tickets, and relevant steps before implementation.
2. Use backend steps to derive domain model, state transitions, public APIs, admin APIs, and verification targets.
3. Use frontend steps to derive pages, states, actions, user feedback, visual evidence, and routing.
4. Code tests verify implementation against business-chain rules; they do not redefine the rules.
5. If implementation creates stable engineering facts, update local ADR, context, README, or module docs.

### Business-Chain Testing

1. Create or reuse a test batch.
2. Execute the smallest verification that proves each selected step.
3. Append status events; do not rewrite history to make it cleaner.
4. Update current statuses only after recording the event.
5. Add or close evidence issues.
6. Re-read changed records and report IDs, statuses, evidence, blockers, and next actions.

## Ticket Rules

- Default ticket granularity is a business-chain vertical slice.
- Each ticket must link to PRD, chain, rules, affected steps, repository/module when known, verification command, and status.
- Use subtasks only for team execution splits; the parent ticket remains the business completion unit.
- Defects, blockers, and retest work are ticket types, not separate unmanaged notes.

## Reporting

Report the Feishu Doc/Base used, object IDs touched, draft confirmation status, records created or updated, verification commands, evidence, blockers, and any local Markdown updates required by stable engineering facts.
