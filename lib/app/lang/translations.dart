import 'package:get/get.dart';

import 'en.dart';
import 'kh.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': en,
        'km_KH': kh,
      };
}
