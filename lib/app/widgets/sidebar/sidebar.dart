import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../routes/app_pages.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text('Ecom User'),
            accountEmail: Text('user@example.com'),
            currentAccountPicture: CircleAvatar(
              child: Icon(Icons.person),
            ),
            decoration: BoxDecoration(
              color: Colors.indigo,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Get.offAllNamed(Routes.HOME);
            },
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Get.offAllNamed(Routes.DASHBOARD);
            },
          ),
          ListTile(
            leading: const Icon(Icons.admin_panel_settings),
            title: const Text('Admin'),
            onTap: () {
              Get.offAllNamed(Routes.ADMIN);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Get.offAllNamed(Routes.AUTHENTICATION);
            },
          ),
        ],
      ),
    );
  }
}
