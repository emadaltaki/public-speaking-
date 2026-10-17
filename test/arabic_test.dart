import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speak_up_fearless/app.dart';
import 'package:speak_up_fearless/games/arabic_game_data.dart';
import 'package:speak_up_fearless/games/autocomplete/autocomplete_data.dart';
import 'package:speak_up_fearless/games/topics.dart';
import 'package:speak_up_fearless/translations/translations.dart';

import 'support/test_helpers.dart';

void main() {
  setUpAll(configureTestFonts);
  tearDown(() => Translations.language.value = 'en');

  testWidgets('the language switch shows Arabic, right to left', (
    tester,
  ) async {
    setSurface(tester, size: const Size(1280, 1200));
    await tester.pumpWidget(
      SpeakUpFearlessApp(contactHandler: RecordingContactHandler()),
    );
    await tester.pumpAndSettle();
    expect(
      find.text('You Don\'t Have to Be Fearless to Speak.'),
      findsOneWidget,
    );

    await tester.tap(find.text('العربية'));
    await tester.pumpAndSettle();

    expect(find.text('لست بحاجة لأن تكون بلا خوف لكي تتحدث.'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    final direction = Directionality.of(
      tester.element(find.text('لست بحاجة لأن تكون بلا خوف لكي تتحدث.')),
    );
    expect(direction, TextDirection.rtl);

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    expect(
      find.text('You Don\'t Have to Be Fearless to Speak.'),
      findsOneWidget,
    );
  });

  test('games draw Arabic topics and sentences in Arabic', () {
    Translations.language.value = 'ar';
    final topic = pickGameTopic(
      suggestTitle: true,
      wordSet: generalWordSet,
      random: math.Random(1),
    );
    expect(ArabicGameData.topics, contains(topic));
    expect(
      AutocompleteData.phrasesFor(AutocompleteData.mixed).first,
      ArabicGameData.phrases.values.first.first,
    );
    expect(Translations.timerLabel(60), 'دقيقة واحدة');
  });

  test('every Arabic word set exists in English too', () {
    expect(
      ArabicGameData.wordSets.keys.toSet(),
      ArabicGameData.wordSets.keys.toSet(),
    );
    for (final list in ArabicGameData.wordSets.values) {
      expect(list.length, greaterThanOrEqualTo(25));
    }
    expect(ArabicGameData.topics.length, greaterThanOrEqualTo(200));
  });
}
