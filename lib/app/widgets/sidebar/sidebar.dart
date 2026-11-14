import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/services/user_service.dart';
import '../../routes/app_pages.dart';
import '../../theme/app_theme.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

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
      width: 316,
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(28)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 20, 18, 18),
              child: _buildBrand(),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(14, 16, 14, 20),
                children: [
                  _buildAccount(userService),
                  const SizedBox(height: 24),
                  const _SectionLabel('Shop'),
                  const SizedBox(height: 8),
                  const _NavigationTile(
                    icon: Icons.home_outlined,
                    selectedIcon: Icons.home_rounded,
                    title: 'Home',
                    route: Routes.HOME,
                  ),
                  const _NavigationTile(
                    icon: Icons.grid_view_outlined,
                    selectedIcon: Icons.grid_view_rounded,
                    title: 'Categories',
                    route: Routes.CATEGORIES,
                  ),
                  const _NavigationTile(
                    icon: Icons.devices_other_outlined,
                    selectedIcon: Icons.devices_other_rounded,
                    title: 'All products',
                    route: Routes.PRODUCTS,
                  ),
                  const _NavigationTile(
                    icon: Icons.search_rounded,
                    selectedIcon: Icons.manage_search_rounded,
                    title: 'Search',
                    route: Routes.SEARCH,
                  ),
                  const SizedBox(height: 18),
                  const _SectionLabel('My account'),
                  const SizedBox(height: 8),
                  const _NavigationTile(
                    icon: Icons.favorite_border_rounded,
                    selectedIcon: Icons.favorite_rounded,
                    title: 'Wishlist',
                    route: Routes.WISHLIST,
                  ),
                  const _NavigationTile(
                    icon: Icons.shopping_bag_outlined,
                    selectedIcon: Icons.shopping_bag_rounded,
                    title: 'Shopping bag',
                    route: Routes.CART,
                  ),
                  const _NavigationTile(
                    icon: Icons.person_outline_rounded,
                    selectedIcon: Icons.person_rounded,
                    title: 'Profile',
                    route: Routes.PROFILE,
                  ),
                  const SizedBox(height: 18),
                  const _SectionLabel('Workspace'),
                  const SizedBox(height: 8),
                  const _NavigationTile(
                    icon: Icons.space_dashboard_outlined,
                    selectedIcon: Icons.space_dashboard_rounded,
                    title: 'Dashboard',
                    route: Routes.DASHBOARD,
                  ),
                  if (userService != null)
                    Obx(() {
                      final user = userService.currentUser.value;
                      if (user == null || !user.isAdmin) {
                        return const SizedBox.shrink();
                      }
                      return const _NavigationTile(
                        icon: Icons.admin_panel_settings_outlined,
                        selectedIcon: Icons.admin_panel_settings_rounded,
                        title: 'Store management',
                        route: Routes.ADMIN,
                      );
                    }),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: _buildSessionAction(userService),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrand() {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.memory_rounded,
            color: Colors.white,
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ECOM',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.8,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 1),
              Text(
                'Premium digital store',
                style: TextStyle(
                  fontSize: 11.5,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'STORE',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccount(UserService? userService) {
    if (userService == null) return _guestAccount();

    return Obx(() {
      final user = userService.currentUser.value;
      if (!userService.isLoggedIn || user == null) return _guestAccount();

      final name = user.fullName.isNotEmpty ? user.fullName : user.email;
      return _AccountCard(
        name: name.isNotEmpty ? name : 'Ecom User',
        detail: user.email,
        initial: name.isNotEmpty ? name[0].toUpperCase() : 'U',
        badge: user.role.isNotEmpty ? user.role : 'Member',
        onTap: () => Get.toNamed(Routes.PROFILE),
      );
    });
  }

  Widget _guestAccount() {
    return _AccountCard(
      name: 'Welcome to ECOM',
      detail: 'Sign in for orders and saved items',
      initial: 'E',
      badge: 'Guest',
      onTap: () => Get.toNamed(Routes.AUTHENTICATION),
    );
  }

  Widget _buildSessionAction(UserService? userService) {
    if (userService == null) {
      return _SessionButton(
        icon: Icons.login_rounded,
        label: 'Sign in or register',
        onTap: () => Get.toNamed(Routes.AUTHENTICATION),
      );
    }

    return Obx(() {
      final isLoggedIn =
          userService.isLoggedIn && userService.currentUser.value != null;
      return _SessionButton(
        icon: isLoggedIn ? Icons.logout_rounded : Icons.login_rounded,
        label: isLoggedIn ? 'Log out' : 'Sign in or register',
        onTap: () {
          if (isLoggedIn) {
            userService.clear();
            Get.offAllNamed(Routes.HOME);
          } else {
            Get.toNamed(Routes.AUTHENTICATION);
          }
        },
      );
    });
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({
    required this.name,
    required this.detail,
    required this.initial,
    required this.badge,
    required this.onTap,
  });

  final String name;
  final String detail;
  final String initial;
  final String badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.14),
                  ),
                ),
                child: Text(
                  initial,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            badge.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 8,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      detail,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: Colors.white70,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationTile extends StatelessWidget {
  const _NavigationTile({
    required this.icon,
    required this.selectedIcon,
    required this.title,
    required this.route,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String title;
  final String route;

  @override
  Widget build(BuildContext context) {
    final selected = Get.currentRoute == route;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: selected ? AppColors.surfaceMuted : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            if (selected) {
              Get.back();
            } else {
              Get.offAllNamed(route);
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: selected
                  ? Border.all(color: AppColors.border)
                  : Border.all(color: Colors.transparent),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(
                    selected ? selectedIcon : icon,
                    size: 19,
                    color: selected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13.5,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
                if (selected)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SessionButton extends StatelessWidget {
  const _SessionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        backgroundColor: AppColors.surfaceMuted,
        side: BorderSide.none,
      ),
    );
  }
}
