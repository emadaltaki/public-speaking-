import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speak_up_fearless/app.dart';
import 'package:speak_up_fearless/games/conductor/conductor_game.dart';
import 'package:speak_up_fearless/games/conductor/conductor_play_page.dart';
import 'package:speak_up_fearless/translations/translations.dart';

import 'support/test_helpers.dart';

void main() {
  setUpAll(configureTestFonts);

  group('ConductorGame', () {
    ConductorGame game([ConductorSettings s = const ConductorSettings()]) =>
        ConductorGame(s, random: math.Random(4));

    test('waits on the Ready screen, then counts 3-2-1', () {
      final g = game()..tick(const Duration(seconds: 5));
      expect(g.phase, ConductorPhase.ready);
      g.start();
      expect(g.countdownNumber, 3);
      g.tick(const Duration(milliseconds: 1500));
      expect(g.countdownNumber, 2);
      g.tick(const Duration(milliseconds: 1600));
      expect(g.phase, ConductorPhase.running);
    });

    test('pitch stays 1-10 and changes clearly every 4-8 seconds', () {
      final g = game()
        ..start()
        ..tick(ConductorGame.countdownLength);
      var previous = g.level;
      var changes = 0;
      for (var i = 0; i < 590; i++) {
        g.tick(const Duration(milliseconds: 100));
        expect(g.level, inInclusiveRange(1, 10));
        if (g.level != previous) {
          expect((g.level - previous).abs(), greaterThanOrEqualTo(3));
          previous = g.level;
          changes++;
        }
      }
      // 59 seconds of play: between 59/8 and 59/4 changes.
      expect(changes, inInclusiveRange(7, 14));
    });

    test('pausing stops time; the round ends at the timer', () {
      final g = game()
        ..start()
        ..tick(ConductorGame.countdownLength)
        ..tick(const Duration(seconds: 20))
        ..togglePause()
        ..tick(const Duration(seconds: 30));
      expect(g.remaining, const Duration(seconds: 40));
      g
        ..togglePause()
        ..tick(const Duration(seconds: 40));
      expect(g.phase, ConductorPhase.finished);
    });

    test('word sets other than General turn a word into the topic', () {
      final g = game(const ConductorSettings(wordSet: 'Food'));
      expect(g.topic[0], g.topic[0].toUpperCase());
      expect(
        game(const ConductorSettings(suggestTitle: false)).topic,
        'Your Own Topic',
      );
    });

    test('retry keeps the topic; next round goes back to Ready', () {
      final g = game()
        ..start()
        ..tick(ConductorGame.countdownLength)
        ..stop();
      final topic = g.topic;
      g.retry();
      expect(g.topic, topic);
      expect(g.phase, ConductorPhase.ready);
    });
  });

  testWidgets('games page opens The Conductor setup', (tester) async {
    setSurface(tester, size: const Size(1280, 1000));
    await tester.pumpWidget(
      SpeakUpFearlessApp(contactHandler: RecordingContactHandler()),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text(Translations.navGames).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('${Translations.gamesPlay} The Conductor'));
    await tester.pumpAndSettle();
    expect(find.text(Translations.conductorSetupSubtitle), findsOneWidget);
    expect(find.text('1 minute'), findsOneWidget);
    expect(find.text(Translations.tripleStepStart), findsOneWidget);
  });

  testWidgets('ready, countdown, pitch number, then time is up', (
    tester,
  ) async {
    setSurface(tester, size: const Size(1280, 900));
    await tester.pumpWidget(
      MaterialApp(
        home: ConductorPlayPage(
          settings: const ConductorSettings(timerSeconds: 30),
          random: math.Random(7),
        ),
      ),
    );
    await tester.pump();
    expect(find.text(Translations.gamesCueReady), findsOneWidget);

    await tester.tap(find.text(Translations.gamesImReady));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text(Translations.gamesCueReady), findsOneWidget);

    await tester.pump(const Duration(seconds: 4));
    expect(
      find.text(Translations.conductorPitch.toUpperCase()),
      findsOneWidget,
    );
    expect(find.text('00:30'), findsOneWidget);

    for (var i = 0; i < 31; i++) {
      await tester.pump(const Duration(seconds: 1));
    }
    expect(find.text(Translations.tripleStepTimeUp), findsOneWidget);
    expect(find.textContaining('Score'), findsNothing);
  });
}
