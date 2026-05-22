# Option Framing

Use this only when there is a real tradeoff that affects architecture, AF ownership, public contracts, tests, or user-visible behavior.

## Rules

- Present 2-3 meaningful options, not filler.
- Recommend one default and explain why.
- Keep options at the responsibility and behavior level; do not write implementation code.
- If the answer can be inferred from the current `XXXAgentFramework`, ModulePlan, existing patterns, or tests, use the existing pattern instead of asking.
- Record the chosen option in `Decisions / Gray Areas Resolved`.

## Option Table

```md
| Option | Choose When | Tradeoff |
|---|---|---|
| A | | |
| B | | |
| C | | |
```

After the user chooses, convert the selected option into concrete Module, AF Element, BDD, and TDD obligations.
