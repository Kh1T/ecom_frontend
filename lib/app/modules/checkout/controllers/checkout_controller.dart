import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../cart/controllers/cart_controller.dart';

class PaymentMethodOption {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;

  const PaymentMethodOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class CheckoutController extends GetxController {
  final CartController cart = Get.find<CartController>();

  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final postalCodeController = TextEditingController();
  final noteController = TextEditingController();

  final selectedPaymentId = 'cash'.obs;
  final isPlacingOrder = false.obs;

  final List<PaymentMethodOption> paymentMethods = const [
    PaymentMethodOption(
      id: 'cash',
      title: 'Cash on Delivery',
      subtitle: 'Pay in cash when your order arrives',
      icon: Icons.payments_outlined,
    ),
    PaymentMethodOption(
      id: 'card',
      title: 'Credit / Debit Card',
      subtitle: 'Visa, Mastercard, JCB',
      icon: Icons.credit_card,
    ),
    PaymentMethodOption(
      id: 'wallet',
      title: 'Mobile Wallet',
      subtitle: 'ABA Pay, Bakong and more',
      icon: Icons.account_balance_wallet_outlined,
    ),
  ];

  PaymentMethodOption get selectedPayment => paymentMethods
      .firstWhere((method) => method.id == selectedPaymentId.value);

  void selectPayment(String id) => selectedPaymentId.value = id;

  Future<void> placeOrder() async {
    if (cart.cartItems.isEmpty) {
      Get.snackbar('Cart is empty', 'Add some items before checking out.');
      return;
    }

    if (fullNameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty ||
        cityController.text.trim().isEmpty) {
      Get.snackbar(
        'Missing information',
        'Please complete your delivery address.',
      );
      return;
    }

    isPlacingOrder.value = true;
    await Future.delayed(const Duration(milliseconds: 800));
    await cart.clearCart();
    isPlacingOrder.value = false;

    Get.offAllNamed(Routes.ORDER_SUCCESS);
  }

  @override
  void onClose() {
    fullNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cityController.dispose();
    postalCodeController.dispose();
    noteController.dispose();
    super.onClose();
  }
}
