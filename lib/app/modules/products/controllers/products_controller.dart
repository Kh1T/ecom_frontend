import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/providers/admin_product_provider.dart';
import '../../../data/services/storage_service.dart';

class Product {
  final int id;
  final String name;
  final String? description;
  final String category;
  final double price;
  final int stockQuantity;
  final String? sku;
  final List<String> imageUrls;
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.category,
    required this.price,
    required this.stockQuantity,
    this.sku,
    this.imageUrls = const [],
    this.status = 'active',
    this.createdAt,
    this.updatedAt,
  });

  /// Backwards-compatible getter for stock
  int get stock => stockQuantity;

  /// Returns the first available image URL, or null if empty
  String? get firstImageUrl =>
      imageUrls.isNotEmpty && imageUrls.first.isNotEmpty ? imageUrls.first : null;

  factory Product.fromJson(Map<String, dynamic> json) {
    List<String> parsedImages = [];
    if (json['imageUrls'] is List) {
      parsedImages = (json['imageUrls'] as List)
          .map((e) => e?.toString().trim() ?? '')
          .where((e) => e.isNotEmpty)
          .toList();
    } else if (json['imageUrl'] != null &&
        json['imageUrl'].toString().trim().isNotEmpty) {
      parsedImages = [json['imageUrl'].toString().trim()];
    } else if (json['images'] is List) {
      parsedImages = (json['images'] as List)
          .map((e) => e?.toString().trim() ?? '')
          .where((e) => e.isNotEmpty)
          .toList();
    }

    return Product(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? json['title'] as String? ?? '',
      description: json['description'] as String?,
      category: json['category'] as String? ?? 'Uncategorized',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      stockQuantity: (json['stockQuantity'] as num?)?.toInt() ??
          (json['stock'] as num?)?.toInt() ??
          (json['quantity'] as num?)?.toInt() ??
          0,
      sku: json['sku'] as String?,
      imageUrls: parsedImages,
      status: json['status'] as String? ?? 'active',
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'category': category,
        'price': price,
        'stockQuantity': stockQuantity,
        'stock': stockQuantity,
        'sku': sku,
        'imageUrls': imageUrls,
        'status': status,
        if (createdAt != null) 'createdAt': createdAt,
        if (updatedAt != null) 'updatedAt': updatedAt,
      };
}

class ProductsController extends GetxController {
  final AdminProductProvider _provider = AdminProductProvider();

  final products = <Product>[].obs;
  final isLoading = false.obs;
  final categories = <String>['All'].obs;
  final selectedCategory = 'All'.obs;

  List<Product> get filteredProducts {
    if (selectedCategory.value == 'All') return products;
    return products.where((p) => p.category == selectedCategory.value).toList();
  }

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      final data = await _provider.getProducts();

      final List<dynamic> list;
      if (data is List<dynamic>) {
        list = data;
      } else if (data is Map<String, dynamic>) {
        final nested = data['content'] ??
            data['data'] ??
            data['products'] ??
            data['items'] ??
            data['results'];
        if (nested is List<dynamic>) {
          list = nested;
        } else {
          list = [];
        }
      } else {
        list = [];
      }

      final parsed = list
          .whereType<Map<String, dynamic>>()
          .map((item) => Product.fromJson(item))
          .toList();

