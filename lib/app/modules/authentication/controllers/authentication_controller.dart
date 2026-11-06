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
  static const String dummyEmail = 'testuser@gmail.com';
  static const String dummyPassword = '123';

  final isLoading = false.obs;

  ApiProvider get _api => Get.find<ApiProvider>();
  StorageService get _storage => Get.find<StorageService>();

  /// Bearer token returned by the backend after a successful sign-in/up.
  String? get token => _storage.token;

  // Form controllers so the view can bind directly to this controller.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  final isPasswordHidden = true.obs;
  final isSignUp = false.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleAuthMode() {
    isSignUp.value = !isSignUp.value;
  }

  void fillDummyUser() {
    emailController.text = dummyEmail;
    passwordController.text = dummyPassword;
    if (isSignUp.value && nameController.text.isEmpty) {
      nameController.text = 'Test User';
    }
  }

  void signInWithFacebook() {
    Get.snackbar(
      'Facebook Sign In',
      'Facebook authentication will be connected soon.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void signInWithGoogle() {
    Get.snackbar(
      'Google Sign In',
      'Google authentication will be connected soon.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void forgotPassword() {
    final resetEmailController = TextEditingController(text: emailController.text);
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Reset Password',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter your email address and we will send you instructions to reset your password.',
              style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: resetEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Email',
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Color(0xFFE5E7EB), width: 1.2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.black, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  final email = resetEmailController.text.trim();
                  if (email.isEmpty) {
                    Get.snackbar(
                      'Error',
                      'Please enter your email address.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }
                  Get.back();
                  Get.snackbar(
                    'Reset Link Sent',
                    'Password reset instructions have been sent to $email.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Send Reset Link',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Future<void> signUp({String? email, String? password, String? name}) async {
    final e = email ?? emailController.text.trim();
    final p = password ?? passwordController.text;
    final n = name ?? nameController.text.trim();

    if (e.isEmpty || p.isEmpty) {
      _showError('Email and password are required.');
      return;
    }

    // Handle dummy user sign up
    if (e.toLowerCase() == dummyEmail.toLowerCase()) {
      isLoading.value = true;
      await Future.delayed(const Duration(milliseconds: 300));
      final dummyUser = UserModel(
        id: 999,
        email: dummyEmail,
        firstName: n.isNotEmpty ? n.split(' ').first : 'Test',
        lastName: n.contains(' ') ? n.substring(n.indexOf(' ') + 1) : 'User',
        role: 'CUSTOMER',
      );
      _storage.token = 'dummy_token_testuser_123';
      _storage.user = dummyUser;
      if (Get.isRegistered<UserService>()) {
        Get.find<UserService>().currentUser.value = dummyUser;
      }
      isLoading.value = false;
      Get.snackbar('Success', 'Account created successfully as Test User');
      Get.offAllNamed<dynamic>(Routes.HOME);
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

    // Handle dummy user sign in
    if (e.toLowerCase() == dummyEmail.toLowerCase()) {
      if (p == dummyPassword) {
        isLoading.value = true;
        await Future.delayed(const Duration(milliseconds: 300));
        final dummyUser = UserModel(
          id: 999,
          email: dummyEmail,
          firstName: 'Test',
          lastName: 'User',
          role: 'CUSTOMER',
        );
        _storage.token = 'dummy_token_testuser_123';
        _storage.user = dummyUser;
        if (Get.isRegistered<UserService>()) {
          Get.find<UserService>().currentUser.value = dummyUser;
        }
        isLoading.value = false;
        Get.snackbar('Success', 'Signed in successfully as Test User');
        Get.offAllNamed<dynamic>(Routes.HOME);
        return;
      } else {
        _showError('Invalid password for test user.');
        return;
      }
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
