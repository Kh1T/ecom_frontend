import 'package:get/get.dart';

import '../../../data/services/cart_service.dart';
import '../controllers/cart_controller.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CartService>()) {
      Get.putAsync<CartService>(() => CartService().init());
    }
    Get.lazyPut<CartController>(
      () => CartController(),
    );
  }
}
