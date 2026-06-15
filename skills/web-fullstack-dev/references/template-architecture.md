# 模板架构

## 核心原则

不追求一套 UI 跑多端。共享后端能力、接口契约、领域模型、设计 token 和纯工具函数；各端按平台特性独立实现。

默认根目录直接使用业内常见名称：

```text
server      后台服务器
admin       后台管理端
web         桌面 Web / 浏览器 H5
miniprogram 原生微信小程序
packages    前端共享包
docs        ADR、部署和 agent 文档
```

根目录是唯一 Git 仓库，不创建端内 `.git`。根目录提供 pnpm workspace 和统一脚本；`server/` 内保留独立 Maven 工程。

## 后台服务器

- 目录：`server/`
- 基线：RuoYi 后端模块化单体。
- Java：17。
- Spring Boot：按项目基线锁定。
- 持久层：MyBatis。
- 数据库：MySQL / MariaDB。
- 缓存：Redis。
- 认证：JWT。
- 业务模块：独立 Maven 模块，例如 `ruoyi-business`。
- 契约：运行时暴露 `/v3/api-docs`，Swagger UI 默认关闭。

推荐结构：

```text
server/
  pom.xml
  ruoyi-admin/
  ruoyi-common/
  ruoyi-framework/
  ruoyi-generator/
  ruoyi-quartz/
  ruoyi-system/
  BUSINESS_MODULE/
  sql/
  docs/
  doc/
  deploy/
```

## 后台管理端

- 目录：`admin/`
- 基线：RuoYi-Vue3-TS。
- 框架：Vue3、Vite、TypeScript。
- UI：Element Plus。
- 状态：Pinia。
- 职责：内部 CRUD、权限、菜单、角色、字典、系统配置、业务数据维护。

后台端不承担用户前台体验，不作为桌面 Web、H5 或小程序页面基础。

## 桌面 Web / 浏览器 H5

- 目录：`web/`
- 框架：Vue3 + Vite + TypeScript。
- 样式：本地 design tokens + 自有组件，可结合 `ui-ux-pro-max` 做设计建议和视觉评审。
- 接口：只调用 `/api/**` 用户公开 API。
- 验收：PRD/issue acceptance criteria、前端逻辑测试、构建、CodexApp Browser 桌面和移动宽度检查。

## 原生微信小程序

- 目录：`miniprogram/`
- 基线：原生微信小程序。
- 锚点：`app.js`、`app.json`、`app.wxss`、`project.config.json`、`pages/`、`components/`。
- 接口：只调用 `/api/**` 用户公开 API。
- 设计：使用本地 design tokens、自有组件和 `ui-ux-pro-max` 评审结果。
- 验收：微信开发者工具 CLI、`miniprogram-automator`、页面打开、文本断言、点击；截图只用于视觉风险。

## 共享包

- `packages/contracts`：OpenAPI 契约类型入口。
- `packages/api-client`：API client 和请求适配。
- `packages/design-tokens`：本地 design token 实现。
- `packages/shared`：纯工具、常量、非 UI 业务辅助。

共享包不放页面壳，不放平台 SDK，不放后台管理端专用 UI。

## pnpm Workspace

```yaml
packages:
  - "admin"
  - "web"
  - "miniprogram"
  - "packages/*"
```

根目录脚本应覆盖 dev、test、build 和 `verify:apps`，各端自己的 `package.json` 脚本保留用于局部开发。
