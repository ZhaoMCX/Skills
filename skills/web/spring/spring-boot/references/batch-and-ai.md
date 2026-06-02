# Spring Boot Batch 与 AI 开发地图

## Spring Batch

用于批处理任务和高容量数据流水线。

- 检查 Batch 版本、Boot 版本、metadata schema、JobRepository 和事务管理器。
- 读取 job/step、reader/processor/writer、job parameters、scheduler、restart 策略。
- Job 参数必须能唯一标识一次运行；重跑语义要清楚。
- chunk size、事务边界、提交频率和内存占用一起设计。
- Reader/Writer 处理分页、游标、锁和断点续跑。
- Processor 保持纯业务转换；副作用放 writer 或 service 且保证幂等。
- 大任务使用 partitioning/parallel steps 时关注资源争用和顺序要求。
- Job 不启动查参数重复、JobInstance、launcher、scheduler 和 bean 注册。
- 无法 restart 查 reader state、ExecutionContext、事务提交和异常分类。
- 数据重复查幂等键、writer upsert、重试、skip 和事务回滚。

## Spring AI

用于 Spring Boot 应用里的 AI provider、RAG、tool calling 和模型调用。

- Spring AI 更新很快；实施前必须查项目当前版本的官方 reference 和 release notes。
- 确认 Spring AI 版本、Boot 版本、provider starter、模型供应商和配置来源。
- 读取 `ChatClient`、`ChatModel`、`EmbeddingModel`、`VectorStore`、advisor、prompt、tool/function 配置。
- 确认数据边界：是否会发送用户隐私、业务敏感数据、代码、日志或凭证到外部模型。
- RAG 明确 indexing、chunking、metadata、embedding model、vector store、retrieval filter 和重建流程。
- Prompt 把系统提示、用户输入、工具定义、输出 schema 分层；避免字符串拼接泄漏。
- Tool calling 需要参数校验、权限、超时、幂等和审计。
- 结构化结果用 converter/schema；不要直接信任模型文本驱动关键业务。
- 配置 timeout、retry、rate limit、fallback、metrics 和 tracing。
- 模型调用失败查 provider starter、API key、base URL、model name、超时和限流。
- RAG 命中差查分块、embedding 模型一致性、metadata filter、topK、相似度阈值和重索引。
