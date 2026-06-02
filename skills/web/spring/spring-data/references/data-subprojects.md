# Spring Data 子项目开发地图

## JPA

用于 JPA/Hibernate repository 开发。

- 检查 Spring Data JPA、Hibernate、数据库、driver、migration 工具版本。
- 读取 entity、repository、query、transaction、fetch plan、schema/index。
- Entity 只表达持久化模型；API DTO 不直接暴露 entity。
- 简单查询用派生方法；复杂查询用 `@Query`、Specification、Querydsl 或自定义 repository。
- 分页必须稳定排序；避免深分页性能陷阱。
- 控制 fetch plan，主动处理 N+1；不要依赖 OSIV 掩盖问题。
- LazyInitializationException 查事务边界、fetch plan、DTO projection。
- N+1 查 SQL、entity graph、join fetch、batch size。

## JDBC

用于轻量关系型聚合持久化，不等同 JPA。

- 检查 Spring Data JDBC、数据库、driver、migration 工具版本。
- 按聚合建模；不要期待 JPA 的 lazy loading、dirty checking、级联语义。
- Schema 与对象映射保持简单，复杂查询可回到 `JdbcTemplate`。
- 一次保存聚合可能重写子集合，注意并发和数据量。
- 事务放 service 层；乐观锁用版本字段。
- 映射失败查表/列命名、构造器、ID、`@MappedCollection`。

## R2DBC

用于响应式关系型数据访问。

- 检查 R2DBC driver、Spring Data R2DBC、Boot、数据库版本。
- 不在 reactive chain 里阻塞；阻塞边界必须隔离 scheduler。
- 事务使用 reactive transaction manager/operator。
- 背压、连接池、超时和并发一起配置。
- Repository 适合简单 CRUD；复杂 SQL 用 `DatabaseClient` 或 template。
- SQL 不执行查是否订阅、chain 是否返回、测试是否 StepVerifier。

## Redis

用于 Redis 数据访问、缓存、stream 和基础设施能力。

- 检查 Redis 拓扑：standalone、sentinel、cluster、managed service。
- 读取 connection factory、template、serializer、cache manager、TTL、key prefix。
- Key 命名、TTL、序列化和 namespace 必须统一。
- cache 与持久化数据分离；缓存值可丢失、可重建。
- 分布式锁需要超时、唯一 token、释放校验和业务补偿。
- Redis Stream 消费组处理 ack、pending、重试和幂等。
- 读不到查 key prefix、serializer、database index、TTL、环境。

## MongoDB

用于 MongoDB 文档存储。

- 检查 MongoDB server、driver、Spring Data MongoDB、reactive/imperative 栈。
- 文档结构围绕查询和聚合设计，不照搬关系模型。
- 索引与查询一起设计；大集合禁止无索引扫描。
- Aggregation pipeline 保持可读、可测；复杂 pipeline 加样例数据测试。
- 事务只在 replica set/sharded cluster 支持条件下使用，成本需评估。
- 查询慢查 explain、索引、正则、排序、分页和投影。

## Elasticsearch

用于 Elasticsearch 搜索和索引。

- 检查 Elasticsearch/OpenSearch 版本、Spring Data Elasticsearch、client 兼容性。
- Mapping/analyzer 是契约，变更通常需要新索引和 reindex。
- 深分页避免 from/size，使用 search_after 或业务游标。
- 搜索 DTO 与业务 entity 分离。
- 写入一致性、刷新策略和最终一致性要向调用方说明。
- 查不到时检查 analyzer、keyword/text、refresh、index name、routing。

## Data REST

用于 repository 自动暴露 REST API。公网业务 API 要谨慎使用。

- 确认哪些 repository 被导出，base path、HAL、pagination、projections。
- 默认不要把内部 repository 直接暴露给公网客户端。
- 明确导出/隐藏 repository、方法和字段；权限必须覆盖读写端点。
- Projection/excerpt 用于视图，不替代业务 DTO 设计。
- Repository events 只处理边界逻辑，复杂业务放 service。
