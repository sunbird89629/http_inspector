import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_inspector/src/models/network/http_record.dart';

void main() {
  group('HttpRecord', () {
    late RequestOptions requestOptions;

    setUp(() {
      requestOptions = RequestOptions(
        path: '/api/login',
        baseUrl: 'https://example.com',
        method: 'POST',
      );
    });

    test('url returns full URI string', () {
      final record = HttpRecord(requestOptions: requestOptions);
      expect(record.url, equals('https://example.com/api/login'));
    });

    test('host returns host component', () {
      final record = HttpRecord(requestOptions: requestOptions);
      expect(record.host, equals('example.com'));
    });

    test('isRequesting is true when no response or exception', () {
      final record = HttpRecord(requestOptions: requestOptions);
      expect(record.isRequesting, isTrue);
    });

    test('isRequesting is false when response is set', () {
      final record = HttpRecord(requestOptions: requestOptions)
        ..response = Response(
          requestOptions: requestOptions,
          statusCode: 200,
        );
      expect(record.isRequesting, isFalse);
    });

    test('statusCode returns response status code', () {
      final record = HttpRecord(requestOptions: requestOptions)
        ..response = Response(
          requestOptions: requestOptions,
          statusCode: 201,
        );
      expect(record.statusCode, equals(201));
    });

    test('statusCode returns null when no response or exception', () {
      final record = HttpRecord(requestOptions: requestOptions);
      expect(record.statusCode, isNull);
    });

    test('statusCode returns exception response status code', () {
      final record = HttpRecord(requestOptions: requestOptions)
        ..exception = DioException(
          requestOptions: requestOptions,
          response: Response(
            requestOptions: requestOptions,
            statusCode: 404,
          ),
        );
      expect(record.statusCode, equals(404));
    });

    test('duration returns empty string when times are null', () {
      final record = HttpRecord(requestOptions: requestOptions);
      expect(record.duration, equals(''));
    });

    test('duration returns milliseconds between start and end', () {
      final start = DateTime(2024, 1, 1, 12);
      final end = DateTime(2024, 1, 1, 12, 0, 1); // 1 second later
      final record = HttpRecord(
        requestOptions: requestOptions,
        startTime: start,
      )..endTime = end;
      expect(record.duration, equals('1000'));
    });

    test('isFavorite defaults to false', () {
      final record = HttpRecord(requestOptions: requestOptions);
      expect(record.isFavorite, isFalse);
    });

    test('isFavorite can be toggled', () {
      final record = HttpRecord(requestOptions: requestOptions)
        ..isFavorite = true;
      expect(record.isFavorite, isTrue);
    });
  });
}
