import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/services/cart_service.dart';
import '../../../data/services/user_service.dart';
import '../../../data/services/wishlist_service.dart';
import '../../../routes/app_pages.dart';
import '../../products/controllers/products_controller.dart';

class HomeController extends GetxController {
  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();
  final isSearchActive = false.obs;
  final searchQuery = ''.obs;
  final selectedSort = 'default'.obs;
  final bottomNavIndex = 0.obs;
  final localSelectedCategory = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    searchFocusNode.addListener(() {
      if (searchFocusNode.hasFocus) {
        isSearchActive.value = true;
      }
    });
  }

  // Sample products matching design
  static final List<Product> defaultSampleProducts = [
    Product(
      id: 1,
      name: 'Phone ( 4a )',
      description: 'High performance smartphone with transparent back design.',
      category: 'Phones',
      price: 299.0,
      stockQuantity: 100,
      sku: 'PHONE-4A',
      imageUrls: ['assets/images/phone_4a.png'],
    ),
    Product(
      id: 2,
      name: 'Phone ( 4b )',
      description: 'Flagship smartphone with advanced camera setup.',
      category: 'Phones',
      price: 499.0,
      stockQuantity: 50,
      sku: 'PHONE-4B',
      imageUrls: ['assets/images/phone_4b.png'],
    ),
    Product(
      id: 5,
      name: 'CMF Watch 3 Pro',
      description: 'Smartwatch with AMOLED display, GPS, and health tracking.',
      category: 'Accessories',
      price: 99.0,
      stockQuantity: 60,
      sku: 'CMF-WATCH-3PRO',
      imageUrls: ['assets/images/phone_4a_pro.png'],
    ),
    Product(
      id: 6,
      name: 'CMF Headphone Pro',
      description: 'Active noise cancelling wireless over-ear headphones.',
      category: 'Audios',
      price: 79.0,
      stockQuantity: 45,
      sku: 'CMF-HEADPHONE-PRO',
      imageUrls: ['assets/images/phone_3a_lite.png'],
    ),
    Product(
      id: 3,
      name: 'Phone ( 4a ) Pro',
      description: 'Pro tier smartphone with peak performance.',
      category: 'Phones',
      price: 519.0,
      stockQuantity: 30,
      sku: 'PHONE-4APRO',
      imageUrls: ['assets/images/phone_4a_pro.png'],
    ),
    Product(
      id: 4,
      name: 'Phone ( 3a ) Lite',
      description: 'Lightweight smartphone with essential features.',
      category: 'Phones',
      price: 199.0,
      stockQuantity: 80,
      sku: 'PHONE-3ALITE',
      imageUrls: ['assets/images/phone_3a_lite.png'],
    ),
  ];

  ProductsController? get _productsController =>
      Get.isRegistered<ProductsController>()
          ? Get.find<ProductsController>()
          : null;

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

  String get selectedCategory => localSelectedCategory.value;

  List<Product> get allProducts {
    final pc = _productsController;
    if (pc != null && pc.products.isNotEmpty) {
      return pc.products;
    }
    return defaultSampleProducts;
  }

  List<Product> get filteredProducts {
    var list = allProducts;
    if (selectedCategory != 'All') {
      list = list
          .where((p) =>
              p.category.toLowerCase() == selectedCategory.toLowerCase())
          .toList();
    }
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isNotEmpty) {
      list = list
          .where((p) =>
              p.name.toLowerCase().contains(query) ||
              (p.description ?? '').toLowerCase().contains(query))
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

  void enterSearch() {
    isSearchActive.value = true;
    if (!searchFocusNode.hasFocus) {
      searchFocusNode.requestFocus();
    }
  }

  void exitSearch() {
    isSearchActive.value = false;
    searchFocusNode.unfocus();
    searchController.clear();
    searchQuery.value = '';
  }

  void setSort(String sort) {
    selectedSort.value = sort;
  }

  void selectCategory(String category) {
    localSelectedCategory.value = category;
    _productsController?.filterByCategory(category);
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  WishlistService? get _wishlist =>
      Get.isRegistered<WishlistService>() ? Get.find<WishlistService>() : null;

  bool isFavorite(int productId) => _wishlist?.isFavorite(productId) ?? false;

  void toggleFavorite(int productId) {
    _wishlist?.toggle(productId);
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

  void onBottomNavTapped(int index) {
    bottomNavIndex.value = index;
    switch (index) {
      case 0:
        // Home
        break;
      case 1:
        // Products / Categories
        Get.toNamed(Routes.PRODUCTS);
        break;
      case 2:
        // Favorites
        Get.toNamed(Routes.WISHLIST);
        break;
      case 3:
        // Cart
        Get.toNamed(Routes.CART);
        break;
      case 4:
        // Profile
        final userService =
            Get.isRegistered<UserService>() ? Get.find<UserService>() : null;
        if (userService != null && userService.isLoggedIn) {
          final user = userService.currentUser.value;
          Get.snackbar(
            'Profile',
            'Signed in as ${user?.fullName ?? user?.email ?? 'User'}',
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          Get.toNamed(Routes.AUTHENTICATION);
        }
        break;
    }
  }

  @override
  void onClose() {
    searchFocusNode.dispose();
    searchController.dispose();
    super.onClose();
  }
}
