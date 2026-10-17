import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speak_up_fearless/app.dart';
import 'support/test_helpers.dart';

void main() {
  testWidgets('a direct /games/triple-step link opens the setup screen', (
    tester,
  ) async {
    signInForTest();
    final handle = tester.ensureSemantics();
    setSurface(tester, size: const Size(1280, 900));
    tester.binding.platformDispatcher.defaultRouteNameTestValue =
        '/games/triple-step';
    await tester.pumpWidget(
      SpeakUpFearlessApp(contactHandler: RecordingContactHandler()),
    );
    await tester.pumpAndSettle();
    expect(find.text('START TRAINING'), findsOneWidget);
    handle.dispose();
  });
}
