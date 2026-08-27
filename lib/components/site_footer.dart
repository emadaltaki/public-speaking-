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
    required this.onPhone,
  });

  final List<FooterLink> links;
  final VoidCallback onEmail;
  final VoidCallback onPhone;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.navy,
      child: SizedBox(
        width: double.infinity,
        child: SectionContainer(
          padding: const EdgeInsets.symmetric(
            horizontal: AppStyles.gutter,
            vertical: 56,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth >= AppStyles.tabletBreakpoint;
                  final brand = _FooterBrand();
                  final navigation = _FooterLinks(links: links);
                  final contact = _FooterContact(
                    onEmail: onEmail,
                    onPhone: onPhone,
                  );

                  if (!wide) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        brand,
                        const SizedBox(height: 32),
                        navigation,
                        const SizedBox(height: 32),
                        contact,
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 5, child: brand),
                      const SizedBox(width: 40),
                      Expanded(flex: 4, child: navigation),
                      const SizedBox(width: 40),
                      Expanded(flex: 3, child: contact),
                    ],
                  );
                },
              ),
              const SizedBox(height: 40),
              const Divider(height: 1, color: Color(0x33FFFFFF)),
              const SizedBox(height: 20),
              Text(
                Translations.footerCopyright,
                style: AppStyles.bodySmall.copyWith(color: AppColors.lightBlue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterBrand extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SpeechMarkLogo(size: 28),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                Translations.siteName,
                style: AppStyles.title.copyWith(color: AppColors.onNavy),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          Translations.footerBlurb,
          style: AppStyles.body.copyWith(color: AppColors.lightBlue),
        ),
      ],
    );
  }
}

class _FooterLinks extends StatelessWidget {
  const _FooterLinks({required this.links});

  final List<FooterLink> links;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Translations.footerExplore,
          style: AppStyles.label.copyWith(color: AppColors.lightBlue),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 24,
          children: [
            for (final link in links)
              SizedBox(
                width: 150,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: link.onPressed,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.onNavy,
                      minimumSize: const Size(44, 44),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                    child: Text(link.label),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _FooterContact extends StatelessWidget {
  const _FooterContact({required this.onEmail, required this.onPhone});

  final VoidCallback onEmail;
  final VoidCallback onPhone;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Translations.footerContactLabel,
          style: AppStyles.label.copyWith(color: AppColors.lightBlue),
        ),
        const SizedBox(height: 6),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: onEmail,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.teal,
              minimumSize: const Size(44, 44),
              padding: const EdgeInsets.symmetric(horizontal: 4),
            ),
            child: const Text(Translations.contactEmail),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: onPhone,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.teal,
              minimumSize: const Size(44, 44),
              padding: const EdgeInsets.symmetric(horizontal: 4),
            ),
            child: const Text(Translations.contactPhoneDisplay),
          ),
        ),
      ],
    );
  }
}
