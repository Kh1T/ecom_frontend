import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/app_config.dart';
import '../../../data/models/user_model.dart';
import '../../../data/providers/api_provider.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/services/user_service.dart';
import '../../../routes/app_pages.dart';

class AuthenticationController extends GetxController {
  final isLoading = false.obs;

  ApiProvider get _api => Get.find<ApiProvider>();
  StorageService get _storage => Get.find<StorageService>();

  /// Bearer token returned by the backend after a successful sign-in/up.
  String? get token => _storage.token;

  // Form controllers so the view can bind directly to this controller.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  Future<void> signUp({String? email, String? password, String? name}) async {
    final e = email ?? emailController.text.trim();
    final p = password ?? passwordController.text;
    final n = name ?? nameController.text.trim();

    if (e.isEmpty || p.isEmpty) {
      _showError('Email and password are required.');
      return;
    }

    await _authenticate(
      path: AppConfig.signUp,
      body: {
        'email': e,
        'password': p,
        if (n.isNotEmpty) 'name': n,
      },
      successMessage: 'Account created successfully.',
    );
  }

  Future<void> signIn({String? email, String? password}) async {
    final e = email ?? emailController.text.trim();
    final p = password ?? passwordController.text;

    if (e.isEmpty || p.isEmpty) {
      _showError('Email and password are required.');
      return;
    }

    await _authenticate(
      path: AppConfig.signIn,
      body: {
        'email': e,
        'password': p,
      },
      successMessage: 'Signed in successfully.',
    );
  }

  Future<void> _authenticate({
    required String path,
    required Map<String, dynamic> body,
    required String successMessage,
  }) async {
    try {
      isLoading.value = true;
      final response = await _api.post<Map<String, dynamic>>(
        path,
        data: body,
      );

      final data = response.data;
      final token = _extractToken(data);
      UserModel? user;
      if (token != null) {
        _storage.token = token;
        debugPrint('Token stored: $token');
        if (Get.isRegistered<UserService>()) {
          user = await Get.find<UserService>().fetchCurrentUser();
        }
      } else {
        debugPrint('No token found in response: $data');
      }

      Get.snackbar('Success', successMessage);
      final destination =
          user != null && user.isAdmin ? Routes.ADMIN : Routes.HOME;
      Get.offAllNamed<dynamic>(destination);
    } on DioException catch (e) {
      _showError(_extractError(e));
    } catch (e) {
      _showError('An unexpected error occurred.');
    } finally {
      isLoading.value = false;
    }
  }

  String? _extractToken(dynamic data) {
    if (data == null) return null;
    if (data is! Map<String, dynamic>) return null;

    final tokenKeys = [
      'accessToken',
      'token',
      'access_token',
      'jwt',
      'jwtToken',
      'tokenValue',
      'id_token',
      'idToken',
      'bearerToken',
    ];

    // Check nested data first: { data: { token: ... } }
    final nested = data['data'] ?? data['result'] ?? data['response'];
    if (nested is Map<String, dynamic>) {
      for (final key in tokenKeys) {
        if (nested[key] != null) return nested[key].toString();
      }
    }

    // Check top level
    for (final key in tokenKeys) {
      if (data[key] != null) return data[key].toString();
    }

    return null;
  }

  String _extractError(DioException error) {
    final response = error.response;
    if (response?.data != null && response!.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      final message = data['message'] ?? data['error'];
      if (message != null) return message.toString();
    }
    return error.message ?? 'Request failed. Please try again.';
  }

  void _showError(String message) {
    Get.snackbar('Error', message, snackPosition: SnackPosition.BOTTOM);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.onClose();
  }
}
