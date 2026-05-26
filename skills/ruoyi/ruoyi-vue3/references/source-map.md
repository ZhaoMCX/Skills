# 源码地图

本文件的模块地图来自 `yangzongzhuan/RuoYi-Vue3` 与配套 Cloud Vue3 前端的参考快照，仅用于说明常见结构和命名。实际版本、Vite/Element Plus/Pinia/Vue Router/Axios 组合、环境变量和接口前缀以目标项目本地代码及当前官方分支为准。

## 根目录

- `package.json`：脚本、依赖、`type: module`。
- `vite.config.js`：别名、代理、构建输出、插件。
- `.env.development`、`.env.production`、`.env.staging`：`VITE_APP_BASE_API`、环境变量。
- `index.html`：Vite 入口。

## 核心源码

- `src/main.js`：应用入口、插件、Pinia、路由、指令、样式。
- `src/App.vue`：根组件。
- `src/permission.js`：全局路由守卫。
- `src/router/index.js`：静态路由。
- `src/store/index.js`：Pinia 注册。
- `src/store/modules/user.js`：登录、用户信息、退出。
- `src/store/modules/permission.js`：动态路由。
- `src/store/modules/dict.js`：字典缓存。
- `src/utils/request.js`：Axios 封装。
- `src/utils/auth.js`：token 存取。
- `src/utils/ruoyi.js`：常用格式化、参数、日期范围。
- `src/directive/permission/hasPermi.js`、`hasRole.js`：权限指令。
- `src/api/**`：接口封装。
- `src/views/**`：页面。
- `src/components/**`：通用组件。
- `src/plugins/**`：modal、download、tab、auth、cache。

## 数据契约

- 成功响应 `code = 200`。
- 登录过期 `401`。
- 业务错误 `500`，警告类状态常见 `601`。
- 表格接口返回 `rows` 与 `total`。
- token header 默认 `Authorization: Bearer <token>`。
- 开发代理常把 `/dev-api` 转发到 `http://localhost:8080` 或网关地址。
