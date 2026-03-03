import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_inspector/src/utils/extensions/request_extensions.dart';

void main() {
  group('CurlExtension', () {
    test('GET request produces valid curl command without -X flag', () {
      final options = RequestOptions(
        path: '/users',
        baseUrl: 'https://api.example.com',
        method: 'GET',
      );

      final curl = options.cURL;

      // Dio's curl extension omits -X for GET (curl defaults to GET)
      expect(curl, startsWith('curl'));
      expect(curl, contains("'https://api.example.com/users'"));
      expect(curl, isNot(contains('-X GET')));
    });

    test('POST request includes -d flag with body', () {
      final options = RequestOptions(
        path: '/login',
        baseUrl: 'https://api.example.com',
        method: 'POST',
        data: {'username': 'test', 'password': 'secret'},
      );

      final curl = options.cURL;

      expect(curl, contains('-X POST'));
      expect(curl, contains('-d'));
      expect(curl, contains('username'));
    });

    test('request with headers includes -H flags', () {
      final options = RequestOptions(
        path: '/secure',
        baseUrl: 'https://api.example.com',
        method: 'GET',
        headers: {'Authorization': 'Bearer token123'},
      );

      final curl = options.cURL;

      expect(curl, contains('-H'));
      expect(curl, contains('Authorization'));
      expect(curl, contains('Bearer token123'));
    });

    test('GET request with query parameters appends to URL', () {
      final options = RequestOptions(
        path: '/search',
        baseUrl: 'https://api.example.com',
        method: 'GET',
        queryParameters: {'q': 'flutter', 'page': '1'},
      );

      final curl = options.cURL;

      expect(curl, contains('q=flutter'));
      expect(curl, contains('page=1'));
    });
  });

  group('RequestExtensions', () {
    test('createUrlComponent returns full URI', () {
      final options = RequestOptions(
        path: '/test',
        baseUrl: 'https://example.com',
      );
      expect(options.createUrlComponent(), equals('https://example.com/test'));
    });

    test('createMethodComponent returns HTTP method', () {
      final options = RequestOptions(
        path: '/',
        baseUrl: 'https://example.com',
        method: 'DELETE',
      );
      expect(options.createMethodComponent(), equals('DELETE'));
    });

    test('createRequestBody returns pretty json for Map data', () {
      final options = RequestOptions(
        path: '/',
        baseUrl: 'https://example.com',
        data: {'key': 'value'},
      );
      final body = options.createRequestBody();
      expect(body, contains('"key"'));
      expect(body, contains('"value"'));
    });
  });
}
