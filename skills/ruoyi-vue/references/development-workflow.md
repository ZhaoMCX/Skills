# 开发工作流

## 新增后端接口

1. 找到所属模块和已有 controller 风格。
2. 添加 REST 方法和 `@PreAuthorize`。
3. 写 service 接口/实现；多表写入加事务。
4. 写 mapper 接口/XML；保持 `#{}`、数据权限、软删和状态字段。
5. 返回 `AjaxResult`、`TableDataInfo` 或直接写 `HttpServletResponse`。
6. 需要菜单/按钮时补 SQL 权限数据。

## 新增前端页面

1. 添加 `src/api/<module>/<business>.js`。
2. 添加 `src/views/<module>/<business>/index.vue`。
3. 复用 `Pagination`、`RightToolbar`、`DictTag`、`$modal`、`download`。
4. 路由通常由后端菜单动态返回；不要只加前端文件忘记菜单 component。
5. 按钮使用 `v-hasPermi`，权限字符串与后端一致。

## 修改既有纵切

同时检查：

- 后端 controller / service / mapper / XML。
- 前端 api / view / route / store。
- 菜单权限、字典、SQL、导出字段。
- token、匿名接口、跨域和代理配置。

## 验证命令

后端：

```powershell
mvn clean package -DskipTests
mvn -pl ruoyi-admin -am package -DskipTests
mvn -pl ruoyi-admin -am spring-boot:run
```

前端：

```powershell
cd ruoyi-ui
npm run build:prod
npm run dev
```

本地联调通常还需要 MySQL、Redis，以及 `VUE_APP_BASE_API` / `vue.config.js` 代理指向后端。

## 评审清单

- 后端鉴权、前端按钮权限、菜单 SQL 三者一致。
- token header、代理前缀、后端安全放行列表没有冲突。
- 列表接口分页字段和前端 `queryParams` 一致。
- 导出返回 blob，前端按下载工具处理。
- 数据权限别名和 XML SQL 别名一致。
- 用户输入没有进入 MyBatis `${}`。
- Redis 登录态、权限刷新和退出逻辑没有被绕过。
- Oracle/fast 变体下 SQL 和目录结构已按本地项目调整。
