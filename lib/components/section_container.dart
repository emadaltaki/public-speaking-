import 'package:flutter/material.dart';

import '../theme/styles.dart';

class SectionContainer extends StatelessWidget {
  const SectionContainer({
    super.key,
    required this.child,
    this.backgroundColor,
    this.padding,
  });

  final Widget child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final vertical = width < AppStyles.tabletBreakpoint
        ? AppStyles.sectionPaddingYMobile
        : AppStyles.sectionPaddingY;
    return ColoredBox(
      color: backgroundColor ?? Colors.transparent,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppStyles.maxContentWidth),
          child: Padding(
            padding: padding ??
                EdgeInsets.symmetric(
                  horizontal: AppStyles.gutter,
                  vertical: vertical,
                ),
            child: child,
          ),
        ),
      ),
    );
  }
}
