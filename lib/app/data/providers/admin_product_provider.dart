import 'package:get/get.dart';

import '../providers/api_provider.dart';

/// Backend API endpoints for admin product management.
///
/// Base URL is configured in [DioProvider] / [AppConfig].
/// All paths are relative to `http://localhost:8080`.
class AdminProductProvider {
  final ApiProvider _api = Get.find<ApiProvider>();

  static const String _base = '/api/v1/admin/products';

  /// GET /api/v1/admin/products
  Future<dynamic> getProducts() async {
    final response = await _api.get(_base);
    return response.data;
  }

  /// GET /api/v1/admin/products/{id}
  Future<dynamic> getProduct(int id) async {
    final response = await _api.get('$_base/$id');
    return response.data;
  }

  /// POST /api/v1/admin/products
  Future<dynamic> createProduct(Map<String, dynamic> data) async {
    final response = await _api.post(_base, data: data);
    return response.data;
  }

  /// PUT /api/v1/admin/products/{id}
  Future<dynamic> updateProduct(int id, Map<String, dynamic> data) async {
    final response = await _api.put('$_base/$id', data: data);
    return response.data;
  }

  /// DELETE /api/v1/admin/products/{id}
  Future<void> deleteProduct(int id) async {
    await _api.delete('$_base/$id');
  }

  /// POST /api/v1/admin/products/{id}/variants
  Future<dynamic> addVariant(int id, Map<String, dynamic> data) async {
    final response = await _api.post('$_base/$id/variants', data: data);
    return response.data;
  }

  /// PATCH /api/v1/admin/products/{id}/variants/{variantId}
  Future<dynamic> updateVariant(
    int id,
    int variantId,
    Map<String, dynamic> data,
  ) async {
    final response = await _api.patch(
      '$_base/$id/variants/$variantId',
      data: data,
    );
    return response.data;
  }

  /// POST /api/v1/admin/products/{id}/images
  Future<dynamic> uploadImage(int id, Map<String, dynamic> data) async {
    final response = await _api.post('$_base/$id/images', data: data);
    return response.data;
  }

  /// DELETE /api/v1/admin/products/{id}/images/{imageId}
  Future<void> deleteImage(int id, int imageId) async {
    await _api.delete('$_base/$id/images/$imageId');
  }

  /// PATCH /api/v1/admin/products/{id}/status
  Future<dynamic> updateStatus(int id, Map<String, dynamic> data) async {
    final response = await _api.patch('$_base/$id/status', data: data);
    return response.data;
  }
}
