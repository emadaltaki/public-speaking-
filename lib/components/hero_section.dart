import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/styles.dart';
import '../translations/translations.dart';
import '../data/models.dart';
import 'community_scene.dart';
import 'photo_viewer.dart';
import 'primary_button.dart';
import 'secondary_button.dart';
import 'section_container.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({
    super.key,
    required this.onJoin,
    required this.onLearnSessions,
  });

  final VoidCallback onJoin;
  final VoidCallback onLearnSessions;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final wide = width >= AppStyles.tabletBreakpoint;
    final desktop = width >= 960;
    final display = AppStyles.display.copyWith(
      fontSize: desktop ? 60 : (wide ? 48 : 38),
      letterSpacing: wide ? -1.6 : -1,
    );

    final copy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _LocationPill(),
        const SizedBox(height: 24),
        Text(Translations.heroHeadline, style: display),
        const SizedBox(height: 22),
        Text(
          Translations.heroSupport,
          style: AppStyles.lead.copyWith(fontSize: wide ? 19 : 17),
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            PrimaryButton(
              label: Translations.pricingIntroCta,
              onPressed: onJoin,
              large: true,
            ),
            SecondaryButton(
              label: Translations.ctaLearnSessions,
              onPressed: onLearnSessions,
            ),
          ],
        ),
        const SizedBox(height: 28),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Icon(
                Icons.verified_outlined,
                size: 20,
                color: AppColors.teal,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                Translations.heroTrust,
                style: AppStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.navy,
                ),
              ),
            ),
          ],
        ),
      ],
    );

    final visual = _HeroPhoto(aspectRatio: desktop ? 0.92 : 1.3);

    return DecoratedBox(
      decoration: const BoxDecoration(
        // Continues the amber header band and fades into the page.
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.headerBand,
            AppColors.headerBandSoft,
            AppColors.offWhite,
          ],
          stops: [0, 0.55, 1],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -120,
            top: -140,
            child: _Glow(
              size: 460,
              color: AppColors.teal.withValues(alpha: 0.10),
            ),
          ),
          Positioned(
            left: -160,
            bottom: -180,
            child: _Glow(
              size: 420,
              color: AppColors.warm.withValues(alpha: 0.10),
            ),
          ),
          SectionContainer(
            padding: EdgeInsets.fromLTRB(
              AppStyles.gutter,
              wide ? 88 : 48,
              AppStyles.gutter,
              wide ? 104 : 64,
            ),
            child: desktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 11, child: copy),
                      const SizedBox(width: 64),
                      Expanded(flex: 9, child: visual),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [copy, const SizedBox(height: 48), visual],
                  ),
          ),
        ],
      ),
    );
  }
}

class _LocationPill extends StatelessWidget {
  const _LocationPill();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.border),
        boxShadow: AppStyles.softShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 6, 14, 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                color: AppColors.tealSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.place_rounded,
                size: 14,
                color: AppColors.teal,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                Translations.heroLocation,
                style: AppStyles.label.copyWith(fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroPhoto extends StatelessWidget {
  const _HeroPhoto({required this.aspectRatio});

  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24, left: 12),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Transform.translate(
              offset: const Offset(16, 16),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.teal.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.zoomIn,
            child: GestureDetector(
              onTap: () => showPhotoViewer(
                context,
                items: const [
                  GalleryItem(
                    assetPath: 'assets/images/explaining-pic.jpeg',
                    caption: Translations.heroPhotoCaption,
                    alt: Translations.heroImageAlt,
                  ),
                ],
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: AppStyles.elevatedShadow,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: AspectRatio(
                    aspectRatio: aspectRatio,
                    child: Semantics(
                      label: Translations.heroImageAlt,
                      image: true,
                      child: Image.asset(
                        'assets/images/explaining-pic.jpeg',
                        fit: BoxFit.cover,
                        alignment: const Alignment(-0.45, 0),
                        excludeFromSemantics: true,
                        errorBuilder: (context, error, stackTrace) =>
                            const CommunityScene(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: -12,
            bottom: -24,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppStyles.hoverShadow,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 20, 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.warmSoft,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.groups_rounded,
                        color: AppColors.warm,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          Translations.heroBadgeTitle,
                          style: AppStyles.label.copyWith(fontSize: 14),
                        ),
                        Text(
                          Translations.heroBadgeBody,
                          style: AppStyles.bodySmall.copyWith(fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
        ),
      ),
    );
  }
}
