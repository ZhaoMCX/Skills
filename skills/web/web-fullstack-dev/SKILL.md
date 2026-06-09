---
name: web-fullstack-dev
description: Guides Web-first full-stack monorepo work using a RuoYi backend, RuoYi-Vue3-TS admin, Vue3 desktop Web, uni-app mobile targets, shared packages, OpenAPI contracts, frontend responsibility placement via web-structure, and multi-surface verification. Use when designing, scaffolding, refactoring, implementing, or verifying projects with server/admin/web/uniapp/packages, RuoYi full-stack templates, 分端前台, H5-first mobile validation, WeChat mini program builds, or OpenAPI-driven agent workflows.
---

# Web 全栈开发技能

用于以 Web 技术栈为主体的全栈 monorepo：RuoYi 后端、Vue3 后台、桌面 Web、uni-app 移动端、共享包、OpenAPI 契约和多端验收。

## 首轮检查

1. 先确认仓库结构：`server/`、`admin/`、`web/`、`uniapp/`、`packages/`、`docs/`。
2. 读取根 `README.md`、`package.json`、`pnpm-workspace.yaml`、`AGENTS.md`。
3. 后端读取 `server/pom.xml`、业务模块、`server/sql/`、OpenAPI/Swagger 配置。
4. 前端读取各端 `package.json`、入口、API 封装、测试配置和设计 token。
5. 如果目录或技术栈不符合模板，不要假设；先说明偏差，再按当前项目实际边界工作。

## 工作流

- 规划或整改技术选型时，使用 [template-architecture.md](references/template-architecture.md)。
- 设计接口、前后端契约或权限边界时，使用 [api-boundaries.md](references/api-boundaries.md)。
- 从 PRD 拆任务或实施模块时，使用 [development-workflow.md](references/development-workflow.md)。
- 收尾、验收、报告测试结果时，使用 [verification.md](references/verification.md)。
- 修改 `web/` 或 `uniapp/` 的页面、组件、store、composable、API client、路由守卫、平台适配或用户反馈流程时，同时使用 `web-structure`。
- 修改 `uniapp/` 源码、pages、manifest、条件编译或构建脚本时，同时使用 `uniapp-development`。
- 做微信小程序 DevTools、automator、预览、上传、模拟器截图或 `mp-weixin` 产物验收时，同时使用 `wechat-miniprogram-devtools`。

## 前端结构协作

- 本技能决定全栈端边界、接口契约、共享包职责和多端验收；`web-structure` 决定前端业务逻辑应该放在 Feature、State、Feature API、Result、Surface 还是 Adapter。
- 复杂前端业务改动前，先做一次 `Web Structure Check`：确认业务归属、外部边界、不可放置位置和验证方式。
- 页面和组件默认是 Surface：收集输入、渲染状态、调用 Feature API，不承载核心业务规则。
- HTTP、`uni.*`、微信 SDK、浏览器全局对象、router、storage 和 toast/loading 默认是 Adapter 边界，不把业务判断藏在适配层。
- `packages/*` 可以共享类型、请求 client、设计 token 和纯工具；不要共享页面壳、平台 SDK、端内状态或后台 UI。

## 默认边界

- 后端使用 RuoYi 模块化单体；业务模块独立，不塞进 RuoYi 官方模块。
- 后台端使用 RuoYi-Vue3-TS + Element Plus，只服务内部管理。
- 桌面 Web 使用 Vue3 + Vite + TypeScript，只调用 `/api/**` 用户公开 API。
- 移动端使用 uni-app + Vue3；H5 优先验收，小程序来自 `mp-weixin` 编译产物，App 只预留。
- 共享包只放 contracts、api-client、design-tokens、shared 工具，不放页面壳或平台 SDK。
- OpenAPI 运行时 `/v3/api-docs` 是默认契约入口；Swagger UI 默认关闭。

## 禁止事项

- 不让用户前台复用后台 CRUD API 或后台页面壳。
- 不把业务代码塞进 `ruoyi-system`、`ruoyi-common`、`ruoyi-framework` 等官方模块。
- 不重新引入 `frontend/`、`backend/` 外壳作为默认结构。
- 不让 `uni`、微信 SDK、浏览器全局对象泄漏进共享包。
- 不把 App APK/IPA 作为默认 CI 强制产物。
