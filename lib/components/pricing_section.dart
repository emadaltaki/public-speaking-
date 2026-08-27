import 'package:flutter/material.dart';

import '../data/models.dart';
import '../data/site_content.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';
import '../translations/translations.dart';
import 'primary_button.dart';
import 'secondary_button.dart';
import 'section_container.dart';
import 'site_card.dart';

class PricingSection extends StatelessWidget {
  const PricingSection({super.key, required this.onJoin, required this.onTalk});

  final VoidCallback onJoin;
  final VoidCallback onTalk;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.offWhite,
      child: SectionContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(Translations.pricingHeadline, style: AppStyles.headline),
            const SizedBox(height: 12),
            Text(Translations.pricingSupport, style: AppStyles.body),
            const SizedBox(height: 8),
            Text(Translations.pricingCurrencyNote, style: AppStyles.bodySmall),
            const SizedBox(height: 32),
            LayoutBuilder(
              builder: (context, constraints) {
                final stacked = constraints.maxWidth < 960;
                final cards = [
                  for (final pack in SiteContent.pricing)
                    _PricingCard(pack: pack, onSelect: onJoin),
                ];
                if (stacked) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final card in cards) ...[
                        card,
                        const SizedBox(height: 16),
                      ],
                    ],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: cards[0]),
                    const SizedBox(width: 16),
                    Expanded(child: cards[1]),
                    const SizedBox(width: 16),
                    Expanded(child: cards[2]),
                  ],
                );
              },
            ),
            const SizedBox(height: 28),
            _PricingSummary(),
            const SizedBox(height: 32),
            Text(Translations.pricingReassureTitle, style: AppStyles.title),
            const SizedBox(height: 8),
            Text(Translations.pricingReassureBody, style: AppStyles.body),
            const SizedBox(height: 32),
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
        ),
      ),
    );
  }
}

class _PricingCard extends StatelessWidget {
  const _PricingCard({required this.pack, required this.onSelect});

  final PricingPackage pack;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    return SiteCard(
      elevated: pack.highlighted,
      borderColor: pack.highlighted ? AppColors.teal : AppColors.border,
      color: pack.highlighted ? AppColors.lightBlue : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (pack.badge != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: pack.highlighted ? AppColors.teal : AppColors.navy,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  child: Text(
                    pack.badge!,
                    style: AppStyles.label.copyWith(
                      color: AppColors.onTeal,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            ),
          Text(pack.title, style: AppStyles.title),
          const SizedBox(height: 8),
          if (pack.wasPrice != null)
            Text(
              pack.wasPrice!,
              style: AppStyles.bodySmall.copyWith(
                decoration: TextDecoration.lineThrough,
              ),
            ),
          Text(
            pack.price,
            style: AppStyles.headline.copyWith(
              color: AppColors.teal,
              fontSize: 40,
            ),
          ),
          if (pack.saveLabel != null)
            Text(pack.saveLabel!, style: AppStyles.label.copyWith(color: AppColors.teal)),
          if (pack.perSession != null)
            Text(pack.perSession!, style: AppStyles.bodySmall),
          if (pack.meta != null)
            Text(pack.meta!, style: AppStyles.bodySmall),
          const SizedBox(height: 12),
          Text(pack.description, style: AppStyles.bodySmall),
          const SizedBox(height: 16),
          for (final feature in pack.features)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check, size: 18, color: AppColors.teal),
                  const SizedBox(width: 8),
                  Expanded(child: Text(feature, style: AppStyles.bodySmall)),
                ],
              ),
            ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(label: pack.cta, onPressed: onSelect),
          ),
        ],
      ),
    );
  }
}

class _PricingSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SiteCard(
      color: AppColors.lightBlue,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: 640,
          child: Column(
            children: [
              const Row(
                children: [
                  Expanded(child: Text(Translations.pricingTablePackage)),
                  Expanded(
                    child: Text(
                      Translations.pricingTableTotal,
                      textAlign: TextAlign.end,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      Translations.pricingTableSavings,
                      textAlign: TextAlign.end,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      Translations.pricingTablePer,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              for (final pack in SiteContent.pricing)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(pack.title, style: AppStyles.bodySmall),
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
                          style: AppStyles.bodySmall,
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
    );
  }
}
