import 'package:flutter/material.dart';

import 'colors.dart';

/// Typography, spacing, radii, shadows, and the app [ThemeData].
class AppStyles {
  AppStyles._();

  static const double maxContentWidth = 1160;
  static const double sectionPaddingY = 104;
  static const double sectionPaddingYMobile = 56;
  static const double gutter = 24;
  static const double barGutterWide = 48;
  static const double barGutterNarrow = 20;
  static const double radius = 20;
  static const double radiusSmall = 12;
  static const double minTapSize = 44;
  static const double avatarSize = 64;
  static const double navBreakpoint = 1100;
  static const double tabletBreakpoint = 720;

  // Shadows use small blurs on purpose: large blurs are redrawn every frame
  // on the web and made scrolling stutter on phones.
  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: AppColors.navy.withValues(alpha: 0.07),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get hoverShadow => [
    BoxShadow(
      color: AppColors.navy.withValues(alpha: 0.12),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> get elevatedShadow => [
    BoxShadow(
      color: AppColors.navy.withValues(alpha: 0.16),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];

  static BorderRadius get cardRadius => BorderRadius.circular(radius);

  /// Inter is bundled as a variable font, so weights are requested through the
  /// `wght` axis as well as [TextStyle.fontWeight] for renderers that need it.
  static const String fontFamily = 'Inter';

  static TextStyle _inter({
    double? fontSize,
    double? height,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    final weight = fontWeight ?? FontWeight.w400;
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      height: height,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      decoration: decoration,
      fontVariations: [FontVariation('wght', weight.value.toDouble())],
    );
  }

  /// Headings use Montserrat, a geometric sans, for a bolder, more
  /// professional look next to Inter body text.
  static const String headingFontFamily = 'Montserrat';

  static TextStyle _heading({
    double? fontSize,
    double? height,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
  }) {
    final weight = fontWeight ?? FontWeight.w700;
    return TextStyle(
      fontFamily: headingFontFamily,
      fontSize: fontSize,
      height: height,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      fontVariations: [FontVariation('wght', weight.value.toDouble())],
    );
  }

  static TextStyle get display => _heading(
    fontSize: 56,
    height: 1.1,
    fontWeight: FontWeight.w800,
    color: AppColors.navy,
    letterSpacing: -1.2,
  );

  static TextStyle get headline => _heading(
    fontSize: 38,
    height: 1.18,
    fontWeight: FontWeight.w800,
    color: AppColors.navy,
    letterSpacing: -0.6,
  );

  /// Small uppercase kicker shown above section headlines.
  static TextStyle get eyebrow => _inter(
    fontSize: 13,
    height: 1.3,
    fontWeight: FontWeight.w700,
    color: AppColors.teal,
    letterSpacing: 1.6,
  );

  static TextStyle get title => _heading(
    fontSize: 21,
    height: 1.3,
    fontWeight: FontWeight.w700,
    color: AppColors.navy,
    letterSpacing: -0.2,
  );

  static TextStyle get lead => _inter(
    fontSize: 19,
    height: 1.6,
    fontWeight: FontWeight.w400,
    color: AppColors.mutedText,
  );

  static TextStyle get body => _inter(
    fontSize: 17,
    height: 1.65,
    fontWeight: FontWeight.w400,
    color: AppColors.charcoal,
  );

  static TextStyle get bodySmall => _inter(
    fontSize: 15,
    height: 1.6,
    fontWeight: FontWeight.w400,
    color: AppColors.mutedText,
  );

  static TextStyle get navLink => _inter(
    fontSize: 17,
    height: 1.2,
    fontWeight: FontWeight.w600,
    color: AppColors.navy,
    letterSpacing: 0.1,
  );

  static TextStyle get label => _inter(
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
      EdgeInsets.symmetric(horizontal: 24, vertical: 15),
    ),
    shape: const WidgetStatePropertyAll(StadiumBorder()),
    elevation: WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.hovered) ? 4 : 0,
    ),
    shadowColor: WidgetStatePropertyAll(AppColors.teal.withValues(alpha: 0.5)),
    textStyle: WidgetStatePropertyAll(
      _inter(fontWeight: FontWeight.w600, fontSize: 16),
    ),
  );

  static ButtonStyle get primaryButtonLarge => primaryButton.copyWith(
    minimumSize: const WidgetStatePropertyAll(Size(56, 52)),
    padding: const WidgetStatePropertyAll(
      EdgeInsets.symmetric(horizontal: 28, vertical: 16),
    ),
    textStyle: WidgetStatePropertyAll(
      _inter(fontWeight: FontWeight.w600, fontSize: 17),
    ),
  );

  static ButtonStyle get secondaryButton => ButtonStyle(
    minimumSize: const WidgetStatePropertyAll(Size(48, minTapSize)),
    backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
    foregroundColor: const WidgetStatePropertyAll(AppColors.navy),
    overlayColor: WidgetStatePropertyAll(
      AppColors.navy.withValues(alpha: 0.06),
    ),
    side: WidgetStateProperty.resolveWith(
      (states) => BorderSide(
        color: states.contains(WidgetState.hovered)
            ? AppColors.navy
            : AppColors.navy.withValues(alpha: 0.35),
        width: 1.4,
      ),
    ),
    padding: const WidgetStatePropertyAll(
      EdgeInsets.symmetric(horizontal: 24, vertical: 15),
    ),
    shape: const WidgetStatePropertyAll(StadiumBorder()),
    elevation: const WidgetStatePropertyAll(0),
    textStyle: WidgetStatePropertyAll(
      _inter(fontWeight: FontWeight.w600, fontSize: 16),
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

    final textTheme = base.textTheme.apply(
      fontFamily: fontFamily,
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
