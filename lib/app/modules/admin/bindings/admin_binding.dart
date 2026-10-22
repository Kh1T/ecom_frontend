import 'package:get/get.dart';

import '../../products/bindings/products_binding.dart';
import '../controllers/admin_controller.dart';

class AdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminController>(
      () => AdminController(),
    );
    ProductsBinding().dependencies();
  }
}
