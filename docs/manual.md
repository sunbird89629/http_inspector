# http_inspector (Fancy Dio Inspector) 使用手册

本手册旨在帮助开发者在 Flutter 应用中集成并高效使用 `http_inspector`，以实现对 `Dio` 网络请求的实时监控、审查和调试。

## 核心特性

- **实时日志**：自动捕获所有 HTTP(S) 请求、响应和异常，并记录时间戳与耗时。
- **应用内查看器**：提供 `HttpScopeView` 和 `FancyDioInspectorView` 两个 UI 组件，无需离开应用即可审查网络详情。
- **一键复制 cURL**：在详情页轻松复制任何请求的 cURL 命令，便于在终端或 Postman 等工具中复现。
- **格式化 JSON**：自动美化并高亮显示 JSON 格式的请求头、请求体和响应体。
- **搜索与过滤**：内置搜索功能，可快速根据 URL、方法等关键词定位目标请求。同时支持通过代码进行编程化过滤。
- **生产环境禁用**：可结合 `kDebugMode` 轻松在 Release 版本中禁用所有功能，避免泄露敏感信息。
- **高度可配置**：提供丰富的选项，可自定义日志保留数量、控制台打印行为、UI 文案及帮助链接等。

## 快速上手

集成 `http_inspector` 只需简单三步。

### 1. 添加依赖

在你的 `pubspec.yaml` 文件中添加依赖：

```yaml
dependencies:
  http_inspector: ^1.0.2 # 请使用最新版本
```

然后运行 `flutter pub get`。

### 2. 添加拦截器

在创建 `Dio` 实例后，将 `FancyDioInterceptor` 添加到拦截器列表中。

```dart
import 'package:dio/dio.dart';
import 'package:http_inspector/http_inspector.dart';

final dio = Dio();

// 添加拦截器
dio.interceptors.add(FancyDioInterceptor());
```

### 3. 添加 UI 组件

你可以将 `HttpScopeView` 或 `FancyDioInspectorView` 作为一个独立的页面或嵌入到现有组件（如 `Drawer`）中。

**示例：作为新页面打开**
```dart
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (_) => const HttpScopeView(), 
  ),
);
```

**示例：作为抽屉（Drawer）使用**
```dart
Scaffold(
  endDrawer: kDebugMode ? const FancyDioInspectorView() : null,
  // ...
)
```

## 功能详解

### UI 界面操作

- **列表页**：展示所有已捕获的网络请求摘要，包括请求方法、URL、状态码和时间。顶部的搜索框可以帮助你快速筛选。
- **详情页**：点击任意记录可进入详情页，包含请求和响应的完整信息（Headers, Body），并可在右上角一键复制 cURL 命令。
- **顶部操作栏**：
  - **搜索按钮**：切换搜索框的显示与隐藏。
  - **清空按钮**：长按此按钮可清空当前所有已记录的网络请求。
  - **帮助按钮**：点击打开在线的使用手册（URL 可自定义）。

## 高级配置

### 拦截器选项 (`FancyDioInterceptorOptions`)

在添加拦截器时，你可以传入 `options` 参数进行详细配置。

```dart
dio.interceptors.add(
  FancyDioInterceptor(
    options: const FancyDioInspectorOptions(
      maxLogs: 100, // 内存中最多保留 100 条日志
      consoleOptions: FancyDioInspectorConsoleOptions(
        verbose: true, // 在控制台打印更详细的日志
        colorize: true, // 开启彩色日志
      ),
    ),
  ),
);
```

### UI 视图选项 (`HttpScopeViewConfig`)

在使用 `HttpScopeView` 时，可以通过 `viewConfig` 进行自定义。

**1. 编程化过滤记录**

通过 `recordFilter` 传入一个过滤函数，可以精确控制列表中显示哪些记录。

```dart
HttpScopeView(
  viewConfig: HttpScopeViewConfig(
    // 仅显示路径以 /api/ 开头的请求
    recordFilter: (record) => record.requestOptions.path.startsWith('/api/'),
  ),
)
```

**2. 自定义帮助链接**

你可以将本手册部署到自己的服务器或 GitHub Pages，然后通过 `manualUrl` 指定链接地址。

```dart
const HttpScopeView(
  viewConfig: HttpScopeViewConfig(
    manualUrl: 'https://your-url/to/manual.html',
  ),
)
```

## 隐私与安全

- **切勿在生产环境中使用**：务必使用 `kDebugMode` 变量来确保 `http_inspector` 的所有功能仅在调试时启用。
- **保护敏感数据**：避免在日志中记录如 Token、密码或个人身份信息（PII）。如有必要，请在应用层进行脱敏处理。

## 附：使用 GitHub Pages 部署在线手册

1. 推送本文件至仓库（建议路径为 `docs/manual.md`）。
2. 在 GitHub 仓库的 `Settings` → `Pages` 中启用 GitHub Pages。
   - **Source**: 选择 "Deploy from a branch"。
   - **Branch**: 选择你的主分支（如 `main`），文件夹选择 `docs`。
3. 保存后，GitHub 会提供一个公共访问地址。将此地址配置到 `HttpScopeViewConfig.manualUrl` 即可。
