import 'package:flutter/material.dart';

import '../data/site_content.dart';
import '../translations/translations.dart';
import 'faq_accordion_item.dart';
import 'section_container.dart';
import 'section_header.dart';

class FaqSection extends StatelessWidget {
  const FaqSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: SectionContainer(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 860),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: SectionHeader(
                    eyebrow: Translations.eyebrowFaq,
                    title: Translations.faqHeadline,
                    centered: true,
                  ),
                ),
                const SizedBox(height: 40),
                for (final item in SiteContent.faqs) ...[
                  FaqAccordionItem(item: item),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
