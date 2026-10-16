import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speak_up_fearless/components/faq_section.dart';
import 'package:speak_up_fearless/translations/translations.dart';

import 'support/test_helpers.dart';

void main() {
  setUpAll(configureTestFonts);

  testWidgets('FAQ answers are closed until a question is opened', (
    tester,
  ) async {
    setSurface(tester, size: const Size(800, 1600));
    await tester.pumpWidget(
      wrapForTest(
        const Scaffold(body: SingleChildScrollView(child: FaqSection())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(Translations.faqQ1), findsOneWidget);
    expect(find.text(Translations.faqA1), findsNothing);

    await tester.tap(find.text(Translations.faqQ1));
    await tester.pumpAndSettle();
    expect(find.text(Translations.faqA1), findsOneWidget);

    // Non-answers and the price repeat were trimmed from the FAQ.
    expect(find.text(Translations.faqQ5), findsNothing);
    expect(find.text(Translations.faqQ8), findsNothing);

    expect(find.text(Translations.faqQ9), findsOneWidget);
    await tester.ensureVisible(find.text(Translations.faqQ9));
    await tester.tap(find.text(Translations.faqQ9));
    await tester.pumpAndSettle();
    expect(find.text(Translations.faqA9), findsOneWidget);
  });
}
