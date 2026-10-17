import 'package:flutter/material.dart';

/// Brand color tokens. Widgets should reference these instead of raw hex.
///
/// Palette: warm amber header band, light grey page, white cards, a strong
/// indigo for actions and deep indigo ink for headings and dark panels.
/// Token names predate the palette (e.g. [teal] is now the indigo primary).
class AppColors {
  AppColors._();

  /// Deep indigo ink: headings, dark panels, the footer.
  static const Color navy = Color(0xFF1E1B4B);

  /// Primary action colour (indigo).
  static const Color teal = Color(0xFF4F46E5);

  /// Light grey page background.
  static const Color offWhite = Color(0xFFF5F6F8);

  /// Soft warm section background.
  static const Color lightBlue = Color(0xFFFFF7E6);
  static const Color charcoal = Color(0xFF1F2937);

  /// Warm amber band behind the header.
  static const Color headerBand = Color(0xFFFFD27F);
  static const Color headerBandSoft = Color(0xFFFFE7B8);

  static const Color onTeal = Color(0xFFFFFFFF);
  static const Color onNavy = Color(0xFFFFFFFF);
  static const Color mutedText = Color(0xFF6B7280);
  static const Color border = Color(0xFFE5E7EB);
  static const Color focusRing = Color(0xFF4F46E5);
  static const Color error = Color(0xFFB42318);
  static const Color cardShadow = Color(0x141E1B4B);
  static const Color popularAccent = Color(0xFF4F46E5);
  static const Color tealPressed = Color(0xFF4338CA);
  static const Color navyElevated = Color(0xFF2E2A6B);
  static const Color personAccent = Color(0xFF3730A3);

  /// Deeper indigo used for gradients and the footer.
  static const Color navyDeep = Color(0xFF17153B);

  /// Soft indigo wash used behind icons and highlights.
  static const Color tealSoft = Color(0xFFE0E7FF);

  /// Lighter indigo that stays legible on dark backgrounds.
  static const Color tealLight = Color(0xFFA5B4FC);

  /// Warm amber accent.
  static const Color warm = Color(0xFFF2A33A);
  static const Color warmSoft = Color(0xFFFFF1D1);
}
