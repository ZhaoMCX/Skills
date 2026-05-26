---
name: ruoyi-app
description: 该技能处理若依 RuoYi-App 移动端项目，覆盖 uni-app Vue2、uni-ui、Vuex、pages.json、manifest.json、若依 token 登录、请求封装、导航拦截、个人中心和与 RuoYi-Vue/RuoYi-Cloud 后端对接。Use when 项目包含 RuoYi-App、config.js baseUrl、permission.js uni.addInterceptor、utils/request.js、pages/login、pages/mine、uni_modules，或用户明确提到若依移动端/App。
---

# RuoYi App

用于若依官方移动端模板。通用 uni-app 平台问题仍可参考 `uniapp-development`，但若依 App 的登录、token、接口、页面结构和后端对接按本技能处理。

## 首轮检查

1. 读取 `manifest.json`、`pages.json`、`config.js`、`main.js`、`App.vue`、`uni.scss`。
2. 读取 `utils/request.js`、`utils/upload.js`、`utils/auth.js`、`permission.js`、`store/modules/user.js`。
3. 修改接口时读取 `api/**`；修改页面时读取对应 `pages/**`、`components/**` 和 `plugins/**`。
4. 确认目标平台：H5、App、`mp-weixin`、支付宝小程序等；平台差异以 `manifest.json` 和条件编译为准。
5. 确认后端是 RuoYi-Vue 还是 RuoYi-Cloud，以及 `config.js baseUrl` 是否指向正确 API 前缀。

## 引用地图

- `references/official-sources.md`：官方仓库、后端契约和来源优先级。
- `references/source-map.md`：项目结构、关键文件、后端接口契约。
- `references/app-patterns.md`：请求、登录、导航拦截、Vuex、页面、上传、插件。
- `references/development-workflow.md`：新增页面/接口、多端验证、打包和评审清单。

## 工作规则

- 新页面必须注册到 `pages.json`；tab 页还要维护 `tabBar.list` 和图标资源。
- 接口封装放在 `api/**`，统一通过 `utils/request.js` 或 `utils/upload.js`，不要直接散落 `uni.request`。
- token 默认放在 `Authorization: Bearer <token>`；无需 token 的接口设置 `headers.isToken = false`。
- 路由登录拦截在 `permission.js`，白名单要显式维护。
- 用户状态走 Vuex `store/modules/user.js`，页面优先通过 store/getters 获取登录用户、头像和 token。
- 后端响应 code 契约沿用 RuoYi-Vue/RuoYi-Cloud：`200` 成功、`401` 过期、`500` 错误。
- 多端能力使用 `uni.*`，不要在非 H5 条件下直接使用浏览器 API。

## 验证

根据目标平台选择：

- H5：用 HBuilderX 或现有 CLI 运行到浏览器，检查 `config.js baseUrl` 和跨域。
- App：运行到模拟器/真机，检查登录、token 过期、上传、权限。
- 小程序：运行到对应开发者工具，检查 `manifest.json` appid、合法域名、分包和资源路径。

报告修改的页面/API/store/config，目标平台，以及仍需设备或开发者工具验证的部分。
