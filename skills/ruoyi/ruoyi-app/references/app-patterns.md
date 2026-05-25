# App 模式

## 请求封装

`utils/request.js`：

- `baseUrl` 来自 `config.js`。
- 默认超时 `10000`。
- 有 token 且没有设置 `headers.isToken === false` 时，添加 `Authorization: Bearer <token>`。
- `params` 会通过 `tansParams` 拼接到 URL。
- 使用 `uni.request`。
- `401` 弹确认框，确认后 dispatch `LogOut` 并 `uni.reLaunch('/pages/login')`。
- `500` 和其他非 `200` 会 toast 错误。

规则：

- 新接口统一放 `api/**` 并调用 request。
- 登录、注册、验证码设置 `headers.isToken = false`。
- 后端 code 契约以 RuoYi-Vue/RuoYi-Cloud 为准。
- 不要在业务页面重复写 token、错误码和过期处理。

## 上传

头像等文件上传使用 `utils/upload.js`。新增上传功能时保留：

- token header。
- `filePath` / `name`。
- 后端返回格式处理。
- App、小程序和 H5 的路径差异。

## 登录与用户态

`store/modules/user.js` 通常负责：

- `Login`
- `GetInfo`
- `LogOut`
- token 存储/删除。
- 用户名、昵称、头像等状态。

页面读取：

```javascript
this.$store.state.user.name
this.$store.state.user.avatar
```

或通过 getters。不要绕过 store 单独维护登录态。

## 导航拦截

`permission.js` 对以下方法添加拦截器：

- `navigateTo`
- `redirectTo`
- `reLaunch`
- `switchTab`

白名单通常包含：

- `/pages/login`
- `/pages/register`
- `/pages/common/webview/index`

未登录访问非白名单时重定向登录页。新增无需登录页面时更新白名单；新增 tab 页仍需考虑未登录是否允许访问。

## 页面和 tabBar

新增普通页面：

- 添加到 `pages.json` 的 `pages`。
- 路径不带扩展名。
- 设置 `navigationBarTitleText`。

新增 tab 页：

- 添加 page。
- 添加 `tabBar.list`。
- 准备 `iconPath` 和 `selectedIconPath`。
- 使用 `switchTab` 跳转。

若依 App 常见页面：

- `pages/index`
- `pages/work/index`
- `pages/mine/index`
- `pages/mine/info/index`
- `pages/mine/info/edit`
- `pages/mine/pwd/index`
- `pages/mine/avatar/index`

## 插件

`plugins/**` 挂载常用能力到 Vue 原型：

- `$modal`
- `$tab`
- `$auth`

页面跳转优先使用 `$tab.navigateTo`、`$tab.reLaunch` 等项目封装。提示优先用 `$modal.showToast`，不要散落多套 UI 反馈。

## 多端边界

优先使用 `uni.*` API。确需平台特有逻辑时使用条件编译：

```js
// #ifdef H5
// H5 only
// #endif

// #ifdef APP-PLUS
// App only
// #endif
```

微信小程序需要检查 `manifest.json` 的 `mp-weixin.appid`、合法域名、分包和资源路径。
