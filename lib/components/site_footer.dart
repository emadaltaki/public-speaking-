import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/styles.dart';
import '../translations/translations.dart';
import 'section_container.dart';
import 'speech_mark_logo.dart';

class FooterLink {
  const FooterLink({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;
}

class SiteFooter extends StatelessWidget {
  const SiteFooter({
    super.key,
    required this.links,
    required this.onEmail,
  });

  final List<FooterLink> links;
  final VoidCallback onEmail;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.navy,
      child: SectionContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                SpeechMarkLogo(size: 28),
                SizedBox(width: 10),
                Flexible(
                  child: Text(
                    Translations.siteName,
                    style: TextStyle(
                      color: AppColors.onNavy,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              Translations.footerBlurb,
              style: AppStyles.body.copyWith(color: AppColors.lightBlue),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                for (final link in links)
                  TextButton(
                    onPressed: link.onPressed,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.onNavy,
                      minimumSize: const Size(44, 44),
                    ),
                    child: Text(link.label),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: onEmail,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.teal,
                minimumSize: const Size(44, 44),
              ),
              child: const Text(Translations.contactEmail),
            ),
            const SizedBox(height: 16),
            Text(
              Translations.footerCopyright,
              style: AppStyles.bodySmall.copyWith(color: AppColors.lightBlue),
            ),
          ],
        ),
      ),
    );
  }
}
