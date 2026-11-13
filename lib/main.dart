import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/dependency_injection.dart';
import 'app/lang/translations.dart';
import 'app/modules/dashboard/controllers/language_controller.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await DependencyInjection.init();

  // Load the saved language preference before building the widget tree
  final prefs = await SharedPreferences.getInstance();
  final savedLang = prefs.getString('selected_language') ?? 'en_US';
  final parts = savedLang.split('_');
  final initialLocale = Locale(parts[0], parts.length > 1 ? parts[1] : '');

  // Register LanguageController globally so it's available everywhere
  final langController = LanguageController();
  Get.put<LanguageController>(langController, permanent: true);

  runApp(MyApp(initialLocale: initialLocale));
}

class MyApp extends StatelessWidget {
  final Locale initialLocale;
  const MyApp({super.key, required this.initialLocale});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      // GetX i18n
      translations: AppTranslations(),
      locale: initialLocale,
      fallbackLocale: const Locale('en', 'US'),
    );
  }
}
