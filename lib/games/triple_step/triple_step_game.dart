import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import 'triple_step_data.dart';

enum TripleStepMode { singlePlayer, multiplayer }

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

  /// How many words the speaker has to work into the speech.
  final int topicCount;
  final int timerSeconds;
  final bool suggestTitle;

  /// Each word gets an equal slice of the time; missing a slice ends the round.
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

enum RoundStatus { running, paused, completed, timeUp, eliminated }

class RoundResult {
  const RoundResult({
    required this.player,
    required this.topic,
    required this.wordsUsed,
    required this.wordCount,
    required this.timeLeft,
    required this.status,
  });

  final String? player;
  final String topic;
  final int wordsUsed;
  final int wordCount;
  final Duration timeLeft;
  final RoundStatus status;

  /// Words used, plus a bonus second-per-point for finishing early.
  int get score =>
      wordsUsed * 10 +
      (status == RoundStatus.completed ? timeLeft.inSeconds : 0);
}

/// Game state for Triple Step. Time is advanced by [tick] so a screen can
/// drive it from a ticker and tests can drive it directly.
class TripleStepGame extends ChangeNotifier {
  TripleStepGame(this.settings, {math.Random? random})
    : _random = random ?? math.Random() {
    _startRound();
  }

  final TripleStepSettings settings;
  final math.Random _random;

  final List<RoundResult> results = [];
  late String topic;
  late List<String> words;
  late List<bool> done;
  int playerIndex = 0;
  RoundStatus status = RoundStatus.running;

  Duration _elapsed = Duration.zero;
  Duration _sliceStart = Duration.zero;

  Duration get total => Duration(seconds: settings.timerSeconds);

  /// Time each word gets in survival mode.
  Duration get slice =>
      Duration(milliseconds: total.inMilliseconds ~/ settings.topicCount);

  /// The time the pie and clock show: the whole round normally, or the
  /// current word's slice in survival mode.
  Duration get countdownTotal => settings.survivalMode ? slice : total;

  Duration get remaining {
    final left = settings.survivalMode
        ? slice - (_elapsed - _sliceStart)
        : total - _elapsed;
    if (left.isNegative) return Duration.zero;
    if (left > countdownTotal) return countdownTotal;
    return left;
  }

  /// Time left in the whole round (used for scoring).
  Duration get roundRemaining {
    final left = total - _elapsed;
    return left.isNegative ? Duration.zero : left;
  }

  double get fractionRemaining => countdownTotal.inMilliseconds == 0
      ? 0
      : remaining.inMilliseconds / countdownTotal.inMilliseconds;

  int get wordsUsed => done.where((d) => d).length;

  bool get isOver =>
      status == RoundStatus.completed ||
      status == RoundStatus.timeUp ||
      status == RoundStatus.eliminated;

  String? get currentPlayer =>
      settings.isMultiplayer && settings.players.isNotEmpty
      ? settings.players[playerIndex]
      : null;

  bool get hasNextPlayer =>
      settings.isMultiplayer && playerIndex < settings.players.length - 1;

  void _startRound() {
    topic = settings.suggestTitle
        ? TripleStepData.topics[_random.nextInt(TripleStepData.topics.length)]
        : 'Your Own Topic';
    final pool = List<String>.of(
      TripleStepData.wordSets[settings.wordSet] ??
          TripleStepData.wordSets.values.first,
    )..shuffle(_random);
    words = pool.take(settings.topicCount).toList();
    done = List<bool>.filled(words.length, false);
    _elapsed = Duration.zero;
    _sliceStart = Duration.zero;
    status = RoundStatus.running;
  }

  /// Advances the clock by [delta] while the round is running.
  void tick(Duration delta) {
    if (status != RoundStatus.running) return;
    _elapsed += delta;
    if (settings.survivalMode && _elapsed - _sliceStart >= slice) {
      _finish(RoundStatus.eliminated);
    } else if (_elapsed >= total) {
      _finish(RoundStatus.timeUp);
    }
    notifyListeners();
  }

  void toggle(int index) {
    if (isOver) return;
    done[index] = !done[index];
    if (done[index] && settings.survivalMode) {
      _sliceStart = _elapsed;
    }
    if (done.every((d) => d)) {
      _finish(RoundStatus.completed);
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

  /// Ends the round early, keeping the words used so far.
  void finishEarly() {
    if (isOver) return;
    _finish(done.every((d) => d) ? RoundStatus.completed : RoundStatus.timeUp);
    notifyListeners();
  }

  void _finish(RoundStatus outcome) {
    status = outcome;
    results.add(
      RoundResult(
        player: currentPlayer,
        topic: topic,
        wordsUsed: wordsUsed,
        wordCount: words.length,
        timeLeft: roundRemaining,
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
