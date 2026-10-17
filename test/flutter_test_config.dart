import 'dart:async';

import 'package:speak_up_fearless/account/progress_store.dart';
import 'package:speak_up_fearless/games/widgets/game_setup.dart';

/// Runs before every test file: keep game history in memory/local storage
/// so tests never call the real backend.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  ProgressStore.instance = LocalProgressStore();
  HowToPlayFirstTime.enabled = false;
  HowToPlayCards.animate = false;
  await testMain();
}
