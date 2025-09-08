import 'package:dio/dio.dart';
import 'package:example/models/login_request.dart';
import 'package:example/models/login_response.dart';
import 'package:flutter/material.dart';
import 'package:http_inspector/http_inspector.dart';

void main() {
  /// Initialize your `Dio` client.
  DioClient.instance.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? token;

  Future<void> login({bool success = true}) async {
    setState(() {
      token = null;
    });

    final response = await DioClient.instance.login(success: success);

    if (response != null) {
      setState(() {
        token = response.token;
      });
    }
  }

  void openHttpScopePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HttpScopeView(
          leading: CloseButton(onPressed: Navigator.of(context).pop),
          viewConfig: HttpScopeViewConfig(
            itemBuilder: (context, record) => Text(record.toString()),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Http Inspector Example',
      home: Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Http Inspector'),
                const SizedBox(height: 16),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    DioClient.instance.mockSuccessHttpRequest();
                  },
                  child: const Text('Mock success Http'),
                ),
                ElevatedButton(
                  onPressed: () {
                    DioClient.instance.mockFailHttpRequest();
                  },
                  child: const Text('Mock fail Http'),
                ),
                ElevatedButton(
                  onPressed: login,
                  child: const Text('Mock error Http Request'),
                ),
                ElevatedButton(
                  onPressed: login,
                  child: const Text('Success Login'),
                ),
                ElevatedButton(
                  onPressed: () => login(success: false),
                  child: const Text('Error Login'),
                ),
                const SizedBox(height: 4),
                ElevatedButton(
                  // onPressed: () => openDioInspector(context),
                  onPressed: () => openHttpScopePage(context),
                  child: const Text('Open HttpDioInspectorView'),
                ),
                Text('Token: $token'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DioClient {
  DioClient._();
  static final DioClient instance = DioClient._();

  late final Dio _dio;

  void init() {
    _dio = Dio(BaseOptions(baseUrl: 'https://reqres.in/api'));

    /// Add the `FancyDioInterceptor` to the `Dio` client.
    _dio.interceptors.add(
      HttpInspectorInterceptor(
        options: const HttpDioInspectorOptions(
          consoleOptions: HttpDioInspectorConsoleOptions(verbose: true),
        ),
      ),
    );
  }

  Future<LoginResponse?> login({bool success = true}) async {
    final request = LoginRequest(
      email: 'eve.holt@reqres.${success ? 'in' : 'com'}',
      password: 'cityslicka',
    );

    try {
      final response = await _dio.post('/login', data: request.toJson());
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> mockSuccessHttpRequest() async {
    const url = "https://api.test.yoofinds.com/api/campaign-products/qMjYbP";
    try {
      final response = await _dio.get(url);
      return response;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> mockFailHttpRequest() async {
    const url =
        "https://api.test.yoofinds.com/api/campaign-products/qMjYbPmockdd";
    try {
      final response = await _dio.get(url);
      return response;
    } catch (e) {
      return null;
    }
  }
}
