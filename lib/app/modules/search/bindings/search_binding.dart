import 'package:get/get.dart';

import '../../../data/services/wishlist_service.dart';
import '../../products/controllers/products_controller.dart';
import '../controllers/search_view_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<WishlistService>()) {
      Get.putAsync<WishlistService>(() => WishlistService().init());
    }
    if (!Get.isRegistered<ProductsController>()) {
      Get.lazyPut<ProductsController>(() => ProductsController());
    }
    Get.lazyPut<SearchViewController>(() => SearchViewController());
  }
}
