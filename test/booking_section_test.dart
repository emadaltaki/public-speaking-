import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speak_up_fearless/components/booking_section.dart';
import 'package:speak_up_fearless/translations/translations.dart';

import 'support/test_helpers.dart';

void main() {
  setUpAll(configureTestFonts);

  Future<List<String>> pumpBooking(WidgetTester tester) async {
    final sent = <String>[];
    setSurface(tester, size: const Size(1280, 2000));
    await tester.pumpWidget(
      wrapForTest(
        Scaffold(
          body: SingleChildScrollView(
            child: BookingSection(
              bookingUrl: '',
              onRequest: (subject, body) => sent
                ..add(subject)
                ..add(body),
              onEmail: () {},
              onCall: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return sent;
  }

  testWidgets('asks for a day and time before sending', (tester) async {
    final sent = await pumpBooking(tester);
    await tester.tap(find.text(Translations.bookingSubmit));
    await tester.pumpAndSettle();
    expect(find.text(Translations.bookingChoiceRequired), findsOneWidget);
    expect(sent, isEmpty);
  });

  testWidgets('sends the chosen day, time and details', (tester) async {
    final sent = await pumpBooking(tester);
    await tester.tap(find.byType(ChoiceChip).first);
    await tester.tap(find.text(Translations.bookingTimeEvening));
    await tester.enterText(find.byType(TextFormField).at(0), 'Alex');
    await tester.enterText(find.byType(TextFormField).at(1), '416-555-0100');
    await tester.tap(find.text(Translations.bookingSubmit));
    await tester.pumpAndSettle();

    expect(sent, hasLength(2));
    expect(sent[0], contains(Translations.bookingTimeEvening));
    expect(sent[1], contains('Alex'));
    expect(sent[1], contains('416-555-0100'));
  });
}
