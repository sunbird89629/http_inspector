import 'package:http_inspector/src/models/network/http_record.dart';
import 'package:flutter/material.dart';

class MainDataProvider extends ChangeNotifier {
  MainDataProvider({
    required List<HttpRecord> httpRecords,
  }) : _httpRecords = httpRecords;
  List<HttpRecord>? _httpRecords;
  List<HttpRecord> get httpRecords => _httpRecords ?? [];
  set httpRecords(List<HttpRecord> val) {
    _httpRecords = val;
    notifyListeners();
  }
}
