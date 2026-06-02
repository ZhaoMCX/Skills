---
name: spring-security
description: Guides Spring Security development, review, debugging, and upgrades across authentication, authorization, SecurityFilterChain, method security, CSRF, sessions, OAuth2 login/client/resource server, JWT, password encoding, testing, and migration. Use when working with Spring Security, SecurityFilterChain, @PreAuthorize, @Secured, OAuth2, JWT, Resource Server, form login, CSRF, CORS, roles, permissions, or access-denied behavior.
---

# Spring Security

用于认证、授权和安全过滤链。授权服务器另用 `spring-authorization-server`。

## 首轮检查

1. 确认 Security 版本、Boot auto-configuration、是否使用 OAuth2/OIDC/JWT/session。
2. 读取 `SecurityFilterChain`、method security、用户加载、密码编码、CORS/CSRF、异常处理。
3. 确认前后端边界：浏览器 session、API token、resource server、gateway 鉴权或混合模式。
4. 查官方 reference：`https://docs.spring.io/spring-security/reference/`。

## 开发规则

- 明确 authentication 与 authorization；不要把角色、权限、租户和数据权限混成一个字符串判断。
- `SecurityFilterChain` 按路径分链时要注意 order；默认拒绝未明确允许的敏感入口。
- 密码必须使用 `PasswordEncoder`；不要明文、可逆加密或硬编码默认密码。
- CSRF：浏览器 cookie/session 场景默认保留；纯 token API 才按边界关闭。
- JWT：服务端校验签名、issuer、audience、过期时间和权限映射；不要信任客户端声明。
- Method security 与 web security 互补，关键业务操作保留 service 层授权。

## 引用地图

| 任务 | 阅读 |
| --- | --- |
| OAuth2 Client、Resource Server、Authorization Server | `references/oauth2-and-resource-server.md` |

## 调试清单

- 401 vs 403：分别查认证是否成功、权限是否满足、entry point 和 access denied handler。
- 登录成功但接口失败：查 session/cookie、token 透传、CORS、SameSite、权限映射。
- `@PreAuthorize` 不生效：查启用注解、代理、自调用、表达式和返回对象。
- CSRF 报错：查请求方法、token 注入、前端 header/cookie 和是否应保留 CSRF。
- OAuth2/JWT 失败：查 issuer、JWK、clock skew、scope/authority mapping。

## 验证

```powershell
mvn test
mvn -Dtest=*Security* test
.\gradlew test
```

报告必须说明安全边界、开放路径、鉴权方式、权限模型、测试覆盖和仍需人工安全复核的点。
