import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/styles.dart';
import '../translations/translations.dart';
import 'community_scene.dart';
import 'primary_button.dart';
import 'secondary_button.dart';
import 'section_container.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({
    super.key,
    required this.onJoin,
    required this.onLearnSessions,
  });

  final VoidCallback onJoin;
  final VoidCallback onLearnSessions;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= AppStyles.tabletBreakpoint;
    final display = AppStyles.display.copyWith(
      fontSize: wide ? 52 : 34,
    );

    final copy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Translations.heroHeadline, style: display),
        const SizedBox(height: 18),
        Text(Translations.heroSupport, style: AppStyles.body),
        const SizedBox(height: 28),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            PrimaryButton(label: Translations.ctaJoin, onPressed: onJoin),
            SecondaryButton(
              label: Translations.ctaLearnSessions,
              onPressed: onLearnSessions,
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          Translations.heroTrust,
          style: AppStyles.bodySmall.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.navy,
          ),
        ),
      ],
    );

    final visual = ClipRRect(
      borderRadius: AppStyles.cardRadius,
      child: AspectRatio(
        aspectRatio: wide ? 1.05 : 1.25,
        child: const CommunityScene(semanticLabel: Translations.heroImageAlt),
      ),
    );

    return ColoredBox(
      color: AppColors.offWhite,
      child: SectionContainer(
        child: wide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 6, child: copy),
                  const SizedBox(width: 48),
                  Expanded(flex: 5, child: visual),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  copy,
                  const SizedBox(height: 32),
                  visual,
                ],
              ),
      ),
    );
  }
}
