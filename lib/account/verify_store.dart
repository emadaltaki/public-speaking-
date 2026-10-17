import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'auth_service.dart';
import 'auth_storage.dart';
import 'progress_store.dart';

/// Whether the signed-in visitor has confirmed their email.
///
/// Google sign-ins come verified. Email sign-ups confirm a 6-digit code on
/// the sign-in page, which the backend records (`emailVerified` on
/// `GET /v1/me`). When the API can't be reached, or codes aren't switched on
/// yet, visitors are let through rather than locked out.
class VerifyStore {
  VerifyStore._();

  /// null while checking.
  static final ValueNotifier<bool?> verified = ValueNotifier(null);

  static http.Client client = http.Client();

  static String? _checkedUid;

  static bool _storedFlag() {
    final raw = readStoredUser(
      'firebase:authUser:${AuthService.apiKey}:[DEFAULT]',
    );
    if (raw == null) return false;
    try {
      return (jsonDecode(raw) as Map<String, dynamic>)['emailVerified'] == true;
    } catch (_) {
      return false;
    }
  }

  /// Checks once per signed-in account (call again with [force] to recheck).
  static Future<void> check({bool force = false}) async {
    final user = AuthService.user.value;
    if (user == null) {
      verified.value = null;
      _checkedUid = null;
      return;
    }
    if (!force && _checkedUid == user.uid && verified.value != null) return;
    _checkedUid = user.uid;
    if (_storedFlag() ||
        readLocal('speakupfearless.verifySkip.${user.uid}') == '1') {
      verified.value = true;
      return;
    }
    final token = await AuthService.idToken(client: client);
    if (token == null) {
      verified.value = true;
      return;
    }
    try {
      final response = await client
          .get(
            Uri.parse('${ProgressStore.apiBaseUrl}/v1/me'),
            headers: {'Authorization': 'Bearer $token'},
          )
          .timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) {
        verified.value = true;
        return;
      }
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      verified.value = body['emailVerified'] != false;
    } catch (_) {
      verified.value = true;
    }
  }
}
