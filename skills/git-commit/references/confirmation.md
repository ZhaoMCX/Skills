# Commit Confirmation

Ask for confirmation before committing only when:

- The user asks to review or confirm before committing.
- The commit scope is ambiguous.
- The staged or unstaged changes mix current-task changes with unrelated user-owned work and cannot be separated safely.
- The commit would include generated, temporary, credential, environment, or unusually large files whose intent is unclear.

When asking for confirmation, show:

```text
Files to commit:
- <path>

Commit message:
<type>: <summary>
```
