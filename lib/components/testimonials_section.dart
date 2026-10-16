import 'package:flutter/material.dart';

import '../data/site_content.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';
import '../translations/translations.dart';
import 'responsive_card_grid.dart';
import 'section_container.dart';
import 'section_header.dart';
import 'site_card.dart';

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
            const SectionHeader(
              eyebrow: Translations.eyebrowHosts,
              title: Translations.testimonialsHeadline,
            ),
            const SizedBox(height: 40),
            ResponsiveCardGrid(
              minTileWidth: 420,
              gap: 24,
              children: [
                for (final item in SiteContent.testimonials)
                  SiteCard(
                    padding: const EdgeInsets.all(36),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.format_quote_rounded,
                          size: 40,
                          color: AppColors.teal,
                        ),
                        if (item.isPlaceholder)
                          Text(
                            Translations.testimonialPlaceholderLabel,
                            style: AppStyles.label.copyWith(
                              color: AppColors.teal,
                            ),
                          ),
                        const SizedBox(height: 12),
                        Text(
                          item.quote,
                          style: AppStyles.body.copyWith(
                            fontSize: 18,
                            height: 1.7,
                            color: AppColors.charcoal,
                          ),
                        ),
                        const SizedBox(height: 28),
                        const Divider(height: 1, color: AppColors.border),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            if (item.photoAsset != null) ...[
                              Semantics(
                                label: item.photoAlt,
                                image: true,
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [AppColors.teal, AppColors.warm],
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: Image.asset(
                                      item.photoAsset!,
                                      width: AppStyles.avatarSize,
                                      height: AppStyles.avatarSize,
                                      fit: BoxFit.cover,
                                      excludeFromSemantics: true,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                            ],
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.firstName,
                                    style: AppStyles.title.copyWith(
                                      fontSize: 18,
                                    ),
                                  ),
                                  if (item.role != null)
                                    Text(
                                      item.role!,
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
