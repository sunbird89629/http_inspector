import 'package:http_inspector/src/models/network/http_record.dart';

class HttpScopeViewConfig {
  final bool Function(HttpRecord record)? recordFilter;
  /// The URL to open when the user taps the help button in HttpScopeView.
  /// If null, a sensible default pointing to the repository manual will be used.
  final String? manualUrl;
  /// Optional manual opener. If provided, it will be used to open [manualUrl]
  /// (or the default manual URL). This allows apps to integrate their own
  /// launching logic without adding extra dependencies in this package.
  final void Function(String manualUrl)? onOpenManual;
  const HttpScopeViewConfig({
    this.recordFilter,
    this.manualUrl,
    this.onOpenManual,
  });
}
