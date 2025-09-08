import 'package:http_inspector/src/models/fancy_dio_inspector/fancy_dio_inspector.dart';

/// This is used to configure the `FancyDioInspector` package.
class HttpDioInspectorOptions {
  /// It controls whether to log requests or not.
  final bool logRequests;

  /// It controls whether to log responses or not.
  final bool logResponses;

  /// It controls whether to log errors or not.
  final bool logErrors;

  /// It controls the maximum number of logs to be stored.
  final int maxLogs;

  /// It controls the console logging options.
  final HttpDioInspectorConsoleOptions consoleOptions;

  const HttpDioInspectorOptions({
    this.logRequests = true,
    this.logResponses = true,
    this.logErrors = true,
    this.maxLogs = 50,
    this.consoleOptions = const HttpDioInspectorConsoleOptions(),
  });
}
