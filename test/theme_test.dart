import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speak_up_fearless/theme/colors.dart';
import 'package:speak_up_fearless/theme/styles.dart';
import 'package:speak_up_fearless/theme/theme_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('brand tokens match the soft palette, with a dark variant', () {
    ThemeController.dark.value = false;
    expect(AppColors.navy, const Color(0xFF2B2118));
    expect(AppColors.teal, const Color(0xFFB4583A));
    expect(AppColors.offWhite, const Color(0xFFF8F5F1));
    expect(AppColors.headerBand, const Color(0xFFF1DDBC));
    ThemeController.dark.value = true;
    expect(AppColors.offWhite, const Color(0xFF17120F));
    expect(AppColors.navy, const Color(0xFFF2E9DF));
    expect(AppStyles.theme.brightness, Brightness.dark);
    ThemeController.dark.value = false;
  });

  test('header CTA style is a large, comfortable tap target', () {
    final size = AppStyles.primaryButtonLarge.minimumSize?.resolve({});
    expect(size, isNotNull);
    expect(size!.height, greaterThanOrEqualTo(52));
    expect(AppStyles.navLink.fontSize, greaterThanOrEqualTo(17));
  });

  test('theme uses navy primary and off-white scaffold', () {
    final theme = AppStyles.theme;
    expect(theme.primaryColor, AppColors.navy);
    expect(theme.scaffoldBackgroundColor, AppColors.offWhite);
    expect(theme.colorScheme.secondary, AppColors.teal);
  });
}
