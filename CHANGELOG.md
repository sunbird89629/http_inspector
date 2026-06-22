## 0.0.1

首个发布版本。一个面向 Dio 的轻量级应用内 HTTP 抓包工具。

### 功能
- 通过 `HttpInspectorInterceptor` 实时抓取并记录 Dio 请求。
- 应用内 UI（`HttpScopeView` / 详情页）查看请求列表与详情，支持搜索与筛选。
- cURL 命令导出，便于复现请求。
- 请求 / 响应 Body 的 JSON 美化展示。
- 收藏 / 置顶请求记录，支持 `alwaysStar` 配置；清理时保留收藏项。
- 应用内重放（replay）请求，并显示加载状态。
- 详情页一键复制、可配置的 `onShareAction` 分享入口。
- 彩色控制台日志（`HttpConsoleColors`）。
- 公共 API 统一在 `HttpInspector*` 命名空间下。
