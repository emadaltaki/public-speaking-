import 'package:flutter/material.dart';

import '../data/site_content.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';
import '../translations/translations.dart';
import 'section_container.dart';
import 'site_card.dart';
import 'responsive_card_grid.dart';

class TestimonialsSection extends StatelessWidget {
  const TestimonialsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.lightBlue,
      child: SectionContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(Translations.testimonialsHeadline, style: AppStyles.headline),
            const SizedBox(height: 12),
            Text(Translations.testimonialsIntro, style: AppStyles.bodySmall),
            const SizedBox(height: 28),
            ResponsiveCardGrid(
              children: [
                for (final item in SiteContent.testimonials)
                  SiteCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (item.isPlaceholder)
                          Text(
                            Translations.testimonialPlaceholderLabel,
                            style: AppStyles.label.copyWith(
                              color: AppColors.teal,
                            ),
                          ),
                        const SizedBox(height: 8),
                        Text(
                          '"${item.quote}"',
                          style: AppStyles.body,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item.firstName,
                          style: AppStyles.title.copyWith(fontSize: 18),
                        ),
                        if (item.role != null)
                          Text(item.role!, style: AppStyles.bodySmall),
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
