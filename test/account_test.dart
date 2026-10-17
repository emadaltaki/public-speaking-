import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:speak_up_fearless/account/account_page.dart';
import 'package:speak_up_fearless/account/auth_service.dart';
import 'package:speak_up_fearless/account/auth_storage.dart';
import 'package:speak_up_fearless/account/avatar_store.dart';
import 'package:speak_up_fearless/account/progress_store.dart';
import 'package:speak_up_fearless/translations/translations.dart';

import 'support/test_helpers.dart';

const _key = 'firebase:authUser:${AuthService.apiKey}:[DEFAULT]';

void _signIn({int expiresInMs = 3600000}) {
  writeStoredUser(
    _key,
    jsonEncode({
      'uid': 'u1',
      'email': 'sam@example.com',
      'displayName': 'Sam Rivera',
      'stsTokenManager': {
        'accessToken': 'old-token',
        'refreshToken': 'refresh-1',
        'expirationTime': DateTime.now().millisecondsSinceEpoch + expiresInMs,
      },
    }),
  );
  AuthService.reload();
}

void main() {
  setUpAll(configureTestFonts);
  tearDown(() {
    AuthService.signOut();
  });

  test('reads the Firebase session the sign-in page stored', () {
    expect(AuthService.signedIn, isFalse);
    _signIn();
    expect(AuthService.user.value!.shortName, 'Sam');
    expect(AuthService.user.value!.email, 'sam@example.com');
    AuthService.signOut();
    expect(AuthService.signedIn, isFalse);
  });

  test('returns the token, refreshing it when expired', () async {
    _signIn();
    expect(await AuthService.idToken(), 'old-token');

    _signIn(expiresInMs: -1000);
    final client = MockClient((req) async {
      expect(req.url.host, 'securetoken.googleapis.com');
      expect(req.body, contains('refresh-1'));
      return http.Response(
        jsonEncode({
          'id_token': 'new-token',
          'refresh_token': 'refresh-2',
          'expires_in': '3600',
        }),
        200,
      );
    });
    expect(await AuthService.idToken(client: client), 'new-token');
    expect(await AuthService.idToken(), 'new-token');
  });

  test('local history keeps rounds per account', () async {
    final store = LocalProgressStore();
    _signIn();
    await store.record(
      GameSession(
        gameId: 'conductor',
        playedAt: DateTime(2026, 10, 17),
        spoken: const Duration(seconds: 60),
        topic: 'Rivers',
      ),
    );
    final history = await store.history();
    expect(history.single.topic, 'Rivers');
    AuthService.signOut();
    expect(await store.history(), isEmpty);
  });

  test('API store sends rounds to the Go backend with the token', () async {
    _signIn();
    late http.Request sent;
    final store = ApiProgressStore(
      'https://api.example.com',
      client: MockClient((req) async {
        sent = req;
        return http.Response('{}', 201);
      }),
    );
    await store.record(
      GameSession(
        gameId: 'triple-step',
        playedAt: DateTime(2026, 10, 17),
        spoken: const Duration(seconds: 90),
      ),
    );
    expect(sent.url.path, '/v1/games/sessions');
    expect(sent.headers['Authorization'], 'Bearer old-token');
    expect(jsonDecode(sent.body)['durationSeconds'], 90);
  });

  test('API store merges backend rounds with local rounds', () async {
    _signIn();
    final played = DateTime(2026, 10, 17, 9);
    final store = ApiProgressStore(
      'https://api.example.com',
      local: LocalProgressStore(),
      client: MockClient((req) async {
        if (req.method == 'POST') return http.Response('{}', 201);
        return http.Response(
          jsonEncode({
            'sessions': [
              {
                'gameId': 'triple-step',
                'playedAt': played.toUtc().toIso8601String(),
                'durationSeconds': 90,
              },
              {
                'gameId': 'podcast',
                'playedAt': DateTime(2026, 10, 16).toUtc().toIso8601String(),
                'durationSeconds': 60,
              },
            ],
          }),
          200,
        );
      }),
    );
    await store.record(
      GameSession(
        gameId: 'triple-step',
        playedAt: played,
        spoken: const Duration(seconds: 90),
      ),
    );
    final history = await store.history();
    // The round saved here and returned by the backend shows up once.
    expect(
      history.where((s) => s.gameId == 'triple-step' && s.playedAt == played),
      hasLength(1),
    );
    expect(history.any((s) => s.gameId == 'podcast'), isTrue);
    AuthService.signOut();
  });

  test('profile photo is cached and sent to the backend', () async {
    _signIn();
    late http.Request sent;
    AvatarStore.client = MockClient((req) async {
      sent = req;
      return http.Response('{}', 200);
    });
    const photo = 'data:image/jpeg;base64,AAAA';
    expect(await AvatarStore.save(photo), isTrue);
    expect(sent.method, 'PATCH');
    expect(sent.url.path, '/v1/me');
    expect(jsonDecode(sent.body)['avatar'], photo);
    expect(AvatarStore.photo.value, photo);
    await AvatarStore.save(null);
    expect(jsonDecode(sent.body)['avatar'], '');
    expect(AvatarStore.photo.value, isNull);
    AvatarStore.client = MockClient((_) async => http.Response('{}', 404));
    AuthService.signOut();
  });

  testWidgets('account page shows sign-in when signed out, stats when in', (
    tester,
  ) async {
    setSurface(tester, size: const Size(1280, 1400));
    await tester.pumpWidget(wrapForTest(const AccountPage()));
    await tester.pumpAndSettle();
    expect(find.text(Translations.accountSignedOutTitle), findsOneWidget);

    _signIn();
    await ProgressStore.instance.record(
      GameSession(
        gameId: 'podcast',
        playedAt: DateTime.now(),
        spoken: const Duration(minutes: 2),
        topic: 'Hope',
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text(Translations.accountHello('Sam')), findsOneWidget);
    expect(find.text(Translations.accountRounds), findsOneWidget);
    expect(find.text('Hope'), findsOneWidget);
  });
}
