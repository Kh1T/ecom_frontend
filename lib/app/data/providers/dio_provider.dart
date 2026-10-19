import 'package:dio/dio.dart';

import '../../config/app_config.dart';

/// Central Dio instance for all backend calls.
///
/// The base URL is read from `AppConfig.apiBaseUrl` (set via the
/// `API_BASE_URL` dart-define). Defaults to `http://localhost:8080/api/v1`.
class DioProvider {
  DioProvider._();

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  )..interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

  static Dio get dio => _dio;
}
