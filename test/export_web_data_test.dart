// Writes the games' text and word lists to site/data/*.json for the plain
// HTML pages. Run with: flutter test test/export_web_data_test.dart
@Tags(['export'])
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:speak_up_fearless/games/arabic_game_data.dart';
import 'package:speak_up_fearless/games/autocomplete/autocomplete_data.dart';
import 'package:speak_up_fearless/games/game_catalog.dart';
import 'package:speak_up_fearless/games/triple_step/triple_step_data.dart';
import 'package:speak_up_fearless/translations/translations.dart';

Map<String, dynamic> _catalog() => {
  for (final g in GameCatalog.games.where((g) => g.available))
    g.id: {
      'title': g.title,
      'tagline': g.tagline,
      'description': g.description,
      'skills': g.skills,
      'steps': [for (final s in g.howToPlay) s.text],
      'tip': g.tip,
    },
};

void main() {
  test('export game data for the HTML site', () {
    Translations.language.value = 'en';
    final en = _catalog();
    Translations.language.value = 'ar';
    final ar = _catalog();
    Translations.language.value = 'en';
    Directory('site/data').createSync(recursive: true);
    const enc = JsonEncoder.withIndent(' ');
    File('site/data/games.json').writeAsStringSync(enc.convert({'en': en, 'ar': ar}));
    File('site/data/words.json').writeAsStringSync(
      jsonEncode({
        'en': {
          'topics': TripleStepData.topics,
          'wordSets': TripleStepData.wordSets,
          'phrases': AutocompleteData.sets,
        },
        'ar': {
          'topics': ArabicGameData.topics,
          'wordSets': ArabicGameData.wordSets,
          'phrases': ArabicGameData.phrases,
        },
      }),
    );
  });
}
