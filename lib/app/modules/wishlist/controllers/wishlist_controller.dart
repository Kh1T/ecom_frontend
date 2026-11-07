import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/services/cart_service.dart';
import '../../../data/services/wishlist_service.dart';
import '../../home/controllers/home_controller.dart';
import '../../products/controllers/products_controller.dart';

class WishlistController extends GetxController {
  WishlistService get _wishlist => Get.find<WishlistService>();

  ProductsController? get _productsController =>
      Get.isRegistered<ProductsController>()
          ? Get.find<ProductsController>()
          : null;

  List<Product> get allProducts {
    final pc = _productsController;
    if (pc != null && pc.products.isNotEmpty) {
      return pc.products;
    }
    return HomeController.defaultSampleProducts;
  }

  List<Product> get wishlistProducts =>
      allProducts.where((p) => _wishlist.isFavorite(p.id)).toList();

  bool isFavorite(int productId) => _wishlist.isFavorite(productId);

  Future<void> removeFromWishlist(int productId) async {
    await _wishlist.remove(productId);
  }

  Future<void> toggleFavorite(int productId) async {
    await _wishlist.toggle(productId);
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
}
