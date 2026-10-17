import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speak_up_fearless/account/account_page.dart';
import 'package:speak_up_fearless/app.dart';
import 'package:speak_up_fearless/theme/theme_controller.dart';
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

  testWidgets('switching the theme keeps you on the page you were on', (
    tester,
  ) async {
    signInForTest();
    setSurface(tester, size: const Size(390, 844));
    tester.binding.platformDispatcher.defaultRouteNameTestValue = '/games';
    await tester.pumpWidget(
      SpeakUpFearlessApp(contactHandler: RecordingContactHandler()),
    );
    await tester.pumpAndSettle();
    final nav = tester.state<NavigatorState>(find.byType(Navigator).first);
    nav.pushNamed('/account');
    await tester.pumpAndSettle();
    expect(find.byType(AccountPage), findsOneWidget);

    ThemeController.toggle();
    await tester.pumpAndSettle();
    expect(find.byType(AccountPage), findsOneWidget);
    ThemeController.dark.value = false;
    await tester.pumpAndSettle();
  });
}
