import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/services/cart_service.dart';
import '../../products/controllers/products_controller.dart';

class CartItem {
  final int id;
  final Product product;
  final RxInt quantity;
  final String colorName;
  final Color color;
  final String size;

  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
    required this.colorName,
    required this.color,
    required this.size,
  });

  double get total => product.price * quantity.value;
}

class CartController extends GetxController {
  final CartService _cartService = Get.find<CartService>();
  final cartItems = <CartItem>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  Future<void> loadCart() async {
    isLoading.value = true;
    final items = await _cartService.getCartItems();
    cartItems.assignAll(items);
    isLoading.value = false;
  }

  double get totalPrice =>
      cartItems.fold(0.0, (sum, item) => sum + item.total);

  Future<void> increaseQuantity(CartItem item) async {
    item.quantity.value++;
    cartItems.refresh();
    await _cartService.updateQuantity(item.product.id, item.quantity.value);
  }

  Future<void> decreaseQuantity(CartItem item) async {
    if (item.quantity.value > 1) {
      item.quantity.value--;
      cartItems.refresh();
      await _cartService.updateQuantity(item.product.id, item.quantity.value);
    }
  }

  Future<void> removeItem(CartItem item) async {
    cartItems.remove(item);
    await _cartService.removeItem(item.product.id);
  }

  Future<void> clearCart() async {
    cartItems.clear();
    await _cartService.clearCart();
  }

  void checkout() {
    if (cartItems.isEmpty) {
      Get.snackbar(
        'Cart is empty',
        'Add some items before checking out.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
      return;
    }

    Get.snackbar(
      'Checkout',
      'Total: \$${totalPrice.toStringAsFixed(2)}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }
}