      products.assignAll(parsed);
      _updateCategories();
    } catch (e) {
      _logDioError('fetchProducts', e);
      Get.snackbar('Error', 'Failed to load products: ${_errorMessage(e)}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchProduct(int id) async {
    try {
      final data = await _provider.getProduct(id);
      if (data is Map<String, dynamic>) {
        final product = Product.fromJson(data);
        debugPrint('Fetched product: ${product.name}');
      }
    } catch (e) {
      debugPrint('Failed to load product $id: $e');
    }
  }

  Future<void> createProduct(Map<String, dynamic> data) async {
    try {
      final result = await _provider.createProduct(data);
      if (result is Map<String, dynamic>) {
        final product = Product.fromJson(result);
        products.add(product);
        _updateCategories();
        Get.snackbar('Success', '${product.name} created');
      }
    } catch (e) {
      debugPrint('Failed to create product: $e');
      Get.snackbar('Error', 'Failed to create product');
    }
  }

  Future<void> updateProduct(int id, Map<String, dynamic> data) async {
    try {
      final result = await _provider.updateProduct(id, data);
      if (result is Map<String, dynamic>) {
        final updated = Product.fromJson(result);
        final index = products.indexWhere((p) => p.id == id);
        if (index != -1) {
          products[index] = updated;
        }
        _updateCategories();
        Get.snackbar('Success', '${updated.name} updated');
      }
    } catch (e) {
      debugPrint('Failed to update product: $e');
      Get.snackbar('Error', 'Failed to update product');
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await _provider.deleteProduct(id);
      products.removeWhere((p) => p.id == id);
      _updateCategories();
      Get.snackbar('Success', 'Product deleted');
    } catch (e) {
      debugPrint('Failed to delete product: $e');
      Get.snackbar('Error', 'Failed to delete product');
    }
  }

  Future<void> updateStatus(int id, String status) async {
    try {
      await _provider.updateStatus(id, {'status': status});
      final index = products.indexWhere((p) => p.id == id);
      if (index != -1) {
        final current = products[index];
        products[index] = Product(
          id: current.id,
          name: current.name,
          description: current.description,
          category: current.category,
          price: current.price,
          stockQuantity: current.stockQuantity,
          sku: current.sku,
          imageUrls: current.imageUrls,
          status: status,
          createdAt: current.createdAt,
          updatedAt: current.updatedAt,
        );
      }
      Get.snackbar('Success', 'Status updated');
    } catch (e) {
      debugPrint('Failed to update status: $e');
      Get.snackbar('Error', 'Failed to update status');
    }
  }

  /// POST /api/v1/admin/products/{id}/images
  ///
  /// Uploads a product image using multipart/form-data.
  Future<bool> addProductImage({
    required int id,
    required List<int> fileBytes,
    required String filename,
    int sortOrder = 0,
  }) async {
    try {
      isLoading.value = true;
      final result = await _provider.addProductImage(
        id: id,
        fileBytes: fileBytes,
        filename: filename,
        sortOrder: sortOrder,
      );

      String? newImageUrl;
      if (result is Map<String, dynamic>) {
        newImageUrl = result['imageUrl'] as String?;
      }

      final index = products.indexWhere((p) => p.id == id);
      if (index != -1 && newImageUrl != null && newImageUrl.isNotEmpty) {
        final current = products[index];
        final updatedImages = List<String>.from(current.imageUrls)
          ..add(newImageUrl);
        products[index] = Product(
          id: current.id,
          name: current.name,
          description: current.description,
          category: current.category,
          price: current.price,
          stockQuantity: current.stockQuantity,
          sku: current.sku,
          imageUrls: updatedImages,
          status: current.status,
          createdAt: current.createdAt,
          updatedAt: current.updatedAt,
        );
      } else {
        await fetchProducts();
      }

      Get.snackbar('Success', 'Product image uploaded successfully');
      return true;
    } catch (e) {
      _logDioError('addProductImage', e);
      Get.snackbar(
        'Error',
        'Failed to upload product image: ${_errorMessage(e)}',
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Opens the file picker, selects an image from gallery, and uploads it.
  Future<bool> pickAndUploadProductImage(
    int productId, {
    int sortOrder = 0,
  }) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile == null) return false;

      final bytes = await pickedFile.readAsBytes();
      final filename =
          pickedFile.name.isNotEmpty ? pickedFile.name : 'product_image.jpg';

      return await addProductImage(
        id: productId,
        fileBytes: bytes,
        filename: filename,
        sortOrder: sortOrder,
      );
    } catch (e) {
      debugPrint('Error picking image: $e');
      Get.snackbar('Error', 'Failed to select image: $e');
      return false;
    }
  }

  Future<void> deleteImage(int id, int imageId) async {
    try {
      await _provider.deleteImage(id, imageId);
      await fetchProducts();
      Get.snackbar('Success', 'Image deleted');
    } catch (e) {
      debugPrint('Failed to delete image: $e');
      Get.snackbar('Error', 'Failed to delete image');
    }
  }

  Future<void> addVariant(int id, Map<String, dynamic> data) async {
    try {
      await _provider.addVariant(id, data);
      Get.snackbar('Success', 'Variant added');
    } catch (e) {
      debugPrint('Failed to add variant: $e');
      Get.snackbar('Error', 'Failed to add variant');
    }
  }

  Future<void> updateVariant(
    int id,
    int variantId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _provider.updateVariant(id, variantId, data);
      Get.snackbar('Success', 'Variant updated');
    } catch (e) {
      debugPrint('Failed to update variant: $e');
      Get.snackbar('Error', 'Failed to update variant');
    }
  }

  void filterByCategory(String category) => selectedCategory.value = category;

  void _updateCategories() {
    final all = products.map((p) => p.category).toSet().toList();
    categories.assignAll(['All', ...all]);
  }

  void _logDioError(String action, dynamic error) {
    final token = Get.find<StorageService>().token;
    debugPrint('=== $action error ===');
    debugPrint('Stored token: $token');
    if (error is DioException) {
      debugPrint('Request path: ${error.requestOptions.path}');
      debugPrint('Request headers: ${error.requestOptions.headers}');
      debugPrint('Response status: ${error.response?.statusCode}');
      debugPrint('Response data: ${error.response?.data}');
    } else {
      debugPrint('Error: $error');
    }
    debugPrint('=====================');
  }

  String _errorMessage(dynamic error) {
    if (error is DioException && error.response?.data != null) {
      final data = error.response!.data;
      if (data is Map<String, dynamic>) {
        final msg = data['message'] ?? data['error'];
        if (msg != null) return msg.toString();
      }
    }
    return error.toString();
  }
}
