import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speak_up_fearless/app.dart';
import 'package:speak_up_fearless/games/autocomplete/autocomplete_data.dart';
import 'package:speak_up_fearless/games/autocomplete/autocomplete_game.dart';
import 'package:speak_up_fearless/games/autocomplete/autocomplete_play_page.dart';
import 'package:speak_up_fearless/games/game_catalog.dart';
import 'package:speak_up_fearless/games/podcast/podcast_game.dart';
import 'package:speak_up_fearless/games/podcast/podcast_play_page.dart';
import 'package:speak_up_fearless/translations/translations.dart';

import 'support/test_helpers.dart';

void main() {
  setUpAll(configureTestFonts);

  group('PodcastGame', () {
    PodcastGame game([PodcastSettings s = const PodcastSettings()]) =>
        PodcastGame(s, random: math.Random(5));

    test('defaults to 5 players and a slow pace', () {
      final g = game();
      expect(g.players, hasLength(5));
      expect(g.settings.pace, PodcastPace.slow);
    });

    test('the speaker switches to someone else at the chosen pace', () {
      final g = game(const PodcastSettings(pace: PodcastPace.fast))
        ..start()
        ..tick(PodcastGame.countdownLength);
      var previous = g.speaker;
      var switches = 0;
      for (var i = 0; i < 590; i++) {
        g.tick(const Duration(milliseconds: 100));
        if (g.speaker != previous) {
          switches++;
          previous = g.speaker;
        }
      }
      // Fast is every 5-8 seconds: 59s gives 7 to 11 switches.
      expect(switches, inInclusiveRange(7, 11));
    });

    test('uses the names given and ends at the timer', () {
      final g =
          game(const PodcastSettings(players: ['Ana', 'Ben'], timerSeconds: 30))
            ..start()
            ..tick(PodcastGame.countdownLength)
            ..tick(const Duration(seconds: 31));
      expect(['Ana', 'Ben'], contains(g.speakerName));
      expect(g.phase, PodcastPhase.finished);
    });
  });

  group('AutocompleteGame', () {
    AutocompleteGame game([
      AutocompleteSettings s = const AutocompleteSettings(),
    ]) => AutocompleteGame(s, random: math.Random(6));

    test('has a big phrase list with funny ones', () {
      final all = AutocompleteData.phrasesFor(AutocompleteData.mixed);
      expect(all.length, greaterThanOrEqualTo(150));
      expect(all.toSet(), hasLength(all.length));
      expect(AutocompleteData.sets['Funny']!.length, greaterThanOrEqualTo(50));
    });

    test('deals 6 different phrases and moves on when time runs out', () {
      final g = game()
        ..start()
        ..tick(AutocompleteGame.countdownLength);
      expect(g.phrases.toSet(), hasLength(6));
      final first = g.phrase;
      g.tick(const Duration(seconds: 5));
      expect(g.round, 1);
      expect(g.phrase, isNot(first));
    });

    test('Next skips ahead and the game ends after the last round', () {
      final g = game(const AutocompleteSettings(rounds: 3))
        ..start()
        ..tick(AutocompleteGame.countdownLength)
        ..next()
        ..next();
      expect(g.round, 2);
      g.next();
      expect(g.phase, AutocompletePhase.finished);
    });

    test('multiplayer takes turns each round', () {
      final g =
          game(
              const AutocompleteSettings(
                mode: AutocompleteMode.multiplayer,
                players: ['Ana', 'Ben'],
              ),
            )
            ..start()
            ..tick(AutocompleteGame.countdownLength);
      expect(g.currentPlayer, 'Ana');
      g.next();
      expect(g.currentPlayer, 'Ben');
    });
  });

  testWidgets('every playable game has How to play tips that open', (
    tester,
  ) async {
    signInForTest();
    setSurface(tester, size: const Size(1280, 1400));
    await tester.pumpWidget(
      SpeakUpFearlessApp(contactHandler: RecordingContactHandler()),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text(Translations.navGames).first);
    await tester.pumpAndSettle();

    final playable = GameCatalog.games.where((g) => g.available).toList();
    expect(playable, hasLength(4));
    for (final g in playable) {
      expect(g.howToPlay, isNotEmpty, reason: '${g.title} needs tips');
    }
    expect(find.text(Translations.gamesHowToPlay), findsNWidgets(4));

    await tester.tap(find.text(Translations.gamesHowToPlay).first);
    await tester.pumpAndSettle();
    expect(
      find.text('${Translations.gamesHowToPlay}: Triple Step'),
      findsOneWidget,
    );
    await tester.tap(find.text(Translations.gamesGotIt));
    await tester.pumpAndSettle();
    expect(find.text(Translations.gamesGotIt), findsNothing);
  });

  testWidgets('podcast: ready, then a name to speak, then time is up', (
    tester,
  ) async {
    setSurface(tester, size: const Size(1280, 900));
    await tester.pumpWidget(
      MaterialApp(
        home: PodcastPlayPage(
          settings: const PodcastSettings(
            players: ['Ana', 'Ben', 'Cy'],
            timerSeconds: 30,
          ),
          random: math.Random(1),
        ),
      ),
    );
    await tester.pump();
    expect(find.text(Translations.gamesCueReady), findsOneWidget);
    await tester.tap(find.text(Translations.gamesImReady));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(seconds: 4));
    expect(
      find.text(Translations.podcastNowSpeaking.toUpperCase()),
      findsOneWidget,
    );
    for (var i = 0; i < 31; i++) {
      await tester.pump(const Duration(seconds: 1));
    }
    expect(find.text(Translations.tripleStepTimeUp), findsOneWidget);
  });

  testWidgets('autocomplete: sentences rotate and the game finishes', (
    tester,
  ) async {
    setSurface(tester, size: const Size(1280, 1000));
    await tester.pumpWidget(
      MaterialApp(
        home: AutocompletePlayPage(
          settings: const AutocompleteSettings(rounds: 3),
          random: math.Random(2),
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.text(Translations.gamesImReady));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(seconds: 4));
    expect(find.text('1 / 3'), findsOneWidget);
    await tester.tap(find.text(Translations.autocompleteNext));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('2 / 3'), findsOneWidget);
    for (var i = 0; i < 12; i++) {
      await tester.pump(const Duration(seconds: 1));
    }
    expect(find.text(Translations.autocompleteDone), findsOneWidget);
  });

  testWidgets('signed-out visitors are asked to sign up before playing', (
    tester,
  ) async {
    setSurface(tester, size: const Size(1280, 1400));
    await tester.pumpWidget(
      SpeakUpFearlessApp(contactHandler: RecordingContactHandler()),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text(Translations.navGames).first);
    await tester.pumpAndSettle();
    expect(find.text(Translations.gamesGateTitle), findsOneWidget);
    expect(find.text(Translations.gamesPlay), findsNothing);
  });
}
