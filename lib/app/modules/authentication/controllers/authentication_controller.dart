import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/providers/dio_provider.dart';
import '../../../routes/app_pages.dart';

class AuthenticationController extends GetxController {
  final isLoading = false.obs;

  /// Bearer token returned by the backend after a successful sign-in/up.
  /// In a real app you should persist this (e.g. with get_storage or
  /// shared_preferences) and attach it to outgoing requests.
  String? token;

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
      path: '/api/auth/sign-up',
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
      path: '/api/auth/sign-in',
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
      final response = await DioProvider.dio.post<Map<String, dynamic>>(
        path,
        data: body,
      );

      final data = response.data;
      if (data != null && data['token'] != null) {
        token = data['token'] as String?;
      }

      Get.snackbar('Success', successMessage);
      Get.offAllNamed<dynamic>(Routes.HOME);
    } on DioException catch (e) {
      _showError(_extractError(e));
    } catch (e) {
      _showError('An unexpected error occurred.');
    } finally {
      isLoading.value = false;
    }
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
