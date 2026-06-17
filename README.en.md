# Skills

[简体中文](README.md)

An author-maintained Codex skill library for reusable Agent skills, reference materials, and supporting scripts.

README is the source for repository classification, status, and dependency explanations. Skill directories stay flat so they are easy to browse, validate, and reuse across Agents.

## Layout

```text
skills/<skill-name>/
  SKILL.md
  references/
  scripts/
```

Only `SKILL.md` is required. Repository skill directories must be flat under `skills/`; README is the only source for category and status explanations, and filesystem paths do not express categories.

## Agent Usage

When an agent needs to choose skills, first match the task against "Repository Skill Modules", then check "Direct Skill Dependencies". If the target skill depends on other repository skills, install them together; if it depends on external skills, fetch them from the source listed under "External Dependency Skills".

Install one skill:

```powershell
.\scripts\install.ps1 -Skill web-fullstack-dev
```

Common entry points:

| Task type | Skills to install first |
| --- | --- |
| Chinese conversation, plans, and user-facing docs | [Chinese Agent Rules](skills/chinese-agent-rules) |
| Git commit preparation | [Git Commit](skills/git-commit) |
| Remote servers or production operations | [Server Operation Guardrails](skills/server-operation-guardrails) |
| Web-first full-stack business development | [Web Fullstack Dev](skills/web-fullstack-dev) |
| Web, Vue, H5, uni-app, and Mini Program responsibility boundaries | [Web Structure](skills/web-structure) |
| uni-app / DCloud / multi-surface projects | [UniApp Development](skills/uniapp-development) |
| Native WeChat Mini Programs and WeChat DevTools | [WeChat Mini Program DevTools](skills/wechat-miniprogram-devtools) |
| RuoYi project families | [RuoYi Framework](skills/ruoyi-framework), [RuoYi Vue](skills/ruoyi-vue), [RuoYi Vue3](skills/ruoyi-vue3), [RuoYi Cloud](skills/ruoyi-cloud), [RuoYi App](skills/ruoyi-app) |
| Spring backend concerns | [Spring Boot](skills/spring-boot), [Spring Cloud](skills/spring-cloud), [Spring Data](skills/spring-data), [Spring Security](skills/spring-security) |
| Unity concerns | [Unity DOTween](skills/unity-dotween), [Unity FishNet](skills/unity-fishnet), [Unity Odin](skills/unity-odin), [Unity Steamworks.NET](skills/unity-steamworks-net), [Unity TapTap SDK](skills/unity-taptap-sdk) |

## External Dependency Skills

These skills are not collected into this repository, but they are documented as external dependency sources for repository skill design, orchestration, questioning, verification, and UI/UX judgment.

### mattpocock/skills

#### Engineering

