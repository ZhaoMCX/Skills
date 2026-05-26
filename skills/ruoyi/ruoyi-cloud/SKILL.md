---
name: ruoyi-cloud
description: 该技能处理若依微服务项目族：RuoYi-Cloud、RuoYi-Cloud-Oracle，以及与 RuoYi-Cloud-Vue3 的接口边界，覆盖 Spring Boot、Spring Cloud & Alibaba、Nacos、Gateway、Auth、Feign、Redis、Sentinel、Seata、多模块服务与若依权限体系。Use when 项目包含 ruoyi-gateway、ruoyi-auth、ruoyi-modules、ruoyi-api、ruoyi-common-security、bootstrap.yml、Nacos 配置、@InnerAuth、@RequiresPermissions，或仓库名为 RuoYi-Cloud。
---

# RuoYi Cloud

用于若依微服务版。前端若是 `ruoyi-ui` Vue2 可参考 `ruoyi-vue` 的前端模式；若是 `RuoYi-Cloud-Vue3` 独立前端，使用 `ruoyi-vue3`。

## 首轮检查

1. 读取根 `pom.xml`、各服务 `bootstrap.yml`、`docker/`、`sql/`。
2. 确认服务边界：`ruoyi-gateway`、`ruoyi-auth`、`ruoyi-modules/*`、`ruoyi-api/*`、`ruoyi-common/*`、`ruoyi-visual/*`。
3. 涉及接口时确认外部路由经 Gateway，内部调用经 Feign，是否需要 `@InnerAuth`。
4. 涉及配置时确认 Nacos dataId、profile、namespace/group，以及本地 fallback 配置。
5. Oracle 变体优先检查本地 SQL、驱动、分页和函数差异。

## 引用地图

- `references/official-sources.md`：官方仓库、分支和来源优先级。
- `references/source-map.md`：模块职责、关键文件、服务链路。
- `references/backend-patterns.md`：Gateway、Auth、Token、Feign、权限、数据权限、模块开发。
- `references/ops-workflow.md`：Nacos/Sentinel/Redis/Seata、启动顺序、验证和排错清单。

## 工作规则

- 不要把单体版 Controller 路径直接套进 Cloud；业务模块 controller 通常在服务内使用短路径，如系统服务 `/user`，外部路径由网关路由前缀组合。
- 外部请求必须走 Gateway 鉴权；内部 Feign 接口使用 `@InnerAuth` 和 `SecurityConstants.FROM_SOURCE` 约定。
- Gateway `AuthFilter` 校验 JWT 和 Redis 登录态，并把 user key、user id、username 写入请求头；不要绕过这条身份透传链。
- 权限使用若依 Cloud 自定义 `@RequiresPermissions` / `@RequiresRoles`，由 `PreAuthorizeAspect` 调用 `AuthUtil` 校验。
- 跨服务调用新增接口时，同时维护 `ruoyi-api` 接口、fallback factory、provider controller 和调用方。
- 业务公共能力优先放入 `ruoyi-common-*` 合适子模块，不要让业务服务互相复制基础设施代码。
- 配置优先进入 Nacos；提交本地配置时不要写入生产密钥、真实地址或宽松白名单。

## 验证

常用命令：

```powershell
mvn clean package -DskipTests
mvn -pl ruoyi-gateway -am package -DskipTests
mvn -pl ruoyi-auth -am package -DskipTests
mvn -pl ruoyi-modules/ruoyi-system -am package -DskipTests
```

联调需要 Nacos、Redis、数据库，按项目启用 Sentinel/Seata/MinIO 等依赖。报告修改的服务、配置项、启动/构建命令，以及仍需环境验证的部分。
