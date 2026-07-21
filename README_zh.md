<p align="center">
  <img src="assets/readme/hero.svg" width="100%"
       alt="http_inspector —— 不离开 App 就能看到每一个 Dio 请求，实时抓取，含请求头、JSON 美化与一键 cURL 导出">
</p>

<p align="center">
  <a href="README.md">English</a> · <b>简体中文</b>
</p>

<p align="center">
  <a href="https://pub.dev/packages/http_inspector"><img alt="pub.dev" src="https://img.shields.io/pub/v/http_inspector.svg?color=30D5C8"></a>
  <a href="LICENSE"><img alt="License: MIT" src="https://img.shields.io/badge/license-MIT-30D5C8"></a>
  <a href="https://flutter.dev"><img alt="Flutter ≥3.0.5" src="https://img.shields.io/badge/flutter-%E2%89%A53.0.5-02569B?logo=flutter"></a>
  <a href="https://pub.dev/packages/dio"><img alt="Dio 5.x" src="https://img.shields.io/badge/dio-%5E5.x-E57C00"></a>
</p>

给 `Dio` 挂上一个拦截器，之后每一个请求、响应和错误都会被实时抓取。在 App 内部打开内置面板，就能看到完整往返——状态码、耗时、请求头、美化后的 JSON——还能把任意一次调用复制成可直接运行的 cURL 命令。

不用代理，不用桌面工具，也不用离开 App。

<img src="assets/readme/proof.png" width="100%"
     alt="抓包面板的两个界面：请求列表，每行用左侧状态色条显示方法、状态码、时间与耗时；以及请求详情，含 Overview、Response Body、cURL 和请求头等分区。">

## 安装

```yaml
dependencies:
  http_inspector: ^1.0.3
```

## 两步跑起来

**第 1 步 · 挂上拦截器** —— 抓包由它完成：

```dart
import 'package:dio/dio.dart';
import 'package:http_inspector/http_inspector.dart';

final dio = Dio();

dio.interceptors.add(
  HttpInspectorInterceptor(
    options: const HttpInspectorOptions(
      maxLogs: 200,
      consoleOptions: HttpInspectorConsoleOptions(verbose: true),
    ),
  ),
);
```

**第 2 步 · 打开面板** —— 从任意位置 push `HttpScopeView`，用 `kDebugMode` 兜住，保证不会带进发布包：

```dart
import 'package:flutter/foundation.dart';

if (kDebugMode) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => const HttpScopeView()),
  );
}
```

集成到此为止。列表、搜索、详情页、cURL 复制都是内置的。

## 定制面板

`HttpScopeView` 接收一个 `HttpScopeViewConfig`，绝大多数实际定制都在这里发生：

```dart
HttpScopeView(
  leading: CloseButton(onPressed: Navigator.of(context).pop),
  viewConfig: HttpScopeViewConfig(
    // 把匹配的请求钉在顶部；清理时也不会被清掉。
    alwaysStar: (record) => record.url.contains('/login'),

    // 只看你关心的请求。
    recordFilter: (record) => record.host == 'api.example.com',

    // 在详情页加一个分享按钮 → 把记录发到任意地方。
    onShareAction: (record) async {
      await myWebhook.post(record.toHttpRequestLog());
    },

    // 让帮助按钮指向你自己的文档。
    manualUrl: 'https://example.com/debugging',
  ),
)
```

| 字段 | 类型 | 作用 |
| --- | --- | --- |
| `recordFilter` | `bool Function(HttpRecord)` | 哪些记录显示出来，默认全部。 |
| `alwaysStar` | `bool Function(HttpRecord)` | 始终置顶、不可被清理的记录。 |
| `itemBuilder` | `Widget Function(BuildContext, HttpRecord)` | 列表行的自定义 widget。 |
| `customFilters` | `List<SingleFilter>` | 叠加在 `recordFilter` 之上的额外条件。 |
| `onShareAction` | `Future<void> Function(HttpRecord)?` | 设置后显示分享按钮，为 `null` 时隐藏。 |
| `manualUrl` | `String?` | 帮助按钮打开的 URL，为 `null` 时隐藏。 |

### 拦截器回调

`HttpInspectorInterceptor` 还会把每个事件转发出来，方便你自己记录或上报：

```dart
HttpInspectorInterceptor(
  onRequestCreated: (requestOptions) { /* ... */ },
  onResponseCreated: (response)      { /* ... */ },
  onErrorCreated: (dioError)         { /* ... */ },
)
```

### 控制台输出

`HttpInspectorConsoleOptions` 控制与 UI 并行的终端日志——用 `verbose` 开关，用 `colorize` 及各类颜色（`requestColor`、`responseColor`、`errorColor`）让日志一眼可辨。

## 公开 API

| 符号 | 类别 | 用途 |
| --- | --- | --- |
| `HttpInspectorInterceptor` | Dio `Interceptor` | 挂到 `Dio` 上抓取流量 |
| `HttpInspectorOptions` | 配置 | `maxLogs`、各类日志开关、控制台选项 |
| `HttpInspectorConsoleOptions` | 配置 | 终端日志：详细程度与颜色 |
| `HttpScopeView` | Widget | 抓包面板界面 |
| `HttpScopeViewConfig` | 配置 | 筛选、置顶、自定义行、分享、帮助 URL |
| `HttpRecord` | 模型 | 一次完整往返——请求、响应/错误、耗时、`cURL` |

## 运行示例

```bash
cd example
flutter pub get
flutter run
```

示例会发出几个真实的 Dio 请求（其中部分故意失败），你可以看着它们落进列表。

## 隐私与生产环境

面板会暴露完整的请求与响应 Body，务必把它挡在发布包之外：

- 每个入口都用 `kDebugMode` 兜住，如上所示。
- 不要指望它去脱敏 token 或 PII——它展示的就是 Dio 实际发送的内容。
- 记录只存在内存中，上限由 `maxLogs` 控制（默认 `50`）。

## 兼容性

| 依赖 | 版本 |
| --- | --- |
| Dart | `>=2.17.6 <4.0.0` |
| Flutter | `>=3.0.5` |
| Dio | `^5.x` |

## 贡献

```bash
dart format .
flutter analyze
flutter test
```

然后带上清晰的说明开 PR。欢迎提 Issue 与功能建议。

## 协议

MIT —— 见 [LICENSE](LICENSE)。完整发布记录见 [CHANGELOG.md](CHANGELOG.md)。
