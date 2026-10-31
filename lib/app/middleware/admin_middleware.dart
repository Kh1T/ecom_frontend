import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/services/user_service.dart';
import '../routes/app_pages.dart';

/// Redirects non-admin users away from admin routes.
class AdminMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (!Get.isRegistered<UserService>()) {
      return const RouteSettings(name: Routes.AUTHENTICATION);
    }

    final userService = Get.find<UserService>();
    final user = userService.currentUser.value;

    if (!userService.isLoggedIn || user == null || !user.isAdmin) {
      return const RouteSettings(name: Routes.HOME);
    }

    return null;
  }
}
