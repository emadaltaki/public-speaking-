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
  /// Base URL of the Go backend (no trailing slash). Signed-in visitors'
  /// history is also saved there so it follows them across devices.
  static const String apiBaseUrl = 'https://public-speaking-backend.vercel.app';

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

/// Saves history in this browser and, for signed-in visitors, also in the Go
/// backend (`/v1/games/sessions`). History merges both, so it keeps working
/// when the API is unreachable or has lost data, and rounds played on other
/// devices still show up.
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
    await _local.record(session);
    _changes.value++;
    final headers = await _headers();
    if (headers == null) return;
    try {
      await _client
          .post(
            Uri.parse('$baseUrl/v1/games/sessions'),
            headers: headers,
            body: jsonEncode({
              'gameId': session.gameId,
              'durationSeconds': session.spoken.inSeconds,
              if (session.topic != null) 'details': {'topic': session.topic},
            }),
          )
          .timeout(const Duration(seconds: 10));
    } catch (_) {
      // Already saved locally.
    }
  }

  @override
  Future<List<GameSession>> history() async {
    final local = await _local.history();
    final remote = await _remoteHistory();
    // Rounds from this browser are in both lists; keep one copy of each.
    bool same(GameSession a, GameSession b) =>
        a.gameId == b.gameId &&
        (a.spoken.inSeconds - b.spoken.inSeconds).abs() <= 1 &&
        a.playedAt.difference(b.playedAt).inMinutes.abs() <= 2;
    final merged = [
      ...local,
      for (final r in remote)
        if (!local.any((l) => same(l, r))) r,
    ]..sort((a, b) => b.playedAt.compareTo(a.playedAt));
    return merged;
  }

  Future<List<GameSession>> _remoteHistory() async {
    final headers = await _headers();
    if (headers == null) return const [];
    try {
      final response = await _client
          .get(
            Uri.parse('$baseUrl/v1/games/sessions?limit=200'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) return const [];
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
      return const [];
    }
  }
}
