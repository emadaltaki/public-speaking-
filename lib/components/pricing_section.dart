import 'package:flutter/material.dart';

import '../data/models.dart';
import '../data/site_content.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';
import '../translations/translations.dart';
import 'primary_button.dart';
import 'secondary_button.dart';
import 'section_container.dart';
import 'section_header.dart';
import 'site_card.dart';

class PricingSection extends StatelessWidget {
  const PricingSection({
    super.key,
    required this.onJoin,
    required this.onBookIntro,
  });

  final VoidCallback onJoin;
  final VoidCallback onBookIntro;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.offWhite,
      child: SectionContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              eyebrow: Translations.eyebrowPricing,
              title: Translations.pricingHeadline,
              intro: Translations.pricingSupport,
            ),
            const SizedBox(height: 10),
            Text(Translations.pricingCurrencyNote, style: AppStyles.bodySmall),
            const SizedBox(height: 40),
            _FreeIntroCard(onBookIntro: onBookIntro),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, constraints) {
                final stacked = constraints.maxWidth < 960;
                final cards = [
                  for (final pack in SiteContent.pricing)
                    _PricingCard(
                      pack: pack,
                      onSelect: onJoin,
                      fillHeight: !stacked,
                    ),
                ];
                if (stacked) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final card in cards) ...[
                        card,
                        const SizedBox(height: 20),
                      ],
                    ],
                  );
                }
                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: cards[0]),
                      const SizedBox(width: 20),
                      Expanded(child: cards[1]),
                      const SizedBox(width: 20),
                      Expanded(child: cards[2]),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 3),
                  child: Icon(
                    Icons.check_circle_rounded,
                    size: 20,
                    color: AppColors.teal,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    Translations.pricingIncludes,
                    style: AppStyles.body,
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

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.color, this.textColor});

  final String label;
  final Color color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        child: Text(
          label,
          style: AppStyles.label.copyWith(
            color: textColor ?? AppColors.onTeal,
            fontSize: 11,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.only(top: 1),
            decoration: const BoxDecoration(
              color: AppColors.tealSoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              size: 14,
              color: AppColors.teal,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppStyles.bodySmall.copyWith(color: AppColors.charcoal),
            ),
          ),
        ],
      ),
    );
  }
}

class _FreeIntroCard extends StatelessWidget {
  const _FreeIntroCard({required this.onBookIntro});

  final VoidCallback onBookIntro;

  @override
  Widget build(BuildContext context) {
    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const _Pill(
          label: Translations.pricingIntroBadge,
          color: AppColors.teal,
        ),
        const SizedBox(height: 14),
        Text(Translations.pricingIntroTitle, style: AppStyles.title),
        const SizedBox(height: 8),
        Text(Translations.pricingIntroDesc, style: AppStyles.bodySmall),
        const SizedBox(height: 16),
        Wrap(
          spacing: 24,
          children: [
            for (final feature in [
              Translations.pricingIntroFeatureMeet,
              Translations.pricingIntroFeatureUnderstand,
              Translations.pricingIntroFeatureFit,
            ])
              _FeatureRow(text: feature),
          ],
        ),
      ],
    );

    final action = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          Translations.pricingIntroPrice,
          style: AppStyles.display.copyWith(
            color: AppColors.teal,
            fontSize: 52,
          ),
        ),
        Text(Translations.pricingIntroMeta, style: AppStyles.bodySmall),
        const SizedBox(height: 18),
        PrimaryButton(
          label: Translations.pricingIntroCta,
          onPressed: onBookIntro,
        ),
      ],
    );

    return SiteCard(
      hoverLift: false,
      borderColor: AppColors.teal.withValues(alpha: 0.5),
      color: Colors.white,
      padding: const EdgeInsets.all(32),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 760) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [details, const SizedBox(height: 20), action],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(flex: 3, child: details),
              Container(
                width: 1,
                height: 160,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                color: AppColors.border,
              ),
              Expanded(flex: 2, child: action),
            ],
          );
        },
      ),
    );
  }
}

class _PricingCard extends StatelessWidget {
  const _PricingCard({
    required this.pack,
    required this.onSelect,
    this.fillHeight = false,
  });

  final PricingPackage pack;
  final VoidCallback onSelect;

  /// Pushes the button to the bottom when cards sit side by side.
  final bool fillHeight;

  @override
  Widget build(BuildContext context) {
    final dark = pack.highlighted;
    final titleColor = dark ? AppColors.onNavy : AppColors.navy;
    final mutedColor = dark ? AppColors.lightBlue : AppColors.mutedText;

    return SiteCard(
      elevated: dark,
      borderColor: dark ? AppColors.navy : null,
      color: dark ? AppColors.navy : Colors.white,
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (pack.badge != null || fillHeight) ...[
            SizedBox(
              height: 26,
              child: pack.badge != null
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: _Pill(
                        label: pack.badge!,
                        color: dark ? AppColors.warm : AppColors.tealSoft,
                        textColor: dark ? AppColors.navyDeep : AppColors.teal,
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 16),
          ],
          Text(pack.title, style: AppStyles.title.copyWith(color: titleColor)),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                pack.price,
                style: AppStyles.display.copyWith(
                  color: titleColor,
                  fontSize: 48,
                  height: 1,
                ),
              ),
              if (pack.wasPrice != null) ...[
                const SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    pack.wasPrice!,
                    style: AppStyles.bodySmall.copyWith(
                      color: mutedColor,
                      fontSize: 17,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: mutedColor,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          if (pack.saveLabel != null)
            Text(
              pack.saveLabel!,
              style: AppStyles.label.copyWith(
                color: dark ? AppColors.warm : AppColors.teal,
              ),
            ),
          if (pack.perSession != null)
            Text(
              pack.perSession!,
              style: AppStyles.bodySmall.copyWith(color: mutedColor),
            ),
          if (pack.meta != null)
            Text(
              pack.meta!,
              style: AppStyles.bodySmall.copyWith(color: mutedColor),
            ),
          if (fillHeight) const Spacer(),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: dark
                ? PrimaryButton(
                    label: pack.cta,
                    onPressed: onSelect,
                    large: true,
                  )
                : SecondaryButton(label: pack.cta, onPressed: onSelect),
          ),
        ],
      ),
    );
  }
}
