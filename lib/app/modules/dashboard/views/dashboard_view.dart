import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../widgets/sidebar/sidebar.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/language_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    final langController = Get.find<LanguageController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('DASHBOARD_TITLE'.tr),
        centerTitle: true,
        actions: [
          // Language switcher button
          Obx(() {
            final isEn = langController.isEnglish;
            return PopupMenuButton<String>(
              icon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.language, size: 22),
                  const SizedBox(width: 4),
                  Text(
                    isEn ? 'EN' : 'KH',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              tooltip: 'DASHBOARD_LANGUAGE'.tr,
              onSelected: (value) {
                langController.changeLanguage(value);
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'en_US',
                  child: Row(
                    children: [
                      Icon(
                        Icons.check,
                        size: 18,
                        color: isEn ? Colors.indigo : Colors.transparent,
                      ),
                      const SizedBox(width: 8),
                      Text('DASHBOARD_ENGLISH'.tr),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'km_KH',
                  child: Row(
                    children: [
                      Icon(
                        Icons.check,
                        size: 18,
                        color: !isEn ? Colors.indigo : Colors.transparent,
                      ),
                      const SizedBox(width: 8),
                      Text('DASHBOARD_KHMER'.tr),
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
      drawer: const Sidebar(),
      body: Center(
        child: Text(
          'DASHBOARD_IS_WORKING'.tr,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
