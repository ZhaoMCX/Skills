# 源码地图

本技能参考 `yangzongzhuan/RuoYi-Cloud` 快照 `3979713`（2026-04-17，版本 `3.6.8`）和 `RuoYi-Cloud-Vue3` 前端快照 `277b1c8`。代表技术栈：Java 17、Spring Boot 4.0.3、Spring Cloud 2025.1、Spring Cloud Alibaba 2025.1、Nacos、Gateway、Sentinel、OpenFeign、Redis、MyBatis XML、PageHelper、Druid、dynamic-datasource、Seata、JWT。

同族变体：

- `RuoYi-Cloud`：后端微服务 + `ruoyi-ui` Vue2 前端。
- `RuoYi-Cloud-Oracle`：Oracle 版，SQL/驱动/函数/分页差异以本地项目为准。
- `RuoYi-Cloud-Vue3`：独立 Vue3 前端，前端开发使用 `ruoyi-vue3`。

## 根模块

- `pom.xml`：Cloud/Alibaba/Boot BOM、若依公共模块版本、模块列表。
- `docker/`：中间件和服务部署参考。
- `sql/`：库表初始化。
- `bin/`：打包/运行脚本。

## 服务模块

`ruoyi-gateway`

- 入口：`RuoYiGatewayApplication`。
- 配置：`src/main/resources/bootstrap.yml`。
- 鉴权：`filter/AuthFilter.java`。
- 验证码：`ValidateCodeFilter`、`ValidateCodeService`。
- 黑名单/XSS/异常：`BlackListUrlFilter`、`XssFilter`、`GatewayExceptionHandler`。
- Swagger 聚合：`SpringDocConfig`、`RouterFunctionConfiguration`。

`ruoyi-auth`

- 入口：`RuoYiAuthApplication`。
- 登录 token：`controller/TokenController.java`。
- 登录逻辑：`service/SysLoginService.java`、`SysPasswordService.java`、`SysRecordLogService.java`。
- 表单：`LoginBody`、`RegisterBody`、`UnLockBody`。

`ruoyi-modules`

- `ruoyi-system`：用户、角色、菜单、部门、字典、参数、日志等核心系统服务。
- `ruoyi-gen`：代码生成服务。
- `ruoyi-job`：定时任务服务。
- `ruoyi-file`：文件服务，常与 MinIO/本地存储相关。

`ruoyi-api`

- `ruoyi-api-system`：跨服务接口、DTO/domain、fallback factory。
- 典型接口：`RemoteUserService`、`RemoteLogService`、`RemoteFileService`。

`ruoyi-common`

- `ruoyi-common-core`：基础常量、`R`、`AjaxResult`、`BaseController`、分页、工具。
- `ruoyi-common-security`：token、鉴权注解、AOP、Feign 拦截器、上下文。
- `ruoyi-common-datascope`：数据权限。
- `ruoyi-common-datasource`：主从/多数据源注解。
- `ruoyi-common-log`：操作日志。
- `ruoyi-common-redis`：Redis 服务。
- `ruoyi-common-swagger`：Springdoc。
- `ruoyi-common-seata`：分布式事务。
- `ruoyi-common-sensitive`：脱敏。

## 关键链路

1. 前端请求 Gateway。
2. Gateway `AuthFilter` 校验 token、Redis 登录态和白名单。
3. Gateway 将 `userKey`、`userId`、`username` 写入请求头。
4. Gateway 路由到业务服务。
5. 业务服务通过 `HeaderInterceptor` / `SecurityUtils` 读取请求头用户信息。
6. 方法上的 `@RequiresPermissions` 由 `PreAuthorizeAspect` 调用 `AuthUtil` 校验。
7. 跨服务调用由 Feign 传递用户和 token 请求头。
