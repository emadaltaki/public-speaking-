import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/styles.dart';
import '../translations/translations.dart';

/// Switches between English and Arabic. Shows the language you'd switch to.
class LanguageToggle extends StatelessWidget {
  const LanguageToggle({
    super.key,
    this.expanded = false,
    this.compact = false,
  });

  /// Full-width style for the mobile menu.
  final bool expanded;

  /// Short label ("ع" / "EN") for the phone header.
  final bool compact;

  static void toggle() {
    Translations.language.value = Translations.isArabic ? 'en' : 'ar';
  }

  @override
  Widget build(BuildContext context) {
    final button = TextButton.icon(
      onPressed: toggle,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.navy,
        backgroundColor: Colors.white.withValues(alpha: 0.55),
        shape: const StadiumBorder(),
        minimumSize: const Size(44, 44),
        padding: EdgeInsets.symmetric(horizontal: compact ? 10 : 14),
        alignment: expanded ? AlignmentDirectional.centerStart : null,
        textStyle: AppStyles.navLink,
      ),
      icon: const Icon(Icons.translate_rounded, size: 18),
      label: Text(
        compact
            ? Translations.languageToggleShort
            : Translations.languageToggle,
        style: AppStyles.navLink,
      ),
    );
    return Semantics(
      label: Translations.isArabic
          ? 'Switch to English'
          : 'التبديل إلى العربية',
      button: true,
      excludeSemantics: true,
      child: button,
    );
  }
}
