# AgentFramework Topic Rules

- AF work should route through `using-agent-framework`.
- AF subagent delegation belongs to `af-dispatch-agents`, not a generic delegation skill.
- AF continuation belongs to `af-handoff`, not a generic handoff skill.
- AF subagents should know general AF concepts, but project-specific `XXXAgentFramework`, Binding, ModuleMap, AF Feature Plan, Module, AF Element, TDD Slice, BDD Scenario, Write Scope, Forbidden Shortcuts, and Verification Gate must be provided in each dispatch prompt.
- Main agents remain responsible for integration, AF review, and final verification. Subagent evidence never replaces those gates.
