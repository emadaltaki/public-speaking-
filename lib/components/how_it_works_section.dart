import 'package:flutter/material.dart';

import '../data/site_content.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';
import '../translations/translations.dart';
import 'responsive_card_grid.dart';
import 'section_container.dart';
import 'section_header.dart';
import 'site_card.dart';

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  static const _icons = [
    Icons.waving_hand_outlined,
    Icons.record_voice_over_outlined,
    Icons.lightbulb_outline_rounded,
    Icons.trending_up_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.offWhite,
      child: SectionContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              eyebrow: Translations.eyebrowHow,
              title: Translations.howHeadline,
            ),
            const SizedBox(height: 40),
            ResponsiveCardGrid(
              minTileWidth: 220,
              children: [
                for (var i = 0; i < SiteContent.howItWorks.length; i++)
                  SiteCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            IconBadge(icon: _icons[i % _icons.length]),
                            const Spacer(),
                            Text(
                              SiteContent.howItWorks[i].number,
                              style: AppStyles.headline.copyWith(
                                color: AppColors.teal.withValues(alpha: 0.25),
                                fontSize: 34,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          SiteContent.howItWorks[i].title,
                          style: AppStyles.title,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          SiteContent.howItWorks[i].body,
                          style: AppStyles.bodySmall,
                        ),
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
