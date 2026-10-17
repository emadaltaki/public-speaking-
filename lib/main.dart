import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'app.dart';
import 'translations/language_store.dart';
import 'translations/translations.dart';

void main() {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  // Use the language picked last time; otherwise follow the browser.
  final saved = loadSavedLanguage();
  final browserLanguage =
      WidgetsBinding.instance.platformDispatcher.locale.languageCode;
  Translations.language.value = saved == 'ar' || saved == 'en'
      ? saved!
      : (browserLanguage == 'ar' ? 'ar' : 'en');
  Translations.language.addListener(
    () => saveLanguage(Translations.language.value),
  );
  runApp(const SpeakUpFearlessApp());
}
