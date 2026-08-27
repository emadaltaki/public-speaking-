import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/styles.dart';
import '../translations/translations.dart';
import 'section_container.dart';
import 'site_card.dart';
import 'responsive_card_grid.dart';

class WhatToExpectSection extends StatelessWidget {
  const WhatToExpectSection({super.key});

  @override
  Widget build(BuildContext context) {
    const steps = [
      (Translations.expect1Title, Translations.expect1Body),
      (Translations.expect2Title, Translations.expect2Body),
      (Translations.expect3Title, Translations.expect3Body),
      (Translations.expect4Title, Translations.expect4Body),
    ];

    return ColoredBox(
      color: AppColors.lightBlue,
      child: SectionContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(Translations.expectHeadline, style: AppStyles.headline),
            const SizedBox(height: 24),
            ResponsiveCardGrid(
              minTileWidth: 200,
              children: [
                for (final step in steps)
                  SiteCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          step.$1,
                          style: AppStyles.label.copyWith(color: AppColors.teal),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          step.$2,
                          style: AppStyles.title.copyWith(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              Translations.expectReassure,
              style: AppStyles.title.copyWith(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
