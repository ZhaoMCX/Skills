---
name: ruoyi-framework
description: 处理若依经典单体后台项目族：RuoYi、RuoYi-fast、RuoYi-Oracle，以及 Spring Boot 2/3/4 分支中的 Shiro、Thymeleaf、MyBatis XML、Druid、Quartz 与内置 Velocity 代码生成器。Use when 项目包含 ruoyi-admin、ruoyi-framework、ruoyi-common、ruoyi-system、ruoyi-quartz、ruoyi-generator、RuoYiApplication、ry.bat，或使用 AjaxResult、TableDataInfo、ry-ui.js 等若依经典单体模式。
---

# RuoYi Framework

用于经典若依单体版 `yangzongzhuan/RuoYi`、`RuoYi-fast`、`RuoYi-Oracle`。不要把它直接套到 RuoYi-Vue、RuoYi-Cloud 或 RuoYi-App，除非目标项目确实保留了这些模块和 Thymeleaf/jQuery 约定。

## 首轮检查

改代码前先做这些事：

1. 从 `pom.xml`、`README.md` 和模块 POM 判断版本、JDK、Spring Boot 分支。
2. 用 `rg --files` 列文件；读取受影响的 controller、service、mapper 接口、Mapper XML、Thymeleaf 页面；涉及代码生成时读取本项目生成器模板。
3. 确认模块职责：
   - `ruoyi-admin`：Web 入口、控制器、模板、静态资源、应用配置。
   - `ruoyi-framework`：Shiro、MVC 配置、AOP、过滤器、拦截器、数据源、全局异常。
   - `ruoyi-common`：基础领域对象、注解、常量、工具类、Excel/文件/分页辅助。
   - `ruoyi-system`：系统领域、服务、Mapper 与 RBAC 数据。
   - `ruoyi-quartz`：定时任务控制器、服务和任务执行。
   - `ruoyi-generator`：Velocity CRUD 生成器和菜单 SQL。
4. 以目标项目本地约定为准；若依二开项目经常改生成器模板、包名、权限字符串和前端封装。

## 引用地图

只读取当前任务需要的文件：

- `references/source-map.md`：模块地图、关键文件、创建本技能时参考的源码快照。
- `references/backend-patterns.md`：控制器、服务、Mapper、分页、返回值、数据权限、数据源、事务。
- `references/frontend-patterns.md`：Thymeleaf、`include.html`、`ry-ui.js`、bootstrap-table、权限、字典、表单。
- `references/security-and-ops.md`：Shiro、CSRF/XSS、文件上传下载、Quartz 调用安全、日志、防重复提交。
- `references/development-workflow.md`：CRUD/变更流程、代码生成器使用、验证命令、评审清单。

## 工作规则

- 页面和 Ajax 端点分开：页面方法返回模板路径；表格和操作接口返回 `TableDataInfo` 或 `AjaxResult`。
- 分页查询前立刻调用 `BaseController.startPage()`，查询后用 `getDataTable(list)`。
- 后端 `@RequiresPermissions("module:business:action")` 要与前端 `shiro:hasPermission` 或 `@permission.hasPermi` 配套。
- 管理端写操作添加 `@Log(title = "...", businessType = BusinessType.INSERT/UPDATE/DELETE/EXPORT/IMPORT/GRANT)`。
- 持久化业务查询放在 Mapper XML 中，保持 mapper 方法名、XML id 和 service 调用同步。
- MyBatis 用户输入使用 `#{}`。除 AOP 生成的 `params.dataScope`、已清洗排序字段等受控片段外，不要使用 `${}`。
- 不要绕过用户、角色、部门以及组织范围数据的数据权限检查。
- CRUD 生成优先读取并适配 `ruoyi-generator/src/main/resources/vm/**`，不要另造一套风格。
- Spring Boot 4 分支使用 Java 17 和 Jakarta imports；旧分支可能是 Java 8 与 `javax.*`，以本地项目为准。

## 验证

按风险选择最窄有效检查：

- 全模块编译：`mvn clean package -DskipTests`
- 编译入口模块及依赖：`mvn -pl ruoyi-admin -am package -DskipTests`
- 本地运行：`mvn -pl ruoyi-admin -am spring-boot:run`
- 涉及数据库时，检查 `sql/` 下的表结构和 Mapper XML 是否一致。

报告时说明修改模块、运行命令，以及仍需浏览器、数据库或后台手工验证的部分。
