# 开发流程

## 需求到任务

1. 先把产品意图沉淀为 PRD：目标用户、核心场景、MVP 范围、非目标、验收标准。
2. 再拆 issues：优先 tracer-bullet 纵切片，而不是按层横切。
3. 每个业务模块至少明确：
   - 后端领域模型和数据库权威。
   - 后台管理能力。
   - 用户公开 API。
   - Web 展示或交互。
   - uni-app H5/小程序展示或交互。
   - 测试和验收命令。

## 模块实施顺序

默认顺序：

1. 后端领域模型、表、Mapper、Service、后台 CRUD。
2. 用户公开 VO、facade、`/api/**`。
3. OpenAPI 运行时契约确认。
4. `packages/contracts` / `packages/api-client` 必要更新。
5. admin 后台页面接入后台 API。
6. web 页面接入公开 API。
7. uniapp H5 页面接入公开 API。
8. mp-weixin 构建和微信 DevTools 模拟验收。

如果 UI 风险高，可以先做前端静态模板和 mock 数据，但最终必须回到公开 API 契约。

## 前端开发规则

- 前端业务结构按 `web-structure` 判断职责归位：Feature/Module 定义业务边界，State 记录当前事实，Feature API 编排业务操作，Result 描述结果，Surface 负责页面/组件呈现，Adapter 触达 HTTP、`uni.*`、router、storage、SDK 等外部系统。
- 页面壳保持薄，只做输入收集、状态呈现、生命周期和路由入口；不要在页面事件里堆业务判断。
- 业务规则、校验、状态转换和跨页面流程优先放入 Feature API、组合函数或业务组件；请求封装只做远端 API Adapter。
- API client、router、storage、toast/loading、微信 SDK、`uni.*` 等平台能力需要适配层隔离，不把平台对象泄漏进共享包。
- 涉及复杂前端业务改动时，先写出 `Web Structure Check`，说明 Feature/Module、Role、Why here、Must not live in、External boundary、Verification。
- Web 和 uniapp 可共享 token、类型、纯工具，不共享页面壳。
- 用户端不使用后台管理端 UI 框架作为默认设计系统。
- 设计 token 优先进入 `packages/design-tokens`，端侧只做平台适配。
- 页面任务默认包含空态、加载态、错误态和关键交互态。

## 后端开发规则

- 业务模块独立于 RuoYi 官方模块。
- 后台管理 API 与用户公开 API 分离。
- 用户公开 API 返回 VO，通过 facade 聚合展示数据。
- 列表、详情、启用状态、排序、404/停用态要有测试。
- OpenAPI 要能反映新增公开接口和后台接口。

## 移动与小程序流程

- H5 是主要开发反馈和 CodexApp 视觉/业务验收入口。
- 微信小程序只打开 uni-app 生成的 `dist/build/mp-weixin` 或 `dist/dev/mp-weixin`。
- 小程序验收使用微信 DevTools CLI + `miniprogram-automator`。
- App 打包默认只预留 manifest、图标、权限和说明；不要把 APK/IPA 作为默认 CI 门槛。

## 收尾报告

完成任务时报告：

- 改动的端和接口边界。
- 后端测试、前端测试、构建命令。
- H5 和小程序是否做了视觉/模拟验收。
- 未验证项和需要真实账号、真实 AppID、服务器环境的部分。
