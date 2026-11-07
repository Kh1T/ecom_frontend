import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../products/controllers/products_controller.dart';
import '../controllers/wishlist_controller.dart';

class WishlistView extends GetView<WishlistController> {
  const WishlistView({super.key});

  static const Color _muted = Color(0xFF9CA3AF);
  static const Color _border = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 56,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Text(
                    'Wishlist',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      padding: const EdgeInsets.only(left: 8),
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 20,
                        color: Colors.black,
                      ),
                      onPressed: () => Get.back(),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                final items = controller.wishlistProducts;
                if (items.isEmpty) {
                  return _buildEmptyState();
                }
                return GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.62,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) =>
                      _buildProductCard(items[index]),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: _buildImage(product),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => controller.removeFromWishlist(product.id),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1C1C1E),
            ),
          ),
          const SizedBox(height: 4),
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
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 36,
            child: ElevatedButton.icon(
              onPressed: () => controller.addToCart(product),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.shopping_bag_outlined, size: 16),
              label: const Text(
                'Add',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(Product product) {
    final url = product.firstImageUrl;
    if (url != null && url.isNotEmpty) {
      if (url.startsWith('http://') || url.startsWith('https://')) {
        return Image.network(
          url,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => _placeholder(),
        );
      }
      return Image.asset(
        url,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return const Icon(Icons.phone_android, size: 56, color: Colors.black26);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                size: 44,
                color: Colors.black38,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Your Wishlist is empty',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Tap the heart on any product to save it here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: _muted,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Get.offAllNamed(Routes.HOME),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Browse Products',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
