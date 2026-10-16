import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

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

  void _onGameChanged() => setState(() {});

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
        for (var i = 0; i < _game.words.length && i < 9; i++)
          SingleActivator(LogicalKeyboardKey(0x31 + i)): () => _game.toggle(i),
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
                                        Expanded(child: _checklist()),
                                      ],
                                    )
                                  else ...[
                                    _timerPanel(wide),
                                    const SizedBox(height: 28),
                                    _checklist(),
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
                    "$player's turn · ${_game.playerIndex + 1}/${_game.settings.players.length}",
                strong: true,
              ),
            _Badge(icon: Icons.style_outlined, text: _game.settings.wordSet),
            if (_game.settings.survivalMode)
              const _Badge(
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
    final remaining = _game.remaining;
    final low = _game.fractionRemaining <= 0.2;
    final minutes = remaining.inMinutes.toString().padLeft(2, '0');
    final seconds = (remaining.inSeconds % 60).toString().padLeft(2, '0');
    final paused = _game.status == RoundStatus.paused;

    return Column(
      children: [
        SizedBox.square(
          dimension: wide ? 280 : 170,
          child: Semantics(
            label: 'Time remaining $minutes:$seconds',
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
        if (_game.settings.survivalMode)
          Text(
            Translations.tripleStepNextWordTimer,
            style: AppStyles.bodySmall,
          ),
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
              onPressed: _game.isOver ? null : _game.finishEarly,
              style: AppStyles.secondaryButton,
              icon: const Icon(Icons.flag_rounded),
              label: const Text(Translations.tripleStepFinish),
            ),
          ],
        ),
      ],
    );
  }

  Widget _checklist() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
                '${_game.wordsUsed} / ${_game.words.length}',
                style: AppStyles.label.copyWith(color: GameColors.accentDark),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: _game.wordsUsed / _game.words.length,
              minHeight: 6,
              backgroundColor: GameColors.track,
              color: GameColors.accent,
            ),
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < _game.words.length; i++)
            _CheckItem(
              index: i,
              word: _game.words[i],
              checked: _game.done[i],
              onTap: () => _game.toggle(i),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Row(
        children: [
          IconButton(
            tooltip: Translations.tripleStepBackToSettings,
            onPressed: onBack,
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              minimumSize: const Size(48, 48),
            ),
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.navy),
          ),
          const Spacer(),
          TextButton(
            onPressed: onExit,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.navy,
              backgroundColor: Colors.white,
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

class _CheckItem extends StatelessWidget {
  const _CheckItem({
    required this.index,
    required this.word,
    required this.checked,
    required this.onTap,
  });

  final int index;
  final String word;
  final bool checked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      checked: checked,
      label: word,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: checked ? GameColors.accentSoft : GameColors.background,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: checked ? GameColors.accent : Colors.white,
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(
                    color: checked
                        ? GameColors.accent
                        : const Color(0xFFB9C3CC),
                    width: 2,
                  ),
                ),
                child: checked
                    ? const Icon(
                        Icons.check_rounded,
                        size: 20,
                        color: Colors.white,
                      )
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  word,
                  style: AppStyles.title.copyWith(
                    fontSize: 19,
                    color: checked ? AppColors.mutedText : AppColors.navy,
                    decoration: checked ? TextDecoration.lineThrough : null,
                    decorationColor: AppColors.mutedText,
                  ),
                ),
              ),
              if (index < 9)
                Text(
                  '${index + 1}',
                  style: AppStyles.bodySmall.copyWith(
                    fontSize: 12,
                    color: AppColors.mutedText.withValues(alpha: 0.6),
                  ),
                ),
            ],
          ),
        ),
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
      RoundStatus.completed => (
        Icons.emoji_events_rounded,
        Translations.tripleStepAllDone,
      ),
      RoundStatus.eliminated => (
        Icons.local_fire_department_rounded,
        Translations.tripleStepEliminated,
      ),
      _ => (Icons.timer_off_rounded, Translations.tripleStepTimeUp),
    };
    final multiplayerDone = game.settings.isMultiplayer && !game.hasNextPlayer;
    final standings = [...game.results]
      ..sort((a, b) => b.score.compareTo(a.score));

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
                    '${last.wordsUsed} of ${last.wordCount} words used'
                    '${last.status == RoundStatus.completed ? ' with ${last.timeLeft.inSeconds}s to spare' : ''}.',
                    textAlign: TextAlign.center,
                    style: AppStyles.body,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${Translations.tripleStepScore}: ${last.score}',
                    textAlign: TextAlign.center,
                    style: AppStyles.label.copyWith(
                      color: GameColors.accentDark,
                    ),
                  ),
                  if (multiplayerDone) ...[
                    const SizedBox(height: 20),
                    Text(
                      Translations.tripleStepStandings,
                      style: AppStyles.label,
                    ),
                    const SizedBox(height: 8),
                    for (var i = 0; i < standings.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 28,
                              child: Text(
                                i == 0 ? '🏆' : '${i + 1}.',
                                style: AppStyles.label,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                standings[i].player ?? '',
                                style: AppStyles.body,
                              ),
                            ),
                            Text(
                              '${standings[i].wordsUsed}/${standings[i].wordCount} · ${standings[i].score}',
                              style: AppStyles.bodySmall,
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
