import 'package:flutter/material.dart';
import 'package:http_inspector/http_inspector.dart';
import 'package:http_inspector/src/models/network/http_record.dart';

class MainDataProvider extends ChangeNotifier {
  MainDataProvider({
    required List<HttpRecord> httpRecords,
  }) : _httpRecords = httpRecords;

  HttpScopeViewConfig? _viewConfig;

  HttpScopeViewConfig get viewConfig =>
      _viewConfig ?? const HttpScopeViewConfig();
  set viewConfig(HttpScopeViewConfig val) {
    _viewConfig = val;
    notifyListeners();
  }

  List<HttpRecord>? _httpRecords;
  List<HttpRecord> get httpRecords => _httpRecords ?? [];
  set httpRecords(List<HttpRecord> val) {
    _httpRecords = val;
    notifyListeners();
  }
}
