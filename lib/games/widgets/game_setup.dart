import 'dart:async';

import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../theme/styles.dart';
import '../../translations/translations.dart';
import '../../account/account_page.dart';
import '../../account/auth_storage.dart';
import '../game_catalog.dart';
import '../game_theme.dart';
import '../games_hub_page.dart';

/// Page frame for a game's setup screen: header bar, centred white card, and
/// a title row with the game's icon, a "How to play" button and close.
/// Every game uses it, so each gets the popup automatically.
class GameSetupScaffold extends StatelessWidget {
  const GameSetupScaffold({
    super.key,
    required this.game,
    required this.children,
    this.subtitle,
    this.onClose,
  });

  final GameInfo game;
  final List<Widget> children;
  final String? subtitle;

  /// Defaults to going back to the games list.
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= AppStyles.tabletBreakpoint;
    return Title(
      title: '${game.title} | ${Translations.siteName}',
      color: AppColors.navy,
      child: Scaffold(
        backgroundColor: GameColors.background,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const GamesHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: wide ? 48 : 20,
                ),
                child: RepaintBoundary(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: SignInGate(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: AppStyles.elevatedShadow,
                          ),
                          padding: EdgeInsets.all(wide ? 36 : 22),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              HowToPlayFirstTime(game: game),
                              _header(context),
                              const SizedBox(height: 24),
                              ...children,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: GameColors.accent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(game.icon, color: Colors.white),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    game.title,
                    style: AppStyles.title.copyWith(fontSize: 24),
                  ),
                  Text(subtitle ?? game.tagline, style: AppStyles.bodySmall),
                ],
              ),
            ),
            IconButton(
              tooltip: Translations.tripleStepBackToGames,
              onPressed:
                  onClose ??
                  () => Navigator.of(context).canPop()
                      ? Navigator.of(context).pop()
                      : Navigator.of(
                          context,
                        ).pushReplacementNamed(AppRoutes.games),
              icon: const Icon(Icons.close_rounded),
            ),
          ],
        ),
        if (game.howToPlay.isNotEmpty) ...[
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerLeft,
            child: HowToPlayButton(game: game),
          ),
        ],
      ],
    );
  }
}

/// "How to play" pill that opens the game's tips.
class HowToPlayButton extends StatelessWidget {
  const HowToPlayButton({super.key, required this.game, this.compact = false});

  final GameInfo game;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => showHowToPlay(context, game),
      style: TextButton.styleFrom(
        foregroundColor: GameColors.accentDark,
        backgroundColor: compact ? null : GameColors.accentSoft,
        shape: const StadiumBorder(),
        padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 14),
        textStyle: AppStyles.label,
      ),
      icon: const Icon(Icons.lightbulb_outline_rounded, size: 18),
      label: Text(Translations.gamesHowToPlay),
    );
  }
}

/// Shows the game's "How to play" as short cards you can swipe through.
Future<void> showHowToPlay(BuildContext context, GameInfo game) {
  return showDialog<void>(
    context: context,
    builder: (context) => Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: AppColors.surface,
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: HowToPlayCards(game: game),
      ),
    ),
  );
}

/// Opens "How to play" by itself the first time someone opens a game.
class HowToPlayFirstTime extends StatefulWidget {
  const HowToPlayFirstTime({super.key, required this.game});

  final GameInfo game;

  /// Turned off in tests so setup screens open without the popup.
  static bool enabled = true;

  @override
  State<HowToPlayFirstTime> createState() => _HowToPlayFirstTimeState();
}

class _HowToPlayFirstTimeState extends State<HowToPlayFirstTime> {
  @override
  void initState() {
    super.initState();
    final key = 'speakupfearless.howto.${widget.game.id}';
    if (!HowToPlayFirstTime.enabled ||
        widget.game.howToPlay.isEmpty ||
        readLocal(key) != null) {
      return;
    }
    writeLocal(key, '1');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) showHowToPlay(context, widget.game);
    });
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

