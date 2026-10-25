import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../widgets/sidebar/sidebar.dart';
import '../controllers/admin_controller.dart';

class AdminView extends GetView<AdminController> {
  const AdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 800;
        return isWide ? _buildDesktopLayout(context) : _buildMobileLayout(context);
      },
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        centerTitle: true,
      ),
      drawer: const Sidebar(),
      body: Row(
        children: [
          Obx(
            () => NavigationRail(
              extended: true,
              minExtendedWidth: 200,
              selectedIndex: controller.selectedIndex.value,
              onDestinationSelected: controller.selectIndex,
              destinations: [
                for (var i = 0; i < controller.menuItems.length; i++)
                  NavigationRailDestination(
                    icon: Icon(controller.menuIcons[i]),
                    label: Text(controller.menuItems[i]),
                  ),
              ],
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _buildContent(context),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        centerTitle: true,
      ),
      drawer: const Sidebar(),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Obx(
      () => IndexedStack(
        index: controller.selectedIndex.value,
        children: [
          _buildDashboard(context),
          _buildPlaceholderList('Orders', Icons.shopping_cart),
          _buildPlaceholderList('Users', Icons.people),
        ],
      ),
    );
  }

  Widget _buildDashboard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dashboard',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Obx(
              () => GridView.extent(
                maxCrossAxisExtent: 280,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: [
                  for (final stat in controller.stats)
                    Card(
                      elevation: 2,
                      child: InkWell(
                        onTap: stat['title'] == 'Products'
                            ? () => Get.toNamed(Routes.PRODUCTS)
                            : null,
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                stat['icon'] as IconData,
                                size: 32,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    stat['value'] as String,
                                    style: Theme.of(context).textTheme.headlineMedium,
                                  ),
                                  Text(
                                    stat['title'] as String,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderList(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Icon(icon),
                    title: Text('$title item #${index + 1}'),
                    subtitle: const Text('Placeholder details'),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
