# 验证与验收

## 根级命令

```powershell
pnpm install
pnpm run test:web
pnpm run test:miniprogram
pnpm run build:web
pnpm run build:miniprogram
pnpm run build:admin
pnpm run verify:apps
```

`verify:apps` 应至少覆盖后端关键测试、Admin、Web/H5 和原生微信小程序的测试/构建。

## 验证层级

1. 使用 `tdd` 或轻量集成测试验证高风险业务规则、状态转换、接口契约和前端业务逻辑层。
2. 使用构建、局部页面/接口验证确认端侧实现可运行。
3. 使用 `feishu-business-chain` 按业务链步骤记录前端、后端、端到端验收状态、测试批次、状态事件和证据问题。
4. 使用 `feishu-ui-design-system` 记录视觉截图、HTML 样例对照、视觉问题和复测状态。

## 端侧交互与视觉证据

- Web/H5 使用 CodexApp 内置浏览器做本地页面交互、路由检查和桌面/移动宽度视口检查。
- 原生微信小程序使用 WeChat DevTools CLI 和 `miniprogram-automator` 做页面打开、文本断言、点击、输入和截图。
- 能用 DOM、data、route、network 或 page-data 断言证明的状态，不截图；截图只用于布局、遮挡、响应式、弹窗、滚动、空态、错误态等人眼可见质量证据。

## 后台服务器

```powershell
cd server
mvn -pl BUSINESS_MODULE -am test
mvn -pl ruoyi-admin -am package -DskipTests
```

验收重点：

- 业务模块单测通过。
- 后台管理 API 覆盖权限、分页、CRUD。
- 用户公开 API 覆盖 VO、启用状态、排序、404/停用态。
- `/v3/api-docs` 可访问并包含后台与公开 API。

## 后台管理端

```powershell
pnpm run build:admin
pnpm run dev:admin
```

验收重点：

- RuoYi-Vue3-TS 能启动和构建。
- 登录、菜单、权限、字典、基础 CRUD 页面可用。
- 业务后台页面能调用后台管理 API。
- 权限按钮和后端权限字符串一致。

## 桌面 Web / 浏览器 H5

```powershell
pnpm run test:web
pnpm run build:web
pnpm run dev:web
```

验收重点：

- 逻辑测试覆盖 API client、Feature API、组合函数、校验、状态转换和关键业务状态。
- 页面交互测试来自飞书业务链步骤，不作为 TDD 红绿重构入口。
- 使用 CodexApp 内置浏览器检查本地页面交互、路由跳转和桌面/移动宽度。
- 检查首页、主业务列表、详情、错误态、空态、加载态、主行动和路由跳转。
- 页面无横向滚动，文本不溢出，主行动清晰。
- 视觉审阅对照飞书 UI 设计系统、页面模板、HTML 样例和截图证据。

## 原生微信小程序

```powershell
pnpm run test:miniprogram
pnpm run build:miniprogram
pnpm run dev:miniprogram
```

验收重点：

- `app.json`、`project.config.json`、`pages/` 和 `components/` 存在且结构符合原生微信小程序。
- 微信开发者工具打开原生小程序项目目录。
- 使用 DevTools CLI 开启自动化，使用 `miniprogram-automator` 做页面打开、文本断言、点击、输入和截图。
- 页面视觉审阅对照飞书 UI 设计系统、页面模板、HTML 样例和截图证据。
- 本地模拟可使用空 AppID；预览、上传、真机能力需要真实 AppID 和登录态。

## 业务链验收

- 使用飞书业务链的前端步骤、后端步骤和端到端步骤作为验收来源。
- 后端业务链测试验证接口、认证上下文、断言、数据库/状态证据。
- 前端业务链测试验证页面、视觉、交互、路由、用户反馈和截图证据。
- 端到端业务链测试验证真实环境、前后端串联、状态事件和证据闭环。
- 飞书不可用时，不得把 PRD、业务链、工单、缺陷或验收状态标记为正式完成。

## 验证报告规则

- 报告实际运行的命令，不只写“已测试”。
- 分清逻辑测试、构建产物检查、视觉截图、业务链验收、真实后端联调。
- 报告飞书 PRD、业务链、工单、UI 设计系统、测试批次、证据编号。
- DevTools、AppID、登录、服务器、数据库等外部条件阻塞时要明确说明。
