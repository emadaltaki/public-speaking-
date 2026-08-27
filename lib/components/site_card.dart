import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/styles.dart';

class SiteCard extends StatelessWidget {
  const SiteCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.elevated = false,
    this.borderColor,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final bool elevated;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: AppStyles.cardRadius,
        border: Border.all(color: borderColor ?? AppColors.border),
        boxShadow: elevated ? AppStyles.elevatedShadow : AppStyles.softShadow,
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(24),
        child: child,
      ),
    );
  }
}
