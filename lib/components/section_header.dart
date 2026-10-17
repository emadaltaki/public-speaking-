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
    final width = MediaQuery.sizeOf(context).width;
    final wide = width >= AppStyles.tabletBreakpoint;
    final align = centered ? TextAlign.center : TextAlign.start;
    final headline = AppStyles.headline.copyWith(
      fontSize: wide ? 40 : (width * 0.072).clamp(24.0, 30.0),
      color: onDark ? AppColors.onNavy : AppColors.navy,
    );
    final accent = onDark ? AppColors.warm : AppColors.teal;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 760),
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
                SizedBox(width: 10),
                Flexible(
                  child: Text(
                    eyebrow!.toUpperCase(),
                    style: AppStyles.eyebrow.copyWith(color: accent),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14),
          ],
          Text(title, style: headline, textAlign: align),
          if (intro != null) ...[
            SizedBox(height: 16),
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
    this.color,
    this.background,
    this.size = 48,
  });

  final IconData icon;

  /// Defaults to the primary colour.
  final Color? color;

  /// Defaults to the soft primary wash.
  final Color? background;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background ?? AppColors.tealSoft,
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Icon(icon, color: color ?? AppColors.teal, size: size * 0.5),
    );
  }
}
