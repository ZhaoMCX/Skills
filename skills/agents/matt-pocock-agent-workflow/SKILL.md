---
name: matt-pocock-agent-workflow
description: Routes repository work across Matt Pocock engineering skills and project agent docs without replacing the individual skills. Use when deciding whether to run setup-matt-pocock-skills, to-prd, to-issues, triage, diagnose, tdd, grill-with-docs, improve-codebase-architecture, or zoom-out; when a request spans multiple of those workflows; or when implementing an issue end to end.
---

# Matt Pocock Agent Workflow

Use this skill to choose and sequence Matt Pocock-style engineering skills. It is a router and coordinator: once the right individual skill is obvious, load that skill and follow its instructions.

## Trigger Rules

Use this skill when the user asks to:

- Turn a conversation, idea, plan, or spec into a PRD or implementation issues.
- Create, classify, review, move, or prepare issues for a human or agent.
- Implement an issue end to end from issue context through verification and tracker update.
- Diagnose a bug, regression, broken behavior, or failing test when issue workflow or project docs may matter.
- Use TDD, red-green-refactor, integration tests, or a test-first implementation flow.
- Improve architecture, reduce coupling, clarify domain boundaries, or make code easier for agents to navigate.
- Zoom out on unfamiliar code before planning or changing it.
- Decide which Matt Pocock engineering skill should handle a request.

Do not use this skill just because a task mentions code, docs, or tests. If the user directly invokes one specific skill and no routing is needed, use that skill directly.

## First Move

Check whether the current repository is configured for agent skills:

- `## Agent skills` in `AGENTS.md` or equivalent agent instructions.
- `docs/agents/issue-tracker.md`.
- `docs/agents/triage-labels.md`.
- `docs/agents/domain.md` or another documented domain-doc layout.

If any of these are missing, use or suggest `setup-matt-pocock-skills` before running PRD, issue, triage, diagnosis, TDD, architecture, or zoom-out workflows.

## Skill Router

- Use `setup-matt-pocock-skills` before the first engineering workflow in an unconfigured repo, or when the issue tracker, triage labels, or domain-doc layout are unclear.
- Use `to-prd` when turning a discussion, idea, or rough requirement into a PRD.
- Use `grill-with-docs` before `to-prd` when domain language, boundaries, ownership, or decisions are unclear.
- Use `to-issues` when splitting a PRD, plan, or specification into implementation issues.
- Use `triage` when creating, classifying, moving, checking, or preparing issues for a human or agent.
- Use `diagnose` when fixing bugs, failing tests, broken behavior, regressions, or reports that something is wrong.
- Use `tdd` when the user requests test-first work, red-green-refactor, public behavior tests, or a high-risk implementation.
- Use `improve-codebase-architecture` when the task asks for architecture improvement, refactoring opportunities, coupling reduction, testability, or clearer domain boundaries.
- Use `zoom-out` when unfamiliar code needs broader context before planning, diagnosing, or changing it.

## Issue Implementation Workflow

When implementing an issue:

1. Read the issue and the repository agent configuration.
2. Confirm the issue is actionable; if it has not been triaged for agent readiness, use `triage` before implementation. Do not treat a freshly written issue as ready merely because it has a `ready-for-agent` status line.
3. Choose the implementation skill path: usually `tdd`, `diagnose`, or a project-specific technical skill.
4. Before changing implementation files, update or append to the issue tracker when the repository convention requires start notes, assignment notes, or an agent brief.
5. Implement the smallest vertical slice that satisfies the acceptance criteria.
6. Verify with relevant tests, builds, or manual checks.
7. Immediately update the issue according to `docs/agents/issue-tracker.md` with implementation summary, verification results, residual risk, and related follow-up tickets. Do this before the final user-facing summary.

Do not hard-code issue statuses, completion rules, or label meanings. Follow the current repository's agent docs. If no completion convention exists, at minimum add an implementation summary, test results, residual risk, and related commit information under the issue's comment/history section.

## Issue Tracker Hygiene

- `to-issues` creates candidate work; `triage` prepares, classifies, and checks those issues for human or agent execution. Do not skip `triage` when the next step is handing an issue to an agent or beginning implementation.
- Keep the issue tracker as the durable source of workflow truth. User-facing chat summaries do not replace issue comments, status updates, agent briefs, or test-result notes.
- When a local markdown tracker records state in a `Status:` line, preserve the repository's configured state vocabulary and add progress details under `## Comments` rather than inventing ad-hoc statuses.
- If the tracker lacks a completion state, keep the configured state line intact unless the repository docs say otherwise, and append a clear implemented/verified note with tests run and any remaining risks.
- When publishing issues from a PRD, show or internally validate dependency order, HITL/AFK suitability, and readiness. If issues were already published without that review, run `triage` as the next step to repair the workflow.

## Issue Splitting

When converting plans into issues, prefer tracer-bullet vertical slices:

- Each issue should be independently understandable.
- Each issue should produce observable value or reduce concrete risk.
- Each issue should identify dependencies and human-in-the-loop needs.
- Ask the user to confirm granularity, dependencies, and HITL/AFK markers before publishing issues.

## Communication

Name the Matt Pocock skill path being used in a short update, then keep the work moving. Combine skills when the task naturally crosses boundaries, but keep the active set minimal.
