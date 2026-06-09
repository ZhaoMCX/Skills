# 验证与验收

## 根级命令

```powershell
pnpm install
pnpm run test:web
pnpm run test:mobile
pnpm run build:web
pnpm run build:mobile
pnpm run build:weapp
pnpm run build:admin
pnpm run verify:apps
```

`verify:apps` 应至少覆盖 Web、uni-app H5、mp-weixin 和 Admin 的测试/构建。

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

## 桌面 Web

```powershell
pnpm run test:web
pnpm run build:web
pnpm run dev:web
```

验收重点：

- Vitest 覆盖 API client、组合函数、关键组件状态。
- CodexApp Browser 检查桌面宽度。
- 检查首页、主业务列表、详情、错误态、空态和路由跳转。
- 页面无横向滚动，文本不溢出，主行动清晰。

## uni-app H5

```powershell
pnpm run test:mobile
pnpm run build:mobile
pnpm run dev:mobile
```

验收重点：

- H5 构建通过。
- CodexApp Browser 检查移动宽度。
- 无横向滚动，触控区域不小于 44px，路由正常。
- 空态、错误态、加载态可见且可理解。

## 微信小程序

```powershell
pnpm run build:weapp
```

验收重点：

- `uniapp/dist/build/mp-weixin/app.json` 存在。
- 微信开发者工具打开编译产物，不打开 repo 根目录。
- 使用 DevTools CLI 开启自动化，使用 `miniprogram-automator` 做页面打开、文本断言、点击和截图。
- 本地模拟可使用空 AppID；预览、上传、真机能力需要真实 AppID 和登录态。

## 验证报告规则

- 报告实际运行的命令，不只写“已测试”。
- 分清功能断言、视觉截图、构建产物检查和真实后端联调。
- DevTools、AppID、登录、服务器、数据库等外部条件阻塞时要明确说明。
