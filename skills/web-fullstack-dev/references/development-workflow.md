# 开发流程

## Feishu profile

Before using Feishu as the official source for PRDs, business chains, tickets, UI design systems, or acceptance evidence, follow `feishu-agent-knowledge-base`. Use the target project's declared `lark-cli` profile explicitly, default to `--as user`, and do not create or update official Feishu records when no project profile is declared in project docs or explicit user instruction.

## 需求到任务

1. 先使用 `feishu-business-chain` 读取或创建 PRD、业务链、业务规则和纵切片工单。
2. PRD、业务链、工单、缺陷、验收状态和证据以飞书为正式事实源；仓库 Markdown 只记录稳定工程事实。
3. 每个业务模块至少明确：
   - 后端领域模型和数据库权威。
   - 后台管理能力。
   - 用户公开 API。
   - Web/H5 展示或交互。
   - 原生微信小程序展示或交互。
   - UI 设计系统依据。
   - 测试和验收命令。

## 模块实施顺序

默认顺序：

1. 读取飞书 PRD、业务链、规则、工单和验收标准。
2. 读取飞书 UI 设计系统、页面模板、页面 override、HTML 样例和截图证据。
3. 后端领域模型、表、Mapper、Service、后台 CRUD。
4. 用户公开 VO、facade、`/api/**`。
5. OpenAPI 运行时契约确认。
6. `packages/contracts` / `packages/api-client` 必要更新。
7. admin 后台页面接入后台 API。
8. web/H5 页面接入公开 API。
9. 原生微信小程序页面接入公开 API。
10. Web/H5、原生微信小程序和业务链验收。

如果 UI 风险高，可以先做静态模板、HTML 样例或 mock 数据，但最终必须回到飞书业务链、飞书 UI 设计系统和公开 API 契约。

## 前端设计系统规则

- 任何页面、组件、视觉修复或 UI 改版，先使用 `feishu-ui-design-system` 和 `ui-ux-pro-max`。
- `ui-ux-pro-max` 负责设计建议和 UI/UX 评审；`feishu-ui-design-system` 负责飞书事实源、HTML 样例、截图证据和本地实现映射。
- 页面实现前必须读取 UI 设计系统、页面模板、页面 override 和相关 HTML 样例。
- 不临时发明样式规则；若设计事实缺失，先补充飞书结构化草案并确认。
- 仓库代码只承载 token、CSS variables、组件实现和飞书设计编号到代码实现的映射。

## 前端开发规则

- 前端业务结构按 `web-structure` 判断职责归位：Feature/Module 定义业务边界，State 记录当前事实，Feature API 编排业务操作，Result 描述结果，Surface 负责页面/组件呈现，Adapter 触达 HTTP、微信小程序 API、微信 SDK、浏览器 API、router、storage 等外部系统。
- 页面壳保持薄，只做输入收集、状态呈现、生命周期和路由入口；不要在页面事件里堆业务判断。
- 业务规则、校验、状态转换和跨页面流程优先放入 Feature API、组合函数或业务组件；请求封装只做远端 API Adapter。
- API client、router、storage、toast/loading、微信 SDK 和平台 API 需要适配层隔离，不把平台对象泄漏进共享包。
- 涉及复杂前端业务改动时，先写出 `Web Structure Check`，说明 Feature/Module、Role、Why here、Must not live in、External boundary、Verification。
- Web/H5 和原生微信小程序可共享 token、类型、纯工具，不共享页面壳。
- 用户端不使用后台管理端 UI 框架作为默认设计系统。
- 页面任务默认包含空态、加载态、错误态和关键交互态。

## TDD 与业务链

- 业务规则事实源在飞书业务链；代码测试只验证实现没有违背业务链，不重新定义规则。
- 后端复杂领域规则、状态机、金额、库存、积分、订单流转、权限判断和接口契约转换优先使用 `tdd`。
- 前端 TDD 只覆盖业务逻辑层：Feature API、状态转换、校验、API 数据适配、权限/登录态判断。
- 页面交互测试来自飞书业务链步骤，不作为 TDD 红绿重构入口。
- 纯 UI 样式、静态展示、低风险字段映射不强制 TDD。

## 后端开发规则

- 业务模块独立于 RuoYi 官方模块。
- 后台管理 API 与用户公开 API 分离。
- 用户公开 API 返回 VO，通过 facade 聚合展示数据。
- 列表、详情、启用状态、排序、404/停用态要有测试。
- OpenAPI 要能反映新增公开接口和后台接口。

## 原生微信小程序流程

- 原生微信小程序使用 `app.js`、`app.json`、`app.wxss`、`project.config.json`、`pages/`、`components/` 作为项目锚点。
- 小程序页面按飞书业务链步骤和飞书 UI 设计系统实现。
- 小程序验收使用微信 DevTools CLI + `miniprogram-automator`。
- 本地模拟可使用空 AppID；预览、上传、真机能力需要真实 AppID 和登录态。

## 收尾报告

完成任务时报告：

- 飞书 PRD、业务链、工单、UI 设计系统和证据编号。
- 改动的端和接口边界。
- 后端测试、前端逻辑测试、构建命令。
- Web/H5 和原生微信小程序是否做了视觉/模拟验收。
- 未验证项和需要真实账号、真实 AppID、服务器环境的部分。
