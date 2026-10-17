import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import '../topics.dart';

class ConductorSettings {
  const ConductorSettings({
    this.timerSeconds = defaultTimerSeconds,
    this.suggestTitle = true,
    this.wordSet = generalSet,
  });

  static const int defaultTimerSeconds = 60;
  static const int minTimerSeconds = 30;
  static const int maxTimerSeconds = 300;
  static const int timerStepSeconds = 30;

  /// "General" draws from the full topic list; other sets turn one of their
  /// words into the topic.
  static const String generalSet = generalWordSet;

  final int timerSeconds;
  final bool suggestTitle;
  final String wordSet;

  ConductorSettings copyWith({
    int? timerSeconds,
    bool? suggestTitle,
    String? wordSet,
  }) {
    return ConductorSettings(
      timerSeconds: timerSeconds ?? this.timerSeconds,
      suggestTitle: suggestTitle ?? this.suggestTitle,
      wordSet: wordSet ?? this.wordSet,
    );
  }
}

enum ConductorPhase {
  /// Topic shown, waiting for the speaker to start.
  ready,

  /// 3-2-1 before the round.
  countdown,
  running,
  paused,
  finished,
}

/// The Conductor: the speaker talks on a topic while a pitch level from
/// 1 (low) to 10 (high) changes at random, and matches their voice to it.
/// Time is advanced by [tick] so a screen can drive it from a ticker and
/// tests can drive it directly.
class ConductorGame extends ChangeNotifier {
  ConductorGame(this.settings, {math.Random? random})
    : _random = random ?? math.Random() {
    _newRound();
  }

  static const int minLevel = 1;
  static const int maxLevel = 10;
  static const Duration countdownLength = Duration(seconds: 3);

  /// A new pitch is called every 4–8 seconds.
  static const int minChangeMs = 4000;
  static const int maxChangeMs = 8000;

  final ConductorSettings settings;
  final math.Random _random;

  late String topic;
  ConductorPhase phase = ConductorPhase.ready;
  int level = 5;

  /// How many times the pitch has changed this round (drives animations).
  int changes = 0;

  Duration elapsed = Duration.zero;
  Duration _countdown = Duration.zero;
  Duration _nextChangeAt = Duration.zero;

  Duration get total => Duration(seconds: settings.timerSeconds);

  Duration get remaining {
    final left = total - elapsed;
    return left.isNegative ? Duration.zero : left;
  }

  /// 3, 2, 1 during the countdown.
  int get countdownNumber =>
      (countdownLength - _countdown).inSeconds.clamp(0, 2) + 1;

  bool get isOver => phase == ConductorPhase.finished;

  void _newRound() {
    topic = _pickTopic();
    phase = ConductorPhase.ready;
    elapsed = Duration.zero;
    _countdown = Duration.zero;
    changes = 0;
    level = _randomLevel(avoid: null);
  }

  String _pickTopic() => pickGameTopic(
    suggestTitle: settings.suggestTitle,
    wordSet: settings.wordSet,
    random: _random,
  );

  /// Picks a level that differs clearly from [avoid], so every change is
  /// noticeable.
  int _randomLevel({required int? avoid}) {
    while (true) {
      final next = minLevel + _random.nextInt(maxLevel - minLevel + 1);
      if (avoid == null || (next - avoid).abs() >= 3) return next;
    }
  }

  Duration _randomGap() => Duration(
    milliseconds: minChangeMs + _random.nextInt(maxChangeMs - minChangeMs + 1),
  );

  /// The speaker is ready: run the 3-2-1.
  void start() {
    if (phase != ConductorPhase.ready) return;
    phase = ConductorPhase.countdown;
    _countdown = Duration.zero;
    notifyListeners();
  }

  void tick(Duration delta) {
    switch (phase) {
      case ConductorPhase.countdown:
        _countdown += delta;
        if (_countdown >= countdownLength) {
          phase = ConductorPhase.running;
          _nextChangeAt = _randomGap();
        }
      case ConductorPhase.running:
        elapsed += delta;
        if (elapsed >= total) {
          elapsed = total;
          phase = ConductorPhase.finished;
        } else if (elapsed >= _nextChangeAt) {
          level = _randomLevel(avoid: level);
          changes++;
          _nextChangeAt = elapsed + _randomGap();
        }
      case ConductorPhase.ready:
      case ConductorPhase.paused:
      case ConductorPhase.finished:
        return;
    }
    notifyListeners();
  }

  void togglePause() {
    if (phase == ConductorPhase.running) {
      phase = ConductorPhase.paused;
    } else if (phase == ConductorPhase.paused) {
      phase = ConductorPhase.running;
    }
    notifyListeners();
  }

  /// Ends the round now.
  void stop() {
    if (phase != ConductorPhase.running && phase != ConductorPhase.paused) {
      return;
    }
    phase = ConductorPhase.finished;
    notifyListeners();
  }

  /// A fresh topic, back on the Ready screen.
  void nextRound() {
    _newRound();
    notifyListeners();
  }

  /// Same topic again, back on the Ready screen.
  void retry() {
    final keep = topic;
    _newRound();
    topic = keep;
    notifyListeners();
  }
}
