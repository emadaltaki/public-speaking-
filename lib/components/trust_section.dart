import 'package:flutter/material.dart';

import '../data/site_content.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';
import '../translations/translations.dart';
import 'section_container.dart';

class TrustSection extends StatelessWidget {
  const TrustSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.offWhite,
      child: SectionContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(Translations.trustHeadline, style: AppStyles.headline),
            const SizedBox(height: 24),
            for (final point in SiteContent.trustPoints)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle, color: AppColors.teal),
                    const SizedBox(width: 12),
                    Expanded(child: Text(point, style: AppStyles.body)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
