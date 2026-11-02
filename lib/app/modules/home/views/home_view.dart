import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../widgets/sidebar/sidebar.dart';
import '../../products/controllers/products_controller.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const Sidebar(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Builder(
                  builder: (context) => IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.menu, color: Colors.black, size: 26),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                Image.asset(
                  'assets/images/logo.png',
                  height: 20,
                  errorBuilder: (context, error, stackTrace) => const Text(
                    'ECOM',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                      letterSpacing: 2,
                      color: Colors.black,
                    ),
                  ),
                ),
                Builder(
                  builder: (context) => GestureDetector(
                    onTap: () => Scaffold.of(context).openDrawer(),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/avatar.png',
                        width: 34,
                        height: 34,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const CircleAvatar(
                          radius: 17,
                          backgroundColor: Colors.black12,
                          child: Icon(Icons.person,
                              size: 20, color: Colors.black87),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar (Tapping navigates to dedicated search page)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            child: GestureDetector(
              onTap: () => Get.toNamed(Routes.SEARCH),
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xFFC4C4C4),
                    width: 1.2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: const [
                    SizedBox(width: 12),
                    Icon(
                      Icons.search,
                      color: Color(0xFF1C1C1E),
                      size: 22,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Search',
                      style: TextStyle(
                        color: Color(0xFF1C1C1E),
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Categories Tabs
          Obx(() {
            final categories = controller.categories;
            final selected = controller.selectedCategory;
            return SizedBox(
              height: 38,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isSelected =
                      cat.toLowerCase() == selected.toLowerCase();

                  return GestureDetector(
                    onTap: () => controller.selectCategory(cat),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 8),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? const Color(0xFFEE5D26) : Colors.white,
                        border: isSelected
                            ? null
                            : Border.all(
                                color: const Color(0xFFE2E2E6), width: 1.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF9E9EA4),
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),

          const SizedBox(height: 12),

          // Product Grid
          Expanded(
            child: Obx(() {
              final products = controller.filteredProducts;
              if (products.isEmpty) {
                return const Center(
                  child: Text(
                    'No products found',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 36),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 36,
                  childAspectRatio: 0.64,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return _buildProductCard(context, product);
                },
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // Main Product Card
        GestureDetector(
          onTap: () => _showProductDetails(context, product),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Heart / Favorite Icon
                Align(
                  alignment: Alignment.topRight,
                  child: Obx(() {
                    final isFav = controller.isFavorite(product.id);
                    return GestureDetector(
                      onTap: () => controller.toggleFavorite(product.id),
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border_rounded,
                          color: isFav ? Colors.red : const Color(0xFF1C1C1E),
                          size: 20,
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 2),

                // Product Image
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: _buildProductImage(
                          product.firstImageUrl, product.name),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Product Name
                Text(
                  product.name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1C1C1E),
                    letterSpacing: 0.1,
                  ),
                ),

                const SizedBox(height: 4),

                // Price (Underlined)
                Text(
                  product.price % 1 == 0
                      ? '\$${product.price.toInt()}'
                      : '\$${product.price.toStringAsFixed(2)}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1C1C1E),
                    decoration: TextDecoration.underline,
                  ),
                ),

                const SizedBox(height: 6),
              ],
            ),
          ),
        ),

        // Overlapping Black Squircle Bag Button
        Positioned(
          bottom: -18,
          child: GestureDetector(
            onTap: () => controller.addToCart(product),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.18),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductImage(String? url, String name) {
    if (url != null && url.isNotEmpty) {
      if (url.startsWith('http://') || url.startsWith('https://')) {
        return Image.network(
          url,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) =>
              _buildPlaceholderImage(name),
        );
      }
      return Image.asset(
        url,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
            _buildPlaceholderImage(name),
      );
    }
    return _buildPlaceholderImage(name);
  }

  Widget _buildPlaceholderImage(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('watch')) {
      return Container(
        width: 80,
        height: 110,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F7F5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 14,
              height: 16,
              decoration: BoxDecoration(
                color: const Color(0xFF88A999),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF1E2824),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF88A999), width: 2.5),
              ),
              child: const Center(
                child: Icon(Icons.access_time_filled,
                    size: 26, color: Colors.white),
              ),
            ),
            Container(
              width: 14,
              height: 16,
              decoration: BoxDecoration(
                color: const Color(0xFF88A999),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ],
        ),
      );
    } else if (lower.contains('headphone') || lower.contains('audio')) {
      return Container(
        width: 80,
        height: 110,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F6F9),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Icon(Icons.headphones, size: 68, color: Color(0xFF8FA7B8)),
        ),
      );
    }
    return const Icon(Icons.phone_android, size: 64, color: Colors.black26);
  }

  Widget _buildBottomNav(BuildContext context) {
    return Obx(() {
      final active = controller.bottomNavIndex.value;
      return Container(
        color: Colors.white,
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _navItem(0, Icons.home_outlined, active == 0),
                    _navItem(1, Icons.grid_view_rounded, active == 1),
                    _navItem(2, Icons.favorite_border_rounded, active == 2),
                    _navItem(3, Icons.shopping_bag_outlined, active == 3),
                    _navItem(4, Icons.person_outline_rounded, active == 4),
                  ],
                ),
              ),
              // iOS Home Indicator pill
              Container(
                margin: const EdgeInsets.only(top: 6, bottom: 6),
                width: 135,
                height: 4.5,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _navItem(int index, IconData icon, bool isActive) {
    return GestureDetector(
      onTap: () => controller.onBottomNavTapped(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 48,
        height: 48,
        child: Center(
          child: isActive
              ? Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                )
              : Icon(icon, color: const Color(0xFF1C1C1E), size: 24),
        ),
      ),
    );
  }

  void _showProductDetails(BuildContext context, Product product) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: SizedBox(
                      height: 180,
                      child: _buildProductImage(
                          product.firstImageUrl, product.name),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.price % 1 == 0
                            ? '\$${product.price.toInt()}'
                            : '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      Text(
                        'Stock: ${product.stockQuantity}',
                        style: const TextStyle(
                            fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Category: ${product.category}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  if (product.description != null &&
                      product.description!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      product.description!,
                      style:
                          const TextStyle(color: Colors.black87, height: 1.4),
                    ),
                  ],
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                        controller.addToCart(product);
                      },
                      icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                      label: const Text('Add to Cart'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
