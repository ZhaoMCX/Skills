---
name: spring-boot
description: Guides Spring Boot and SpringBoot application development, review, debugging, upgrades, tests, configuration, starters, auto-configuration, Actuator, Spring Framework core/web behavior, Batch jobs, AI integrations, packaging, and production readiness. Use when working with Spring Boot, SpringBoot, Spring Framework, @SpringBootApplication, spring-boot-starter, Spring Initializr, Boot Maven/Gradle plugins, application.yml/properties, @ConfigurationProperties, @SpringBootTest, Actuator, Spring MVC/WebFlux, Spring Batch, or Spring AI.
---

# Spring Boot

用于处理 Spring Boot 项目。优先以本地项目版本和官方文档为准，不把当前最新版本当成所有项目的默认答案。

## 首轮检查

1. 识别构建工具和版本来源：`pom.xml`、`build.gradle`、`settings.gradle`、`gradle.properties`、wrapper、父 POM、BOM、`spring-boot-starter-parent`、`spring-boot-dependencies`。
2. 确认实际 Spring Boot、Spring Framework、Java、Maven/Gradle 版本；多模块项目逐模块核对继承和 dependency management。
3. 读取入口和边界：`@SpringBootApplication`、主包路径、`@ComponentScan`、profiles、`application*.yml`、`bootstrap*.yml`、环境变量约定。
4. 涉及 Spring Cloud、Spring Data 或 Spring Security 时，同时使用对应主技能；Batch、AI 和 Framework/Web 细节在本技能 references 内处理。
5. 涉及 RuoYi 项目时，同时使用对应 `ruoyi-*` 技能，按项目既有封装和权限体系落地。

## 官方文档优先级

1. 先查项目锁定版本对应的 Spring Boot Reference、API 和 release notes。
2. 当前版本不清楚时，先读本地 dependency tree 或 lockfile，再查 `https://docs.spring.io/spring-boot/`。
3. 只有在做新项目选型、升级建议或用户要求最新信息时，才查 Spring 官网当前稳定版本。
4. 版本兼容、弃用、迁移、CVE、安全公告和发行状态必须联网确认官方来源。

## 工作流

- 新增功能：先找合适 starter 和自动配置，再判断是否需要显式 `@Configuration`；避免复制框架已有配置。
- 配置变更：优先使用类型安全的 `@ConfigurationProperties`，敏感值留给外部环境或配置中心。
- Web 接口：区分 Servlet MVC 与 WebFlux；不要混用阻塞和响应式栈，除非项目已明确这样设计。
- 数据访问：确认 JPA/JDBC/R2DBC/MyBatis 等项目实际栈；事务边界放在 service 层。
- 测试：优先选择 test slice，例如 `@WebMvcTest`、`@DataJpaTest`；需要完整上下文时再用 `@SpringBootTest`。
- 生产化：检查 Actuator、health、metrics、logging、profiles、graceful shutdown、container image、配置外置和安全暴露面。

## 决策规则

| 情况 | 默认处理 |
| --- | --- |
| 依赖版本冲突 | 先恢复 Boot BOM 管理，再最小化显式版本覆盖。 |
| 自动配置没有生效 | 查条件评估、classpath、properties、profile 和 bean 覆盖。 |
| 配置读取异常 | 查属性源顺序、profile、relaxed binding、类型转换和校验。 |
| 测试太慢 | 用 slice、mock 外部边界、Testcontainers 只覆盖真实集成风险。 |
| 需要暴露 Actuator | 默认最小暴露，只开放必要 endpoint，并审查鉴权。 |
| 升级 Boot 大版本 | 先读 migration guide/release notes，再改 Java、Jakarta、依赖和插件。 |

## 引用地图

- `references/official-doc-map.md`：官方入口、Boot 文档阅读顺序、版本和兼容性检查清单。
- `references/web-and-core.md`：Spring Framework IoC、事务、MVC/WebFlux、WebClient、GraphQL/HATEOAS/Web Services 和测试排障。
- `references/batch-and-ai.md`：Spring Batch job/step/restart/chunk，以及 Spring AI provider、RAG、prompt、tool calling 开发清单。

## 验证

常用命令按项目构建工具调整：

```powershell
mvn test
mvn spring-boot:run
mvn -DskipTests package
.\gradlew test
.\gradlew bootRun
.\gradlew bootJar
```

报告修改时说明：Boot 版本、涉及 starter/auto-configuration、配置项、profile、测试命令、仍需真实环境验证的部分。
