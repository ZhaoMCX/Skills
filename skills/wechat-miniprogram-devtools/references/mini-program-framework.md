# 微信小程序框架速查

用于编写、审查或调试原生微信小程序代码。优先核对本地项目结构和官方文档；不同基础库、渲染引擎、DevTools 版本的能力可能不同。

## 先看项目类型

- 原生小程序：根目录通常有 `app.js`、`app.json`、`app.wxss`、`project.config.json`，页面由同路径同名的 `.js`、`.wxml`、`.json`、`.wxss` 组成。
- uni-app / Taro 等编译产物：先改源项目；仅在验证生成结果时阅读 `dist/dev/mp-weixin` 或 `dist/build/mp-weixin`。
- 自定义组件：目录通常包含 `index.js`、`index.wxml`、`index.json`、`index.wxss`，组件 JSON 里需要 `"component": true`。

## 结构与配置

- `app.js` 注册全局 `App` 逻辑，适合放启动、全局状态入口和全局生命周期。
- `app.json` 是全局配置，常见字段包括 `pages`、`window`、`tabBar`、`networkTimeout`、`debug`、`usingComponents`、`permission`、`subpackages`。
- `pages` 的第一项通常是默认首页；新增页面时同步创建页面文件并写入 `app.json` 或分包配置。
- 页面同名 `.json` 覆盖 `app.json.window` 中相同的窗口表现配置，也可配置页面级 `usingComponents`。
- `project.config.json` / `project.private.config.json` 属于工具项目配置；除非任务明确要求，不要把个人本地设置写入共享配置。

## 页面与组件逻辑

- 简单页面用 `Page({ data, onLoad, onShow, onReady, onHide, onUnload, ...methods })`。
- 页面数据变更用 `this.setData({ key: value })` 驱动渲染；避免把大型对象、频繁滚动状态或纯临时变量反复写入 `data`。
- 常用页面生命周期：`onLoad(options)` 接收路由参数，`onShow` 前台显示，`onReady` 首次渲染后，`onHide` 后台，`onUnload` 销毁。
- 页面事件函数写在 `Page` 顶层；如果用 `Component` 构造页面，方法需要放入 `methods`。
- 自定义组件用 `Component({ properties, data, methods, lifetimes, pageLifetimes, observers })`；对外输入用 `properties`，对外事件用 `this.triggerEvent`。
- 跨页面共享逻辑优先使用本项目已有 store/service/helper；轻量复用可用 `Behavior`，但注意命名冲突和生命周期合并。

## WXML 语法

- 数据绑定使用 `{{ }}`，例如 `{{message}}`、`checked="{{isChecked}}"`；表达式能力有限，不要把复杂业务逻辑塞进模板。
- 列表渲染用 `wx:for="{{list}}"`，默认项名为 `item`、索引为 `index`；稳定列表必须补 `wx:key`。
- 条件渲染用 `wx:if`、`wx:elif`、`wx:else`；频繁切换且结构稳定时可考虑 `hidden`，但 `hidden` 不会销毁节点。
- 需要包裹多个节点但不产生真实节点时用 `<block>`。
- 模板复用可用 `<template>`、`import`、`include`，但组件化交互应优先用自定义组件。
- 事件绑定可用 `bindtap` / `bind:tap`，阻止冒泡用 `catchtap` / `catch:tap`，捕获阶段用 `capture-bind` / `capture-catch`。
- 事件对象常看 `event.currentTarget.dataset`、`event.target`、`event.detail`、`event.mark`；`data-foo-bar` 会变成 `dataset.fooBar`，大写会转小写。

## WXSS 规则

- `app.wxss` 是全局样式；页面 `.wxss` 是局部样式，会覆盖相同选择器。
- `rpx` 按屏幕宽度自适应，官方基准是屏幕宽 `750rpx`；移动端布局优先使用 `rpx`、百分比和 flex。
- `@import "relative/path.wxss";` 可导入样式。
- WXML 的 `class` 写类名，不带 `.`；静态样式放 class，运行时动态样式才放 `style`。
- 选择器能力有限，常用 `.class`、`#id`、组件选择器、并集选择器、`::before`、`::after`；不要照搬复杂 Web CSS 选择器。

## 内置组件选择

- 基础布局：`view`、`scroll-view`、`swiper`/`swiper-item`、`movable-area`/`movable-view`、`page-container`、`root-portal`。
- 文本与内容：`text`、`rich-text`、`icon`、`progress`、`image`。
- 表单：`form`、`input`、`textarea`、`button`、`picker`、`picker-view`、`checkbox-group`、`radio-group`、`switch`、`slider`、`label`。
- 导航：普通页面跳转用 `navigator` 或 `wx.navigateTo`；tab 页使用 `wx.switchTab`；返回用 `wx.navigateBack`。
- 媒体与原生能力：`video`、`camera`、`live-player`、`live-pusher`、`map`、`canvas`；这些常涉及授权、原生组件层级或同层渲染差异。
- 开放能力：`web-view`、`open-data`、`official-account`、广告/微信小店相关组件通常需要 AppID、后台配置、域名或权限条件。
- Skyline 组件或 `scroll-view type="custom"`、`list-view`、`grid-view` 等能力要先确认项目启用的渲染引擎和最低基础库。

## API 与路由习惯

- 网络请求用 `wx.request` 或项目封装；先检查合法域名、环境配置、token 注入和错误处理。
- 用户反馈用 `wx.showToast`、`wx.showModal`、`wx.showLoading`/`wx.hideLoading`，避免让页面状态和弹层状态脱节。
- 本地缓存用 `wx.setStorage` / `wx.getStorage` 或同步版本；敏感信息不要长期明文存储。
- 登录、用户信息、手机号、位置、摄像头、相册等能力涉及授权、隐私协议和后台配置；不要假设模拟器可代表真机授权表现。
- 分包、插件、`web-view`、支付、直播、广告等平台能力需要查官方文档和项目后台配置后再实现。

## 自动化验证注意

- `miniprogram-automator` 操作模拟器前，必须确认 DevTools 主窗口在桌面可见，不能最小化到后台；最小化/后台状态会导致自动化无法执行并超时。
- 先断言路由、页面数据、选择器和 AppService 日志，再做截图或视觉 QA。
- 截图超时且数据断言通过时，优先怀疑 DevTools 窗口状态、渲染窗口或会话串错。
- 新增页面、组件或配置后，重新编译/重开目标项目，确认 `app.json`、分包路径、`usingComponents` 和生成产物已更新。

## 官方文档入口

- 目录结构：https://developers.weixin.qq.com/miniprogram/dev/framework/structure.html
- 小程序配置：https://developers.weixin.qq.com/miniprogram/dev/framework/config.html
- 注册页面：https://developers.weixin.qq.com/miniprogram/dev/framework/app-service/page.html
- WXML：https://developers.weixin.qq.com/miniprogram/dev/framework/view/wxml/
- 事件系统：https://developers.weixin.qq.com/miniprogram/dev/framework/view/wxml/event.html
- WXSS：https://developers.weixin.qq.com/miniprogram/dev/framework/view/wxss.html
- 组件总览：https://developers.weixin.qq.com/miniprogram/dev/component/
