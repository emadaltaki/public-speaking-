import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../../account/progress_store.dart';
import '../../theme/colors.dart';
import '../../theme/styles.dart';
import '../../translations/translations.dart';
import '../game_catalog.dart';
import '../game_theme.dart';
import 'triple_step_game.dart';

/// Phase 2: the active game screen.
class TripleStepPlayPage extends StatefulWidget {
  const TripleStepPlayPage({super.key, required this.settings, this.random});

  final TripleStepSettings settings;

  /// Injectable for tests that need predictable topics and words.
  final math.Random? random;

  @override
  State<TripleStepPlayPage> createState() => _TripleStepPlayPageState();
}

class _TripleStepPlayPageState extends State<TripleStepPlayPage>
    with SingleTickerProviderStateMixin {
  late final TripleStepGame _game = TripleStepGame(
    widget.settings,
    random: widget.random,
  );
  late final Ticker _ticker = createTicker(_onTick);
  Duration _lastTick = Duration.zero;

  @override
  void initState() {
    super.initState();
    _game.addListener(_onGameChanged);
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _game
      ..removeListener(_onGameChanged)
      ..dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    final delta = elapsed - _lastTick;
    _lastTick = elapsed;
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
        gameId: GameCatalog.tripleStep.id,
        playedAt: DateTime.now(),
        spoken: spoken,
        topic: topic,
      ),
    );
  }

  void _onGameChanged() {
    _recordIfOver(
      spoken: _game.isOver ? _game.results.last.spoken : Duration.zero,
      topic: _game.topic,
    );
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final wide = size.width >= 820;

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): _exit,
        const SingleActivator(LogicalKeyboardKey.space): _game.togglePause,
      },
      child: Focus(
        autofocus: true,
        child: Title(
          title: 'Triple Step | ${Translations.siteName}',
          color: AppColors.navy,
          child: Scaffold(
            backgroundColor: GameColors.background,
            body: SafeArea(
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _TopBar(onBack: _back, onExit: _exit),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.fromLTRB(
                            20,
                            wide ? 8 : 0,
                            20,
                            32,
                          ),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 1040),
                              child: Column(
                                children: [
                                  _header(wide),
                                  SizedBox(height: wide ? 40 : 24),
                                  if (wide)
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(child: _timerPanel(wide)),
                                        const SizedBox(width: 48),
                                        Expanded(child: _wordsPanel()),
                                      ],
                                    )
                                  else ...[
                                    _timerPanel(wide),
                                    const SizedBox(height: 28),
                                    _wordsPanel(),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_game.isOver)
                    Positioned.fill(
                      child: _ResultsOverlay(
                        game: _game,
                        onNext: _game.nextRound,
                        onReplay: _game.restartRound,
                        onSettings: _back,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(bool wide) {
    final player = _game.currentPlayer;
    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            if (player != null)
              _Badge(
                icon: Icons.person_rounded,
                text:
                    '${Translations.turnOf(player)} · ${_game.playerIndex + 1}/${_game.settings.players.length}',
                strong: true,
              ),
            _Badge(icon: Icons.style_outlined, text: _game.settings.wordSet),
            if (_game.settings.survivalMode)
              _Badge(
                icon: Icons.local_fire_department_rounded,
                text: Translations.tripleStepSurvival,
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          _game.topic.toUpperCase(),
          textAlign: TextAlign.center,
          style: AppStyles.display.copyWith(
            fontSize: wide ? 48 : 30,
            letterSpacing: wide ? 1 : 0.5,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _game.settings.survivalMode
              ? Translations.tripleStepSurvivalInstruction
              : Translations.tripleStepInstruction,
          textAlign: TextAlign.center,
          style: AppStyles.bodySmall,
        ),
      ],
    );
  }

  Widget _timerPanel(bool wide) {
    final survival = _game.settings.survivalMode;
    // Survival counts speaking time up; normal rounds count down.
    final shown = survival ? _game.elapsed : _game.remaining;
    final low = !survival && _game.fractionRemaining <= 0.2;
    final minutes = shown.inMinutes.toString().padLeft(2, '0');
    final seconds = (shown.inSeconds % 60).toString().padLeft(2, '0');
    final paused = _game.status == RoundStatus.paused;

    return Column(
      children: [
        SizedBox.square(
          dimension: wide ? 280 : 170,
          child: Semantics(
            label: survival
                ? Translations.spokenFor('$minutes:$seconds')
                : Translations.timeRemaining('$minutes:$seconds'),
            child: CustomPaint(
              painter: PieTimerPainter(
                fraction: _game.fractionRemaining,
                color: low ? const Color(0xFFD9534F) : GameColors.accent,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          '$minutes:$seconds',
          style: AppStyles.display.copyWith(
            fontSize: wide ? 72 : 48,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
            color: low ? const Color(0xFFB83B37) : AppColors.navy,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        if (survival)
          Text(Translations.tripleStepSpokenFor, style: AppStyles.bodySmall),
        const SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: [
            OutlinedButton.icon(
              onPressed: _game.isOver ? null : _game.togglePause,
              style: AppStyles.secondaryButton,
              icon: Icon(
                paused ? Icons.play_arrow_rounded : Icons.pause_rounded,
              ),
              label: Text(
                paused
                    ? Translations.tripleStepResume
                    : Translations.tripleStepPause,
              ),
            ),
            OutlinedButton.icon(
              onPressed: _game.isOver ? null : _game.stop,
              style: AppStyles.secondaryButton,
              icon: Icon(
                survival ? Icons.front_hand_rounded : Icons.flag_rounded,
              ),
              label: Text(
                survival
                    ? Translations.tripleStepStuck
                    : Translations.tripleStepFinish,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _wordsPanel() {
    final words = _game.revealed;
    final next = _game.nextWordIn;
    final survival = _game.settings.survivalMode;
    final step = _game.interval.inMilliseconds;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppStyles.softShadow,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(Translations.tripleStepWords, style: AppStyles.label),
              const Spacer(),
              Text(
                survival
                    ? '${words.length}'
                    : '${words.length} / ${_game.settings.topicCount}',
                style: AppStyles.label.copyWith(color: GameColors.accentDark),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (next != null) ...[
            Row(
              children: [
                Icon(
                  Icons.hourglass_top_rounded,
                  size: 16,
                  color: AppColors.mutedText,
                ),
                const SizedBox(width: 6),
                Text(
                  '${Translations.tripleStepNextWordIn} ${Translations.seconds(next.inSeconds + 1)}',
                  style: AppStyles.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: 1 - next.inMilliseconds / step,
                minHeight: 6,
                backgroundColor: GameColors.track,
                color: GameColors.accent,
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (words.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                Translations.tripleStepFirstWordSoon,
                textAlign: TextAlign.center,
                style: AppStyles.body.copyWith(color: AppColors.mutedText),
              ),
            ),
          // Newest word first, so the one to use now is always on top.
          for (var i = words.length - 1; i >= 0; i--)
            _WordTile(
              key: ValueKey('word-$i'),
              word: words[i],
              isNew: i == words.length - 1,
            ),
          for (var i = 0; i < _game.upcomingCount; i++) const _UpcomingTile(),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Row(
        children: [
          IconButton(
            tooltip: Translations.tripleStepBackToSettings,
            onPressed: onBack,
            style: IconButton.styleFrom(
              backgroundColor: AppColors.surface,
              minimumSize: const Size(48, 48),
            ),
            icon: Icon(Icons.arrow_back_rounded, color: AppColors.navy),
          ),
          const Spacer(),
          TextButton(
            onPressed: onExit,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.navy,
              backgroundColor: AppColors.surface,
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

class _Badge extends StatelessWidget {
  const _Badge({required this.icon, required this.text, this.strong = false});

  final IconData icon;
  final String text;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: strong ? GameColors.accent : GameColors.accentSoft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: strong ? Colors.white : GameColors.accentDark,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: AppStyles.label.copyWith(
              fontSize: 13,
              color: strong ? Colors.white : GameColors.accentDark,
            ),
          ),
        ],
      ),
    );
  }
}

/// A word that has appeared. The newest one is large and highlighted, and
/// pops in so the speaker notices it.
class _WordTile extends StatelessWidget {
  const _WordTile({super.key, required this.word, required this.isNew});

  final String word;
  final bool isNew;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutBack,
      builder: (context, t, child) => Opacity(
        opacity: t.clamp(0, 1),
        child: Transform.scale(scale: 0.9 + 0.1 * t, child: child),
      ),
      child: Semantics(
        liveRegion: isNew,
        label: isNew ? Translations.newWord(word) : word,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: isNew ? 20 : 12,
          ),
          decoration: BoxDecoration(
            color: isNew ? GameColors.accent : GameColors.accentSoft,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Expanded(
                child: ExcludeSemantics(
                  child: Text(
                    word,
                    style: AppStyles.title.copyWith(
                      fontSize: isNew ? 28 : 18,
                      fontWeight: isNew ? FontWeight.w800 : FontWeight.w600,
                      color: isNew ? Colors.white : AppColors.navy,
                    ),
                  ),
                ),
              ),
              if (isNew)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    Translations.tripleStepNew,
                    style: AppStyles.label.copyWith(
                      color: Colors.white,
                      fontSize: 11,
                      letterSpacing: 1,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Placeholder for a word that hasn't appeared yet.
class _UpcomingTile extends StatelessWidget {
  const _UpcomingTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: GameColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: GameColors.track),
      ),
      child: Row(
        children: [
          Icon(Icons.lock_clock_outlined, size: 18, color: AppColors.mutedText),
          const SizedBox(width: 10),
          Text(Translations.tripleStepComingUp, style: AppStyles.bodySmall),
        ],
      ),
    );
  }
}

/// Filled pie that shrinks clockwise from 12 o'clock as time runs out.
class PieTimerPainter extends CustomPainter {
  const PieTimerPainter({required this.fraction, required this.color});

  final double fraction;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    canvas.drawCircle(center, radius, Paint()..color = GameColors.track);
    final rect = Rect.fromCircle(center: center, radius: radius - 6);
    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * fraction.clamp(0, 1),
      true,
      Paint()..color = color,
    );
    canvas.drawCircle(center, radius * 0.08, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(PieTimerPainter old) =>
      old.fraction != fraction || old.color != color;
}

class _ResultsOverlay extends StatelessWidget {
  const _ResultsOverlay({
    required this.game,
    required this.onNext,
    required this.onReplay,
    required this.onSettings,
  });

  final TripleStepGame game;
  final VoidCallback onNext;
  final VoidCallback onReplay;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    final last = game.results.last;
    final (icon, title) = switch (last.status) {
      RoundStatus.finished => (
        Icons.emoji_events_rounded,
        Translations.tripleStepTimeUp,
      ),
      _ => (Icons.flag_rounded, Translations.tripleStepRoundEnded),
    };
    String clock(Duration d) =>
        '${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';
    final multiplayerDone = game.settings.isMultiplayer && !game.hasNextPlayer;

    return ColoredBox(
      color: AppColors.navyDeep.withValues(alpha: 0.55),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppColors.surface,
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
                      decoration: BoxDecoration(
                        color: GameColors.accentSoft,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, size: 38, color: GameColors.accent),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    last.player == null ? title : '${last.player}: $title',
                    textAlign: TextAlign.center,
                    style: AppStyles.title.copyWith(fontSize: 24),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    Translations.youSpokeFor(clock(last.spoken)),
                    textAlign: TextAlign.center,
                    style: AppStyles.body,
                  ),
                  if (multiplayerDone) ...[
                    const SizedBox(height: 20),
                    Text(
                      Translations.tripleStepEveryoneWent,
                      style: AppStyles.label,
                    ),
                    const SizedBox(height: 8),
                    for (final turn in game.results)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              size: 18,
                              color: GameColors.accent,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                turn.player ?? '',
                                style: AppStyles.body,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                turn.topic,
                                textAlign: TextAlign.end,
                                overflow: TextOverflow.ellipsis,
                                style: AppStyles.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
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
                    child: Text(
                      game.hasNextPlayer
                          ? '${Translations.tripleStepNextPlayer}: ${game.settings.players[game.playerIndex + 1]}'
                          : multiplayerDone
                          ? Translations.tripleStepNewGame
                          : Translations.tripleStepNextTopic,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onReplay,
                          style: AppStyles.secondaryButton,
                          child: Text(Translations.tripleStepRetry),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onSettings,
                          style: AppStyles.secondaryButton,
                          child: Text(Translations.tripleStepSettings),
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
