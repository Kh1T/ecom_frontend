import 'package:get/get.dart';

import '../../products/controllers/products_controller.dart';
import '../controllers/categories_controller.dart';

class CategoriesBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ProductsController>()) {
      Get.lazyPut<ProductsController>(() => ProductsController());
    }
    Get.lazyPut<CategoriesController>(() => CategoriesController());
  }
}
