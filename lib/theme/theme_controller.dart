import 'package:flutter/widgets.dart';

/// Light or dark appearance. Starts light (the bright default) unless the
/// visitor picked dark before, and the app rebuilds when it changes.
class ThemeController {
  ThemeController._();

  /// True for the dark theme.
  static final ValueNotifier<bool> dark = ValueNotifier(false);

  static bool get isDark => dark.value;

  static void toggle() => dark.value = !dark.value;

  /// Applies a saved choice ('light' / 'dark'); light when nothing is saved.
  static void init(String? saved) {
    dark.value = saved == 'dark';
  }
}
