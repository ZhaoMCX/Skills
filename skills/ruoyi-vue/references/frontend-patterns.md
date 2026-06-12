# 前端模式

## 技术栈

RuoYi-Vue 前端位于 `ruoyi-ui`：

- Vue 2.6
- Element UI 2.x
- Vue CLI / webpack
- Vuex
- Vue Router 3
- Axios
- SCSS

## 请求封装

所有业务接口走 `@/utils/request`：

- `baseURL` 来自 `process.env.VUE_APP_BASE_API`。
- 默认 `Content-Type: application/json;charset=utf-8`。
- 有 token 时设置 `Authorization: Bearer <token>`。
- GET 请求会把 `params` 拼到 URL。
- POST/PUT 默认做重复提交检测，可通过 `headers.repeatSubmit = false` 关闭。
- blob/arraybuffer 直接返回。
- `401` 会弹重新登录确认框，调用 `store.dispatch('LogOut')`。

新增 API 文件放在 `src/api/<module>/<business>.js`，不要直接使用 Axios。

## 路由与权限

`src/permission.js`：

- 白名单：`/login`、`/register`。
- 有 token 时拉取 `GetInfo`。
- 根据用户 roles/permissions 调用 `GenerateRoutes` 并 `router.addRoutes`。
- 锁屏状态会跳转 `/lock`。

按钮权限：

```html
<el-button v-hasPermi="['system:user:add']">新增</el-button>
```

角色权限：

```html
<el-button v-hasRole="['admin']">...</el-button>
```

路由、菜单和后端权限字符串必须一致。菜单接口返回的 component 路径要能被动态路由加载。

## 列表页模式

标准页面由搜索表单、工具栏、表格、分页、弹窗组成。

常用状态：

- `loading`
- `ids`
- `single`
- `multiple`
- `showSearch`
- `total`
- `<business>List`
- `open`
- `title`
- `dateRange`
- `queryParams`
- `form`
- `rules`

列表查询：

```javascript
getList() {
  this.loading = true
  listUser(this.addDateRange(this.queryParams, this.dateRange)).then(response => {
    this.userList = response.rows
    this.total = response.total
    this.loading = false
  })
}
```

分页组件：

```html
<pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
```

## 字典

页面可声明：

```javascript
dicts: ['sys_normal_disable', 'sys_user_sex']
```

模板使用：

```html
<dict-tag :options="dict.type.sys_normal_disable" :value="scope.row.status" />
```

或者在 select/radio 中遍历 `dict.type.<dictType>`。新增字典列时确认后端字典表和前端字典类型一致。

## 增删改查

常见 API 命名：

- `listXxx(query)`
- `getXxx(id)`
- `addXxx(data)`
- `updateXxx(data)`
- `delXxx(id)`

常见页面方法：

- `handleQuery`
- `resetQuery`
- `handleSelectionChange`
- `handleAdd`
- `handleUpdate`
- `submitForm`
- `handleDelete`
- `handleExport`

导出使用全局方法：

```javascript
this.download('system/user/export', { ...this.queryParams }, `user_${new Date().getTime()}.xlsx`)
```

## 组件与插件

优先复用已有组件和插件：

- `Pagination`
- `RightToolbar`
- `DictTag`
- `TreePanel`
- `ExcelImportDialog`
- `ImageUpload` / `FileUpload`
- `$modal`
- `$download`
- `$auth`
- `$tab`

不要新增重复的弹窗、下载、权限判断工具，除非目标项目已经有新的统一封装。
