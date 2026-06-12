# Commit Messages

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
