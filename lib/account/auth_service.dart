import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'auth_storage.dart';

/// A signed-in visitor.
class AppUser {
  const AppUser({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
  });

  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;

  /// What to call the visitor: their name, else the start of their email.
  String get shortName {
    final name = displayName?.trim();
    if (name != null && name.isNotEmpty) return name.split(' ').first;
    final mail = email ?? '';
    return mail.contains('@') ? mail.split('@').first : mail;
  }

  String get initial => shortName.isEmpty ? '?' : shortName[0].toUpperCase();
}

/// Who is signed in, read from the Firebase session that the sign-in page
/// (`/login`) stores in the browser.
///
/// Sign-in itself happens on that separate page because Firebase's Google
/// pop-up can't run inside the app, which is cross-origin isolated for
/// faster rendering. The app reads the stored session, refreshes its ID
/// token through Firebase's token REST API, and sends that token to the
/// backend.
class AuthService {
  AuthService._();

  static const String apiKey = 'AIzaSyD61GC3xaetEqOwPYhYltxMp-FAsFLX6Ow';
  static const String _storageKey = 'firebase:authUser:$apiKey:[DEFAULT]';

  static final ValueNotifier<AppUser?> user = ValueNotifier(_load());

  static bool get signedIn => user.value != null;

  static Map<String, dynamic>? _raw() {
    final stored = readStoredUser(_storageKey);
    if (stored == null || stored.isEmpty) return null;
    try {
      return jsonDecode(stored) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static AppUser? _load() {
    final data = _raw();
    final uid = data?['uid'] as String?;
    if (data == null || uid == null) return null;
    return AppUser(
      uid: uid,
      email: data['email'] as String?,
      displayName: data['displayName'] as String?,
      photoUrl: data['photoURL'] as String?,
    );
  }

  /// Re-reads the stored session (e.g. after returning from `/login`).
  static void reload() => user.value = _load();

  /// Sends the visitor to the sign-in page, then back to [returnTo].
  static void signIn({String returnTo = '/', bool signUp = false}) {
    final next = Uri.encodeComponent(returnTo);
    openSitePage('/login?next=$next${signUp ? '&mode=signup' : ''}');
  }

  static void signOut() {
    clearStoredUser(_storageKey);
    user.value = null;
  }

  /// A valid Firebase ID token for calling the backend, or null when signed
  /// out. Expired tokens are refreshed and stored back.
  static Future<String?> idToken({http.Client? client}) async {
    final data = _raw();
    final manager = data?['stsTokenManager'] as Map<String, dynamic>?;
    if (data == null || manager == null) return null;
    final token = manager['accessToken'] as String?;
    final expires = manager['expirationTime'] as int? ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    if (token != null && expires - now > 60 * 1000) return token;

    final refresh = manager['refreshToken'] as String?;
    if (refresh == null) return null;
    try {
      final response = await (client ?? http.Client()).post(
        Uri.parse('https://securetoken.googleapis.com/v1/token?key=$apiKey'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'grant_type=refresh_token&refresh_token=$refresh',
      );
      if (response.statusCode != 200) return null;
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final fresh = body['id_token'] as String;
      final seconds = int.tryParse('${body['expires_in']}') ?? 3600;
      manager
        ..['accessToken'] = fresh
        ..['refreshToken'] = body['refresh_token'] ?? refresh
        ..['expirationTime'] = now + seconds * 1000;
      writeStoredUser(_storageKey, jsonEncode(data));
      return fresh;
    } catch (_) {
      return null;
    }
  }
}
