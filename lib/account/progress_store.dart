import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'auth_service.dart';
import 'auth_storage.dart';

/// One finished game round.
class GameSession {
  const GameSession({
    required this.gameId,
    required this.playedAt,
    required this.spoken,
    this.topic,
  });

  final String gameId;
  final DateTime playedAt;
  final Duration spoken;
  final String? topic;

  Map<String, dynamic> toJson() => {
    'gameId': gameId,
    'playedAt': playedAt.toIso8601String(),
    'spokenSeconds': spoken.inSeconds,
    if (topic != null) 'topic': topic,
  };

  static GameSession fromJson(Map<String, dynamic> json) => GameSession(
    gameId: json['gameId'] as String,
    playedAt: DateTime.parse(json['playedAt'] as String),
    spoken: Duration(seconds: (json['spokenSeconds'] as num).toInt()),
    topic: json['topic'] as String?,
  );
}

/// Where game history is kept. The app only talks to this interface, so the
/// local store below can be swapped for one that calls the Go backend
/// (sending [AuthService.idToken] as a bearer token) without touching the
/// games.
abstract class ProgressStore {
  /// Base URL of the Go backend. Empty until it is deployed; set it (no
  /// trailing slash) to save signed-in visitors' history in the backend.
  static const String apiBaseUrl = '';

  static ProgressStore instance = apiBaseUrl.isEmpty
      ? LocalProgressStore()
      : ApiProgressStore(apiBaseUrl);

  /// Notifies when history changes, so the account page can refresh.
  ValueListenable<int> get changes;

  Future<void> record(GameSession session);

  Future<List<GameSession>> history();
}

/// Keeps history in this browser, per signed-in account (or as a guest).
class LocalProgressStore implements ProgressStore {
  static const int _keep = 200;

  final ValueNotifier<int> _changes = ValueNotifier(0);

  @override
  ValueListenable<int> get changes => _changes;

  String get _key =>
      'speakupfearless.history.${AuthService.user.value?.uid ?? 'guest'}';

  List<GameSession> _read() {
    final raw = readLocal(_key);
    if (raw == null) return [];
    try {
      return [
        for (final item in jsonDecode(raw) as List)
          GameSession.fromJson(item as Map<String, dynamic>),
      ];
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> record(GameSession session) async {
    final all = [session, ..._read()].take(_keep).toList();
    writeLocal(_key, jsonEncode([for (final s in all) s.toJson()]));
    _changes.value++;
  }

  @override
  Future<List<GameSession>> history() async => _read();
}

/// Stores history in the Go backend (`/v1/games/sessions`) for signed-in
/// visitors, and falls back to [LocalProgressStore] for guests or when the
/// API can't be reached.
class ApiProgressStore implements ProgressStore {
  ApiProgressStore(this.baseUrl, {http.Client? client, ProgressStore? local})
    : _client = client ?? http.Client(),
      _local = local ?? LocalProgressStore();

  /// e.g. `https://speakup-api-xxxx.run.app`, without a trailing slash.
  final String baseUrl;
  final http.Client _client;
  final ProgressStore _local;
  final ValueNotifier<int> _changes = ValueNotifier(0);

  @override
  ValueListenable<int> get changes => _changes;

  Future<Map<String, String>?> _headers() async {
    final token = await AuthService.idToken(client: _client);
    if (token == null) return null;
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  @override
  Future<void> record(GameSession session) async {
    final headers = await _headers();
    try {
      if (headers == null) throw StateError('signed out');
      final response = await _client.post(
        Uri.parse('$baseUrl/v1/games/sessions'),
        headers: headers,
        body: jsonEncode({
          'gameId': session.gameId,
          'durationSeconds': session.spoken.inSeconds,
          if (session.topic != null) 'details': {'topic': session.topic},
        }),
      );
      if (response.statusCode >= 300) {
        throw StateError('${response.statusCode}');
      }
    } catch (_) {
      await _local.record(session);
    }
    _changes.value++;
  }

  @override
  Future<List<GameSession>> history() async {
    final headers = await _headers();
    if (headers == null) return _local.history();
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/v1/games/sessions?limit=200'),
        headers: headers,
      );
      if (response.statusCode != 200) return _local.history();
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return [
        for (final item in body['sessions'] as List? ?? const [])
          GameSession(
            gameId: item['gameId'] as String,
            playedAt: DateTime.parse(item['playedAt'] as String).toLocal(),
            spoken: Duration(seconds: (item['durationSeconds'] as num).toInt()),
            topic:
                (item['details'] as Map<String, dynamic>?)?['topic'] as String?,
          ),
      ];
    } catch (_) {
      return _local.history();
    }
  }
}
