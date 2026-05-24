# Global Agent Rules

- Use local skills/files first. Do not start, request, suggest, or ask about Superpowers/supperpowers URL services unless the user explicitly requests them, or the task cannot be completed without them and you explain why.
- Treat `using-agent-framework` as the local AgentFramework entrypoint for AF workflow routing; do not invoke `using-superpowers` by default.
- In Plan mode, write plans primarily in Chinese unless the user asks otherwise.
- Do not create git branches or git worktrees unless the user explicitly asks for them.

## Encoding Rules

- Default all new or edited text files to UTF-8.
- When writing non-ASCII text, prefer `apply_patch` or language-native file APIs with explicit UTF-8 encoding.
- Avoid `echo > file`, `cmd /c`, batch redirection, or shell redirection for writing non-ASCII text.
- In PowerShell, read/write text with explicit encoding, such as `Get-Content -Encoding UTF8`, `Set-Content -Encoding utf8`, and `Out-File -Encoding utf8`.
- In Python, use `encoding="utf-8"` for text file reads and writes.
- In Node.js, use `"utf8"` for text file reads and writes.
- Before overwriting existing non-ASCII files, check whether they are UTF-8, GBK/ANSI, or another encoding; preserve the original encoding unless conversion is intentional.
- If text looks garbled in a terminal, verify whether the file bytes are actually corrupted before rewriting it.

## Testing Style Overlay

- For TDD, keep RED -> GREEN -> refactor discipline.
- Write behavior-focused BDD-style tests with Given/When/Then or Arrange/Act/Assert for non-trivial cases.
- Assert observable behavior, not private implementation details.
- Do not add Cucumber, Gherkin, or a new BDD framework unless already used or explicitly requested.
