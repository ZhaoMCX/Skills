# 官方来源

先读目标 RuoYi-App 项目本地代码，再查若依 App 与 DCloud 官方文档。RuoYi-App 的后端契约取决于接入的是 RuoYi-Vue 还是 RuoYi-Cloud，移动端平台差异以目标 `manifest.json`、`pages.json` 和条件编译为准。

## 官方仓库

- RuoYi-App：https://github.com/yangzongzhuan/RuoYi-App
- RuoYi-Vue：https://github.com/yangzongzhuan/RuoYi-Vue
- RuoYi-Cloud：https://github.com/yangzongzhuan/RuoYi-Cloud
- DCloud uni-app 文档：https://uniapp.dcloud.net.cn/

## 来源优先级

1. 目标项目本地 `config.js`、`utils/request.js`、`permission.js`, `store/modules/user.js`、`pages.json`、`manifest.json`、接口封装和后端项目契约。
2. 对应若依官方仓库的目标分支、README、提交历史和模板源码。
3. DCloud、微信/支付宝小程序、Android/iOS 平台官方文档。
4. 社区文章、博客和旧快照只能作为经验线索。
