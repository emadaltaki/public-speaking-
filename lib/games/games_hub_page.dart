import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../components/responsive_card_grid.dart';
import '../account/account_page.dart';
import '../account/auth_storage.dart';
import '../components/language_toggle.dart';
import '../components/theme_toggle.dart';
import '../components/speech_mark_logo.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';
import '../translations/translations.dart';
import 'game_catalog.dart';
import 'game_theme.dart';
import 'widgets/game_setup.dart';

/// Floating rounded header shared by the games and account screens.
class GamesHeader extends StatelessWidget {
  const GamesHeader({super.key});

  static void _goHome(BuildContext context) {
    // Ignore repeat taps while the page is already changing.
    if (!(ModalRoute.of(context)?.isCurrent ?? false)) return;
    // On the web the home page is a separate, plain HTML page.
    if (kIsWeb) {
      openSitePage('/');
      return;
    }
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= AppStyles.tabletBreakpoint;
    final dark = AppColors.offWhite.computeLuminance() < 0.2;
    // Floating "glass" bar, matching the sign-in page.
    return RepaintBoundary(
      child: Container(
        color: AppColors.headerBand.withValues(alpha: dark ? 1 : 0.55),
        padding: EdgeInsets.fromLTRB(wide ? 24 : 12, 10, wide ? 24 : 12, 10),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1120),
            child: Container(
              height: 56,
              padding: const EdgeInsetsDirectional.only(start: 14, end: 6),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: dark ? 0.7 : 0.72),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: dark
                      ? Colors.white.withValues(alpha: 0.07)
                      : Colors.white.withValues(alpha: 0.85),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF502D14).withValues(alpha: 0.18),
                    blurRadius: 12,
                    offset: const Offset(0, 8),
                    spreadRadius: -12,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(999),
                        onTap: () => _goHome(context),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SpeechMarkLogo(size: 30),
                            const SizedBox(width: 9),
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  Translations.siteName,
                                  textDirection: TextDirection.ltr,
                                  style: AppStyles.title.copyWith(
                                    color: AppColors.navy,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AccountButton(compact: !wide),
                  if (wide) const LanguageToggle(compact: true),
                  const ThemeToggle(),
                  IconButton(
                    onPressed: () => _goHome(context),
                    tooltip: Translations.gamesBackToSite,
                    color: AppColors.navy,
                    style: IconButton.styleFrom(
                      minimumSize: const Size(40, 40),
                    ),
                    icon: const Icon(Icons.home_outlined),
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

class GamesHubPage extends StatelessWidget {
  const GamesHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= AppStyles.tabletBreakpoint;
    return Title(
      title: '${Translations.gamesTitle} | ${Translations.siteName}',
      color: AppColors.navy,
      child: Scaffold(
        backgroundColor: GameColors.background,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const GamesHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: RepaintBoundary(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1080),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          20,
                          wide ? 56 : 32,
                          20,
                          56,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Translations.gamesEyebrow.toUpperCase(),
                              style: AppStyles.eyebrow.copyWith(
                                color: GameColors.accentDark,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              Translations.gamesTitle,
                              style: AppStyles.headline.copyWith(
                                fontSize: wide ? 40 : 30,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              Translations.gamesIntro,
                              style: AppStyles.lead.copyWith(
                                fontSize: wide ? 19 : 17,
                              ),
                            ),
                            const SizedBox(height: 32),
                            // Games are for members: signed-out visitors see
                            // a sign-up prompt instead of the list.
                            SignInGate(
                              child: ResponsiveCardGrid(
                                minTileWidth: 320,
                                gap: 20,
                                children: [
                                  for (final game in GameCatalog.games)
                                    GameCard(game: game),
                                ],
                              ),
                            ),
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
}

class GameCard extends StatefulWidget {
  const GameCard({super.key, required this.game});

  final GameInfo game;

  @override
  State<GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> {
  bool _hovered = false;

  void _open() {
    final route = widget.game.route;
    if (route != null) {
      AppRoutes.open(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final game = widget.game;
    final lifted = _hovered && game.available;
    return MouseRegion(
      cursor: game.available
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: game.available ? _open : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(0, lifted ? -4 : 0, 0),
          decoration: BoxDecoration(
            color: game.available
                ? AppColors.surface
                : AppColors.surface.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: lifted
                  ? GameColors.accent
                  : AppColors.border.withValues(alpha: 0.7),
            ),
            boxShadow: lifted ? AppStyles.hoverShadow : AppStyles.softShadow,
          ),
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: game.available
                          ? GameColors.accent
                          : GameColors.accentSoft,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      game.icon,
                      color: game.available ? Colors.white : GameColors.accent,
                      size: 28,
                    ),
                  ),
                  const Spacer(),
                  if (!game.available)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: GameColors.accentSoft,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        Translations.gamesComingSoon,
                        style: AppStyles.label.copyWith(
                          color: GameColors.accentDark,
                          fontSize: 11,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Text(game.title, style: AppStyles.title),
              const SizedBox(height: 6),
              Text(
                game.tagline,
                style: AppStyles.body.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 8),
              Text(game.description, style: AppStyles.bodySmall),
              if (game.skills.isNotEmpty) ...[
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final skill in game.skills)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: GameColors.background,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          skill,
                          style: AppStyles.bodySmall.copyWith(fontSize: 13),
                        ),
                      ),
                  ],
                ),
              ],
              const Spacer(),
              if (game.available) ...[
                const SizedBox(height: 24),
                if (game.howToPlay.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Center(
                      child: HowToPlayButton(game: game, compact: true),
                    ),
                  ),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _open,
                    style: AppStyles.primaryButton.copyWith(
                      backgroundColor: WidgetStateProperty.resolveWith(
                        (states) => states.contains(WidgetState.hovered)
                            ? GameColors.accentDark
                            : GameColors.accent,
                      ),
                    ),
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: Text('${Translations.gamesPlay} ${game.title}'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
