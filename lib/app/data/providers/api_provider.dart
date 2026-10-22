import 'package:dio/dio.dart';

import '../services/storage_service.dart';
import 'dio_provider.dart';

/// High-level API wrapper around [DioProvider].
///
/// Automatically attaches the stored bearer token to outgoing requests when
/// the user is authenticated.
class ApiProvider {
  final StorageService _storage;

  ApiProvider(this._storage);

  Dio get dio => DioProvider.dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: _authOptions(),
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
  }) async {
    return dio.post<T>(
      path,
      data: data,
      options: _authOptions(),
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
  }) async {
    return dio.put<T>(
      path,
      data: data,
      options: _authOptions(),
    );
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
  }) async {
    return dio.patch<T>(
      path,
      data: data,
      options: _authOptions(),
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
  }) async {
    return dio.delete<T>(
      path,
      data: data,
      options: _authOptions(),
    );
  }

  Options? _authOptions() {
    final token = _storage.token;
    if (token == null || token.isEmpty) return null;
    return Options(headers: {'Authorization': 'Bearer $token'});
  }
}
