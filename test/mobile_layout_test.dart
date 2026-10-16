import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speak_up_fearless/components/site_card.dart';
import 'package:speak_up_fearless/pages/home_page.dart';
import 'package:speak_up_fearless/theme/styles.dart';
import 'package:speak_up_fearless/translations/translations.dart';

import 'support/test_helpers.dart';

void main() {
  setUpAll(configureTestFonts);

  const phone = Size(390, 9000);
  final contentWidth = phone.width - AppStyles.gutter * 2;

  Future<void> pumpPhoneHome(WidgetTester tester) async {
    setSurface(tester, size: phone);
    await tester.pumpWidget(
      wrapForTest(HomePage(contactHandler: RecordingContactHandler())),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('booking form and contact card fill the width on phones', (
    tester,
  ) async {
    await pumpPhoneHome(tester);

    final contactCard = find
        .ancestor(
          of: find.text(Translations.ctaEmailUs),
          matching: find.byType(SiteCard),
        )
        .first;
    final messageForm = find
        .ancestor(
          of: find.text(Translations.bookingSubmit),
          matching: find.byType(SiteCard),
        )
        .first;

    expect(tester.getSize(contactCard).width, contentWidth);
    expect(tester.getSize(messageForm).width, contentWidth);
  });

  testWidgets('pricing cards fill the width on phones', (tester) async {
    await pumpPhoneHome(tester);

    final card = find
        .ancestor(
          of: find.text(Translations.pricingSingleCta),
          matching: find.byType(SiteCard),
        )
        .first;

    expect(tester.getSize(card).width, contentWidth);
  });
}
