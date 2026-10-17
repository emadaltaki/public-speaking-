import 'package:web/web.dart' as web;

String? readStoredUser(String key) => readLocal(key);

void writeStoredUser(String key, String value) => writeLocal(key, value);

void clearStoredUser(String key) {
  try {
    web.window.localStorage.removeItem(key);
  } catch (_) {}
}

String? readLocal(String key) {
  try {
    return web.window.localStorage.getItem(key);
  } catch (_) {
    return null;
  }
}

void writeLocal(String key, String value) {
  try {
    web.window.localStorage.setItem(key, value);
  } catch (_) {}
}

/// Opens a page of this site outside the Flutter app (the sign-in page).
void openSitePage(String path) {
  web.window.location.assign(path);
}
