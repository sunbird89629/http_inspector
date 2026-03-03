# Contributing to http_inspector

Thank you for your interest in contributing! Here is everything you need to get started.

## Development setup

**Requirements:** Flutter ≥ 3.0.5, Dart ≥ 2.17.6

```bash
git clone https://github.com/Howard-Wang/http_inspector.git
cd http_inspector
flutter pub get
```

Run the example app:

```bash
cd example
flutter pub get
flutter run
```

## Making changes

1. Fork the repository and create a feature branch from `main`.
2. Write your code following the existing style (enforced by `very_good_analysis`).
3. Add or update tests for any changed behaviour.
4. Run the full quality suite:

```bash
dart format .
flutter analyze
flutter test
```

5. Update `CHANGELOG.md` with a summary of your change under an `## Unreleased` section.
6. Open a pull request with a clear description of the change.

## Commit style

Use [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add filter by status code
fix: prevent crash on binary response bodies
docs: improve HttpInspectorOptions docstring
```

## Reporting bugs

Please use the [bug report template](.github/ISSUE_TEMPLATE/bug_report.md) and include a minimal reproduction case whenever possible.

## Code of Conduct

Be respectful and constructive. We follow the [Contributor Covenant](https://www.contributor-covenant.org/).
