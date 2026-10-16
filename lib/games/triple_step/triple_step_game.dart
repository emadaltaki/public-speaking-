import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import 'triple_step_data.dart';

enum TripleStepMode { singlePlayer, multiplayer }

/// Hands out topics in a random order without repeats; once every topic has
/// been used, it reshuffles. Shared so every round and every player in a
/// visit gets a fresh topic.
class TopicDeck {
  TopicDeck(this.topics);

  static final TopicDeck shared = TopicDeck(TripleStepData.topics);

  final List<String> topics;
  final List<String> _remaining = [];

  String draw(math.Random random) {
    if (_remaining.isEmpty) {
      _remaining.addAll(topics);
      _remaining.shuffle(random);
    }
    return _remaining.removeLast();
  }
}

class TripleStepSettings {
  const TripleStepSettings({
    this.mode = TripleStepMode.singlePlayer,
    this.topicCount = defaultTopicCount,
    this.timerSeconds = defaultTimerSeconds,
    this.suggestTitle = true,
    this.survivalMode = false,
    this.wordSet = 'General',
    this.players = const [],
  });

  static const int defaultTopicCount = 6;
  static const int minTopicCount = 3;
  static const int maxTopicCount = 10;
  static const int defaultTimerSeconds = 60;
  static const int minTimerSeconds = 30;
  static const int maxTimerSeconds = 300;
  static const int timerStepSeconds = 30;

  final TripleStepMode mode;

  /// How many words appear during the round.
  final int topicCount;
  final int timerSeconds;
  final bool suggestTitle;

  /// Words keep coming at the same pace until the speaker gets stuck.
  final bool survivalMode;
  final String wordSet;

  /// Player names in multiplayer mode.
  final List<String> players;

  bool get isMultiplayer => mode == TripleStepMode.multiplayer;

  TripleStepSettings copyWith({
    TripleStepMode? mode,
    int? topicCount,
    int? timerSeconds,
    bool? suggestTitle,
    bool? survivalMode,
    String? wordSet,
    List<String>? players,
  }) {
    return TripleStepSettings(
      mode: mode ?? this.mode,
      topicCount: topicCount ?? this.topicCount,
      timerSeconds: timerSeconds ?? this.timerSeconds,
      suggestTitle: suggestTitle ?? this.suggestTitle,
      survivalMode: survivalMode ?? this.survivalMode,
      wordSet: wordSet ?? this.wordSet,
      players: players ?? this.players,
    );
  }
}

enum RoundStatus {
  running,
  paused,

  /// Spoke until the timer ran out.
  finished,

  /// Ended early (or got stuck in survival mode).
  stopped,
}

class RoundResult {
  const RoundResult({
    required this.player,
    required this.topic,
    required this.wordsHandled,
    required this.spoken,
    required this.status,
  });

  final String? player;
  final String topic;

  /// Words that appeared while the speaker kept going.
  final int wordsHandled;
  final Duration spoken;
  final RoundStatus status;

  int get score => wordsHandled * 10 + spoken.inSeconds;
}

/// Game state for Triple Step: the speaker talks on a topic while words
/// appear one at a time, and has to work each new word into the speech.
/// Time is advanced by [tick] so a screen can drive it from a ticker and
/// tests can drive it directly.
class TripleStepGame extends ChangeNotifier {
  TripleStepGame(this.settings, {math.Random? random})
    : _random = random ?? math.Random() {
    _startRound();
  }

  final TripleStepSettings settings;
  final math.Random _random;

  final List<RoundResult> results = [];
  late String topic;
  late List<String> _pool;
  int playerIndex = 0;
  RoundStatus status = RoundStatus.running;
  Duration elapsed = Duration.zero;

  Duration get total => Duration(seconds: settings.timerSeconds);

  /// Time between new words. Words are spread so the last one still leaves
  /// a stretch of speaking time after it.
  Duration get interval =>
      Duration(milliseconds: total.inMilliseconds ~/ (settings.topicCount + 1));

  /// Words shown so far, oldest first.
  List<String> get revealed {
    var count = elapsed.inMilliseconds ~/ interval.inMilliseconds;
    if (!settings.survivalMode) {
      count = math.min(count, settings.topicCount);
    }
    return [for (var i = 0; i < count; i++) _pool[i % _pool.length]];
  }

  int get revealedCount => revealed.length;

  /// Words still to come (normal mode only).
  int get upcomingCount =>
      settings.survivalMode ? 0 : settings.topicCount - revealedCount;

  /// Time until the next word appears, or null when none are left.
  Duration? get nextWordIn {
    if (!settings.survivalMode && upcomingCount == 0) return null;
    final step = interval.inMilliseconds;
    return Duration(milliseconds: step - elapsed.inMilliseconds % step);
  }

  /// What the pie and clock count down: the round in normal mode, the wait
  /// for the next word in survival mode.
  Duration get countdownTotal => settings.survivalMode ? interval : total;

  Duration get remaining {
    if (settings.survivalMode) return nextWordIn ?? Duration.zero;
    final left = total - elapsed;
    return left.isNegative ? Duration.zero : left;
  }

  double get fractionRemaining => countdownTotal.inMilliseconds == 0
      ? 0
      : remaining.inMilliseconds / countdownTotal.inMilliseconds;

  bool get isOver =>
      status == RoundStatus.finished || status == RoundStatus.stopped;

  String? get currentPlayer =>
      settings.isMultiplayer && settings.players.isNotEmpty
      ? settings.players[playerIndex]
      : null;

  bool get hasNextPlayer =>
      settings.isMultiplayer && playerIndex < settings.players.length - 1;

  void _startRound() {
    topic = settings.suggestTitle
        ? TopicDeck.shared.draw(_random)
        : 'Your Own Topic';
    _pool = List<String>.of(
      TripleStepData.wordSets[settings.wordSet] ??
          TripleStepData.wordSets.values.first,
    )..shuffle(_random);
    elapsed = Duration.zero;
    status = RoundStatus.running;
  }

  /// Advances the clock by [delta] while the round is running.
  void tick(Duration delta) {
    if (status != RoundStatus.running) return;
    elapsed += delta;
    if (!settings.survivalMode && elapsed >= total) {
      elapsed = total;
      _finish(RoundStatus.finished);
    }
    notifyListeners();
  }

  void togglePause() {
    if (status == RoundStatus.running) {
      status = RoundStatus.paused;
    } else if (status == RoundStatus.paused) {
      status = RoundStatus.running;
    }
    notifyListeners();
  }

  /// Ends the round now: "Finish" in normal mode, "I'm stuck" in survival.
  void stop() {
    if (isOver) return;
    _finish(RoundStatus.stopped);
    notifyListeners();
  }

  void _finish(RoundStatus outcome) {
    status = outcome;
    results.add(
      RoundResult(
        player: currentPlayer,
        topic: topic,
        wordsHandled: revealedCount,
        spoken: elapsed,
        status: outcome,
      ),
    );
  }

  /// Starts the next player's turn (multiplayer) or a fresh round.
  void nextRound() {
    if (hasNextPlayer) {
      playerIndex++;
    } else {
      playerIndex = 0;
      results.clear();
    }
    _startRound();
    notifyListeners();
  }

  /// Replays the current turn with a new topic and words.
  void restartRound() {
    if (isOver && results.isNotEmpty) {
      results.removeLast();
    }
    _startRound();
    notifyListeners();
  }
}
