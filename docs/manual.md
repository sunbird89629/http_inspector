# HTTP Inspector 使用手册

本手册介绍如何在应用内查看并分析通过 Dio 发起的 HTTP 请求与响应。

## 安装与集成

1. 将本库添加为依赖（通常已在你的工程中依赖本 package）。
2. 在创建 Dio 实例后，添加 `FancyDioInterceptor`：

```dart
final dio = Dio();
dio.interceptors.add(FancyDioInterceptor());
```

## 在应用内查看网络日志

- 使用 `HttpScopeView` 或 `FancyDioInspectorView` 作为一个页面显示：

```dart
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (_) => const HttpScopeView(), // 或 FancyDioInspectorView()
  ),
);
```

### 标题栏操作

- 帮助按钮：点击打开本手册页面（可在 `HttpScopeViewConfig.manualUrl` 自定义手册地址）。
- 清空按钮：长按可清空已记录的网络请求。

## 过滤记录

通过 `HttpScopeViewConfig.recordFilter` 传入过滤函数，仅展示满足条件的记录：

```dart
HttpScopeView(
  viewConfig: HttpScopeViewConfig(
    recordFilter: (record) => record.requestOptions.path.startsWith('/api/'),
  ),
)
```

## 在项目中定制帮助链接

你可以将手册部署到任意可访问的 URL，然后通过 `HttpScopeViewConfig.manualUrl` 指定：

```dart
const HttpScopeView(
  viewConfig: HttpScopeViewConfig(
    manualUrl: 'https://sunbird89629.github.io/http_inspector/manual',
  ),
)
```

## 使用 GitHub Pages 渲染本手册

1. 推送本文件至仓库（文件路径为 `docs/manual.md`）。
2. 在 GitHub 仓库的 Settings → Pages 中启用 Pages：
   - 如果使用 “Deploy from a branch”，建议选择分支 `main`，文件夹 `docs` 或 `root`（若选择 `docs`，请将本文件放至 `docs/manual.md`）。
   - 或选择 “GitHub Actions” 以使用 Actions 部署静态站点（Jekyll/静态渲染均可）。
3. 启用完成后，页面地址通常为：
   - `https://sunbird89629.github.io/http_inspector/manual`（Jekyll 会将 `.md` 转为 HTML）。
4. 将该地址配置到 `HttpScopeViewConfig.manualUrl`，应用内标题栏帮助按钮即可打开。

> 备注：若暂未启用 GitHub Pages，默认会打开仓库内的 `docs/manual.md` 文件地址：
> `https://github.com/sunbird89629/http_inspector/blob/main/docs/manual.md`