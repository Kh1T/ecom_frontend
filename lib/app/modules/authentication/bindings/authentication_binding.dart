import 'package:get/get.dart';

import '../../../data/providers/api_provider.dart';
import '../../../data/services/storage_service.dart';
import '../controllers/authentication_controller.dart';

class AuthenticationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StorageService>(
      () => StorageService(),
    );
    Get.lazyPut<ApiProvider>(
      () => ApiProvider(Get.find<StorageService>()),
    );
    Get.lazyPut<AuthenticationController>(
      () => AuthenticationController(),
    );
  }
}
