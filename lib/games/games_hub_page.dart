import 'package:flutter/material.dart';

import '../components/responsive_card_grid.dart';
import '../components/speech_mark_logo.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';
import '../translations/translations.dart';
import 'game_catalog.dart';
import 'game_theme.dart';
import 'widgets/game_setup.dart';

/// Slim navy header shared by the games screens.
class GamesHeader extends StatelessWidget {
  const GamesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= AppStyles.tabletBreakpoint;
    return Material(
      color: AppColors.headerBand,
      child: SizedBox(
        height: 68,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: wide ? 32 : 16),
          child: Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(AppRoutes.home, (_) => false),
                child: Row(
                  children: [
                    const SpeechMarkLogo(size: 30),
                    const SizedBox(width: 10),
                    Text(
                      Translations.siteName,
                      style: AppStyles.title.copyWith(
                        color: AppColors.navy,
                        fontSize: wide ? 19 : 17,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(AppRoutes.home, (_) => false),
                style: TextButton.styleFrom(foregroundColor: AppColors.navy),
                icon: const Icon(Icons.arrow_back_rounded, size: 18),
                label: Text(wide ? Translations.gamesBackToSite : 'Site'),
              ),
            ],
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
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1080),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, wide ? 56 : 32, 20, 56),
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
                          ResponsiveCardGrid(
                            minTileWidth: 320,
                            gap: 20,
                            children: [
                              for (final game in GameCatalog.games)
                                GameCard(game: game),
                            ],
                          ),
                        ],
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
      Navigator.of(context).pushNamed(route);
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
                ? Colors.white
                : Colors.white.withValues(alpha: 0.6),
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
