import 'package:flutter/material.dart';

import '../data/site_content.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';
import '../translations/translations.dart';
import 'section_container.dart';
import 'site_card.dart';
import 'responsive_card_grid.dart';

class AnxietySection extends StatelessWidget {
  const AnxietySection({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.lightBlue,
      child: SectionContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(Translations.anxietyHeadline, style: AppStyles.headline),
            const SizedBox(height: 28),
            ResponsiveCardGrid(
              children: [
                for (final card in SiteContent.anxietyCards)
                  SiteCard(
                    color: Colors.white,
                    child: Text(
                      card,
                      textAlign: TextAlign.center,
                      style: AppStyles.title.copyWith(fontSize: 18),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 28),
            Text(
              Translations.anxietyHuman,
              style: AppStyles.title.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 12),
            Text(Translations.anxietyFollow, style: AppStyles.body),
          ],
        ),
      ),
    );
  }
}
