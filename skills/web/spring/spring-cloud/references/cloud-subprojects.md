# Spring Cloud 子项目开发地图

## Gateway

用于 API Gateway 路由、过滤器和边界流量治理。

- 检查 Boot/Cloud release train、Gateway 版本、routes、predicate、filter、global filter、CORS、security、discovery locator。
- 路由匹配、路径重写、鉴权、限流、观测各自分层；不要把业务逻辑塞进网关。
- 过滤器顺序必须明确，尤其是认证、header 透传、rewrite、body 读取和日志。
- `lb://` 路由依赖服务发现和 LoadBalancer；服务名大小写与平台约定一致。
- Gateway 是响应式栈，filter 中避免阻塞调用。
- 404 查 Path predicate、StripPrefix/RewritePath、route order、下游 context path。
- 502/503 查服务发现、LoadBalancer、实例健康、网络和超时。

## OpenFeign

用于声明式 HTTP 客户端和服务间调用。

- 检查 `@FeignClient`、configuration、fallback/fallbackFactory、interceptor、decoder、timeout。
- Feign interface 是契约；路径、method、参数和返回类型与 provider 同步维护。
- fallback 只做降级，不吞掉需要暴露的业务错误；优先 `FallbackFactory` 保留异常原因。
- 设置连接和读取超时；重试策略要与幂等性匹配。
- 认证、租户、trace header 通过 interceptor 明确透传。
- 404/405 查 provider 路径、context path、method、网关前缀。
- 解码失败查 content type、Jackson 配置、泛型返回值和错误体。

## Config

用于集中配置服务和客户端配置加载。

- 检查 Config Server/Client、`spring.config.import` 或 legacy bootstrap 模式。
- 读取 server backend、application/profile/label、加密配置、refresh/bus、客户端 fallback。
- 本地配置只放安全 fallback；生产敏感值放受控后端或 secret 管理。
- 加密/解密密钥不提交；密钥轮换有流程。
- refresh 只用于可安全热更新的 bean；关键基础设施配置需要重启策略。
- 远程配置没加载查 config import、profile、application name、URI、label、认证。
- 值被覆盖查 property source 顺序、环境变量、命令行参数、本地 profile。

## LoadBalancer

用于客户端负载均衡和服务实例选择。

- 检查调用方：Gateway、Feign、RestClient、WebClient。
- 读取 `@LoadBalanced` bean、`ServiceInstanceListSupplier`、retry、health check、zone/metadata。
- 服务名必须与注册中心一致；不要混用固定 URL 和服务发现语义。
- 自定义策略要可测试、可观测，避免在选择器里做阻塞 IO。
- retry 只用于幂等请求；与 Feign/Gateway retry 避免重复叠加。
- 找不到实例查 discovery client、service id、namespace、健康状态和缓存。

## Circuit Breaker

用于熔断、限时、隔离和降级策略。

- 检查 Resilience4j、circuit breaker、time limiter、retry、bulkhead、fallback、metrics 配置。
- 熔断、重试、限时不要机械叠加；先设计超时预算和失败分类。
- fallback 返回必须业务可接受；不能掩盖数据损坏或权限错误。
- 配置按下游依赖分组，不同服务不同阈值。
- 熔断误触发查慢调用阈值、窗口大小、异常分类、超时和下游性能。
- fallback 没执行查方法签名、代理、异常类型和配置名称。

## Stream

用于抽象消息绑定和事件驱动微服务。

- 检查 binder：Kafka、RabbitMQ 或其他；读取 functional bean、bindings、destination、group、partition、retry、DLQ、converter。
- 函数签名清晰，业务处理与消息绑定配置分离。
- destination、group、partition key 是契约；变更需评估消费者影响。
- 失败处理配置 DLQ/retry；避免无限重投。
- 事件 payload 版本化；headers 只放路由/追踪等少量元数据。
- 绑定没生效查 function definition、binding name、profile、binder 配置。

## Contract

用于消费者驱动契约和 provider/consumer 兼容性验证。

- 检查 contract DSL 位置、插件配置、stub 发布方式和测试框架。
- 契约描述 provider 可承诺的行为，不写实现细节。
- 破坏性变更需要版本化或兼容期；不要直接删除字段/路径。
- Provider 生成测试必须纳入 CI；consumer 使用发布的 stub 验证。
- 生成测试失败查 DSL、base class、URL/method/header/body 匹配。

## Kubernetes

用于 Spring 应用与 Kubernetes 原生能力集成。

- 检查 service discovery、ConfigMap/Secret、namespace、RBAC、reload、probes。
- ConfigMap/Secret 命名、namespace、profile 和 reload 策略清楚。
- RBAC 最小权限；不要给应用过宽 cluster 权限。
- 使用 Kubernetes probes 配合 Boot Actuator health group。
- 配置没加载查 namespace、label、name、RBAC、profile 和 property source。
