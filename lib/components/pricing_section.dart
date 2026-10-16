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
    required this.onTalk,
    required this.onBookIntro,
  });

  final VoidCallback onJoin;
  final VoidCallback onTalk;
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
            const SizedBox(height: 32),
            _PricingSummary(),
            const SizedBox(height: 32),
            _PricingCta(onJoin: onJoin, onTalk: onTalk),
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
  const _FeatureRow({required this.text, this.onDark = false});

  final String text;
  final bool onDark;

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
            decoration: BoxDecoration(
              color: onDark
                  ? AppColors.tealLight.withValues(alpha: 0.18)
                  : AppColors.tealSoft,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_rounded,
              size: 14,
              color: onDark ? AppColors.tealLight : AppColors.teal,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppStyles.bodySmall.copyWith(
                color: onDark ? AppColors.lightBlue : AppColors.charcoal,
              ),
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
          const SizedBox(height: 16),
          Text(
            pack.description,
            style: AppStyles.bodySmall.copyWith(color: mutedColor),
          ),
          const SizedBox(height: 20),
          Divider(
            height: 1,
            color: dark
                ? Colors.white.withValues(alpha: 0.14)
                : AppColors.border,
          ),
          const SizedBox(height: 20),
          for (final feature in pack.features)
            _FeatureRow(text: feature, onDark: dark),
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

class _PricingSummary extends StatelessWidget {
  /// Phone layout: one stacked block per package instead of a wide table.
  Widget _compact(TextStyle header) {
    Widget cell(String label, String value) => Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: header.copyWith(fontSize: 10)),
          const SizedBox(height: 2),
          Text(value, style: AppStyles.bodySmall),
        ],
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < SiteContent.pricing.length; i++) ...[
          if (i > 0) const Divider(height: 28, color: AppColors.border),
          Text(
            SiteContent.pricing[i].title,
            style: AppStyles.bodySmall.copyWith(
              color: AppColors.navy,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              cell(
                Translations.pricingTableTotal,
                SiteContent.pricing[i].price,
              ),
              cell(
                Translations.pricingTableSavings,
                SiteContent.pricing[i].savingsTable,
              ),
              cell(
                Translations.pricingTablePer,
                SiteContent.pricing[i].perSessionTable,
              ),
            ],
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final header = AppStyles.label.copyWith(
      color: AppColors.mutedText,
      fontSize: 12,
      letterSpacing: 1,
    );
    return SiteCard(
      hoverLift: false,
      color: Colors.white,
      child: LayoutBuilder(
        builder: (context, constraints) => constraints.maxWidth < 560
            ? _compact(header)
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: constraints.maxWidth < 640
                      ? 640
                      : constraints.maxWidth,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              Translations.pricingTablePackage.toUpperCase(),
                              style: header,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              Translations.pricingTableTotal.toUpperCase(),
                              textAlign: TextAlign.end,
                              style: header,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              Translations.pricingTableSavings.toUpperCase(),
                              textAlign: TextAlign.end,
                              style: header,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              Translations.pricingTablePer.toUpperCase(),
                              textAlign: TextAlign.end,
                              style: header,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 28),
                      for (final pack in SiteContent.pricing)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  pack.title,
                                  style: AppStyles.bodySmall.copyWith(
                                    color: AppColors.navy,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  pack.price,
                                  textAlign: TextAlign.end,
                                  style: AppStyles.bodySmall,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  pack.savingsTable,
                                  textAlign: TextAlign.end,
                                  style: AppStyles.bodySmall.copyWith(
                                    color:
                                        pack.savingsTable ==
                                            Translations.pricingTableDash
                                        ? AppColors.mutedText
                                        : AppColors.teal,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  pack.perSessionTable,
                                  textAlign: TextAlign.end,
                                  style: AppStyles.bodySmall,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class _PricingCta extends StatelessWidget {
  const _PricingCta({required this.onJoin, required this.onTalk});

  final VoidCallback onJoin;
  final VoidCallback onTalk;

  @override
  Widget build(BuildContext context) {
    return SiteCard(
      hoverLift: false,
      color: AppColors.lightBlue,
      borderColor: Colors.transparent,
      padding: const EdgeInsets.all(36),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 860;
          final reassure = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.favorite_rounded,
                    size: 18,
                    color: AppColors.teal,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      Translations.pricingReassureTitle,
                      style: AppStyles.label.copyWith(color: AppColors.teal),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                Translations.pricingReassureBody,
                style: AppStyles.bodySmall,
              ),
            ],
          );
          final cta = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(Translations.pricingCtaHeadline, style: AppStyles.title),
              const SizedBox(height: 8),
              Text(Translations.pricingCtaBody, style: AppStyles.body),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  PrimaryButton(label: Translations.ctaJoin, onPressed: onJoin),
                  SecondaryButton(
                    label: Translations.ctaTalkToUs,
                    onPressed: onTalk,
                  ),
                ],
              ),
            ],
          );
          if (!wide) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [reassure, const SizedBox(height: 28), cta],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: reassure),
              const SizedBox(width: 48),
              Expanded(child: cta),
            ],
          );
        },
      ),
    );
  }
}
