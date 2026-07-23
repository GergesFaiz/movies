import 'package:dio/dio.dart';

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

    dio.interceptors.add(
      LogInterceptor(
        request: true,
        responseBody: true,
        error: true,
        requestBody: false,
      ),
    );

    return dio;
  }
}
