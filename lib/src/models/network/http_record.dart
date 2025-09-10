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
    return response?.headers['content-type']?[0].split(';')[0] ?? '';
  }

  String toCurlCommand() {
    final curl = StringBuffer('curl');

    // Method
    curl.write(' -X ${requestOptions.method}');

    // Headers
    requestOptions.headers.forEach((key, value) {
      // Escape single quotes in the header value
      final escapedValue = value.toString().replaceAll("'", r"\'\");
      curl.write(" -H '$key: $escapedValue'");
    });

    // Body
    if (requestOptions.data != null) {
      String body;
      if (requestOptions.data is Map) {
        body = (requestOptions.data as Map<String, dynamic>).toPrettyJson();
      } else {
        body = requestOptions.data.toString();
      }
      // Escape single quotes in the body
      body = body.replaceAll("'", r"\'\");
      curl.write(" -d '$body'");
    }

    // URL
    curl.write(" '${requestOptions.uri}'");

    return curl.toString();
  }

  String toHttpRequestLog() {
    final buffer = StringBuffer();
    // Request
    buffer.writeln('## Request');
    buffer.writeln();
    buffer.writeln('- URL: ${requestOptions.uri}');
    buffer.writeln('- Method: ${requestOptions.method}');
    if (requestOptions.headers.isNotEmpty) {
      buffer.writeln('- Headers:');
      requestOptions.headers.forEach((key, value) {
        buffer.writeln('  - $key: $value');
      });
    }
    if (requestOptions.data != null) {
      buffer.writeln('- Body:');
      buffer.writeln('  ```json');
      if (requestOptions.data is Map) {
        buffer.writeln(
          (requestOptions.data as Map<String, dynamic>).toPrettyJson(),
        );
      } else {
        buffer.writeln(requestOptions.data.toString());
      }
      buffer.writeln('  ```');
    }
    buffer.writeln();

    // Curl Command
    buffer.writeln('## Curl Command');
    buffer.writeln('```bash');
    buffer.writeln(toCurlCommand());
    buffer.writeln('```');
    buffer.writeln();

    // Response
    if (response != null) {
      buffer.writeln('## Response');
      buffer.writeln();
      buffer.writeln('- Status Code: ${response!.statusCode}');
      if (response!.headers.map.isNotEmpty) {
        buffer.writeln('- Headers:');
        response!.headers.forEach((key, values) {
          buffer.writeln('  - $key: ${values.join(', ')}');
        });
      }
      if (response!.data != null) {
        buffer.writeln('- Body:');
        buffer.writeln('  ```json');
        buffer.writeln(prettyJsonResponseBody);
        buffer.writeln('  ```');
      }
      buffer.writeln();
    }

    // Error
    if (dioException != null) {
      buffer.writeln('## Error');
      buffer.writeln();
      buffer.writeln('- Message: ${dioException!.message}');
      if (dioException!.response != null) {
        buffer.writeln('- Status Code: ${dioException!.response!.statusCode}');
        if (dioException!.response!.headers.map.isNotEmpty) {
          buffer.writeln('- Headers:');
          dioException!.response!.headers.forEach((key, values) {
            buffer.writeln('  - $key: ${values.join(', ')}');
          });
        }
        if (dioException!.response!.data != null) {
          buffer.writeln('- Body:');
          buffer.writeln('  ```json');
          buffer.writeln(prettyJsonResponseBody);
          buffer.writeln('  ```');
        }
      }
      buffer.writeln('- Stack Trace:');
      buffer.writeln('  ```');
      buffer.writeln(dioException!.stackTrace.toString());
      buffer.writeln('  ```');
      buffer.writeln();
    }

    return buffer.toString();
  }
}
