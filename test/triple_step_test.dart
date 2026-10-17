import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speak_up_fearless/app.dart';
import 'package:speak_up_fearless/games/game_catalog.dart';
import 'package:speak_up_fearless/games/triple_step/triple_step_data.dart';
import 'package:speak_up_fearless/games/triple_step/triple_step_game.dart';
import 'package:speak_up_fearless/games/triple_step/triple_step_play_page.dart';
import 'package:speak_up_fearless/translations/translations.dart';

import 'support/test_helpers.dart';

void main() {
  setUpAll(configureTestFonts);

  group('TripleStepGame', () {
    TripleStepGame game([TripleStepSettings s = const TripleStepSettings()]) =>
        TripleStepGame(s, random: math.Random(1));

    test('defaults to 6 words over 1 minute with a suggested title', () {
      final g = game();
      expect(g.total, const Duration(minutes: 1));
      expect(g.interval, const Duration(milliseconds: 8571));
      expect(g.topic, isNot('Your Own Topic'));
      expect(g.revealed, isEmpty);
      expect(g.upcomingCount, 6);
    });

    test('words appear one at a time as the clock runs', () {
      final g = game()..tick(const Duration(seconds: 9));
      expect(g.revealed, hasLength(1));
      g.tick(const Duration(seconds: 9));
      expect(g.revealed, hasLength(2));
      expect(g.revealed.toSet(), hasLength(2));
      g.tick(const Duration(seconds: 40));
      expect(g.revealed, hasLength(6));
      expect(g.nextWordIn, isNull);
    });

    test('pausing stops words and time; the round ends at the timer', () {
      final g = game()..tick(const Duration(seconds: 20));
      expect(g.remaining, const Duration(seconds: 40));
      g
        ..togglePause()
        ..tick(const Duration(seconds: 30));
      expect(g.remaining, const Duration(seconds: 40));
      g
        ..togglePause()
        ..tick(const Duration(seconds: 40));
      expect(g.status, RoundStatus.finished);
      expect(g.results.single.wordsHandled, 6);
      expect(g.results.single.spoken, const Duration(minutes: 1));
    });

    test('finishing early keeps only the words shown so far', () {
      final g = game()
        ..tick(const Duration(seconds: 20))
        ..stop();
      expect(g.status, RoundStatus.stopped);
      expect(g.results.single.wordsHandled, 2);
    });

    test('survival mode keeps sending words until the speaker is stuck', () {
      final g = game(const TripleStepSettings(survivalMode: true))
        ..tick(const Duration(minutes: 3));
      expect(g.status, RoundStatus.running);
      expect(g.revealed.length, greaterThan(6));
      expect(g.nextWordIn, isNotNull);
      g.stop();
      expect(g.results.single.spoken, const Duration(minutes: 3));
    });

    test('multiplayer rotates players and records each turn', () {
      final g = game(
        const TripleStepSettings(
          mode: TripleStepMode.multiplayer,
          players: ['Ana', 'Ben'],
        ),
      );
      expect(g.currentPlayer, 'Ana');
      g.stop();
      expect(g.hasNextPlayer, isTrue);
      g.nextRound();
      expect(g.currentPlayer, 'Ben');
      g.stop();
      expect(g.results.map((r) => r.player), ['Ana', 'Ben']);
      expect(g.hasNextPlayer, isFalse);
    });

    test('topics never repeat until every topic has been used', () {
      final deck = TopicDeck(['A', 'B', 'C']);
      final random = math.Random(3);
      final firstPass = {for (var i = 0; i < 3; i++) deck.draw(random)};
      expect(firstPass, {'A', 'B', 'C'});
      expect(['A', 'B', 'C'], contains(deck.draw(random)));
    });

    test('the topic pool is large and includes the custom topics', () {
      expect(TripleStepData.topics.length, greaterThan(300));
      expect(
        TripleStepData.topics.toSet(),
        hasLength(TripleStepData.topics.length),
      );
      expect(TripleStepData.topics, contains('The Price of Leadership'));
      expect(TripleStepData.topics, contains("If Money Didn't Exist"));
    });

    test('custom title when suggestions are off', () {
      expect(
        game(const TripleStepSettings(suggestTitle: false)).topic,
        'Your Own Topic',
      );
    });
  });

  testWidgets('games tab leads to setup and into a game', (tester) async {
    signInForTest();
    setSurface(tester, size: const Size(1280, 1000));
    await tester.pumpWidget(
      SpeakUpFearlessApp(contactHandler: RecordingContactHandler()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text(Translations.navGames).first);
    await tester.pumpAndSettle();
    expect(find.text(Translations.gamesTitle), findsOneWidget);

    await tester.tap(find.text('${Translations.gamesPlay} Triple Step'));
    await tester.pumpAndSettle();
    expect(find.text(Translations.tripleStepStart), findsOneWidget);
    expect(find.text('6'), findsOneWidget);
    expect(find.text('1 minute'), findsOneWidget);

    await tester.ensureVisible(find.text(Translations.tripleStepStart));
    await tester.tap(find.text(Translations.tripleStepStart));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(TripleStepPlayPage), findsOneWidget);
    expect(find.text('× (Esc)'), findsOneWidget);
  });

  testWidgets('words pop up over time and the round ends with results', (
    tester,
  ) async {
    setSurface(tester, size: const Size(1280, 1000));
    await tester.pumpWidget(
      MaterialApp(
        home: TripleStepPlayPage(
          settings: const TripleStepSettings(topicCount: 3, timerSeconds: 60),
          random: math.Random(2),
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 2));
    expect(find.text(Translations.tripleStepFirstWordSoon), findsOneWidget);
    expect(find.byType(Checkbox), findsNothing);

    await tester.pump(const Duration(seconds: 14));
    expect(find.text(Translations.tripleStepNew), findsOneWidget);
    expect(find.text(Translations.tripleStepComingUp), findsNWidgets(2));

    for (var i = 0; i < 46; i++) {
      await tester.pump(const Duration(seconds: 1));
    }
    expect(find.text(Translations.tripleStepTimeUp), findsOneWidget);
    expect(find.textContaining('Score'), findsNothing);
    expect(find.text('You spoke for 1:00.'), findsOneWidget);
  });

  test('catalog routes Triple Step', () {
    expect(GameCatalog.games.first.route, AppRoutes.tripleStep);
  });
}
