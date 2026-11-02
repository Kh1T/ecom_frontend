import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../data/services/user_service.dart';
import '../../routes/app_pages.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

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
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          if (userService != null)
            Obx(() {
              final user = userService.currentUser.value;
              final isLoggedIn = userService.isLoggedIn && user != null;

              if (isLoggedIn) {
                final name = user.fullName.isNotEmpty
                    ? user.fullName
                    : (user.email.isNotEmpty ? user.email : 'Ecom User');
                final email = user.email.isNotEmpty ? user.email : 'user@example.com';
                final role = user.role;

                return UserAccountsDrawerHeader(
                  accountName: Text(name),
                  accountEmail: Text(
                    role.isNotEmpty ? '$email • $role' : email,
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : 'U',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.indigo,
                  ),
                );
              } else {
                return UserAccountsDrawerHeader(
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
          if (userService != null)
            Obx(() {
              final isLoggedIn =
                  userService.isLoggedIn && userService.currentUser.value != null;
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
