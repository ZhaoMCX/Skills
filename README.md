# AgentSkills

Personal Agent skill collection maintained as a source monorepo with optional topic repositories and single-skill mirrors.

## Skills

- [AF Create Framework](skills/af-create-framework) - Create or restructure technology-stack AgentFramework profiles and project bindings.
- [AF Debug](skills/af-debug) - Reproduce, investigate, and fix defects in AgentFramework projects.
- [AF Execute Plan](skills/af-execute-plan) - Implement approved AF Feature Plans with TDD slices and ownership constraints.
- [AF Plan Feature](skills/af-plan-feature) - Scope features and produce AF Feature Plans before implementation.
- [AF Review](skills/af-review) - Review changes against AF boundaries, plans, and module ownership.
- [AF Save Plan](skills/af-save-plan) - Persist approved AF Feature Plans after Plan Mode ends.
- [AF Update Framework](skills/af-update-framework) - Update existing AgentFramework documents after project learning or feature work.
- [AF Verify Completion](skills/af-verify-completion) - Verify AF work before claiming it is complete or ready.
- [AgentFramework](skills/agent-framework) - Create, adapt, and review project-specific AgentFramework guides.
- [Dispatch Agents](skills/dispatch-agents) - Delegate independent work to subagents when scopes do not overlap.
- [Handoff](skills/handoff) - Prepare continuation notes for another session or agent.
- [UniApp Development](skills/uniapp-development) - Work with uni-app, uni-app x, DCloud, HBuilderX, and mini-program targets.
- [Using AgentFramework](skills/using-agent-framework) - Route AgentFramework work to the right AF workflow skill.
- [WeChat MiniProgram DevTools](skills/wechat-miniprogram-devtools) - Use official WeChat DevTools CLI and miniprogram-automator workflows.
- [Unity DOTween](skills/unity-dotween) - Implement, review, and debug DOTween animation workflows in Unity.
- [Unity Odin](skills/unity-odin) - Use Odin Inspector and Sirenix Serializer workflows in Unity.

## Layout

```text
skills/<skill-name>/
  SKILL.md
  agents/
  references/
  scripts/
```

Only `SKILL.md` is required. Other folders are included when a skill needs them.

## Install

Install all skills into the local Codex skills directory:

```powershell
.\scripts\install.ps1
```

Install one skill:

```powershell
.\scripts\install.ps1 -Skill agent-framework
```

## Mirrors

The source of truth is this repository. Topic repositories are generated from groups of skills for easier discovery and sharing.

Generate a topic repository workspace:

```powershell
.\scripts\export-topic.ps1 -Topic AgentFramework
.\scripts\export-topic.ps1 -Topic UnitySkills
.\scripts\export-topic.ps1 -Topic UniAppSkills
```

Single-skill mirrors can still be generated from `skills/<skill-name>` when a skill needs independent distribution.

## Notes

Unity `.meta` files are intentionally excluded. These repositories package Codex skills, not Unity assets.
