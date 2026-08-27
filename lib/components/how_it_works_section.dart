import 'package:flutter/material.dart';

import '../data/site_content.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';
import '../translations/translations.dart';
import 'section_container.dart';
import 'site_card.dart';
import 'responsive_card_grid.dart';

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.offWhite,
      child: SectionContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(Translations.howHeadline, style: AppStyles.headline),
            const SizedBox(height: 28),
            ResponsiveCardGrid(
              minTileWidth: 220,
              children: [
                for (final step in SiteContent.howItWorks)
                  SiteCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          step.number,
                          style: AppStyles.headline.copyWith(
                            color: AppColors.teal,
                            fontSize: 28,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(step.title, style: AppStyles.title),
                        const SizedBox(height: 8),
                        Text(step.body, style: AppStyles.bodySmall),
                      ],
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
