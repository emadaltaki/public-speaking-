import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:speak_up_fearless/account/avatar_store.dart';
import 'package:speak_up_fearless/account/progress_store.dart';
import 'package:speak_up_fearless/account/verify_store.dart';
import 'package:speak_up_fearless/games/widgets/game_setup.dart';

/// Runs before every test file: keep game history in memory/local storage
/// so tests never call the real backend.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  ProgressStore.instance = LocalProgressStore();
  AvatarStore.client = MockClient((_) async => http.Response('{}', 404));
  VerifyStore.client = MockClient((_) async => http.Response('{}', 404));
  HowToPlayFirstTime.enabled = false;
  HowToPlayCards.animate = false;
  await testMain();
}
