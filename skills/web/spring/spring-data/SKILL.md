---
name: spring-data
description: Guides Spring Data development, review, debugging, and upgrades across repositories, JPA, JDBC, R2DBC, Redis, MongoDB, Elasticsearch, Neo4j, query derivation, pagination, auditing, transactions, projections, and entity mapping. Use when working with Spring Data, Repository, JpaRepository, CrudRepository, derived queries, @Query, @Entity, MongoTemplate, RedisTemplate, R2DBC, or data access repositories.
---

# Spring Data

用于 Spring Data 与 repository 抽象。遇到具体数据库驱动或 ORM 时同时查对应官方文档。

## 首轮检查

1. 确认模块：JPA、JDBC、R2DBC、Redis、MongoDB、Elasticsearch、Neo4j、Cassandra 等。
2. 确认版本来源：Boot BOM、Spring Data release train、显式依赖和数据库驱动版本。
3. 读取 entity/document、repository、query、transaction、schema migration、test fixture。
4. 查官方入口：`https://spring.io/projects/spring-data/`。

## 开发规则

- Repository 方法名只用于简单查询；复杂查询使用 `@Query`、Specification、Querydsl 或模板 API。
- 分页查询要有稳定排序；大结果集使用 streaming、slice、cursor 或批处理。
- JPA 事务边界放在 service 层；避免 Open Session in View 掩盖 N+1。
- Redis 区分 cache、session、lock、counter、domain data；设置 TTL 和序列化策略。
- R2DBC 是响应式数据访问；不要把阻塞 JPA/JDBC 混入响应式链路。
- Mongo/Elasticsearch 注意索引、mapping、分页深度和一致性预期。

## 引用地图

| 任务 | 阅读 |
| --- | --- |
| JPA、JDBC、R2DBC、Redis、MongoDB、Elasticsearch、Data REST | `references/data-subprojects.md` |

## 调试清单

- 查询派生失败：查方法名解析、属性路径、返回类型和关键字支持。
- N+1 或性能差：查 fetch plan、join fetch、entity graph、batch size、索引和分页。
- 事务不回滚：查事务管理器、传播行为、异常类型和 repository 调用位置。
- Redis 读写异常：查 key 设计、TTL、序列化、连接池和 pipeline/transaction。
- R2DBC 不执行：查是否订阅、事务 operator、连接工厂和阻塞调用。

## 验证

```powershell
mvn test
mvn -Dtest=*Repository* test
.\gradlew test
```

高风险数据变更使用 Testcontainers 或本地同版本数据库验证，汇报 schema、索引和事务风险。
