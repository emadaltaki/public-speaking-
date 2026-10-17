import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/styles.dart';

class SiteCard extends StatefulWidget {
  const SiteCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.elevated = false,
    this.borderColor,
    this.hoverLift = true,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final bool elevated;
  final Color? borderColor;

  /// Whether the card rises slightly under the mouse pointer.
  final bool hoverLift;

  @override
  State<SiteCard> createState() => _SiteCardState();
}

class _SiteCardState extends State<SiteCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final lifted = widget.hoverLift && _hovered;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, lifted ? -4 : 0, 0),
        decoration: BoxDecoration(
          color: widget.color ?? AppColors.surface,
          borderRadius: AppStyles.cardRadius,
          border: Border.all(
            color:
                widget.borderColor ?? AppColors.border.withValues(alpha: 0.7),
          ),
          boxShadow: widget.elevated
              ? AppStyles.elevatedShadow
              : (lifted ? AppStyles.hoverShadow : AppStyles.softShadow),
        ),
        child: Padding(
          padding: widget.padding ?? const EdgeInsets.all(28),
          child: widget.child,
        ),
      ),
    );
  }
}
