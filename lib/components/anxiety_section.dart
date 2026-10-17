import 'package:flutter/material.dart';

import '../data/site_content.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';
import '../translations/translations.dart';
import 'responsive_card_grid.dart';
import 'section_container.dart';
import 'section_header.dart';
import 'site_card.dart';

class AnxietySection extends StatelessWidget {
  const AnxietySection({super.key});

  static const _icons = [
    Icons.favorite_border_rounded,
    Icons.psychology_alt_outlined,
    Icons.visibility_outlined,
    Icons.pause_circle_outline_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surface,
      child: SectionContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              eyebrow: Translations.eyebrowWhy,
              title: Translations.anxietyHeadline,
            ),
            const SizedBox(height: 40),
            ResponsiveCardGrid(
              children: [
                for (var i = 0; i < SiteContent.anxietyCards.length; i++)
                  SiteCard(
                    color: AppColors.offWhite,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconBadge(
                          icon: _icons[i % _icons.length],
                          size: 44,
                          background: AppColors.surface,
                        ),
                        const SizedBox(height: 18),
                        Text(
                          '“${SiteContent.anxietyCards[i]}”',
                          style: AppStyles.title.copyWith(
                            fontSize: 18,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 40),
            ClipRRect(
              borderRadius: AppStyles.cardRadius,
              child: ColoredBox(
                color: AppColors.tealSoft.withValues(alpha: 0.6),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        width: 5,
                        child: ColoredBox(color: AppColors.teal),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Translations.anxietyHuman,
                                style: AppStyles.title.copyWith(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
