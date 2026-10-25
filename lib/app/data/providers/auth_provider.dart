import 'package:get/get.dart';

import '../../config/app_config.dart';
import '../models/user_model.dart';
import 'api_provider.dart';

class AuthProvider {
  final ApiProvider _api = Get.find<ApiProvider>();

  /// GET /api/auth/me
  ///
  /// Fetches the currently authenticated user's profile.
  Future<UserModel> getCurrentUser() async {
    final response = await _api.get<dynamic>(AppConfig.me);
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final json = (data['data'] is Map<String, dynamic>)
          ? data['data'] as Map<String, dynamic>
          : data;
      return UserModel.fromJson(json);
    }
    throw Exception('Invalid user data received from ${AppConfig.me}');
  }
}
