# Spring Framework 核心与 Web 开发地图

## Core / IoC

- Bean 设计优先 constructor injection；避免不必要的 static 全局状态和 field injection。
- 配置类保持职责单一，基础设施 bean 与业务 service 分开。
- Bean 没注入查扫描包、profile、条件配置、同名 bean、泛型类型、代理类型。
- AOP 切点表达式要窄；避免把事务、权限、日志、缓存横切逻辑混在一个 aspect。

## Transactions

- 事务边界放在 service 层；注意自调用、传播行为、只读事务、异常回滚规则。
- 事务不生效查是否经过代理、方法可见性、异常类型、传播行为、数据源/事务管理器。
- 多数据源必须明确 transaction manager，避免默认选择错误。

## MVC / WebFlux

- 区分 MVC、WebFlux、RestClient、WebClient；不要在响应式链路里直接阻塞。
- MVC 映射异常查路径、HTTP method、content negotiation、参数绑定、message converter。
- WebFlux 卡住查阻塞调用、scheduler、backpressure、订阅位置和异常处理。
- WebClient 调用设置 timeout、错误映射、重试边界和观测。

## GraphQL / HATEOAS / Web Services

- GraphQL schema 是公开契约；字段命名、nullability、分页和错误模型要稳定。
- GraphQL 避免 N+1，跨集合查询优先 DataLoader/batching。
- HATEOAS 使用 assembler 集中构造链接，避免 controller 到处拼 URL。
- SOAP/WSDL/XSD 场景查 Spring Web Services；WSDL/XSD 是契约源。

## Testing

- 测试上下文失败查 `@ContextConfiguration`、`@SpringBootTest`、slice、mock bean 和 profile。
- MVC 用 MockMvc，WebFlux 用 WebTestClient；只在需要完整上下文时启动全应用。
