import 'package:flutter/material.dart';
import 'package:http_inspector/src/models/network/http_record.dart';
import 'package:http_inspector/src/ui/widgets/http_record_item_widget.dart';

class HttpScopeViewConfig {
  // default http record filter: always returns true
  static bool _defaultRecordFilter(HttpRecord record) => true;
  // default always start filter
  static bool _defaultAlwaysStar(HttpRecord record) => false;
  // default http record item widget builder, diplayed in http record list page
  static Widget _defaultHttpItemBuilder(
    BuildContext context,
    HttpRecord record,
  ) =>
      HttpRecordItemWidget(record: record);
  final bool Function(HttpRecord record) recordFilter;
  final bool Function(HttpRecord record) alwaysStar;
  final Widget Function(BuildContext context, HttpRecord record) itemBuilder;
  const HttpScopeViewConfig({
    this.recordFilter = _defaultRecordFilter,
    this.itemBuilder = _defaultHttpItemBuilder,
    this.alwaysStar = _defaultAlwaysStar,
  });
}
