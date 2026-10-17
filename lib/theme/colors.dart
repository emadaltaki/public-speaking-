import 'package:flutter/material.dart';

import 'theme_controller.dart';

/// Brand color tokens. Widgets should reference these instead of raw hex.
///
/// Palette: soft warm-sand header band, warm light page, white cards, a
/// muted terracotta for actions and deep espresso ink, chosen to be easy on
/// the eyes. Every token also has a dark-theme value; which one is used
/// follows [ThemeController]. Token names predate the palette (e.g. [teal]
/// is the terracotta primary and [navy] the ink).
class AppColors {
  AppColors._();

  static bool get _dark => ThemeController.isDark;
  static Color _pick(int light, int dark) => Color(_dark ? dark : light);

  /// Ink: headings and strong text.
  static Color get navy => _pick(0xFF2B2118, 0xFFF2E9DF);

  /// Dark panels (footer, featured cards, contact card) in both themes.
  static Color get panel => _pick(0xFF33271E, 0xFF2E241D);

  /// Primary action colour (muted terracotta).
  static Color get teal => _pick(0xFFB4583A, 0xFFE08A68);

  /// Page background.
  static Color get offWhite => _pick(0xFFF8F5F1, 0xFF17120F);

  /// Cards, inputs and other raised surfaces.
  static Color get surface => _pick(0xFFFFFFFF, 0xFF221B16);

  /// Alternate section background.
  static Color get lightBlue => _pick(0xFFFBF4EA, 0xFF1C1612);

  /// Body text.
  static Color get charcoal => _pick(0xFF332A23, 0xFFE6DCD1);

  /// Soft sand band behind the header.
  static Color get headerBand => _pick(0xFFF1DDBC, 0xFF241C16);
  static Color get headerBandSoft => _pick(0xFFF6E9D3, 0xFF1F1813);

  static Color get onTeal => _pick(0xFFFFFFFF, 0xFF1A130F);
  static Color get onNavy => const Color(0xFFFFFFFF);
  static Color get mutedText => _pick(0xFF6E645B, 0xFFB3A699);
  static Color get border => _pick(0xFFE8E0D6, 0xFF3A2F27);
  static Color get focusRing => teal;
  static Color get error => _pick(0xFFB42318, 0xFFF97066);
  static Color get tealPressed => _pick(0xFF96452C, 0xFFEFA284);
  static Color get personAccent => _pick(0xFF7C3A24, 0xFFE8A585);

  /// Deeper brown for the footer.
  static Color get navyDeep => _pick(0xFF241B15, 0xFF110D0A);

  /// Soft wash behind icons and highlights.
  static Color get tealSoft => _pick(0xFFF6E3D9, 0xFF3A2720);

  /// Light terracotta that stays legible on dark panels.
  static Color get tealLight => const Color(0xFFF0B79F);

  /// Warm amber accent.
  static Color get warm => _pick(0xFFD49A4E, 0xFFE0AE6A);
  static Color get warmSoft => _pick(0xFFF8EBD6, 0xFF35291B);
}