- [`diagnose`](https://github.com/mattpocock/skills/tree/main/skills/engineering/diagnose)
- [`grill-with-docs`](https://github.com/mattpocock/skills/tree/main/skills/engineering/grill-with-docs)
- [`improve-codebase-architecture`](https://github.com/mattpocock/skills/tree/main/skills/engineering/improve-codebase-architecture)
- [`prototype`](https://github.com/mattpocock/skills/tree/main/skills/engineering/prototype)
- [`setup-matt-pocock-skills`](https://github.com/mattpocock/skills/tree/main/skills/engineering/setup-matt-pocock-skills)
- [`tdd`](https://github.com/mattpocock/skills/tree/main/skills/engineering/tdd)
- [`to-issues`](https://github.com/mattpocock/skills/tree/main/skills/engineering/to-issues)
- [`to-prd`](https://github.com/mattpocock/skills/tree/main/skills/engineering/to-prd)
- [`triage`](https://github.com/mattpocock/skills/tree/main/skills/engineering/triage)
- [`zoom-out`](https://github.com/mattpocock/skills/tree/main/skills/engineering/zoom-out)

#### Productivity

- [`caveman`](https://github.com/mattpocock/skills/tree/main/skills/productivity/caveman)
- [`grill-me`](https://github.com/mattpocock/skills/tree/main/skills/productivity/grill-me)
- [`handoff`](https://github.com/mattpocock/skills/tree/main/skills/productivity/handoff)
- [`teach`](https://github.com/mattpocock/skills/tree/main/skills/productivity/teach)
- [`write-a-skill`](https://github.com/mattpocock/skills/tree/main/skills/productivity/write-a-skill)

#### Misc

- [`git-guardrails-claude-code`](https://github.com/mattpocock/skills/tree/main/skills/misc/git-guardrails-claude-code)
- [`migrate-to-shoehorn`](https://github.com/mattpocock/skills/tree/main/skills/misc/migrate-to-shoehorn)
- [`scaffold-exercises`](https://github.com/mattpocock/skills/tree/main/skills/misc/scaffold-exercises)
- [`setup-pre-commit`](https://github.com/mattpocock/skills/tree/main/skills/misc/setup-pre-commit)

#### Personal

- [`edit-article`](https://github.com/mattpocock/skills/tree/main/skills/personal/edit-article)
- [`obsidian-vault`](https://github.com/mattpocock/skills/tree/main/skills/personal/obsidian-vault)

### nextlevelbuilder/ui-ux-pro-max-skill

#### UI/UX

- [`ui-ux-pro-max`](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) - Provide UI/UX design recommendations, visual review, color, typography, layout, and accessibility judgment.

## Repository Skill Modules

`Stable` means the skill is collected and ready as a regular trigger. `In Progress` means the skill is collected but its model, dependencies, or orchestration wording is still being refined.

### In Progress

- [Web Fullstack Dev](skills/web-fullstack-dev) - Work on Web-first full-stack module development across RuoYi backends, Vue3 admin, desktop Web/H5, native WeChat mini programs, shared packages, OpenAPI, PRD/issues/TDD workflows, and web-structure responsibility placement.

### Stable

#### Agent Collaboration Rules

- [Chinese Agent Rules](skills/chinese-agent-rules) - Keep agent communication, plans, user-facing docs, headings, and topic summaries in Chinese by default.

#### Engineering Workflow And Safety

- [Git Commit](skills/git-commit) - Guide atomic Git commits, staging checks, commit message conventions, confirmation templates, and small-step commit mode.
- [Server Operation Guardrails](skills/server-operation-guardrails) - Apply remote-server safety rules for read-only inspection, confirmed changes, backups, secrets, TLS, rollback, and verification.

#### Web Full Stack And Surfaces

- [Web Structure](skills/web-structure) - Place Web, Vue, uni-app, H5, and mini-program frontend business logic into Feature, State, Feature API, Result, Surface, or Adapter responsibilities.
- [UniApp Development](skills/uniapp-development) - Work on uni-app, uni-app x, DCloud, H5, app, and mini-program projects.
- [WeChat Mini Program DevTools](skills/wechat-miniprogram-devtools) - Use official WeChat DevTools CLI, project-local automator APIs, native Mini Program structure, WXML/WXSS, generated mp-weixin output, and preview/upload safety workflows.

#### RuoYi Project Families

- [RuoYi Framework](skills/ruoyi-framework) - Work on classic RuoYi monolith projects with Spring Boot, Shiro, Thymeleaf, MyBatis XML, Druid, Quartz, and the built-in code generator.
- [RuoYi Vue](skills/ruoyi-vue) - Work on RuoYi Vue2 front/back separated projects with Spring Security/JWT backends and Vue2/Element UI frontends.
- [RuoYi Vue3](skills/ruoyi-vue3) - Work on standalone RuoYi Vue3 frontends with Vite, Element Plus, Pinia, dynamic routes, and permission directives.
- [RuoYi Cloud](skills/ruoyi-cloud) - Work on RuoYi microservice projects with Gateway, Auth, Nacos, Feign, Redis, Sentinel, Seata, and multi-module services.
- [RuoYi App](skills/ruoyi-app) - Work on RuoYi mobile app templates with uni-app Vue2, token login, request wrappers, navigation guards, and backend integration.

#### Spring Backend Capabilities

- [Spring Boot](skills/spring-boot) - Work on Spring Boot applications, configuration, starters, auto-configuration, Actuator, tests, packaging, and production readiness.
- [Spring Cloud](skills/spring-cloud) - Work on Spring Cloud microservices, Gateway, Config, OpenFeign, LoadBalancer, circuit breakers, streams, contracts, and distributed integration.
- [Spring Data](skills/spring-data) - Work on Spring Data repositories and persistence across JPA, JDBC, R2DBC, Redis, MongoDB, Elasticsearch, Neo4j, pagination, auditing, and projections.
- [Spring Security](skills/spring-security) - Work on Spring Security authentication, authorization, CSRF, sessions, OAuth2, JWT resource servers, method security, passwords, and tests.

#### Unity Concerns

- [Unity DOTween](skills/unity-dotween) - Implement, review, and debug lifecycle-safe Unity DOTween animation with reusable patterns and review checklists.
- [Unity FishNet](skills/unity-fishnet) - Implement, review, and debug FishNet networking with local source checks, authority rules, SyncType guidance, and lifecycle patterns.
- [Unity Odin](skills/unity-odin) - Work with Odin Inspector and Sirenix Serializer while preserving runtime/editor boundaries, common patterns, and review checks.
- [Unity Steamworks.NET](skills/unity-steamworks-net) - Integrate and debug Steamworks.NET lifecycle, callbacks, native binaries, and service boundaries.
- [Unity TapTap SDK](skills/unity-taptap-sdk) - Integrate and debug TapTap SDK modules, platform setup, PC validation, compliance, IAP, migrations, and release checklists.

## Direct Skill Dependencies

| Skill | Direct dependencies | Purpose |
| --- | --- | --- |
| [Web Fullstack Dev](skills/web-fullstack-dev) | [Web Structure](skills/web-structure), [WeChat Mini Program DevTools](skills/wechat-miniprogram-devtools), [UniApp Development](skills/uniapp-development), [`ui-ux-pro-max`](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) | Orchestrate PRD/issues/TDD-driven full-stack module work, frontend responsibility boundaries, surface tools, and UI/UX design judgment. |
| [Web Structure](skills/web-structure) | [WeChat Mini Program DevTools](skills/wechat-miniprogram-devtools), [UniApp Development](skills/uniapp-development) | Define frontend responsibility boundaries for surfaces without replacing Mini Program or uni-app tools. |

## Core Collaboration Chains

- Web full stack: `to-prd`, `to-issues`, and `tdd` provide the engineering workflow; `web-fullstack-dev` orchestrates full-stack module delivery; `web-structure` places frontend business responsibilities.
- RuoYi / Spring: identify the RuoYi project family first, then use Spring skills for focused backend capability questions.
- Unity: choose the matching Unity skill for animation, networking, Inspector, or platform SDK needs.
- Operations: use `server-operation-guardrails` before remote servers, production environments, or high-risk changes.

## Install

Install all skills into the local Codex skills directory:

```powershell
.\scripts\install.ps1
```

Install one skill:

```powershell
.\scripts\install.ps1 -Skill unity-dotween
```

## Validate

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\validate-skills.ps1
```

Validation enforces skill names, frontmatter, non-empty descriptions, `SKILL.md` length, referenced files, README links, and generated-file exclusions.
