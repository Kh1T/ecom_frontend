import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/services/user_service.dart';
import '../../modules/dashboard/controllers/language_controller.dart';
import '../../routes/app_pages.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  static const _ink = Color(0xFF1C1C1E);
  static const _accent = Color(0xFFEE5D26);
  static const _muted = Color(0xFF9E9EA4);
  static const _line = Color(0xFFE2E2E6);

  @override
  Widget build(BuildContext context) {
    final userService = Get.isRegistered<UserService>()
        ? Get.find<UserService>()
        : null;

    if (userService != null &&
        userService.isLoggedIn &&
        userService.currentUser.value == null &&
        !userService.isLoading.value) {
      userService.fetchCurrentUser();
    }

    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(userService),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _sectionLabel('SHOP'),
                  _SidebarTile(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home_rounded,
                    label: 'Home',
                    route: Routes.home,
                    onTap: () => Get.offAllNamed(Routes.home),
                  ),
                  _SidebarTile(
                    icon: Icons.grid_view_rounded,
                    activeIcon: Icons.grid_view_rounded,
                    label: 'Products',
                    route: Routes.products,
                    onTap: () => Get.offAllNamed(Routes.products),
                  ),
                  _SidebarTile(
                    icon: Icons.search_rounded,
                    activeIcon: Icons.search_rounded,
                    label: 'Search',
                    route: Routes.search,
                    onTap: () => Get.toNamed(Routes.search),
                  ),
                  _SidebarTile(
                    icon: Icons.shopping_bag_outlined,
                    activeIcon: Icons.shopping_bag_rounded,
                    label: 'Cart',
                    route: Routes.cart,
                    onTap: () => Get.toNamed(Routes.cart),
                  ),
                  const SizedBox(height: 8),
                  _sectionLabel('ACCOUNT'),
                  _SidebarTile(
                    icon: Icons.dashboard_outlined,
                    activeIcon: Icons.dashboard_rounded,
                    label: 'Dashboard',
                    route: Routes.dashboard,
                    onTap: () => Get.offAllNamed(Routes.dashboard),
                  ),
                  if (userService != null)
                    Obx(() {
                      final user = userService.currentUser.value;
                      if (user == null || !user.isAdmin) {
                        return const SizedBox.shrink();
                      }
                      return _SidebarTile(
                        icon: Icons.admin_panel_settings_outlined,
                        activeIcon: Icons.admin_panel_settings_rounded,
                        label: 'Admin',
                        route: Routes.admin,
                        onTap: () => Get.offAllNamed(Routes.admin),
                      );
                    }),
                ],
              ),
            ),
            _buildAuthAction(userService),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.4,
          color: _muted,
        ),
      ),
    );
  }

  Widget _buildHeader(UserService? userService) {
    Widget content({
      required String name,
      required String subtitle,
      required String initial,
      required bool isLoggedIn,
      String? role,
    }) {
      return Container(
        margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _ink,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isLoggedIn ? _accent : Colors.white12,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: isLoggedIn
                      ? Text(
                          initial,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(
                          Icons.person_outline,
                          size: 28,
                          color: Colors.white70,
                        ),
                ),
                const Spacer(),
                if (role != null && role.isNotEmpty)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      role.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                        color: Colors.white70,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white60,
              ),
            ),
            if (!isLoggedIn) ...[
              const SizedBox(height: 14),
              GestureDetector(
                onTap: () => Get.toNamed(Routes.authentication),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _accent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Sign In / Register',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.indigo,
                  ),
                );
              }
            })
          else
            UserAccountsDrawerHeader(
              accountName: const Text('Guest User'),
              accountEmail: const Text('Tap to sign in'),
              onDetailsPressed: () {
                Get.toNamed(Routes.AUTHENTICATION);
              },
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person_outline,
                  size: 36,
                  color: Colors.indigo,
                ),
              ),
              decoration: const BoxDecoration(
                color: Colors.indigo,
              ),
            ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            selected: Get.currentRoute == Routes.HOME,
            onTap: () {
              Get.offAllNamed(Routes.HOME);
            },
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            selected: Get.currentRoute == Routes.DASHBOARD,
            onTap: () {
              Get.offAllNamed(Routes.DASHBOARD);
            },
          ),
          ListTile(
            leading: const Icon(Icons.inventory_2),
            title: const Text('Products'),
            selected: Get.currentRoute == Routes.PRODUCTS,
            onTap: () {
              Get.offAllNamed(Routes.PRODUCTS);
            },
          ),
          if (userService != null)
            Obx(() {
              final user = userService.currentUser.value;
              if (user == null || !user.isAdmin) return const SizedBox.shrink();
              return ListTile(
                leading: const Icon(Icons.admin_panel_settings),
                title: const Text('Admin'),
                selected: Get.currentRoute == Routes.ADMIN,
                onTap: () {
                  Get.offAllNamed(Routes.ADMIN);
                },
              );
            })
          else
            const SizedBox.shrink(),
          const Divider(),
          // Language switcher
          if (Get.isRegistered<LanguageController>())
            Obx(() {
              final langController = Get.find<LanguageController>();
              final isEn = langController.isEnglish;
              return ListTile(
                leading: const Icon(Icons.language),
                title: Text('SIDEBAR_LANGUAGE'.tr),
                trailing: Text(
                  isEn ? 'EN' : 'KH',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.indigo,
                  ),
                ),
                onTap: () {
                  langController.changeLanguage(
                    isEn ? 'km_KH' : 'en_US',
                  );
                },
              );
            })
          else
            const SizedBox.shrink(),
          const Divider(),
          if (userService != null)
            Obx(() {
              final user = userService.currentUser.value;
              final isLoggedIn = userService.isLoggedIn && user != null;
              if (isLoggedIn) {
                return ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    userService.clear();
                    Get.offAllNamed(Routes.HOME);
                  },
                );
              } else {
                return ListTile(
                  leading: const Icon(Icons.login),
                  title: const Text('Sign In / Register'),
                  onTap: () {
                    Get.toNamed(Routes.AUTHENTICATION);
                  },
                );
              }
            })
          else
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Sign In / Register'),
              onTap: () {
                Get.toNamed(Routes.AUTHENTICATION);
              },
            ),
        ],
      ),
    );
  }
}
