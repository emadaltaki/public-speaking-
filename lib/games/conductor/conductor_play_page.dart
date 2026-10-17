import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../../theme/colors.dart';
import '../../theme/styles.dart';
import '../../translations/translations.dart';
import '../game_catalog.dart';
import '../game_theme.dart';
import 'conductor_game.dart';

class ConductorPlayPage extends StatefulWidget {
  const ConductorPlayPage({super.key, required this.settings, this.random});

  final ConductorSettings settings;

  /// Injectable for tests that need predictable topics and levels.
  final math.Random? random;

  @override
  State<ConductorPlayPage> createState() => _ConductorPlayPageState();
}

class _ConductorPlayPageState extends State<ConductorPlayPage>
    with SingleTickerProviderStateMixin {
  late final ConductorGame _game = ConductorGame(
    widget.settings,
    random: widget.random,
  );
  late final Ticker _ticker = createTicker(_onTick);
  Duration _last = Duration.zero;

  /// Drives the background waves; separate from game time so it keeps
  /// moving gently on the Ready screen.
  double _wave = 0;

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
    final seconds = delta.inMicroseconds / 1e6;
    // Higher pitch, faster waves.
    final paused = _game.phase == ConductorPhase.paused || _game.isOver;
    if (!paused) {
      _wave += seconds * (0.6 + _game.level * 0.35);
    }
    _game.tick(delta);
    setState(() {});
  }

  void _changed() => setState(() {});

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
    if (_game.phase == ConductorPhase.ready) {
      _game.start();
    } else {
      _game.togglePause();
    }
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 820;
    final showLevel =
        _game.phase == ConductorPhase.running ||
        _game.phase == ConductorPhase.paused ||
        _game.isOver;

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): _exit,
        const SingleActivator(LogicalKeyboardKey.space): _space,
      },
      child: Focus(
        autofocus: true,
        child: Title(
          title: 'The Conductor | ${Translations.siteName}',
          color: AppColors.navy,
          child: Scaffold(
            backgroundColor: AppColors.navyDeep,
            body: Stack(
              children: [
                Positioned.fill(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(end: (showLevel ? _game.level : 4).toDouble()),
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.easeInOut,
                    builder: (context, level, _) => CustomPaint(
                      painter: PitchBackgroundPainter(
                        level: level,
                        phase: _wave,
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _TopBar(onBack: _back, onExit: _exit),
                      Expanded(child: Center(child: _centre(wide))),
                      if (showLevel) _bottomBar(wide),
                    ],
                  ),
                ),
                if (_game.isOver)
                  Positioned.fill(
                    child: _Finished(
                      spoken: _game.elapsed,
                      onNext: _game.nextRound,
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

  Widget _centre(bool wide) {
    final white = AppStyles.display.copyWith(color: Colors.white);
    switch (_game.phase) {
      case ConductorPhase.ready:
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                Translations.conductorReady.toUpperCase(),
                style: AppStyles.eyebrow.copyWith(
                  color: GameColors.accent,
                  fontSize: 16,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _game.topic.toUpperCase(),
                textAlign: TextAlign.center,
                style: white.copyWith(fontSize: wide ? 56 : 34),
              ),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Text(
                  Translations.conductorReadyHint,
                  textAlign: TextAlign.center,
                  style: AppStyles.body.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: _game.start,
                style: FilledButton.styleFrom(
                  backgroundColor: GameColors.accent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(220, 58),
                  shape: const StadiumBorder(),
                  textStyle: AppStyles.label.copyWith(
                    fontSize: 17,
                    letterSpacing: 1.4,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                icon: const Icon(Icons.play_arrow_rounded, size: 26),
                label: const Text(Translations.conductorStart),
              ),
            ],
          ),
        );
      case ConductorPhase.countdown:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _game.topic.toUpperCase(),
              textAlign: TextAlign.center,
              style: white.copyWith(fontSize: wide ? 32 : 24),
            ),
            const SizedBox(height: 12),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, a) =>
                  ScaleTransition(scale: a, child: child),
              child: Text(
                '${_game.countdownNumber}',
                key: ValueKey(_game.countdownNumber),
                style: white.copyWith(
                  fontSize: wide ? 220 : 160,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ),
          ],
        );
      case ConductorPhase.running:
      case ConductorPhase.paused:
      case ConductorPhase.finished:
        return _levelDisplay(wide);
    }
  }

  Widget _levelDisplay(bool wide) {
    final level = _game.level;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          Translations.conductorPitch.toUpperCase(),
          style: AppStyles.eyebrow.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 15,
            letterSpacing: 4,
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, a) => ScaleTransition(
            scale: Tween(
              begin: 0.6,
              end: 1.0,
            ).animate(CurvedAnimation(parent: a, curve: Curves.easeOutBack)),
            child: FadeTransition(opacity: a, child: child),
          ),
          child: Semantics(
            key: ValueKey('level-${_game.changes}'),
            liveRegion: true,
            label: 'Pitch $level of 10, ${_describe(level)}',
            child: ExcludeSemantics(
              child: Text(
                '$level',
                style: AppStyles.display.copyWith(
                  color: Colors.white,
                  fontSize: wide ? 260 : 180,
                  fontWeight: FontWeight.w900,
                  height: 1,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 24,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Text(
          _describe(level),
          style: AppStyles.title.copyWith(color: Colors.white, fontSize: 22),
        ),
        const SizedBox(height: 18),
        _LevelMeter(level: level),
        if (_game.phase == ConductorPhase.paused) ...[
          const SizedBox(height: 18),
          Text(
            Translations.conductorPaused,
            style: AppStyles.label.copyWith(color: Colors.white),
          ),
        ],
      ],
    );
  }

  static String _describe(int level) {
    if (level <= 2) return Translations.conductorLevelLow;
    if (level <= 4) return Translations.conductorLevelLowMid;
    if (level <= 6) return Translations.conductorLevelMid;
    if (level <= 8) return Translations.conductorLevelHighMid;
    return Translations.conductorLevelHigh;
  }

  Widget _bottomBar(bool wide) {
    final left = _game.remaining;
    final clock =
        '${left.inMinutes.toString().padLeft(2, '0')}:${(left.inSeconds % 60).toString().padLeft(2, '0')}';
    final paused = _game.phase == ConductorPhase.paused;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, wide ? 28 : 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  Translations.conductorTopic.toUpperCase(),
                  style: AppStyles.eyebrow.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _game.topic,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.title.copyWith(
                    color: Colors.white,
                    fontSize: wide ? 26 : 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
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
                  _RoundIcon(
                    icon: paused
                        ? Icons.play_arrow_rounded
                        : Icons.pause_rounded,
                    tooltip: paused
                        ? Translations.tripleStepResume
                        : Translations.tripleStepPause,
                    onPressed: _game.isOver ? null : _game.togglePause,
                  ),
                  const SizedBox(width: 8),
                  _RoundIcon(
                    icon: Icons.flag_rounded,
                    tooltip: Translations.tripleStepFinish,
                    onPressed: _game.isOver ? null : _game.stop,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                clock,
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

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack, required this.onExit});

  final VoidCallback onBack;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    final style = IconButton.styleFrom(
      backgroundColor: Colors.white.withValues(alpha: 0.15),
      foregroundColor: Colors.white,
      minimumSize: const Size(48, 48),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Row(
        children: [
          IconButton(
            tooltip: Translations.tripleStepBackToSettings,
            onPressed: onBack,
            style: style,
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          const Spacer(),
          TextButton(
            onPressed: onExit,
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.white.withValues(alpha: 0.15),
              minimumSize: const Size(48, 48),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: const StadiumBorder(),
              textStyle: AppStyles.label,
            ),
            child: const Text('× (Esc)'),
          ),
        ],
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: 0.15),
        foregroundColor: Colors.white,
        minimumSize: const Size(44, 44),
      ),
      icon: Icon(icon),
    );
  }
}

/// Ten bars with the current level lit, so the number reads at a glance.
class _LevelMeter extends StatelessWidget {
  const _LevelMeter({required this.level});

  final int level;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var i = 1; i <= 10; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: 14,
            height: 10.0 + i * 4,
            decoration: BoxDecoration(
              color: i <= level
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
      ],
    );
  }
}

