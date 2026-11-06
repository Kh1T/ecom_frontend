import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/services/cart_service.dart';
import '../../home/controllers/home_controller.dart';
import '../../products/controllers/products_controller.dart';

class SearchViewController extends GetxController {
  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();
  final searchQuery = ''.obs;
  final selectedCategory = 'All'.obs;
  final selectedSort = 'default'.obs;
  final favorites = <int>{}.obs;

  ProductsController? get _productsController =>
      Get.isRegistered<ProductsController>()
          ? Get.find<ProductsController>()
          : null;

  HomeController? get _homeController =>
      Get.isRegistered<HomeController>() ? Get.find<HomeController>() : null;

  @override
  void onInit() {
    super.onInit();
    final hc = _homeController;
    if (hc != null) {
      favorites.assignAll(hc.favorites);
      if (hc.searchQuery.value.isNotEmpty) {
        searchQuery.value = hc.searchQuery.value;
        searchController.text = hc.searchQuery.value;
      }
    }
  }

  List<String> get categories {
    final set = <String>{'All', 'Accessories', 'Phones', 'Audios'};
    final pc = _productsController;
    if (pc != null && pc.products.isNotEmpty) {
      for (final p in pc.products) {
        if (p.category.isNotEmpty) {
          set.add(p.category);
        }
      }
    }
    return set.toList();
  }

  List<Product> get allProducts {
    final pc = _productsController;
    if (pc != null && pc.products.isNotEmpty) {
      return pc.products;
    }
    return HomeController.defaultSampleProducts;
  }

  List<Product> get filteredProducts {
    var list = allProducts;
    if (selectedCategory.value != 'All') {
      list = list
          .where((p) =>
              p.category.toLowerCase() == selectedCategory.value.toLowerCase())
          .toList();
    }
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isNotEmpty) {
      list = list
          .where((p) =>
              p.name.toLowerCase().contains(query) ||
              (p.description ?? '').toLowerCase().contains(query) ||
              p.category.toLowerCase().contains(query))
          .toList();
    }
    if (selectedSort.value == 'price_asc') {
      list = List.from(list)..sort((a, b) => a.price.compareTo(b.price));
    } else if (selectedSort.value == 'price_desc') {
      list = List.from(list)..sort((a, b) => b.price.compareTo(a.price));
    } else if (selectedSort.value == 'name_asc') {
      list = List.from(list)..sort((a, b) => a.name.compareTo(b.name));
    }
    return list;
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void setSort(String sort) {
    selectedSort.value = sort;
  }

  bool isFavorite(int productId) => favorites.contains(productId);

  void toggleFavorite(int productId) {
    if (favorites.contains(productId)) {
      favorites.remove(productId);
    } else {
      favorites.add(productId);
    }
    final hc = _homeController;
    if (hc != null) {
      if (favorites.contains(productId)) {
        hc.favorites.add(productId);
      } else {
        hc.favorites.remove(productId);
      }
    }
  }

  Future<void> addToCart(Product product) async {
    final cartService =
        Get.isRegistered<CartService>() ? Get.find<CartService>() : null;
    if (cartService != null) {
      await cartService.addItem(product);
    }

    Get.snackbar(
      'Added to Cart',
      '${product.name} added to your cart',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  @override
  void onClose() {
    searchFocusNode.dispose();
    searchController.dispose();
    super.onClose();
  }
}
