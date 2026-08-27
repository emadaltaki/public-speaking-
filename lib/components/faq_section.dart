import 'package:flutter/material.dart';

import '../data/site_content.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';
import '../translations/translations.dart';
import 'faq_accordion_item.dart';
import 'section_container.dart';

class FaqSection extends StatelessWidget {
  const FaqSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.offWhite,
      child: SectionContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(Translations.faqHeadline, style: AppStyles.headline),
            const SizedBox(height: 24),
            for (final item in SiteContent.faqs) ...[
              FaqAccordionItem(item: item),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}