/// Background that "sounds" like the pitch: deep calm blues with slow,
/// wide waves at 1, hot reds with fast, tight waves at 10.
class PitchBackgroundPainter extends CustomPainter {
  const PitchBackgroundPainter({required this.level, required this.phase});

  /// 1–10, may be fractional while animating between levels.
  final double level;
  final double phase;

  static const _low = [Color(0xFF0B1E3A), Color(0xFF1C4E80)];
  static const _mid = [Color(0xFF1F6F6B), Color(0xFFD9932F)];
  static const _high = [Color(0xFFB8322A), Color(0xFFFF8A2B)];

  List<Color> _colors() {
    final t = ((level - 1) / 9).clamp(0.0, 1.0);
    if (t < 0.5) {
      final k = t / 0.5;
      return [
        Color.lerp(_low[0], _mid[0], k)!,
        Color.lerp(_low[1], _mid[1], k)!,
      ];
    }
    final k = (t - 0.5) / 0.5;
    return [
      Color.lerp(_mid[0], _high[0], k)!,
      Color.lerp(_mid[1], _high[1], k)!,
    ];
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final colors = _colors();
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ).createShader(rect),
    );

    final t = ((level - 1) / 9).clamp(0.0, 1.0);
    // More, tighter, taller waves as pitch rises.
    final cycles = 1.2 + t * 7;
    final amplitude = size.height * (0.03 + t * 0.07);
    const lines = 5;
    for (var i = 0; i < lines; i++) {
      final y0 = size.height * (0.55 + i * 0.08);
      final path = Path()..moveTo(0, y0);
      for (double x = 0; x <= size.width; x += 6) {
        final angle = (x / size.width) * cycles * 2 * math.pi + phase + i * 0.9;
        path.lineTo(x, y0 + math.sin(angle) * amplitude * (1 - i * 0.12));
      }
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..color = Colors.white.withValues(alpha: 0.10 + 0.04 * (lines - i)),
      );
    }

    // Darken the bottom so the topic and clock stay readable.
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.55, 1],
          colors: [Colors.transparent, Colors.black.withValues(alpha: 0.45)],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(PitchBackgroundPainter old) =>
      old.level != level || old.phase != phase;
}

