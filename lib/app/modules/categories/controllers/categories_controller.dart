import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../home/controllers/home_controller.dart';
import '../../products/controllers/products_controller.dart';

class CategoriesController extends GetxController {
  ProductsController? get _productsController =>
      Get.isRegistered<ProductsController>()
          ? Get.find<ProductsController>()
          : null;

  HomeController? get _homeController =>
      Get.isRegistered<HomeController>() ? Get.find<HomeController>() : null;

  List<Product> get allProducts {
    final pc = _productsController;
    if (pc != null && pc.products.isNotEmpty) {
      return pc.products;
    }
    return HomeController.defaultSampleProducts;
  }

  List<String> get categories {
    final set = <String>{'All', 'Accessories', 'Phones', 'Audios'};
    for (final product in allProducts) {
      if (product.category.isNotEmpty) {
        set.add(product.category);
      }
    }
    return set.toList();
  }

  int productCount(String category) {
    if (category == 'All') return allProducts.length;
    return allProducts
        .where((p) =>
            p.category.toLowerCase() == category.toLowerCase())
        .length;
  }

  IconData iconFor(String category) {
    final lower = category.toLowerCase();
    if (lower == 'all') return Icons.grid_view_rounded;
    if (lower.contains('phone')) return Icons.smartphone;
    if (lower.contains('watch')) return Icons.watch;
    if (lower.contains('audio') || lower.contains('head')) {
      return Icons.headphones;
    }
    if (lower.contains('accessor')) return Icons.watch_outlined;
    return Icons.category_outlined;
  }

  void selectCategory(String category) {
    final home = _homeController;
    if (home != null) {
      home.selectCategory(category);
    }
    if (home != null || _productsController != null) {
      Get.back();
    }
  }
}
