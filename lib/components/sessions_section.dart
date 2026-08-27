import 'package:flutter/material.dart';

import '../data/site_content.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';
import '../translations/translations.dart';
import 'section_container.dart';
import 'site_card.dart';
import 'responsive_card_grid.dart';

class SessionsSection extends StatelessWidget {
  const SessionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.lightBlue,
      child: SectionContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(Translations.sessionsHeadline, style: AppStyles.headline),
            const SizedBox(height: 12),
            Text(Translations.sessionsIntro, style: AppStyles.body),
            const SizedBox(height: 28),
            ResponsiveCardGrid(
              children: [
                for (final session in SiteContent.sessions)
                  SiteCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.forum_outlined, color: AppColors.teal),
                        const SizedBox(height: 12),
                        Text(session.title, style: AppStyles.title),
                        const SizedBox(height: 8),
                        Text(session.body, style: AppStyles.bodySmall),
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
