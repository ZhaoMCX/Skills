# Requirement Grilling

Interrogate the request until the feature can be planned without guessing. This is a required planning gate, not optional conversation.

## Rules

- Ask only questions that change implementation, tests, AF ownership, acceptance, or scope.
- Ask one blocking question at a time.
- Give a recommended answer with each question.
- Prefer concrete scenarios and counterexamples over abstract questions.
- Do not ask questions that can be answered by reading `XXXAgentFramework`, ModulePlan, Binding, docs, code, routes, scenes, tests, configs, or manifests.
- Stop grilling only when no unresolved gray area would affect implementation, tests, AF ownership, acceptance, scope, write boundaries, or verification.
- KISS does not mean asking fewer necessary questions. It means asking only questions that remove real ambiguity.

## Challenge Prompts

Use the smallest set needed:

- What must be true for the user or system to consider this successful?
- What is explicitly not part of this feature?
- What input, state, permission, timing, route, scene, or lifecycle condition should reject the action?
- What must not change when the action is rejected?
- Which behavior would surprise a future maintainer if not written down?
- Which AF Element should own the decision: Rule, UseCase, Surface, Ability, Controller, Port, or Adapter?
- What concrete example would prove the boundary is correct?
- What verification result would prove a weaker model finished the right behavior?

## Output

Resolved answers go into:

```md
## Decisions / Gray Areas Resolved
| Question | Decision | Reason |
|---|---|---|
```
