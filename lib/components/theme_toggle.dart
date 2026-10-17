import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/theme_controller.dart';
import '../translations/translations.dart';

/// Sun / moon button that switches between the light and dark themes.
class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = ThemeController.isDark;
    return IconButton(
      tooltip: dark ? Translations.themeLight : Translations.themeDark,
      onPressed: ThemeController.toggle,
      style: IconButton.styleFrom(
        foregroundColor: AppColors.navy,
        minimumSize: const Size(44, 44),
      ),
      icon: Icon(dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
    );
  }
}
