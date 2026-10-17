import 'package:web/web.dart' as web;

const _key = 'speakupfearless.language';

/// The language the visitor picked last time, if any.
String? loadSavedLanguage() {
  try {
    return web.window.localStorage.getItem(_key);
  } catch (_) {
    return null;
  }
}

void saveLanguage(String code) {
  try {
    web.window.localStorage.setItem(_key, code);
  } catch (_) {
    // Private browsing can block storage; the choice just won't persist.
  }
}

const _themeKey = 'speakupfearless.theme';

/// 'light' or 'dark' if the visitor picked one before.
String? loadSavedTheme() {
  try {
    return web.window.localStorage.getItem(_themeKey);
  } catch (_) {
    return null;
  }
}

void saveTheme(String value) {
  try {
    web.window.localStorage.setItem(_themeKey, value);
  } catch (_) {}
}
