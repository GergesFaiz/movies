import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioFactory {
  static Dio create() {
    final options = BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    final dio = Dio(options);

    // Full response bodies are large; only log them while developing.
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          responseBody: true,
          error: true,
          requestBody: false,
        ),
      );
    }

    return dio;
  }
}
