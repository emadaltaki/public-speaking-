import 'package:flutter/material.dart';

/// Brand color tokens. Widgets should reference these instead of raw hex.
///
/// Palette: warm amber header band, warm light page, white cards, a burnt
/// orange for actions and a deep espresso brown for headings and dark panels.
/// Token names predate the palette (e.g. [teal] is now the burnt-orange
/// primary and [navy] the espresso ink).
class AppColors {
  AppColors._();

  /// Deep espresso ink: headings, dark panels, the footer.
  static const Color navy = Color(0xFF2B2118);

  /// Primary action colour (burnt orange).
  static const Color teal = Color(0xFFC2410C);

  /// Warm light page background.
  static const Color offWhite = Color(0xFFF7F5F2);

  /// Soft warm section background.
  static const Color lightBlue = Color(0xFFFFF7E6);
  static const Color charcoal = Color(0xFF292524);

  /// Warm amber band behind the header.
  static const Color headerBand = Color(0xFFFFD27F);
  static const Color headerBandSoft = Color(0xFFFFE7B8);

  static const Color onTeal = Color(0xFFFFFFFF);
  static const Color onNavy = Color(0xFFFFFFFF);
  static const Color mutedText = Color(0xFF6B6259);
  static const Color border = Color(0xFFE7E1DA);
  static const Color focusRing = Color(0xFFC2410C);
  static const Color error = Color(0xFFB42318);
  static const Color cardShadow = Color(0x142B2118);
  static const Color popularAccent = Color(0xFFC2410C);
  static const Color tealPressed = Color(0xFF9A3412);
  static const Color navyElevated = Color(0xFF3D3026);
  static const Color personAccent = Color(0xFF7C2D12);

  /// Deeper brown used for gradients and the footer.
  static const Color navyDeep = Color(0xFF1F1812);

  /// Soft peach wash used behind icons and highlights.
  static const Color tealSoft = Color(0xFFFFEDD5);

  /// Light orange that stays legible on dark backgrounds.
  static const Color tealLight = Color(0xFFFDBA74);

  /// Warm amber accent.
  static const Color warm = Color(0xFFF2A33A);
  static const Color warmSoft = Color(0xFFFFF1D1);
}
