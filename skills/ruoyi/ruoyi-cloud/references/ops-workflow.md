# 运行与排错工作流

## 配置来源

服务使用 `bootstrap.yml` 连接 Nacos：

- `spring.application.name`
- `spring.profiles.active`
- `spring.cloud.nacos.discovery.server-addr`
- `spring.cloud.nacos.config.server-addr`
- `spring.config.import`

常见 dataId：

- `application-dev.yml`
- `ruoyi-gateway-dev.yml`
- `ruoyi-auth-dev.yml`
- `ruoyi-system-dev.yml`
- `ruoyi-gen-dev.yml`
- `ruoyi-job-dev.yml`
- `ruoyi-file-dev.yml`
- Sentinel 规则如 `sentinel-ruoyi-gateway`。

修改配置时确认目标环境、namespace、group、profile，避免只改本地文件而实际运行读取 Nacos。

## 启动顺序

本地联调通常需要：

1. MySQL/Oracle。
2. Redis。
3. Nacos。
4. Sentinel dashboard（若启用）。
5. Seata server（涉及分布式事务时）。
6. MinIO 或文件存储（涉及文件模块时）。
7. Gateway。
8. Auth。
9. System、Gen、Job、File 等业务服务。
10. 前端。

## 新增服务或模块

检查：

- 根 `pom.xml` modules。
- 服务 `pom.xml` 依赖。
- `bootstrap.yml` 应用名和 Nacos 配置。
- Nacos gateway route。
- Feign API 契约和 fallback。
- Swagger 聚合配置。
- Docker/bin 脚本是否需要补充。
- SQL 初始化和权限菜单。

## 验证命令

```powershell
mvn clean package -DskipTests
mvn -pl ruoyi-gateway -am package -DskipTests
mvn -pl ruoyi-auth -am package -DskipTests
mvn -pl ruoyi-modules/ruoyi-system -am package -DskipTests
```

单服务运行可用 IDE 或项目脚本。命令行运行前确认 Nacos 配置可访问。

## 常见排错

401/登录过期：

- Gateway 白名单是否遗漏。
- Authorization header 是否带 `Bearer `。
- Redis 登录 token 是否存在。
- JWT secret 是否一致。
- 网关是否正确透传用户请求头。

403/无权限：

- 菜单 perms 是否存在。
- 用户角色权限是否刷新。
- `@RequiresPermissions` 字符串是否和前端一致。
- 内部接口是否误用了外部鉴权。

Feign 调用失败：

- 服务名和 Nacos 注册名是否一致。
- `ruoyi-api` path 是否和 provider controller 匹配。
- fallback factory 是否吞掉真实错误。
- 请求头是否通过 `FeignRequestInterceptor` 透传。

配置不生效：

- 当前 profile。
- Nacos namespace/group/dataId。
- 本地 `bootstrap.yml` 是否只负责导入远程配置。
- 服务是否重启或刷新。

## 评审清单

- 外部接口必须经过 Gateway。
- 内部接口使用 `@InnerAuth` 且防伪来源头不能由客户端传入。
- 跨服务新增接口维护了 API、fallback、provider 和调用方。
- Nacos 路由、前端 API、controller path 一致。
- 数据权限、日志、事务、缓存和 Redis 登录态没有被绕过。
- 配置没有提交真实密钥、生产地址或过宽白名单。
