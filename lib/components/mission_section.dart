import 'package:flutter/material.dart';

import '../data/site_content.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';
import '../translations/translations.dart';
import 'section_container.dart';
import 'section_header.dart';

class MissionSection extends StatelessWidget {
  const MissionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final onNavyMuted = AppColors.lightBlue.withValues(alpha: 0.85);
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.navy, AppColors.navyDeep],
        ),
      ),
      child: SectionContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              eyebrow: Translations.eyebrowMission,
              title: Translations.missionHeadline,
              onDark: true,
            ),
            const SizedBox(height: 24),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Translations.missionP1,
                    style: AppStyles.lead.copyWith(color: onNavyMuted),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    Translations.missionP2,
                    style: AppStyles.lead.copyWith(
                      color: AppColors.onNavy,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    Translations.missionP3,
                    style: AppStyles.lead.copyWith(color: onNavyMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Text(
              Translations.missionInstead.toUpperCase(),
              style: AppStyles.eyebrow.copyWith(color: AppColors.warm),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final wrap = constraints.maxWidth < 700;
                final steps = <Widget>[];
                for (var i = 0; i < SiteContent.missionSteps.length; i++) {
                  steps.add(
                    _MissionStepChip(
                      index: i + 1,
                      label: SiteContent.missionSteps[i],
                    ),
                  );
                  if (i != SiteContent.missionSteps.length - 1) {
                    steps.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Icon(
                          wrap ? Icons.south : Icons.east,
                          color: AppColors.tealLight.withValues(alpha: 0.7),
                          size: 18,
                        ),
                      ),
                    );
                  }
                }
                return wrap
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: steps
                            .map(
                              (w) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: w,
                              ),
                            )
                            .toList(),
                      )
                    : Row(
                        children: [
                          for (final step in steps)
                            if (step is _MissionStepChip)
                              Expanded(child: step)
                            else
                              step,
                        ],
                      );
              },
            ),
            const SizedBox(height: 48),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.format_quote_rounded,
                  color: AppColors.warm,
                  size: 40,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    Translations.missionQuote,
                    style: AppStyles.title.copyWith(
                      color: AppColors.onNavy,
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                      height: 1.4,
                    ),
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

class _MissionStepChip extends StatelessWidget {
  const _MissionStepChip({required this.index, required this.label});

  final int index;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppStyles.radiusSmall),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              index.toString().padLeft(2, '0'),
              style: AppStyles.label.copyWith(
                color: AppColors.tealLight,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: AppStyles.label.copyWith(
                  color: AppColors.onNavy,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
