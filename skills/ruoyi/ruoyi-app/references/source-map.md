# 源码地图

本文件的模块地图来自 `yangzongzhuan/RuoYi-App` 的参考快照，仅用于说明常见结构和命名。实际 uni-app、Vue、uni-ui、平台配置、版本号和后端接口契约以目标项目本地代码、接入后端和当前官方分支为准。

## 根目录

- `manifest.json`：应用名、appid、版本、App 权限、微信小程序配置、H5 配置、Vue 版本。
- `pages.json`：页面注册、tabBar、globalStyle。
- `config.js`：`baseUrl`、应用名称、版本、logo、官网、协议。
- `main.js`：注册 store、plugins、permission、全局 `getDicts`。
- `App.vue`：应用生命周期和全局样式入口。
- `uni.scss`：全局 SCSS 变量。

## 核心目录

- `api/**`：若依后端接口封装。
- `pages/login`、`pages/register`：登录注册。
- `pages/index`、`pages/work/index`、`pages/mine/index`：tabBar 页面。
- `pages/mine/**`：头像、个人信息、修改密码、设置、帮助、关于。
- `pages/common/webview/index`、`textview/index`：通用展示页。
- `store/modules/user.js`：登录、用户信息、退出、头像等用户态。
- `utils/request.js`：`uni.request` 封装。
- `utils/upload.js`：上传封装。
- `utils/auth.js`：token 存取。
- `utils/common.js`：toast、confirm、参数拼接等。
- `permission.js`：导航拦截和白名单。
- `plugins/**`：`$modal`、`$tab`、`$auth` 等全局插件。
- `components/**`、`uni_modules/**`：通用组件和 uni-ui。
- `static/**`：图片、tabBar 图标、logo、字体图标等资源。

## 接口契约

- `api/login.js`：
  - `POST /login`
  - `POST /register`
  - `GET /getInfo`
  - `POST /logout`
  - `GET /captchaImage`
- `api/system/user.js`：
  - `PUT /system/user/profile/updatePwd`
  - `GET /system/user/profile`
  - `PUT /system/user/profile`
  - `POST /system/user/profile/avatar`

默认后端地址在 `config.js baseUrl`，可指向 RuoYi-Vue 或 RuoYi-Cloud 网关/API 前缀。
