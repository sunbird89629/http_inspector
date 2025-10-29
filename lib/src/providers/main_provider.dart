import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_inspector/http_inspector.dart';
import 'package:http_inspector/src/models/network/http_record.dart';

class MainProvider extends ChangeNotifier {
  factory MainProvider() => _instance;

  MainProvider._internal();
  static final MainProvider _instance = MainProvider._internal();

  HttpScopeViewConfig? _viewConfig;

  HttpScopeViewConfig get viewConfig =>
      _viewConfig ?? const HttpScopeViewConfig();
  set viewConfig(HttpScopeViewConfig val) {
    _viewConfig = val;
    notifyListeners();
  }

  final List<HttpRecord> _httpRecords = [];
  List<HttpRecord> get httpRecords => _httpRecords;

  void insertHttpRecord(HttpRecord record) {
    _httpRecords.insert(0, record);
    notifyListeners();
  }

  void clearHttpRecords() {
    _httpRecords.clear();
    notifyListeners();
  }

  void updateHttpRecord(void Function() updater) {
    updater.call();
    notifyListeners();
  }

  void updateHttpRecords(void Function(List<HttpRecord> records) updater) {
    updater.call(_httpRecords);
    notifyListeners();
  }

  void updateHttpRecordByRequestOptions(
    RequestOptions options,
    void Function(HttpRecord record) updater,
  ) {
    updateHttpRecords((records) {
      final target = records.firstWhere(
        (element) => element.requestOptions == options,
      );
      updater.call(target);
    });
  }
}
