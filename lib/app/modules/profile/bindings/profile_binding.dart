import 'package:get/get.dart';

import '../../../data/services/user_service.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    // UserService is already permanent — no need to re-register.
    // This binding exists so the route has a proper lifecycle owner.
    if (!Get.isRegistered<UserService>()) {
      Get.lazyPut<UserService>(() => UserService());
    }
  }
}