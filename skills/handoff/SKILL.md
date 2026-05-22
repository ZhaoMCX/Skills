---
name: handoff
description: Use when handing work to another session, another agent, or a future continuation after planning, partial implementation, debugging, review, verification, or investigation.
---

# Handoff

Create a compact continuation document so a fresh agent can continue without replaying the full conversation.

## Purpose

Summarize current work by referencing durable artifacts instead of duplicating them. Preserve goal, state, decisions, verification status, blockers, and the suggested next workflow.

## Destination

Save handoff documents outside the project workspace unless the user asks for a project artifact. Prefer the OS temporary directory for ephemeral handoff.

## Include

```md
# Handoff

## Current Goal

## Relevant Artifacts
- Plans / specs:
- Docs / ADRs / issues:
- Commits / diffs:
- Logs / screenshots:

## Current Status
- Planned / InProgress / Implemented / Verified / Blocked:

## Work Context
- Ownership / scope:
- Allowed write areas:
- Forbidden areas:

## Decisions Already Made

## Tests And Verification
- Passed:
- Failing:
- Not run:

## Open Questions / Blockers

## Suggested Next Workflow Or Skill

## Sensitive Info Redaction Notes
```

## Rules

- Do not duplicate content already captured in durable artifacts. Link paths or URLs instead.
- Redact secrets, API keys, credentials, private tokens, and personal data.
- Keep the handoff short enough for a fresh agent to read first.
- Include the next suggested workflow or skill so continuation starts in the right place.
