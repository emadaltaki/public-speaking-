import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../translations/translations.dart';

/// Keyboard-only shortcut past the navigation. Collapsed until it takes focus
/// so it stays available to screen readers without cluttering the header.
class SkipToContentLink extends StatefulWidget {
  const SkipToContentLink({super.key, required this.onActivate});

  final VoidCallback onActivate;

  @override
  State<SkipToContentLink> createState() => _SkipToContentLinkState();
}

class _SkipToContentLinkState extends State<SkipToContentLink> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Align(
        alignment: Alignment.centerLeft,
        widthFactor: _focused ? 1 : 0,
        child: Focus(
          onFocusChange: (value) => setState(() => _focused = value),
          child: TextButton(
            onPressed: widget.onActivate,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.onNavy,
              backgroundColor: AppColors.teal,
              minimumSize: const Size(44, 44),
              padding: const EdgeInsets.symmetric(horizontal: 14),
            ),
            child: const Text(Translations.skipToContent),
          ),
        ),
      ),
    );
  }
}
