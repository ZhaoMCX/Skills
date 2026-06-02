# 前端模式

## Vite 配置

`vite.config.js` 常见内容：

- `@` 指向 `src`，`~` 指向项目根。
- `server.proxy['/dev-api']` 转发到后端或网关。
- build 输出 `dist`，静态资源拆到 `static/**`。
- 插件由 `vite/plugins` 组合。

改接口地址时优先改 `.env.*` 和代理配置，不要在业务 API 中硬编码完整后端 URL。

## Request

`src/utils/request.js`：

- `baseURL = import.meta.env.VITE_APP_BASE_API`。
- 默认 JSON。
- token 来自 `getToken()`。
- `headers.isToken === false` 表示不附带 token。
- POST/PUT 默认做重复提交检测。
- blob/arraybuffer 直接返回。
- `401` 触发重新登录确认并调用 `useUserStore().logOut()`。

新增下载接口使用导出的 `download(url, params, filename, config)` 或全局插件，不要重复写 blob 解析。

## 路由守卫

`src/permission.js`：

- 白名单通常是 `/login`、`/register`。
- 有 token 时先处理登录页、白名单、锁屏。
- 首次进入时调用 `useUserStore().getInfo()`。
- 调用 `usePermissionStore().generateRoutes()` 生成动态路由。
- 用 `router.addRoute(route)` 加入非外链路由。

改菜单 component/path 时，要确保后端返回的 component 能被前端动态加载逻辑识别。

## Pinia

状态模块在 `src/store/modules/**`，使用 `defineStore`。

用户模块常见字段：

- `token`
- `id`
- `name`
- `nickName`
- `avatar`
- `roles`
- `permissions`

不要写 Vue2/Vuex 的 `mutations`、`dispatch('...')` 风格，除非目标项目仍保留兼容层。

## 列表页

标准页面仍是若依 CRUD 模式：

- 搜索表单。
- 工具栏按钮。
- `el-table`。
- `pagination`。
- 新增/编辑 `el-dialog`。
- `queryParams`、`dateRange`、`ids`、`single`、`multiple`、`loading`、`total`、`form`、`rules`。

常用函数：

- `getList`
- `handleQuery`
- `resetQuery`
- `handleSelectionChange`
- `handleAdd`
- `handleUpdate`
- `submitForm`
- `handleDelete`
- `handleExport`

## 权限和字典

按钮权限：

```vue
<el-button v-hasPermi="['system:user:add']">新增</el-button>
```

字典：

- 页面可用 `dicts` 兼容写法，或项目封装后的 `useDict`。
- 显示标签优先用 `dict-tag`。
- 表单 select/radio 遍历对应字典数组。

确认目标项目使用的字典 API 和混入/组合式封装，不要混用两套写法。

## Element Plus

图标优先使用 `@element-plus/icons-vue` 已注册/自动导入的组件。不要把 Element UI 的 `el-icon-search`、`el-icon-edit` 当成默认可用，除非目标项目确实保留了兼容图标样式。
