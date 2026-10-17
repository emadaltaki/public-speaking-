import 'dart:math' as math;

import 'triple_step/triple_step_data.dart';
import 'triple_step/triple_step_game.dart' show TopicDeck;

/// The "General" set draws from the full topic list; other word sets turn
/// one of their words into the topic.
const String generalWordSet = 'General';

/// Picks a round topic the same way for every game.
String pickGameTopic({
  required bool suggestTitle,
  required String wordSet,
  required math.Random random,
}) {
  if (!suggestTitle) return 'Your Own Topic';
  final words = TripleStepData.wordSets[wordSet];
  if (wordSet == generalWordSet || words == null) {
    return TopicDeck.shared.draw(random);
  }
  final word = words[random.nextInt(words.length)];
  return word[0].toUpperCase() + word.substring(1);
}
