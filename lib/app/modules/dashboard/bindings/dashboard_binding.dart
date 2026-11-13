import 'package:get/get.dart';

import '../controllers/dashboard_controller.dart';
import '../controllers/language_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(
      () => DashboardController(),
    );
    // Persist the LanguageController so the locale survives navigation
    if (!Get.isRegistered<LanguageController>()) {
      Get.put<LanguageController>(LanguageController(), permanent: true);
    }
  }
}
