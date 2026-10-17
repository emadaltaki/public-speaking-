import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:speak_up_fearless/components/booking_section.dart';
import 'package:speak_up_fearless/contact/booking_request_sender.dart';
import 'package:speak_up_fearless/translations/translations.dart';

import 'support/test_helpers.dart';

void main() {
  setUpAll(configureTestFonts);

  Future<List<BookingRequest>> pumpBooking(
    WidgetTester tester, {
    bool succeed = true,
  }) async {
    final sent = <BookingRequest>[];
    setSurface(tester, size: const Size(1280, 2000));
    await tester.pumpWidget(
      wrapForTest(
        Scaffold(
          body: SingleChildScrollView(
            child: BookingSection(
              bookingUrl: '',
              onRequest: (request) async {
                sent.add(request);
                return succeed;
              },
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return sent;
  }

  Future<void> fillAndSend(WidgetTester tester) async {
    await tester.tap(find.byKey(const ValueKey('day-0')));
    await tester.tap(find.text('Evening'));
    await tester.enterText(find.byType(TextFormField).at(0), 'Alex');
    await tester.enterText(find.byType(TextFormField).at(1), '416-555-0100');
    await tester.enterText(find.byType(TextFormField).at(2), 'Nervous at work');
    await tester.enterText(
      find.byType(TextFormField).at(3),
      'I freeze in meetings.',
    );
    await tester.tap(find.text(Translations.bookingSubmit));
    await tester.pumpAndSettle();
  }

  testWidgets('asks for a day and time before sending', (tester) async {
    final sent = await pumpBooking(tester);
    await tester.tap(find.text(Translations.bookingSubmit));
    await tester.pumpAndSettle();
    expect(find.text(Translations.bookingChoiceRequired), findsOneWidget);
    expect(sent, isEmpty);
  });

  testWidgets('sends the request and confirms it', (tester) async {
    final sent = await pumpBooking(tester);
    await fillAndSend(tester);

    expect(sent, hasLength(1));
    expect(sent.single.name, 'Alex');
    expect(sent.single.contact, '416-555-0100');
    expect(sent.single.reason, 'Nervous at work');
    expect(sent.single.description, 'I freeze in meetings.');
    expect(
      sent.single.preferredTime,
      contains(Translations.bookingTimeEvening),
    );
    expect(find.text(Translations.bookingSentTitle), findsOneWidget);
  });

  testWidgets('explains the email fallback when sending fails', (tester) async {
    await pumpBooking(tester, succeed: false);
    await fillAndSend(tester);

    expect(find.text(Translations.bookingSentTitle), findsNothing);
    expect(find.text(Translations.bookingSendFailed), findsOneWidget);
  });

  group('FormSubmitBookingSender', () {
    const request = BookingRequest(
      name: 'Alex',
      contact: 'alex@example.com',
      preferredTime: 'Mon, Oct 19, Evening (5–9pm)',
      reason: 'Job interviews',
    );

    test('posts the request as JSON to the inbox address', () async {
      late http.Request captured;
      final sender = FormSubmitBookingSender(
        client: MockClient((req) async {
          captured = req;
          return http.Response('{"success":"true"}', 200);
        }),
      );

      expect(await sender.send(request), isTrue);
      expect(captured.url.path, endsWith(Translations.bookingInboxEmail));
      final body = jsonDecode(captured.body) as Map;
      expect(body['Name'], 'Alex');
      expect(body['Email or phone'], 'alex@example.com');
      expect(body['_subject'], contains('Evening'));
    });

    test('reports failure when the service rejects the request', () async {
      final sender = FormSubmitBookingSender(
        client: MockClient(
          (_) async => http.Response('{"success":"false"}', 200),
        ),
      );
      expect(await sender.send(request), isFalse);
    });
  });
}