/// One card per step, with a picture, dots and Next / Let's play buttons.
class HowToPlayCards extends StatefulWidget {
  const HowToPlayCards({super.key, required this.game});

  final GameInfo game;

  /// Turned off in tests, where endless animations never settle.
  static bool animate = true;

  @override
  State<HowToPlayCards> createState() => _HowToPlayCardsState();
}

class _HowToPlayCardsState extends State<HowToPlayCards> {
  final _pages = PageController();
  int _page = 0;

  List<HowToStep> get _steps => widget.game.howToPlay;
  bool get _last => _page == _steps.length - 1;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _go(int page) => _pages.animateToPage(
    page,
    duration: const Duration(milliseconds: 320),
    curve: Curves.easeOutCubic,
  );

  @override
  Widget build(BuildContext context) {
    final game = widget.game;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(22, 18, 8, 0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Translations.gamesHowToPlay.toUpperCase(),
                      style: AppStyles.label.copyWith(
                        color: GameColors.accent,
                        fontSize: 12,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      game.title,
                      style: AppStyles.title.copyWith(fontSize: 21),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: Translations.privacyClose,
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 300,
          child: PageView.builder(
            controller: _pages,
            itemCount: _steps.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (context, i) => _StepCard(
              game: game,
              step: _steps[i],
              index: i,
              count: _steps.length,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 4, 22, 0),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _last && game.tip != null
                ? Container(
                    key: const ValueKey('tip'),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.warmSoft,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      '💡 ${game.tip}',
                      style: AppStyles.bodySmall.copyWith(
                        color: AppColors.navy,
                      ),
                    ),
                  )
                : const SizedBox(key: ValueKey('none'), height: 0),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 14, 22, 20),
          child: Row(
            children: [
              for (var i = 0; i < _steps.length; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  margin: const EdgeInsetsDirectional.only(end: 6),
                  width: i == _page ? 22 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: i == _page ? GameColors.accent : GameColors.track,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              const Spacer(),
              if (_page > 0)
                TextButton(
                  onPressed: () => _go(_page - 1),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.mutedText,
                  ),
                  child: Text(Translations.howToBack),
                ),
              const SizedBox(width: 6),
              FilledButton(
                onPressed: _last
                    ? () => Navigator.of(context).pop()
                    : () => _go(_page + 1),
                style: FilledButton.styleFrom(
                  backgroundColor: GameColors.accent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 46),
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  shape: const StadiumBorder(),
                  textStyle: AppStyles.label.copyWith(fontSize: 15.5),
                ),
                child: Text(
                  _last ? Translations.howToLetsPlay : Translations.howToNext,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.game,
    required this.step,
    required this.index,
    required this.count,
  });

  final GameInfo game;
  final HowToStep step;
  final int index;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [GameColors.accentSoft, AppColors.warmSoft],
              ),
            ),
            child: Stack(
              children: [
                PositionedDirectional(
                  top: 12,
                  start: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      Translations.howToStepOf(index + 1, count),
                      style: AppStyles.label.copyWith(
                        fontSize: 12,
                        color: GameColors.accentDark,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: game.id == 'conductor' && index > 0
                      ? const _PitchDemo()
                      : _Pulse(
                          child: Container(
                            width: 76,
                            height: 76,
                            decoration: BoxDecoration(
                              color: GameColors.accent,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: GameColors.accent.withValues(
                                    alpha: .35,
                                  ),
                                  blurRadius: 12,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Icon(
                              step.icon,
                              color: Colors.white,
                              size: 36,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(
            step.text,
            textAlign: TextAlign.center,
            style: AppStyles.body.copyWith(
              fontSize: 17,
              height: 1.45,
              color: AppColors.navy,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Gently grows and shrinks its child so the picture feels alive.
class _Pulse extends StatefulWidget {
  const _Pulse({required this.child});

  final Widget child;

  @override
  State<_Pulse> createState() => _PulseState();
}

class _PulseState extends State<_Pulse> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  @override
  void initState() {
    super.initState();
    if (HowToPlayCards.animate) _c.repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScaleTransition(
    scale: Tween(
      begin: .94,
      end: 1.06,
    ).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut)),
    child: widget.child,
  );
}

/// The Conductor in miniature: the number changes and the voice bars follow.
class _PitchDemo extends StatefulWidget {
  const _PitchDemo();

  @override
  State<_PitchDemo> createState() => _PitchDemoState();
}

class _PitchDemoState extends State<_PitchDemo> {
  static const _levels = [2, 8, 5, 10, 1, 7];
  Timer? _timer;
  int _i = 0;

  @override
  void initState() {
    super.initState();
    if (HowToPlayCards.animate) {
      _timer = Timer.periodic(const Duration(milliseconds: 1300), (_) {
        if (mounted) setState(() => _i = (_i + 1) % _levels.length);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final level = _levels[_i];
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, a) =>
              ScaleTransition(scale: a, child: child),
          child: Text(
            '$level',
            key: ValueKey(level),
            style: AppStyles.title.copyWith(
              fontSize: 64,
              height: 1,
              color: GameColors.accentDark,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 18),
        Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var b = 1; b <= 10; b++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutBack,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  width: 8,
                  height: 8.0 + b * 6,
                  decoration: BoxDecoration(
                    color: b <= level
                        ? GameColors.accent
                        : GameColors.accent.withValues(alpha: .18),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Text fields for player names, used by multiplayer games.
class PlayerNameFields extends StatelessWidget {
  const PlayerNameFields({
    super.key,
    required this.controllers,
    this.onAdd,
    this.onRemove,
    this.maxPlayers = 8,
    this.minPlayers = 2,
  });

  final List<TextEditingController> controllers;

  /// Leave null to hide the add/remove controls.
  final VoidCallback? onAdd;
  final ValueChanged<int>? onRemove;
  final int maxPlayers;
  final int minPlayers;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < controllers.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controllers[i],
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.person_outline_rounded),
                      hintText: Translations.playerName(i + 1),
                    ),
                  ),
                ),
                if (onRemove != null && controllers.length > minPlayers)
                  IconButton(
                    tooltip: Translations.tripleStepRemovePlayer,
                    onPressed: () => onRemove!(i),
                    icon: const Icon(Icons.remove_circle_outline_rounded),
                  ),
              ],
            ),
          ),
        if (onAdd != null && controllers.length < maxPlayers)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: onAdd,
              style: TextButton.styleFrom(
                foregroundColor: GameColors.accentDark,
              ),
              icon: const Icon(Icons.add_rounded),
              label: Text(Translations.tripleStepAddPlayer),
            ),
          ),
      ],
    );
  }

  /// Names from [controllers], with "Player N" for blanks.
  static List<String> namesOf(List<TextEditingController> controllers) => [
    for (var i = 0; i < controllers.length; i++)
      controllers[i].text.trim().isEmpty
          ? Translations.playerName(i + 1)
          : controllers[i].text.trim(),
  ];
}

/// Top bar for game screens: back arrow and "× (Esc)".
class GamePlayTopBar extends StatelessWidget {
  const GamePlayTopBar({
    super.key,
    required this.onBack,
    required this.onExit,
    this.dark = false,
  });

  final VoidCallback onBack;
  final VoidCallback onExit;

  /// Light controls for dark backgrounds.
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final bg = dark ? Colors.white.withValues(alpha: 0.15) : Colors.white;
    final fg = dark ? Colors.white : AppColors.navy;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Row(
        children: [
          IconButton(
            tooltip: Translations.tripleStepBackToSettings,
            onPressed: onBack,
            style: IconButton.styleFrom(
              backgroundColor: bg,
              foregroundColor: fg,
              minimumSize: const Size(48, 48),
            ),
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          const Spacer(),
          TextButton(
            onPressed: onExit,
            style: TextButton.styleFrom(
              foregroundColor: fg,
              backgroundColor: bg,
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

/// White "Ready? Set. Go!" screen shown before a round: topic large at the
/// top, the cue in the middle, and a start button while waiting.
class GameReadyView extends StatelessWidget {
  const GameReadyView({
    super.key,
    required this.cue,
    this.topic,
    this.onStart,
    this.hint,
  });

  /// "Ready?", then "Set.", then "Go!".
  final String cue;
  final String? topic;
  final String? hint;

  /// Shown as a button while waiting; null once the countdown runs.
  final VoidCallback? onStart;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 820;
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              children: [
                if (topic != null)
                  Text(
                    topic!.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: AppStyles.display.copyWith(
                      fontSize: wide ? 52 : 30,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 1,
                      color: AppColors.navy,
                    ),
                  ),
                SizedBox(height: wide ? 96 : 64),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  transitionBuilder: (child, a) => ScaleTransition(
                    scale: Tween(begin: 0.8, end: 1.0).animate(a),
                    child: FadeTransition(opacity: a, child: child),
                  ),
                  child: Text(
                    cue,
                    key: ValueKey(cue),
                    style: AppStyles.display.copyWith(
                      fontSize: wide ? 72 : 52,
                      fontWeight: FontWeight.w600,
                      color: AppColors.mutedText.withValues(alpha: 0.55),
                    ),
                  ),
                ),
                if (hint != null) ...[
                  const SizedBox(height: 20),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Text(
                      hint!,
                      textAlign: TextAlign.center,
                      style: AppStyles.bodySmall,
                    ),
                  ),
                ],
                if (onStart != null) ...[
                  const SizedBox(height: 32),
                  FilledButton.icon(
                    onPressed: onStart,
                    style: FilledButton.styleFrom(
                      backgroundColor: GameColors.accent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(220, 56),
                      shape: const StadiumBorder(),
                      textStyle: AppStyles.label.copyWith(
                        fontSize: 16,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: Text(Translations.gamesImReady),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// The cue for a 3-second countdown: Ready? -> Set. -> Go!
  static String cueFor({required bool waiting, required int countdownNumber}) {
    if (waiting) return Translations.gamesCueReady;
    return switch (countdownNumber) {
      3 => Translations.gamesCueReady,
      2 => Translations.gamesCueSet,
      _ => Translations.gamesCueGo,
    };
  }
}

/// "Time's up" style end card shared by the games.
class GameEndCard extends StatelessWidget {
  const GameEndCard({
    super.key,
    required this.title,
    required this.message,
    required this.primaryLabel,
    required this.onPrimary,
    required this.onRetry,
    required this.onSettings,
    this.extra,
  });

  final String title;
  final String message;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final VoidCallback onRetry;
  final VoidCallback onSettings;
  final Widget? extra;

  @override
  Widget build(BuildContext context) {
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
                      child: Icon(
                        Icons.emoji_events_rounded,
                        size: 38,
                        color: GameColors.accent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: AppStyles.title.copyWith(fontSize: 24),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: AppStyles.body,
                  ),
                  if (extra != null) ...[const SizedBox(height: 16), extra!],
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: onPrimary,
                    style: FilledButton.styleFrom(
                      backgroundColor: GameColors.accent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(52),
                      shape: const StadiumBorder(),
                      textStyle: AppStyles.label.copyWith(fontSize: 16),
                    ),
                    child: Text(primaryLabel),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onRetry,
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

/// Small circular pie that empties as time runs out.
class PieCountdown extends StatelessWidget {
  const PieCountdown({super.key, required this.fraction, this.size = 200});

  final double fraction;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: _PiePainter(fraction)),
    );
  }
}

class _PiePainter extends CustomPainter {
  const _PiePainter(this.fraction);

  final double fraction;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.shortestSide / 2;
    canvas.drawCircle(c, r, Paint()..color = GameColors.track);
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: r),
      -1.5707963,
      6.2831853 * fraction.clamp(0.0, 1.0),
      true,
      Paint()..color = GameColors.accent,
    );
  }

  @override
  bool shouldRepaint(_PiePainter old) => old.fraction != fraction;
}

/// Formats a duration as mm:ss.
String gameClock(Duration d) =>
    '${d.inMinutes.toString().padLeft(2, '0')}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';
