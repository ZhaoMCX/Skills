---
name: git-commit
description: Guides agents to create clean, atomic Git commits with consistent commit messages, reporting, optional confirmation, and optional small-step workflows. Use when the user asks to commit changes, prepare a Git commit, write a commit message, split commits, use incremental or small-step commits, or follow Git commit conventions.
---

# Git Commit

Use this skill when preparing local Git commits. It covers commit scope, atomicity, optional small-step commit workflows, staging, commit messages, optional confirmation, and completion reports. It does not cover push, pull requests, releases, or platform-specific workflows.

## First Move

Inspect before staging or committing:

```bash
git status --short
git diff
git diff --cached
```

Identify which changes belong to the user's current request. Treat existing unrelated changes as user-owned: do not revert, restage, or include them unless the user explicitly asks.

## Reference Map

- `references/small-step-commits.md`: optional incremental commit workflow and reporting.
- `references/commit-message.md`: type prefixes, summary rules, language choice, and examples.
- `references/confirmation.md`: when to ask before committing and what to show.

## Atomic Commit Rule

One commit should express one intent:

- It should be independently understandable.
- It should be independently revertible.
- It should be independently verifiable when practical.
- It should not mix features, fixes, refactors, formatting, dependency changes, tests, and docs unless they are inseparable.
- If changes must exist together to compile or pass tests, keep them in the same commit.
- If changes can be explained or reverted separately, split them into separate commits.

When commit-ready content contains multiple intents, split it into separate commits by default. Pause only when the correct split is ambiguous, the requested scope is unclear, or committing would risk including unrelated user-owned changes.

## Staging Rules

- Stage only files related to the current task.
- Prefer narrow staging over broad commands when unrelated changes exist.
- Review `git diff --cached` after staging.
- Never use destructive cleanup, reset, checkout, or restore commands to remove user changes unless the user explicitly requests that exact action.
- Do not commit generated, temporary, debug, credential, or environment files unless they are intentional project artifacts.

## Commit Execution

When the user asks to commit, stage only the relevant files, split commit-ready changes into atomic units, create the commit or commits, and report the result. Do not stop for confirmation by default.

Ask for confirmation before committing only when the user asks to review first, the commit scope is ambiguous, unrelated user-owned changes cannot be separated safely, or the commit would include generated, temporary, credential, environment, or unusually large files whose intent is unclear.

If the user already supplied an exact commit message and asked to commit, use that message for the relevant commit unless it conflicts with atomicity or the staged content.

## Completion Report

After a successful commit, report:

- commit hash
- commit message
- whether uncommitted changes remain

Do not push or create a pull request from this skill.
