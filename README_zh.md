# Http Inspector

[![pub.dev](https://img.shields.io/pub/v/http_inspector.svg)](https://pub.dev/packages/http_inspector)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.0.5-02569B?logo=flutter)](https://flutter.dev)
[![Dio](https://img.shields.io/badge/Dio-%5E5.x-orange)](https://pub.dev/packages/dio)

**语言**：[English](README.md) · **简体中文**

轻量级 Flutter 应用内 HTTP 抓包工具，专为 Dio 打造。实时捕获请求、响应与错误，内置可视化 UI、JSON 美化、cURL 一键导出、搜索过滤 —— 让调试网络请求这件事不用再离开 App。

<img src="assets/screenshots/screenshot_1.png" height="400" />
<img src="assets/screenshots/screenshot_2.png" height="400" />

---

## 为什么用它

在 Flutter 项目里调试网络请求，你可能遇到过：

- 用 Charles / Proxyman 抓包，但真机上配代理太麻烦，HTTPS 还要装证书
- 打 `print(response.data)`，日志被淹没在其他输出里
- 想复现 Bug，得手动复制 URL、Header、Body 拼 cURL

`http_inspector` 直接在 App 内部打开一个「网络面板」，能看到所有请求详情、复制 cURL 交给后端复现、也能在离线设备上快速定位问题。**装在 Dio 上一行代码就跑起来。**

---

## 功能特性

- 🔴 **实时日志** —— 请求、响应、错误全捕获，带时间戳和耗时
- 📱 **应用内查看** —— `HttpScopeView` 直接嵌入 App，无需切走
- 📋 **cURL 导出** —— 任意请求一键复制成可运行的 cURL 命令
- 🎨 **JSON 美化** —— 请求/响应体和 Header 格式化展示
- 🔍 **搜索过滤** —— 按 URL、域名、关键字定位请求
- 🌈 **彩色控制台** —— 可配置的彩色日志，扫一眼就知道成败
- 🔒 **生产环境安全** —— 用 `kDebugMode` 守护，避免泄漏敏感数据

---

## 安装

在 `pubspec.yaml` 中添加：

```yaml
dependencies:
  http_inspector: ^1.0.2
```

然后执行：

```bash
flutter pub get
```

---

## 快速上手

### 第 1 步 —— 给 Dio 挂上拦截器

```dart
import 'package:dio/dio.dart';
import 'package:http_inspector/http_inspector.dart';

final dio = Dio();

dio.interceptors.add(
  HttpInspectorInterceptor(
    options: const FancyDioInspectorOptions(
      consoleOptions: FancyDioInspectorConsoleOptions(verbose: true),
    ),
  ),
);
```

### 第 2 步 —— 把面板挂到 App 上

```dart
import 'package:flutter/foundation.dart';

MaterialApp(
  home: Scaffold(
    // 方式 A：从右侧抽屉呼出（仅 debug 构建）
    endDrawer: kDebugMode ? const FancyDioInspectorView() : null,

    // 方式 B：手动跳转
    body: ElevatedButton(
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const HttpScopeView()),
      ),
      child: const Text('打开抓包面板'),
    ),
  ),
);
```

搞定 —— 现在跑一次网络请求，就能在面板里看到详情。

---

## 进阶用法

### 拦截器完整配置

```dart
HttpInspectorInterceptor(
  options: const FancyDioInspectorOptions(
    maxLogs: 200,                    // 最多保留多少条日志
    consoleOptions: FancyDioInspectorConsoleOptions(
      verbose: true,                 // 打印详细日志到控制台
      colorize: true,                // 彩色输出
    ),
  ),
  onRequestCreated: (requestOptions) {
    // 请求发出前的钩子（打点、埋点、修改参数等）
  },
  onResponseCreated: (response) {
    // 响应回来后的钩子
  },
  onErrorCreated: (dioError) {
    // 错误发生时的钩子（上报到 Sentry / Firebase 等）
  },
)
```

### 代码里直接拿 cURL

```dart
final curl = requestOptions.cURL;
// 现在可以打日志、发给后端、写到剪贴板等等
```

---

## 示例项目

仓库自带 `example/`，直接跑：

```bash
cd example
flutter pub get
flutter run
```

---

## API 速查

| 名称 | 类型 | 说明 |
|------|------|------|
| `HttpInspectorInterceptor` | Interceptor | 挂到 Dio 上捕获流量 |
| `FancyDioInspectorOptions` | Options | 配置日志上限、控制台输出等 |
| `FancyDioInspectorView` | Widget | 全屏抓包面板 |
| `HttpScopeView` | Widget | 轻量版抓包面板 |
| `NetworkRequestModel` | Model | 请求数据模型 |
| `NetworkResponseModel` | Model | 响应数据模型 |
| `NetworkErrorModel` | Model | 错误数据模型 |

---

## 隐私与生产环境

- **只在 debug 构建里启用面板** —— 用 `kDebugMode` 或自己的 flag 守护
- **不要记录敏感数据** —— token、密码、身份证号等要在拦截器里脱敏
- 日志存在内存中，`maxLogs` 控制上限，不会写盘

---

## 兼容性

| 依赖 | 版本 |
|------|------|
| Dart | >= 2.17.6, < 4.0.0 |
| Flutter | >= 3.0.5 |
| Dio | ^5.x |

---

## 贡献

1. Fork 仓库，创建 feature 分支
2. 遵循现有代码风格进行修改
3. 提交前跑一遍检查：

```bash
flutter format .
flutter analyze
flutter test
```

4. 提 PR，描述清楚改动动机与影响

详见 [CONTRIBUTING.md](CONTRIBUTING.md)。

---

## 协议

MIT —— 见 [LICENSE](LICENSE)。

## 更新日志

见 [CHANGELOG.md](CHANGELOG.md)。
