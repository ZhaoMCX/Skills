# Spring Boot 官方文档地图

## 核心入口

- Spring Boot 项目页：`https://spring.io/projects/spring-boot/`
- Spring Boot 文档首页：`https://docs.spring.io/spring-boot/`
- Spring Boot Reference：`https://docs.spring.io/spring-boot/reference/`
- System Requirements：`https://docs.spring.io/spring-boot/system-requirements.html`
- Release notes：`https://github.com/spring-projects/spring-boot/wiki`
- Spring Initializr：`https://start.spring.io/`
- Spring Guides：`https://spring.io/guides`
- Spring security advisories：`https://spring.io/security`

## 阅读顺序

1. `System Requirements`：核对 Java、Maven/Gradle、Spring Framework、Servlet container、GraalVM 要求。
2. `Developing with Spring Boot`：构建系统、代码结构、configuration class、auto-configuration、dependency injection、运行和打包。
3. `Core Features`：`SpringApplication`、externalized configuration、profiles、logging、JSON、scheduling、custom auto-configuration。
4. `Web`、`Data`、`IO`、`Messaging`：按项目实际 starter 选择章节。
5. `Testing`：test modules、test scope dependencies、Spring application tests、Boot application tests、Testcontainers。
6. `Production-ready Features`：Actuator endpoints、HTTP/JMX management、observability、loggers、metrics、tracing、auditing。
7. `Build Tool Plugins`：Maven/Gradle plugin、bootRun、bootJar/bootWar、OCI image、AOT、integration tests。
8. `Appendix`：common application properties、auto-configuration classes、test slices、managed dependency versions。

## 本地项目检查清单

- Maven：`mvn -q help:effective-pom`、`mvn dependency:tree`。
- Gradle：`.\gradlew dependencies`、`.\gradlew dependencyInsight --dependency <name>`。
- Boot 版本：查 parent、BOM、plugin、lockfile 和构建输出，避免只看某一个文件。
- Java 版本：查 toolchain、compiler/sourceCompatibility、CI、Dockerfile、运行环境。
- 配置来源：查 `application.yml`、profile 文件、环境变量、命令行参数、配置中心、测试属性。
- 自动配置：查 classpath、`spring.autoconfigure.exclude`、条件报告、`@Conditional*`、bean 覆盖。
- Actuator：查 `management.endpoints.web.exposure.include`、base path、health group、鉴权和网络边界。

## 常见章节对应问题

| 问题 | 优先章节 |
| --- | --- |
| starter 该怎么选 | Developing with Spring Boot / Build Systems |
| Bean 为什么没注入 | Spring Beans and Dependency Injection / Spring Framework IoC |
| 自动配置为什么没生效 | Auto-configuration / Appendix auto-configuration classes |
| 配置值为什么不对 | Externalized Configuration / Profiles / Common Application Properties |
| Controller 行为异常 | Web / Servlet Web Applications 或 Reactive Web Applications |
| 数据库初始化、事务、JPA | Data / SQL Databases / Spring Data 官方文档 |
| 测试启动慢或上下文失败 | Testing / Test slices / Spring TestContext |
| 健康检查、指标、日志 | Production-ready Features / Actuator |
| 镜像和部署 | Packaging / Container Images / Build Tool Plugins |
| 原生镜像 | GraalVM Native Images / AOT |

## 版本和兼容性规则

- 不要凭记忆写 Spring Boot 与 Java、Spring Framework、Spring Cloud 的兼容矩阵；每次以官方页面或项目 BOM 为准。
- Boot 管理大量三方依赖版本。除非修复安全问题或项目明确要求，不要随意覆盖 managed dependency。
- Boot 3+ 迁移常涉及 Jakarta namespace、Java baseline、Hibernate/Spring Security/Cloud 兼容性；先读迁移说明再改代码。
- Spring Cloud 必须按 release train 与 Boot 版本配套；使用 `spring-cloud` 的 Cloud 检查规则。

## 实现偏好

- 配置类保持小而有边界；只有在 auto-configuration 不满足需求时才新增显式 bean。
- DTO、entity、configuration properties、API contract 分清职责。
- 使用 constructor injection；避免 field injection，除非项目历史风格强依赖。
- 外部系统客户端增加超时、重试/熔断策略和测试替身。
- 生产 endpoint 默认最小暴露；敏感配置值不写入日志、文档或回复。
