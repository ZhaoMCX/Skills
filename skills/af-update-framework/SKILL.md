---
name: af-update-framework
description: Use when an existing XXXAgentFramework, Binding, ModulePlan, glossary, boundary list, dependency rule, or verification command needs to change after project learning or feature work.
---

# AF Update Framework

Update durable AgentFramework knowledge only when it will reduce future agent confusion or prevent repeated mistakes.

## Update Triggers

- New or renamed Module.
- New stable domain term or terminology conflict.
- New Boundary, Port, Adapter, Surface kind, Ability, or Controller pattern.
- New dependency rule, forbidden dependency, generated-file rule, or write scope.
- New verification command or changed test runner.
- Repeated implementation mistake caused by missing AF guidance.
- Feature work reveals the existing `XXXAgentFramework` is wrong or incomplete.

## Workflow

1. Read the current `XXXAgentFramework`, Binding, ModulePlan, and relevant plan or review notes.
2. Identify the smallest durable update.
3. Prefer updating existing sections over adding new documents.
4. Add only stable guidance, not one-off feature detail.
5. Preserve canonical AF role names.
6. Re-check that the framework answers Module ownership, AF element ownership, boundaries, write scope, and verification commands.

## Avoid

- Capturing temporary implementation notes.
- Adding abstractions or rules because they feel tidy.
- Updating the framework to match a bad implementation instead of correcting the implementation.
- Duplicating plan details that belong in an AF Feature Plan.
