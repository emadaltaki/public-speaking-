import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'auth_service.dart';
import 'auth_storage.dart';
import 'progress_store.dart';

/// The signed-in visitor's profile photo, as a small JPEG data URL.
///
/// It is saved with their account on the backend (`PATCH /v1/me`) and cached
/// in this browser so it shows straight away, even when the API is slow.
/// Visitors who signed in with Google fall back to their Google photo.
class AvatarStore {
  AvatarStore._();

  static final ValueNotifier<String?> photo = ValueNotifier(_cached());

  static http.Client client = http.Client();

  static String? get _key {
    final uid = AuthService.user.value?.uid;
    return uid == null ? null : 'speakupfearless.avatar.$uid';
  }

  static String? _cached() {
    final key = _key;
    final value = key == null ? null : readLocal(key);
    return value == null || value.isEmpty ? null : value;
  }

  static void _cache(String? value) {
    final key = _key;
    if (key != null) writeLocal(key, value ?? '');
    photo.value = value;
  }

  /// Shows the cached photo for whoever is signed in, then checks the backend.
  static Future<void> refresh() async {
    photo.value = _cached();
    final token = await AuthService.idToken(client: client);
    if (token == null) return;
    try {
      final response = await client
          .get(
            Uri.parse('${ProgressStore.apiBaseUrl}/v1/me'),
            headers: {'Authorization': 'Bearer $token'},
          )
          .timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) return;
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (!body.containsKey('avatar')) return;
      final avatar = body['avatar'] as String?;
      _cache(avatar == null || avatar.isEmpty ? null : avatar);
    } catch (_) {}
  }

  /// Saves [dataUrl] (or removes the photo when null). Returns false if the
  /// backend could not be reached; the photo still shows on this device.
  static Future<bool> save(String? dataUrl) async {
    _cache(dataUrl);
    final token = await AuthService.idToken(client: client);
    if (token == null) return false;
    try {
      final response = await client
          .patch(
            Uri.parse('${ProgressStore.apiBaseUrl}/v1/me'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({'avatar': dataUrl ?? ''}),
          )
          .timeout(const Duration(seconds: 12));
      return response.statusCode < 300;
    } catch (_) {
      return false;
    }
  }
}
