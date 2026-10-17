import 'package:flutter/widgets.dart';

/// Light or dark appearance. Starts from the visitor's saved choice, or
/// their device setting, and the app rebuilds when it changes.
class ThemeController {
  ThemeController._();

  /// True for the dark theme.
  static final ValueNotifier<bool> dark = ValueNotifier(_deviceIsDark());

  static bool get isDark => dark.value;

  static bool _deviceIsDark() =>
      WidgetsBinding.instance.platformDispatcher.platformBrightness ==
      Brightness.dark;

  static void toggle() => dark.value = !dark.value;

  /// Applies a saved choice ('light' / 'dark'), or follows the device.
  static void init(String? saved) {
    dark.value = saved == null ? _deviceIsDark() : saved == 'dark';
  }
}
