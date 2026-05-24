# Plan Self-Review

Review the AF Feature Plan before presenting it.

## Checklist

- No `TBD`, `TODO`, placeholders, or unresolved implementation choices remain.
- The plan is weak-model executable: an implementer does not need to infer Module, AF Element, BDD behavior, test obligation, TDD order, write scope, or verification Gate.
- The plan satisfies the Minimum Effective Plan for its complexity level.
- The plan passes the Gray Area Gate; any remaining assumption is explicit, accepted, and carries a risk or verification consequence.
- `Primary Module` is explicit and normally unique.
- Cross-module collaboration names the mechanism: `UseCase`, `Event`, `Port`, `Result`, or `Surface composition`.
- BDD scenarios appear before AF element mapping and are partitioned by Module, with cross-module behavior in `跨模块场景`.
- Changed or relied-on AF responsibilities are covered by concrete AF Element rows under `AF 元素变动` or `跨模块 UseCase`.
- `AF Element` values are concrete names, not file paths and not abstract labels such as `Rules`, `UseCase`, or `Surface`.
- Concrete AF Element names reveal their type through the current Directory And Naming Binding.
- AF element changes are grouped first by Module and then by relevant AF type; empty AF type tables and routine N/A rows are not emitted.
- Any omitted AF type that could cause ownership, boundary, or verification ambiguity is explained with a short omission note.
- Any changed or relied-on route, page, component, scene, prefab, API endpoint, CLI command, editor entry, visible feedback, or user/system entry point appears as a concrete Surface row.
- Surface rows do not own business decisions that belong in Rules, UseCase, State, Ability, Controller, Port, or Adapter.
- Cross-module UseCases appear in `跨模块 UseCase`; other AF elements remain under their owning Module.
- BDD scenarios cover normal path, important failure path, and important no-side-effect guarantee when relevant.
- TDD Execution Slices are partitioned by Module, with cross-module slices in `跨模块切片`.
- TDD rows map concrete AF Elements to BDD scenarios, behaviors or risks, test type, test first, expected RED, minimal GREEN, refactor boundary, and verification Gate.
- Subagent Delegation Strategy either defines safe independent `af-dispatch-agents` tasks with AF role, Module, Element, TDD Slice, BDD Scenario, non-overlapping write scope, and verification, or states `No delegation` with a concrete reason.
- Write Scope and Forbidden Shortcuts prevent unrelated implementation.
- Verification Gates define real commands or explicit manual verification gates, and BDD/AF/TDD rows reference those Gate names.
- Required Documentation Updates contains only follow-up documentation candidates, not text that should be written during Plan Mode.
- Tables, omission notes, Option Framing, and Required Documentation Updates are present only when they reduce ambiguity, prevent responsibility drift, or guide verification.
- KISS was not used to remove responsibility ownership, BDD, TDD, review, or verification.
- Bugfix, regression, failing test, flaky behavior, or unexpected state requests are routed to `af-debug` instead of planned as normal feature work.

Fix any failure before outputting `<proposed_plan>`.
