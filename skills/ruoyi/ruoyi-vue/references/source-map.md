# 源码地图

本文件的模块地图来自 `yangzongzhuan/RuoYi-Vue` 的参考快照，仅用于说明常见结构和命名。实际版本、JDK、Spring Boot、Spring Security、JWT、Redis、Vue/Element UI/Vue CLI、生成器模板和接口契约以目标项目本地代码及当前官方分支为准。

同族变体：

- `RuoYi-Vue`：多模块后端 + `ruoyi-ui` Vue2 前端。
- `RuoYi-Vue-fast`：快速版，目录会更扁平，模式仍是 Spring Security/JWT + Vue2。
- `RuoYi-Vue-Oracle`：Oracle 版，重点留意 SQL、驱动、分页和函数差异。

## 后端模块

- `ruoyi-admin`：Spring Boot 入口、REST controller、`application.yml`、`application-druid.yml`。
- `ruoyi-framework`：Spring Security、JWT filter、TokenService、Redis、全局异常、数据源、AOP。
- `ruoyi-common`：`BaseController`、`AjaxResult`、`TableDataInfo`、注解、常量、工具、Excel、文件、分页。
- `ruoyi-system`：用户、角色、菜单、部门、字典、参数、通知、日志等业务。
- `ruoyi-quartz`：定时任务。
- `ruoyi-generator`：后端 CRUD 和 Vue/Vue3/TypeScript 生成模板。

关键文件：

- `ruoyi-framework/src/main/java/com/ruoyi/framework/config/SecurityConfig.java`
- `ruoyi-framework/src/main/java/com/ruoyi/framework/security/filter/JwtAuthenticationTokenFilter.java`
- `ruoyi-framework/src/main/java/com/ruoyi/framework/web/service/TokenService.java`
- `ruoyi-framework/src/main/java/com/ruoyi/framework/web/service/PermissionService.java`
- `ruoyi-admin/src/main/java/com/ruoyi/web/controller/**`
- `ruoyi-system/src/main/resources/mapper/system/*.xml`

## 前端目录

- `ruoyi-ui/package.json`：脚本和依赖。
- `ruoyi-ui/vue.config.js`：dev server、代理、构建配置。
- `ruoyi-ui/src/utils/request.js`：Axios 实例、token、重复提交、错误处理、下载。
- `ruoyi-ui/src/permission.js`：全局路由守卫。
- `ruoyi-ui/src/router/index.js`：静态路由。
- `ruoyi-ui/src/store/modules/user.js`：登录、用户信息、退出。
- `ruoyi-ui/src/store/modules/permission.js`：动态路由生成。
- `ruoyi-ui/src/directive/permission/hasPermi.js`、`hasRole.js`：按钮权限指令。
- `ruoyi-ui/src/api/**`：接口封装。
- `ruoyi-ui/src/views/**`：页面。
- `ruoyi-ui/src/plugins/**`：modal、download、auth、tab、cache 等全局插件。

## 数据契约

- 成功响应通常 `code = 200`。
- 未登录/过期为 `401`，业务错误常见 `500`，警告常见 `601`。
- 表格接口返回 `rows` 和 `total`。
- token header 默认 `Authorization: Bearer <token>`。
- 前端 `VUE_APP_BASE_API` 指向代理前缀，例如 `/dev-api`。
