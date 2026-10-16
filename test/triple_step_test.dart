import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speak_up_fearless/app.dart';
import 'package:speak_up_fearless/games/game_catalog.dart';
import 'package:speak_up_fearless/games/triple_step/triple_step_game.dart';
import 'package:speak_up_fearless/games/triple_step/triple_step_play_page.dart';
import 'package:speak_up_fearless/translations/translations.dart';

import 'support/test_helpers.dart';

void main() {
  setUpAll(configureTestFonts);

  group('TripleStepGame', () {
    TripleStepGame game([TripleStepSettings s = const TripleStepSettings()]) =>
        TripleStepGame(s, random: math.Random(1));

    test('defaults to 6 words, 1 minute and a suggested title', () {
      final g = game();
      expect(g.words, hasLength(6));
      expect(g.words.toSet(), hasLength(6));
      expect(g.total, const Duration(minutes: 1));
      expect(g.topic, isNot('Your Own Topic'));
    });

    test('checking every word completes the round', () {
      final g = game();
      for (var i = 0; i < g.words.length; i++) {
        g.toggle(i);
      }
      expect(g.status, RoundStatus.completed);
      expect(g.results.single.wordsUsed, 6);
    });

    test('unchecking a word keeps the round going', () {
      final g = game()
        ..toggle(0)
        ..toggle(0);
      expect(g.wordsUsed, 0);
      expect(g.status, RoundStatus.running);
    });

    test('runs out of time and stops while paused', () {
      final g = game()..tick(const Duration(seconds: 20));
      expect(g.remaining, const Duration(seconds: 40));
      g
        ..togglePause()
        ..tick(const Duration(seconds: 30));
      expect(g.remaining, const Duration(seconds: 40));
      g
        ..togglePause()
        ..tick(const Duration(seconds: 40));
      expect(g.status, RoundStatus.timeUp);
    });

    test('survival mode resets the clock per word and eliminates', () {
      final g = game(const TripleStepSettings(survivalMode: true));
      expect(g.slice, const Duration(seconds: 10));
      g
        ..tick(const Duration(seconds: 8))
        ..toggle(0);
      expect(g.remaining, const Duration(seconds: 10));
      g.tick(const Duration(seconds: 10));
      expect(g.status, RoundStatus.eliminated);
    });

    test('multiplayer rotates players and keeps standings', () {
      final g = game(
        const TripleStepSettings(
          mode: TripleStepMode.multiplayer,
          players: ['Ana', 'Ben'],
        ),
      );
      expect(g.currentPlayer, 'Ana');
      g.finishEarly();
      expect(g.hasNextPlayer, isTrue);
      g.nextRound();
      expect(g.currentPlayer, 'Ben');
      g.finishEarly();
      expect(g.results.map((r) => r.player), ['Ana', 'Ben']);
      expect(g.hasNextPlayer, isFalse);
    });

    test('custom title when suggestions are off', () {
      expect(
        game(const TripleStepSettings(suggestTitle: false)).topic,
        'Your Own Topic',
      );
    });
  });

  testWidgets('games tab leads to setup and into a game', (tester) async {
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

  testWidgets('ticking every word shows the results', (tester) async {
    setSurface(tester, size: const Size(1280, 1000));
    await tester.pumpWidget(
      MaterialApp(
        home: TripleStepPlayPage(
          settings: const TripleStepSettings(topicCount: 3),
          random: math.Random(2),
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 2));
    expect(find.textContaining('00:5'), findsOneWidget);

    final boxes = find.byType(InkWell);
    final page = tester.state(find.byType(TripleStepPlayPage));
    expect(page, isNotNull);
    // Tap the three word rows (they're the last three InkWells).
    final count = boxes.evaluate().length;
    for (var i = count - 3; i < count; i++) {
      await tester.tap(boxes.at(i));
      await tester.pump();
    }
    expect(find.text(Translations.tripleStepAllDone), findsOneWidget);
    expect(find.text(Translations.tripleStepNextTopic), findsOneWidget);
  });

  test('catalog routes Triple Step', () {
    expect(GameCatalog.games.first.route, AppRoutes.tripleStep);
  });
}
