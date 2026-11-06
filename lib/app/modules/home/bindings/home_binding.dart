import 'package:get/get.dart';

import '../../../data/providers/api_provider.dart';
import '../../../data/services/cart_service.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/services/user_service.dart';
import '../../products/controllers/products_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<StorageService>()) {
      Get.lazyPut<StorageService>(() => StorageService());
    }
    if (!Get.isRegistered<ApiProvider>()) {
      Get.lazyPut<ApiProvider>(() => ApiProvider(Get.find<StorageService>()));
    }
    if (!Get.isRegistered<UserService>()) {
      Get.lazyPut<UserService>(() => UserService());
    }
    if (!Get.isRegistered<CartService>()) {
      Get.putAsync<CartService>(() => CartService().init());
    }
    if (!Get.isRegistered<ProductsController>()) {
      Get.lazyPut<ProductsController>(() => ProductsController());
    }
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
