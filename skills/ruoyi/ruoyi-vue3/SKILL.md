---
name: ruoyi-vue3
description: 该技能处理若依 Vue3 独立前端项目族：RuoYi-Vue3、RuoYi-Cloud-Vue3，覆盖 Vue3、Vite、Element Plus、Pinia、Vue Router 4、Axios、若依动态路由和权限指令。Use when 项目根目录有 vite.config.js、package.json type module、src/utils/request.js、src/store/modules、Element Plus、Pinia、VITE_APP_BASE_API，或仓库名为 RuoYi-Vue3 / RuoYi-Cloud-Vue3。
---

# RuoYi Vue3

用于若依 Vue3 独立前端。后端接口仍可能来自 RuoYi-Vue 或 RuoYi-Cloud；后端修改分别使用 `ruoyi-vue` 或 `ruoyi-cloud`。

## 首轮检查

1. 读取 `package.json`、`vite.config.js`、`.env.*`。
2. 读取 `src/utils/request.js`、`src/permission.js`、`src/router/index.js`、`src/store/modules/user.js`、`src/store/modules/permission.js`。
3. 修改页面时同步读取对应 `src/api/**`、`src/views/**`、相关组件和字典/权限使用。
4. 区分 `RuoYi-Vue3` 与 `RuoYi-Cloud-Vue3`：前端模式相似，但接口基础路径、网关前缀、部署路径可能不同。

## 引用地图

- `references/official-sources.md`：官方仓库、分支和来源优先级。
- `references/source-map.md`：项目结构、核心文件、接口契约。
- `references/frontend-patterns.md`：Vite、request、路由守卫、Pinia、权限、列表页、组件。
- `references/development-workflow.md`：新增页面/API、联调、构建验证、评审清单。

## 工作规则

- API 统一放在 `src/api/**`，通过 `@/utils/request` 调用，不直接使用 Axios。
- token header 默认 `Authorization: Bearer <token>`；`baseURL` 来自 `import.meta.env.VITE_APP_BASE_API`。
- 路由守卫在 `src/permission.js`；动态路由由 `usePermissionStore().generateRoutes()` 加入。
- 用户态使用 Pinia `defineStore`；不要写 Vuex 风格代码。
- UI 使用 Element Plus 和 `@element-plus/icons-vue`，不要沿用 Element UI 的 `el-icon-*` 写法，除非目标项目还保留兼容样式。
- 按钮权限用 `v-hasPermi` / `v-hasRole`，权限字符串必须和后端菜单及接口一致。
- 常用全局能力：`$modal`、`download`、`auth`、`tab`、`cache`、`DictTag`、`Pagination`、`RightToolbar`。

## 验证

```powershell
npm run build:prod
npm run build:stage
npm run dev
```

报告修改的 API、页面、store/router/component，运行命令，以及仍需后端/网关联调的部分。
