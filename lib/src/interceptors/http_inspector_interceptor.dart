import 'package:dio/dio.dart';
import 'package:http_inspector/src/loggers/http_dio_logger.dart';
import 'package:http_inspector/src/models/models.dart';
import 'package:http_inspector/src/typedefs/typedefs.dart';

class HttpInspectorInterceptor extends Interceptor {
  HttpDioLogger get logger => HttpDioLogger.instance;

  final HttpDioInspectorOptions options;

  final OnRequestCreated? onRequestCreated;
  final OnResponseCreated? onResponseCreated;
  final OnErrorCreated? onErrorCreated;

  HttpInspectorInterceptor({
    this.options = const HttpDioInspectorOptions(),
    this.onRequestCreated,
    this.onResponseCreated,
    this.onErrorCreated,
  }) {
    logger.options = options;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (this.options.logRequests) {
      logger.log(options);
      onRequestCreated?.call(options);
    }

    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (options.logResponses) {
      logger.log(response);
      onResponseCreated?.call(response);
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (options.logErrors) {
      logger.log(err);
      onErrorCreated?.call(err);
    }

    handler.next(err);
  }
}
