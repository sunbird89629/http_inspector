# Repository Guidelines

## Project Structure & Module Organization
- `lib/http_inspector.dart` is the public entrypoint exporting the package API.
- `lib/src/interceptors/` houses `HttpInspectorInterceptor` and config; `lib/src/models/` defines network records and options; `lib/src/loggers/` handles console output; `lib/src/ui/` contains views and widgets; `lib/src/utils/` offers extensions/helpers; `lib/src/theme/` and `lib/src/l10n/` centralize styling and strings.
- Assets (screenshots) live in `assets/`. The example Flutter app is under `example/` with platform scaffolding and `example/lib/main.dart`.
- Tests are currently minimal; add new coverage under `test/` mirroring the source structure.

## Build, Test, and Development Commands
- `flutter pub get` — install dependencies.
- `flutter format .` — apply standard Dart formatting.
- `flutter analyze` — run static analysis using Very Good Analysis rules.
- `flutter test` — execute repository tests.
- `cd example && flutter run` — launch the sample app to exercise the inspector UI.
- `cd example && flutter test` — run example-specific tests.

## Coding Style & Naming Conventions
- Follow the Very Good Analysis lint set (see `analysis_options.yaml`); use 2-space indentation, prefer `const`, and keep imports tidy.
- Public APIs use `HttpInspector*` prefix exclusively (e.g. `HttpInspectorOptions`, `HttpConsoleColors`); internal-only widgets/helpers keep `Fancy*` prefix. Models are PascalCase, files are `snake_case.dart`.
- Widgets end with `...Widget` or `...Page`; helpers/providers use descriptive nouns. Favor barrel exports (e.g., `views.dart`, `interceptors.dart`) to keep imports concise.

## Testing Guidelines
- Place tests in `_test.dart` files that mirror source paths (e.g., `test/ui/http_detail_page_test.dart` for `lib/src/ui/views/http_detail_page.dart`).
- Use widget tests for UI components and unit tests for helpers, logging, and cURL generation logic.
- The cURL extension (`request_extensions.dart`) omits `-X GET` for GET requests (curl defaults to GET); write test assertions accordingly.
- Include assertions around filtering/search behavior and any new request mutation features. Run `flutter test` before opening a PR.
- `flutter analyze` has ~52 pre-existing info-level issues from `very_good_analysis`; do not use `--fatal-infos` in CI — it will always fail on this repo.

## Commit & Pull Request Guidelines
- Keep commit messages short, present-tense, and scoped; include an English summary even when adding bilingual notes (existing history mixes both).
- Create feature branches per change. PRs should describe intent, list commands executed, and attach screenshots/GIFs for UI changes (use the example app to capture).
- Link issues or tickets when available, and call out breaking changes or migration steps explicitly.

## Security & Configuration Tips
- Guard the inspector with `kDebugMode` or similar flags to avoid exposing traffic in production builds.
- Avoid logging or committing secrets/PII; redact tokens in screenshots and sample payloads.
- Keep `maxLogs` bounded to limit in-memory retention and surface only necessary headers/bodies.
