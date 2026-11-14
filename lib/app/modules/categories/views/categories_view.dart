import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/app_ui.dart';
import '../controllers/categories_controller.dart';

class CategoriesView extends GetView<CategoriesController> {
  const CategoriesView({super.key});

  static const _categoryTones = [
    Color(0xFFEFF6FF),
    Color(0xFFF5F3FF),
    Color(0xFFFFF7ED),
    Color(0xFFECFDF5),
    Color(0xFFFDF2F8),
    Color(0xFFF0FDFA),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AppPageHeader(
              title: 'Shop categories',
              subtitle: 'Find the right technology for your setup',
            ),
            Expanded(
              child: Obx(() {
                final categories = controller.categories;
                final allCategory = categories.firstWhereOrNull(
                  (category) => category.toLowerCase() == 'all',
                );
                final catalogCategories = categories
                    .where((category) => category.toLowerCase() != 'all')
                    .toList();

                return ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                  children: [
                    if (allCategory != null)
                      _CatalogCard(
                        productCount: controller.productCount(allCategory),
                        onTap: () => controller.selectCategory(allCategory),
                      ),
                    const SizedBox(height: 26),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Expanded(
                          child: AppSectionTitle(
                            'Browse departments',
                            caption: 'Curated technology for work and life',
                          ),
                        ),
                        Text(
                          '${catalogCategories.length} categories',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.93,
                          ),
                      itemCount: catalogCategories.length,
                      itemBuilder: (context, index) {
                        final category = catalogCategories[index];
                        return _CategoryCard(
                          category: category,
                          description: _descriptionFor(category),
                          productCount: controller.productCount(category),
                          icon: controller.iconFor(category),
                          tone: _categoryTones[index % _categoryTones.length],
                          onTap: () => controller.selectCategory(category),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    const _SupportBanner(),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  String _descriptionFor(String category) {
    final normalized = category.toLowerCase();
    if (normalized.contains('phone')) return 'Smartphones & mobile';
    if (normalized.contains('audio') || normalized.contains('head')) {
      return 'Headphones & sound';
    }
    if (normalized.contains('watch')) return 'Wearables & watches';
    if (normalized.contains('accessor')) return 'Essentials & add-ons';
    if (normalized.contains('laptop') || normalized.contains('computer')) {
      return 'Computing & productivity';
    }
    return 'Explore the collection';
  }
}

class _CatalogCard extends StatelessWidget {
  const _CatalogCard({required this.productCount, required this.onTap});

  final int productCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          height: 168,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -30,
                bottom: -46,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                      width: 28,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'FULL CATALOG',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 13),
                          const Text(
                            'All digital products',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '$productCount products ready to explore',
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 12.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.description,
    required this.productCount,
    required this.icon,
    required this.tone,
    required this.onTap,
  });

  final String category;
  final String description;
  final int productCount;
  final IconData icon;
  final Color tone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: tone,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, size: 23, color: AppColors.textPrimary),
                  ),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceMuted,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Icon(
                      Icons.arrow_outward_rounded,
                      size: 15,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                category,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.25,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$productCount ${productCount == 1 ? 'item' : 'items'}',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SupportBanner extends StatelessWidget {
  const _SupportBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        children: [
          Icon(Icons.verified_user_outlined, color: AppColors.textSecondary),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shop with confidence',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Carefully selected digital products and accessories.',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
