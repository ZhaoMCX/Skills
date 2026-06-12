---
name: web-fullstack-dev
description: Guides Web-first full-stack business development using a RuoYi backend, RuoYi-Vue3-TS admin, Vue3 desktop Web/H5, native WeChat mini programs, shared packages, OpenAPI contracts, Feishu business chains, Feishu UI design systems, frontend responsibility placement via web-structure, and multi-surface verification. Use when designing, scaffolding, refactoring, implementing, or verifying Web business flows with server/admin/web/miniprogram/packages, RuoYi templates, user-facing APIs, Feishu-driven PRDs/tickets, UI design systems, or OpenAPI-driven agent workflows.
---

## Feishu Project Profile

When this workflow reads or writes Feishu PRDs, business chains, tickets, UI design systems, or acceptance evidence, first follow `feishu-agent-knowledge-base`. Use the target project's declared `lark-cli` profile explicitly, default to `--as user`, and never treat the active default profile as the project fact source. If no profile is declared in project docs or explicit user instruction, draft or inspect only; do not create or update official Feishu records.

# Web 全栈开发技能

用于以 Web 技术栈为主体的业务开发：RuoYi 后端、Vue3 后台、桌面 Web/H5、原生微信小程序、共享包、OpenAPI 契约、飞书业务链、飞书 UI 设计系统和多端验收。

## 首轮检查

1. 先确认仓库结构：`server/`、`admin/`、`web/`、`miniprogram/`、`packages/`、`docs/`。
2. 读取根 `README.md`、`package.json`、`pnpm-workspace.yaml`、`AGENTS.md`。
3. 后端读取 `server/pom.xml`、业务模块、`server/sql/`、OpenAPI/Swagger 配置。
4. 前端读取各端 `package.json`、入口、API 封装、测试配置、设计 token 和组件实现。
5. 小程序读取 `app.js`、`app.json`、`app.wxss`、`project.config.json`、`pages/`、`components/`。
6. 如果目录或技术栈不符合模板，不要假设；先说明偏差，再按当前项目实际边界工作。

## 强制编排顺序

1. 业务目标、PRD、业务链、工单、规则、缺陷和验收事实先使用 `feishu-business-chain`。
2. UI 页面、组件、视觉规则、HTML 样例和截图证据先使用 `feishu-ui-design-system`；设计建议和 UI 评审使用 `ui-ux-pro-max`。
3. 前端业务逻辑归位使用 `web-structure`。
4. 高风险业务逻辑开发反馈使用 `tdd`。
5. 原生微信小程序 DevTools、automator、预览、上传或截图验收使用 `wechat-miniprogram-devtools`。

## 工作流

- 规划或整改技术选型时，使用 [template-architecture.md](references/template-architecture.md)。
- 设计接口、前后端契约或权限边界时，使用 [api-boundaries.md](references/api-boundaries.md)。
- 从 PRD、业务链或飞书工单实施模块时，使用 [development-workflow.md](references/development-workflow.md)。
- 收尾、验收、报告测试结果时，使用 [verification.md](references/verification.md)。
- 修改 `web/` 或 `miniprogram/` 的页面、组件、store、composable、API client、路由守卫、平台适配或用户反馈流程时，同时使用 `web-structure`。
- 修改原生微信小程序源码、页面、组件、配置、平台 API 或 DevTools 验收流程时，同时使用 `wechat-miniprogram-devtools`。

## 前端结构协作

- 本技能决定全栈端边界、接口契约、共享包职责和多端验收；`web-structure` 决定前端业务逻辑应该放在 Feature、State、Feature API、Result、Surface 还是 Adapter。
- 复杂前端业务改动前，先做一次 `Web Structure Check`：确认业务归属、外部边界、不可放置位置和验证方式。
- 页面和组件默认是 Surface：收集输入、渲染状态、调用 Feature API，不承载核心业务规则。
- HTTP、微信小程序 API、微信 SDK、浏览器全局对象、router、storage 和 toast/loading 默认是 Adapter 边界，不把业务判断藏在适配层。
- `packages/*` 可以共享类型、请求 client、设计 token 和纯工具；不要共享页面壳、平台 SDK、端内状态或后台 UI。

## 默认边界

- 后端使用 RuoYi 模块化单体；业务模块独立，不塞进 RuoYi 官方模块。
- 后台端使用 RuoYi-Vue3-TS + Element Plus，只服务内部管理。
- 桌面 Web/H5 使用 Vue3 + Vite + TypeScript，只调用 `/api/**` 用户公开 API。
- 原生微信小程序使用微信小程序原生项目结构，调用 `/api/**` 用户公开 API。
- 共享包只放 contracts、api-client、design-tokens、shared 工具，不放页面壳或平台 SDK。
- OpenAPI 运行时 `/v3/api-docs` 是默认契约入口；Swagger UI 默认关闭。

## 禁止事项

- 不让用户前台复用后台 CRUD API 或后台页面壳。
- 不把业务代码塞进 `ruoyi-system`、`ruoyi-common`、`ruoyi-framework` 等官方模块。
- 不重新引入 `frontend/`、`backend/` 外壳作为默认结构。
- 不让浏览器、微信小程序 API、微信 SDK 或后台 UI 框架运行时泄漏进共享包。
- 不把 App APK/IPA 作为默认 CI 强制产物。
