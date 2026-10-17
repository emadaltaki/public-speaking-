import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import 'autocomplete_data.dart';

enum AutocompleteMode { singlePlayer, multiplayer }

class AutocompleteSettings {
  const AutocompleteSettings({
    this.mode = AutocompleteMode.singlePlayer,
    this.secondsPerRound = 5,
    this.rounds = 6,
    this.phraseSet = AutocompleteData.mixed,
    this.players = const [],
  });

  static const int minSeconds = 3;
  static const int maxSeconds = 20;
  static const int minRounds = 3;
  static const int maxRounds = 30;

  final AutocompleteMode mode;
  final int secondsPerRound;
  final int rounds;
  final String phraseSet;
  final List<String> players;

  bool get isMultiplayer => mode == AutocompleteMode.multiplayer;

  AutocompleteSettings copyWith({
    AutocompleteMode? mode,
    int? secondsPerRound,
    int? rounds,
    String? phraseSet,
    List<String>? players,
  }) {
    return AutocompleteSettings(
      mode: mode ?? this.mode,
      secondsPerRound: secondsPerRound ?? this.secondsPerRound,
      rounds: rounds ?? this.rounds,
      phraseSet: phraseSet ?? this.phraseSet,
      players: players ?? this.players,
    );
  }
}

enum AutocompletePhase { ready, countdown, running, paused, finished }

/// Autocomplete, rapid fire: a sentence starter appears, the speaker
/// finishes it out loud before the timer runs out, then the next one comes.
/// Time is advanced by [tick] so a screen can drive it and tests can drive
/// it directly.
class AutocompleteGame extends ChangeNotifier {
  AutocompleteGame(this.settings, {math.Random? random})
    : _random = random ?? math.Random() {
    _deal();
  }

  static const Duration countdownLength = Duration(seconds: 3);

  final AutocompleteSettings settings;
  final math.Random _random;

  late List<String> phrases;
  int round = 0;
  AutocompletePhase phase = AutocompletePhase.ready;
  Duration _roundElapsed = Duration.zero;

  /// Total time spent in rounds this game.
  Duration played = Duration.zero;
  Duration _countdown = Duration.zero;

  Duration get perRound => Duration(seconds: settings.secondsPerRound);

  String get phrase => phrases[round];

  Duration get remaining {
    final left = perRound - _roundElapsed;
    return left.isNegative ? Duration.zero : left;
  }

  double get fractionRemaining =>
      remaining.inMilliseconds / perRound.inMilliseconds;

  int get countdownNumber =>
      (countdownLength - _countdown).inSeconds.clamp(0, 2) + 1;

  bool get isOver => phase == AutocompletePhase.finished;

  String? get currentPlayer =>
      settings.isMultiplayer && settings.players.isNotEmpty
      ? settings.players[round % settings.players.length]
      : null;

  void _deal() {
    final pool = List<String>.of(
      AutocompleteData.phrasesFor(settings.phraseSet),
    )..shuffle(_random);
    phrases = [for (var i = 0; i < settings.rounds; i++) pool[i % pool.length]];
    round = 0;
    played = Duration.zero;
    _roundElapsed = Duration.zero;
    _countdown = Duration.zero;
    phase = AutocompletePhase.ready;
  }

  void start() {
    if (phase != AutocompletePhase.ready) return;
    phase = AutocompletePhase.countdown;
    notifyListeners();
  }

  void tick(Duration delta) {
    switch (phase) {
      case AutocompletePhase.countdown:
        _countdown += delta;
        if (_countdown >= countdownLength) {
          phase = AutocompletePhase.running;
        }
      case AutocompletePhase.running:
        _roundElapsed += delta;
        played += delta;
        if (_roundElapsed >= perRound) next();
      case AutocompletePhase.ready:
      case AutocompletePhase.paused:
      case AutocompletePhase.finished:
        return;
    }
    notifyListeners();
  }

  /// Moves to the next sentence (the timer ran out, or the speaker is done).
  void next() {
    if (phase != AutocompletePhase.running &&
        phase != AutocompletePhase.paused) {
      return;
    }
    if (round >= settings.rounds - 1) {
      phase = AutocompletePhase.finished;
    } else {
      round++;
      _roundElapsed = Duration.zero;
      phase = AutocompletePhase.running;
    }
    notifyListeners();
  }

  void togglePause() {
    if (phase == AutocompletePhase.running) {
      phase = AutocompletePhase.paused;
    } else if (phase == AutocompletePhase.paused) {
      phase = AutocompletePhase.running;
    }
    notifyListeners();
  }

  /// New sentences, back on the Ready screen.
  void playAgain() {
    _deal();
    notifyListeners();
  }

  /// Same sentences again, back on the Ready screen.
  void retry() {
    final keep = phrases;
    _deal();
    phrases = keep;
    notifyListeners();
  }
}
