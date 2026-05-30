# Small-Step Commits

Small-step commits are an optional development mode, not the default. Use this mode only when the user explicitly asks for small-step commits, incremental commits, frequent commits, progress commits, or automatic commits after each committable unit.

In small-step commit mode, after finishing each committable unit, check whether it should become a commit now. A small-step commit is a complete, atomic unit that is independently understandable, revertible, and verifiable when practical.

Use small-step commits to make commit history useful as development progress, development documentation, and a user-visible control surface for pacing the work when the user wants that workflow.

- Do not enable small-step commit mode unless the user explicitly asks for it.
- Do not commit unfinished work just to record activity.
- Do not use small-step commits to bypass staging review, diff review, secret checks, generated-file checks, or the atomic commit rule.
- When small-step commit mode is enabled, commit each finished unit after reviewing the staged diff, then report the commit hash, commit message, and whether uncommitted changes remain.
- If the user explicitly authorizes automatic small-step commits, commit each finished unit without asking again, then immediately report the commit hash, commit message, and whether uncommitted changes remain.
- If the user's requested pace conflicts with atomicity or repository safety, prefer atomicity and safety, then explain the tradeoff.
