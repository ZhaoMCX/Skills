# API 与契约边界

## 后台管理 API

- 路径使用 `/{business}/**`，例如 `/business/item/list`。
- 服务后台 CRUD、权限、分页表格、菜单按钮权限。
- 可沿用 RuoYi 返回风格、分页封装和权限注解。
- 面向后台表单、列表、导入导出、字典和系统配置。

后台管理 API 不应成为用户公开前台的默认数据源。

## 用户公开 API

- 路径统一使用 `/api/**`，例如 `/api/items`。
- 服务桌面 Web、uni-app H5、微信小程序和未来 App。
- 返回 VO，不直接返回数据库实体。
- 通过 facade 聚合面向前台展示的数据。
- 默认只返回启用、可公开、已排序的数据。

用户公开 API 不复用后台 CRUD 接口，即使字段短期相同也要保持边界。

## OpenAPI 契约

- 后端运行时暴露 `/v3/api-docs`。
- 默认不提交 OpenAPI JSON/YAML 快照。
- 默认不启用 Swagger UI；agent 和生成工具通过运行时 OpenAPI 端点获取接口信息。
- 若需要文档 UI，应作为显式项目选择，而不是默认模板能力。

## 共享类型和请求

- `packages/contracts` 放契约类型入口，来源应可追溯到 OpenAPI。
- `packages/api-client` 放请求 client 和端无关 API 封装。
- 端侧适配层负责 token、base URL、`uni.request`、浏览器 fetch/axios 等平台差异。
- 不把 RuoYi 后台权限对象、Element Plus 类型、uni/微信 SDK 类型泄漏进共享包。

## 权限与数据边界

- 前端隐藏按钮不是授权；后端必须校验权限和数据范围。
- 用户公开 API 不能依赖前端过滤敏感字段。
- 后台接口可以返回后台表格所需字段；公开接口只返回前台展示 VO。
- 角色/状态/租户/数据范围类逻辑优先在后端测试中验证。

## 常见禁止事项

- 禁止用户前台直接调用 `/{business}/**` 后台 CRUD。
- 禁止为了少写代码让 admin、web、uniapp 共用页面组件。
- 禁止把业务接口塞进 RuoYi 官方模块。
- 禁止让共享包依赖浏览器、uni、微信或后台 UI 框架运行时。
