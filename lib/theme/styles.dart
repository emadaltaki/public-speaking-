import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

/// Typography, spacing, radii, shadows, and the app [ThemeData].
class AppStyles {
  AppStyles._();

  static const double maxContentWidth = 1160;
  static const double sectionPaddingY = 88;
  static const double sectionPaddingYMobile = 56;
  static const double gutter = 24;
  static const double radius = 16;
  static const double radiusSmall = 10;
  static const double minTapSize = 44;
  static const double navBreakpoint = 1100;
  static const double tabletBreakpoint = 720;

  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: AppColors.cardShadow,
          blurRadius: 24,
          offset: const Offset(0, 10),
        ),
      ];

  static List<BoxShadow> get elevatedShadow => [
        BoxShadow(
          color: AppColors.navy.withValues(alpha: 0.14),
          blurRadius: 32,
          offset: const Offset(0, 14),
        ),
      ];

  static BorderRadius get cardRadius => BorderRadius.circular(radius);

  static TextStyle get display => GoogleFonts.inter(
        fontSize: 52,
        height: 1.15,
        fontWeight: FontWeight.w700,
        color: AppColors.navy,
        letterSpacing: -0.8,
      );

  static TextStyle get headline => GoogleFonts.inter(
        fontSize: 36,
        height: 1.22,
        fontWeight: FontWeight.w700,
        color: AppColors.navy,
        letterSpacing: -0.4,
      );

  static TextStyle get title => GoogleFonts.inter(
        fontSize: 22,
        height: 1.35,
        fontWeight: FontWeight.w600,
        color: AppColors.navy,
      );

  static TextStyle get body => GoogleFonts.inter(
        fontSize: 17,
        height: 1.65,
        fontWeight: FontWeight.w400,
        color: AppColors.charcoal,
      );

  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 15,
        height: 1.6,
        fontWeight: FontWeight.w400,
        color: AppColors.mutedText,
      );

  static TextStyle get navLink => GoogleFonts.inter(
        fontSize: 15,
        height: 1.2,
        fontWeight: FontWeight.w500,
        color: AppColors.onNavy,
        letterSpacing: 0.1,
      );

  static TextStyle get label => GoogleFonts.inter(
        fontSize: 14,
        height: 1.4,
        fontWeight: FontWeight.w600,
        color: AppColors.navy,
        letterSpacing: 0.2,
      );

  static ButtonStyle get primaryButton => ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(Size(48, minTapSize)),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.teal.withValues(alpha: 0.45);
          }
          if (states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.pressed)) {
            return AppColors.tealPressed;
          }
          return AppColors.teal;
        }),
        foregroundColor: const WidgetStatePropertyAll(AppColors.onTeal),
        overlayColor: WidgetStatePropertyAll(
          AppColors.onTeal.withValues(alpha: 0.08),
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusSmall)),
        ),
        elevation: const WidgetStatePropertyAll(0),
        textStyle: WidgetStatePropertyAll(
          GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      );

  static ButtonStyle get secondaryButton => ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(Size(48, minTapSize)),
        backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
        foregroundColor: const WidgetStatePropertyAll(AppColors.navy),
        overlayColor: WidgetStatePropertyAll(
          AppColors.navy.withValues(alpha: 0.06),
        ),
        side: const WidgetStatePropertyAll(
          BorderSide(color: AppColors.navy, width: 1.4),
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusSmall)),
        ),
        elevation: const WidgetStatePropertyAll(0),
        textStyle: WidgetStatePropertyAll(
          GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      );

  static ThemeData get theme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.offWhite,
      primaryColor: AppColors.navy,
      colorScheme: const ColorScheme.light(
        primary: AppColors.navy,
        secondary: AppColors.teal,
        surface: AppColors.offWhite,
        onPrimary: AppColors.onNavy,
        onSecondary: AppColors.onTeal,
        onSurface: AppColors.charcoal,
        error: AppColors.error,
      ),
    );

    final textTheme = GoogleFonts.interTextTheme(base.textTheme).apply(
      bodyColor: AppColors.charcoal,
      displayColor: AppColors.navy,
    );

    return base.copyWith(
      textTheme: textTheme,
      focusColor: AppColors.focusRing.withValues(alpha: 0.18),
      hoverColor: AppColors.teal.withValues(alpha: 0.06),
      splashColor: AppColors.teal.withValues(alpha: 0.12),
      dividerColor: AppColors.border,
      filledButtonTheme: FilledButtonThemeData(style: primaryButton),
      outlinedButtonTheme: OutlinedButtonThemeData(style: secondaryButton),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: bodySmall,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
          borderSide: const BorderSide(color: AppColors.teal, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
      ),
    );
  }
}
