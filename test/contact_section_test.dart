import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speak_up_fearless/components/contact_section.dart';
import 'package:speak_up_fearless/translations/translations.dart';

import 'support/test_helpers.dart';

void main() {
  setUpAll(configureTestFonts);

  testWidgets('Email Us uses the community address via the handler', (
    tester,
  ) async {
    final handler = RecordingContactHandler();
    setSurface(tester, size: const Size(1000, 1400));
    await tester.pumpWidget(
      wrapForTest(
        Scaffold(
          body: SingleChildScrollView(
            child: ContactSection(
              handler: handler,
              onTalkToUs: () {
                handler.openEmailClient();
              },
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(Translations.contactEmail), findsOneWidget);
    await tester.tap(find.text(Translations.ctaEmailUs));
    await tester.pumpAndSettle();
    expect(handler.emailOpens, 1);
  });

  testWidgets('empty submit shows validation and does not claim sent', (
    tester,
  ) async {
    final handler = RecordingContactHandler();
    setSurface(tester, size: const Size(1000, 1600));
    await tester.pumpWidget(
      wrapForTest(
        Scaffold(
          body: SingleChildScrollView(child: ContactSection(handler: handler)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text(Translations.ctaSendMessage));
    await tester.tap(find.text(Translations.ctaSendMessage));
    await tester.pumpAndSettle();

    expect(find.text(Translations.contactNameRequired), findsOneWidget);
    expect(find.text(Translations.contactEmailRequired), findsOneWidget);
    expect(find.text(Translations.contactMessageRequired), findsOneWidget);
    expect(handler.lastSubmitted, isNull);
    expect(find.textContaining('message sent'), findsNothing);
  });

  testWidgets('invalid email is rejected', (tester) async {
    final handler = RecordingContactHandler();
    setSurface(tester, size: const Size(1000, 1600));
    await tester.pumpWidget(
      wrapForTest(
        Scaffold(
          body: SingleChildScrollView(child: ContactSection(handler: handler)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'Alex');
    await tester.enterText(find.byType(TextFormField).at(1), 'not-an-email');
    await tester.enterText(find.byType(TextFormField).at(2), 'Hello');
    await tester.tap(find.text(Translations.ctaSendMessage));
    await tester.pumpAndSettle();

    expect(find.text(Translations.contactEmailInvalid), findsOneWidget);
    expect(handler.lastSubmitted, isNull);
  });

  testWidgets('valid submit uses handler payload and does not say sent', (
    tester,
  ) async {
    final handler = RecordingContactHandler();
    setSurface(tester, size: const Size(1000, 1600));
    await tester.pumpWidget(
      wrapForTest(
        Scaffold(
          body: SingleChildScrollView(child: ContactSection(handler: handler)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'Alex');
    await tester.enterText(find.byType(TextFormField).at(1), 'alex@example.com');
    await tester.enterText(find.byType(TextFormField).at(2), 'I would like to join');
    await tester.tap(find.text(Translations.ctaSendMessage));
    await tester.pumpAndSettle();

    expect(handler.lastSubmitted?.name, 'Alex');
    expect(handler.lastSubmitted?.email, 'alex@example.com');
    expect(find.text(Translations.contactFormNote), findsWidgets);
    expect(find.textContaining('Message sent'), findsNothing);
    expect(find.textContaining('message sent'), findsNothing);
  });
}
