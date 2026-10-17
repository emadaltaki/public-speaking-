import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../../account/progress_store.dart';
import '../../theme/colors.dart';
import '../../theme/styles.dart';
import '../../translations/translations.dart';
import '../game_catalog.dart';
import '../widgets/game_setup.dart';
import 'podcast_game.dart';

class PodcastPlayPage extends StatefulWidget {
  const PodcastPlayPage({super.key, required this.settings, this.random});

  final PodcastSettings settings;
  final math.Random? random;

  @override
  State<PodcastPlayPage> createState() => _PodcastPlayPageState();
}

class _PodcastPlayPageState extends State<PodcastPlayPage>
    with SingleTickerProviderStateMixin {
  late final PodcastGame _game = PodcastGame(
    widget.settings,
    random: widget.random,
  );
  late final Ticker _ticker = createTicker(_onTick);
  Duration _last = Duration.zero;

  @override
  void initState() {
    super.initState();
    _game.addListener(_changed);
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _game
      ..removeListener(_changed)
      ..dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    final delta = elapsed - _last;
    _last = elapsed;
    _game.tick(delta);
  }

  bool _recorded = false;

  /// Saves the round to the visitor's history once, when it ends.
  void _recordIfOver({required Duration spoken, String? topic}) {
    if (!_game.isOver) {
      _recorded = false;
      return;
    }
    if (_recorded) return;
    _recorded = true;
    ProgressStore.instance.record(
      GameSession(
        gameId: GameCatalog.podcast.id,
        playedAt: DateTime.now(),
        spoken: spoken,
        topic: topic,
      ),
    );
  }

  void _changed() {
    _recordIfOver(spoken: _game.elapsed, topic: _game.topic);
    setState(() {});
  }

  void _back() => Navigator.of(context).maybePop();

  void _exit() {
    Navigator.of(context).popUntil(
      (route) => route.settings.name == AppRoutes.games || route.isFirst,
    );
    if (ModalRoute.of(context)?.isCurrent ?? false) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.games);
    }
  }

  void _space() {
    if (_game.phase == PodcastPhase.ready) {
      _game.start();
    } else {
      _game.togglePause();
    }
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 820;
    final live =
        _game.phase == PodcastPhase.running ||
        _game.phase == PodcastPhase.paused ||
        _game.isOver;

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): _exit,
        const SingleActivator(LogicalKeyboardKey.space): _space,
      },
      child: Focus(
        autofocus: true,
        child: Title(
          title: '${GameCatalog.podcast.title} | ${Translations.siteName}',
          color: AppColors.navy,
          child: Scaffold(
            backgroundColor: live ? AppColors.panel : AppColors.surface,
            body: Stack(
              children: [
                SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GamePlayTopBar(onBack: _back, onExit: _exit, dark: live),
                      Expanded(
                        child: live
                            ? Center(child: _speaker(wide))
                            : GameReadyView(
                                topic: _game.topic,
                                cue: GameReadyView.cueFor(
                                  waiting: _game.phase == PodcastPhase.ready,
                                  countdownNumber: _game.countdownNumber,
                                ),
                                hint: _game.phase == PodcastPhase.ready
                                    ? Translations.podcastReadyHint
                                    : null,
                                onStart: _game.phase == PodcastPhase.ready
                                    ? _game.start
                                    : null,
                              ),
                      ),
                      if (live) _bottomBar(wide),
                    ],
                  ),
                ),
                if (_game.isOver)
                  Positioned.fill(
                    child: GameEndCard(
                      title: Translations.tripleStepTimeUp,
                      message: Translations.podcastEnd,
                      primaryLabel: Translations.tripleStepNextTopic,
                      onPrimary: _game.nextRound,
                      onRetry: _game.retry,
                      onSettings: _back,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _speaker(bool wide) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            Translations.podcastNowSpeaking.toUpperCase(),
            style: AppStyles.eyebrow.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 12),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, a) => ScaleTransition(
              scale: Tween(
                begin: 0.7,
                end: 1.0,
              ).animate(CurvedAnimation(parent: a, curve: Curves.easeOutBack)),
              child: FadeTransition(opacity: a, child: child),
            ),
            child: Semantics(
              key: ValueKey('speaker-${_game.switches}'),
              liveRegion: true,
              label: Translations.isSpeaking(_game.speakerName),
              child: ExcludeSemantics(
                child: Text(
                  _game.speakerName,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: AppStyles.display.copyWith(
                    color: AppColors.headerBand,
                    fontSize: wide ? 120 : 64,
                    fontWeight: FontWeight.w900,
                    height: 1.05,
                  ),
                ),
              ),
            ),
          ),
          if (_game.phase == PodcastPhase.paused) ...[
            const SizedBox(height: 18),
            Text(
              Translations.conductorPaused,
              style: AppStyles.label.copyWith(color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }

  Widget _bottomBar(bool wide) {
    final paused = _game.phase == PodcastPhase.paused;
    final buttonStyle = IconButton.styleFrom(
      backgroundColor: Colors.white.withValues(alpha: 0.15),
      foregroundColor: Colors.white,
      minimumSize: const Size(44, 44),
    );
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, wide ? 28 : 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              _game.topic.toUpperCase(),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.title.copyWith(
                color: Colors.white,
                fontSize: wide ? 26 : 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: paused
                        ? Translations.tripleStepResume
                        : Translations.tripleStepPause,
                    onPressed: _game.isOver ? null : _game.togglePause,
                    style: buttonStyle,
                    icon: Icon(
                      paused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: Translations.tripleStepFinish,
                    onPressed: _game.isOver ? null : _game.stop,
                    style: buttonStyle,
                    icon: const Icon(Icons.flag_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                gameClock(_game.remaining),
                style: AppStyles.display.copyWith(
                  color: Colors.white,
                  fontSize: wide ? 48 : 34,
                  fontWeight: FontWeight.w800,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
