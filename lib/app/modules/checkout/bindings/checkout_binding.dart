import 'package:get/get.dart';

import '../../../data/services/cart_service.dart';
import '../../cart/controllers/cart_controller.dart';
import '../controllers/checkout_controller.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CartService>()) {
      Get.putAsync<CartService>(() => CartService().init());
    }
    if (!Get.isRegistered<CartController>()) {
      Get.lazyPut<CartController>(() => CartController());
    }
    Get.lazyPut<CheckoutController>(() => CheckoutController());
  }
}
