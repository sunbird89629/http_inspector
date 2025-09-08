import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:http_inspector/src/theme/theme.dart';
import 'package:http_inspector/src/utils/extensions/extensions.dart';

class HttpRecord {
  HttpRecord({
    required this.requestOptions,
    this.response,
    this.dioException,
    this.startTime,
  });

  bool isFavorite = false;
  DateTime? startTime;
  DateTime? endTime;

  final RequestOptions requestOptions;
  Response<dynamic>? response;
  DioException? dioException;

  int? get statusCode {
    if (response != null) {
      return response?.statusCode;
    } else if (dioException != null) {
      return dioException?.response?.statusCode;
    } else {
      return null;
    }
  }

  String get url => requestOptions.uri.toString();
  String get host => requestOptions.uri.host;

  String get duration {
    if (startTime == null || endTime == null) return '';
    final theStartTime = startTime!;
    final theEndTime = endTime!;

    final duration = theEndTime.difference(theStartTime);

    final ms = duration.inMilliseconds +
        duration.inMicroseconds.remainder(1000) / 1000;
    return '${ms.toStringAsFixed(1)} ms';
  }

  Color get statusColor {
    switch (statusCode) {
      case 200:
        return FancyColors.green;
      case null:
        return FancyColors.yellow;
      default:
        return FancyColors.red;
    }
  }

  String get prettyJsonResponseBody {
    if (response?.data != null) {
      return (response!.data as Map<String, dynamic>).toPrettyJson();
    } else if (dioException?.response?.data != null) {
      return (dioException!.response!.data as Map<String, dynamic>)
          .toPrettyJson();
    } else {
      return '';
    }
  }

  String get responseHeadersString {
    if (response != null) {
      return response!.headers.toString();
    } else if (dioException?.response != null) {
      return dioException!.response!.headers.toString();
    } else {
      return '';
    }
  }

  String get contentType {
    // try{
    //   return response?.headers['content-type']![0].split(":")[0];
    // }
    return response?.headers['content-type']?[0].split(';')[0] ?? '';
  }
}
