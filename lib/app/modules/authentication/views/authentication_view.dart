import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/authentication_controller.dart';

class AuthenticationView extends GetView<AuthenticationController> {
  const AuthenticationView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Authentication'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Sign In'),
              Tab(text: 'Sign Up'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildSignInTab(context),
            _buildSignUpTab(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSignInTab(BuildContext context) {
    return _AuthForm(
      submitLabel: 'Sign In',
      onSubmit: controller.signIn,
      emailController: controller.emailController,
      passwordController: controller.passwordController,
      isLoading: controller.isLoading,
    );
  }

  Widget _buildSignUpTab(BuildContext context) {
    return _AuthForm(
      submitLabel: 'Sign Up',
      onSubmit: () => controller.signUp(),
      emailController: controller.emailController,
      passwordController: controller.passwordController,
      nameController: controller.nameController,
      isLoading: controller.isLoading,
    );
  }
}

class _AuthForm extends StatelessWidget {
  const _AuthForm({
    required this.submitLabel,
    required this.onSubmit,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    this.nameController,
  });

  final String submitLabel;
  final VoidCallback onSubmit;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController? nameController;
  final RxBool isLoading;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (nameController != null) ...[
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
          ],
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(),
            ),
            obscureText: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => onSubmit(),
          ),
          const SizedBox(height: 24),
          Obx(
            () => ElevatedButton(
              onPressed: isLoading.value ? null : onSubmit,
              child: isLoading.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(submitLabel),
            ),
          ),
        ],
      ),
    );
  }
}
