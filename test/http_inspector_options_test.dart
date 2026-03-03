import 'package:flutter_test/flutter_test.dart';
import 'package:http_inspector/http_inspector.dart';

void main() {
  group('HttpInspectorOptions', () {
    test('defaults are sensible', () {
      const options = HttpInspectorOptions();

      expect(options.logRequests, isTrue);
      expect(options.logResponses, isTrue);
      expect(options.logErrors, isTrue);
      expect(options.maxLogs, equals(50));
    });

    test('can disable individual log types', () {
      const options = HttpInspectorOptions(
        logRequests: false,
        logResponses: false,
        logErrors: false,
      );

      expect(options.logRequests, isFalse);
      expect(options.logResponses, isFalse);
      expect(options.logErrors, isFalse);
    });

    test('maxLogs is configurable', () {
      const options = HttpInspectorOptions(maxLogs: 200);
      expect(options.maxLogs, equals(200));
    });
  });

  group('HttpInspectorConsoleOptions', () {
    test('defaults are sensible', () {
      const options = HttpInspectorConsoleOptions();

      expect(options.verbose, isFalse);
      expect(options.colorize, isTrue);
    });

    test('can enable verbose mode', () {
      const options = HttpInspectorConsoleOptions(verbose: true);
      expect(options.verbose, isTrue);
    });

    test('custom color overrides default', () {
      const options = HttpInspectorConsoleOptions(
        requestColor: HttpConsoleColors.blue,
      );
      expect(options.requestColor, equals(HttpConsoleColors.blue));
    });
  });

  group('HttpInspectorL10nOptions', () {
    test('defaults to English strings', () {
      const options = HttpInspectorL10nOptions();
      expect(options.appBarText, equals('Network Logs'));
      expect(options.copyText, equals('Copy'));
      expect(options.searchHintText, equals('Search'));
    });

    test('can override individual strings', () {
      const options = HttpInspectorL10nOptions(appBarText: 'Requests');
      expect(options.appBarText, equals('Requests'));
    });
  });

  group('HttpInspectorTileOptions', () {
    test('defaults show buttons and search', () {
      const options = HttpInspectorTileOptions();
      expect(options.showButtons, isTrue);
      expect(options.showSearch, isTrue);
    });

    test('can hide buttons', () {
      const options = HttpInspectorTileOptions(showButtons: false);
      expect(options.showButtons, isFalse);
    });
  });
}
