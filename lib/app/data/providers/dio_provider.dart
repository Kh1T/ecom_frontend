import 'package:dio/dio.dart';

/// Central Dio instance for all backend calls.
///
/// Set the backend base URL with the `API_BASE_URL` dart-define, e.g.:
///   flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080
///
/// Defaults to `http://localhost:8080` (works for Flutter web/desktop).
class DioProvider {
  DioProvider._();

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'http://localhost:8080',
      ),
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  static Dio get dio => _dio;
}
