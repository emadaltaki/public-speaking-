import 'package:flutter/material.dart';

import '../contact/contact_submit_handler.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';
import '../translations/translations.dart';
import 'contact_form.dart';
import 'primary_button.dart';
import 'section_container.dart';
import 'site_card.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({
    super.key,
    required this.handler,
    this.onTalkToUs,
  });

  final ContactSubmitHandler handler;
  final VoidCallback? onTalkToUs;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= AppStyles.tabletBreakpoint;

    final card = SiteCard(
      elevated: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Translations.siteName, style: AppStyles.title),
          const SizedBox(height: 8),
          SelectableText(
            Translations.contactEmail,
            style: AppStyles.body.copyWith(color: AppColors.teal),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: Translations.ctaEmailUs,
            onPressed: onTalkToUs ??
                () {
                  handler.openEmailClient(
                    subject: 'Speak Up Fearless — I would like to join',
                  );
                },
          ),
        ],
      ),
    );

    final form = SiteCard(child: ContactForm(handler: handler));

    return ColoredBox(
      color: AppColors.lightBlue,
      child: SectionContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(Translations.contactHeadline, style: AppStyles.headline),
            const SizedBox(height: 12),
            Text(Translations.contactSupport, style: AppStyles.body),
            const SizedBox(height: 28),
            if (wide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: card),
                  const SizedBox(width: 20),
                  Expanded(flex: 2, child: form),
                ],
              )
            else ...[
              card,
              const SizedBox(height: 16),
              form,
            ],
          ],
        ),
      ),
    );
  }
}
