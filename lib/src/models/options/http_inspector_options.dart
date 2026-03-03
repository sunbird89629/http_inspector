import 'package:http_inspector/src/models/options/options.dart';

/// This is used to configure the `HttpInspector` package.
class HttpInspectorOptions {
  /// It controls whether to log requests or not.
  final bool logRequests;

  /// It controls whether to log responses or not.
  final bool logResponses;

  /// It controls whether to log errors or not.
  final bool logErrors;

  /// It controls the maximum number of logs to be stored.
  final int maxLogs;

  /// It controls the console logging options.
  final HttpInspectorConsoleOptions consoleOptions;

  const HttpInspectorOptions({
    this.logRequests = true,
    this.logResponses = true,
    this.logErrors = true,
    this.maxLogs = 50,
    this.consoleOptions = const HttpInspectorConsoleOptions(),
  });
}
