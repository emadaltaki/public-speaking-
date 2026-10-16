import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/styles.dart';
import '../translations/translations.dart';
import 'responsive_card_grid.dart';
import 'section_container.dart';
import 'section_header.dart';
import 'site_card.dart';

class WhatToExpectSection extends StatelessWidget {
  const WhatToExpectSection({super.key});

  static const _icons = [
    Icons.mail_outline_rounded,
    Icons.chat_bubble_outline_rounded,
    Icons.videocam_outlined,
    Icons.check_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    const steps = [
      (Translations.expect1Title, Translations.expect1Body),
      (Translations.expect2Title, Translations.expect2Body),
      (Translations.expect3Title, Translations.expect3Body),
      (Translations.expect4Title, Translations.expect4Body),
    ];

    return ColoredBox(
      color: AppColors.offWhite,
      child: SectionContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              eyebrow: Translations.eyebrowExpect,
              title: Translations.expectHeadline,
            ),
            const SizedBox(height: 40),
            ResponsiveCardGrid(
              minTileWidth: 220,
              children: [
                for (var i = 0; i < steps.length; i++)
                  SiteCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconBadge(
                          icon: _icons[i],
                          color: AppColors.onNavy,
                          background: AppColors.navy,
                          size: 44,
                        ),
                        const SizedBox(height: 18),
                        Text(
                          steps[i].$1.toUpperCase(),
                          style: AppStyles.eyebrow.copyWith(fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          steps[i].$2,
                          style: AppStyles.title.copyWith(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                const Icon(
                  Icons.sentiment_satisfied_alt_rounded,
                  color: AppColors.teal,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    Translations.expectReassure,
                    style: AppStyles.title.copyWith(fontSize: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
