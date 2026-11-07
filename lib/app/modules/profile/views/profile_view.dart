import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/services/user_service.dart';
import '../../../routes/app_pages.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  static const Color _muted = Color(0xFF9CA3AF);
  static const Color _border = Color(0xFFE5E7EB);
  static const Color _fieldBg = Color(0xFFF9FAFB);

  UserService? get _userService =>
      Get.isRegistered<UserService>() ? Get.find<UserService>() : null;

  @override
  Widget build(BuildContext context) {
    final userService = _userService;

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
                    'Profile',
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
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  if (userService != null)
                    Obx(() => _buildProfileHeader(userService))
                  else
                    _buildProfileHeader(null),
                  const SizedBox(height: 24),
                  _buildMenu(),
                  const SizedBox(height: 24),
                  if (userService == null || !userService.isLoggedIn)
                    _buildSignInButton()
                  else
                    _buildLogoutButton(userService),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(UserService? userService) {
    final user = userService?.currentUser.value;
    final isLoggedIn = userService != null && user != null;
    final name = isLoggedIn
        ? (user.fullName.isNotEmpty ? user.fullName : user.email)
        : 'Guest User';
    final subtitle = isLoggedIn
        ? user.email
        : 'Sign in to manage your account';

    return Column(
      children: [
        ClipOval(
          child: Image.asset(
            'assets/images/avatar.png',
            width: 88,
            height: 88,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 88,
              height: 88,
              color: _fieldBg,
              child: const Icon(Icons.person, size: 44, color: Colors.black38),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: _muted),
        ),
      ],
    );
  }

  Widget _buildMenu() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          _MenuTile(
            icon: Icons.receipt_long_outlined,
            title: 'My Orders',
            onTap: () => _notImplemented('My Orders'),
          ),
          const _MenuDivider(),
          _MenuTile(
            icon: Icons.favorite_border_rounded,
            title: 'Wishlist',
            onTap: () => Get.toNamed(Routes.WISHLIST),
          ),
          const _MenuDivider(),
          _MenuTile(
            icon: Icons.location_on_outlined,
            title: 'Delivery Address',
            onTap: () => _notImplemented('Delivery Address'),
          ),
          const _MenuDivider(),
          _MenuTile(
            icon: Icons.credit_card_outlined,
            title: 'Payment Methods',
            onTap: () => _notImplemented('Payment Methods'),
          ),
          const _MenuDivider(),
          _MenuTile(
            icon: Icons.settings_outlined,
            title: 'Settings',
            onTap: () => _notImplemented('Settings'),
          ),
          const _MenuDivider(),
          _MenuTile(
            icon: Icons.help_outline_rounded,
            title: 'Help & Support',
            onTap: () => _notImplemented('Help & Support'),
          ),
        ],
      ),
    );
  }

  Widget _buildSignInButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: () => Get.toNamed(Routes.AUTHENTICATION),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text(
          'Sign In',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(UserService userService) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton.icon(
        onPressed: () {
          userService.clear();
          Get.offAllNamed(Routes.HOME);
        },
        icon: const Icon(Icons.logout, size: 20, color: Colors.red),
        label: const Text(
          'Log Out',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.red,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: _border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  void _notImplemented(String label) {
    Get.snackbar(
      label,
      'This section is coming soon.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 20, color: Colors.black87),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 15,
              color: ProfileView._muted,
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuDivider extends StatelessWidget {
  const _MenuDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 70,
      color: Color(0xFFF1F1F3),
    );
  }
}
