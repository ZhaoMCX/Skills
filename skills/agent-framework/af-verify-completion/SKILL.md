---
name: af-verify-completion
description: Use before claiming AgentFramework work is complete, fixed, implemented, reviewed, or ready to ship.
---

# AF Verify Completion

Completion requires evidence, not confidence.

## Verification Inputs

Read the current `XXXAgentFramework`, relevant AF Feature Plan, and project scripts to identify required commands.

## Required Evidence

Report the command and result for each applicable category:

- Data / Schema tests.
- State Transition tests.
- Rules tests.
- UseCase tests.
- Event Flow tests.
- Boundary / Port / Adapter tests.
- Ability tests.
- Controller tests.
- Surface tests.
- Regression tests.
- Typecheck, lint, build, PlayMode, route/UI, scene/prefab, or platform-specific checks listed by the project.
- BDD acceptance scenario coverage.
- TDD slice verification evidence, including RED/GREEN evidence when available in the current session.

## Rules

- Do not claim completion if planned verification was not run.
- Do not let review substitute for verification, or verification substitute for AF boundary review.
- If verification cannot run, state exactly why and what risk remains.
- If verification fails, stop and use `af-debug` or continue implementation as appropriate.
- Completion Evidence in the plan should be updated only after real commands pass.

## AF Verification Sidecars

Use `af-dispatch-agents` with `verification_runner` when independent verification commands can run in parallel without mutating shared source files. The prompt must include the exact command, expected result, relevant AF Feature Plan Gate, working directory, and evidence format.

The main agent must read the output, decide whether it proves the Gate, and report final completion evidence. Do not forward a sidecar success report without independent inspection.
