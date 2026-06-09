# 模板架构

## 核心原则

不追求一套 UI 跑三端。共享后端能力、接口契约、领域模型、设计 token 和纯工具函数；各端按平台特性独立实现。

默认根目录直接使用业内常见名称：

```text
server   后台服务器
admin    后台管理端
web      桌面网页端
uniapp   移动统一工程
packages 前端共享包
docs     PRD、ADR、部署和 agent 文档
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

后台端不承担用户前台体验，不作为桌面 Web 或移动端页面基础。

## 桌面网页端

- 目录：`web/`
- 框架：Vue3 + Vite + TypeScript。
- 样式：设计 token + 自有组件。
- 接口：只调用 `/api/**` 用户公开 API。
- 验收：Vitest 单测 + CodexApp Browser 桌面宽度视觉验收。

## 移动统一工程

- 目录：`uniapp/`
- 框架：uni-app + Vue3 + Vite + TypeScript。
- H5：主要开发反馈、视觉验收和业务验收目标。
- 微信小程序：由 `uniapp/dist/build/mp-weixin` 编译产物进入微信开发者工具。
- App：保留 `manifest.json`、图标、权限和打包说明，不进入默认 CI 强制门槛。

`uni.*` 平台能力只留在 `uniapp/` 内部适配层，不泄漏进 `packages/*`。

## 共享包

- `packages/contracts`：OpenAPI 契约类型入口。
- `packages/api-client`：API client 和请求适配。
- `packages/design-tokens`：跨端设计 token。
- `packages/shared`：纯工具、常量、非 UI 业务辅助。

共享包不放页面壳，不放平台 SDK，不放后台管理端专用 UI。

## pnpm Workspace

```yaml
packages:
  - "admin"
  - "web"
  - "uniapp"
  - "packages/*"
```

根目录脚本应覆盖 dev、test、build 和 `verify:apps`，各端自己的 `package.json` 脚本保留用于局部开发。
