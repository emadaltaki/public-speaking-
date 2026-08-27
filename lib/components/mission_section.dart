import 'package:flutter/material.dart';

import '../data/site_content.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';
import '../translations/translations.dart';
import 'section_container.dart';

class MissionSection extends StatelessWidget {
  const MissionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.navy,
      child: SectionContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Translations.missionHeadline,
              style: AppStyles.headline.copyWith(color: AppColors.onNavy),
            ),
            const SizedBox(height: 18),
            Text(
              Translations.missionP1,
              style: AppStyles.body.copyWith(color: AppColors.onNavy),
            ),
            const SizedBox(height: 12),
            Text(
              Translations.missionP2,
              style: AppStyles.body.copyWith(
                color: AppColors.onNavy,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              Translations.missionP3,
              style: AppStyles.body.copyWith(color: AppColors.onNavy),
            ),
            const SizedBox(height: 28),
            Text(
              Translations.missionInstead,
              style: AppStyles.bodySmall.copyWith(color: AppColors.lightBlue),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final wrap = constraints.maxWidth < 700;
                final steps = <Widget>[];
                for (var i = 0; i < SiteContent.missionSteps.length; i++) {
                  steps.add(
                    _MissionStepChip(label: SiteContent.missionSteps[i]),
                  );
                  if (i != SiteContent.missionSteps.length - 1) {
                    steps.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Icon(
                          wrap ? Icons.south : Icons.east,
                          color: AppColors.teal,
                          size: 20,
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
                                padding: const EdgeInsets.symmetric(vertical: 4),
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
            const SizedBox(height: 28),
            Text(
              Translations.missionQuote,
              style: AppStyles.title.copyWith(
                color: AppColors.lightBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MissionStepChip extends StatelessWidget {
  const _MissionStepChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.navyElevated,
        borderRadius: BorderRadius.circular(AppStyles.radiusSmall),
        border: Border.all(color: AppColors.teal.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppStyles.label.copyWith(color: AppColors.onNavy),
        ),
      ),
    );
  }
}
