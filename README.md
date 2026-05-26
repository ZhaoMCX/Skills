# Skills

Personal Codex skills maintained as a single repository with lightweight, Matt Pocock-style skill folders.

## Layout

```text
skills/<category>/<skill-name>/
  SKILL.md
  references/
  scripts/
```

Only `SKILL.md` is required. Categories organize source files only; installed skills are copied directly into the local Codex skills directory by skill name.

## Skills

### Dev

- [Git Commit](skills/dev/git-commit) - Guide atomic Git commits, staging checks, commit message conventions, and pre-commit confirmation.

### Game

- [Game Structure](skills/game/game-structure) - Place gameplay logic into Module, Data, State, Rule, Ability, UseCase, Result, Surface, and Adapter responsibilities.

### Ops

- [Server Operation Guardrails](skills/ops/server-operation-guardrails) - Apply safety rules for SSH, production/staging servers, Nginx/TLS, databases, firewalls, deployments, and other remote operations.

### RuoYi

- [RuoYi Framework](skills/ruoyi/ruoyi-framework) - 处理经典若依单体项目，覆盖 Spring Boot、Shiro、Thymeleaf、MyBatis XML、Druid、Quartz 和内置代码生成器。
- [RuoYi Vue](skills/ruoyi/ruoyi-vue) - 处理若依前后端分离 Vue2 项目族，覆盖 Spring Security/JWT 后端和 Vue2/Element UI 前端。
- [RuoYi Vue3](skills/ruoyi/ruoyi-vue3) - 处理若依 Vue3 独立前端项目，覆盖 Vite、Element Plus、Pinia、动态路由和权限指令。
- [RuoYi Cloud](skills/ruoyi/ruoyi-cloud) - 处理若依微服务项目族，覆盖 Gateway、Auth、Nacos、Feign、Redis、Sentinel、Seata 和多模块服务。
- [RuoYi App](skills/ruoyi/ruoyi-app) - 处理若依移动端 App 模板，覆盖 uni-app Vue2、token 登录、请求封装、导航拦截和后端对接。

### Unity

- [Unity DOTween](skills/unity/unity-dotween) - Implement, review, and debug Unity DOTween animation safely.
- [Unity FishNet](skills/unity/unity-fishnet) - Implement, review, and debug FishNet networking.
- [Unity Odin](skills/unity/unity-odin) - Work with Odin Inspector and Sirenix Serializer.
- [Unity Steamworks.NET](skills/unity/unity-steamworks-net) - Integrate and debug Steamworks.NET in Unity.
- [Unity TapTap SDK](skills/unity/unity-taptap-sdk) - Integrate and debug TapTap SDK in Unity.

### UniApp

- [UniApp Development](skills/uniapp/uniapp-development) - Work on uni-app, uni-app x, DCloud, H5, app, and mini-program projects.

### WeChat

- [WeChat Mini Program DevTools](skills/wechat/wechat-miniprogram-devtools) - Use official WeChat DevTools CLI and miniprogram-automator workflows.

## Sync

Use these scripts for the two common sync directions.

Sync repository skills to the local global Codex skills directory:

```powershell
.\scripts\sync-to-global.ps1
```

Sync global skills back into this repository for skills that already exist in the repository:

```powershell
.\scripts\sync-from-global.ps1
```

`sync-from-global.ps1` skips Agent-specific `agents/` metadata by default so the repository stays cross-agent. Pass `-IncludeAgentMetadata` only when a skill intentionally stores Agent-specific UI metadata.

Sync one category:

```powershell
.\scripts\sync-to-global.ps1 -Category unity
.\scripts\sync-from-global.ps1 -Category unity
```

Sync one skill:

```powershell
.\scripts\sync-to-global.ps1 -Skill game-structure
.\scripts\sync-from-global.ps1 -Skill game-structure
```

## Install

Install all skills into the local Codex skills directory:

```powershell
.\scripts\install.ps1
```

Install one category:

```powershell
.\scripts\install.ps1 -Category unity
```

Install one skill:

```powershell
.\scripts\install.ps1 -Skill game-structure
```

`install.ps1` is kept as the backward-compatible name for repository-to-global sync. Prefer `sync-to-global.ps1` for new routine usage.

## Validate

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\validate-skills.ps1
```

## Notes

Unity `.meta` files are intentionally excluded. This repository packages Codex skills, not Unity assets.
