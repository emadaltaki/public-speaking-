import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../theme/styles.dart';
import '../../translations/translations.dart';
import '../../account/account_page.dart';
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

/// Shows the game's "How to play" steps in a simple popup.
Future<void> showHowToPlay(BuildContext context, GameInfo game) {
  return showDialog<void>(
    context: context,
    builder: (context) => Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: AppColors.surface,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(game.icon, color: GameColors.accent),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${Translations.gamesHowToPlay}: ${game.title}',
                      style: AppStyles.title.copyWith(fontSize: 19),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              for (var i = 0; i < game.howToPlay.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: GameColors.accent,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${i + 1}',
                          style: AppStyles.label.copyWith(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            game.howToPlay[i].text,
                            style: AppStyles.body.copyWith(height: 1.45),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (game.tip != null) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.warmSoft,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    '💡 ${game.tip}',
                    style: AppStyles.bodySmall.copyWith(color: AppColors.navy),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                style: FilledButton.styleFrom(
                  backgroundColor: GameColors.accent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                  shape: const StadiumBorder(),
                  textStyle: AppStyles.label.copyWith(fontSize: 16),
                ),
                child: Text(Translations.gamesGotIt),
              ),
            ],
          ),
        ),
      ),
    ),
  );
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
