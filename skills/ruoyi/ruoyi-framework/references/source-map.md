# 源码地图

本文件的模块地图来自 `yangzongzhuan/RuoYi` 经典单体版的参考快照，仅用于说明常见结构和命名。实际版本、JDK、Spring Boot、Shiro、`javax`/`jakarta`、依赖和模板以目标项目本地代码及当前官方分支为准。

同族变体：

- `RuoYi-fast`：单模块快速版，源码集中在 `src/`，仍是 Shiro + Thymeleaf + MyBatis + jQuery 模式。
- `RuoYi-Oracle`：经典多模块 Oracle 版，核心模式同 `RuoYi`，但 SQL、驱动、分页/函数差异以本地项目为准。

始终先读目标仓库。RuoYi 同时维护 Spring Boot 2/3/4 分支，很多 fork 会改包名、权限、前端助手和生成器模板。

## 根目录

- `pom.xml`：父 POM、依赖管理、模块列表、Java/Spring Boot 版本。
- `ry.bat`、`ry.sh`：本地运行脚本。
- `sql/ry_*.sql`、`sql/quartz.sql`：初始化库表和 Quartz 表。
- `doc/若依环境使用手册.docx`：存在时可作为本地环境指南。

## 模块

`ruoyi-admin`

- 应用入口：`src/main/java/com/ruoyi/RuoYiApplication.java`。
- 控制器：`src/main/java/com/ruoyi/web/controller/**`。
- 配置：`src/main/resources/application.yml`、`application-druid.yml`、`logback.xml`、`mybatis/mybatis-config.xml`。
- 页面：`src/main/resources/templates/**`。
- 公共模板片段：`templates/include.html`。
- 前端封装：`static/ruoyi/js/ry-ui.js`、`static/ruoyi/js/common.js`。

`ruoyi-common`

- 基础 Web/领域契约：`BaseController`、`AjaxResult`、`TableDataInfo`、`BaseEntity`。
- 注解：`@Log`、`@DataScope`、`@DataSource`、`@RepeatSubmit`、`@Excel`、`@Xss`、`@Anonymous`。
- 常量、枚举和工具：`Constants`、`UserConstants`、`ScheduleConstants`、`BusinessType`、`DataSourceType`、`StringUtils`、`ShiroUtils`、`PageUtils`、`ExcelUtil`、`FileUploadUtils`。

`ruoyi-framework`

- 安全：`ShiroConfig`、`UserRealm`、登录/密码/注册服务、自定义过滤器。
- MVC/资源：`ResourcesConfig`、`GlobalExceptionHandler`、`RepeatSubmitInterceptor`、`SameUrlDataInterceptor`。
- AOP：`LogAspect`、`DataScopeAspect`、`DataSourceAspect`、`PermissionsAspect`。
- 数据源/MyBatis：`DruidConfig`、`DynamicDataSource`、`MyBatisConfig`。
- Thymeleaf 服务：以 `@permission` 暴露的 `PermissionService`，以 `@dict` 暴露的 `DictService`，以及 `ConfigService`、`CacheService`。

`ruoyi-system`

- 核心 RBAC/系统业务：用户、角色、菜单、部门、岗位、字典、参数、通知、登录日志、操作日志。
- 常见结构：`domain/`、`mapper/`、`service/`、`service/impl/`、`resources/mapper/system/*.xml`。

`ruoyi-quartz`

- `com.ruoyi.quartz` 下的控制器和服务。
- 调度安全与执行工具：`ScheduleUtils`、`CronUtils`、`JobInvokeUtil`、`AbstractQuartzJob`。
- 模块资源中包含 Mapper XML 和任务页面。

`ruoyi-generator`

- 代码生成相关控制器页面随模块资源打包。
- 配置：`src/main/resources/generator.yml`。
- 模板：`src/main/resources/vm/java`、`vm/html`、`vm/xml`、`vm/sql`。
- 关键辅助：`GenUtils`、`VelocityUtils`、`VelocityInitializer`。

## 架构形态

- 这是服务端渲染后台应用。控制器同时返回 Thymeleaf 页面和 Ajax JSON。
- RBAC 基于 Shiro。菜单、按钮权限和后端注解共享 `system:user:list` 这类权限字符串。
- MyBatis 类型别名扫描 `com.ruoyi.**.domain`，Mapper XML 从 `classpath*:mapper/**/*Mapper.xml` 加载。
- PageHelper 从请求参数读取 `pageNum`、`pageSize`、`orderByColumn`、`isAsc`。
- 前端助手期待表格响应为 `{ code: 0, rows: [], total: n }`，操作响应为 `{ code: 0|301|500, msg, data? }`。
