# Spring Integration 与消息开发地图

## Spring Integration

- Flow 中每步职责单一：filter、transform、route、handle 不混写大块业务逻辑。
- 明确 channel 类型：direct、executor、queue、publish-subscribe。
- 外部系统 adapter 要有超时、重试、错误通道、幂等和监控。
- Aggregator/splitter 要处理关联键、释放策略、超时和消息存储。
- 业务规则放 service，Integration flow 负责编排和边界。
- 消息丢失查 channel 类型、error channel、事务、ack、异常吞掉和 poller。

## AMQP / RabbitMQ

- 检查 broker、Spring AMQP、Boot 和 Rabbit client 版本。
- 明确 exchange 类型、routing key 和 queue durability；声明由代码还是平台负责。
- Listener 要处理 ack 模式、prefetch、并发、异常和幂等。
- 重试和 DLQ 成套配置，避免无限重投或消息静默丢失。
- Message converter 要版本化；跨服务消息用稳定契约。
- 消息没到查 exchange、binding、routing key、vhost、权限和 mandatory/return。

## Kafka

- 检查 Kafka broker、Spring Kafka、Boot 和 client 版本。
- Topic、partition、replication、retention 和 key 设计要服务业务语义。
- Consumer group 命名稳定；避免多个不同语义消费者误用同一 group。
- 消费处理必须幂等；offset 提交与业务事务关系要明确。
- Retry topic/DLT 配置成套，错误分类清晰。
- 消费不到查 topic、group、offset、auto offset reset、ACL 和 broker 连接。
- 顺序错查 key、partition、并发度和重试路径。

## Pulsar

- 检查 Pulsar broker、Spring Pulsar、Boot 和 client 版本。
- 选择 subscription type 时先匹配业务并发和顺序要求。
- schema 要稳定；跨服务消息使用可演进格式和版本策略。
- Ack、negative ack、redelivery、DLQ 和超时成套设计。
- Producer batching、compression 和 routing key 影响吞吐与顺序。
- 消费不到查 topic、tenant/namespace、subscription、权限、初始位置。
