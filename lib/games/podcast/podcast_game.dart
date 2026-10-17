import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import '../topics.dart';

/// How often the microphone moves to someone else.
enum PodcastPace {
  slow('Slow', 12, 18),
  medium('Medium', 8, 12),
  fast('Fast', 5, 8),
  chaos('Chaos', 2, 4);

  const PodcastPace(this.label, this.minSeconds, this.maxSeconds);

  final String label;
  final int minSeconds;
  final int maxSeconds;
}

class PodcastSettings {
  const PodcastSettings({
    this.timerSeconds = 60,
    this.pace = PodcastPace.slow,
    this.playerCount = defaultPlayers,
    this.suggestTitle = true,
    this.wordSet = generalWordSet,
    this.players = const [],
  });

  static const int defaultPlayers = 5;
  static const int minPlayers = 2;
  static const int maxPlayers = 8;
  static const int minTimerSeconds = 30;
  static const int maxTimerSeconds = 600;
  static const int timerStepSeconds = 30;

  final int timerSeconds;
  final PodcastPace pace;
  final int playerCount;
  final bool suggestTitle;
  final String wordSet;
  final List<String> players;

  PodcastSettings copyWith({
    int? timerSeconds,
    PodcastPace? pace,
    int? playerCount,
    bool? suggestTitle,
    String? wordSet,
    List<String>? players,
  }) {
    return PodcastSettings(
      timerSeconds: timerSeconds ?? this.timerSeconds,
      pace: pace ?? this.pace,
      playerCount: playerCount ?? this.playerCount,
      suggestTitle: suggestTitle ?? this.suggestTitle,
      wordSet: wordSet ?? this.wordSet,
      players: players ?? this.players,
    );
  }
}

enum PodcastPhase { ready, countdown, running, paused, finished }

/// The Podcast Game: a group shares one topic and the name on screen is who
/// speaks; it switches to someone else at random. Time is advanced by
/// [tick] so a screen can drive it and tests can drive it directly.
class PodcastGame extends ChangeNotifier {
  PodcastGame(this.settings, {math.Random? random})
    : _random = random ?? math.Random() {
    _newRound();
  }

  static const Duration countdownLength = Duration(seconds: 3);

  final PodcastSettings settings;
  final math.Random _random;

  late String topic;
  PodcastPhase phase = PodcastPhase.ready;
  int speaker = 0;

  /// How many times the microphone has moved (drives animations).
  int switches = 0;
  Duration elapsed = Duration.zero;
  Duration _countdown = Duration.zero;
  Duration _nextSwitchAt = Duration.zero;

  List<String> get players => settings.players.isEmpty
      ? [for (var i = 1; i <= settings.playerCount; i++) 'Player $i']
      : settings.players;

  String get speakerName => players[speaker];

  Duration get total => Duration(seconds: settings.timerSeconds);

  Duration get remaining {
    final left = total - elapsed;
    return left.isNegative ? Duration.zero : left;
  }

  int get countdownNumber =>
      (countdownLength - _countdown).inSeconds.clamp(0, 2) + 1;

  bool get isOver => phase == PodcastPhase.finished;

  void _newRound() {
    topic = pickGameTopic(
      suggestTitle: settings.suggestTitle,
      wordSet: settings.wordSet,
      random: _random,
    );
    phase = PodcastPhase.ready;
    elapsed = Duration.zero;
    _countdown = Duration.zero;
    switches = 0;
    speaker = _random.nextInt(players.length);
  }

  Duration _gap() {
    final p = settings.pace;
    final ms =
        p.minSeconds * 1000 +
        _random.nextInt((p.maxSeconds - p.minSeconds) * 1000 + 1);
    return Duration(milliseconds: ms);
  }

  void start() {
    if (phase != PodcastPhase.ready) return;
    phase = PodcastPhase.countdown;
    notifyListeners();
  }

  void tick(Duration delta) {
    switch (phase) {
      case PodcastPhase.countdown:
        _countdown += delta;
        if (_countdown >= countdownLength) {
          phase = PodcastPhase.running;
          _nextSwitchAt = _gap();
        }
      case PodcastPhase.running:
        elapsed += delta;
        if (elapsed >= total) {
          elapsed = total;
          phase = PodcastPhase.finished;
        } else if (elapsed >= _nextSwitchAt) {
          _switchSpeaker();
          _nextSwitchAt = elapsed + _gap();
        }
      case PodcastPhase.ready:
      case PodcastPhase.paused:
      case PodcastPhase.finished:
        return;
    }
    notifyListeners();
  }

  void _switchSpeaker() {
    if (players.length < 2) return;
    var next = speaker;
    while (next == speaker) {
      next = _random.nextInt(players.length);
    }
    speaker = next;
    switches++;
  }

  void togglePause() {
    if (phase == PodcastPhase.running) {
      phase = PodcastPhase.paused;
    } else if (phase == PodcastPhase.paused) {
      phase = PodcastPhase.running;
    }
    notifyListeners();
  }

  void stop() {
    if (phase != PodcastPhase.running && phase != PodcastPhase.paused) return;
    phase = PodcastPhase.finished;
    notifyListeners();
  }

  void nextRound() {
    _newRound();
    notifyListeners();
  }

  void retry() {
    final keep = topic;
    _newRound();
    topic = keep;
    notifyListeners();
  }
}
