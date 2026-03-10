import 'package:flutter/material.dart';
import 'package:http_inspector/src/models/network/http_record.dart';
import 'package:http_inspector/src/ui/widgets/http_record_item_widget.dart';

typedef SingleFilter = bool Function(HttpRecord item);

class HttpScopeViewConfig {
  static bool _defaultRecordFilter(HttpRecord record) => true;
  static bool _defaultAlwaysStar(HttpRecord record) => false;
  static Widget _defaultHttpItemBuilder(
    BuildContext context,
    HttpRecord record,
  ) =>
      HttpRecordItemWidget(record: record);

  /// Filter to control which records appear in the list. Defaults to showing all.
  final bool Function(HttpRecord record) recordFilter;

  /// Records matching this predicate are always starred and cannot be cleared.
  /// Defaults to never auto-starring.
  final bool Function(HttpRecord record) alwaysStar;

  /// Custom item builder for the request list. Defaults to [HttpRecordItemWidget].
  final Widget Function(BuildContext context, HttpRecord record) itemBuilder;

  /// Additional per-record filters applied on top of [recordFilter].
  final List<SingleFilter> customFilters;

  /// Optional callback invoked when the share action is triggered from the
  /// detail page. When `null`, the share button is hidden.
  ///
  /// Example — send to a custom webhook:
  /// ```dart
  /// onShareAction: (record) async {
  ///   await myWebhookClient.post(record.toHttpRequestLog());
  /// },
  /// ```
  final Future<void> Function(HttpRecord record)? onShareAction;

  /// URL opened when the user taps the help button in [HttpScopeView].
  /// When `null`, the help button is hidden.
  final String? manualUrl;

  const HttpScopeViewConfig({
    this.recordFilter = _defaultRecordFilter,
    this.itemBuilder = _defaultHttpItemBuilder,
    this.alwaysStar = _defaultAlwaysStar,
    this.customFilters = const [],
    this.onShareAction,
    this.manualUrl,
  });
}
