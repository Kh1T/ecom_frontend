import 'package:get/get.dart';

import 'data/providers/api_provider.dart';
import 'data/services/location_service.dart';
import 'data/services/storage_service.dart';
import 'data/services/user_service.dart';

class DependencyInjection {
  static Future<void> init() async {
    final storage = await StorageService.init();
    Get.put<StorageService>(storage, permanent: true);
    Get.put<ApiProvider>(
      ApiProvider(Get.find<StorageService>()),
      permanent: true,
    );
    Get.put<LocationService>(LocationService(), permanent: true);
    Get.put<UserService>(UserService(), permanent: true);
  }
}
