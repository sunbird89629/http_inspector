import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_inspector/src/models/models.dart';
import 'package:http_inspector/src/models/network/http_record.dart';
import 'package:http_inspector/src/providers/main_provider.dart';
import 'package:http_inspector/src/utils/enums/enums.dart';
import 'package:http_inspector/src/utils/extensions/extensions.dart';

class HttpDioLogger {
  HttpDioLogger._();
  static final HttpDioLogger instance = HttpDioLogger._();

  HttpDioInspectorOptions options = const HttpDioInspectorOptions();
  HttpDioInspectorConsoleOptions get consoleOptions => options.consoleOptions;

  void log<T>(T data) {
    final now = DateTime.now();

    if (data is RequestOptions) {
      data.extra[FancyDioKey.requestTime.key] = now;

      final requestModel = NetworkRequestModel(
        url: data.createUrlComponent(),
        method: data.createMethodComponent(),
        requestBody: data.createRequestBody(),
        headers: data.createRequestHeadersComponent(),
        cURL: data.cURL,
        time: now,
      );
      if (consoleOptions.verbose) {
        consoleLog(model: requestModel);
      }

      MainProvider().insertHttpRecord(
        HttpRecord(requestOptions: data, startTime: now),
      );
      // _records.insert(0, HttpRecord(requestOptions: data, startTime: now));
    } else if (data is Response) {
      final responseModel = NetworkResponseModel(
        url: data.createUrlComponent(),
        method: data.createMethodComponent(),
        requestBody: data.createRequestComponent(),
        headers: data.createResponseHeadersComponent(),
        cURL: data.cURL,
        statusCode: data.createStatusCodeComponent(),
        responseBody: data.createResponseComponent(),
        time: now,
        elapsedDuration: data.calculateElapsedDuration(),
      );
      if (consoleOptions.verbose) {
        consoleLog(model: responseModel);
      }
      MainProvider().updateHttpRecordByRequestOptions(
        data.requestOptions,
        (record) {
          record
            ..response = data
            ..endTime = now;
        },
      );
    } else if (data is DioException) {
      final errorModel = NetworkErrorModel(
        url: data.createUrlComponent(),
        method: data.createMethodComponent(),
        requestBody: data.createRequestComponent(),
        headers: data.createResponseHeadersComponent(),
        cURL: data.cURL,
        statusCode: data.createStatusCodeComponent(),
        errorBody: data.createErrorComponent(),
        time: now,
        elapsedDuration: data.calculateElapsedDuration(),
      );

      if (consoleOptions.verbose) {
        consoleLog(model: errorModel);
      }
      MainProvider().updateHttpRecordByRequestOptions(
        data.requestOptions,
        (record) {
          record
            ..dioException = data
            ..endTime = now;
        },
      );
    } else {
      throw Exception('Invalid type!');
    }
  }

  void consoleLog({
    required NetworkBaseModel model,
  }) {
    late final String name;
    late FancyConsoleTextColors ansiiColor;
    const resetAnsiColor = FancyConsoleTextColors.reset;

    switch (model.runtimeType) {
      case NetworkRequestModel:
        name = consoleOptions.requestName;
        ansiiColor = consoleOptions.requestColor;
        break;
      case NetworkResponseModel:
        name = consoleOptions.responseName;
        ansiiColor = consoleOptions.responseColor;
        break;
      case NetworkErrorModel:
        name = consoleOptions.errorName;
        ansiiColor = consoleOptions.errorColor;
        break;
      default:
        throw Exception('Invalid type! ${model.runtimeType}}');
    }

    /// If [consoleOptions.colorize] is [false], we should reset the color.
    if (!consoleOptions.colorize) {
      ansiiColor = FancyConsoleTextColors.reset;
    }

    final data = model.toClipboardText();

    /// [log] function inside `dart:developer` truncates the output for some
    /// reason, so we use [debugPrint] instead as a workaround.
    if (kIsWeb) {
      final color = ansiiColor.value;

      debugPrint(
        '$color$data'.replaceAll('\n', '\n$color'),
      );
    } else {
      developer.log(
        '${ansiiColor.value}$data${resetAnsiColor.value}',
        name: name,
      );
    }
  }
  // List<HttpRecord> get records => _records;
}
