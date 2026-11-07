import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class OrderSuccessView extends StatelessWidget {
  const OrderSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 3),
              _buildIllustration(),
              const SizedBox(height: 40),
              const Text(
                'Order Successful!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'You have successfully made order',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF9CA3AF),
                  height: 1.4,
                ),
              ),
              const Spacer(flex: 4),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => Get.offAllNamed(Routes.HOME),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Continue Shopping',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return SizedBox(
      width: 240,
      height: 210,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 64),
          ),
          _dot(const Alignment(-0.72, -0.52), 9),
          _dot(const Alignment(0.60, -0.66), 13),
          _dot(const Alignment(0.84, -0.14), 9),
          _dot(const Alignment(-0.86, 0.16), 8),
          _dot(const Alignment(-0.56, 0.66), 9),
          _dot(const Alignment(-0.10, 0.82), 7),
          _dot(const Alignment(0.50, 0.70), 10),
          _dot(const Alignment(0.80, 0.40), 7),
        ],
      ),
    );
  }

  Widget _dot(Alignment alignment, double size) {
    return Align(
      alignment: alignment,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
