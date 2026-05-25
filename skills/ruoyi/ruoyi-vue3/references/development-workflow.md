# 开发工作流

## 新增业务页面

1. 在 `src/api/<module>/<business>.js` 添加接口函数。
2. 在 `src/views/<module>/<business>/index.vue` 添加页面。
3. 复用现有 `Pagination`、`RightToolbar`、`DictTag`、`TreePanel`、`ExcelImportDialog` 等组件。
4. 如果菜单由后端返回，补后端菜单 component 路径；如果是静态路由，改 `src/router/index.js`。
5. 按钮权限使用 `v-hasPermi`，权限字符串与后端一致。

## 修改请求或鉴权

同时检查：

- `.env.*`
- `vite.config.js` proxy
- `src/utils/request.js`
- `src/utils/auth.js`
- `src/permission.js`
- `src/store/modules/user.js`
- 后端 token header 和响应 code。

## 从 Vue2 迁移代码时

注意差异：

- Vuex -> Pinia。
- `process.env.VUE_APP_*` -> `import.meta.env.VITE_*`。
- Vue Router 3 `addRoutes` -> Vue Router 4 `addRoute`。
- Element UI -> Element Plus。
- 老 `slot-scope` -> `#default` / `v-slot`，但目标项目可能仍有兼容写法，先看本地。

## 验证命令

```powershell
npm run build:prod
npm run build:stage
npm run dev
npm run preview
```

联调检查：

- 登录和刷新页面后动态路由正常。
- 菜单、按钮权限、角色权限生效。
- 列表分页和搜索参数正确。
- 导出下载 blob 正常。
- 401 重新登录流程正常。
- 代理路径和后端/网关一致。

## 评审清单

- 未绕过 `@/utils/request`。
- 未硬编码生产接口地址。
- Pinia 写法与项目一致。
- 权限字符串和后端菜单一致。
- Element Plus 组件和图标写法正确。
- 构建无 Vite alias、自动导入、样式或大小写路径问题。
