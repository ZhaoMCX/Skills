---
name: spring-cloud
description: Guides Spring Cloud microservice and distributed integration development, review, debugging, and upgrades across release trains, Config, Gateway, OpenFeign, LoadBalancer, Circuit Breaker, Stream, Contract, Kubernetes, AMQP/RabbitMQ, Kafka, Pulsar, Integration flows, and distributed service patterns. Use when working with Spring Cloud, microservices, Gateway routes, Feign clients, service discovery, config server, bootstrap.yml, load balancing, circuit breakers, stream binders, Spring Integration, Kafka, RabbitMQ, Pulsar, or Cloud release train compatibility.
---

# Spring Cloud

用于 Spring Cloud 微服务项目。若项目是 RuoYi Cloud 或 Nacos/Sentinel/Seata 体系，同时使用 `ruoyi-cloud` 或项目专属技能。

## 首轮检查

1. 确认 Boot 版本与 Spring Cloud release train；必须以官方 compatibility matrix 和项目 BOM 为准。
2. 识别 Cloud 子项目：Config、Gateway、OpenFeign、LoadBalancer、Circuit Breaker、Stream、Contract、Kubernetes、Vault、Consul、Bus。
3. 读取 `bootstrap.yml`、`application.yml`、配置中心约定、网关路由、服务发现、Feign 接口和熔断降级。
4. 查官方文档：`https://spring.io/projects/spring-cloud/` 与 `https://docs.spring.io/spring-cloud/`。

## 开发规则

- 依赖：使用 Cloud BOM，不单独拼子项目版本；升级先验证 Boot/Cloud 配套。
- Gateway：路由、predicate、filter、鉴权、限流和转发路径分层清楚；避免在业务服务重复网关职责。
- Feign：接口、fallback、错误码、超时、重试、鉴权头透传要成套维护。
- 配置中心：区分本地 fallback 与远程配置；敏感值不写入提交或文档。
- Stream：明确 binder、destination、consumer group、重试、DLQ 和幂等策略。
- Contract：服务契约变更要同时覆盖 provider test 和 consumer stub。

## 引用地图

| 任务 | 阅读 |
| --- | --- |
| Gateway、Feign、Config、LoadBalancer、Circuit Breaker、Stream、Contract、Kubernetes | `references/cloud-subprojects.md` |
| Spring Integration flow、AMQP/RabbitMQ、Kafka、Pulsar | `references/messaging-and-flows.md` |

## 调试清单

- 服务找不到：查 discovery client、service id、namespace/group、profile、网络和健康状态。
- Gateway 404/转发错：查 route order、path rewrite、strip prefix、predicate 和下游 context path。
- Feign 失败：查 base service name、负载均衡、超时、编码器/解码器、fallback factory。
- 配置没生效：查 bootstrap/application 加载顺序、profile、config import、远程配置优先级。
- 熔断误触发：查超时、线程池/信号量隔离、错误计数窗口和重试叠加。

## 验证

```powershell
mvn test
mvn -pl <module> -am test
.\gradlew test
```

联调还需验证配置中心、注册中心、网关、下游服务和消息中间件。汇报版本矩阵与外部依赖状态。
