# 官方来源

先读目标项目本地代码，再查若依官方仓库和文档。若依前后端分离项目常被二开，token header、接口前缀、菜单路由、权限字符串、生成器模板和 Redis 登录态都可能与官方模板不同。

## 官方仓库

- RuoYi-Vue：https://github.com/yangzongzhuan/RuoYi-Vue
- RuoYi-Vue-fast / Oracle 变体：从官方账号与 README 链接确认当前维护位置。
- 相关 Vue3 前端：https://github.com/yangzongzhuan/RuoYi-Vue3

## 来源优先级

1. 目标项目本地 `pom.xml`、`ruoyi-ui/package.json`、`application*.yml`、`SecurityConfig`、`TokenService`、`src/utils/request.js`、路由、store 和生成器模板。
2. 对应官方仓库的目标分支、README、提交历史和模板源码。
3. Spring Security、Vue2、Element UI、Vue CLI、Redis、MyBatis 等官方文档。
4. 社区文章、博客和旧快照只能作为经验线索。
