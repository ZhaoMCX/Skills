# AgentSkills

Personal Agent skill collection maintained as a source monorepo with folder-based topic packages and optional single-skill mirrors.

## Layout

```text
skills/<topic>/
  topic.toml
  AGENTS.md
  <skill-name>/
    SKILL.md
    agents/
    references/
    scripts/
```

Only `SKILL.md` is required for a skill. `topic.toml` is required for every topic folder.

## Topics

- [AgentFramework](skills/agent-framework) - AF workflow skills for planning, execution, debugging, review, verification, AF subagent dispatch, and AF handoff.
- [UnitySkills](skills/unity) - Unity-focused Agent skills for common Unity development workflows.
- [UniAppSkills](skills/uniapp) - uni-app Agent skills for App, H5, mini-program, and DCloud workflows.

## AgentFramework Skills

- [Using AgentFramework](skills/agent-framework/using-agent-framework) - Route AF work to the right workflow skill.
- [AgentFramework](skills/agent-framework/agent-framework) - Create, adapt, and review project-specific AgentFramework guides.
- [AF Create Framework](skills/agent-framework/af-create-framework) - Create or restructure technology-stack AgentFramework profiles and project bindings.
- [AF Update Framework](skills/agent-framework/af-update-framework) - Update existing AgentFramework documents after project learning or feature work.
- [AF Plan Feature](skills/agent-framework/af-plan-feature) - Scope features and produce AF Feature Plans before implementation.
- [AF Save Plan](skills/agent-framework/af-save-plan) - Persist approved AF Feature Plans after Plan Mode ends.
- [AF Execute Plan](skills/agent-framework/af-execute-plan) - Implement approved AF Feature Plans with TDD slices and ownership constraints.
- [AF Debug](skills/agent-framework/af-debug) - Reproduce, investigate, and fix defects in AF projects.
- [AF Review](skills/agent-framework/af-review) - Review changes against AF boundaries, plans, and module ownership.
- [AF Verify Completion](skills/agent-framework/af-verify-completion) - Verify AF work before claiming it is complete or ready.
- [AF Dispatch Agents](skills/agent-framework/af-dispatch-agents) - Delegate AF-scoped work to subagents.
- [AF Handoff](skills/agent-framework/af-handoff) - Prepare AF continuation notes for another session or agent.

## Install

Install all skills into the local Codex skills directory:

```powershell
.\scripts\install.ps1
```

Install one topic:

```powershell
.\scripts\install.ps1 -Topic agent-framework
```

Install one skill:

```powershell
.\scripts\install.ps1 -Skill af-plan-feature
```

## Topic Repositories

The source of truth is this repository. Topic repositories are generated from `skills/<topic>` folders. Topic membership and repository targets are managed by each topic's `topic.toml`; there is no root `topics.json`.

Generate a topic repository workspace:

```powershell
.\scripts\export-topic.ps1 -Topic agent-framework
.\scripts\export-topic.ps1 -Topic unity
.\scripts\export-topic.ps1 -Topic uniapp
```

Legacy aliases such as `AgentFramework`, `UnitySkills`, and `UniAppSkills` remain accepted by scripts.

Clone or update all topic repository workspaces on a machine:

```powershell
.\scripts\sync-topics.ps1
```

Publish one topic repository from this source repository:

```powershell
.\scripts\publish-topic.ps1 -Topic unity
```

Publish every topic repository:

```powershell
.\scripts\publish-all-topics.ps1
```

Generated and synced topic workspaces live under `dist/topics/`. The directory is intentionally ignored because it is a local publish workspace, not source content.

## Notes

Unity `.meta` files are intentionally excluded. These repositories package Codex skills, not Unity assets.
