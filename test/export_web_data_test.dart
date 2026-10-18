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
import 'package:speak_up_fearless/games/podcast/podcast_game.dart';
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

Map<String, dynamic> _strings() => {
  'gamesImReady': Translations.gamesImReady,
  'gamesCueReady': Translations.gamesCueReady,
  'gamesCueSet': Translations.gamesCueSet,
  'gamesCueGo': Translations.gamesCueGo,
  'tripleStepSetupSubtitle': Translations.tripleStepSetupSubtitle,
  'tripleStepBackToGames': Translations.tripleStepBackToGames,
  'tripleStepSingle': Translations.tripleStepSingle,
  'tripleStepMulti': Translations.tripleStepMulti,
  'tripleStepPlayers': Translations.tripleStepPlayers,
  'tripleStepAddPlayer': Translations.tripleStepAddPlayer,
  'tripleStepRemovePlayer': Translations.tripleStepRemovePlayer,
  'tripleStepTopics': Translations.tripleStepTopics,
  'tripleStepTopicsHelp': Translations.tripleStepTopicsHelp,
  'tripleStepTimer': Translations.tripleStepTimer,
  'tripleStepSuggestTitle': Translations.tripleStepSuggestTitle,
  'tripleStepSuggestTitleHelp': Translations.tripleStepSuggestTitleHelp,
  'tripleStepSurvival': Translations.tripleStepSurvival,
  'tripleStepSurvivalHelp': Translations.tripleStepSurvivalHelp,
  'tripleStepWordSet': Translations.tripleStepWordSet,
  'tripleStepStart': Translations.tripleStepStart,
  'tripleStepBackToSettings': Translations.tripleStepBackToSettings,
  'tripleStepInstruction': Translations.tripleStepInstruction,
  'tripleStepSurvivalInstruction': Translations.tripleStepSurvivalInstruction,
  'tripleStepPause': Translations.tripleStepPause,
  'tripleStepResume': Translations.tripleStepResume,
  'tripleStepFinish': Translations.tripleStepFinish,
  'tripleStepWords': Translations.tripleStepWords,
  'tripleStepSpokenFor': Translations.tripleStepSpokenFor,
  'tripleStepStuck': Translations.tripleStepStuck,
  'tripleStepNextWordIn': Translations.tripleStepNextWordIn,
  'tripleStepFirstWordSoon': Translations.tripleStepFirstWordSoon,
  'tripleStepNew': Translations.tripleStepNew,
  'tripleStepComingUp': Translations.tripleStepComingUp,
  'tripleStepTimeUp': Translations.tripleStepTimeUp,
  'tripleStepRoundEnded': Translations.tripleStepRoundEnded,
  'tripleStepEveryoneWent': Translations.tripleStepEveryoneWent,
  'tripleStepNextPlayer': Translations.tripleStepNextPlayer,
  'tripleStepNewGame': Translations.tripleStepNewGame,
  'tripleStepNextTopic': Translations.tripleStepNextTopic,
  'tripleStepRetry': Translations.tripleStepRetry,
  'tripleStepSettings': Translations.tripleStepSettings,
  'conductorSetupSubtitle': Translations.conductorSetupSubtitle,
  'conductorReadyHint': Translations.conductorReadyHint,
  'conductorPitch': Translations.conductorPitch,
  'conductorTopic': Translations.conductorTopic,
  'conductorPaused': Translations.conductorPaused,
  'conductorLevelLow': Translations.conductorLevelLow,
  'conductorLevelLowMid': Translations.conductorLevelLowMid,
  'conductorLevelMid': Translations.conductorLevelMid,
  'conductorLevelHighMid': Translations.conductorLevelHighMid,
  'conductorLevelHigh': Translations.conductorLevelHigh,
  'podcastDifficulty': Translations.podcastDifficulty,
  'podcastDifficultyHelp': Translations.podcastDifficultyHelp,
  'podcastPlayers': Translations.podcastPlayers,
  'podcastNext': Translations.podcastNext,
  'podcastBackToRules': Translations.podcastBackToRules,
  'podcastWhoIsPlaying': Translations.podcastWhoIsPlaying,
  'podcastReadyHint': Translations.podcastReadyHint,
  'podcastNowSpeaking': Translations.podcastNowSpeaking,
  'podcastEnd': Translations.podcastEnd,
  'autocompleteSubtitle': Translations.autocompleteSubtitle,
  'autocompleteSecondsPerRound': Translations.autocompleteSecondsPerRound,
  'autocompleteRounds': Translations.autocompleteRounds,
  'autocompletePhraseSet': Translations.autocompletePhraseSet,
  'autocompleteReadyHint': Translations.autocompleteReadyHint,
  'autocompleteNext': Translations.autocompleteNext,
  'autocompleteDone': Translations.autocompleteDone,
  'autocompletePlayAgain': Translations.autocompletePlayAgain,
  'yourOwnTopic': Translations.yourOwnTopic,
  'playerName': Translations.playerName(9999),
  'youSpokeFor': Translations.youSpokeFor('@@'),
  'turnOf': Translations.turnOf('@@'),
  'finishedSentences': Translations.finishedSentences(9999),
  'wordSetNames': {
    for (final n in [
      'General',
      'Business',
      'Nature',
      'Food',
      'Travel',
      'Technology',
      'Mixed',
      'Funny',
      'Everyday',
      'Work & School',
      'Big Questions',
    ])
      n: Translations.wordSetName(n),
  },
  'paces': [for (final p in PodcastPace.values) p.label],
};

void main() {
  test('export game data for the HTML site', () {
    Translations.language.value = 'en';
    final en = _catalog();
    final enS = _strings();
    Translations.language.value = 'ar';
    final ar = _catalog();
    final arS = _strings();
    Translations.language.value = 'en';
    Directory('site/data').createSync(recursive: true);
    const enc = JsonEncoder.withIndent(' ');
    File('site/data/games.json').writeAsStringSync(
      enc.convert({
        'en': en,
        'ar': ar,
        'strings': {'en': enS, 'ar': arS},
      }),
    );
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
