import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/styles.dart';

class NavLinkButton extends StatefulWidget {
  const NavLinkButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.alignStart = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool alignStart;

  @override
  State<NavLinkButton> createState() => _NavLinkButtonState();
}

class _NavLinkButtonState extends State<NavLinkButton> {
  bool _active = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.onPressed,
      onHover: (value) => setState(() => _active = value),
      onFocusChange: (value) => setState(() => _active = value),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.onNavy,
        minimumSize: Size(44, widget.alignStart ? 48 : 44),
        alignment: widget.alignStart ? Alignment.centerLeft : Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: widget.alignStart ? 8 : 11),
        textStyle: AppStyles.navLink,
      ),
      child: Text(
        widget.label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppStyles.navLink.copyWith(
          color: AppColors.onNavy,
          decoration: _active ? TextDecoration.underline : TextDecoration.none,
          decorationColor: AppColors.teal,
          decorationThickness: 2,
        ),
      ),
    );
  }
}
