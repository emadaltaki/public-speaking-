import 'package:flutter/material.dart';

import '../data/site_content.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';
import '../translations/translations.dart';
import 'responsive_card_grid.dart';
import 'section_container.dart';
import 'section_header.dart';
import 'site_card.dart';

class SessionsSection extends StatelessWidget {
  const SessionsSection({super.key});

  static const _icons = [
    Icons.mic_none_rounded,
    Icons.bolt_rounded,
    Icons.auto_stories_outlined,
    Icons.forum_outlined,
    Icons.emoji_events_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.lightBlue,
      child: SectionContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              eyebrow: Translations.eyebrowSessions,
              title: Translations.sessionsHeadline,
              intro: Translations.sessionsIntro,
            ),
            const SizedBox(height: 40),
            ResponsiveCardGrid(
              minTileWidth: 320,
              children: [
                for (var i = 0; i < SiteContent.sessions.length; i++)
                  SiteCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconBadge(
                          icon: _icons[i % _icons.length],
                          color: i.isEven ? AppColors.teal : AppColors.warm,
                          background: i.isEven
                              ? AppColors.tealSoft
                              : AppColors.warmSoft,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          SiteContent.sessions[i].title,
                          style: AppStyles.title,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          SiteContent.sessions[i].body,
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
