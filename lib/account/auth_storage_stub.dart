/// Outside the browser (tests), storage is kept in memory.
final Map<String, String> _memory = {};

String? readStoredUser(String key) => _memory[key];

void writeStoredUser(String key, String value) => _memory[key] = value;

void clearStoredUser(String key) => _memory.remove(key);

String? readLocal(String key) => _memory[key];

void writeLocal(String key, String value) => _memory[key] = value;

/// Opens a page of this site outside the Flutter app (the sign-in page).
void openSitePage(String path) {}

/// Photo picking only exists in the browser.
Future<String?> pickSquarePhoto({int size = 256}) async => null;
