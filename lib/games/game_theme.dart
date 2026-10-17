import 'package:flutter/material.dart';

import '../theme/colors.dart';

/// Colours for the games area, matching the site's terracotta actions on a
/// warm page, in light and dark themes.
class GameColors {
  GameColors._();

  static Color get accent => AppColors.teal;
  static Color get accentDark => AppColors.tealPressed;
  static Color get accentSoft => AppColors.tealSoft;
  static Color get background => AppColors.offWhite;
  static Color get track => AppColors.border;
}
