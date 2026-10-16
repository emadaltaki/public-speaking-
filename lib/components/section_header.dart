import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/styles.dart';

/// Eyebrow + headline + optional intro used at the top of every section.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.eyebrow,
    this.intro,
    this.introStyle,
    this.centered = false,
    this.onDark = false,
  });

  final String title;
  final String? eyebrow;
  final String? intro;
  final TextStyle? introStyle;
  final bool centered;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= AppStyles.tabletBreakpoint;
    final align = centered ? TextAlign.center : TextAlign.start;
    final headline = AppStyles.headline.copyWith(
      fontSize: wide ? 40 : 30,
      color: onDark ? AppColors.onNavy : AppColors.navy,
    );
    final accent = onDark ? AppColors.warm : AppColors.teal;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 760),
      child: Column(
        crossAxisAlignment: centered
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          if (eyebrow != null) ...[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 24,
                  height: 2,
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    eyebrow!.toUpperCase(),
                    style: AppStyles.eyebrow.copyWith(color: accent),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
          ],
          Text(title, style: headline, textAlign: align),
          if (intro != null) ...[
            const SizedBox(height: 16),
            Text(
              intro!,
              textAlign: align,
              style:
                  introStyle ??
                  AppStyles.lead.copyWith(
                    fontSize: wide ? 19 : 17,
                    color: onDark
                        ? AppColors.lightBlue.withValues(alpha: 0.85)
                        : AppColors.mutedText,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Rounded tinted square holding an icon, used on feature cards.
class IconBadge extends StatelessWidget {
  const IconBadge({
    super.key,
    required this.icon,
    this.color = AppColors.teal,
    this.background = AppColors.tealSoft,
    this.size = 48,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Icon(icon, color: color, size: size * 0.5),
    );
  }
}
