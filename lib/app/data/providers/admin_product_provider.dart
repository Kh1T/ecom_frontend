import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;

import '../../config/app_config.dart';
import '../providers/api_provider.dart';

/// Backend API endpoints for product management.
///
/// Base URL is configured in [DioProvider] / [AppConfig].
/// All paths are relative to `http://localhost:8080`.
class AdminProductProvider {
  final ApiProvider _api = Get.find<ApiProvider>();

  static const String _adminBase = AppConfig.adminProducts;
  static const String _productsBase = AppConfig.products;

  /// GET /api/v1/products
  Future<dynamic> getProducts() async {
    final response = await _api.get(_productsBase);
    return response.data;
  }

  /// GET /api/v1/products/{id}
  Future<dynamic> getProduct(int id) async {
    final response = await _api.get('$_productsBase/$id');
    return response.data;
  }

  /// POST /api/v1/admin/products
  Future<dynamic> createProduct(Map<String, dynamic> data) async {
    final response = await _api.post(_adminBase, data: data);
    return response.data;
  }

  /// PUT /api/v1/admin/products/{id}
  Future<dynamic> updateProduct(int id, Map<String, dynamic> data) async {
    final response = await _api.put('$_adminBase/$id', data: data);
    return response.data;
  }

  /// DELETE /api/v1/admin/products/{id}
  Future<void> deleteProduct(int id) async {
    await _api.delete('$_adminBase/$id');
  }

  /// POST /api/v1/admin/products/{id}/images
  ///
  /// Uploads a product image via multipart/form-data.
  Future<dynamic> addProductImage({
    required int id,
    required List<int> fileBytes,
    required String filename,
    int sortOrder = 0,
  }) async {
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        fileBytes,
        filename: filename,
      ),
    });

    final response = await _api.post(
      '$_adminBase/$id/images',
      data: formData,
      queryParameters: {
        'sortOrder': sortOrder,
      },
    );
    return response.data;
  }

  /// DELETE /api/v1/admin/products/{id}/images/{imageId}
  Future<void> deleteImage(int id, int imageId) async {
    await _api.delete('$_adminBase/$id/images/$imageId');
  }

  /// POST /api/v1/admin/products/{id}/variants
  Future<dynamic> addVariant(int id, Map<String, dynamic> data) async {
    final response = await _api.post('$_adminBase/$id/variants', data: data);
    return response.data;
  }

  /// PATCH /api/v1/admin/products/{id}/variants/{variantId}
  Future<dynamic> updateVariant(
    int id,
    int variantId,
    Map<String, dynamic> data,
  ) async {
    final response = await _api.patch(
      '$_adminBase/$id/variants/$variantId',
      data: data,
    );
    return response.data;
  }

  /// PATCH /api/v1/admin/products/{id}/status
  Future<dynamic> updateStatus(int id, Map<String, dynamic> data) async {
    final response = await _api.patch('$_adminBase/$id/status', data: data);
    return response.data;
  }
}
