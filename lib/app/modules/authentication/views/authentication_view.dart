import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/authentication_controller.dart';

class AuthenticationView extends GetView<AuthenticationController> {
  const AuthenticationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(
          () => SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (Navigator.canPop(context)) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 20,
                        color: Colors.black,
                      ),
                      onPressed: () => Get.back(),
                    ),
                  ),
                  const SizedBox(height: 16),
                ] else
                  const SizedBox(height: 16),

                // Header Title
                Text(
                  controller.isSignUp.value ? 'Create account' : 'Welcome back!',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    letterSpacing: -0.5,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  controller.isSignUp.value ? 'Sign Up' : 'Sign In',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    letterSpacing: -0.5,
                    height: 1.15,
                  ),
                ),

                const SizedBox(height: 36),

                // Name field (Sign Up only)
                if (controller.isSignUp.value) ...[
                  _buildTextField(
                    controller: controller.nameController,
                    hintText: 'Full Name',
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                ],

                // Email field
                _buildTextField(
                  controller: controller.emailController,
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),

                const SizedBox(height: 16),

                // Password field
                _buildTextField(
                  controller: controller.passwordController,
                  hintText: 'Password',
                  obscureText: controller.isPasswordHidden.value,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) {
                    if (controller.isSignUp.value) {
                      controller.signUp();
                    } else {
                      controller.signIn();
                    }
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordHidden.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: const Color(0xFF6B7280),
                      size: 22,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                ),

                // Forget Password?
                if (!controller.isSignUp.value) ...[
                  const SizedBox(height: 14),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: controller.forgotPassword,
                      child: const Text(
                        'Forget Password?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 28),

                // Sign In / Sign Up Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                            if (controller.isSignUp.value) {
                              controller.signUp();
                            } else {
                              controller.signIn();
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.black54,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            controller.isSignUp.value ? 'Sign Up' : 'Sign In',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 28),

                // OR Divider
                const Row(
                  children: [
                    Expanded(
                      child: Divider(color: Color(0xFFE5E7EB), thickness: 1),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: Color(0xFFE5E7EB), thickness: 1),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // Continue with facebook Button
                _buildSocialButton(
                  icon: Image.asset(
                    'assets/images/facebook_logo.png',
                    width: 22,
                    height: 22,
                  ),
                  text: 'Continue with facebook',
                  onTap: controller.signInWithFacebook,
                ),

                const SizedBox(height: 14),

                // Continue with Google Button
                _buildSocialButton(
                  icon: Image.asset(
                    'assets/images/google_logo.png',
                    width: 20,
                    height: 20,
                  ),
                  text: 'Continue with Google',
                  onTap: controller.signInWithGoogle,
                ),

                const SizedBox(height: 20),

                // Quick Demo Account Pill
                Center(
                  child: InkWell(
                    onTap: controller.fillDummyUser,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFE5E7EB),
                          width: 1,
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.key_outlined,
                            size: 14,
                            color: Color(0xFF6B7280),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Quick fill: testuser@gmail.com',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF4B5563),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Switch between Sign In and Sign Up
                Center(
                  child: GestureDetector(
                    onTap: controller.toggleAuthMode,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: RichText(
                        text: TextSpan(
                          text: controller.isSignUp.value
                              ? 'Already have an account ? '
                              : 'Don’t have an account ? ',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF9CA3AF),
                          ),
                          children: [
                            TextSpan(
                              text: controller.isSignUp.value ? 'Sign In' : 'Sign Up',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
    bool obscureText = false,
    Widget? suffixIcon,
    void Function(String)? onSubmitted,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      onSubmitted: onSubmitted,
      style: const TextStyle(
        fontSize: 15,
        color: Colors.black,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFF9CA3AF),
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black, width: 1.4),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required Widget icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFFE5E7EB), width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 14),
            Text(
              text,
              style: const TextStyle(
                color: Color(0xFF374151),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
