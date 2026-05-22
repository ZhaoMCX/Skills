# Codex Plan Mode Integration

Use Codex Plan Mode as the planning host for `af-plan-feature`.

## Allowed

- Read `XXXAgentFramework`, ModulePlan, Binding, docs, code, tests, configs, routes, scenes, and manifests.
- Run non-mutating inspections or tests that only refine the plan.
- Ask user questions for product intent and tradeoffs.
- Output one complete `<proposed_plan>`.

## Not Allowed

- Write files.
- Save plans.
- Edit code.
- Run formatters or generators that change tracked files.
- Execute implementation.

## Final Output

The final Plan Mode output is an AF Feature Plan wrapped in:

```text
<proposed_plan>
...
</proposed_plan>
```

After the user exits Plan Mode and approves, use `af-save-plan` and then `af-execute-plan` if implementation is requested.
