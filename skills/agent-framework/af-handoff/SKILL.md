---
name: af-handoff
description: Use when AgentFramework work must continue in another session, another agent, or a future continuation after AF planning, implementation, debugging, review, verification, or framework updates.
---

# AF Handoff

Create a compact AgentFramework continuation document so a fresh agent can continue without replaying the full conversation.

## Purpose

Reference durable AF artifacts instead of duplicating them. Preserve the current goal, AF workflow state, Module and Element progress, decisions, verification status, blockers, and the next suggested AF skill.

## Destination

Save handoff documents outside the project workspace unless the user asks for a project artifact. Prefer the OS temporary directory for ephemeral handoff.

## Include

```md
# AF Handoff

## Current Goal

## Active Framework Artifacts
- XXXAgentFramework:
- Directory And Naming Binding:
- ModuleMap / ModulePlan:
- AF Feature Plan:
- Other durable docs:

## Current AF Workflow State
- Current skill:
- Suggested next AF skill:
- Planned / InProgress / Implemented / Reviewed / Verified / Blocked:

## Module / Element Progress
- Primary Module:
- Related Modules:
- AF Elements changed or relied on:
- TDD Slices:
- BDD Scenarios:

## Work Context
- Allowed write areas:
- Forbidden areas:
- Forbidden Shortcuts:
- ModulePlan dependency constraints:

## Decisions Already Made

## Tests And Verification
- RED evidence:
- GREEN evidence:
- Review evidence:
- Verification evidence:
- Failing / not run:

## Subagent State
- Delegated tasks:
- Accepted outputs:
- Rejected outputs:
- Remaining risks:

## Open Questions / Blockers

## Sensitive Info Redaction Notes
```

## Rules

- Do not duplicate full AF Feature Plans, framework docs, ADRs, tests, or logs when a path or URL can reference them.
- Do not treat an AF handoff as a replacement for an AF Feature Plan, review, verification, or framework update.
- Include the next suggested AF skill so continuation starts in the right workflow.
- Redact secrets, API keys, credentials, private tokens, and personal data.
- Keep the handoff short enough for a fresh agent to read first.
