import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speak_up_fearless/theme/colors.dart';
import 'package:speak_up_fearless/theme/styles.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  test('brand tokens match the Speak Up Fearless palette', () {
    expect(AppColors.navy, const Color(0xFF173B57));
    expect(AppColors.teal, const Color(0xFF2A8C82));
    expect(AppColors.offWhite, const Color(0xFFF8F7F3));
    expect(AppColors.lightBlue, const Color(0xFFEEF5F7));
    expect(AppColors.charcoal, const Color(0xFF1F2933));
  });

  test('theme uses navy primary and off-white scaffold', () {
    final theme = AppStyles.theme;
    expect(theme.primaryColor, AppColors.navy);
    expect(theme.scaffoldBackgroundColor, AppColors.offWhite);
    expect(theme.colorScheme.secondary, AppColors.teal);
  });
}
