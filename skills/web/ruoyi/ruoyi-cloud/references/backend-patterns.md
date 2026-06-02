# 后端模式

## Gateway

`AuthFilter` 是外部请求鉴权入口：

- 读取请求 path。
- 匹配白名单 `IgnoreWhiteProperties`。
- 从 `Authorization` 读取 Bearer token。
- 解析 JWT claim。
- 检查 Redis 中 `login_tokens:<userKey>` 是否存在。
- 将 `USER_KEY`、`DETAILS_USER_ID`、`DETAILS_USERNAME` 写入请求头。
- 删除外部传入的 `FROM_SOURCE`，防止伪造内部请求。

规则：

- 新增公开接口必须明确加入白名单配置，避免误放行。
- 不要允许客户端直接传 `FROM_SOURCE`。
- Gateway 是 WebFlux，过滤器和响应写法不同于 MVC。

## Auth 服务

`TokenController`：

- `POST /login`：调用 `SysLoginService.login`，通过 `TokenService.createToken` 返回 token。
- `DELETE /logout`：删除 Redis 登录态并记录退出日志。
- `POST /refresh`：刷新 token 有效期。
- `POST /register`：注册。
- `POST /unlockscreen`：解锁。

登录用户信息来自系统服务的内部接口。修改登录字段、验证码、密码策略时，同时看 auth、gateway、system、前端登录页。

## 业务服务 Controller

业务模块路径通常是服务内部路径。例如 `ruoyi-system` 用户 controller 是：

```java
@RestController
@RequestMapping("/user")
public class SysUserController extends BaseController
{
    @RequiresPermissions("system:user:list")
    @GetMapping("/list")
    public TableDataInfo list(SysUser user) { ... }
}
```

外部访问路径由网关路由组合，不一定等于单体版 `/system/user/list`。改路径时同步检查：

- Nacos gateway route 配置。
- 前端 API URL。
- Feign client path。
- Swagger 聚合。

## 内部接口

内部接口使用 `@InnerAuth`，通常在 provider controller 上：

```java
@InnerAuth
@GetMapping("/info/{username}")
public R<LoginUser> info(@PathVariable String username) { ... }
```

调用方通过 `ruoyi-api-*` 的 Feign interface 调用。新增内部接口时：

- 在 `ruoyi-api` 定义接口和 fallback factory。
- 在 provider 实现 controller。
- 调用方传递 `SecurityConstants.INNER` 或使用既有调用工具。
- 确保 `FeignRequestInterceptor` 能透传用户和 token 请求头。

## 权限

Cloud 版不用 Spring Security `@PreAuthorize`，而用自定义注解：

- `@RequiresLogin`
- `@RequiresPermissions`
- `@RequiresRoles`
- `@InnerAuth`

`PreAuthorizeAspect` 调用 `AuthUtil` 校验权限。权限数据来自 Redis 中的登录用户权限集合和系统服务菜单权限。

## 数据权限

`ruoyi-common-datascope` 的 `@DataScope` 与单体类似：

- 读取当前 `LoginUser`。
- 非管理员根据角色数据范围生成 SQL。
- 写入 `BaseEntity.params.dataScope`。
- Mapper XML 通过 `${params.dataScope}` 追加。

保持注解别名与 SQL 别名一致，避免把请求参数里的 `params.dataScope` 当可信输入。

## 跨服务公共模块

放置规则：

- 通用常量、基础响应、分页：`ruoyi-common-core`。
- 安全上下文、token、Feign 请求头、鉴权注解：`ruoyi-common-security`。
- 数据权限：`ruoyi-common-datascope`。
- 数据源：`ruoyi-common-datasource`。
- 日志：`ruoyi-common-log`。
- Redis：`ruoyi-common-redis`。
- 服务 API 契约：`ruoyi-api-*`。

不要让业务模块互相直接依赖实现模块；跨服务只依赖 `ruoyi-api` 和公共模块。

## 分布式事务

涉及跨服务写操作时检查项目是否启用 Seata，并使用本地既有 `@GlobalTransactional` 或服务编排模式。不要用单体事务假设跨服务一致性。
