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
import '../widgets/game_setup.dart';
import 'autocomplete_game.dart';

class AutocompletePlayPage extends StatefulWidget {
  const AutocompletePlayPage({super.key, required this.settings, this.random});

  final AutocompleteSettings settings;
  final math.Random? random;

  @override
  State<AutocompletePlayPage> createState() => _AutocompletePlayPageState();
}

class _AutocompletePlayPageState extends State<AutocompletePlayPage>
    with SingleTickerProviderStateMixin {
  late final AutocompleteGame _game = AutocompleteGame(
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
        gameId: GameCatalog.autocomplete.id,
        playedAt: DateTime.now(),
        spoken: spoken,
        topic: topic,
      ),
    );
  }

  void _changed() {
    _recordIfOver(spoken: _game.played);
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
    if (_game.phase == AutocompletePhase.ready) {
      _game.start();
    } else {
      _game.togglePause();
    }
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 820;
    final waiting =
        _game.phase == AutocompletePhase.ready ||
        _game.phase == AutocompletePhase.countdown;

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): _exit,
        const SingleActivator(LogicalKeyboardKey.space): _space,
        const SingleActivator(LogicalKeyboardKey.arrowRight): _game.next,
        const SingleActivator(LogicalKeyboardKey.enter): _game.next,
      },
      child: Focus(
        autofocus: true,
        child: Title(
          title: '${GameCatalog.autocomplete.title} | ${Translations.siteName}',
          color: AppColors.navy,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GamePlayTopBar(onBack: _back, onExit: _exit),
                      Expanded(
                        child: waiting
                            ? GameReadyView(
                                cue: GameReadyView.cueFor(
                                  waiting:
                                      _game.phase == AutocompletePhase.ready,
                                  countdownNumber: _game.countdownNumber,
                                ),
                                hint: _game.phase == AutocompletePhase.ready
                                    ? Translations.autocompleteReadyHint
                                    : null,
                                onStart: _game.phase == AutocompletePhase.ready
                                    ? _game.start
                                    : null,
                              )
                            : _round(wide),
                      ),
                    ],
                  ),
                ),
                if (_game.isOver)
                  Positioned.fill(
                    child: GameEndCard(
                      title: Translations.autocompleteDone,
                      message: Translations.finishedSentences(
                        _game.settings.rounds,
                      ),
                      primaryLabel: Translations.autocompletePlayAgain,
                      onPrimary: _game.playAgain,
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

  Widget _round(bool wide) {
    final paused = _game.phase == AutocompletePhase.paused;
    final player = _game.currentPlayer;
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Column(
              children: [
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _Chip('${_game.round + 1} / ${_game.settings.rounds}'),
                    if (player != null)
                      _Chip(Translations.turnOf(player), strong: true),
                  ],
                ),
                const SizedBox(height: 20),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder: (child, a) => FadeTransition(
                      opacity: a,
                      child: SlideTransition(
                        position: Tween(
                          begin: const Offset(0, 0.15),
                          end: Offset.zero,
                        ).animate(a),
                        child: child,
                      ),
                    ),
                    child: Semantics(
                      key: ValueKey('phrase-${_game.round}'),
                      liveRegion: true,
                      label: _game.phrase.replaceAll('**', ''),
                      child: ExcludeSemantics(
                        child: _BoldPhrase(_game.phrase, large: wide),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: wide ? 48 : 32),
                PieCountdown(
                  fraction: _game.fractionRemaining,
                  size: wide ? 240 : 180,
                ),
                const SizedBox(height: 16),
                Text(
                  gameClock(_game.remaining),
                  style: AppStyles.display.copyWith(
                    fontSize: wide ? 44 : 36,
                    fontWeight: FontWeight.w800,
                    color: AppColors.mutedText,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(height: 20),
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
                    FilledButton.icon(
                      onPressed: _game.isOver ? null : _game.next,
                      style: AppStyles.primaryButton,
                      icon: const Icon(Icons.skip_next_rounded),
                      label: Text(Translations.autocompleteNext),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Sentence starter in uppercase with the **marked** words in bold.
class _BoldPhrase extends StatelessWidget {
  const _BoldPhrase(this.phrase, {required this.large});

  final String phrase;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final base = AppStyles.display.copyWith(
      fontSize: large ? 52 : 30,
      fontWeight: FontWeight.w400,
      height: 1.2,
      letterSpacing: 0,
      color: AppColors.navy,
    );
    final bold = base.copyWith(
      fontWeight: FontWeight.w900,
      fontVariations: const [FontVariation('wght', 900)],
      color: GameColors.accent,
    );
    final parts = phrase.toUpperCase().split('**');
    return Text.rich(
      TextSpan(
        children: [
          for (var i = 0; i < parts.length; i++)
            TextSpan(text: parts[i], style: i.isOdd ? bold : base),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.text, {this.strong = false});

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
      child: Text(
        text,
        style: AppStyles.label.copyWith(
          fontSize: 13,
          color: strong ? Colors.white : GameColors.accentDark,
        ),
      ),
    );
  }
}
