import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speak_up_fearless/theme/colors.dart';
import 'package:speak_up_fearless/theme/styles.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('brand tokens match the Speak Up Fearless palette', () {
    expect(AppColors.navy, const Color(0xFF2B2118));
    expect(AppColors.teal, const Color(0xFFC2410C));
    expect(AppColors.offWhite, const Color(0xFFF7F5F2));
    expect(AppColors.headerBand, const Color(0xFFFFD27F));
    expect(AppColors.charcoal, const Color(0xFF292524));
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
