# 项目待办事项

- [ ] 增加测试覆盖：针对 `HttpInspectorInterceptor`、cURL 生成、筛选/搜索 UI、请求编辑流程，以及二进制/异常响应的边界用例编写单元和小部件测试。
- [ ] 添加 CI：使用 GitHub Actions 或类似方案在 push/PR 时运行 `flutter format`, `flutter analyze`, `flutter test`。
- [ ] 清理示例构建产物：移除 `example/build/` 与 `example/.dart_tool/` 等生成文件，并更新忽略规则避免再次提交。
- [ ] 加强 Lint：考虑启用 `public_member_api_docs`，收紧未使用代码规则，并恢复 `sort_constructors_first`（若希望统一构造函数顺序）。
- [ ] 生产防护：在 `FancyDioInspectorOptions` 中默认禁止 Release 运行（如增加 `enabledInRelease`），避免无意暴露流量。
- [ ] 请求编辑体验：在 `edit_request_page` 中增加校验（超时、body 编码），并提供撤销/克隆操作以降低误操作。
- [ ] 性能优化：为 `HttpScopeView` 的日志列表加入虚拟化或渲染上限，JSON 美化可惰性执行以减少卡顿。
- [ ] 本地化改进：将 `fancy_strings` 接入 Flutter localization 或提供外部注入接口，方便宿主应用自定义翻译。
- [ ] 隐私与复制：在 cURL 导出和剪贴板辅助中提供脱敏选项，默认去除认证头或敏感字段。
- [ ] 文档完善：在 `docs/` 添加架构概览（拦截器 → provider → UI）与扩展点说明，降低上手成本。
- [ ] 发布流程：制定版本发布脚本/步骤，确保 `CHANGELOG.md` 与 `pubspec.yaml` 同步，并为新版本创建标签。
