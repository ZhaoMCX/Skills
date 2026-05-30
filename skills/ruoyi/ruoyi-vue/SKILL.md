---
name: ruoyi-vue
description: 处理若依前后端分离 Vue2 项目族：RuoYi-Vue、RuoYi-Vue-fast、RuoYi-Vue-Oracle，覆盖 Spring Boot/Spring Security/JWT/Redis 后端与 Vue2/Element UI/Vue CLI 前端。Use when 项目包含 ruoyi-ui、vue.config.js、src/utils/request.js、v-hasPermi、@PreAuthorize("@ss.hasPermi(...)")、SecurityConfig、TokenService，或仓库名/说明为 RuoYi-Vue。
---

# RuoYi Vue

用于若依前后端分离 Vue2 族。不要用于经典 Thymeleaf 单体、Vue3 独立前端、Cloud 微服务或 RuoYi-App。

## 首轮检查

1. 读取根 `pom.xml`、`ruoyi-ui/package.json`、`ruoyi-admin/src/main/resources/application.yml`。
2. 确认分支版本、JDK、Spring Boot、前端 Vue/Element UI/Vue CLI 版本，以及是否是 `fast` 或 `Oracle` 变体。
3. 后端修改读取 controller、service、mapper、Mapper XML、`SecurityConfig`、`TokenService`、权限服务和代码生成器模板。
4. 前端修改读取 `ruoyi-ui/src/utils/request.js`、`permission.js`、`router/index.js`、`store/modules/**`、对应 `api/**` 与 `views/**`。
5. 以目标项目本地代码为准；RuoYi-Vue 二开常改 token header、接口前缀、菜单路由、字典组件和生成器模板。

## 引用地图

- `references/source-map.md`：模块、关键文件、仓库变体。
- `references/backend-patterns.md`：REST Controller、Spring Security/JWT、Redis token、权限、数据权限、Excel、代码生成。
- `references/frontend-patterns.md`：Vue2、Element UI、Vuex、路由守卫、Axios、权限指令、列表页模式。
- `references/development-workflow.md`：新增/修改功能、前后端联调、验证命令、评审清单。

## 工作规则

- 后端是 REST API，controller 使用 `@RestController`；列表返回 `TableDataInfo`，操作返回 `AjaxResult`，导出通常直接写 `HttpServletResponse`。
- 权限使用 `@PreAuthorize("@ss.hasPermi('module:business:action')")`，前端按钮使用 `v-hasPermi="['module:business:action']"`。
- token 由前端 `Authorization: Bearer <token>` 携带，后端 `JwtAuthenticationTokenFilter` + `TokenService` 从 Redis 读取登录态。
- 前端 API 模块放在 `ruoyi-ui/src/api/**`，页面放在 `ruoyi-ui/src/views/**`，不要绕过 `@/utils/request`。
- 查询列表通常用 GET + `params`；新增 POST、修改 PUT、删除 DELETE；日期范围使用 `addDateRange(queryParams, dateRange)`。
- 保持后端权限、菜单数据、前端路由 name/path/component、按钮权限字符串一致。
- RuoYi-Vue3 生成模板可能存在于后端生成器中，但实际 Vue3 前端项目优先使用 `ruoyi-vue3` 技能。

## 验证

常用命令：

```powershell
mvn clean package -DskipTests
mvn -pl ruoyi-admin -am package -DskipTests
cd ruoyi-ui; npm run build:prod
cd ruoyi-ui; npm run dev
```

报告后端模块、前端页面/API、运行命令，以及仍需数据库、Redis、浏览器联调的部分。
