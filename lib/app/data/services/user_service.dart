import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';
import '../providers/auth_provider.dart';
import 'storage_service.dart';

class UserService extends GetxService {
  final AuthProvider _authProvider = AuthProvider();
  final StorageService _storage = Get.find<StorageService>();

  final currentUser = Rxn<UserModel>();
  final isLoading = false.obs;

  bool get isLoggedIn => _storage.token != null && _storage.token!.isNotEmpty;
  bool get isAdmin => currentUser.value?.isAdmin ?? false;

  @override
  void onInit() {
    super.onInit();
    if (isLoggedIn) {
      fetchCurrentUser();
    }
  }

  Future<UserModel?> fetchCurrentUser() async {
    if (!isLoggedIn) return null;
    try {
      isLoading.value = true;
      final user = await _authProvider.getCurrentUser();
      currentUser.value = user;
      _storage.user = user;
      debugPrint('Current user loaded: ${user.fullName} (${user.role})');
      return user;
    } catch (e) {
      debugPrint('Failed to fetch current user (/api/auth/me): $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  void clear() {
    currentUser.value = null;
    _storage.clearToken();
  }
}