class _Finished extends StatelessWidget {
  const _Finished({
    required this.spoken,
    required this.onNext,
    required this.onRetry,
    required this.onSettings,
  });

  final Duration spoken;
  final VoidCallback onNext;
  final VoidCallback onRetry;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    final clock =
        '${spoken.inMinutes}:${(spoken.inSeconds % 60).toString().padLeft(2, '0')}';
    return ColoredBox(
      color: AppColors.navyDeep.withValues(alpha: 0.55),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: AppStyles.elevatedShadow,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        color: GameColors.accentSoft,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.emoji_events_rounded,
                        size: 38,
                        color: GameColors.accent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    Translations.tripleStepTimeUp,
                    textAlign: TextAlign.center,
                    style: AppStyles.title.copyWith(fontSize: 24),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You spoke for $clock.',
                    textAlign: TextAlign.center,
                    style: AppStyles.body,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: onNext,
                    style: FilledButton.styleFrom(
                      backgroundColor: GameColors.accent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(52),
                      shape: const StadiumBorder(),
                      textStyle: AppStyles.label.copyWith(fontSize: 16),
                    ),
                    child: const Text(Translations.tripleStepNextTopic),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onRetry,
                          style: AppStyles.secondaryButton,
                          child: const Text(Translations.tripleStepRetry),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onSettings,
                          style: AppStyles.secondaryButton,
                          child: const Text(Translations.tripleStepSettings),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
