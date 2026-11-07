import 'package:get/get.dart';

import '../../../data/services/cart_service.dart';
import '../../../data/services/wishlist_service.dart';
import '../../products/controllers/products_controller.dart';
import '../controllers/wishlist_controller.dart';

class WishlistBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<WishlistService>()) {
      Get.putAsync<WishlistService>(() => WishlistService().init());
    }
    if (!Get.isRegistered<CartService>()) {
      Get.putAsync<CartService>(() => CartService().init());
    }
    if (!Get.isRegistered<ProductsController>()) {
      Get.lazyPut<ProductsController>(() => ProductsController());
    }
    Get.lazyPut<WishlistController>(() => WishlistController());
  }
}
