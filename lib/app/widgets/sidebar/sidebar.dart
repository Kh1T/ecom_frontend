import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../data/services/user_service.dart';
import '../../routes/app_pages.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  static const _ink = Color(0xFF1C1C1E);
  static const _accent = Color(0xFFEE5D26);
  static const _muted = Color(0xFF9E9EA4);
  static const _line = Color(0xFFE2E2E6);

  @override
  Widget build(BuildContext context) {
    final userService =
        Get.isRegistered<UserService>() ? Get.find<UserService>() : null;

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
                    route: Routes.HOME,
                    onTap: () => Get.offAllNamed(Routes.HOME),
                  ),
                  _SidebarTile(
                    icon: Icons.grid_view_rounded,
                    activeIcon: Icons.grid_view_rounded,
                    label: 'Products',
                    route: Routes.PRODUCTS,
                    onTap: () => Get.offAllNamed(Routes.PRODUCTS),
                  ),
                  _SidebarTile(
                    icon: Icons.search_rounded,
                    activeIcon: Icons.search_rounded,
                    label: 'Search',
                    route: Routes.SEARCH,
                    onTap: () => Get.toNamed(Routes.SEARCH),
                  ),
                  _SidebarTile(
                    icon: Icons.shopping_bag_outlined,
                    activeIcon: Icons.shopping_bag_rounded,
                    label: 'Cart',
                    route: Routes.CART,
                    onTap: () => Get.toNamed(Routes.CART),
                  ),
                  const SizedBox(height: 8),
                  _sectionLabel('ACCOUNT'),
                  _SidebarTile(
                    icon: Icons.dashboard_outlined,
                    activeIcon: Icons.dashboard_rounded,
                    label: 'Dashboard',
                    route: Routes.DASHBOARD,
                    onTap: () => Get.offAllNamed(Routes.DASHBOARD),
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
                        route: Routes.ADMIN,
                        onTap: () => Get.offAllNamed(Routes.ADMIN),
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
                onTap: () => Get.toNamed(Routes.AUTHENTICATION),
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
                ),
              ),
            ],
          ],
        ),
      );
    }

    if (userService == null) {
      return content(
        name: 'Guest User',
        subtitle: 'Tap to sign in',
        initial: 'G',
        isLoggedIn: false,
      );
    }

    return Obx(() {
      final user = userService.currentUser.value;
      final isLoggedIn = userService.isLoggedIn && user != null;

      if (!isLoggedIn) {
        return content(
          name: 'Guest User',
          subtitle: 'Sign in to sync your cart',
          initial: 'G',
          isLoggedIn: false,
        );
      }

      final name = user.fullName.isNotEmpty
          ? user.fullName
          : (user.email.isNotEmpty ? user.email : 'Ecom User');
      final email = user.email.isNotEmpty ? user.email : 'user@example.com';

      return content(
        name: name,
        subtitle: email,
        initial: name.isNotEmpty ? name[0].toUpperCase() : 'U',
        isLoggedIn: true,
        role: user.role,
      );
    });
  }

  Widget _buildAuthAction(UserService? userService) {
    if (userService == null) {
      return _authTile(
        icon: Icons.login_rounded,
        label: 'Sign In / Register',
        color: _ink,
        onTap: () => Get.toNamed(Routes.AUTHENTICATION),
      );
    }

    return Obx(() {
      final isLoggedIn =
          userService.isLoggedIn && userService.currentUser.value != null;
      if (!isLoggedIn) {
        return _authTile(
          icon: Icons.login_rounded,
          label: 'Sign In / Register',
          color: _ink,
          onTap: () => Get.toNamed(Routes.AUTHENTICATION),
        );
      }
      return _authTile(
        icon: Icons.logout_rounded,
        label: 'Logout',
        color: _accent,
        onTap: () {
          userService.clear();
          Get.offAllNamed(Routes.HOME);
        },
      );
    });
  }

  Widget _authTile({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _line, width: 1),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SidebarTile extends StatelessWidget {
  const _SidebarTile({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isActive = Get.currentRoute == route;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: isActive ? Sidebar._ink : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                isActive ? activeIcon : icon,
                size: 21,
                color: isActive ? Colors.white : Sidebar._ink,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive ? Colors.white : Sidebar._ink,
                  ),
                ),
              ),
              if (isActive)
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Sidebar._accent,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
