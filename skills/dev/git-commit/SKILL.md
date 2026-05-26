---
name: git-commit
description: Guides agents to create clean, atomic Git commits with consistent commit messages and pre-commit confirmation. Use when the user asks to commit changes, prepare a Git commit, write a commit message, split commits, or follow Git commit conventions.
---

# Git Commit

Use this skill when preparing local Git commits. It covers commit scope, atomicity, staging, commit messages, and confirmation. It does not cover push, pull requests, releases, or platform-specific workflows.

## First Move

Inspect before staging or committing:

```bash
git status --short
git diff
git diff --cached
```

Identify which changes belong to the user's current request. Treat existing unrelated changes as user-owned: do not revert, restage, or include them unless the user explicitly asks.

## Atomic Commit Rule

One commit should express one intent:

- It should be independently understandable.
- It should be independently revertible.
- It should be independently verifiable when practical.
- It should not mix features, fixes, refactors, formatting, dependency changes, tests, and docs unless they are inseparable.
- If changes must exist together to compile or pass tests, keep them in the same commit.
- If changes can be explained or reverted separately, split them into separate commits.

When staged content contains multiple intents, pause and propose a split plan. Do not combine multiple intents into one commit without user confirmation.

## Staging Rules

- Stage only files related to the current task.
- Prefer narrow staging over broad commands when unrelated changes exist.
- Review `git diff --cached` after staging.
- Never use destructive cleanup, reset, checkout, or restore commands to remove user changes unless the user explicitly requests that exact action.
- Do not commit generated, temporary, debug, credential, or environment files unless they are intentional project artifacts.

## Commit Message Format

Default format:

```text
<type>: <summary>
```

Optional scope:

```text
<type>(<scope>): <summary>
```

Allowed types:

- `feat`: user-facing feature or capability
- `fix`: bug fix
- `refactor`: behavior-preserving code restructuring
- `docs`: documentation-only change
- `test`: tests or test infrastructure
- `chore`: maintenance task that does not fit another type
- `style`: formatting or stylistic change without behavior change
- `perf`: performance improvement
- `build`: build system, dependency, or packaging change
- `ci`: CI configuration or pipeline change
- `revert`: revert a previous commit

Summary rules:

- Keep the type prefix in English.
- Match the summary language to the user conversation or explicit user request.
- In Chinese conversations, a Chinese summary is fine, for example `fix: 修复登录状态丢失`.
- Describe the result, not the process.
- Keep it one line, concise, and without a trailing period.
- Avoid vague summaries such as `update`, `misc`, `changes`, or `优化代码`.

## Confirmation Before Commit

Before running `git commit`, show the user:

```text
Files to commit:
- <path>

Commit message:
<type>: <summary>
```

Commit only after explicit user confirmation. If the user already supplied an exact commit message and asked to commit, still confirm the staged file list unless the instruction clearly authorizes immediate commit.

## Completion Report

After a successful commit, report:

- commit hash
- commit message
- whether uncommitted changes remain

Do not push or create a pull request from this skill.
