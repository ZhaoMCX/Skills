# Spring Security OAuth2 开发地图

## OAuth2 Client

用于 OAuth2 登录、第三方授权和代表用户调用资源。

- 检查 Spring Security 版本、provider、grant type、client registration。
- 读取 `oauth2Login`、authorized client manager、WebClient/RestClient、token storage。
- 授权码流程使用 PKCE 保护公开客户端；secret 不进入前端。
- redirect URI 与 provider 注册完全匹配。
- Token relay 只传递给可信资源服务，保留最小 scope。
- refresh token 存储要安全，登出和撤销有策略。
- 登录回调失败查 redirect URI、state、session、SameSite、client id/secret。
- WebClient 未带 token 查 authorized client manager、principal、filter 注册。

## Resource Server

用于保护 REST/API 资源服务。

- 确认 token 类型：JWT 或 opaque token；读取 issuer、JWK、introspection、audience。
- 读取 `oauth2ResourceServer`、converter、authority mapping、method security、CORS。
- JWT 校验 issuer、signature、expiration、audience；不要只解码不验证。
- scope/role 到 authority 的映射清楚，避免前后缀混乱。
- Opaque token introspection 配置超时、缓存和失败策略。
- API 层与 service 层双重保护关键操作。
- 401 查 Authorization header、issuer、JWK、过期、签名、时钟偏差。
- 403 查 authority mapping、scope、method security、路径规则。

## Authorization Server

用于实现 OAuth2/OIDC 授权服务器。

- 确认版本、Boot/Security 兼容性和是否启用 OIDC。
- 读取 `RegisteredClientRepository`、`AuthorizationServerSettings`、JWK、token customizer、consent、login 配置。
- 使用 Authorization Code + PKCE 保护公开客户端；机器调用使用 Client Credentials。
- client secret 必须安全存储和编码；不要把生产 client secret 写入配置样例。
- JWK rotation、token lifetime、issuer、audience、scope 和 claim 设计要有清晰策略。
- token 自定义只加入必要 claim；避免塞入大量业务状态或敏感信息。
- redirect_uri 失败查注册客户端、协议、域名、端口、context path 和 exact match。
