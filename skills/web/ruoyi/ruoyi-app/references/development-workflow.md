# 开发工作流

## 新增接口

1. 在 `api/<domain>.js` 添加函数。
2. 使用 `utils/request.js`；上传使用 `utils/upload.js`。
3. 确认是否需要 token。
4. 确认后端路径是 RuoYi-Vue 直连还是 RuoYi-Cloud 网关路径。
5. 页面调用时处理 loading、toast、刷新 store 或本地数据。

## 新增页面

1. 创建 `pages/<module>/<name>.vue`。
2. 在 `pages.json` 注册。
3. 如果需要登录，默认受 `permission.js` 保护。
4. 如果无需登录，加入白名单。
5. 如果是 tab 页，维护 `tabBar.list` 和图标资源。
6. 使用 `$tab` 跳转、`$modal` 提示。

## 修改登录或个人中心

同时检查：

- `api/login.js`
- `api/system/user.js`
- `store/modules/user.js`
- `utils/auth.js`
- `utils/request.js`
- `permission.js`
- `pages/login`
- `pages/mine/**`
- 后端 `getInfo`、登录、退出、头像、修改密码接口。

## 修改后端地址

改 `config.js baseUrl`。不同目标：

- RuoYi-Vue 单体后端：通常是 `http://localhost:8080` 或 `/prod-api`。
- RuoYi-Cloud：通常指向 Gateway。
- H5 可能需要处理跨域和代理。
- 小程序需要配置合法域名。

不要把完整接口地址散落在业务页面。

## 验证

H5：

- 登录、验证码、token 过期、个人中心。
- 网络请求 baseUrl 和跨域。

App：

- 真机/模拟器登录。
- 上传头像。
- 权限弹窗和 Android/iOS 差异。

小程序：

- `manifest.json` appid。
- 合法域名。
- tabBar 图标和页面路径。
- 分包和静态资源路径。

## 评审清单

- 新页面已注册到 `pages.json`。
- 登录白名单正确。
- 接口走统一 request/upload。
- token 与后端契约一致。
- store 中用户态更新完整。
- 多端 API 使用 `uni.*` 或条件编译。
- `config.js` 未提交错误环境地址或敏感信息。
