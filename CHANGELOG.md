## 2.0.0

**Breaking changes** — public API unified under the `HttpInspector*` namespace.

### Renamed classes

| Old name | New name |
|---|---|
| `HttpDioInspectorOptions` | `HttpInspectorOptions` |
| `HttpDioInspectorConsoleOptions` | `HttpInspectorConsoleOptions` |
| `FancyDioInspectorL10nOptions` | `HttpInspectorL10nOptions` |
| `FancyDioInspectorTileOptions` | `HttpInspectorTileOptions` |
| `FancyConsoleTextColors` | `HttpConsoleColors` |

### Other changes
- `FancyElevatedButton` removed from public exports (internal widget).
- Library declaration changed from `fancy_dio_inspector_personal` to `http_inspector`.
- Added `repository`, `homepage`, and `issue_tracker` to `pubspec.yaml`.

### Migration guide

Replace old class names with the new ones (e.g. find-and-replace in your IDE).
The constructor signatures and behaviour are unchanged.

---

## 1.0.2

- Add starred / favourite feature for request records.
- Add always-star config via `HttpScopeViewConfig.alwaysStar`.
- Show loading state during in-app request replay.
- Add long-delay mock endpoint in example app.

## 1.0.1

- First independent release under new maintenance.
- Renamed interceptor to `HttpInspectorInterceptor`.
- Renamed primary view to `HttpScopeView`.
