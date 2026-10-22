import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/providers/admin_product_provider.dart';

class Product {
  final int id;
  final String name;
  final String category;
  final double price;
  final int stock;
  final String status;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    this.status = 'active',
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      category: json['category'] as String? ?? 'Uncategorized',
      price: (json['price'] as num).toDouble(),
      stock: json['stock'] as int? ?? 0,
      status: json['status'] as String? ?? 'active',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'price': price,
        'stock': stock,
        'status': status,
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
      final list = (data as List<dynamic>)
          .map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList();
      products.assignAll(list);
      _updateCategories();
    } catch (e) {
      debugPrint('Failed to load products: $e');
      Get.snackbar('Error', 'Failed to load products');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchProduct(int id) async {
    try {
      final data = await _provider.getProduct(id);
      final product = Product.fromJson(data as Map<String, dynamic>);
      debugPrint('Fetched product: ${product.name}');
    } catch (e) {
      debugPrint('Failed to load product $id: $e');
    }
  }

  Future<void> createProduct(Map<String, dynamic> data) async {
    try {
      final result = await _provider.createProduct(data);
      final product = Product.fromJson(result as Map<String, dynamic>);
      products.add(product);
      _updateCategories();
      Get.snackbar('Success', '${product.name} created');
    } catch (e) {
      debugPrint('Failed to create product: $e');
      Get.snackbar('Error', 'Failed to create product');
    }
  }

  Future<void> updateProduct(int id, Map<String, dynamic> data) async {
    try {
      final result = await _provider.updateProduct(id, data);
      final updated = Product.fromJson(result as Map<String, dynamic>);
      final index = products.indexWhere((p) => p.id == id);
      if (index != -1) {
        products[index] = updated;
      }
      _updateCategories();
      Get.snackbar('Success', '${updated.name} updated');
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
        products[index] = Product(
          id: products[index].id,
          name: products[index].name,
          category: products[index].category,
          price: products[index].price,
          stock: products[index].stock,
          status: status,
        );
      }
      Get.snackbar('Success', 'Status updated');
    } catch (e) {
      debugPrint('Failed to update status: $e');
      Get.snackbar('Error', 'Failed to update status');
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

  Future<void> uploadImage(int id, Map<String, dynamic> data) async {
    try {
      await _provider.uploadImage(id, data);
      Get.snackbar('Success', 'Image uploaded');
    } catch (e) {
      debugPrint('Failed to upload image: $e');
      Get.snackbar('Error', 'Failed to upload image');
    }
  }

  Future<void> deleteImage(int id, int imageId) async {
    try {
      await _provider.deleteImage(id, imageId);
      Get.snackbar('Success', 'Image deleted');
    } catch (e) {
      debugPrint('Failed to delete image: $e');
      Get.snackbar('Error', 'Failed to delete image');
    }
  }

  void filterByCategory(String category) => selectedCategory.value = category;

  void _updateCategories() {
    final all = products.map((p) => p.category).toSet().toList();
    categories.assignAll(['All', ...all]);
  }
}
