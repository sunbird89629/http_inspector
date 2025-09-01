import 'package:http_inspector/src/models/network/http_record.dart';

class HttpScopeViewConfig {
  final bool Function(HttpRecord record)? recordFilter;
  const HttpScopeViewConfig({
    this.recordFilter,
  });
}
