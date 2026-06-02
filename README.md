# Skills

[English](README.md) | [简体中文](README.zh-CN.md)

Personal Codex skills maintained as a single repository with lightweight, Matt Pocock-style skill folders.

Recommended reference: [mattpocock/skills](https://github.com/mattpocock/skills), a practical example collection for lightweight agent skill structure and workflows.

## Layout

```text
skills/<category>/<skill-name>/
skills/<category>/<group>/<skill-name>/
  SKILL.md
  references/
  scripts/
```

Only `SKILL.md` is required. Categories and optional groups organize source files only; installed skills are copied directly into the local Codex skills directory by skill name.

## Skills

### Agents

- [Matt Pocock Agent Workflow](skills/agents/matt-pocock-agent-workflow) - Route PRDs, issues, triage, implementation, diagnosis, TDD, architecture work, and domain docs while preserving issue-tracker hygiene.
- [Chinese Agent Rules](skills/agents/chinese-agent-rules) - Keep agent communication, plans, user-facing docs, headings, and topic summaries in Chinese by default.

### Dev

- [Git Commit](skills/dev/git-commit) - Guide atomic Git commits, staging checks, commit message conventions, confirmation templates, and small-step commit mode.

### Game

- [Game Structure](skills/game/game-structure) - Place gameplay logic into Module, Data, State, Rule, Ability, UseCase, Result, Surface, and Adapter responsibilities.

### Ops

- [Server Operation Guardrails](skills/ops/server-operation-guardrails) - Apply remote-server safety rules for read-only inspection, confirmed changes, backups, secrets, TLS, rollback, and verification.

### Web

#### RuoYi

- [RuoYi Framework](skills/web/ruoyi/ruoyi-framework) - Work on classic RuoYi monolith projects with Spring Boot, Shiro, Thymeleaf, MyBatis XML, Druid, Quartz, and the built-in code generator.
- [RuoYi Vue](skills/web/ruoyi/ruoyi-vue) - Work on RuoYi Vue2 front/back separated projects with Spring Security/JWT backends and Vue2/Element UI frontends.
- [RuoYi Vue3](skills/web/ruoyi/ruoyi-vue3) - Work on standalone RuoYi Vue3 frontends with Vite, Element Plus, Pinia, dynamic routes, and permission directives.
- [RuoYi Cloud](skills/web/ruoyi/ruoyi-cloud) - Work on RuoYi microservice projects with Gateway, Auth, Nacos, Feign, Redis, Sentinel, Seata, and multi-module services.
- [RuoYi App](skills/web/ruoyi/ruoyi-app) - Work on RuoYi mobile app templates with uni-app Vue2, token login, request wrappers, navigation guards, and backend integration.

#### Spring

- [Spring Boot](skills/web/spring/spring-boot) - Work on Spring Boot applications, configuration, starters, auto-configuration, Actuator, tests, packaging, and production readiness.
- [Spring Cloud](skills/web/spring/spring-cloud) - Work on Spring Cloud microservices, Gateway, Config, OpenFeign, LoadBalancer, circuit breakers, streams, contracts, and distributed integration.
- [Spring Data](skills/web/spring/spring-data) - Work on Spring Data repositories and persistence across JPA, JDBC, R2DBC, Redis, MongoDB, Elasticsearch, Neo4j, pagination, auditing, and projections.
- [Spring Security](skills/web/spring/spring-security) - Work on Spring Security authentication, authorization, CSRF, sessions, OAuth2, JWT resource servers, method security, passwords, and tests.

### Unity

- [Unity DOTween](skills/unity/unity-dotween) - Implement, review, and debug lifecycle-safe Unity DOTween animation with reusable patterns and review checklists.
- [Unity FishNet](skills/unity/unity-fishnet) - Implement, review, and debug FishNet networking with local source checks, authority rules, SyncType guidance, and lifecycle patterns.
- [Unity Odin](skills/unity/unity-odin) - Work with Odin Inspector and Sirenix Serializer while preserving runtime/editor boundaries, common patterns, and review checks.
- [Unity Steamworks.NET](skills/unity/unity-steamworks-net) - Integrate and debug Steamworks.NET lifecycle, callbacks, native binaries, and service boundaries.
- [Unity TapTap SDK](skills/unity/unity-taptap-sdk) - Integrate and debug TapTap SDK modules, platform setup, PC validation, compliance, IAP, migrations, and release checklists.

### UniApp

- [UniApp Development](skills/uniapp/uniapp-development) - Work on uni-app, uni-app x, DCloud, H5, app, and mini-program projects.

### WeChat

- [WeChat Mini Program DevTools](skills/wechat/wechat-miniprogram-devtools) - Use official WeChat DevTools CLI, project-local automator APIs, generated mp-weixin output, and preview/upload safety workflows.

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
.\scripts\sync-to-global.ps1 -Category web
.\scripts\sync-from-global.ps1 -Category web
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
.\scripts\install.ps1 -Category web
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

Validation enforces skill names, frontmatter, two-sentence descriptions with `Use when`, `SKILL.md` length, referenced files, README links, and generated-file exclusions.

## Notes

Unity `.meta` files are intentionally excluded. This repository packages Codex skills, not Unity assets.
