---
name: web-fullstack-dev
description: Guides Web-first full-stack module development across RuoYi backends, RuoYi-Vue3-TS admin, Vue3 Web/H5, native WeChat mini programs, shared packages, OpenAPI contracts, PRD/issues/TDD workflows, frontend responsibility placement via web-structure, and multi-surface verification. Use when designing, scaffolding, refactoring, implementing, or verifying Web business modules with server/admin/web/miniprogram/packages, RuoYi templates, user-facing APIs, or OpenAPI-driven agent workflows.
---

# Web Fullstack Dev

Use this skill to orchestrate Web-first full-stack business module work. It coordinates backend, admin, Web/H5, mini program, shared packages, OpenAPI contracts, PRD/issues/TDD workflow, and surface verification. Use `web-structure` for frontend responsibility placement.

## First Pass

1. Inspect the repo shape: `server/`, `admin/`, `web/`, `miniprogram/`, `packages/`, and `docs/`.
2. Read root `README.md`, `package.json`, `pnpm-workspace.yaml`, `AGENTS.md`, and `docs/agents/` when present.
3. For backend, inspect `server/pom.xml`, business modules, `server/sql/`, and OpenAPI/Swagger config.
4. For frontend surfaces, inspect each `package.json`, entrypoints, API clients, test config, tokens, and component implementation.
5. For native WeChat mini programs, inspect `app.js`, `app.json`, `app.wxss`, `project.config.json`, `pages/`, and `components/`.
6. If the repo differs from this template, state the difference and follow the actual project boundaries.

## Orchestration

1. On first use in a project, ensure `setup-matt-pocock-skills` has configured issue tracker, triage labels, and domain docs.
2. For new features, use `to-prd` to create the PRD from current context and repo understanding.
3. Break approved PRDs or plans into vertical-slice issues with `to-issues`.
4. Before implementation, use `web-structure` to place frontend business logic in Feature/Module, State, Feature API, Result, Surface, or Adapter.
5. Use `tdd` for high-risk business logic, state transitions, contracts, permissions, money, inventory, ordering, and other critical behaviors.
6. Use `wechat-miniprogram-devtools` for native mini program DevTools, automator, preview, upload, and platform verification.

## Workflows

- For architecture planning or cleanup, use [template-architecture.md](references/template-architecture.md).
- For API, frontend/backend contract, and permission boundaries, use [api-boundaries.md](references/api-boundaries.md).
- For implementing from a PRD or issue, use [development-workflow.md](references/development-workflow.md).
- For final verification and reporting, use [verification.md](references/verification.md).
- When editing `web/` or `miniprogram/` pages, components, stores, composables, API clients, router guards, platform adapters, or feedback flows, also use `web-structure`.
- When editing native WeChat mini program source, pages, components, config, platform APIs, or DevTools verification, also use `wechat-miniprogram-devtools`.

## Frontend Structure

- This skill decides full-stack surface boundaries, API contracts, shared package responsibilities, and multi-surface verification.
- `web-structure` decides where frontend business logic lives.
- Complex frontend business changes should include a `Web Structure Check` before editing.
- Pages and components are Surfaces: collect input, render state/results, and call Feature APIs.
- HTTP, WeChat Mini Program APIs, WeChat SDK, browser globals, router, storage, and toast/loading are Adapter boundaries.
- `packages/*` may share types, API clients, design tokens, and pure utilities. Do not share page shells, platform SDKs, surface state, or admin-only UI.

## Defaults

- Backend uses a RuoYi modular monolith; business modules stay independent from official RuoYi modules.
- Admin uses RuoYi-Vue3-TS + Element Plus for internal management only.
- Desktop Web/H5 uses Vue3 + Vite + TypeScript and only calls `/api/**` user-facing APIs.
- Native WeChat mini program uses native project structure and calls `/api/**` user-facing APIs.
- Shared packages contain only contracts, API clients, design tokens, and shared utilities.
- Runtime OpenAPI `/v3/api-docs` is the default contract source; Swagger UI is disabled by default.

## Do Not

- Do not let user-facing surfaces call admin CRUD APIs or reuse admin page shells.
- Do not put business code into `ruoyi-system`, `ruoyi-common`, `ruoyi-framework`, or other official RuoYi modules.
- Do not reintroduce `frontend/` or `backend/` shell directories as the default structure.
- Do not leak browser, WeChat Mini Program, WeChat SDK, or admin UI runtime dependencies into shared packages.
- Do not make App APK/IPA a default required CI artifact.
