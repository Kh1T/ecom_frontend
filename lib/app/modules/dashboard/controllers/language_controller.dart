import 'dart:ui';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  static const String _langKey = 'selected_language';

  // Observable current locale code: 'en_US' or 'km_KH'
  final currentLanguage = 'en_US'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedLanguage();
  }

  /// Load the persisted language from SharedPreferences on startup.
  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_langKey);
    if (saved != null && saved.isNotEmpty) {
      currentLanguage.value = saved;
      _applyLocale(saved);
    }
  }

  /// Switch between English and Khmer and persist the choice.
  Future<void> changeLanguage(String langCode) async {
    if (langCode == currentLanguage.value) return;
    currentLanguage.value = langCode;
    _applyLocale(langCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_langKey, langCode);
  }

  void _applyLocale(String langCode) {
    final parts = langCode.split('_');
    final locale = Locale(parts[0], parts.length > 1 ? parts[1] : '');
    Get.updateLocale(locale);
  }

  /// Convenience getters
  bool get isEnglish => currentLanguage.value == 'en_US';
  bool get isKhmer => currentLanguage.value == 'km_KH';
}
