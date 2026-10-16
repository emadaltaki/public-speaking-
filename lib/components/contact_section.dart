import 'package:flutter/material.dart';

import '../contact/contact_submit_handler.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';
import '../translations/translations.dart';
import 'contact_form.dart';
import 'primary_button.dart';
import 'section_container.dart';
import 'section_header.dart';
import 'site_card.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({
    super.key,
    required this.handler,
    this.onTalkToUs,
    this.onCallUs,
  });

  final ContactSubmitHandler handler;
  final VoidCallback? onTalkToUs;
  final VoidCallback? onCallUs;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= AppStyles.tabletBreakpoint;

    final card = SiteCard(
      elevated: true,
      hoverLift: false,
      color: AppColors.navy,
      borderColor: AppColors.navy,
      padding: EdgeInsets.all(wide ? 32 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            Translations.siteName,
            style: AppStyles.title.copyWith(color: AppColors.onNavy),
          ),
          const SizedBox(height: 24),
          const _ContactLine(
            icon: Icons.mail_outline_rounded,
            text: Translations.contactEmail,
          ),
          const SizedBox(height: 14),
          const _ContactLine(
            icon: Icons.phone_outlined,
            text: Translations.contactPhoneDisplay,
          ),
          const SizedBox(height: 14),
          const _ContactLine(
            icon: Icons.place_outlined,
            text: Translations.heroLocation,
            selectable: false,
          ),
          const SizedBox(height: 28),
          PrimaryButton(
            label: Translations.ctaEmailUs,
            onPressed:
                onTalkToUs ??
                () {
                  handler.openEmailClient(
                    subject: 'Speak Up Fearless — I would like to join',
                  );
                },
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            style: AppStyles.secondaryButton.copyWith(
              foregroundColor: const WidgetStatePropertyAll(AppColors.onNavy),
              overlayColor: WidgetStatePropertyAll(
                Colors.white.withValues(alpha: 0.08),
              ),
              side: WidgetStatePropertyAll(
                BorderSide(
                  color: Colors.white.withValues(alpha: 0.4),
                  width: 1.4,
                ),
              ),
            ),
            onPressed: onCallUs ?? () => handler.openPhoneClient(),
            child: const Text(Translations.ctaCallUs),
          ),
        ],
      ),
    );

    final form = SiteCard(
      hoverLift: false,
      padding: EdgeInsets.all(wide ? 32 : 24),
      child: ContactForm(handler: handler),
    );

    return ColoredBox(
      color: AppColors.lightBlue,
      child: SectionContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SectionHeader(
              eyebrow: Translations.eyebrowContact,
              title: Translations.contactHeadline,
              intro: Translations.contactSupport,
            ),
            const SizedBox(height: 40),
            if (wide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: card),
                  const SizedBox(width: 24),
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

class _ContactLine extends StatelessWidget {
  const _ContactLine({
    required this.icon,
    required this.text,
    this.selectable = true,
  });

  final IconData icon;
  final String text;
  final bool selectable;

  @override
  Widget build(BuildContext context) {
    final style = AppStyles.body.copyWith(
      color: AppColors.onNavy,
      fontSize: 16,
    );
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: AppColors.tealLight),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: selectable
              ? SelectableText(text, style: style)
              : Text(text, style: style),
        ),
      ],
    );
  }
}
